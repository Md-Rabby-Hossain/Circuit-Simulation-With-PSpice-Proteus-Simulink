x = 0:0.1:2;
y = 0:0.1:2;
[xx,yy] = meshgrid(x, y);
 zz=sin(xx.^2+yy.^2);
 surf(xx,yy,zz);
 xlabel('x values');
 ylabel('y values');
 zlabel('z values');