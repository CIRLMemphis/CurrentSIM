#!/bin/bash
#SBATCH --partition computeq
#SBATCH --nodes 1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=2000M
#SBATCH --time=0-00:30:00
#SBATCH --mail-type=END
#SBATCH --mail-user=cvan@memphis.edu

# just in case purge the old modules and load Matlab module
module purge
module load matlab

# run matlab program via the run_matlab script
logFile=SimTunable9SlitsOSSRMultiOb512.log
mFile=SimTunable9SlitsOSSRMultiOb512.m
/public/apps/matlab/R2018a/bin/matlab -nodisplay -nosplash -nodesktop -logfile $logFile -r "run $mFile;quit;"
