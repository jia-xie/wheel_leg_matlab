clear, clc

syms x x_dot x_ddot phi_ddot theta_ddot_b
syms F_wx_1 F_wz_1 F_wx_2 F_wz_2
syms F_bx_1 F_bz_1 F_bx_2 F_bz_2
syms f1 f2

syms T_w_1 T_w_2 T_h_1 T_h_2 

syms  theta_b theta_l_1 theta_l_2 theta_ddot_l_1 theta_ddot_l_2
syms theta_ddot_w_1 theta_ddot_w_2
syms g I_z I_w I_l_1 I_l_2 I_b m_w m_l m_b l_b_1 l_w_1 l_b_2 l_w_2 R_l R_w l_c
syms theta_dot_l_1 theta_dot_l_2 l_1 l_2


x_ddot_l_1 = - l_w_1*sin(theta_l_1)*theta_dot_l_1^2 + R_w*theta_ddot_w_1 + l_w_1*theta_ddot_l_1*cos(theta_l_1);
z_ddot_l_1 = -l_w_1*(cos(theta_l_1)*theta_dot_l_1^2 + theta_ddot_l_1*sin(theta_l_1));
x_ddot_l_2 = - l_w_2*sin(theta_l_2)*theta_dot_l_2^2 + R_w*theta_ddot_w_2 + l_w_2*theta_ddot_l_2*cos(theta_l_2);
z_ddot_l_2 = -l_w_2*(cos(theta_l_2)*theta_dot_l_2^2 + theta_ddot_l_2*sin(theta_l_2));
x_ddot_b = (l_1*sin(theta_l_1)*theta_dot_l_1^2)/2 + (l_2*sin(theta_l_2)*theta_dot_l_2^2)/2 + (R_w*(theta_ddot_w_1 + theta_ddot_w_2))/2 - (l_1*theta_ddot_l_1*cos(theta_l_1))/2 - (l_2*theta_ddot_l_2*cos(theta_l_2))/2;
z_ddot_b = - l_1*cos(theta_l_1)*theta_dot_l_1^2 - l_2*cos(theta_l_2)*theta_dot_l_2^2 - l_1*theta_ddot_l_1*sin(theta_l_1) - l_2*theta_ddot_l_2*sin(theta_l_2);
phi_ddot_temp = -(l_1*sin(theta_l_1)*theta_dot_l_1^2 - l_2*sin(theta_l_2)*theta_dot_l_2^2 + R_w*(theta_ddot_w_1 - theta_ddot_w_2) - l_1*theta_ddot_l_1*cos(theta_l_1) + l_2*theta_ddot_l_2*cos(theta_l_2))/(2*R_l);

% x_l_1 = R_w * theta_w_1 + l_w_1 * sin(theta_l_1)
% z_l_1 = R_w + l_w_1*cos(theta_l_1)
% x_l_2 = R_w * theta_w_2 + l_w_2 * sin(theta_l_2)
% z_l_2 = R_w + l_w_2*cos(theta_l_2)
% eq_x_b_1 = x_b == R_w*theta_w_1 - R_l*phi - l_1*sin(theta_l_1)
% eq_x_b_2 = x_b == R_w*theta_w_2 + R_l*phi - l_2*sin(theta_l_2)
% 
% x_b = x - l_1*sin(theta_l_1)/2 - l_2*sin(theta_l_2)/2;
% phi = simplify((R_w*(theta_w_2-theta_w_1)+ l_1*sin(theta_l_1) - l_2*sin(theta_l_2))/(2*R_l));
% z_b = (l_1*cos(theta_l_1) + l_2*cos(theta_l_2));
% 
% x_ddot = diff(x, t, 2);
% x_ddot_l_1 = diff(x_l_1, t, 2);
% z_ddot_l_1 = diff(z_l_1, t, 2);
% x_ddot_l_2 = diff(x_l_2, t, 2);
% z_ddot_l_2 = diff(z_l_2, t, 2);
% phi_ddot = diff(phi, t, 2);
% x_ddot_b = diff(x_b, t, 2);
% z_ddot_b = diff(z_b, t, 2);

eq3 = m_w*R_w*theta_ddot_w_1 == f1 - F_wx_1;
eq4 = I_w*theta_ddot_w_1 == T_w_1 - R_w*f1;
eq8 = m_w*R_w*theta_ddot_w_2 == f2 - F_wx_2;
eq9 = I_w*theta_ddot_w_2 == T_w_2 - R_w*f2;
[f1_temp, F_wx_1_temp]=solve([eq3, eq4], [f1, F_wx_1]);
[f2_temp, F_wx_2_temp]=solve([eq8, eq9], [f2, F_wx_2]);

eq1 = I_z * (phi_ddot_temp) == (-f1_temp + f2_temp)*R_l;
eq13 = m_b*x_ddot_b == F_wx_1_temp + F_wx_2_temp;

[theta_ddot_w_1_sol, theta_ddot_w_2_sol] = solve([eq1, eq13], [theta_ddot_w_1, theta_ddot_w_2]);

F_wx_1 = -(m_w*theta_ddot_w_1_sol*R_w^2 - T_w_1 + I_w*theta_ddot_w_1_sol)/R_w
F_wx_2 = -(m_w*theta_ddot_w_2_sol*R_w^2 - T_w_2 + I_w*theta_ddot_w_2_sol)/R_w



