function [C]= Clutter_meas
global lambda_c Sen;
MSen=Sen;
Mlambdac=lambda_c;
nclut = poissrnd(Mlambdac);
R1 = sqrt((MSen(1)-0)^2 + (MSen(2)-0)^2);
R2 = sqrt((MSen(1)-0)^2 + (MSen(2)-000)^2);
R3 = sqrt((MSen(1)-1000)^2 + (MSen(2)-0)^2);
R4 = sqrt((MSen(1)-1000)^2 + (MSen(2)-1000)^2);
max_R = max([R1 R2 R3 R4]);
C = [rand(1,nclut)*max_R;rand(1,nclut)*max_R];
end