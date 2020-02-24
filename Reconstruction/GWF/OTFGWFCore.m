function [Ob, figTits, retVars] = OTFGWFCore( g, Hn, qn, cn, uc, omegaXY, phiDeg, offsDeg, thetaDeg, wD, dXY, dZ, cutoff, A, sigma, weights, returnVar, GFilter, shouldDouble)
retVars = {};
figTits = {};
[Y, X, Z, Nthe, Nphi] = size(g);
if (nargin < 13)
    cutoff = -1;
end
if (nargin < 14 || A == -1)
    A = 0;
end
if (nargin < 15 || sigma == -1)
    sigma = sqrt(0.1);
end
if (nargin < 17)
    returnVar = 0;
end
if (nargin < 18)
    GFilter = ones(Y,X,Z);
end
if (nargin < 19)
    shouldDouble = 1;
end

theta = pi*thetaDeg/180;
G     = zeros(Y, X, Z, Nthe, Nphi);

for k = 1:Nphi
    
    for l = 1:Nthe
        if (nargin < 19 || isempty(GFilter))
            G(:,:,:,l,k) = FT(g(:,:,:,l,k));
        else
            G(:,:,:,l,k) = FT(g(:,:,:,l,k)).*GFilter;
        end
    end
end

GM = zeros(Y, X, Z, Nthe, Nphi);
for l = 1:Nthe
    M     = PhaseMatrix(phiDeg, offsDeg(l), cn, qn);
    GM(:,:,:,l,:) = reshape(reshape(G(:,:,:,l,:), X*Y*Z, Nphi)/transpose(M), Y, X, Z, Nphi);
end

%% increase the grid size to support the shifting
%  pad zeros to Hn and GM
X2 = X*2;
Y2 = Y*2;
if (shouldDouble)
    Z2 = Z + floor(Z/2)*2;
    pads = [Y/2 X/2 floor(Z/2)];
else
    Z2 = Z;
    pads = [Y/2 X/2 0];
end
dXY2 = dXY/2; % division by 2 because of SR 

if (numel(Hn) == X*Y*Z*Nphi)
    Hn2 = zeros(Y2,X2,Z2,Nphi);

    for k = 1 : Nphi
        Hn2(:,:,:,k) = padarray(Hn(:,:,:,k), pads);
    end
else
    Hn2 = Hn;
end

%% Deconvolution of each component
[yy2, xx2, zz2] = meshgrid(0 : 1 : Y2-1, 0 : 1 : X2-1, 0 : 1 : Z2-1);
Ob = zeros(Y2,X2,Z2);
WF = zeros(Y2,X2,Z2); % the widefield
for l = 1:Nthe
    fxx    = omegaXY(l)*sin(theta(l)).*xx2*dXY2;   
    fyy    = omegaXY(l)*cos(theta(l)).*yy2*dXY2;   
    xy     = fyy + fxx;
    radius = round((uc+omegaXY(l)).*X*dXY);
    for k = 1 : Nphi
        % get the denominator
        DenHn = zeros(Y2,X2,Z2);
        for l2 = 1:Nthe
            fxx2 = omegaXY(l2)*sin(theta(l2)).*xx2*dXY2;
            fyy2 = omegaXY(l2)*cos(theta(l2)).*yy2*dXY2;
            xy2  = fyy2 + fxx2;
            for k2 = 1 : Nphi
                DenHn = DenHn + (abs( FT( exp(-1i*2*pi*(xy2*qn(k2) - xy*qn(k))).*real(IFT(Hn2(:,:,:,k2))) ) )).^2;
            end
        end
        
        WFilter = conj(Hn2(:,:,:,k))./(wD^2 + DenHn);
        center  = [1+Y2/2 1+X2/2 1+Z2/2] + round(omegaXY(l)*X*dXY*qn(k)*[sin(theta(l)) cos(theta(l)) 0]);
        AD      = apodization( X2, Z2, radius, center);
        ObFT    = padarray(GM(:,:,:,l,k), pads).*WFilter.*AD;
        if (qn(k) == 0)
            WF = WF + real(IFT(ObFT));
        else
            Ob = Ob + real(IFT(ObFT).*exp(-qn(k)*1i*2*pi*xy));
        end
    end
end

% add the widefield
Ob = Ob + WF;

if (returnVar)
    retVars{end+1} = WF;
    figTits{end+1} = "WideField";
    retVars{end+1} = Ob;
    figTits{end+1} = "Recon";
end
end