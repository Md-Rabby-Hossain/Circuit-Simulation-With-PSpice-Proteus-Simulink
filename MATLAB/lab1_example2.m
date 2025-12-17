z1=3+i*4;
z2=5+i*2;
argument =deg2rad(60); 
z3=2*(cos(argument)+1i*sin(argument));
z4=3+i*6;
z5=1+i*2;

z = ((z1*z2*z3)/(z4*z5));
z

r = abs(z);
theta = rad2deg(angle(z));
fprintf('Polar form of z = %.3f ∠ %.2f°\n', r, theta);
