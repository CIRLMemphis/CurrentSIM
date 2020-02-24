function G = HotForwardModel(ob, h, imFunc, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thetaDeg, phiDeg, offDeg, phizDeg, isWF)
if (nargin < 17)
    isWF = 0;
end

if isWF
    G = 5*real(IFT(FT(ob).*FT(h.*imFunc(zz, dZ, omegaZ, phizDeg, 1))));
    return
end

G = zeros(size(ob));
for m = 1:Nm
    G = G + FT(ob.*jmFunc(xx, yy, dXY, omegaXY, thetaDeg, phiDeg, offDeg, m)).* ...
            FT(h.*imFunc(zz, dZ, omegaZ, phizDeg, m));
end
G = real(IFT(G));
end