x_ddot_l_1 = - l_w_1*sin(theta_l_1)*theta_dot_l_1^2 + R_w*theta_ddot_w_1_sol + l_w_1*theta_ddot_l_1*cos(theta_l_1);
z_ddot_l_1 = -l_w_1*(cos(theta_l_1)*theta_dot_l_1^2 + theta_ddot_l_1*sin(theta_l_1));
x_ddot_l_2 = - l_w_2*sin(theta_l_2)*theta_dot_l_2^2 + R_w*theta_ddot_w_2_sol + l_w_2*theta_ddot_l_2*cos(theta_l_2);
z_ddot_l_2 = -l_w_2*(cos(theta_l_2)*theta_dot_l_2^2 + theta_ddot_l_2*sin(theta_l_2));
x_ddot_b = (l_1*sin(theta_l_1)*theta_dot_l_1^2)/2 + (l_2*sin(theta_l_2)*theta_dot_l_2^2)/2 + (R_w*(theta_ddot_w_1_sol + theta_ddot_w_2_sol))/2 - (l_1*theta_ddot_l_1*cos(theta_l_1))/2 - (l_2*theta_ddot_l_2*cos(theta_l_2))/2;
z_ddot_b = - l_1*cos(theta_l_1)*theta_dot_l_1^2 - l_2*cos(theta_l_2)*theta_dot_l_2^2 - l_1*theta_ddot_l_1*sin(theta_l_1) - l_2*theta_ddot_l_2*sin(theta_l_2);
eq2 = F_bz_1 == F_bz_2;
eq5 = m_l*x_ddot_l_1 == F_wx_1 - F_bx_1;
eq6 = m_l * z_ddot_l_1 == F_wz_1 - F_bz_1 - m_l * g;
eq10 = m_l*x_ddot_l_2 == F_wx_2 - F_bx_2;
eq11 = m_l * z_ddot_l_2 == F_wz_2 - F_bz_2 - m_l * g;
eq14 = m_b*z_ddot_b == F_bz_1 + F_bz_2 - m_b*g;
[F_wz_1, F_wz_2, F_bx_1, F_bz_1, F_bx_2, F_bz_2] = solve([eq2 eq5 eq6 eq10 eq11 eq14], [F_wz_1, F_wz_2, F_bx_1, F_bz_1, F_bx_2, F_bz_2])


eq1 = x_ddot == R_w*(theta_ddot_w_1_sol + theta_ddot_w_2_sol) / 2
eq2 = phi_ddot == -(l_1*sin(theta_l_1)*theta_dot_l_1^2 - l_2*sin(theta_l_2)*theta_dot_l_2^2 + R_w*(theta_ddot_w_1_sol - theta_ddot_w_2_sol) - l_1*theta_ddot_l_1*cos(theta_l_1) + l_2*theta_ddot_l_2*cos(theta_l_2))/(2*R_l)
eq3 = theta_ddot_l_1 == ((-F_bx_1*l_b_1 + F_wx_1*l_w_1)*cos(theta_l_1) + (F_bz_1*l_b_1 + F_wz_1*l_w_1)*sin(theta_l_1) - T_w_1 + T_h_1)/I_l_1
eq4 = theta_ddot_l_2 == ((-F_bx_2*l_b_2 + F_wx_2*l_w_2)*cos(theta_l_2) + (F_bz_2*l_b_2 + F_wz_2*l_w_2)*sin(theta_l_2) - T_w_2 + T_h_2)/I_l_2
eq5 = theta_ddot_b == ((-F_bx_1 + F_bx_2)*l_c*cos(theta_b) + (F_bz_1 + F_bz_2)*l_c*sin(theta_b) - T_h_1 - T_h_2)/I_b

[x_ddot, phi_ddot, theta_ddot_l_1, theta_ddot_l_2, theta_ddot_b] = solve([eq1, eq2, eq3, eq4, eq5], [x_ddot, phi_ddot, theta_ddot_l_1, theta_ddot_l_2, theta_ddot_b])

syms x x_dot phi phi_dot theta_dot_b theta_ddot_w_1 theta_ddot_w_2

X = [x;x_dot;phi;phi_dot;theta_l_1;theta_dot_l_1;theta_l_2;theta_dot_l_2;theta_b;theta_dot_b]
X_dot = [x_dot;x_ddot;phi_dot;phi_ddot;theta_dot_l_1;theta_ddot_l_1;theta_dot_l_2;theta_ddot_l_2;theta_dot_b;theta_ddot_b]

A = jacobian(X_dot, X)

A = subs(A, [ ...
    x; ...
    x_dot; ...
    phi; ...
    phi_dot; ...
    theta_l_1; ...
    theta_dot_l_1; ...
    theta_l_2; ...
    theta_dot_l_2; ...
    theta_b; ...
    theta_dot_b ...
    ],[ ...
    0;0;0;0;0;0;0;0;0;0])

Parameters = [g I_z I_w I_l_1 I_l_2 I_b m_w m_l m_b l_b_1 l_w_1 l_b_2 l_w_2 R_w R_l]

g = 9.81;
I_z = 0.4075851016;
I_w = 6e-4;
I_l_1 = 5e-5;
I_l_2 = 5e-5;
I_b = 0.1424586238;
m_w = 0.3;
m_l = 0.5;
m_b = 4.2;
l_b_1 = l_1/2;
l_w_1 = l_1/2;
l_b_2 = l_2/2;
l_w_2 = l_2/2;
R_w = 0.075;
R_l = 0.22;
Numeric = [g I_z I_w I_l_1 I_l_2 I_b m_w m_l m_b l_b_1 l_w_1 l_b_2 l_w_2 R_w R_l]
Numeric = ones(1,15)
A = subs(A, Parameters, Numeric)