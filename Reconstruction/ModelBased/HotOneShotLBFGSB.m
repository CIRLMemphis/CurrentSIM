function [reconOb, retFig, retVars] = HotOneShotLBFGSB(...
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
X   = X*2;
Y   = Y*2;
Z   = Z + floor(Z/2)*2;
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);

initGuess = zeros(X,Y,Z);
for l = 1:Nthe
    for k = 1:Nphi
        initGuess = UpFct(initGuess, g(:,:,:,l,k));
    end
end
initGuess = initGuess/(Nphi*Nthe);

    function [crit, grad] = costGrad(x)
        curOb   = reshape(x(1:end-3), Y,X,Z);
        gradOb  = zeros(X,Y,Z);
        gradPhi = zeros(3,1);
        crit    = 0;
        x(end-2:end)
        for l = 1:Nthe
            for k = 1:Nphi
                curPhi = x(X*Y*Z+k);
                diffOb = ForwardFct(curOb, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                    curPhi, offs(l), phiz);
                diffOb = UpFct(-diffOb, g(:,:,:,l,k));
                gradOb = GradientFct( gradOb, diffOb, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                    curPhi, offs(l), phiz);
                temp = zeros(X,Y,Z);
                for m = 1:Nm
                    temp = temp + IFT(FT(curOb.*jmTunable_dPhi(xx, yy, dXY, omegaXY(l), theta(l), curPhi, offs(l), m)).* ...
                                      FT(h.*imFct(zz, dZ, omegaZ(l), phiz, m)));
                end
                gradPhi(k) = gradPhi(k) + dot(diffOb(:), temp(:));
                crit = crit + dot(diffOb(:), diffOb(:));
            end
        end
        grad = -2.*[reshape(real(gradOb), X*Y*Z, 1); real(gradPhi)];
    end

tic;
n = Y*X*Z + 3;
% There are no constraints
lowerBd = [zeros(Y*X*Z,1); -2*180; -2*180; -2*180];
upperBd = [inf(Y*X*Z,1); 4*180; 4*180; 4*180];
opts    = struct( 'x0', [reshape(initGuess, Y*X*Z, 1); phi(1); phi(2); phi(3)] );
opts.printEvery     = 1;
opts.m  = 5;

% Ask for very high accuracy
opts.pgtol      = 1e-10;
opts.factr      = 1e3;

% The {f,g} is another way to call it
[xRet, f, info] = lbfgsb( @costGrad , lowerBd, upperBd, opts );
reconOb = reshape(xRet(1:end-3), Y, X, Z);
xRet(end-2:end)
toc;
end
