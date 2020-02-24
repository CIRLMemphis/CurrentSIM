function jm = jm3WGPU(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)
phi   = pi*phiDeg/180;
offs  = pi*offDeg/180;
theta = pi*thetaDeg/180;
if (m == 2)
    jm = 2/3*cos( 2*pi*omegaXY*(gpuArray(cos(theta)*yy + sin(theta)*xx))*dXY + phi + offs );
elseif (m == 3)
    jm = 4/3*cos((2*pi*omegaXY*(gpuArray(cos(theta)*yy + sin(theta)*xx))*dXY + phi)/2 + offs);
elseif (m == 1)
    jm = gpuArray(ones(size(xx)));
end
end