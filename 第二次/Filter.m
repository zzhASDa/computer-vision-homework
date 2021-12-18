function [result] = Filter(pic, sigma)
size = 6*sigma+1;
size = round(size);
if mod(size,2) == 0
    size = size + 1;
end
core = fspecial('gaussian',size,sigma);
result = conv2(pic,core,'same');
end

