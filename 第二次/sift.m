function [descr,loca] = sift(pic)
pic = im2double(pic);
S = 3;
K = 2^(1/S);
border = 5;
sigma0 = 1.6;
sigma = ones(1,S+3);
sigma(1) = sigma0;
sigma(2) = sigma0*sqrt(K*K-1);
for i = 3:S+3
    sigma(i) = sigma(i-1)*K;
end
pic = imresize(pic, 2);
pic = Filter(pic, sqrt(sigma0^2-4*0.5^2));
octvs = floor(log( min(size(pic)) )/log(2) - 2);

GaussPyr = cell(octvs,1);
pic_size = zeros(octvs, 2);
pic_size(1,:) = size(pic);
GaussPyr{1} = zeros(pic_size(1,1),pic_size(1,2),S+3);
for i = 2:octvs
    pic_size(i,:) = [round(pic_size(i-1,1)/2),round(pic_size(i-1,2)/2)];
    GaussPyr{i} = zeros(pic_size(i,1),pic_size(i,2),S+3);
end

for i = 1:octvs
    for j = 1:S+3
        if i==1 && j==1
            GaussPyr{i}(:,:,j) = pic;
        elseif j==1
            GaussPyr{i}(:,:,j) = imresize(GaussPyr{i-1}(:,:,S+1),0.5);
        else
            GaussPyr{i}(:,:,j) = Filter(GaussPyr{i}(:,:,j-1),sigma(j));
        end
    end
end

DogPyr = cell(octvs,1);
for i = 1:octvs
    DogPyr{i} = zeros(pic_size(i,1),pic_size(i,2),S+2);
    for j = 1:S+2
        DogPyr{i}(:,:,j) = GaussPyr{i}(:,:,j+1)-GaussPyr{i}(:,:,j);
    end
end


gama = 10;
keyPoint = struct('x',0,'y',0,'s',0,'octv',0);
index = 0;
for i = 1:octvs
    for j = 2:S+1
        tempPic = DogPyr{i};
        for x = border+1:pic_size(i,1)-border
            for y = border+1:pic_size(i,2)-border
                if (isExtremum(x,y,j))
                    point = adjust(x,y,j,tempPic,S,i,border);
                    if (~isempty(point))
                        if(~isEdge(x,y,j))
                            index = index + 1;
                            keyPoint(index) = point;
                        end
                    end
                end
            end
        end
    end
end


function [ flag ] = isExtremum(x,y,s)
% Function: Find Extrema in 26 neighboring pixels
    value = tempPic(x,y,s);
    tempBlock = tempPic(x-1:x+1,y-1:y+1,j-1:j+1);
    if ( value > 0 && value == max(tempBlock(:)) )
        flag = 1;
    elseif ( value == min(tempBlock(:)) )
        flag = 1;
    else
        flag = 0;
    end
end
function[flag] = isEdge(x,y,s)
    center = tempPic(x,y,s);
    dxx = tempPic(x+1,y,s)+tempPic(x-1,y,s)-2*center;
    dyy = tempPic(x,y+1,s)+tempPic(x,y-1,s)-2*center;
    dxy = (tempPic(x+1,y+1,s)+tempPic(x-1,y-1,s)-tempPic(x+1,y-1,s)-tempPic(x-1,y+1,s))/4;
    
    tr = dxx+dyy;
    det = dxx*dyy - dxy*dxy;
    
    if det <=0 
        flag = 1;
    elseif (tr^2/det < (1+gama)^2/gama)
        flag = 0;
    else
        flag = 1;
    end
end

%计算梯度和角度并产生描述子

[descr,loca] = process(keyPoint,GaussPyr,sigma,pic_size);


end










