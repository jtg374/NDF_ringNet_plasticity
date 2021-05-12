#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p serial
#SBATCH -o ../log/result.%J.%x.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jtg374@nyu.edu
#SBATCH -t 0-1:00

module purge
module load matlab/2018a
matlab -nodisplay -r "disp('$1.m');disp('$2');$1('$2');quit"
