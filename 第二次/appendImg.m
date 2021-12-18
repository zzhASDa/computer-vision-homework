function [img] = appendImg(img1, img2, H)
[row1,col1] = size(img1);
[row2,col2] = size(img2);

row = 3 * max(row1, row2);
col = 3 * max(col1, col2);

img = zeros(row, col);

cx = row / 3;
cy = col / 3;

img(1+cx:row1+cx,1+cy:col1+cy) = img1;

for i = 1 : row
    for j = 1 : col
        xy1 = [i-cx, j-cy, 1];
        xy2 = round(H*xy1');
        x = xy2(1);
        y = xy2(2);
        if x>=1 && x<=row2 && y>=1 && y<=col2
            if i<=cx || i>=cx+row1 || j<=cy || j>=cy+col1
                img(i, j) = img2(x, y);
            end
        end
    end
end

img(all(img==0,2),:) = [];
img(:,all(img==0,1)) = [];



img = uint8(img);

end

