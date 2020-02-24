function [top, bot] = HotPSFVzStepSize(top, bot, d, diff, h, vz, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
if (nargin < 20)
    isWF = 0;
end
[X, Y, Z] = size(diff);
A = zeros(Y, X, Z);
if isWF
    A = A + 5*real(IFT( FT(d) .* ...
                        FT(h.*vz(:,:,:,1)) ));
else
    for m = 1:Nm
        A = A + real(IFT( FT(d.*jmFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)) .* ...
                          FT(h.*vz(:,:,:,m)) ));
    end
end
bot = bot + dot(A(:), A(:));
top = top + dot(A(:), diff(:)); 
end