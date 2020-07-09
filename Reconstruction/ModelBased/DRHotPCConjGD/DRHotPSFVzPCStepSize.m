function curStepSize = DRHotPSFVzPCStepSize(ForwardModelFct, UpFct, g0, d, xi, h, vz, jmFunc, Nm, xx, yy, zz, dXY, dZ, omegaXY, omegaZ, thePhiOff, phizDeg, penalizationParam, isDRWF)
if(nargin < 19)
    penalizationParam = -1;
end
if (nargin < 20)
    isDRWF = 0;
end
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
        if isDRWF && lk == Npt
            FThim  = FT(h.*vz(:,:,:,1));
            A1     = A1 + 5*real(IFT( FT(xi.*xi) .* FThim ));
            A2     = A2 - 5*real(IFT( FT(d .*xi) .* FThim ));
            A3     = A3 - 5*real(IFT( FT(d .*d ) .* FThim ));
        else
            for m = 1:Nm
                jmTemp = jmFunc(xx, yy, dXY, omegaXY(1), thePhiOff(lk,1), thePhiOff(lk,2), thePhiOff(lk,3), m);
                FThim  = FT(h.*vz(:,:,:,m));
                A1     = A1 + real(IFT( FT(xi.*xi.*jmTemp) .* FThim ));
                A2     = A2 - real(IFT( FT(d .*xi.*jmTemp) .* FThim ));
                A3     = A3 - real(IFT( FT(d .*d .*jmTemp) .* FThim ));
            end
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

if penalizationParam ~= -1
    AA = AA + 4*penalizationParam*dot(d(:).^2,d(:).^2);
    BB = BB + 4*penalizationParam*3*dot(d(:).^2,d(:).*xi(:));
    CC = CC + 4*penalizationParam*(dot(xi(:).^2,d(:).^2) + 2*dot(xi(:).*d(:),xi(:).*d(:)));
    DD = DD + 4*penalizationParam*dot(xi(:).^2,xi(:).*d(:));
end

loc_alpha  = roots([ AA BB CC DD ]);
cost_alpha = zeros(length(loc_alpha),1);

for loc = 1:length(loc_alpha)
    if (isreal(loc_alpha(loc)))
        for lk = 1:Npt
            isWF = 0;	
            if isDRWF && (lk == Npt)	
                isWF = 1;	
            end
                diff = ForwardModelFct((xi + loc_alpha(loc)*d).^2, h, vz, jmFunc, Nm, xx,     ...
                                       yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhiOff(lk,1), ...
                                       thePhiOff(lk,2), thePhiOff(lk,3), phizDeg, isWF);
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