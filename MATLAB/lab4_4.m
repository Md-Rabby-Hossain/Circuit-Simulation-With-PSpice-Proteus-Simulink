x=[-3 -2 -1 0 1 2 3];
y = x.^2;
subplot(2,1,1);
plot(x,y,'g*:', 'LineWidth',2);
title('Figure 1');

subplot(2,1,2);
y2 = x+2;
plot(x, y2, 'ro-', 'LineWidth',2);
title('Figure 2');
