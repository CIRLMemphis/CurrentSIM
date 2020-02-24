% see section [TODO] in the documentation
function [im, jm, Nm] = DRPattern3W3D(X, Y, Z, omegaXY, omegaZ, dXY, dZ, thePhiDeg, phizDeg)
[yy, xx] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1);
zz       = 0 : 1 : Z-1;
Nm     = 3;            % 3W 3D has 3 components
thePhi = pi*thePhiDeg/180;
phiz   = pi*phizDeg/180;
Npt    = length(thePhi);
im     = ones(1,1,Z,Npt,Nm);
jm     = ones(X,Y,1,Npt,Nm);

for lk = 1:Npt
    xy  = 2*pi*omegaXY(1)*(cos(thePhi(lk,1))*yy + sin(thePhi(lk,1))*xx)*dXY;
    im(:,:,:,lk,3) = cos( 2*pi*omegaZ(1)*zz*dZ + phiz);
    jm(:,:,:,lk,2) = 2/3*cos( xy + thePhi(lk,2)   );
    jm(:,:,:,lk,3) = 4/3*cos((xy + thePhi(lk,2))/2);
end