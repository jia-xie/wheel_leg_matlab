function [T1, T4] = vmc_(F0,Tp,leg,ang)
[phi1, phi2] = inverse_kinematics(leg,ang, 0.11, 0.15, 0.26);
[T1, T4] = vmc(F0,Tp,phi1/180*pi, phi2/180*pi);
end
