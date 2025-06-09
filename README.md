# MnM-W-MMGBSA
Requirements:
1. Gromacs installation
2. AmberTools installation
3. Pymol

Procedure:
1. Put all the required files in the working directory from 'required_files' directory.
2. Calculate interface residues using 'InterfaceResidues_0point5all.py' script and write the residues in 'interface_residues.txt' file in comma separated values.
3. Run the MD simlation using 'mdrun_gromacs.sbatch' script (adjust the parameters based on Local/HPC environment).
4. Run the MMGBSA using 'mmgbsa_analysis.sbatch' script (put appropriate ligand mask in '-n' option while generating topologies using 'ante-MMPBSA').
5. An example system for MnM-W-MMGBSA is given in the 'example' directory.
