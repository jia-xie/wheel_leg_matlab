current = [0.806;1.611;2.417;3.223;4.028;4.834;5.640;6.445;7.251;8.057;
    8.862;9.668;10.474;11.279;12.085;12.891;13.696;14.502;15.308;16.113];

torque = [0.28616; 0.52528; 0.7644; 1.00352; 1.29164; 1.5288; 1.81692; 
    2.05604; 2.58132; 2.82044; 3.05956; 3.1066; 3.34572;3.5378;3.77692;
    4.01604;4.25516;4.44528;4.7334;4.92352];

p = polyfit(current,torque,1);
current_model = linspace(0,17,100);
torque_model = current_model * p(1) + p(2);
plot(current,torque, LineWidth=1)
hold on
grid on
plot(current_model, torque_model, LineWidth=1)
title("Motor Torque Current Relation", "Interpreter","latex")
xlabel("Current (A)", "Interpreter","latex")
ylabel("Torque ($N\cdot m$)", "Interpreter","latex")
legend("Measured Data", "Modeled Data $\;\;T = 0.3058 \times I + 0.1071$ ", "Interpreter","latex")