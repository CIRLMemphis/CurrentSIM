run('../../../CIRLSetup.m');
load("Z:\Archives-SIM Illumination\2019\2019-04--- Fresnell Data & Tests\070919 9Slit_6umCluster&GB_SR\FSIM_070919_9S_Glioblastoma_2.mat");

%%
g = reshape(g, [1000 1000 300 1 3]);
save(CIRLDataPath + "/TunableData/071919_Glioblastoma/070919_Glioblastoma2.mat", 'g', '-v7.3');

g = g(244+1:1000-244, 244+1:1000-244, 22+1:300-22, :, :);
save(CIRLDataPath + "/TunableData/071919_Glioblastoma/070919_Glioblastoma2_Grid512x256.mat", 'g');

%%
g = g(:, :, 100:100+127, :, :);
save(CIRLDataPath + "/TunableData/071919_Glioblastoma/070919_Glioblastoma2_Grid512x128.mat", 'g');