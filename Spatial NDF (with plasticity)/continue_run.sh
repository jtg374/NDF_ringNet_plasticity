#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p serial
#SBATCH -o result.%J.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jtg374@nyu.edu
#SBATCH -t 1-12:00

module purge
module load matlab/2018a
matlab -nodisplay -r "NDF_with_Plasticity_continue('$2',$1);quit"
