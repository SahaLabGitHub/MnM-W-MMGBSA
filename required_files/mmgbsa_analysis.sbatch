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
#SBATCH -J analysis
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=10

#adjust the AmberTools23 source directory as per the HPC/Local environment
source ~/Data/conda/bin/activate AmberTools23

ppiname="1ay7"

export CUDA_VISIBLE_DEVICES=0

#convert Gromacs .top and .gro into Amber format
python3 topology_convert.py

#convert Gromacs trajectory into Amber format
cpptraj -i convert_trajectory_center.in

#regular mmgbsa

#convert gromacs trajectory to amber removing solvents and ions
cpptraj -i dry_convert_trajectory_center.in

#generate dry_complex_topology, put appropriate mask for the ligand residues in -n
cpptraj -i dry_topology.cpptraj
ante-MMPBSA.py -p complex_dry.prmtop -c complex_dry_igb8rad_complex.prmtop -r complex_dry_igb8rad_receptor.prmtop -l complex_dry_igb8rad_ligand.prmtop -s :NA:CL:SOL:WAT -n :97-185 --radii mbondi3

mpirun -np 10 MMPBSA.py.MPI -i mmgbsa.in  -o RESULT_4thns_dry_igb8mmgbsa_$ppiname.dat -eo RESULT_4thns_dry_igb8mmgbsa_$ppiname.csv -cp complex_dry_igb8rad_complex.prmtop -rp complex_dry_igb8rad_receptor.prmtop -lp complex_dry_igb8rad_ligand.prmtop  -y centered_trajectory_amber_dry.mdcrd


#mmgbsa with interfacial waters

#convert the trajectory containing interfacial waters
python3 closest_cpptraj_30wat.py
cpptraj -i complex_30wat.cpptraj  > complex_30wat_cpptraj.log

#generate topology for the nwat complex, receptor and ligand, put appropriate mask for the ligand residues in -n
ante-MMPBSA.py -p complex_30wat.prmtop -c complex_30wat_igb8rad_complex.prmtop -r complex_30wat_igb8rad_receptor.prmtop -l complex_30wat_igb8rad_ligand.prmtop -s :NA:CL -n :97-185 --radii mbondi3 

#do mmgbsa
mpirun -np 10 MMPBSA.py.MPI -i mmgbsa.in  -o RESULT_4thns_30wat_igb8mmgbsa_$ppiname.dat -eo RESULT_4thns_30wat_igb8mmgbsa_$ppiname.csv -cp complex_30wat_igb8rad_complex.prmtop -rp complex_30wat_igb8rad_receptor.prmtop -lp complex_30wat_igb8rad_ligand.prmtop  -y stripped_trajectory_complex_30wat.mdcrd  \

