function [Ob, retFig, retVars] = OptGWFTunable3DNoDouble( g, h, im, uc, omegaXY, phiDeg, offsDeg, thetaDeg, wD, dXY, dZ, cutoff, A, sigma, returnVar, GFilter, weights)
[Y, X, Z, Nthe, Nphi] = size(g);
if (nargin < 12)
    cutoff = -1;
end
if (nargin < 13)
    A = 0;
end
if (nargin < 14)
    sigma = sqrt(0.1);
end
if (nargin < 15)
    returnVar = 1;
end
if (nargin < 16)
    GFilter = ones(Y,X,Z);
end
if (nargin < 17)
    weights = ones(Y,X,Z,Nthe,Nphi);
end
qn = [0, 1, -1];
cn = [1, 1/2, 1/2];
vn = ones(1,1,Z,Nphi);
%vn(1,1,:,1) = im(1,1,:,1,1,2);
vn(1,1,:,2) = im(1,1,:,1,2,2);
vn(1,1,:,3) = im(1,1,:,1,3,2);

[Ob, figTits, retVars] = OptGWFCoreNoDouble(g,h,vn,qn,cn,uc,omegaXY,phiDeg,offsDeg,thetaDeg,wD,dXY,dZ,cutoff,A,sigma,weights,returnVar,GFilter, []);

% component pictures for fixed theta, variable phi
lThe = 1;
zBF  = 1+round(Z/2);
zBF2 = zBF*2;
retFig = [];
for k = 1:length(retVars)
    retFig(end+1) = figure('Position', get(0, 'Screensize'));
    curVar = retVars{k};
    if (length(size(curVar)) == 5)
        Nphi = size(curVar, 5);
    elseif length(size(curVar)) == 4
        Nphi = size(curVar, 4);
    end
    if (size(curVar, 3) == Z)
        curZ = zBF;
    else
        curZ = zBF2;
    end
    if (length(size(curVar)) == 3)
        imagesc(squeeze(abs(curVar(:,:,curZ))));
        xlabel('u'); ylabel('v'); colorbar; axis square; colormap jet; title(figTits{k});
    else
        for kPhi = 1:Nphi
            subplot(2,3,kPhi);
            if (length(size(curVar)) == 5)
                imagesc(squeeze(log(abs(curVar(:,:,curZ,lThe,kPhi)))));
            elseif (length(size(curVar)) == 4)
                imagesc(squeeze(log(abs(curVar(:,:,curZ,lThe)))));
            elseif (length(size(curVar)) == 3)
                imagesc(log(abs(curVar(:,:,curZ)))); 
            end
            xlabel('u'); ylabel('v'); colorbar; axis square; colormap jet; title(figTits{k});
        end
    end
    if (verLessThan('matlab','9.4.1'))
        suptitle("For angle = " + num2str(thetaDeg(lThe)));
    else
        sgtitle("For angle = " + num2str(thetaDeg(lThe)));
    end
end