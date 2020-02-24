function [reconOb, retFig, retVars] = GPUPCGradientDescent(...
            ForwardFct, GradientFct, StepSizeFct, imFct, jmFct,...
            g, h, dXY, dZ, Nm, omegaXY, omegaZ, theta, phi, offs, phiz, ...
            numIt, penalizationParam, initGuess, selectDir, picInterval, gTransform)
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
[Y, X, Z, Nthe, Nphi] = size(g);
X   = X*2;
Y   = Y*2;
Z   = Z*2;

hGPU      = gpuArray(h);
xi        = gpuArray(zeros(X,Y,Z));
memGrad   = zeros(X,Y,Z);
desctDir  = zeros(X,Y,Z);
for l = 1:Nthe
    for k = 1:Nphi
        xi = DataUpSampling(xi, g(:,:,:,l,k));
    end
end
xi = xi/(Nphi*Nthe);
xi = sqrt(xi);

[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);
tic;
for it = 1:numIt
    grad = zeros(X,Y,Z);
    crit = 0;
    for l = 1:Nthe
        for k = 1:Nphi
            diff = ForwardFct(  xi.^2, hGPU, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            diff = DataUpSampling(-diff, gpuArray(g(:,:,:,l,k)));
            grad = GradientFct( grad, diff, hGPU, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            crit = crit + gather(dot(diff(:), diff(:)));
        end
    end
    grad = -real(4.*xi.*gather(grad));
    if (it == 1)
        memGrad  =  grad;
        desctDir = -grad;
    end
    
    desctDir = grad + dot(grad(:),(grad(:) - memGrad(:)))/ dot(memGrad(:),memGrad(:))*desctDir;
    
    % compute the step size
    alpha = StepSizeFct(ForwardFct, g, desctDir, xi, hGPU, imFct, jmFct, Nm, xx,     ...
                        yy, zz, dXY, dZ, omegaXY, omegaZ, theta, ...
                        phi, offs, phiz);
    fprintf('It : %d \n',it);
    fprintf('Alpha : %03.2e    crit : %d\n',alpha, crit);
    
    xi      = xi + alpha.*desctDir;
    memGrad = grad;
end
reconOb = gather(xi.^2);
toc;
end
