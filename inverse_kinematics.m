function [phi1_pos, phi4_neg] = inverse_kinematics(height, angle, joint_dis, ...
    thigh_length, calf_length)
%% Function Name: inverse_kinematics
%
% Description:
%   Calculate the correpsonding joint angle
%
% Inputs:
%   height: height of the robot
%   angle: the angle of simplified model                 [rad]
%   joint_dis: the distance between two joint motors
%   thigh_length： length of the thigh                   [m]
%
% $Revision: R2023a$
% $Author: Jia Xie$
% $Date: October 25, 2023$
angle = angle/180*pi;
x = height / tan(angle);
y = height;

a1 = x + joint_dis/2;
b1 = y;

A1 = a1^2 + b1^2 + thigh_length^2 - calf_length^2;
B1 = -2* a1 * thigh_length;
C1 = -2 * b1 * thigh_length;

phi1_pos = 2 * atan2(-C1 + sqrt(C1^2 + B1^2 - A1^2), A1 - B1);
phi1_pos = phi1_pos/pi*180;


phi1_neg = 2 * atan2(-C1 - sqrt(C1^2 + B1^2 - A1^2), A1 - B1);
phi1_neg = phi1_neg/pi*180;
% a1 = -x + joint_dis/2;
% b1 = y;
%
% A1 = a1^2 + b1^2 + thigh_length^2 - calf_length^2;
% B1 = -2* a1 * thigh_length;
% C1 = -2 * b1 * calf_length;
%
% phi4 = -2 * atan2(-C1 + sqrt(C1^2 + B1^2 - A1^2), A1 - B1);




a2 = x - joint_dis/2;
b2 = y;
A2 = a2^2 + b2^2 + thigh_length^2 - calf_length^2;
B2 = -2 * a2 * thigh_length;
C2 = -2 * b2 * thigh_length;
phi4_pos = 2 * atan2(-C2 + sqrt(C2^2 + B2^2 - A2^2), A2 - B2);
phi4_pos = phi4_pos/pi*180;
phi4_neg = 2 * atan2(-C2 - sqrt(C2^2 + B2^2 - A2^2), A2 - B2);
phi4_neg = phi4_neg/pi*180;

phi1_pos = mod(phi1_pos, 360);
phi1_neg = mod(phi1_neg, 360);
phi4_pos = mod(phi4_pos, 360);
if phi4_pos > 180
    phi4_pos = phi4_pos - 360;
end
phi4_neg = mod(phi4_neg, 360);
if phi4_neg > 180
    phi4_neg = phi4_neg - 360;
end
end