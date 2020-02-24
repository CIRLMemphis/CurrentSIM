#!/bin/bash
#SBATCH --partition computeq
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=3000M
#SBATCH --time=0-4:00:00

# just in case purge the old modules and load Matlab module
module purge
module load matlab

# run matlab program via the run_matlab script
logFile=ExpTunableOneShotMB0408NormBeadNoDouble.log
mFile=ExpTunableOneShotMB0408NormBeadNoDouble.m
/public/apps/matlab/R2018a/bin/matlab -nodisplay -nosplash -nodesktop -logfile $logFile -r "run $mFile;quit;"
