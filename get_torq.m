function [T_A, T_B] = get_torq(k1, x,x_dot,theta,theta_dot,phi,phi_dot)

T = k1 * [x; x_dot;theta;theta_dot;phi;phi_dot];
    T_A = T(1);
    T_B = T(2);
end