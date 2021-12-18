function [Gray] = RGB2Gray(RGB_data)
R_data = RGB_data(:,:,1);
G_data = RGB_data(:,:,2);
B_data = RGB_data(:,:,3);

[row,col,~] = size(RGB_data);
Y = zeros(row,col);

for r = 1:row
    for c = 1:col
        Y(r, c) = 0.299*R_data(r, c) + 0.587*G_data(r, c) + 0.114*B_data(r, c);
    end
end
Gray = uint8(Y);
end

