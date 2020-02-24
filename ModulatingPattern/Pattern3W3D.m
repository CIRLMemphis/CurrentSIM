% see section [TODO] in the documentation
function [im, jm, Nm] = Pattern3W3D(X, Y, Z, omegaXY, omegaZ, dXY, dZ, phiDeg, offsDeg, thetaDeg, phizDeg)
[yy, xx] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1);
zz       = 0 : 1 : Z-1;

Nm    = 3;            % 3W 3D has 3 components
phi   = pi*phiDeg/180;
offs  = pi*offsDeg/180;
theta = pi*thetaDeg/180;
phiz  = pi*phizDeg/180;
Nphi  = length(phi);
Nthe  = length(theta);
im    = ones(1,1,Z,Nthe,Nphi,Nm);
jm    = ones(X,Y,1,Nthe,Nphi,Nm);

for l = 1:Nthe
    xy              = 2*pi*omegaXY(l)*(cos(theta(l))*yy + sin(theta(l))*xx)*dXY;
    im(1,1,:,l,:,3) = repmat(cos( 2*pi*omegaZ(l)*zz*dZ + phiz), [1 1 1 1 Nphi]);
    for k = 1:Nphi
        jm(:,:,1,l,k,2) = 2/3*cos( xy + phi(k) + offs(l));
        jm(:,:,1,l,k,3) = 4/3*cos((xy + phi(k) + offs(l))/2);
    end
end