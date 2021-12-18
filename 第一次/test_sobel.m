clc;
clear;

RGB_data = imread('lena.jpg');%
grayPic = rgb2gray(RGB_data);
[grad_x,grad_y,angle,sobel_Img] = sobel(grayPic);

figure;
%subplot(2,3,1);
imshow(RGB_data);
title("原图");
%subplot(2,3,2);
figure;
imshow(grayPic);
title("灰度图");
%subplot(2,3,3);
figure;
imshow(sobel_Img);
title("边缘");
%subplot(2,3,4);
figure;
imagesc(grad_x);
colorbar,title("x方向梯度");
%subplot(2,3,5);
figure;
imagesc(grad_y);
colorbar,title("y方向梯度");
%subplot(2,3,6);
figure;
imagesc(angle);
colorbar,title("角度");

