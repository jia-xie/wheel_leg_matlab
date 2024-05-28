close all
time = out.simout.time;

velocity = out.simout.signals.values;
figure(1)
plot(time, velocity(:, 1), "LineWidth", 1.5)
hold on
grid on 
plot(time, velocity(:, 2))
xlabel("time (s)", "Interpreter","latex");
ylabel("Velocity (m/s)", "Interpreter","latex");
title("Velocity Response $\dot x$", "Interpreter","latex")
legend("target", "actual", "Interpreter","latex")
figure(2)
theta = out.simout1.signals.values;
plot(time, theta(:, 1).*(180/pi), LineWidth=1.5)
hold on
grid on 
plot(time, theta(:, 2).*(180/pi), LineWidth=1.5)
xlabel("time (s)", "Interpreter","latex");
ylabel("Leg Angle $\theta$ (deg)", "Interpreter","latex");
title("Leg Angle $\theta$ Response", "Interpreter","latex")
legend("target", "actual", "Interpreter","latex")
figure(3)
phi = out.simout2.signals.values;
plot(time, phi(:, 1).*(180/pi), LineWidth=1.5)
hold on
grid on 
plot(time, phi(:, 2).*(180/pi), LineWidth=1.5)
xlabel("time (s)", "Interpreter","latex");
ylabel("Platform Angle $\phi$ (deg)", "Interpreter","latex");
title("Platform Angle $\phi$ Response", "Interpreter","latex")
legend("target", "actual", "Interpreter","latex")