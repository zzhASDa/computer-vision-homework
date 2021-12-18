function [result] = RANSC(loca1,loca2,match)
index = find(match~=0);
num = size(index,2);
times = 10000;
MAX = 0;
for i = 1 : times
    %每次选四个配对点
    fit = 0;
    r = randi(num,[1,4]);
    
%     x1 = loca1(index(1,r),1);
%     y1 = loca1(index(1,r),2);
    x2 = loca2(match(1,index(1,r)),1);
    y2 = loca2(match(1,index(1,r)),2);
    xy1 = loca1(index(1,r),:);
    
    A = zeros(8,9);
    A(1:2:7,1:2) = xy1;
   
%     A(1:2:7,1) = x1;
%     A(1:2:7,2) = y1;
    
    A(1:2:7,3) = 1;
    A(2:2:8,4:5) = xy1;
%     A(2:2:8,4) = x1;
%     A(2:2:8,5) = y1;
    A(2:2:8,6) = 1;
    A(1:2:7,7:8) = -x2.*xy1;
%     A(1:2:7,7) = -x2.*x1;
%     A(1:2:7,8) = -x2.*y1;
    A(1:2:7,7:8) = -y2.*xy1;
%     A(2:2:8,7) = -y2.*x1;
%     A(2:2:8,8) = -y2.*y1;
    A(1:2:7,9) = -x2;
    A(2:2:8,9) = -y2;
    [evec,~] = eig(A'*A);
    H = reshape(evec(:,1),[3,3])';
    H = H/H(end);
    
    for j = 1 : num
        if Fit(loca1(index(j),:), loca2(match(index(j)),:), H)
            fit = fit + 1;
        end
    end
    
    if fit > MAX
        MAX = fit;
        result = H;
    end
    
end
end

