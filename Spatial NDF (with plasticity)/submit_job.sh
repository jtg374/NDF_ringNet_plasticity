#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p serial
#SBATCH -o result.%J.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jtg374@nyu.edu
#SBATCH -t 0-15:00

module purge
module load matlab/2018a
matlab -nodisplay -r "NDF_with_Plasticity_Frameworks($4,$1,$2,$3,20);quit"
