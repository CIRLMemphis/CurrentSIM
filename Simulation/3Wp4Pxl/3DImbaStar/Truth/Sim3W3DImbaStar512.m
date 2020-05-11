run("Sim3W3DImbaStar512Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DImbaStar512.mat";

%% run forward model and save the results into CIRLDataPath
ob = StarLikeSample(3,512,8,20,3,0.6);
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DImbaStar256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');