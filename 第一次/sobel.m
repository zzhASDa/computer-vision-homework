function [grad_x,grad_y,angle,sobel_Img] = sobel(grayPic)
[row, col] = size(grayPic);
grad_x = zeros(row,col);
grad_y = zeros(row,col);
angle = zeros(row,col);
sobel_Img = zeros(row,col);
threshold = 127;
grayPic = double(grayPic);
for r = 2:row-1
    for c = 2:col-1
        gradx = grayPic(r-1,c+1) + 2*grayPic(r,c+1) + grayPic(r+1,c+1) - grayPic(r-1,c-1) - 2*grayPic(r,c-1) - grayPic(r+1,c-1);
        grady = grayPic(r-1,c-1) + 2*grayPic(r-1,c) + grayPic(r-1,c+1) - grayPic(r+1,c-1) - 2*grayPic(r+1,c) - grayPic(r+1,c+1);
        grad = abs(gradx) + abs(grady);
        
        if(grad > threshold)
            grad_x(r,c) = gradx;
            grad_y(r,c) = grady;
            if grad_x(r,c)==0
                angle(r,c) = pi/2;
            else
                angle(r,c) = atan(double(grad_y(r,c))/double(grad_x(r,c)));
            end
                sobel_Img(r,c)=255;
         else
            sobel_Img(r,c)=0;
         end
    end
end
grad_x = grad_x/8;
grad_y = grad_y/8;
end

