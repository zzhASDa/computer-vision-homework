clc;
clear;
pic1 = imread("1.png");
pic2 = imread("2.png");
pic1 = rgb2gray(pic1);
pic2 = rgb2gray(pic2);
[descr1,loca1] = sift(pic1);
[descr2,loca2] = sift(pic2);
matched = myMatch(descr1,descr2);
drawFeatures(pic1,loca1);
drawFeatures(pic2,loca2);
drawMatched(matched,pic1,pic2,loca1,loca2);


