function curGrad = HotGradient(curGrad, diff, h, imFunc, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
if (nargin < 18)
    isWF = 0;
end
if isWF
    curGrad = curGrad + ...
              5*IFT( conj(FT(h.*imFunc(zz, dZ, omegaZ, phizDeg, 1))) .* FT(diff) );
    return
end
for m = 1:Nm
    curGrad = curGrad + conj(jmFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)).* ...
              IFT( conj(FT(h.*imFunc(zz, dZ, omegaZ, phizDeg, m))) .* FT(diff) );
end
end