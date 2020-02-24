function [top, bot] = GPUStepSize(top, bot, dir, diff, hGPU, imGPUFunc, jmGPUFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg)
[X, Y, Z] = size(diff);
A = zeros(Y, X, Z, 'gpuArray');
for m = 1:Nm
    temp = gpuArray(dir).*jmGPUFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m);
    temp = fftshift(temp);
    temp = fftn(temp);
    temp = fftshift(temp);
    temp = temp.*fftshift(fftn(fftshift(hGPU.*imGPUFunc(zz, dZ, omegaZ, phizDeg, m))));
    temp = ifftshift(temp);
    temp = ifftn(temp);
    temp = ifftshift(temp);
    A = A + real(temp); clear temp;
end
bot = bot + dot(A(:), A(:));
top = top + dot(A(:), diff(:)); 
clear A;
end