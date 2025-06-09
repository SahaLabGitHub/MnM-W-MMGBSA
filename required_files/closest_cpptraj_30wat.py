# Read residue numbers from the .txt file
with open("interface_residues.txt", "r") as f:
    residue_str = f.read().strip()
 
# Generate the cpptraj input script
cpptraj_script = f"""
parm amber_solvatedtopology.prmtop
# Extract 100 frames from the 4th ns of the trajectory
trajin centered_trajectory_amber.mdcrd 1 100 1
center @CA,C,N mass origin
image origin center
strip :Cl-,:Na+,:CL,:NA
closest 30 :{residue_str} noimage closestout closest30wat.dat parmout complex_30wat.prmtop 
trajout stripped_trajectory_complex_30wat.mdcrd nobox
run
"""
 
# Write the cpptraj input script to a file
with open("complex_30wat.cpptraj", "w") as f:
    f.write(cpptraj_script)
 
print("CPPTRAJ input script generated: complex_30wat.cpptraj") 
