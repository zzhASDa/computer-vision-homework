clear
tic
img1 = imread('1.png');
img1 = rgb2gray(img1);
img2 = imread('2.png');
img2 = rgb2gray(img2);
[des1,loc1] = getFeatures(img1);
[des2,loc2] = getFeatures(img2);
matched = match(des1,des2);
H = RANSC(loc1,loc2,matched)
img = appendImg(img1, img2, H);
imshow(img);
drawFeatures(img1,loc1);
drawFeatures(img2,loc2);
drawMatched(matched,img1,img2,loc1,loc2, H);
toc