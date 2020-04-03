function curGrad = HotPSFVzGradientMismatch(curGrad, diff, h, vz, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
for m = 1:Nm
    curGrad = curGrad + conj(jmFunc(xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, m, vz(:,:,:,m))).* ...
              IFT( conj(FT(h)) .* FT(diff) );
end
end