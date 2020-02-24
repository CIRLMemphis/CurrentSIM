function im = imTunable(zz, dZ, omegaZ, phizDeg, m, Nslits)
if (nargin < 6)
    Nslits = 3;
end
if (m == 2)
    im = Visibility(zz*dZ, omegaZ, Nslits, pi*phizDeg/180);
elseif (m == 1)
    im = ones(size(zz));
end
end