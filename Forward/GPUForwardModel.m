function G = GPUForwardModel(obGPU, hGPU, imGPUFunc, jmGPUFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg)
G = gpuArray(zeros(size(obGPU)));
for m = 1:Nm
    temp  = imGPUFunc(zz, dZ, omegaZ, phizDeg, m);
    temp  = hGPU.*temp;
    temp  = fftshift(temp);
    temp  = fftn(temp);
    temp  = fftshift(temp);
    temp2 = jmGPUFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m);
    temp2 = obGPU.*temp2;
    temp2 = fftshift(temp2);
    temp2 = fftn(temp2);
    temp2 = fftshift(temp2);
    temp  = temp.*temp2;
    G     = G + temp; clear temp; clear temp2;
end
G = ifftshift(G);
G = ifftn(G);
G = ifftshift(G);
G = real(G);
end