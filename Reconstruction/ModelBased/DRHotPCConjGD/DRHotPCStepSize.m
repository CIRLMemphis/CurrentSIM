function curStepSize = DRHotPCStepSize(ForwardModelFct, UpFct, g0, d, xi, h, imFunc, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thePhiDeg, offDeg, phizDeg)
[~, ~, ~, Npt] = size(g0);
[X, Y, Z] = size(xi);
AA = 0;
BB = 0;
CC = 0;
DD = 0;
for lk = 1:Npt
        A1 = zeros(Y, X, Z);
        A2 = zeros(Y, X, Z);
        A3 = zeros(Y, X, Z);
        for m = 1:Nm
            jmTemp = jmFunc(xx, yy, dXY, omegaXY(1), thePhiDeg(lk,1), thePhiDeg(lk,2), offDeg(1), m);
            FThim  = FT(h.*imFunc(zz, dZ, omegaZ(1), phizDeg, m));
            A1     = A1 + real(IFT( FT(xi.*xi.*jmTemp) .* FThim ));
            A2     = A2 - real(IFT( FT(d .*xi.*jmTemp) .* FThim ));
            A3     = A3 - real(IFT( FT(d .*d .*jmTemp) .* FThim ));
        end
        A1 = UpFct(-A1, g0(:,:,:,lk));
        AA = AA +   dot(A3(:), A3(:));
        BB = BB +   dot(A3(:), A2(:));
        CC = CC + 2*dot(A2(:), A2(:)) + dot(A1(:), A3(:));
        DD = DD +   dot(A1(:), A2(:));
end
AA =  4*AA;
BB = 12*BB;
CC =  4*CC;
DD =  4*DD;

loc_alpha  = roots([ AA BB CC DD ]);
cost_alpha = zeros(length(loc_alpha),1);
for loc = 1:length(loc_alpha)
    if (isreal(loc_alpha(loc)))
        for lk = 1:Npt
                diff = ForwardModelFct((xi + loc_alpha(loc)*d).^2, h, imFunc, jmFunc, Nm, xx,     ...
                                       yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhiDeg(lk,1), ...
                                       thePhiDeg(lk,2), offDeg(1), phizDeg);
                diff = UpFct(-diff, g0(:,:,:,lk));
                cost_alpha(loc) = cost_alpha(loc) + dot(diff(:), diff(:));
        end
    else
        cost_alpha(loc) = realmax;
    end
end

[~, ind]    = min(cost_alpha);
curStepSize = loc_alpha(ind);
end