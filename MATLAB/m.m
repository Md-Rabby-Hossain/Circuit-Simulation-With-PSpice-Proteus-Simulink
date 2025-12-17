function rt = m(coef);
    a = coef(1);
    b = coef(2);
    c = coef(3);

    int = b^2 - 4*a*c;

    if int>0
        stint = sqrt(int);
        x1 = (-b +stint)/(2*a);
        x2 = (-b-stint)/(2*a);
    elseif int == 0
        x1 = -b/(2*a);
        x2 = x1;
    else
        stint = sqrt(-int);
        p1 = -b/(2*a);
        p2 = stint/(2*a);
        x1 = p1+p2*1i;
        x2 = p1-p2*1i;
    end
    rt = [x1,x2];
end