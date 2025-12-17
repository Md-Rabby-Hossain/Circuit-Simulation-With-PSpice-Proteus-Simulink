Il = 3;
Il1 = 5;
Il2 = 7;
Io = 10e-12;
n = 1;
k = 1.38e-23;
e = 1.6e-19;
v=[0:0.1:2];
t = 300;
I = Il-Io*(exp((e.*v)/(n*k*t))-1);

figure;
subplot(3,1,1)
plot(v,I, 'LineWidth', 1.5);
legend('I(V) for I_{l}=3');
title('I_V Curve of a solar cell under different illumination');

subplot(3,1,2)

I1 = Il1-Io*(exp((e.*v)/(n*k*t))-1);
plot(v,I1, 'LineWidth', 1.5);
legend('I(V) for I_{l}=5');

subplot(3,1,3)
I2 = Il2-Io*(exp((e.*v)/(n*k*t))-1);
plot(v,I2, 'LineWidth', 1.5);
legend('I(V) for I_{l}=7');

figure
semilogy(v,I)