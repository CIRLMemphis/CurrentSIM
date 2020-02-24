#!/bin/bash
#SBATCH --partition computeq
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=4000M
#SBATCH --time=0-01:00:00

# just in case purge the old modules and load Matlab module
module purge
module load matlab

# run matlab program via the run_matlab script
logFile=ExpTunableOptGWF0408NormBgBead.log
mFile=ExpTunableOptGWF0408NormBgBead.m
/public/apps/matlab/R2018a/bin/matlab -nodisplay -nosplash -nodesktop -logfile $logFile -r "run $mFile;quit;"
