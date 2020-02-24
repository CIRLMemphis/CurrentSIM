function [Ob, figTits, retVars] = OptGWFCoreNoDouble( g, h, vn, qn, cn, uc, omegaXY, phiDeg, offsDeg, thetaDeg, wD, dXY, dZ, cutoff, A, sigma, weights, returnVar, GFilter, inHn)
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
    for i = 1:size(Hn,4)
        for zInd = 1:Z
            Hn(:,:,zInd,i) = fftshift(Hn(:,:,zInd,i));
        end
    end
else
    inHn = [];
    Hn   = zeros(Y,X,Z,Nphi);
end

theta = pi*thetaDeg/180;
G     = zeros(Y, X, Z, Nthe, Nphi);
XYOff = [0, 0, 0];
for k = 1:Nphi
%     % normalize the OTF ??
%     hvn         = h.*vn(:,:,:,k);
%     hn(:,:,:,k) = hvn./sum(hvn(:));
    if (isempty(inHn))
        Hn(:,:,:,k) = FT(h.*vn(1,1,:,k));
    end
    
    % zero-order frequency damping
    if (A > 0)
        Hn(:,:,:,k) = ZeroFreqDamp3D(Hn(:,:,:,k), X, Y, Z, XYOff(k), dXY, dZ, A, sigma);
    end
    
    for l = 1:Nthe
        if (nargin < 19)
            G(:,:,:,l,k) = FT(g(:,:,:,l,k));
        else
            G(:,:,:,l,k) = FT(g(:,:,:,l,k)).*GFilter;
            if (A > 0)
                G(:,:,:,l,k) = ZeroFreqDamp3D(G(:,:,:,l,k), X, Y, Z, XYOff(k), dXY, dZ, A, sigma);
            end
        end
    end
end

GM = zeros(Y, X, Z, Nthe, Nphi);
for l = 1:Nthe
    M     = PhaseMatrix(phiDeg, offsDeg(l), cn, qn);
    GM(:,:,:,l,:) = reshape(reshape(G(:,:,:,l,:), X*Y*Z, Nphi)/transpose(M), Y, X, Z, Nphi);
%     if (A > 0)
%         for k = 1:Nphi
%             GM(:,:,:,l,k) = ZeroFreqDamp3D(GM(:,:,:,l,k), X, Y, Z, XYOff(k), dXY, dZ, A, sigma);
%         end
%     end
end

%% increase the grid size to support the shifting
%  pad zeros to Hn and GM
X2 = X;
Y2 = Y;
Z2 = Z;
dXY2 = dXY; % division by 2 because of SR 
Hn2 = Hn;

if (returnVar)
    retVars{end+1} = Hn2;
    figTits{end+1} = "OTF";
end

%% Deconvolution of each component
[yy2, xx2, zz2] = meshgrid(0 : 1 : Y2-1, 0 : 1 : X2-1, 0 : 1 : Z2-1);
Ob = zeros(Y2,X2,Z2);
WF = zeros(Y2,X2,Z2); % the widefield
for l = 1:Nthe
    for k = 1 : Nphi
        fxx    = omegaXY(k)*sin(theta(l)).*xx2*dXY2;   
        fyy    = omegaXY(k)*cos(theta(l)).*yy2*dXY2;   
        xy     = fyy + fxx;
        radius = round((uc+omegaXY(k)).*X*dXY);
        
        % get the denominator
        DenHn = zeros(Y2,X2,Z2);
        for l2 = 1:Nthe
            for k2 = 1 : Nphi
                fxx2 = omegaXY(k2)*sin(theta(l2)).*xx2*dXY2;
                fyy2 = omegaXY(k2)*cos(theta(l2)).*yy2*dXY2;
                xy2  = fyy2 + fxx2;
                DenHn = DenHn + (abs( FT( exp(-1i*2*pi*(xy2*qn(k2) - xy*qn(k))).*real(IFT(Hn2(:,:,:,k2))) ) )).^2;
            end
        end

        center  = [1+Y2/2 1+X2/2 1+Z2/2] + round(omegaXY(k)*X*dXY*qn(k)*[sin(theta(l)) cos(theta(l)) 0]);
        AD      = apodization( X2, Z2, radius, center);
        if (qn(k) == 0)
            WFilter = conj(Hn2(:,:,:,k))./(wD^2 + (abs(Hn2(:,:,:,k))).^2);
            ObFT    = GM(:,:,:,l,k).*WFilter.*AD;
            WF      = WF + real(IFT(ObFT));
        end
        WFilter = conj(Hn2(:,:,:,k))./(wD^2 + DenHn);
        ObFT    = GM(:,:,:,l,k).*WFilter.*AD;
        Ob      = Ob + real(IFT(ObFT).*exp(-qn(k)*1i*2*pi*xy));
    end
end

if (returnVar)
    retVars{end+1} = WF;
    figTits{end+1} = "WideField";
    retVars{end+1} = Ob;
    figTits{end+1} = "Recon";
end
end