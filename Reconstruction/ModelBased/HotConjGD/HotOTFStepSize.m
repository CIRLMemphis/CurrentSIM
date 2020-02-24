function [top, bot] = HotOTFStepSize(top, bot, d, diff, h, OTF, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
if (nargin < 20)
    isWF = 0;
end
[X, Y, Z] = size(diff);
A = zeros(Y, X, Z);
if isWF
    A = A + 5*real(IFT( FT(d) .* ...
                        OTF(:,:,:,1) ));
else
    for m = 1:Nm
        A = A + real(IFT( FT(d.*jmFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)) .* ...
                          OTF(:,:,:,m) ));
    end
end
bot = bot + dot(A(:), A(:));
top = top + dot(A(:), diff(:)); 
end