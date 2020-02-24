function im = imTunableGPU(zz, dZ, omegaZ, phizDeg, m)
if (m == 2)
    im = gpuArray((1 + 2*cos(4*pi*omegaZ*zz*dZ + 2*pi*phizDeg/180))/3);
elseif (m == 1)
    im = gpuArray(ones(size(zz)));
end
end