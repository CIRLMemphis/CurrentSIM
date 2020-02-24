function [reconOb, retFig, retVars] = DRHotGradientDescent(...
            ForwardFct, GradientFct, StepSizeFct, UpFct, imFct, jmFct,...
            g, h, dXY, dZ, Nm, omegaXY, omegaZ, thePhi, offs, phiz, ...
            numIt, penalizationParam, initGuess, selectDir, picInterval, initInd, gTransform)
fprintf('Call to %s\n',  mfilename);
tNow    = datestr(datetime(),'yyyymmddHHMMSS')
curFig  = tNow + ".jpg";
retFig  = [];
retVars = {};
DEBUG_DISPLAY = 1;

if(nargin < 17)
    numIt = 10;
end

if(nargin < 18 || isequal(penalizationParam , -1))
    penalizationParam = 1e-8;
end

if(nargin < 20 || isequal(selectDir , -1) )
    selectDir = 2;
end

if(nargin < 21)
    picInterval = -1;
end

% normalize the data and zero-padding
[Y, X, Z, Npt] = size(g);
X   = X*2;
Y   = Y*2;
Z   = Z*2;
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);

if(nargin < 22)
    initInd = Npt;
end

reconOb   = zeros(X,Y,Z);
memGrad   = zeros(X,Y,Z);
desctDir  = zeros(X,Y,Z);
for lk = 1:min(initInd, Npt)
    reconOb = UpFct(reconOb, g(:,:,:,lk));
end
reconOb = reconOb/min(initInd, Npt);

%% save initial guess for double checking
fig    = figure('Position', get(0, 'Screensize'));
imagesc(reconOb(:,:,1+round(Z/2)));
xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
title("initial guess");
saveas(fig, "initial" + curFig);

% end
tic;
for it = 1:numIt
    grad = zeros(X,Y,Z);
    crit = 0;
    diff = zeros(X, Y, Z, Npt);
    for lk = 1:Npt        
        diff(:,:,:,lk) = ForwardFct(reconOb, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhi(lk,1), ...
                                    thePhi(lk,2), offs(1), phiz);
        diff(:,:,:,lk) = UpFct(-diff(:,:,:,lk), g(:,:,:,lk));
        grad = GradientFct( grad, diff(:,:,:,lk), h, imFct, jmFct, Nm, xx,     ...
            yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhi(lk,1), ...
            thePhi(lk,2), offs(1), phiz);
        %crit = crit + gather(dot(diff(:), diff(:)));
    end
    crit = crit + dot(diff(:), diff(:));
    grad = -real(2.*grad);
    if (it == 1)
        memGrad  =  grad;
        desctDir = -grad;
    end
    
    desctDir = grad + dot(grad(:),(grad(:) - memGrad(:)))/ dot(memGrad(:),memGrad(:))*desctDir;
    
    top = 0;
    bot = 0;
    for lk = 1:Npt
        [top, bot] = StepSizeFct( top, bot, desctDir, diff(:,:,:,lk), h, imFct, jmFct, Nm, xx,     ...
                                  yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhi(lk,1), ...
                                  thePhi(lk,2), offs(1), phiz);
    end
    
    alpha = top/bot;
    fprintf('It : %d \n',it);
    fprintf('Alpha : %03.2e    crit : %d\n',alpha, crit);
    
    reconOb = reconOb + alpha.*desctDir;
    memGrad = grad;
    
    if (picInterval ~= -1 && mod(it, picInterval) == 0)
        retFig(end+1)  = figure('Position', get(0, 'Screensize'));
        imagesc(reconOb(:,:,1+round(Z/2)));
        xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
        title("it = " + num2str(it));
        retVars{end+1} = reconOb;
    end
    
    if (mod(it, 10) == 0)
        fig    = figure('Position', get(0, 'Screensize'));
        imagesc(reconOb(:,:,1+round(Z/2)));
        xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
        title("it = " + num2str(it));
        saveas(fig, curFig);
    end
end
toc;
end