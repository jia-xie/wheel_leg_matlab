joint = zeros(4, 1000);
ang = linspace(-10, 190, 1000);
leg = linspace(0, 0.38, 100);
error = zeros(100);
leg_error  = zeros(100);
for j = 1:100
    for i = 1:1000
        angle = ang(i);
        leg_len = leg(j);
        try
            joint(:, i) = inverse_kinematics(leg_len, angle, 0.07, 0.14, 0.24);
            error(j) = angle;
            leg_error(j) = leg_len;
            break
        catch
            
        end
    end
end


hold on
title("range of inverse kinematics");

scatter(leg_error, error, '.');
y = 200 * leg + 12;
plot(leg, y);