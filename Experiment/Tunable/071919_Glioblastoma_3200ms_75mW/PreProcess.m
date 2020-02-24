run('../../../CIRLSetup.m');
load(CIRLDataPath + "/TunableData/071919_Glioblastoma/FSIM_071719_3S_GB_SR75mw.mat");
g = reshape(g, [800 800 300 1 3]);
save(CIRLDataPath + "/TunableData/071919_Glioblastoma/071919_Glioblastoma_3200ms_75mW.mat", 'g', '-v7.3');

g = g(144+1:800-144, 144+1:800-144, 22+1:300-22, :, :);
save(CIRLDataPath + "/TunableData/071919_Glioblastoma/071919_Glioblastoma_3200ms_75mW_Grid512.mat", 'g');

g = g(:, :, 100:100+127, :, :);
save(CIRLDataPath + "/TunableData/071919_Glioblastoma/071919_Glioblastoma_3200ms_75mW_Grid512x128.mat", 'g');