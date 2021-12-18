function [grad_NMS] = NMS(grad,angle)
[row,col] = size(grad);
grad_NMS = grad;
for r=2:row-1 
    for c=2:col-1
        if grad(r,c) ~= 0
            if angle(r,c)==pi/2
                if grad(r,c) < max(grad(r-1,c),grad(r+1,c))
                    grad_NMS(r,c) = 0;
                end
            elseif angle(r,c)==pi/4
                if grad(r,c) < max(grad(r-1,c+1),grad(r+1,c-1))
                    grad_NMS(r,c) = 0;
                end
            elseif angle(r,c)==0
                if grad(r,c) < max(grad(r,c+1),grad(r,c-1))
                    grad_NMS(r,c) = 0;
                end
            elseif angle(r,c)==-pi/4
                if grad(r,c) < max(grad(r-1,c-1),grad(r+1,c+1))
                    grad_NMS(r,c) = 0;
                end
            elseif (angle(r,c)<pi/2) && (angle(r,c)>pi/4)
                weight = (angle(r,c)-pi/4)/(pi/4);
                t1 = weight*grad(r-1,c)+(1-weight)*grad(r-1,c+1);
                t2 = weight*grad(r+1,c)+(1-weight)*grad(r+1,c-1);
                if grad(r,c) < max(t1,t2)
                    grad_NMS(r,c) = 0;
                end
            elseif (angle(r,c)<pi/4) && (angle(r,c)>0)
                weight = angle(r,c)/(pi/4);
                t1 = weight*grad(r-1,c+1)+(1-weight)*grad(r,c+1);
                t2 = weight*grad(r+1,c-1)+(1-weight)*grad(r,c-1);
                if grad(r,c) < max(t1,t2)
                    grad_NMS(r,c) = 0;
                end
            elseif (angle(r,c)>-pi/4) && (angle(r,c)<0)
                weight = angle(r,c)/(-pi/4);
                t1 = weight*grad(r+1,c+1)+(1-weight)*grad(r,c+1);
                t2 = weight*grad(r-1,c-1)+(1-weight)*grad(r,c-1);
                if grad(r,c) < max(t1,t2)
                    grad_NMS(r,c) = 0;
                end
            elseif (angle(r,c)>-pi/2) && (angle(r,c)<-pi/4)
                weight = (angle(r,c)+pi/4)/(-pi/4);
                t1 = weight*grad(r-1,c)+(1-weight)*grad(r-1,c+1);
                t2 = weight*grad(r+1,c)+(1-weight)*grad(r+1,c-1);
                if grad(r,c) < max(t1,t2)
                    grad_NMS(r,c) = 0;
                end
            end
        end
    end
end

