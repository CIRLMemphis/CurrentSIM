function upData = UpSamplingNoZ(upData, data3D)
[X,Y,Z] = size(data3D);
upData  = upData + real(IFT(padarray(FT(data3D),[Y/2 X/2 0])));
end