function jm = jm3WTestMismatch(xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, m, Vz)
phi   = pi*phiDeg/180;
offs  = pi*offDeg/180;
theta = pi*thetaDeg/180;
if (m == 2)
    jm = 0.8*cos( 2*pi*omegaXY*(cos(theta)*yy + sin(theta)*xx)*dXY + phi + offs );
elseif (m == 3)
    jm = 0.8*cos((2*pi*omegaXY*(cos(theta)*yy + sin(theta)*xx)*dXY + phi + offs)/2).*...
             Vz;
elseif (m == 1)
    jm = ones(size(xx));
end
end