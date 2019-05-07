classdef Motor
   properties
      % These are the values sent through the COM port.
      initialDistent = '0';
      dist = '00000';
      motorSpeed = '00000';
      motorStatus = '0';
      motorMode = '1';
      analogDelay = '00';
      motorNumber = '0';
      
      % These values are for resetting the value in an EditText box
      % if a limit is exceeded, or an invalid character is entered.
      lastSpeed = '0';
      lastDist = '0';
      lastCirc = '0';
      lastLength = '0';
      lastDBP = '0';
   end
   methods 
      
   end
end

%
% I0909B0909D0909S0M0
%