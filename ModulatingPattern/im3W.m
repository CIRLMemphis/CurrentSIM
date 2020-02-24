function im = im3W(zz, dZ, omegaZ, phizDeg, m)
if (m == 3)
    im = cos( 2*pi*omegaZ*zz*dZ + pi*phizDeg/180);
elseif (m == 1 || m == 2)
    im = ones(size(zz));
end
end