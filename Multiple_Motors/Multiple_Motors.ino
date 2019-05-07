////////////////////////////////////
//                                //
//         Vessel Rig 2.0         //   Serial Command: 0008003.00011004
//                                //
////////////////////////////////////
//
// The motor driver is configured for 400 pulses per revolution.
// The frequency at which the motor is pulsed determines its speed.
// For 1 Revolution Per Second (RPS). 1/400 = 2500 us Pulse period. 
// 
// The motor pulse, and direction pins are interrupt driven. The frequency
// of the ISRs determined by the motor speed.
//
//  Hardware PWM is configured for approx 10.3kHz with 12 bit resolution (0 <-> 4095).
//  The duty cycles for each motor change with distension. The duty cycles are
//  updated in the corresponding interrupt routine for the motor.
// 
// !! The current PWM Frequency is only 10.3 kHz with range 0 to 4095, check on power lab whether peak values
// !! are being missed!!
//
// !! The PWM frequency can be increased, but the resolution drops (Tradeoff).

#include "Arduino.h"
#include <inttypes.h>
#include <math.h>
#include <string.h>

#define BIT1  0x1
#define BIT2  0x2
#define BIT3  0x4
#define BIT4  0x8
#define BIT5  0x10
#define BIT6  0x20
#define BIT7  0x40
#define BIT8  0x80
#define BIT9  0x100
#define BIT10 0x200
#define BIT11 0x400
#define BIT16 0x8000
#define BIT18 0x20000
#define BIT20 0x80000

#define CLKA 0b1011
#define PWM_MAX_DUTY 4095

// Motor Mode Use
#define PULSATILE 1
#define RAMP  2

// Motor Status Use
#define ON  1
#define OFF 0

// Motor analog value reset
#define FALSE 0
#define TRUE 1

/*  Overclocking the Arduino Due:
 *  Value inside CKGR_PLLAR_MULA( ), tunes the PLL. It is a mupltiplication factor.
 *  18UL = 114 MHz
 *  17UL = 108.8 MHz
 *  16UL = 100.8 MHz
 *  15UL = 96 MHz
 *  13UL = 84 MHz
 *  
 */
#define SYS_BOARD_PLLAR (CKGR_PLLAR_ONE | CKGR_PLLAR_MULA(17UL) | CKGR_PLLAR_PLLACOUNT(0x3fUL) | CKGR_PLLAR_DIVA(1UL))
#define SYS_BOARD_MCKR ( PMC_MCKR_PRES_CLK_2 | PMC_MCKR_CSS_PLLA_CLK)
        

volatile uint32_t PORTA = (volatile uint32_t)(PIOA->PIO_ODSR);
volatile uint32_t PORTB = (volatile uint32_t)(PIOB->PIO_ODSR);
volatile uint32_t PORTC = (volatile uint32_t)(PIOC->PIO_ODSR);
volatile uint32_t PORTD = (volatile uint32_t)(PIOD->PIO_ODSR);

struct Motor {
  
  // Configuration Variables
  uint32_t PWM_CHANNEL = 5;
  uint32_t PWM_PIN = 8;
  uint32_t clkAFreq = 42000000ul;
  int PUL = 31; // PA7
  int DIR = 46; // PC17
  float Calibrated_Steps = 800; // Steps per mm

  // Motor Settings Variables
  String Speed_String;
  String Distension_String;
  volatile int Status = OFF;
  volatile int Analog_Reset = FALSE;
  volatile int Status_Temp = OFF;
  volatile int Mode = PULSATILE;
  volatile int Mode_Temp = RAMP;
  volatile float Speed_Temp = 820.000;
  volatile float Speed = 820.000;
  volatile float Distension_Temp = 0;
  volatile float Distension = 0; // Read in as (mm) from serial port, Need to convert to steps
  
  // Position Related Variables
  volatile int Steps_To_Go = 0;
  volatile int Steps_To_Go_Temp = 0;
  volatile int Ramp_Step_Offset = 0;
  volatile float Current_Position = 0; 
  volatile int Ramping = 0;
  
};

const int MOTOR_NUMBER = 15;
String Distension_String;
String Received_String;
String neg = "-";
boolean data = false;
uint32_t clkAFreq = 42000000ul;
   
