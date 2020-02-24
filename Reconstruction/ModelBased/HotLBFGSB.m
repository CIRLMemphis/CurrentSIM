function [reconOb, retFig, retVars] = HotLBFGSB(...
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
        curOb = reshape(x, Y,X,Z);
        grad  = zeros(X,Y,Z);
        crit  = 0;
        for l = 1:Nthe
            for k = 1:Nphi
                diffOb = ForwardFct(curOb, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                    phi(k), offs(l), phiz);
                diffOb = UpFct(-diffOb, g(:,:,:,l,k));
                grad   = GradientFct(grad, diffOb, h, imFct, jmFct, Nm, xx,     ...
                                     yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                     phi(k), offs(l), phiz);
                crit = crit + dot(diffOb(:), diffOb(:));
            end
        end
        grad = reshape(-real(2.*grad), X*Y*Z, 1);
    end

tic;
n = Y*X*Z;
% There are no constraints
lowerBd = zeros(n,1);
upperBd = inf(n,1);
opts    = struct( 'x0', reshape(initGuess, Y*X*Z, 1) );
opts.printEvery     = 1;
opts.m  = 5;

% Ask for very high accuracy
opts.pgtol      = 1e-10;
opts.factr      = 1e3;

% The {f,g} is another way to call it
[reconOb, f, info] = lbfgsb( @costGrad , lowerBd, upperBd, opts );
reconOb = reshape(reconOb, Y, X, Z);
toc;
end
