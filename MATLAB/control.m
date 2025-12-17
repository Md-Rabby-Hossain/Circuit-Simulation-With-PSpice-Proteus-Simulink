coef = [2 -4 -5];
function rt=rt_quad(coef)
a = coef(1); 
b = coef(2); 
c = coef(3);

int = b^2-4*a*c;
if int>0
    srint = sqrt(int);
    x1 = (-b+srint)/(2*a);
    x2 = (-b-srint)/(2*a);
elseif int == 0
    x1 = -b / (2*a);
    x2 = x1;

else
    srint= sqrt(-int); 
    p1 = -b/(2*a); 
    p2 = srint/(2*a);
    x1 = p1+p2*j; 
    x2 = p1-p2*j;
end
rt = [x1, x2];
end

