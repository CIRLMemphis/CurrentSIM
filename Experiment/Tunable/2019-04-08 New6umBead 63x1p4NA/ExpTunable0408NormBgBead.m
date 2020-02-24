%%
run("../../../CIRLSetup.m");
matFile = CIRLDataPath + "/2019-04-08 New6umBead 63x1p4NA SIM/Data_20190408_6umBead_63x1p4NA.mat";
load(matFile);
g = BackgroundRemove(IntensityNormalize(g), 50);

%%
save(CIRLDataPath + "/2019-04-08 New6umBead 63x1p4NA SIM/NormBgData_20190408_6umBead_63x1p4NA.mat", 'g');