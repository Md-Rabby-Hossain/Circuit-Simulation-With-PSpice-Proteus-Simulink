hold on;
f = [20 40 80 100 120 2000 5000 8000 10000 12000 15000 20000];
g = [5 10 30 32 34 34 34 34 32 30 10 5];
g1 = [5 10 30 32 32 23 24 34 32 30 10 5];
semilogx(f,g, 'bo-');
title('Semilog Graph');
xlabel('Frequency(Hz)');
ylabel("Gain(dB)");

loglog(f,g1);
