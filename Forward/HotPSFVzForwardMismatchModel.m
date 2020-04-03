function G = HotPSFVzForwardMismatchModel(ob, h, vz, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
G = zeros(size(ob));
for m = 1:Nm
    G = G + FT(ob.*jmFunc(xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, m, vz(:,:,:,m))).* ...
            FT(h);
end
G = real(IFT(G));
end