/* Global Motor Instantiation */
struct Motor Motor1;
struct Motor Motor2;
struct Motor Motor3;
struct Motor Motor4;

////////////////////////////////////////////////////////////////////
//                                                                //
//    Converting RPS to Timer Intervals for motor speed control   //
//                                                                //
////////////////////////////////////////////////////////////////////
  //
  //  For the motor to take a 'step' it has to be pulsed. A rising edge*
  // moves the motor one step; the more frequently we pulse it, the faster
  // the motor moves.
  //
  //  The motors are pulsed inside interrupt service routines (ISR). Each time the routine is entered, 
  // we toggle the 'PULSE' pin to the motor. For example, if there are 400 steps per revolution
  // then we need to enter the interrupt routine 800 times.
  //
  //  A key aspect to consider is the execution time of the code within the ISR.
  // The calculations below work under the assumption that the execution time of the code within
  // the interrupt routine is negligible. Where the only code inside the ISR is the pulsing and 
  // direction changes of the motor, this assumption holds true. There are two factors that place
  // a maximum speed limit upon the motors. 1, is the inherent physical speed limit of the motors
  // which appears to be greater than 6.5 RPS, and 2, the execution time of the code within the ISR.
  // 
  //  This second limiting factor occurs when the execution time of the code inside the ISR is greater 
  // than or equal to the required pulsing period. The motor will not function correclty, periodically
  // skipping steps and behaving erratically.
  //
  //  The below calculations operate under the assumption that the ISR code is negligible, and doesn't
  // consider the upper limit. The upper limit will change as the code inside the ISR increases.
  //
  // For 1 RPS. 1/400 = 2500 us Pulse period. 
  //
  // Timer Interval = {(2500/(RPS*2))*10^(-6)}*[(96*10^6)/128]
  //
  // 2500/(1*2) = 1,250 us delays in loop    --->  60 RPM, 1 RPS, 
  // 0.00125*656000 = 820
  // 
  // 2500/(2*2) = 625 us delays in loop      ---> 120 RPM, 2 RPS,
  // 0.000625*656000 = 410
  //
  // 2500/(3*2) = 416.6667 us                ---> 180 RPM, 3 RPS, 
  // 0.00041667*656000 = 273.33
  // 
  // 410/2 = 205    ---> 240 RPM             
  // 205/2 = 102.5  ---> 480 RPM
  //
 //  168 = 180 BPM = 4.889 RPS = 293.35 RPM
 //  The above calculations that convert Timer Intervals --> RPM or RPS
 // are only valid, and are still only approximate
 //
                      
// AccelStepper stepper1(AccelStepper::FULL2WIRE, 30, 31);
// Step Angle = Motor Step Angle / Micro Step
// Motor Step angle = 1.8 degrees
// Micro Step = 2 
// Then Step Angle = 1.8/2 = 0.9 degrees per step
// 360/0.9 = 400 pulses per revolution

// For 1 RPS. 1/400 = 2500 us Pulse period. 
// 2500/2 = 1,250 us delays in loop    ---> 60 RPM

/*
          Atmel SAM3X8E ARM Cortex-M3

 PIO_PER (PIO Enable Register)
 PIO_PDR (PIO Disable Register)
 PIO_OER (Output Enable Register)
 
 PIO_ODR (Output Disable Register)
 PIO_SODR (Set Output Data Register)
 PIO_CODR (Clear Output Data Register)

 PIO_ODSR (OutputData Status Register)
 PIO_OSR (Output Status Register)

 PIO_PDSR (Pin Data Status Register) (Inputs)
 
  The register PIO_PSR (PIO Status
Register) is the result of the set and clear registers and indicates whether the pin is controlled by the
corresponding peripheral or by the PIO Controller.

 If a pin is used as a general purpose I/O line (not multiplexed with an on-chip peripheral), PIO_PER and PIO_PDR
 have no effect and PIO_PSR returns 1 for the corresponding bit.

 These are the clock frequencies available to the interrupt timers /2,/8,/32,/128
 84Mhz/2 = 42.000 MHz
 84Mhz/8 = 10.500 MHz
 84Mhz/32 = 2.625 MHz
 84Mhz/128 = 656.250 KHz

 42Mhz/44.1Khz = 952.38
 10.5Mhz/44.1Khz = 238.09 
 2.625Hmz/44.1Khz = 59.5
 656Khz/44.1Khz = 14.88 // 131200 / 656000 = .2 (.2 seconds)
 84Mhz/44.1Khz = 1904 instructions per tick

*/

