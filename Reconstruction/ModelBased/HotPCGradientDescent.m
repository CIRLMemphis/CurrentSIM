function [reconOb, retFig, retVars] = HotPCGradientDescent(...
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

if(nargin < 19)
    penalizationParam = -1;
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

xi        = zeros(X,Y,Z);
memGrad   = zeros(X,Y,Z);
desctDir  = zeros(X,Y,Z);
for l = 1:Nthe
    for k = 1:Nphi
        xi = UpFct(xi, g(:,:,:,l,k));
    end
end
xi = xi/(Nphi*Nthe);
xi = sqrt(xi);

% end
tic;
for it = 1:numIt
    grad = zeros(X,Y,Z);
    crit = 0;
    for l = 1:Nthe
        for k = 1:Nphi
            diff = ForwardFct(xi.^2, h, imFct, jmFct, Nm, xx,     ...
                              yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                              phi(k), offs(l), phiz);
            diff = UpFct(-diff, g(:,:,:,l,k));
            grad = GradientFct( grad, diff, h, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            crit = crit + dot(diff(:), diff(:));
        end
    end
    grad = -real(4.*xi.*grad);
    
    if penalizationParam ~= -1
        crit = crit + penalizationParam*dot(xi(:).^2, xi(:).^2);
        grad = grad + 4*penalizationParam*xi.^3;
    end
    
    if (it == 1)
        memGrad  =  grad;
        desctDir = -grad;
    end
    
    desctDir = grad + dot(grad(:),(grad(:) - memGrad(:)))/ dot(memGrad(:),memGrad(:))*desctDir;
    
    % compute the step size
    alpha = StepSizeFct(ForwardFct, UpFct, g, desctDir, xi, h, imFct, jmFct, Nm, xx,     ...
                        yy, zz, dXY, dZ, omegaXY, omegaZ, theta, ...
                        phi, offs, phiz, penalizationParam);
    fprintf('It : %d \n',it);
    fprintf('Alpha : %03.2e    crit : %d\n',alpha, crit);
    
    xi      = xi + alpha.*desctDir;
    memGrad = grad;
    
    if (picInterval ~= -1 && mod(it, picInterval) == 0)
        recon2         = xi.^2;
        retFig(end+1)  = figure('Position', get(0, 'Screensize'));
        imagesc(recon2(:,:,1+round(Z/2)));
        xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
        title("it = " + num2str(it));
        retVars{end+1} = recon2;
        saveas(retFig(end), it + "_" + curFig);
        save(tNow + ".mat", 'retVars', '-v7.3')
    end
    
    if (mod(it, 10) == 0)
        recon2 = xi.^2;
        fig    = figure('Position', get(0, 'Screensize'));
        imagesc(recon2(:,:,1+round(Z/2)));
        xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
        title("it = " + num2str(it));
        saveas(fig, curFig);
    end
end
reconOb = xi.^2;
toc;
end