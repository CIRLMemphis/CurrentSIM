run("../Simulation/3W/StarCorner/Sim3WStarCorner100x100x100Setup.m");
[scale01, scaleOmega] = Pixel2Omega(uc, u(1), X, dXY);
ob = StarCorner3DExtend(X, Y, Z);
g  = ForwardModel(ob, h, im, jm);
wD = 0.000001;
[reconOb, retFig, retVars] = GWF3W3D(g,h,im,uc,u,phi,offs,theta,wD,dXY,dZ,1,1,sqrt(0.5));

%%
midX = 1 + X/2;
midY = 1 + Y/2;
midZ = 1 + Z/2;
Nthe = length(theta);
Nphi = length(phi);
ShiftObFT = retVars{7};
lThe = 1;
figure; 
totalThe = 0;
for kPhi = 1:Nphi
    ShiftObFTlk = abs(ShiftObFT(:,:,:, lThe, kPhi));
    hold on; plot(ShiftObFTlk(midY,:,midZ), 'DisplayName', char("k = " + num2str(kPhi)));
end
for l = 1:Nthe
    for kPhi = 1:Nphi
        totalThe    = totalThe + ShiftObFT(:,:,:, l, kPhi);
    end
end
legend; set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega);
title("ShiftObFT");

figure; plot(abs(totalThe(midY, :, midZ)), 'DisplayName', 'Sum1to5');
FTob = abs(FT(ob));
hold on; plot(FTob(midY,:,midZ), 'DisplayName', 'FTOb');
legend; set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega);

%% get the weights
weights  = zeros(Y,X,Z,Nthe,Nphi);
for l = 1:Nthe
    for kPhi = 1:Nphi
        weights(:,:,:, l, kPhi) = abs(FTob)./abs(ShiftObFT(:,:,:, l, kPhi));
    end
end
radius   = round((uc+u(l)).*X*dXY);
center   = [1+Y/2 1+X/2 1+round(Z/2)];
ADCutOff = ApodizationCutOff( X, Z, radius, center);
weights  = weights.*ADCutOff;

%% put the weights on
WeightShiftObFT = weights.*ShiftObFT;
totalThe = 0;
for l = 1:Nthe
    for kPhi = 1:Nphi
        totalThe = totalThe + WeightShiftObFT(:,:,:, l, kPhi);
    end
end
totalThe = totalThe/(Nphi*Nthe);
hold on; plot(abs(totalThe(midY, :, midZ)), 'DisplayName', 'WeightSum1to5');
legend; set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega);

figure; 
for kPhi = 1:Nphi
    hold on; plot(abs(weights(midY,:,midZ)), 'DisplayName', char("k = " + num2str(kPhi)));
end
legend; set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega);
title("weights");

% figure; 
% for kPhi = 1:Nphi
%     WeightShiftObFTlk = abs(WeightShiftObFT(:,:,:, lThe, kPhi));
%     hold on; plot(WeightShiftObFTlk(midY,:,midZ), 'DisplayName', char("k = " + num2str(kPhi)));
% end
% legend; set(gca, 'XTick', scale01, 'XTickLabel', scaleOmega);
% title("WeightShiftObFT");
%%
%[wReconOb, wRetFig, wRetVars] = GWF3W3D(g,h,im,uc,u,phi,offs,theta,wD,dXY,dZ,1,-1,0,weights);