// Serial Command:   // 0000011.00011002

volatile int S = 0;

int c2i(char character)
{
  return (character - 48); // Where 48 is ASCII offset
}

void reg_print(RwReg *reg, uint32_t pin)
{
  Serial.println((*reg) &= (pin));
}

//////////////////////////////////
//                              //
//    Motor Function Control    //
//                              //
//////////////////////////////////
  //
  //  To Test:
  //  --> 
  //
  //

void Pulse_Motor(Motor *motor, RwReg *PUL_reg, uint32_t PUL_pin, RwReg *DIR_reg, uint32_t DIR_pin)
{ // 0008001.00011004
  
  if ( abs(motor->Steps_To_Go > 0) && (motor->Status == ON)) 
  {
    if ( (int)((*DIR_reg)& DIR_pin) ) // Negative Direction
    {
      if( (motor->Current_Position - 1) >= 0)
      {
        motor->Current_Position--;
      }
    }
    else
    {
      motor->Current_Position++;  // Positive Direction
    }
    
    if(motor->Steps_To_Go > 0)  // Positive Direction
    {
      (motor->Steps_To_Go)--;
      (*PUL_reg) ^= PUL_pin;
    }
    
    if(motor->Steps_To_Go < 0 && ((motor->Current_Position - 1) <= 0 )) // Negative Direction
    {
      if( (motor->Steps_To_Go + 1) >= 0)
      {
        (motor->Steps_To_Go)++;
        (*PUL_reg) ^= PUL_pin;
      }
    }
  }

////////////////////
//                //
//    PULSATILE   //
//                //
////////////////////
//
// change steps_to_go so that there is no direction check
// 
//
  if (( motor->Steps_To_Go == 0) && (motor -> Status == ON) && (motor -> Mode == PULSATILE))
  {
    
    if ((int)((*DIR_reg)& DIR_pin)) // PULSATILE, IF ANALOG VALUE COUNTING DOWNWARDS
    {
      motor->Speed = motor->Speed_Temp;
      motor->Mode  = motor->Mode_Temp; // ONLY UPDATE MODE IF CURRENT POSITION IS ZERO AND DIRECTION (-)
      motor->Status = motor->Status_Temp;

      if (motor->Mode == PULSATILE && motor->Status == ON) // MODE: PULSATILE TO PULSATILE
      {
        motor->Distension = motor-> Distension_Temp;
        motor->Steps_To_Go = motor->Distension;
        (*DIR_reg) ^= DIR_pin; // ONLY CHANGE DIRECTION PIN IF CONTINUING PULSATILE
      }
      else if(motor->Mode == PULSATILE && motor->Status == OFF)
      {
        if( motor->Analog_Reset == TRUE) 
        {
          motor->Current_Position = 0;
          motor->Analog_Reset = FALSE;
        }
      }

      if (motor->Mode == RAMP && motor->Status == ON) // MODE: PULSATILE TO RAMP
      {
        motor->Mode  = motor->Mode_Temp; // ONLY UPDATE MODE IF CURRENT POSITION IS ZERO AND DIRECTION (-)
        
        if (motor->Distension < 0)
        {
          (*DIR_reg) |= DIR_pin ; // DIR = 1
        }
        else
        {
          (*DIR_reg) &= ~(DIR_pin); // DIR = 0
        }
      }
    }
    else // PULSATILE, IF ANALOG VALUE COUNTING UPWARDS
    {
      motor->Steps_To_Go = motor->Distension;
      (*DIR_reg) ^= DIR_pin;
    }
  }

////////////////////
//                //
//      RAMP      //
//                //
////////////////////
// eg.      Pulsatile: 0000011.00011002
//               Ramp: 0000011.00012002
  else if (( motor->Steps_To_Go == 0) && (motor -> Status == ON) && (motor -> Mode == RAMP))
  {
        motor->Mode  = motor->Mode_Temp; // ONLY UPDATE MODE IF CURRENT POSITION IS ZERO AND DIRECTION (-)
        motor->Status = motor->Status_Temp;
        
        if( motor->Mode == PULSATILE && motor->Status == ON)
        {
           motor->Speed = motor->Speed_Temp;
              (*DIR_reg) |= DIR_pin ; // DIR = 1
        }
        
        if ( (motor->Ramping > 0) && (motor->Mode == RAMP))
        {

          motor->Distension = motor->Distension_Temp;
          motor->Steps_To_Go = motor->Distension;
          motor->Speed = motor->Speed_Temp;

          if (motor->Ramping == 1)
            {
              (*DIR_reg) |= DIR_pin ; // DIR = 1
            }
          else if (motor->Ramping == 2)
          {
            (*DIR_reg) &= ~(DIR_pin); // DIR = 0
          }
          motor->Ramping = 0;
        }
        
  }
}

