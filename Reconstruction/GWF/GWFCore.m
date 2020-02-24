function [Ob, figTits, retVars] = GWFCore( g, h, vn, qn, cn, uc, omegaXY, phiDeg, offsDeg, thetaDeg, wD, dXY, dZ, cutoff, A, sigma, weights, returnVar, GFilter, inHn)
retVars = {};
figTits = {};
[Y, X, Z, Nthe, Nphi] = size(g);
if (nargin < 14)
    cutoff = -1;
end
if (nargin < 15)
    A = 0;
end
if (nargin < 16)
    sigma = sqrt(0.1);
end
if (nargin < 18)
    returnVar = 0;
end
if (nargin < 19)
    GFilter = ones(Y,X,Z);
end
if (nargin >= 19 && ~isempty(inHn))
    load(inHn);
%     for i = 1:size(Hn,4)
%         for zInd = 1:Z
%             Hn(:,:,zInd,i) = fftshift(Hn(:,:,zInd,i));
%         end
%     end
else
    inHn = [];
    Hn   = zeros(Y,X,Z,Nphi);
end

theta   = pi*thetaDeg/180;
G  = zeros(Y, X, Z, Nthe, Nphi);
for k = 1:Nphi
%     % normalize the OTF ??
%     hvn         = h.*vn(:,:,:,k);
%     hn(:,:,:,k) = hvn./sum(hvn(:));
    if (isempty(inHn))
        Hn(:,:,:,k) = FT(h.*vn(1,1,:,k));
    end
    
    % zero-order frequency damping
    if (A > 0)
        Hn(:,:,:,k) = ZeroFreqDamp3D(Hn(:,:,:,k), X, Y, Z, dXY, dZ, A, sigma);
    end
    
    for l = 1:Nthe
        if (nargin < 19)
            G(:,:,:,l,k) = FT(g(:,:,:,l,k));
        else
            G(:,:,:,l,k) = FT(g(:,:,:,l,k)).*GFilter;
            if (A > 0)
                G(:,:,:,l,k) = ZeroFreqDamp3D(G(:,:,:,l,k), X, Y, Z, dXY, dZ, A, sigma);
            end
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
Z2 = Z + floor(Z/2)*2;
dXY2 = dXY/2; % division by 2 because of SR 
Hn2 = zeros(Y2,X2,Z2,Nphi);
GM2 = zeros(Y2,X2,Z2, Nthe, Nphi);

for l = 1:Nthe
    for k = 1 : Nphi
        GM2(:,:,:,l,k) = padarray(GM(:,:,:,l,k), [Y/2 X/2 floor(Z/2)]);
    end
end

for k = 1 : Nphi
    Hn2(:,:,:,k) = padarray(Hn(:,:,:,k), [Y/2 X/2 floor(Z/2)]);
end

if (returnVar)
    retVars{end+1} = Hn2;
    figTits{end+1} = "OTF";
    retVars{end+1} = GM2;
    figTits{end+1} = "DeComp";
end

%% Deconvolution of each component
WFilter  = zeros(Y2,X2,Z2,Nthe,Nphi);
[yy , xx , zz ] = meshgrid(0 : 1 : Y -1, 0 : 1 : X -1, 0 : 1 : Z -1);
[yy2, xx2, zz2] = meshgrid(0 : 1 : Y2-1, 0 : 1 : X2-1, 0 : 1 : Z2-1);
DenHn = zeros(Y2,X2,Z2,Nthe,Nphi);
for l = 1:Nthe
    fxx = omegaXY(l)*sin(theta(l)).*xx2*dXY2;   
    fyy = omegaXY(l)*cos(theta(l)).*yy2*dXY2;   
    xy  = fyy + fxx;
    for k = 1 : Nphi
        for l2 = 1:Nthe
            fxx2 = omegaXY(l2)*sin(theta(l2)).*xx2*dXY2;
            fyy2 = omegaXY(l2)*cos(theta(l2)).*yy2*dXY2;
            xy2  = fyy2 + fxx2;
            for k2 = 1 : Nphi
                DenHn(:,:,:,l,k) = DenHn(:,:,:,l,k) + (abs( FT( exp(-1i*2*pi*(xy2*qn(k2) - xy*qn(k))).*real(IFT(Hn2(:,:,:,k2))) ) )).^2;
            end
        end
    end
end

for l = 1:Nthe
    for k = 1 : Nphi
        WFilter(:,:,:,l,k) = conj(Hn2(:,:,:,k))./(wD^2 + DenHn(:,:,:,l,k));
    end
end

ObFT = GM2.*WFilter;
if (returnVar)
    retVars{end+1} = DenHn;
    figTits{end+1} = "Denom";
    retVars{end+1} = ObFT;
    figTits{end+1} = "DeConv";
end
clear GM2; clear WFilter; clear Hn2;

AD = zeros(Y2, X2, Z2, Nthe, Nphi);
for l = 1 : Nthe
    radius = round((uc+omegaXY(l)).*X*dXY);
    for k = 1:Nphi
        center = [1+Y2/2 1+X2/2 1+Z2/2] + round(omegaXY(l)*X*dXY*qn(k)*[sin(theta(l)) cos(theta(l)) 0]);
        AD(:,:,:,l,k) = apodization( X2, Z2, radius, center);
    end
end
ObFT = ObFT.*AD;

if (returnVar)
    retVars{end+1} = AD;
    figTits{end+1} = "AD";

    retVars{end+1} = ObFT;
    figTits{end+1} = "DeConvAD";
end
clear AD;

% zero-padding: increase resolution  
Ob = zeros(Y2,X2,Z2);
WF = zeros(Y2,X2,Z2); % the widefield
for l = 1:Nthe
    fxx = omegaXY(l)*sin(theta(l)).*xx2*dXY2;  
    fyy = omegaXY(l)*cos(theta(l)).*yy2*dXY2;
    xy  = fyy + fxx;
    for k = 1:Nphi
        if (qn(k) == 0)
            WF = WF + real(IFT(ObFT(:,:,:,l,k)));
        else
            Ob = Ob + real(IFT(ObFT(:,:,:,l,k)).*exp(-qn(k)*1i*2*pi*xy));
        end
    end
end
% add the widefield
Ob = Ob + WF;

% applying apodization cutoff
% if (cutoff > 0)
%     radius   = round((uc+omegaXY(l)).*X2*dXY2)/cutoff;
%     center   = [1+Y2/2 1+X2/2 round(Z2/2)];
%     ADCutOff = ApodizationCutOff( X2, Z2, radius, center);
%     ObReFT   = ObReFT.*ADCutOff;
% end

if (returnVar)
    retVars{end+1} = WF;
    figTits{end+1} = "WideField";
    retVars{end+1} = Ob;
    figTits{end+1} = "Recon";
end
end