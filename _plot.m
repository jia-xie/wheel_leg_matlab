close all
time=out.state.time;
state=out.state.signals.values;
input=out.input.signals.values;

figure(1)
subplot(3,1,1)
hold on
grid on
plot(time, state(:,1:2))
title("Displacement", FontSize=12)
legend("$x$", "$\dot x$",'interpreter','latex', FontSize=12)
ylabel("Distance (m)", FontSize=12)


subplot(3,1,2)
hold on
grid on
plot(time, state(:,3:4) * 180 / pi)
title("Leg Angle", FontSize=12)
legend("$\theta$", "$\dot \theta$",'interpreter','latex', FontSize=12)
ylabel("Angle (deg)", FontSize=12)


subplot(3,1,3)
hold on
grid on
plot(time, state(:,5:6) * 180 / pi)
ylabel("Angle (deg)", FontSize=12)
title("Displacement", FontSize=12)
legend("$\phi$", "$\dot \phi$",'interpreter','latex', FontSize=12)

figure(2)
plot(time, input(:,1:2))
hold on
grid on
title("Input", FontSize=12)
legend("$T_A$", "$T_B$",'interpreter','latex', FontSize=12)
ylabel("Torque (Nm)", FontSize=12)