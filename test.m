function K = test()

data = load("state_space.mat");
A = data.A;
B = data.B;

Q=diag([150 220 0.1 3 200 100]);   %x x_dot theta theta_dot phi phi_dot
R=[150 0;0 30];

K = lqr(A, B, Q, R)