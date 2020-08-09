run("../../../CIRLSetup.m");

%% run forward model and save the results into CIRLDataPath
ob = StarLikeSample(3,512,8,20,3,0.7);
crop_g = ob(1:256,1:256,256);
save(char("validation/outSimStarLike.mat"), 'crop_g');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DStar256.mat";
load(matFile, 'g');
crop_g = g(1:128,1:128,128,:,:);
save(char("validation/inSimStarLike.mat"), 'crop_g');