function ret = ZeroFreqDamp3D(in3D,X,Y,Z,xyOff,zOff,dXY,dZ,A,sigma)
[yy, xx, zz] = meshgrid(1:1:Y, 1:1:X, 1:1:Z);
xMid   = 1+X/2;
yMid   = 1+Y/2;
if mod(Z, 2) == 0
    zMid   = 1+Z/2;
else
    zMid = round(Z/2);
end

radius = sqrt(((sqrt((xx-xMid).^2 + (yy-yMid).^2) - xyOff)/X/dXY).^2 + ((abs(zz - zMid) - zOff)/Z/dZ).^2);
damp   = 1 - A*exp(-radius./sigma^2);
ret    = in3D.*damp;
end