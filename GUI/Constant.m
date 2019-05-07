classdef Constant
   properties
      MaxSpeedRPS = 9;
      MaxSpeedBPM = 400;
      MaxDist = 900; 
      MinDist = -900;
      MaxCirc = 500;
   end
   methods
       % Mass Calculation (g)
       function result = calculateMass(obj, DBP, circ, length)
          result = 1000.*((DBP.*133.32.*(circ./(2.*pi.*1000)).*(length./1000))./9.806);
       end
    
       % Distension, Percentage to mm
       function result = calculateDistension(obj, dist, circ)
          result = (dist/100)*(circ/pi);
       end
       
       % Speed, BPM to RPS
       function result = calculateSpeed(obj, bpm, dist)
           result = abs((bpm/60)*2*dist);
       end
       
   end
end