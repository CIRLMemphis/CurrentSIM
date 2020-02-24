function [reconOb, retFig, retVars] = DRWFHotGradientDescentNoDouble(...
            ForwardFct, GradientFct, StepSizeFct, UpFct, imFct, jmFct,...
            g, h, dXY, dZ, Nm, omegaXY, omegaZ, thePhi, offs, phiz, ...
            numIt, penalizationParam, initGuess, selectDir, picInterval, gTransform)
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
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);

memGrad  = zeros(X,Y,Z);
desctDir = zeros(X,Y,Z);
reconOb  = g(:,:,:,end); % last one is the widefield

% end
tic;
for it = 1:numIt
    grad = zeros(X,Y,Z);
    crit = 0;
    diff = zeros(X, Y, Z, Npt);
    for lk = 1:Npt
        isWF = 0;
        if (lk == Npt)
            isWF = 1;
        end
        diff(:,:,:,lk) = g(:,:,:,lk) - ...
                         ForwardFct(reconOb, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhi(lk,1), ...
                                    thePhi(lk,2), offs(1), phiz, isWF);
        grad = GradientFct( grad, diff(:,:,:,lk), h, imFct, jmFct, Nm, xx,     ...
            yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhi(lk,1), ...
            thePhi(lk,2), offs(1), phiz, isWF);
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
        isWF = 0;
        if (lk == Npt)
            isWF = 1;
        end
        [top, bot] = StepSizeFct( top, bot, desctDir, diff(:,:,:,lk), h, imFct, jmFct, Nm, xx,     ...
                                  yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhi(lk,1), ...
                                  thePhi(lk,2), offs(1), phiz, isWF);
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