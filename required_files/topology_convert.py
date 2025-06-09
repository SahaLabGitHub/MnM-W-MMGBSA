import parmed as pmd
gmx_top = pmd.load_file('topol.top', xyz='md4ns.gro')
gmx_top.save('amber_solvatedtopology.prmtop', format='amber')
gmx_top.save('amber_solvatedgro.crd', format='rst7')
