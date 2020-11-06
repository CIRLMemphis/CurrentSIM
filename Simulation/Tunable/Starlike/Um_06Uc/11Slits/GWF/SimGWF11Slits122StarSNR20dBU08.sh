#!/bin/bash
#SBATCH --partition computeq
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=10000M
#SBATCH --time=0-01:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=jmhammed@memphis.edu

# just in case purge the old modules and load Matlab module
module purge
module load matlab

# run matlab program via the run_matlab script
logFile=SimGWF11Slits122StarSNR20dBU08.log
mFile=SimGWF11Slits122StarSNR20dBU08.m
/public/apps/matlab/R2018a/bin/matlab -nodisplay -nosplash -nodesktop -logfile $logFile -r "run $mFile;quit;"
