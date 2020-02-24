function ret = ZeroFreqDamp2D(in2D,X,Y,xyOff,dXY,A,sigma)
[yy, xx] = meshgrid(1:1:Y, 1:1:X);
xMid   = 1+X/2;
yMid   = 1+Y/2;
radius = (sqrt((xx-xMid).^2 + (yy-yMid).^2) - xyOff)/X/dXY;
damp   = 1 - A*exp(-radius./sigma^2);
ret    = in2D.*damp;
end