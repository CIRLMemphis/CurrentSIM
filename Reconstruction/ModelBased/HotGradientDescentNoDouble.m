function [reconOb, retFig, retVars] = HotGradientDescentNoDouble(...
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
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);

reconOb   = zeros(X,Y,Z);
memGrad   = zeros(X,Y,Z);
desctDir  = zeros(X,Y,Z);
for l = 1:Nthe
    for k = 1:Nphi
        reconOb = reconOb + g(:,:,:,l,k);
    end
end
reconOb = reconOb/(Nphi*Nthe);

% end
tic;
for it = 1:numIt
    grad = zeros(X,Y,Z);
    crit = 0;
    diff = zeros(X, Y, Z, Nthe, Nphi);
    for l = 1:Nthe
        for k = 1:Nphi
            diff(:,:,:,l,k) = g(:,:,:,l,k) - ...
                   ForwardFct(  reconOb, h, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            grad = GradientFct( grad, diff(:,:,:,l,k), h, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            %crit = crit + gather(dot(diff(:), diff(:)));
        end
    end
    crit = crit + gather(dot(diff(:), diff(:)));
    grad = -real(2.*grad);
    
    if penalizationParam ~= -1
        crit = crit + penalizationParam*dot(reconOb(:), reconOb(:));
        grad = grad + 2*penalizationParam*reconOb;
    end
    
    if (it == 1)
        memGrad  =  grad;
        desctDir = -grad;
    end
    
    desctDir = grad + dot(grad(:),(grad(:) - memGrad(:)))/ dot(memGrad(:),memGrad(:))*desctDir;
    
    top = 0;
    bot = 0;
    for l = 1:Nthe
        for k = 1:Nphi
%             diff = ForwardFct(  reconOb, h, imFct, jmFct, Nm, xx,     ...
%                                 yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
%                                 phi(k), offs(l), phiz);
%             diff = UpFct(-diff, g(:,:,:,l,k));
            [top, bot] = StepSizeFct( top, bot, desctDir, diff(:,:,:,l,k), h, imFct, jmFct, Nm, xx,     ...
                                      yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                      phi(k), offs(l), phiz);
        end
    end
    
    if penalizationParam ~= -1
        top = top + 2*penalizationParam*dot( reconOb(:),desctDir(:));
        bot = bot + 2*penalizationParam*dot(desctDir(:),desctDir(:));
    end
    
    alpha = top/bot;
    fprintf('It : %d \n',it);
    fprintf('Alpha : %03.2e    crit : %d\n',alpha, crit);
    
    reconOb = reconOb + alpha.*desctDir;
    memGrad = grad;
    
    if (picInterval ~= -1 && mod(it, picInterval) == 0)
        tempOb = reconOb;
        tempOb(tempOb < 0) = 0;
        retFig(end+1)  = figure('Position', get(0, 'Screensize'));
        subplot(1,2,1); imagesc(tempOb(:,:,1+round(Z/2)));   xlabel('x'); ylabel('y'); colorbar; axis image; colormap jet;
        subplot(1,2,2); imagesc(squeeze(tempOb(1+Y/2,:,:))); xlabel('x'); ylabel('z'); colorbar; axis image; colormap jet;
        title("it = " + num2str(it));
        retVars{end+1} = reconOb;
        saveas(retFig(end), it + "_" + curFig);
    end
    
    if (mod(it, 10) == 0)
        fig    = figure('Position', get(0, 'Screensize'));
        subplot(1,2,1); imagesc(reconOb(:,:,1+round(Z/2)));   xlabel('x'); ylabel('y'); colorbar; axis image; colormap jet;
        subplot(1,2,2); imagesc(squeeze(reconOb(1+Y/2,:,:))); xlabel('x'); ylabel('z'); colorbar; axis image; colormap jet;
        title("it = " + num2str(it));
        saveas(fig, curFig);
    end
end
toc;
end
