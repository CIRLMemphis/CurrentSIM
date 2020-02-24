function upData = DataUpSampling(upData, data3D)
[X,Y,Z] = size(data3D);
temp    = data3D;
temp    = fftshift(temp);
temp    = fftn(temp);
temp    = fftshift(temp);
temp    = padarray(temp,[Y/2 X/2 Z/2]);
temp    = ifftshift(temp);
temp    = ifftn(temp);
temp    = ifftshift(temp);
upData  = upData + real(temp); clear temp;
end