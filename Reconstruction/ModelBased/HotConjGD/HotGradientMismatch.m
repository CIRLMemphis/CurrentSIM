function curGrad = HotGradientMismatch(curGrad, diff, h, imFunc, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg)
for m = 1:Nm
    curGrad = curGrad + conj(jmFunc(xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, m, imFunc)).* ...
              IFT( conj(FT(h)) .* FT(diff) );
end
end