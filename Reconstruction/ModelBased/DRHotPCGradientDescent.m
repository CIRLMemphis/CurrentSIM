function [reconOb, retFig, retVars] = DRHotPCGradientDescent(...
            ForwardFct, GradientFct, StepSizeFct, UpFct, imFct, jmFct,...
            g, h, dXY, dZ, Nm, omegaXY, omegaZ, thePhiOff, phiz, ...
            numIt, penalizationParam, initGuess, selectDir, picInterval, initInd, gTransform)
fprintf('Call to %s\n',  mfilename);
tNow    = datestr(datetime(),'yyyymmddHHMMSS')
curFig  = tNow + ".jpg";
retFig  = [];
retVars = {};
DEBUG_DISPLAY = 1;

if(nargin < 16)
    numIt = 10;
end

if(nargin < 17 || isequal(penalizationParam , -1))
    penalizationParam = 1e-8;
end

if(nargin < 19 || isequal(selectDir , -1) )
    selectDir = 2;
end

if(nargin < 20)
    picInterval = -1;
end

% normalize the data and zero-padding
[Y, X, Z, Npt] = size(g);
X   = X*2;
Y   = Y*2;
Z   = Z + floor(Z/2)*2;
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);

if(nargin < 21)
    initInd = Npt;
end

xi        = zeros(X,Y,Z);
memGrad   = zeros(X,Y,Z);
desctDir  = zeros(X,Y,Z);
for lk = 1:min(initInd, Npt)
    xi = UpFct(xi, g(:,:,:,lk));
end
xi = xi/min(initInd, Npt);
xi = sqrt(xi);

% end
tic;
for it = 1:numIt
    grad = zeros(X,Y,Z);
    crit = 0;
    diff = zeros(X, Y, Z, Npt);
    for lk = 1:Npt        
        diff(:,:,:,lk) = ForwardFct(xi.^2, h, imFct, jmFct, Nm, xx,     ...
                                    yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhiOff(lk,1), ...
                                    thePhiOff(lk,2), thePhiOff(lk,3), phiz);
        diff(:,:,:,lk) = UpFct(-diff(:,:,:,lk), g(:,:,:,lk));
        grad = GradientFct( grad, diff(:,:,:,lk), h, imFct, jmFct, Nm, xx,     ...
            yy, zz, dXY, dZ, omegaXY(1), omegaZ(1), thePhiOff(lk,1), ...
            thePhiOff(lk,2), thePhiOff(lk,3), phiz);
        %crit = crit + gather(dot(diff(:), diff(:)));
    end
    crit = crit + dot(diff(:), diff(:));
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
    
    alpha = StepSizeFct(ForwardFct, UpFct, g, desctDir, xi, h, imFct, jmFct, Nm, xx,     ...
                        yy, zz, dXY, dZ, omegaXY, omegaZ, thePhiOff, phiz);
    fprintf('It : %d \n',it);
    fprintf('Alpha : %03.2e    crit : %d\n',alpha, crit);
    
    xi      = xi + alpha.*desctDir;
    memGrad = grad;
    
    if (picInterval ~= -1 && mod(it, picInterval) == 0)
        reconOb = xi.^2;
        retFig(end+1)  = figure('Position', get(0, 'Screensize'));
        imagesc(reconOb(:,:,1+round(Z/2)));
        xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
        title("it = " + num2str(it));
        retVars{end+1} = reconOb;
        saveas(retFig(end), it + "_" + curFig);
        save(tNow + ".mat", 'retVars', '-v7.3')
    end
    
    if (mod(it, 10) == 0)
        reconOb = xi.^2;
        fig    = figure('Position', get(0, 'Screensize'));
        imagesc(reconOb(:,:,1+round(Z/2)));
        xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
        title("it = " + num2str(it));
        saveas(fig, curFig);
    end
end
reconOb = xi.^2;
toc;
end