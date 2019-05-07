%MATLAB Code for Serial Communication between Arduino and MATLAB

s = serial('COM4');
fopen(s);
while true
fprintf(s,'A');
out = fscanf(s)
end
fclose(s);
delete(s);
clear s;
