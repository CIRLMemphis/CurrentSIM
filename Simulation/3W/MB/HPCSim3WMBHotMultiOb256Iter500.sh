#!/bin/bash
#SBATCH --partition computeq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5000M
#SBATCH --time=7-00:00:00

# just in case purge the old modules and load Matlab module
module purge
module load matlab

# run matlab program via the run_matlab script
logFile=Sim3WMBHotMultiOb256Iter500.log
mFile=Sim3WMBHotMultiOb256Iter500.m
/public/apps/matlab/R2018a/bin/matlab -nodisplay -nosplash -nodesktop -logfile $logFile -r "run $mFile;quit;"