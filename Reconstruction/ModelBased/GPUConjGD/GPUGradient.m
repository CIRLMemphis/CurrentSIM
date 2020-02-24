function curGrad = GPUGradient(curGrad, diff, hGPU, imGPUFunc, jmGPUFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg)
for m = 1:Nm
    temp    = fftshift(diff);
    temp    = fftn(temp);
    temp    = fftshift(temp);
    temp    = temp.*conj(fftshift(fftn(fftshift(hGPU.*imGPUFunc(zz, dZ, omegaZ, phizDeg, m)))));
    temp    = ifftshift(temp);
    temp    = ifftn(temp);
    temp    = ifftshift(temp);
    temp    = temp.*conj(jmGPUFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m));
    curGrad = curGrad + gather(temp); clear temp;
end
end