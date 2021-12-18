function [flag] = Fit(loca1, loca2, H)
delta = 20;
flag = 0;
x = [loca1(1),loca1(2), 1]';
x_r = [loca2(1), loca2(2), 1]';
pred = H*x;

if sum(abs(x_r - pred)) < delta
    flag = 1;
end

end