void Receive_Serial_Data()
{
  while(Serial.available())
  {
    Received_String = Serial.readString();
    data = true;
  }
  
  if( data == true)
  {
    Execute_Received_Commands();
    data = false;
  }
}

float Calculate_Timer_Interval(float RPS)
{
  // For 1 RPS. 1/400 = 2500 us Pulse period. 
  // Timer Interval = {(2500/(RPS*2))*10^(-6)}*[(84*10^6)/128]
  return (round(10000*(((2500.0/((1*RPS)*2.0))*0.000001)*818250.0/10000))); // For 16UL(795453.0), 
}

////////////////////////////////////////
//
//    Pulsatile: 0008000.50011004
//         Ramp: 0004000.50012004
//               00000011.5312001
//               0000.83.19801002
//
//////////////////////////////////
//                              //
//    READ MOTOR PARAMETERS     //
//                              //
//////////////////////////////////
void Read_Motor_Parameters(Motor *motor, RwReg *PUL_reg, uint32_t PUL_pin, RwReg *DIR_reg, uint32_t DIR_pin)    
{                                          
  motor -> Analog_Reset = c2i(Received_String.charAt(0));
  if( motor-> Analog_Reset == FALSE )
  {
    motor -> Status_Temp = c2i(Received_String.charAt(11));
    motor -> Mode_Temp = c2i(Received_String.charAt(12));
    motor -> Speed_String = Received_String.substring(6,11);
    motor -> Speed_Temp = Calculate_Timer_Interval(motor -> Speed_String.toFloat());
  
    Distension_String = Received_String.substring(1,6);
    // if the string has a '-' in it...
    if( motor->Mode_Temp == RAMP)
    {
      if( strstr(Distension_String.c_str(),neg.c_str()))   // If negative Distension 
      {
        // replace '-' with '0', because toFloat() terminates if it see's non-numeric chars.
        Distension_String.replace('-','0');  
        motor -> Distension_Temp = (motor->Calibrated_Steps)*(Distension_String.toFloat());
        motor->Ramping = 1;
      }
      
      else      // if positive Distension
      {
        motor->Ramping = 2;
  
        motor -> Distension_Temp = (motor->Calibrated_Steps)*(Distension_String.toFloat()); 
        // Direction change happens in ISR
      }
    }
    
    else
    {
      motor -> Distension_Temp = (motor->Calibrated_Steps)*(abs(Distension_String.toFloat())); 
    }
  
    if(motor->Status == OFF && motor->Status_Temp == ON)
    {
      motor->Status = ON;
    }
  }
}

void Execute_Received_Commands()
{
   int a = c2i(Received_String.charAt(MOTOR_NUMBER));

   switch(a)
   {
    case 1:
      Read_Motor_Parameters(&Motor1, &(PIOA->PIO_ODSR), BIT8, &(PIOA->PIO_ODSR), BIT10);
      break;
      
    case 2:
      Read_Motor_Parameters(&Motor2, &(PIOD->PIO_ODSR), BIT1, &(PIOC->PIO_ODSR), BIT4);
      break;

    case 3:
      Read_Motor_Parameters(&Motor3, &(PIOD->PIO_ODSR), BIT3, &(PIOA->PIO_ODSR), BIT20);
      break;

    case 4:
      Read_Motor_Parameters(&Motor4, &(PIOD->PIO_ODSR), BIT7, &(PIOD->PIO_ODSR), BIT11);
      break;
   }
   Serial.println(Received_String);
}

