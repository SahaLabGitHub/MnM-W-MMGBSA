#!/bin/bash

# Written by M. N. Hasan, 2025
# 
# Please read the README file before proceeding.
# Gromacs needs to be installed
#
######################################################
# HERE ARE VARIABLES THAT NEED TO BE MODIFIED BY USER#
######################################################

#SBATCH --partition=gpu
#SBATCH -J 1ay7
#SBATCH --cpus-per-task=32

source /sharedapps/spack/share/spack/setup-env.sh
spack env activate Gromacs-GPU-thread
spack load gromacs@2023/pivoddm

export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_FORCE_UPDATE_DEFAULT_GPU=true

export CUDA_VISIBLE_DEVICES=0

######################################################
# END OF USER MODIFIABLE VARIABLES                   #
######################################################


gmx pdb2gmx -f 1ay7_moe_prep.pdb -o processed.gro -p topol.top
gmx editconf -f processed.gro -o complex_box.gro -c -d 1.0 -bt cubic
gmx solvate -cp complex_box.gro -cs spc216.gro -p topol.top -o solv.gro
gmx grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr
gmx genion -s ions.tpr -o complex_box_wSPCE_ions.gro -p topol.top -pname NA -nname CL -neutral
gmx grompp -f minim.mdp -c complex_box_wSPCE_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -v -deffnm nvt
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top  -o npt.tpr
gmx mdrun -v -deffnm npt
gmx grompp -f md4ns.mdp -c npt.gro -t npt.cpt -p topol.top -o md4ns.tpr
gmx mdrun -v -deffnm md4ns 
gmx trjconv -f md4ns.xtc -s md4ns.tpr -o md4ns_whole.xtc -pbc whole
gmx trjconv -f md4ns_whole.xtc -s md4ns.tpr -o md4ns_whole_nojump.xtc -pbc nojump
gmx trjconv -f md4ns_whole_nojump.xtc -s md4ns.tpr -o md4ns_whole_nojump_nopbc.xtc -pbc mol -center \

