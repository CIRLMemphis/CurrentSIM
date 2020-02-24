function [top, bot] = HotStepSizeMismatch(top, bot, d, diff, h, imFunc, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg)
[X, Y, Z] = size(diff);
A = zeros(Y, X, Z);
    for m = 1:Nm
        A = A + real(IFT( FT(d.*jmFunc(xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, m, imFunc)) .* ...
                          FT(h) ));
    end
bot = bot + dot(A(:), A(:));
top = top + dot(A(:), diff(:)); 
end