////////////////////////////////////
//                                //
//   Pin Setup & Configuration    // 
//                                //
////////////////////////////////////

            void Start_Timer(Tc *tc, uint32_t channel, IRQn_Type irq, uint32_t frequency) 
            {
              /* disable write protection for pmc registers */
              pmc_set_writeprotect(false);
              
              /* Enable Peripheral clocks for individual Timers */
              pmc_enable_periph_clk((uint32_t)irq);
            
              /*    TIMER_CLOCK4 Clock selected: internal MCK/128 clock signal (from PMC)
               *    Wave select with Rise counter (RC)
               */
              TC_Configure(tc, channel, TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC | TC_CMR_TCCLKS_TIMER_CLOCK4);
            
              /* Set counter max for specific timer channel */
              TC_SetRC(tc, channel, frequency);
              TC_Start(tc, channel);
            
              /* IER = interrupt enable register  */
              tc->TC_CHANNEL[channel].TC_IER=TC_IER_CPCS; 
              /* IDR = interrupt disable register */  
              tc->TC_CHANNEL[channel].TC_IDR=~TC_IER_CPCS;  
              
              /* Enable the interrupt in the nested vector interrupt controller */
              /* TC4_IRQn where 4 is the: timer number * timer channels (3) + the channel number (=(1*3)+1) for timer1 channel1 */
              NVIC_EnableIRQ(irq);
            }

            void PWM_Config(Motor *motor)
            {
            
                PIO_Configure(g_APinDescription[motor->PWM_PIN].pPort,
                              PIO_PERIPH_B,
                              g_APinDescription[motor->PWM_PIN].ulPin,
                              g_APinDescription[motor->PWM_PIN].ulPinConfiguration);
            
                pmc_enable_periph_clk(PWM_INTERFACE_ID);
                
                PWMC_ConfigureClocks(motor->clkAFreq, 0, VARIANT_MCK); //set to frequency @450hz @12bits
                PWMC_ConfigureChannel(PWM_INTERFACE, motor->PWM_CHANNEL, PWM_CMR_CPRE_CLKA, 0, 0);
                PWMC_SetPeriod(PWM_INTERFACE, motor->PWM_CHANNEL, PWM_MAX_DUTY); 
                PWMC_EnableChannel(PWM_INTERFACE, motor->PWM_CHANNEL);
                PWMC_SetDutyCycle(PWM_INTERFACE, motor->PWM_CHANNEL, 2048);
            }

            void setup() 
            {

              /* Set FWS according to SYS_BOARD_MCKR configuration */
              EFC0->EEFC_FMR = EEFC_FMR_FWS(4); //4 waitstate flash access
              EFC1->EEFC_FMR = EEFC_FMR_FWS(4);
              
              /* Initialize PLLA to 114MHz */
              PMC->CKGR_PLLAR = SYS_BOARD_PLLAR;
              while (!(PMC->PMC_SR & PMC_SR_LOCKA)) {}
              
              PMC->PMC_MCKR = SYS_BOARD_MCKR;
              while (!(PMC->PMC_SR & PMC_SR_MCKRDY)) {}

              SystemCoreClockUpdate();
              
               Motor2.DIR = 35; // PC3
               Motor2.PUL = 25; // PD0
               Motor2.PWM_PIN = 6; // PC24
               Motor2.PWM_CHANNEL = 7; // PWML 7
               
               Motor3.DIR = 42; // PC19
               Motor3.PUL = 27; // PD2
               Motor3.PWM_PIN = 7; // PC23
               Motor3.PWM_CHANNEL = 6; // PWML 6
            
               Motor4.DIR = 32; // PD10
               Motor4.PUL = 29; // PD6
               Motor4.PWM_PIN = 9;  //PC21
               Motor4.PWM_CHANNEL = 4; // PWML 4
            
               analogWriteResolution(12);
               
               pinMode (Motor1.PUL, OUTPUT); // Latency isn't an issue during setup, so Arduino functions are fine here
               pinMode (Motor1.DIR, OUTPUT); 
               pinMode (Motor2.PUL, OUTPUT); 
               pinMode (Motor2.DIR, OUTPUT); 
               pinMode (Motor3.PUL, OUTPUT); 
               pinMode (Motor3.DIR, OUTPUT); 
               pinMode (Motor4.PUL, OUTPUT); 
               pinMode (Motor4.DIR, OUTPUT);
               
               digitalWrite(Motor1.PUL, LOW);
               digitalWrite(Motor1.DIR, LOW);
               
               digitalWrite(Motor2.PUL, LOW);
               digitalWrite(Motor2.DIR, LOW);
            
               digitalWrite(Motor3.PUL, LOW);
               digitalWrite(Motor3.DIR, LOW);
               
               digitalWrite(Motor4.PUL, LOW);
               digitalWrite(Motor4.DIR, LOW);
            
              /* TC4_IRQn where 4 is the: timer number * timer channels (3) + the channel number (=(1*3)+1) for timer1 channel1 */
              Start_Timer(TC0, 0, TC0_IRQn, Motor2.Speed);
              Start_Timer(TC0, 1, TC1_IRQn, Motor3.Speed);
              Start_Timer(TC0, 2, TC2_IRQn, Motor4.Speed);
              Start_Timer(TC2, 1, TC7_IRQn, Motor1.Speed);
            
              PWM_Config(&Motor2);  
              PWM_Config(&Motor4);  
              PWM_Config(&Motor1);  
              PWM_Config(&Motor3);  
            
              Serial.begin(115200);
            }

