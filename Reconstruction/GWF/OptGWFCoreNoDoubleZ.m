function [Ob, figTits, retVars] = OptGWFCoreNoDoubleZ( g, h, vn, qn, cn, uc, omegaXY, phiDeg, offsDeg, thetaDeg, wD, dXY, dZ, cutoff, A, sigma, weights, returnVar, GFilter, inHn, inHAtt)
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
if (nargin < 20 || isempty(inHAtt))
    strength = 0;
    FWHM     = 1;
else
    strength = inHAtt(1);
    FWHM     = inHAtt(2);
end

theta = pi*thetaDeg/180;
G     = zeros(Y, X, Z, Nthe, Nphi);

XYOff = [0, 0, 0, 0, 0];
 ZOff = [0, 1, 1, 0, 0];

for k = 1:Nphi
%     % normalize the OTF ??
%     hvn         = h.*vn(:,:,:,k);
%     hn(:,:,:,k) = hvn./sum(hvn(:));
    if (isempty(inHn))
        Hn(:,:,:,k) = FT(h.*vn(1,1,:,k));
    end
    
    if (A > 0)
        Hn(:,:,:,k) = ZeroFreqDamp3D(Hn(:,:,:,k), X, Y, Z, XYOff(k), ZOff(k), dXY, dZ, A, sigma);
    end
    
    for l = 1:Nthe
        if (nargin < 19)
            G(:,:,:,l,k) = FT(g(:,:,:,l,k));
        else
            G(:,:,:,l,k) = FT(g(:,:,:,l,k)).*GFilter;
%             if (A > 0)
%                 G(:,:,:,l,k) = ZeroFreqDamp3D(G(:,:,:,l,k), X, Y, Z, XYOff(k), dXY, dZ, A, sigma);
%             end
        end
    end
end

% zero-order frequency damping
%     if (A > 0)
%         Hn(:,:,:,1) = ZeroFreqDamp3D(Hn(:,:,:,1), X, Y, Z, 0, dXY, dZ, A, sigma);
%         Hn(:,:,:,4) = ZeroFreqDamp3D(Hn(:,:,:,4), X, Y, Z, 0, dXY, dZ, A, sigma);
%         Hn(:,:,:,5) = ZeroFreqDamp3D(Hn(:,:,:,5), X, Y, Z, 0, dXY, dZ, A, sigma);
%     end

if (inHAtt ~= -1)
    dUV  = inHAtt(3);
    dW   = inHAtt(4);
    midX = 1 + X/2;
    midY = 1 + Y/2;
    if (mod(Z,2) == 0)
        midZ = 1 + Z/2;
    else
        midZ = round(Z/2);
    end
    for xInd = 1:X
        for yInd = 1:Y
            for zInd = 1:Z
                d = sqrt(((xInd - midX)^2 + (yInd - midY)^2)*dUV^2 + (zInd - midZ)^2*dW^2);
                for k = 1:Nphi
                    Hn(xInd,yInd,zInd, k) = Hn(xInd,yInd,zInd,k)*(1 - strength*exp(-d^2/(2*(FWHM/2.355)^2)));
                end
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
Z2 = Z;
dXY2 = dXY/2; % division by 2 because of SR 
Hn2 = zeros(Y2,X2,Z2,Nphi);

for k = 1 : Nphi
    Hn2(:,:,:,k) = padarray(Hn(:,:,:,k), [Y/2 X/2 0]);
end

if (returnVar)
    retVars{end+1} = Hn2;
    figTits{end+1} = "OTF";
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
        
        center  = [1+Y2/2 1+X2/2 1+floor(Z2/2)] + round(omegaXY(l)*X*dXY*qn(k)*[sin(theta(l)) cos(theta(l)) 0]);
        AD      = ApodizationPixel( X2, Z2, dXY2, dZ, radius, center);
        if (qn(k) == 0)
            WFilter = conj(Hn2(:,:,:,k))./(wD^2 + (abs(Hn2(:,:,:,k))).^2);
            ObFT    = padarray(GM(:,:,:,l,k), [Y/2 X/2 0]).*WFilter.*AD;
            WF      = WF + real(IFT(ObFT));
        end
        WFilter = conj(Hn2(:,:,:,k))./(wD^2 + DenHn);
        ObFT    = padarray(GM(:,:,:,l,k), [Y/2 X/2 0]).*WFilter.*AD;
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