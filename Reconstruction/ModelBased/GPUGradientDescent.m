function [reconOb, retFig, retVars] = GPUGradientDescent(...
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
reconOb   = gpuArray(zeros(X,Y,Z));
memGrad   = zeros(X,Y,Z);
desctDir  = zeros(X,Y,Z);
for l = 1:Nthe
    for k = 1:Nphi
        reconOb = DataUpSampling(reconOb, g(:,:,:,l,k));
    end
end
reconOb = reconOb/(Nphi*Nthe);

[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);

% end
tic;
for it = 1:numIt
    grad = zeros(X,Y,Z);
    crit = 0;
    for l = 1:Nthe
        for k = 1:Nphi
            diff = ForwardFct(  reconOb, hGPU, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            diff = DataUpSampling(-diff, gpuArray(g(:,:,:,l,k)));
            grad = GradientFct( grad, diff, hGPU, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            crit = crit + gather(dot(diff(:), diff(:)));
        end
    end
    grad   = -real(2.*grad);
    if (it == 1)
        memGrad  =  grad;
        desctDir = -grad;
    end
    
    desctDir = grad + dot(grad(:),(grad(:) - memGrad(:)))/ dot(memGrad(:),memGrad(:))*desctDir;
    
    top = 0;
    bot = 0;
    for l = 1:Nthe
        for k = 1:Nphi
            diff = ForwardFct(  reconOb, hGPU, imFct, jmFct, Nm, xx,     ...
                                yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                phi(k), offs(l), phiz);
            diff = DataUpSampling(-diff, gpuArray(g(:,:,:,l,k)));
            [top, bot] = StepSizeFct( top, bot, desctDir, diff, hGPU, imFct, jmFct, Nm, xx,     ...
                                      yy, zz, dXY, dZ, omegaXY(l), omegaZ(l), theta(l), ...
                                      phi(k), offs(l), phiz);
        end
    end
    
    alpha = top/bot;
    fprintf('It : %d \n',it);
    fprintf('Alpha : %03.2e    crit : %d\n',alpha, crit);
    
    reconOb = reconOb + alpha.*desctDir;
    memGrad = grad;
end
reconOb = gather(reconOb);
toc;
end