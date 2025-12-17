t = [0:1:6];
m = 1;
A = 10;
f = 1000;
c = A.*cos(2.*pi.*f.*t);
s = A.*cos(2.*pi.*f.*t +pi.*m);
for 
subplot(3,1,1)
plot(t,m);

subplot(3,1,2)
plot(c);

subplot(3,1,3);
plot(s);