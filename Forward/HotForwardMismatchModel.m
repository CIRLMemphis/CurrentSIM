function G = HotForwardMismatchModel(ob, h, imFunc, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg)
G = zeros(size(ob));
for m = 1:Nm
    G = G + FT(ob.*jmFunc(xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, m, imFunc)).* ...
            FT(h);
end
G = real(IFT(G));
end