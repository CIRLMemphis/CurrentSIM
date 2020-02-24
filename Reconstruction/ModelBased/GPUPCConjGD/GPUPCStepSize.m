function alpha = GPUPCStepSize(ForwardModelFct, g0, dir, xi, hGPU, imGPUFunc, jmGPUFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg)
[~, ~, ~, Nthe, Nphi] = size(g0);
[X, Y, Z] = size(xi);
AA = 0;
BB = 0;
CC = 0;
DD = 0;
for l = 1:Nthe
    for k = 1:Nphi
        A1 = zeros(Y, X, Z);
        A2 = zeros(Y, X, Z);
        A3 = zeros(Y, X, Z);
        for m = 1:Nm
            temp = xi.*xi.*jmGPUFunc(xx, yy, dXY, omegaXY(l), thetaDeg(l), phiDeg(k), offDeg(l), m);
            temp = fftshift(temp);
            temp = fftn(temp);
            temp = fftshift(temp);
            temp = temp.*fftshift(fftn(fftshift(hGPU.*imGPUFunc(zz, dZ, omegaZ(l), phizDeg, m))));
            temp = ifftshift(temp);
            temp = ifftn(temp);
            temp = ifftshift(temp);
            A1   = A1 + real(temp); clear temp;

            temp = dir.*xi.*jmGPUFunc(xx, yy, dXY, omegaXY(l), thetaDeg(l), phiDeg(k), offDeg(l), m);
            temp = fftshift(temp);
            temp = fftn(temp);
            temp = fftshift(temp);
            temp = temp.*fftshift(fftn(fftshift(hGPU.*imGPUFunc(zz, dZ, omegaZ(l), phizDeg, m))));
            temp = ifftshift(temp);
            temp = ifftn(temp);
            temp = ifftshift(temp);
            A2   = A2 - real(temp); clear temp;
            
            temp = dir.*dir.*jmGPUFunc(xx, yy, dXY, omegaXY(l), thetaDeg(l), phiDeg(k), offDeg(l), m);
            temp = fftshift(temp);
            temp = fftn(temp);
            temp = fftshift(temp);
            temp = temp.*fftshift(fftn(fftshift(hGPU.*imGPUFunc(zz, dZ, omegaZ(l), phizDeg, m))));
            temp = ifftshift(temp);
            temp = ifftn(temp);
            temp = ifftshift(temp);
            A3   = A3 - real(temp); clear temp;
        end
        A1 = DataUpSampling(-A1, g0(:,:,:,l,k));
        AA = AA +   dot(A3(:), A3(:));
        BB = BB +   dot(A3(:), A2(:));
        CC = CC + 2*dot(A2(:), A2(:)) + dot(A1(:), A3(:));
        DD = DD +   dot(A1(:), A2(:));
        clear A1; clear A2; clear A3;
    end
end
AA =  4*gather(AA);
BB = 12*gather(BB);
CC =  4*gather(CC);
DD =  4*gather(DD);

loc_alpha  = roots([ AA BB CC DD ]);
cost_alpha = zeros(length(loc_alpha),1);
for loc = 1:length(loc_alpha)
    cost_alpha(loc) = 0;
    for l = 1:Nthe
        for k = 1:Nphi
            diff = ForwardModelFct((xi + loc_alpha(loc)*dir).^2, hGPU, @im3WGPU, @jm3WGPU, Nm, xx,     ...
                                   yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), thetaDeg(l), ...
                                   phiDeg(k), offDeg(l), phizDeg);
            diff = DataUpSampling(-diff, gpuArray(g0(:,:,:,l,k)));
            cost_alpha(loc) = cost_alpha(loc) + gather(dot(diff(:), diff(:))); clear diff;
        end
    end
end

[~, ind] = min(real(cost_alpha));
alpha    = loc_alpha(ind);
end
