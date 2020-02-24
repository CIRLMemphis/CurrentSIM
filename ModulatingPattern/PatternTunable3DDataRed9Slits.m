% see section [TODO] in the documentation
function [im, jm, Nm] = PatternTunable3DDataRed9Slits(X, Y, Z, omegaXY, omegaZ, dXY, dZ, thePhiDeg, phizDeg)
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);
Nm     = 2;            % 3-slit tunable SIM has 2 pattern components
thePhi = pi*thePhiDeg/180;
phiz   = pi*phizDeg/180;
Npt    = length(thePhi);
im     = ones(X,Y,Z,Npt,Nm);
jm     = ones(X,Y,Z,Npt,Nm);

for lk = 1:Npt
    xy    = 2*pi*omegaXY(1)*(cos(thePhi(lk,1))*yy + sin(thePhi(lk,1))*xx)*dXY;
    im(:,:,:,lk,2) = (1 +...
                      2*cos(4 *pi*omegaZ(1)*zz*dZ + 2*phiz) +...
                      2*cos(8 *pi*omegaZ(1)*zz*dZ + 4*phiz) +...
                      2*cos(12*pi*omegaZ(1)*zz*dZ + 6*phiz) +...
                      2*cos(16*pi*omegaZ(1)*zz*dZ + 8*phiz))/9;
    jm(:,:,:,lk,2) = cos(xy + thePhi(lk,2));
end