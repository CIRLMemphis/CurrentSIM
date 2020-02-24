% see section [TODO] in the documentation
function [im, jm, Nm] = DRPatternTunable3DNSlits(X, Y, Z, omegaXY, omegaZ, dXY, dZ, thePhiDeg, phizDeg, Nslits)
[yy, xx] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1);
zz       = 0 : 1 : Z-1;

Nm     = 2;            % 3-slit tunable SIM has 2 pattern components
thePhi = pi*thePhiDeg/180;
phiz   = pi*phizDeg/180;
Npt    = length(thePhi);
im     = ones(1,1,Z,Npt,Nm);
jm     = ones(X,Y,1,Npt,Nm);

for lk = 1:Npt
    xy             = 2*pi*omegaXY(1)*(cos(thePhi(lk,1))*yy + sin(thePhi(lk,1))*xx)*dXY;
    im(1,1,:,lk,2) = Visibility(zz*dZ, omegaZ(1), Nslits, phiz);
    jm(:,:,1,lk,2) = cos(xy + thePhi(lk,2));
end