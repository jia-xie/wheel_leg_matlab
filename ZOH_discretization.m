global K
%% Discretization
% Define the continuous-time system matrices
load("state_space.mat")
C = eye(size(A));  % Identity matrix sized to A, assuming full state output
D = zeros(size(B, 1), size(B, 2));  % Zero matrix sized to B

% Specify the sampling time
Ts = 0.02;  % Sampling time in seconds, change this to your specific value

% Create a continuous-time state-space system
sys = ss(A, B, C, D);

% Convert the continuous-time system to a discrete-time system using ZOH
sysd = c2d(sys, Ts, 'zoh');

% Extract the discrete-time A and B matrices
Ad = sysd.A;
Bd = sysd.B;

% Display the discrete-time matrices
disp('Discrete-time A matrix:');
disp(Ad);
disp('Discrete-time B matrix:');
disp(Bd);

% System matrices
A = Ad; % Your A matrix
B = Bd; % Your B matrix

% Horizon
N = 30; % Prediction horizon

% Pre-allocate H and G matrices
H = zeros(N*size(A,1), size(A,1));
G = zeros(N*size(A,1), N*size(B,2));

% Construct H matrix
for i = 1:N
    H((i-1)*size(A,1)+1:i*size(A,1), :) = A^i;
end

% Construct G matrix
for i = 1:N
    for j = 1:i
        G((i-1)*size(A,1)+1:i*size(A,1), (j-1)*size(B,2)+1:j*size(B,2)) = A^(i-j)*B;
    end
end

% Display H and G
disp('H matrix:');
disp(H);
disp('G matrix:');
disp(G);

%% Unconstrained MPC
% Initial Condition
x0 = [0, 0, 0.2, 0, 0, 0]';

% System matrices
Q = diag([150 220 0.1 3 300 100]);   %x x_dot theta theta_dot phi phi_dot
R = [30 0;0 10];
P = [100, 200, 1, 0.1, 2000, 1000]; % Terminal state weighting matrix
P = diag(P);

% Construct Qbar
Qbar = blkdiag(kron(eye(N-1), Q), P);

% Construct Rbar
Rbar = kron(eye(N), R);

% Display Qbar and Rbar
disp('Qbar matrix:');
disp(Qbar);
disp('Rbar matrix:');
disp(Rbar);

% Compute the augmented matrices for the cost function
M = Q + H'*Qbar*H;
F = G'*Qbar*H;
L = G'*Qbar*G + Rbar;

% Simulation setup
num_steps = 250; % Total number of steps to simulate
X_history = zeros(size(A,1), num_steps+1); % History of states
U_history = zeros(size(B,2), num_steps); % History of inputs

X_history(:,1) = x0; % Initial state

for step = 1:num_steps
    % Compute the optimal control input U for the current state
    U = -inv(L)*F*X_history(:,step);
    
    % Apply only the first control input to the system
    U_current = U(1:size(B,2));
    X_history(:,step+1) = A*X_history(:,step) + B*U_current;

    % Store the applied control input
    U_history(:,step) = U_current;
    
    % If you want to recalculate H, G, Qbar, Rbar, M, F, L based on the new state
    % you need to put the code that calculates these matrices here.
    % This would be needed if your Q, R, P matrices change with the state,
    % which is not typical in MPC.
end

K = (inv(L)*F);
K = K(1:2,1:6)

% Plot the state and control input history
time_vector = 0:num_steps; % Time vector for plotting

% Plot states
figure(1);
plot(time_vector*Ts, X_history);
grid on
title('State history');
xlabel('Time step');
ylabel('State value');
legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6');

% Plot control inputs
figure(2);
plot(time_vector(1:end-1)*Ts, U_history(1,:));
grid on;hold on
plot(time_vector(1:end-1)*Ts, U_history(2,:));
title('Control input history');
xlabel('Time step');
ylabel('Control input value');
legend('u1', 'u2');
hold off