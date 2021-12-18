function [descr,loca] = process(keyPoint,GaussPyr,sigma,pic_size)

[~,len] = size(keyPoint);
loca = zeros(len,2);
descr = zeros(len,128);
Angle = [7*pi/8, 5*pi/8, 3*pi/8, pi/8, -pi/8, -3*pi/8, -5*pi/8, -7*pi/8];
keyPoint_angle = zeros(len,1);

%坐标转化
for i=1:len
    loca(i,1) = 2^(keyPoint(i).octv-2)*keyPoint(i).x;
    loca(i,2) = 2^(keyPoint(i).octv-2)*keyPoint(i).y;
end

%计算每个关键点角度
for i=1:len
    point = keyPoint(i);
    border = round(3*sigma(point.s));
    if mod(border,2) == 0
        border = border+1;
    end
    border = (border-1)/2;
    Grad = count(point.x-border,point.x+border,point.y-border,point.y+border,point.s,point.octv,0);
    [~,index] = max(Grad);
    keyPoint_angle(i) = Angle(index);
       
end

%计算描述子
for i=1:len
    point = keyPoint(i);
    Grad1 = count(point.x-7,point.x-4,point.y-7,point.y-4,point.s,point.octv,keyPoint_angle(i));
    Grad2 = count(point.x-7,point.x-4,point.y-3,point.y,point.s,point.octv,keyPoint_angle(i));
    Grad3 = count(point.x-7,point.x-4,point.y,point.y+3,point.s,point.octv,keyPoint_angle(i));
    Grad4 = count(point.x-7,point.x-4,point.y+4,point.y+7,point.s,point.octv,keyPoint_angle(i));
    Grad5 = count(point.x-3,point.x,point.y-7,point.y-4,point.s,point.octv,keyPoint_angle(i));
    Grad6 = count(point.x-3,point.x,point.y-3,point.y,point.s,point.octv,keyPoint_angle(i));
    Grad7 = count(point.x-3,point.x,point.y,point.y+3,point.s,point.octv,keyPoint_angle(i));
    Grad8 = count(point.x-3,point.x,point.y+4,point.y+7,point.s,point.octv,keyPoint_angle(i));
    Grad9 = count(point.x,point.x+3,point.y-7,point.y-4,point.s,point.octv,keyPoint_angle(i));
    Grad10 = count(point.x,point.x+3,point.y-3,point.y,point.s,point.octv,keyPoint_angle(i));
    Grad11 = count(point.x,point.x+3,point.y,point.y+3,point.s,point.octv,keyPoint_angle(i));
    Grad12 = count(point.x,point.x+3,point.y+4,point.y+7,point.s,point.octv,keyPoint_angle(i));
    Grad13 = count(point.x+4,point.x+7,point.y-7,point.y-4,point.s,point.octv,keyPoint_angle(i));
    Grad14 = count(point.x+4,point.x+7,point.y-3,point.y,point.s,point.octv,keyPoint_angle(i));
    Grad15 = count(point.x+4,point.x+7,point.y,point.y+3,point.s,point.octv,keyPoint_angle(i));
    Grad16 = count(point.x+4,point.x+7,point.y+4,point.y+7,point.s,point.octv,keyPoint_angle(i));
    descr(i,:) = [Grad1, Grad2, Grad3, Grad4, Grad5, Grad6, Grad7, Grad8, Grad9, Grad10, Grad11, Grad12, Grad13, Grad14, Grad15, Grad16];
    descr(i,:) = descr(i,:)/sum(descr(i,:));
end

function[grad,angle] = cal(x,y,s,octv)
    pic = GaussPyr{octv}(:,:,s);
    gx = pic(x+1,y)-pic(x-1,y);
    gy = pic(x,y+1)-pic(x,y-1);
    grad = sqrt(gx^2+gy^2);
        if gx == 0
            if gy>0
                angle = pi/2;
            else
                angle = -pi/2;
            end
        else
            angle = atan(gy/gx);
            if gx < 0
                angle = angle + pi;
            end
        end
end

function[Grad] = count(x1,x2,y1,y2,s,octv,delta)
    x1 = max(x1,2);
    x2 = min(x2,pic_size(octv,1)-1);
    y1 = max(y1,2);
    y2 = min(y2,pic_size(octv,2)-1);
    for x =x1:x2
        for y = y1:y2
            [grad,angle] = cal(x,y,s,octv);
            angle = angle - delta;
            if angle<-pi
                angle = angle + 2*pi;
            elseif angle > pi
                    angle = angle - 2*pi;
            end
            
            Grad = zeros(1,8);
            if angle<=pi && angle >3*pi/4
                Grad(1) = Grad(1) + grad;
            elseif angle<=3*pi/4 && angle>pi/2
                Grad(2) = Grad(2) + grad;
            elseif angle<=pi/2 && angle>pi/4
                Grad(3) = Grad(3) + grad;
            elseif angle<=pi/4 && angle>0
                Grad(4) = Grad(4) + grad;
            elseif angle<=0 && angle >-pi/4
                Grad(5) = Grad(5) + grad;
            elseif angle<=-pi/4 && angle>-pi/2
                Grad(6) = Grad(6) + grad;
            elseif angle<=-pi/2 && angle>-3*pi/4
                Grad(7) = Grad(7) + grad;
            else
                Grad(8) = Grad(8) + grad;
            end
        end
    end
end

end

