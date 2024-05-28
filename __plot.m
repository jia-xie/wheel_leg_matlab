function [T1,T2] = VMC_calc(F0,Tp,phi1,phi4)

l5=0.16;
l1=0.14;
l2=0.24;
l3=0.24;
l4=0.14;

YD = l4*sin(phi4);
YB = l1*sin(phi1);
XD = l5 + l4*cos(phi4);
XB = l1*cos(phi1); 
lBD = sqrt((XD - XB)*(XD - XB) + (YD - YB)*(YD - YB));
A0 = 2*l2*(XD - XB);
B0 = 2*l2*(YD - YB);
C0 = l2*l2 + lBD*lBD - l3*l3;
phi2 = 2*atan2((B0 + sqrt(A0*A0 + B0*B0 - C0*C0)),A0 + C0);
phi3 = atan2(YB-YD+l2*sin(phi2),XB-XD+l2*cos(phi2));
XC = l1*cos(phi1) + l2*cos(phi2);
YC = l1*sin(phi1) + l2*sin(phi2);
L0 = sqrt((XC - l5/2)*(XC - l5/2) + YC*YC);
phi0 = atan2(YC,XC - l5/2);
j11 = (l1*sin(phi0-phi3)*sin(phi1-phi2))/sin(phi3-phi2);
j12 = (l1*cos(phi0-phi3)*sin(phi1-phi2))/L0*sin(phi3-phi2);
j21 = (l4*sin(phi0-phi2)*sin(phi3-phi4))/sin(phi3-phi2);
j22 = (l4*cos(phi0-phi2)*sin(phi3-phi4))/L0*sin(phi3-phi2);
J = [j11 j12; j21 j22];
F = [F0;Tp];
T = J * F;
T1 = T(1,1);
T2 = T(2,1);

end