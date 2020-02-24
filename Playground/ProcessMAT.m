%%
clear; clc
run("../../CIRLSetup.m");
MATPath = "C:\Users\cvan\OneDrive - The University of Memphis\github\cirl\src\GeneratedReport\";
MATDate = "201908071048";
load(MATPath + MATDate + "\" + MATDate + ".mat");

%% apodization analysis
Hn      = retVars{1};
DeConv  = retVars{2};
WFilter = retVars{3};
ObFil   = retVars{4};
AD      = retVars{5};
ObAD    = retVars{6};
figTits = {'Hn', 'DeCon', 'WFilter', 'DeConFil', 'AD', 'DeConFilAD'};

%%
lThe = 1;
kPhi = 3;
figure('Position', get(0, 'Screensize'));

for k = 1:length(retVars)
    subplot(2,3,k);
    if (length(size(retVars{k})) == 5)
        imagesc(abs(retVars{k}(:,:,1,lThe,kPhi)).^0.1);
    else
        imagesc(abs(retVars{k}(:,:,1,kPhi)).^0.1); 
    end
    xlabel('u'); ylabel('v'); colorbar; axis square; colormap jet; title(figTits{k});
end
suptitle("angle = " + num2str(theta(lThe)) + "; phi = " + num2str(phi(kPhi)));

%% test hn
figure;imagesc(abs(IFT(retVars{1}(:,:,1,kPhi))).^0.1); colorbar; axis square; colormap jet