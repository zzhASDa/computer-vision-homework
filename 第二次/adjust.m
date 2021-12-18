function [keyPoint] = adjust(x,y,s,pic,S1,octv,border)
i = 1;
times = 5;
[r,c] = size(pic);
while i <= times
    dx = (pic(x+1,y,s)-pic(x-1,y,s))/2;
    dy = (pic(x,y+1,s)-pic(x,y+1,s))/2;
    ds = (pic(x,y,s+1)-pic(x,y,s-1))/2;
    dxx = pic(x+1,y,s)+pic(x-1,y,s)-2*pic(x,y,s);
    dyy = pic(x,y+1,s)+pic(x,y-1,s)-2*pic(x,y,s);
    dss = pic(x,y,s+1)+pic(x,y,s-1)-2*pic(x,y,s);
    dxy = (pic(x+1,y+1,s)+pic(x-1,y-1,s)-pic(x-1,y+1,s)-pic(x+1,y-1,s))/4;
    dxs = (pic(x+1,y,s+1)+pic(x-1,y,s-1)-pic(x-1,y,s+1)-pic(x+1,y,s-1))/4;
    dys = (pic(x,y+1,s+1)+pic(x,y-1,s-1)-pic(x,y+1,s-1)-pic(x,y-1,s+1))/4;
    dD = [dx,dy,ds]';
    Hessian = [dxx,dxy,dxs;dxy,dyy,dys;dxs,dys,dss];
    %这下面看不懂
    [U,S,V] = svd(Hessian);
    T=S;
    T(S~=0) = 1./S(S~=0);
    svd_inv_H = V * T' * U';
    x_hat = - svd_inv_H*dD;
    
    if (abs(x_hat(1))<0.5) && (abs(x_hat(2))<0.5) && (abs(x_hat(3))<0.5)
        break;
    end
    x = x + round(x_hat(1));
    y = y + round(x_hat(2));
    s = s + round(x_hat(3));
    
    if (x <= border || x >= border || y <= border || y >= border || s < 2 || s > S1+1)
        keyPoint = [];
        return;
    end
    
    i = i + 1;
end

if i > times
    keyPoint = [];
    return;
end
if abs(pic(x,y,s)) < 0.04/S1
    keyPoint = [];
    return;
end

keyPoint.x = x;
keyPoint.y = y;
keyPoint.s = s;
keyPoint.octv = octv;

end

