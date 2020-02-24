%%
run("../Experiment/Tunable/071919_Glioblastoma/ExpTunable071719GlioSetup.m");
matFile = CIRLDataPath + "/TunableData/071919_Glioblastoma/FSIM_071719_3S_GB_SR100mw2500ms_Grid512.mat";

%% load the data
load(matFile)

%%
g_s(:,:,1,1) = squeeze(g(:,:,1+Z/2,1,1));%best focus plane
g_s(:,:,1,2) = squeeze(g(:,:,1+Z/2,1,2));
g_s(:,:,1,3) = squeeze(g(:,:,1+Z/2,1,3));
clear g_Ideal; g_Ideal = g_s; clear g_s;
g_Ideal(:,:,1,1) = g_Ideal(:,:,1,1)./max(max(g_Ideal(:,:,1,1)));
g_Ideal(:,:,1,2) = g_Ideal(:,:,1,2)./max(max(g_Ideal(:,:,1,2)));
g_Ideal(:,:,1,3) = g_Ideal(:,:,1,3)./max(max(g_Ideal(:,:,1,3)));

%%
g = zeros(Y,X,3);g(:,:,1)=g_Ideal(:,:,1,1);g(:,:,2)=g_Ideal(:,:,1,2);g(:,:,3)=g_Ideal(:,:,1,3);

%%
tic
J = newcostFunction(phi,g,omegaXY,dXY);
fprintf('Cost at test theta (zeros): %f\n', J);

%  Set options for fminunc
Tol = 1e-4;
options = optimset('Display','iter', 'MaxIter', 30,'TolX',Tol);


%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 

[phiRecon, J] = ...
	fminunc(@(t)(newcostFunction(t, g,omegaXY,dXY)), phi, options);
toc

% Print theta to screen
fprintf('Cost at theta found by fminunc: %f\n', J);
fprintf('theta: %f\n',phiRecon);