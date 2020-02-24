function jm = jm3W(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)
phi   = pi*phiDeg/180;
offs  = pi*offDeg/180;
theta = pi*thetaDeg/180;
if (m == 2)
    jm = 2/3*cos( 2*pi*omegaXY*(cos(theta)*yy + sin(theta)*xx)*dXY + phi + offs );
elseif (m == 3)
    jm = 4/3*cos((2*pi*omegaXY*(cos(theta)*yy + sin(theta)*xx)*dXY + phi + offs)/2);
elseif (m == 1)
    jm = ones(size(xx));
end
end