function [reconOb, retFig, retVars] = HotOneShotLBFGSBNoDouble(...
            ForwardFct, GradientFct, StepSizeFct, UpFct, imFct, jmFct,...
            g, h, dXY, dZ, Nm, omegaXY, omegaZ, theta, phi, offs, phiz, ...
            numIt, penalizationParam, initGuess, selectDir, picInterval, gTransform, ...
            A, sigma, GFilter)
fprintf('Call to %s\n',  mfilename);
tNow    = datestr(datetime(),'yyyymmddHHMMSS')
curFig  = tNow + ".jpg";
retFig  = [];
retVars = {};
DEBUG_DISPLAY = 1;

if(nargin < 18)
    numIt = 10;
end

if(nargin < 19 || isequal(penalizationParam , -1))
    penalizationParam = 1e-8;
end

if(nargin < 21 || isequal(selectDir , -1) )
    selectDir = 2;
end

if(nargin < 22)
    picInterval = -1;
end

if (nargin < 24)
    A       = -1;
    sigma   = -1;
    GFilter = -1;
end

% denoising the data if required
[Y, X, Z, Nthe, Nphi] = size(g);
if (A ~= -1 || length(GFilter) > 1)
    for l = 1:Nthe
        for k = 1:Nphi
            if (GFilter ~= -1)
                G = FT(g(:,:,:,l,k)).*GFilter;
            else
                G = FT(g(:,:,:,l,k));
            end
            if (A ~= -1)
                g(:,:,:,l,k) = abs(IFT(ZeroFreqDamp3D(G, X, Y, Z, dXY, dZ, A, sigma)));
            else
                g(:,:,:,l,k) = abs(IFT(G));
            end
        end
    end
end

% normalize the data and zero-padding
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);

initGuess = zeros(X,Y,Z);
for l = 1:Nthe
    for k = 1:Nphi
        initGuess = initGuess + g(:,:,:,l,k);
    end
end
initGuess = initGuess/(Nphi*Nthe);

    function [crit, grad] = costGrad(x)
        curOb   = reshape(x(1:end-6), Y,X,Z);
        gradOb  = zeros(X,Y,Z);
        gradPhi = zeros(3,1);
        gradOmegaXY = zeros(3,1);
        x(end-5:end)
        crit    = 0;
        for l = 1:Nthe
            for k = 1:Nphi
                curPhi     = x(X*Y*Z+k);
                curOmegaXY = x(X*Y*Z + Nphi + k);
                diffOb = g(:,:,:,l,k) - ForwardFct(curOb, h, imFct, jmFct, Nm, xx,     ...
                                                   yy, zz, dXY, dZ, curOmegaXY, omegaZ(l), theta(l), ...
                                                   curPhi, offs(l), phiz);
                gradOb = GradientFct( gradOb, diffOb, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, curOmegaXY, omegaZ(l), theta(l), ...
                                    curPhi, offs(l), phiz);
                dPhi = zeros(X,Y,Z);
                for m = 1:Nm
                    dPhi = dPhi + IFT(FT(curOb.*jmTunable_dPhi(xx, yy, dXY, curOmegaXY, theta(l), curPhi, offs(l), m)).* ...
                                      FT(h.*imFct(zz, dZ, omegaZ(l), phiz, m)));
                end
                dOmegaXY = zeros(X,Y,Z);
                for m = 1:Nm
                    dOmegaXY = dOmegaXY + IFT(FT(curOb.*jmTunable_dOmegaXY(xx, yy, dXY, curOmegaXY, theta(l), curPhi, offs(l), m)).* ...
                                              FT(h.*imFct(zz, dZ, omegaZ(l), phiz, m)));
                end
                gradPhi(k)     = gradPhi(k)     + dot(diffOb(:), dPhi(:));
                gradOmegaXY(k) = gradOmegaXY(k) + dot(diffOb(:), dOmegaXY(:));
                crit = crit + dot(diffOb(:), diffOb(:));
            end
            gradOmegaXY = gradOmegaXY/Nphi;
        end
        grad = -2.*[reshape(real(gradOb), X*Y*Z, 1); 0.0001*real(gradPhi); 1e-14*real(gradOmegaXY)];
    end

tic;

% There are no constraints
lowerBd = [zeros(Y*X*Z,1); phi(1)-20; phi(2)-20; phi(3)-20; omegaXY(1) - omegaXY(1)*0.2; omegaXY(2) - omegaXY(2)*0.2; omegaXY(3) - omegaXY(3)*0.2];
upperBd = [  inf(Y*X*Z,1); phi(1)+20; phi(2)+20; phi(3)+20; omegaXY(1) + omegaXY(1)*0.2; omegaXY(2) + omegaXY(2)*0.2; omegaXY(3) + omegaXY(3)*0.2];
opts    = struct( 'x0', [reshape(initGuess, Y*X*Z, 1); phi(1); phi(2); phi(3); omegaXY(1); omegaXY(2); omegaXY(3)] );
opts.printEvery     = 1;
opts.m  = 5;

% Ask for very high accuracy
opts.pgtol  = 1e-14;
opts.factr  = 1e3;
opts.maxIts = numIt

% The {f,g} is another way to call it
[xRet, f, info] = lbfgsb( @costGrad , lowerBd, upperBd, opts );
reconOb = reshape(xRet(1:end-6), Y, X, Z);
xRet(end-5:end)
toc;
end
