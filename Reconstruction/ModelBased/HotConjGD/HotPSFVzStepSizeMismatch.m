function [top, bot] = HotPSFVzStepSizeMismatch(top, bot, d, diff, h, vz, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
[X, Y, Z] = size(diff);
A = zeros(Y, X, Z);
    for m = 1:Nm
        A = A + real(IFT( FT(d.*jmFunc(xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, m, vz(:,:,:,m))) .* ...
                          FT(h) ));
    end
bot = bot + dot(A(:), A(:));
top = top + dot(A(:), diff(:)); 
end