////////////////////////////////////
//                                //
//       Interrupt Routines       // 
//                                //
////////////////////////////////////
    
            ////////////////////
            //                //
            //    Motor 1     //
            //                //
            ////////////////////
            void TC7_Handler()                   
            {
              TC_GetStatus(TC2, 1);
              
              Pulse_Motor(&Motor1, &(PIOA->PIO_ODSR), BIT8, &(PIOC->PIO_ODSR), BIT18);
              //Serial.println(Motor1.Steps_To_Go);
              REG_PWM_CDTY4 = ((Motor1.Current_Position/Motor1.Calibrated_Steps)*(PWM_MAX_DUTY/6)); // Update Duty Cycle
              TC_SetRC(TC2, 1, Motor1.Speed);  // = 1250 us toggle
            }
            
            ////////////////////
            //                //
            //    Motor 2     //
            //                //
            ////////////////////
            void TC0_Handler()                   
            {
              TC_GetStatus(TC0, 0);
            
              Pulse_Motor(&Motor2, &(PIOD->PIO_ODSR), BIT1, &(PIOC->PIO_ODSR), BIT4);
              REG_PWM_CDTY5 = ((Motor2.Current_Position/Motor2.Calibrated_Steps)*(PWM_MAX_DUTY/6)); // Update Duty Cycle
            
              TC_SetRC(TC0, 0, Motor2.Speed);  
            }
            
            ////////////////////
            //                //
            //    Motor 3     //
            //                //
            ////////////////////
            void TC1_Handler()          
            {
              TC_GetStatus(TC0, 1);
            
              Pulse_Motor(&Motor3, &(PIOD->PIO_ODSR), BIT3, &(PIOA->PIO_ODSR), BIT20);
              REG_PWM_CDTY6 = ((Motor3.Current_Position/Motor3.Calibrated_Steps)*(PWM_MAX_DUTY/6)); // Update Duty Cycle
            
              TC_SetRC(TC0, 1, Motor3.Speed);  // = 1250 us toggle
            }
            
            ////////////////////
            //                //
            //    Motor 4     //
            //                //
            ////////////////////
            void TC2_Handler()   
            {
              TC_GetStatus(TC0, 2);
              
              Pulse_Motor(&Motor4, &(PIOD->PIO_ODSR), BIT7, &(PIOD->PIO_ODSR), BIT11);
              REG_PWM_CDTY7 = ((Motor4.Current_Position/Motor4.Calibrated_Steps)*(PWM_MAX_DUTY/6)); // Update Duty Cycle
              TC_SetRC(TC0, 2, Motor4.Speed);  // = 1250 us toggle
            }

/////////////////////
//                 //
//    Main Loop    //
//                 //
/////////////////////
 
            void loop() 
            {
              
              while (true) // While loop avoids overhead of using the arduino void loop()
              {
                Receive_Serial_Data();
              }
            
            }
