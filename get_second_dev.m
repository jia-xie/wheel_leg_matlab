function result = get_second_dev()
syms F_wx_1 F_wz_1 F_wx_2 F_wz_2
syms F_bx_1 F_bz_1 F_bx_2 F_bz_2
syms f1 f2

syms T_w_1 T_w_2 T_h_1 T_h_2 

syms x_ddot_l_1 z_ddot_l_1 x_ddot_l_2 z_ddot_l_2 x_ddot_b z_ddot_b

syms phi_ddot  theta_b theta_l_1 theta_l_2 theta_ddot_l_1 theta_ddot_l_2 
syms theta_ddot_w_1 theta_ddot_w_2 theta_ddot_b
syms g I_z I_w I_l_1 I_l_2 I_b m_w m_l m_b l_b_1 l_w_1 l_b_2 l_w_2 R_l R_w l_c
syms theta_dot_l_1 theta_dot_l_2 l_1 l_2 A
syms theta_dot_w_1(t) theta_dot_w_2(t) l_1 l_2 theta_l_1(t) theta_l_2(t) theta_dot_l_1 theta_dot_l_2 theta_w_1(t) theta_w_2(t) phi(t) phi_dot x_b
x = (theta_w_1+theta_w_2)*R_w/2
x_l_1 = R_w * theta_w_1 + l_w_1 * sin(theta_l_1)
z_l_1 = R_w + l_w_1*cos(theta_l_1)
x_l_2 = R_w * theta_w_2 + l_w_2 * sin(theta_l_2)
z_l_2 = R_w + l_w_2*cos(theta_l_2)
eq_x_b_1 = x_b == R_w*theta_w_1 - R_l*phi - l_1*sin(theta_l_1)
eq_x_b_2 = x_b == R_w*theta_w_2 + R_l*phi - l_2*sin(theta_l_2)

x_b = x - l_1*sin(theta_l_1)/2 - l_2*sin(theta_l_2)/2;
phi = simplify((R_w*(theta_w_2-theta_w_1)+ l_1*sin(theta_l_1) - l_2*sin(theta_l_2))/(2*R_l));
z_b = (l_1*cos(theta_l_1) + l_2*cos(theta_l_2));

x_ddot = diff(x, t, 2);
x_ddot_l_1 = diff(x_l_1, t, 2);
z_ddot_l_1 = diff(z_l_1, t, 2);
x_ddot_l_2 = diff(x_l_2, t, 2);
z_ddot_l_2 = diff(z_l_2, t, 2);
phi_ddot = diff(phi, t, 2);
x_ddot_b = diff(x_b, t, 2);
z_ddot_b = diff(z_b, t, 2);
to_simplify = [cos(theta_b) cos(theta_l_1) cos(theta_l_2) ...
    sin(theta_b) sin(theta_l_1) sin(theta_l_2)];
simplified = [1 1 1 theta_b theta_l_1 theta_l_2];

subs_result = subs([x_ddot; x_ddot_l_1; z_ddot_l_1; x_ddot_l_2; z_ddot_l_2; phi_ddot; x_ddot_b; z_ddot_b], [ ...
    diff(theta_l_1, t, 2) ...
    diff(theta_l_2, t, 2) ...
    diff(theta_l_1, t), ...
    diff(theta_l_2, t), ...
    diff(theta_w_1, t, 2) ...
    diff(theta_w_2, t, 2) ...
    diff(phi, t), ...
    to_simplify], ...
    [theta_ddot_l_1 ...
    theta_ddot_l_2 ...
    theta_dot_l_1 ...
    theta_dot_l_2 ...
    theta_ddot_w_1 ...
    theta_ddot_w_2 ...
    phi_dot, ...
    simplified]);

time_dependent = [theta_dot_w_1(t) theta_dot_w_2(t) l_1 l_2 theta_l_1(t) theta_l_2(t) theta_dot_l_1 theta_dot_l_2 theta_w_1(t) theta_w_2(t) phi(t)];
syms theta_dot_w_1 theta_dot_w_2 l_1 l_2 theta_l_1 theta_l_2 theta_dot_l_1 theta_dot_l_2 theta_w_1 theta_w_2 phi phi_dot
time_independent = [theta_dot_w_1 theta_dot_w_2 l_1 l_2 theta_l_1 theta_l_2 theta_dot_l_1 theta_dot_l_2 theta_w_1 theta_w_2 phi];
subs_result = simplify(subs(subs_result, time_dependent, time_independent));
syms x_ddot x_ddot_l_1 z_ddot_l_1 x_ddot_l_2 z_ddot_l_2 phi_ddot x_ddot_b z_ddot_b
result = subs_result(t);
end