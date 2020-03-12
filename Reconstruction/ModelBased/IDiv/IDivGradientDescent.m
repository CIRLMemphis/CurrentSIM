function [recon, retFig, retVars] = IDivGradientDescent( ForwardFct, CostFct, GradientFct, StepSizeFct, g, h, im, jm, numIt, penalizationParam, initGuess, selectDir, picInterval, gTransform)
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

% normalize the data and zero-padding
if (nargin < 14)
    [Y, X, Z, Nthe, Nphi] = size(g);
    g2    = zeros(Y*2, X*2, Z*2, Nthe, Nphi);
    for l = 1:Nthe
        for k = 1:Nphi
            g2(:,:,:,l,k) = real(IFT(padarray(FT(g(:,:,:,l,k)),[Y/2 X/2 Z/2])));
        end
    end
else
    g2 = gTransform(g);
end

[Y, X, Z, Nthe, Nphi] = size(g2);
if(nargin < 11 || isequal(initGuess , -1))
    initGuess = sum(reshape(g2, Y, X, Z, Nthe*Nphi), 4)/(Nthe*Nphi);
end
recon = initGuess;

% end
tic;
Nm = size(im,6);
for it = 1:numIt
    gCur    = ForwardFct(recon, h, im, jm);
    costIn  = g2.*log(g2./gCur) - (g2 - gCur);
    curCrit = sum(costIn(:))/(X*Y*Z);
    curGrad = zeros(X,Y,Z);
    for l = 1:Nthe
        for k = 1:Nphi
            patSum = zeros(X,Y,Z);
            for m = 1:Nm
                patSum = patSum + IFT( FT(h.*im(:,:,:,l,k,m)) .* FT(jm(:,:,:,l,k,m)) );
            end
            gradIn  = 1 - g2./gCur;
            curGrad = curGrad + real(patSum)*sum(gradIn(:))/(X*Y*Z);
        end
    end
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
    
    gDir = ForwardFct(desctDir, h, im, jm);
    fun  = @(alpha)abs(sum(reshape( (1 - g2./(gCur + alpha*gDir)).*gDir, X*Y*Z*Nthe*Nphi,1 ))/(X*Y*Z));
    alpha = fminunc(fun, 0);
    %alpha = -0.01;
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