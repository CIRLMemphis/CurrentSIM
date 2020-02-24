#!/bin/bash
#SBATCH --partition computeq
#SBATCH --nodes 1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=5000M
#SBATCH --time=0-03:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=cvan

# just in case purge the old modules and load Matlab module
module purge
module load matlab

# run matlab program via the run_matlab script
logFile=Sim3WMBDRHotMultiOb256Iter10.log
mFile=Sim3WMBDRHotMultiOb256Iter10.m
/public/apps/matlab/R2018a/bin/matlab -nodisplay -nosplash -nodesktop -logfile $logFile -r "run $mFile;quit;"
