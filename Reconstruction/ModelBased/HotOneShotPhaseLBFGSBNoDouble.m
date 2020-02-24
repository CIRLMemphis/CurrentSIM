function [reconOb, retFig, retVars] = HotOneShotPhaseLBFGSBNoDouble(...
            ForwardFct, GradientFct, StepSizeFct, UpFct, imFct, jmFct, jmFct_dPhi,...
            g, h, dXY, dZ, Nm, omegaXY, omegaZ, theta, phi, offs, phiz, ...
            numIt, penalizationParam, initGuess, selectDir, picInterval, gTransform, ...
            A, sigma, GFilter)
fprintf('Call to %s\n',  mfilename);
tNow    = datestr(datetime(),'yyyymmddHHMMSS')
curFig  = tNow + ".jpg";
retFig  = [];
retVars = {};
DEBUG_DISPLAY = 1;

if(nargin < 19)
    numIt = 10;
end

if(nargin < 20 || isequal(penalizationParam , -1))
    penalizationParam = 1e-8;
end

if(nargin < 22 || isequal(selectDir , -1) )
    selectDir = 2;
end

if(nargin < 23)
    picInterval = -1;
end

if (nargin < 25)
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
        curOb   = reshape(x(1:end-Nthe*Nphi), Y,X,Z);
        gradOb  = zeros(X,Y,Z);
        gradPhi = zeros(Nthe*Nphi,1);
        crit    = 0;
        for l = 1:Nthe
            for k = 1:Nphi
                phiInd = (l-1)*Nphi + k;
                curPhi = x(X*Y*Z + phiInd);
                diffOb = g(:,:,:,l,k) - ForwardFct(curOb, h, imFct, jmFct, Nm, xx,     ...
                                                   yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                                   curPhi, offs(l), phiz);
                gradOb = GradientFct( gradOb, diffOb, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                    curPhi, offs(l), phiz);
                dPhi = zeros(X,Y,Z);
                for m = 1:Nm
                    dPhi = dPhi + IFT(FT(curOb.*jmFct_dPhi(xx, yy, dXY, omegaXY(l), theta(l), curPhi, offs(l), m)).* ...
                                      FT(h.*imFct(zz, dZ, omegaZ(l), phiz, m)));
                end
                gradPhi(phiInd) = gradPhi(phiInd) + dot(diffOb(:), dPhi(:));
                crit            = crit + dot(diffOb(:), diffOb(:));
            end
        end
        grad = -2.*[reshape(real(gradOb), X*Y*Z, 1); real(gradPhi)];
    end

tic;

% set positivity constraint and initial values
lowerBd = zeros(Y*X*Z,1);
upperBd =   inf(Y*X*Z,1);
x0      = reshape(initGuess, Y*X*Z, 1);
for l = 1:Nthe
    for k = 1:Nphi
        lowerBd(end+1) = phi(k) + offs(l) - 30;
        upperBd(end+1) = phi(k) + offs(l) + 30;
        x0     (end+1) = phi(k) + offs(l);
    end
end

opts    = struct( 'x0', x0 );
opts.printEvery = 1;
opts.m  = 5;

% Ask for very high accuracy
opts.pgtol  = 1e-14;
opts.factr  = 1e3;
opts.maxIts = numIt

% The {f,g} is another way to call it
[xRet, f, info, retVars] = lbfgsb( @costGrad , lowerBd, upperBd, opts );
reconOb = reshape(xRet(1:end-Nthe*Nphi), Y, X, Z);
xRet(end-Nthe*Nphi+1:end)
toc;
end
