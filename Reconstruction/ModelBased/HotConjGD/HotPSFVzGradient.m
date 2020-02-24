function curGrad = HotPSFVzGradient(curGrad, diff, h, vz, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
if (nargin < 18)
    isWF = 0;
end
if isWF
    curGrad = curGrad + ...
              5*IFT( conj(FT(h.*vz(:,:,:,1))) .* FT(diff) );
    return
end
for m = 1:Nm
    curGrad = curGrad + conj(jmFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)).* ...
              IFT( conj(FT(h.*vz(:,:,:,m))) .* FT(diff) );
end
end