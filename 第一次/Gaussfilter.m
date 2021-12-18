function [grayPic_f] = Gaussfilter(grayPic)
gauss_core = [1,4,7,4,1;
              4,16,26,16,4;
              7,26,41,26,7;
              4,16,26,16,4;
              1,4,7,4,1;];
gauss_core = double(gauss_core);
[row,col] = size(grayPic);
grayPic = double(grayPic);
grayPic_f = grayPic;
for r = 3:row-2
    for c = 3:col-2
        grayPic_f(r,c) = sum(sum(gauss_core.*grayPic(r-2:r+2,c-2:c+2)),2)/273;
    end
end
grayPic_f = uint8(grayPic_f);
end

