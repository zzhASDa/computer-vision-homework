function [result] = connect(grad_NMS)
[row,col] = size(grad_NMS);
result = zeros(row,col);
high = 30;
low = 10;
dx = [0,0,1,-1,1,1,-1,-1];
dy = [1,-1,0,0,1,-1,1,-1];
for r=2:row-1
    for c=2:col-1
        if grad_NMS(r,c) > high
            result(r,c) = 255;
            for i=1:8
                if grad_NMS(r+dx(i),c+dy(i)) > low
                   result(r+dx(i),c+dy(i)) = 255;
                else
                   result(r+dx(i),c+dy(i)) = 0;
                end
            end
        end
    end
end

