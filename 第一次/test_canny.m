clc;
clear;
RGB_data = imread('lena.jpg');

grayPic = RGB2Gray(RGB_data);
grayPic_f = Gaussfilter(grayPic);

[grad_x,grad_y,angle] = sobel(grayPic);
grad = abs(grad_x)+abs(grad_y);

grad_NMS = NMS(grad,angle);
canny_Img = connect(grad_NMS);

figure;
%subplot(2,3,1);
imshow(RGB_data);
title("原图");
figure;
%subplot(2,3,2);
imshow(grayPic);
title("灰度图");
figure;
%subplot(2,3,3);
imshow(grayPic_f);
title("滤波后灰度图");
figure;
%subplot(2,3,4);
imshow(grad);
title("梯度");
figure;
%subplot(2,3,5);
imshow(grad_NMS);
title("非极大值抑制");
figure;
%subplot(2,3,6);
imshow(canny_Img);
title("连接后结果");
