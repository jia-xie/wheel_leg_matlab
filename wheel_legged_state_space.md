# MATLAB Symbolic Calculation for Wheel-Legged Balancing Robot
## Define Symbolic Variables

```matlab:Code
syms A_x A_y B_x B_y x(t) theta(t) phi(t) T_A(t) T_B(t) M_A M_B M_R g L_1 L_2 L_r1 L_r2 x_dot phi_dot theta_dot I_B I_R x_ddot phi_ddot theta_ddot R I_A I_r
syms A_x_sol A_y_sol B_x_sol B_y_sol
```

## Eliminate Reaction Force at Point A and B: $A_x$ $A_y$ $B_x$ $B_y$

Define Equation of Motion

```matlab:Code
eq1 = M_B * diff(x + L_1*sin(theta) + L_2 * sin(phi),t, 2) == B_x;
eq2 = M_B*diff(L_1 * cos(theta) + L_2 * cos(phi),t,2) == B_y - M_B * g;
eq3 = M_R * diff(x + L_1 * sin(theta),t,2) == -A_x - B_x;
eq4 = M_R * diff(L_1 * cos(theta),t,t) == -A_y - B_y - M_R * g;
```

solve() function does not support diff type, therefore we need to substitude the $\frac{d}{dt}$ and $\frac{d^2 }{dt^2 }$ with dotted notation

```matlab:Code
eq1 = subs(eq1, [diff(x,t,2) diff(phi,t,2) diff(theta,t,2) diff(x,t) diff(phi,t) diff(theta,t)], [ ...
    x_ddot phi_ddot theta_ddot x_dot phi_dot theta_dot]);
eq2 = subs(eq2, [diff(x,t,2) diff(phi,t,2) diff(theta,t,2) diff(x,t) diff(phi,t) diff(theta,t)], [ ...
    x_ddot phi_ddot theta_ddot x_dot phi_dot theta_dot]);
eq3 = subs(eq3, [diff(x,t,2) diff(phi,t,2) diff(theta,t,2) diff(x,t) diff(phi,t) diff(theta,t)], [ ...
    x_ddot phi_ddot theta_ddot x_dot phi_dot theta_dot]);
eq4 = subs(eq4, [diff(x,t,2) diff(phi,t,2) diff(theta,t,2) diff(x,t) diff(phi,t) diff(theta,t)], [ ...
    x_ddot phi_ddot theta_ddot x_dot phi_dot theta_dot]);
```

Eliminate $A_x$ $A_y$ $B_x$ $B_y$

```matlab:Code
[A_x, A_y, B_x, B_y] = solve([eq1 eq2 eq3 eq4], [A_x, A_y, B_x, B_y]);
```

\matlabheadingtwo{Calculating $\ddot{\phi}$, $\ddot{\theta}$, $\ddot{x}$}

Define Equation of Motion

```matlab:Code
eq5 = phi_ddot == (-T_B + B_x*L_2*cos(phi) + B_y * L_2 * sin(phi))/ I_B;
eq6 = theta_ddot == (B_x * L_r2 * cos(theta) - B_y * L_r2 * sin(theta) - A_x * L_r1 * cos(theta) + A_y * L_r1 * sin(theta) - T_A + T_B) / I_r;
eq7 = x_ddot == R* (T_A - R*A_x)/ (I_A - M_A * R^2);
```

Solve for $\ddot{\phi}$, $\ddot{\theta}$, $\ddot{x}$

```matlab:Code
[x_ddot, theta_ddot, phi_ddot] = solve([eq5, eq6, eq7], [x_ddot theta_ddot phi_ddot]);
```

## Jacobian Linearization of State-Space Model

Define state vector, input vector

```matlab:Code
X = [x, x_dot, theta, theta_dot, phi, phi_dot];
U = [T_A, T_B];
X_dot = [x_dot;x_ddot;theta_dot;theta_ddot;phi_dot;phi_ddot];
```

Jacobian Calculation

```matlab:Code
X_dot = simplify(collect(X_dot, X));
Jacobian_A = jacobian(X_dot, X);
X_dot = simplify(collect(X_dot, U));
Jacobian_B = jacobian(X_dot, U);
```

Substitude phycial properties $I_A ,I_B ,I_r ,L_1 ,L_2 ,L_r 1,L_r 2,M_A ,M_B ,M_R ,R,g$, and system balance point $\dot{\phi} ,\dot{\theta} ,\dot{x} ,\phi ,\theta ,x$

```matlab:Code
A = subs(Jacobian_A,[I_A,I_B,I_r,L_1,L_2,L_r1,L_r2,M_A,M_B,M_R,R,g,phi_dot,theta(t),theta_dot,x_dot, phi(t)],[5e-5,0.003603312/2,0.00063466347,0.16,0.2,0.119,0.041,80,2207.21/2,173.11,0.03,9.81,0,0,0,0,0]);
B = subs(Jacobian_B,[I_A,I_B,I_r,L_1,L_2,L_r1,L_r2,M_A,M_B,M_R,R,g,phi_dot,theta(t),theta_dot,x_dot, phi(t)],[5e-5,0.003603312/2,0.00063466347,0.16,0.2,0.119,0.041,80,2207.21/2,173.11,0.03,9.81,0,0,0,0,0]);
A = double(A)
B = double(B)
```

## Controllability

Full rank

```matlab:Code
rank(ctrb(A,B))
```

## Reccati LQR Calculation

```matlab:Code
Q=diag([800 600 700 1 1000 1])   %x d_x theta d_theta phi d_phi
R=[1 0;0 0.25]                   %T Tp

K1=lqr(A,B,Q,R)
```
