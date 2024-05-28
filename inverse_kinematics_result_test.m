result = zeros(5, 1000);

ang = linspace(30, 150, 1000);

for i = 1:1000
    angle = ang(i);
    try
        [k1, k2, k3, k4] = inverse_kinematics(0.13, angle, 0.07, 0.14, 0.24);
        result(1, i) = angle;
        result(2, i) = k1;
        result(3, i) = k2;
        result(4, i) = k3;
        result(5, i) = k4;
    catch
        result(1, i) = angle;
        result(2, i) = nan;
        result(3, i) = nan;
        result(4, i) = nan;
        result(5, i) = nan;
    end
end
subplot(2,1,1)
hold on
plot(result(1,:), result(2,:))
plot(result(1,:), result(3,:))
title("thigh1")
legend("$+\sqrt{\Delta}$","$-\sqrt{\Delta}$", 'Interpreter','latex')
hold off

subplot(2,1,2)
hold on
plot(result(1,:), result(4,:))
plot(result(1,:), result(5,:))
title("thigh4")
legend("$+\sqrt{\Delta}$","$-\sqrt{\Delta}$", 'Interpreter','latex')
hold off