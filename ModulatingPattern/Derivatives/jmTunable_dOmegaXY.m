function jm = jmTunable_dOmegaXY(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)
phi   = pi*phiDeg/180;
offs  = pi*offDeg/180;
theta = pi*thetaDeg/180;
if (m == 2)
    jm = -sin(2*pi*omegaXY*(cos(theta)*yy + sin(theta)*xx)*dXY + phi + offs).*...
          (2*pi*(cos(theta)*yy + sin(theta)*xx)*dXY);
elseif (m == 1)
    jm = zeros(size(xx));
end
end