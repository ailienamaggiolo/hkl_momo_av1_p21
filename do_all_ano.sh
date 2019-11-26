#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, HKL2000-output
#
# Step 1 of 8 -- SCALEPACK2MTZ with anomalous
# Step 2 of 8 -- SCALEPACK2MTZ with no anomalous
# Step 3 of 8 -- REFMAC5 rigid body refinement with output.mtz
# Step 4 of 8 -- REFMAC5 rigid body refinement with output_noano.mtz
# Step 5 of 8 -- REFMAC5 restrained refinement with output.mtz
# Step 6 of 8 -- REFMAC5 restrained refinement with output_noano.mtz
# Step 7 of 8 -- CAD anomalous reflections to no ano refined map
# Step 8 of 8 -- FFT convert ano mtz to map
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# This program calls scripted versions of SCALEPACK2MTZ, REFMAC rigid body, and REFMAC restrained
# Input file --> text file with list of all X.sca files with full paths "all_sca.txt"
# Note: the input file is different than the "all_sca_proc.txt" which is used to create the directories for processed files

while read in;
  do /data/mag/AM_Drive_8/ccp4_scripts/HKL2000_momo/pipeline_ano.sh "$in";
done < ../proc/all_sca.txt


#test
