function [] = drawFeatures( img, loc )
% Function: Draw sift feature points
figure;
imshow(img);
hold on;
plot(loc(:,2),loc(:,1),'+g');
end