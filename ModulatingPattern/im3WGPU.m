function im = im3WGPU(zz, dZ, omegaZ, phizDeg, m)
if (m == 3)
    im = gpuArray(cos( 2*pi*omegaZ*zz*dZ + pi*phizDeg/180));
elseif (m == 1 || m == 2)
    im = gpuArray(ones(size(zz)));
end
end