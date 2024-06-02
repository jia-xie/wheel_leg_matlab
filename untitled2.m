x_leg = -16.89; 
y_leg = 174.34;

x_body = -25.69;
y_body = 326.12;

xB = -21.94;
yB = 280.52;

xA = -9.7;
yA = 92.85;

L_R1 = sqrt((xA-x_leg)^2+(yA-y_leg)^2)/1000;
L_R2 = sqrt((xB-x_leg)^2+(yB-y_leg)^2)/1000;
L1 = (L_R1 + L_R2)/1000;
L2 = (y_body - yB)/1000;