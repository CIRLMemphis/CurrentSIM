#!/bin/bash
#SBATCH --partition computeq
#SBATCH --nodes 1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=10000M
#SBATCH --time=4-00:00:00

# just in case purge the old modules and load Matlab module
module purge
module load matlab

# run matlab program via the run_matlab script
logFile=SimTunableMBPCSRMultiOb160Iter1000.log
mFile=SimTunableMBPCSRMultiOb160Iter1000.m
/public/apps/matlab/R2018a/bin/matlab -nodisplay -nosplash -nodesktop -logfile $logFile -r "run $mFile;quit;"
