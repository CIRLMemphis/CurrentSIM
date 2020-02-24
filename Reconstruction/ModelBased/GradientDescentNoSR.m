function [recon, retFig, retVars] = GradientDescent( ForwardModel, CostFunction, Gradient, StepSize, g, h, im, jm, numIt, penalizationParam, initGuess, selectDir, picInterval, gTransform)
fprintf('Call to %s\n',  mfilename);
retFig  = [];
retVars = {};
DEBUG_DISPLAY = 1;

if(nargin < 9)
    numIt = 10;
end

if(nargin < 10 || isequal(penalizationParam , -1))
    penalizationParam = 1e-8;
end

if(nargin < 12 || isequal(selectDir , -1) )
    selectDir = 2;
end

if(nargin < 13)
    picInterval = -1;
end

[Y, X, Z, Nthe, Nphi] = size(g);
if(nargin < 11 || isequal(initGuess , -1))
    initGuess = sum(reshape(g, Y, X, Z, Nthe*Nphi), 4)/Nthe;
end
recon = initGuess;

% end
tic;
for it = 1:numIt
    diff    = g - ForwardModel(recon, h, im, jm);
    curCrit = dot(diff(:), diff(:));
    curGrad = Gradient(diff, h, im, jm);
    if (it == 1)
        memGrad  =  curGrad;
        desctDir = -curGrad;
    end
    
    % select desct dir
    switch selectDir
        case 1
            desctDir = -curGrad;
        case 2
            temp     = dot(curGrad(:),(curGrad(:) - memGrad(:)))/ dot(memGrad(:),memGrad(:));
            desctDir = curGrad + temp*desctDir;
        case 3
            desctDir = - ifftn(  fftn(reshape(curGrad,curSize)) ./ precond  );
            desctDir = desctDir(:);
        case 4
            desctDir = - ifftn(  fftn(reshape(curGrad,curSize)) ./ precond  );
            desctDir = desctDir(:);
        otherwise
            desctDir = -curGrad;
    end
    
    alpha = StepSize(diff, desctDir, h, im, jm);
    if(DEBUG_DISPLAY)
        fprintf('It : %d \n',it);
        fprintf('Alpha : %03.2e    crit : %d\n',alpha, curCrit);
    end
        
    recon = recon + alpha.*desctDir;
    memGrad = curGrad;
    
    if (picInterval ~= -1 && mod(it, picInterval) == 0)
        retFig(end+1)  = figure('Position', get(0, 'Screensize'));
        imagesc(recon(:,:,1+round(Z/2)));
        xlabel('x'); ylabel('y'); colorbar; axis square; colormap jet;
        title("it = " + num2str(it));
        retVars{end+1} = recon;
    end
end
toc;
