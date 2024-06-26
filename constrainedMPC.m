global K
%% Discretization
% Define the continuous-time system matrices
load("state_space.mat")
Ac = A;
Bc = B;
C = eye(size(A));  % Identity matrix sized to A, assuming full state output
D = zeros(size(B, 1), size(B, 2));  % Zero matrix sized to B

% Specify the sampling time
dt = 0.02;  % Sampling time in seconds, change this to your specific value

% Create a continuous-time state-space system
sys = ss(A, B, C, D);

% Convert the continuous-time system to a discrete-time system using ZOH
sysd = c2d(sys, dt, 'zoh');

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
C = eye(6);

% Horizon
N = 20; % Prediction horizon

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
umin = [-0.4, -6]'; % minimum input constraints vector
umax = [0.4, 6]'; % maximum input constraints vector
ymin = [-100, -2, -deg2rad(45), -deg2rad(1000), -deg2rad(20), -deg2rad(20)]'; % minimum output constraints vector
ymax = -ymin; % maximum output constraints vector
% System matrices
Q = diag([1.50 2.20 0.001 0.03 3.00 1.00]);   %x x_dot theta theta_dot phi phi_dot
R = [0.01 0;0 0.001];
P = diag([100, 200, 1, 0.1, 2000, 1000]); % Terminal state weighting matrix

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
L = (L+L')/2;

% Simulation setup
num_steps = 250; % Total number of steps to simulate
X_history = zeros(size(A,1), num_steps+1); % History of states
U_history = zeros(size(B,2), num_steps); % History of inputs

X_history(:,1) = x0; % Initial state

for step = 1:num_steps
    x_k = X_history(:,step);
    [E, W] = setup_combined_constraints(A, B, C, umin, umax, ymin, ymax, x_k, N);
    U_optimal = quadprog(L,F*x_k,E,W);
    U_history(:,step) = U_optimal(1:2,1);
    % X_history(:,step+1) = A * x_k + B * U_history(:,step);
    
    % Define the continuous-time system dynamics as a function handle
    system_dynamics = @(t, x) Ac * x + Bc * U_history(:, step);
    
    % Solve the system dynamics over the interval [0, dt] starting from x_k
    [T, X] = ode45(system_dynamics, [0 dt], x_k);
    
    % Store the state at the end of the interval
    X_history(:, step + 1) = X(end, :)';
end



%% Plot
% Plot the state and control input history
time_vector = 0:num_steps; % Time vector for plotting

% Plot states
figure(1);
plot(time_vector*dt, X_history);
grid on
title('State history');
xlabel('Time step');
ylabel('State value');
legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6');

% Plot control inputs
figure(2);
plot(time_vector(1:end-1)*dt, U_history(1,:));
grid on;hold on
plot(time_vector(1:end-1)*dt, U_history(2,:));
title('Control input history');
xlabel('Time step');
ylabel('Control input value');
legend('u1', 'u2');
hold off


%% Function Definitions

function [E, W] = setup_combined_constraints(A, B, C, umin, umax, ymin, ymax, x, N)
    % First, set up the input constraints
    [E_input, W_input] = setup_input_constraints(umin, umax, N);
    
    % Now, set up the output constraints
    [E_output, W_output] = setup_output_constraints(A, B, C, [ymin, ymax], x, N);
    
    % Combine the constraints
    % E = [E_input; E_output];
    % W = [W_input; W_output];

    E = [E_input];
    W = [W_input];
end


function [E, W] = setup_input_constraints(umin, umax, N)
    % Validate that umin and umax are vectors of the same length
    n_controls = length(umin);
    assert(length(umin) == length(umax), 'Vectors umin and umax must be of the same length.');

    % Initialize A matrix as empty and then fill with identity matrices
    % and negative identity matrices for each time step in the horizon
    E_upper = [];
    E_lower = [];
    for i = 1:N
        E_upper = blkdiag(E_upper, eye(n_controls));
    end
    for i = 1:N
        E_lower = blkdiag(E_lower, -eye(n_controls));
    end
    E = [E_upper;E_lower];
    % Stack umax and umin vectors N times to create the b vector
    W = repmat([umax; -umin], N, 1);
end


function [E2, W2] = setup_output_constraints(A, B, C, y, xk, N)
    % Calculate dimensions
    n = size(A, 1); % Assuming A is square
    m = size(B, 2); % Assuming B has the same number of rows as A
    
    % Initialize E2 matrix
    E2 = zeros(2*N*n, N*m);
    
    % Fill E2 matrix
    for i = 1:N
        E2((i-1)*n+1:i*n, (i-1)*m+1:i*m) = C*A^(i-1)*B;
        if i < N
            E2(N*n+(i-1)*n+1:N*n+i*n, (i-1)*m+1:i*m) = -C*A^(i-1)*B;
        end
    end
    
    % Construct the W2 matrix
    ymax = y(:, 1); % Assuming y is organized such that ymax is the first column
    ymin = y(:, 2); % Assuming y is organized such that ymin is the second column
    W2_upper = repmat(ymax, N, 1);
    W2_lower = repmat(-ymin, N, 1);
    
    CA_power = zeros(N*n, n);
    for i = 1:N
        CA_power((i-1)*n+1:i*n, :) = C*A^i;
    end
    W2 = [W2_upper; W2_lower] - [CA_power; -CA_power] * xk; % Assuming x is organized with time-steps as columns
    
    % Return the matrices
end
