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
#                                                 Ailiena Maggiolo 07/23/19
#
###########################################################################

date

#comment out block for script testing-- leave commented to run script. Place STOP at end of comment block.
#: <<'STOP'
#STOP

# Directory for each homemade script for CCP4 run_programs
RUN_PROGRAMS='/data/mag/AM_Drive_8/ccp4_scripts/github_ccp4_proc/hkl_momo/av1_p21/hkl_momo_av1_p21/run_programs'

#-------# SCALEPACK2MTZ_ANO

# Define SCALEPACK2MTZ input file names-- leave untouched
# Note: FreeR flag imported in SCLAEPACK2MTZ. Directory and filename is declared in the "ccp4_HKL2000_scalepack2mtz_proc" program.
      # For script trouble shooting: INPUT_SCA='/data/ailiena/AM_Drive_6/data/190326_test/297/A2_12658/Av1_297A2_12658_output_P21.sca'
INPUT_SCA=$1 #INPUT

# output of SCALEPACK2MTZ (with ano) = OUTPUT.MTZ
CASSETTE=`echo $(dirname "${INPUT_SCA}") | rev | cut -d"/" -f 2 | rev`
WDIR=`echo $(dirname "${INPUT_SCA}") | sed -e "s,$CASSETTE,proc,g"`
FILENAME=`echo $(basename "${INPUT_SCA}") | sed -e "s,sca,mtz,g"`
OUTPUT_MTZ=`echo "$WDIR"/"$FILENAME"` #OUTPUT
# OUTPUT_SCA='/data/ailiena/AM_Drive_6/data/190326_test/proc/A2_12658/Av1_297A2_12658_output_P21_noano.mtz'


#-------# SCALEPACK2MTZ_NOANO

# Define SCALEPACK2MTZ input file names-- leave untouched
# Note: FreeR flag imported in SCLAEPACK2MTZ. Directory and filename is declared in the "ccp4_HKL2000_scalepack2mtz_proc" program.
      # For script trouble shooting: INPUT_SCA='/data/ailiena/AM_Drive_6/data/190326_test/297/A2_12658/Av1_297A2_12658_output_P21.sca'
#INPUT_SCA=$1 #INPUT

# output of SCALEPACK2MTZ_NOANO (with no ano) = OUTPUT_NOANO.mtz
CASSETTE=`echo "$INPUT_SCA" | cut -d"/" -f 7`
WDIR=`echo $(dirname "${INPUT_SCA}") | sed -e "s,$CASSETTE,proc,g"`
FILENAME=`echo $(basename "${INPUT_SCA}") | sed -e "s,P21,P21_noano,g" | sed -e "s,sca,mtz,g"`
OUTPUT_NOANO_MTZ=`echo "$WDIR"/"$FILENAME"` #OUTPUT
# OUTPUT_SCA='/data/ailiena/AM_Drive_6/data/190326_test/proc/A2_12658/Av1_297A2_12658_output_P21_noano.mtz'


#-------# RBP_REFMAC_ANO

# RBP_REFMAC input mtz file (with ano) = OUTPUT.mtz (same as input for SCLAEPACK2MTZ) #$OUTPUT_MTZ
# RBP_REFMAC input pdb file (with ano) = MR_MODEL.pdb (defined in ccp4_HKL2000_RBP_REFMAC.sh as "IMPORT_PDB")

# output of RBP_REFMAC (with ano) = REFMAC1.MTZ
REFMAC_MTZ=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac1,g' | sed -e 's,sca,mtz,g'`
OUTPUT_REFMAC1_MTZ=`echo "$WDIR"/"$REFMAC_MTZ"` #OUTPUT_RBP_REFMAC1

# output of RBP_REFMAC (with ano) = REFMAC1.PDB
REFMAC_PDB=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac1,g' | sed -e 's,sca,pdb,g'`
OUTPUT_REFMAC1_PDB=`echo "$WDIR"/"$REFMAC_PDB"` #OUTPUT_RBP_REFMAC1


#-------# RBP_REFMAC_NOANO

# RBP_REFMAC_NOANO input mtz file (with no ano) = OUTPUT_NOANO.mtz (same as input for SCLAEPACK2MTZ) #$OUTPUT_NOANO_MTZ
# RBP_REFMAC_NOANO input pdb file (with no ano) = MR_MODEL.pdb (defined in ccp4_HKL2000_RBP_REFMAC.sh as "IMPORT_PDB")

# output of RBP_REFMAC (with no ano) = REFMAC1_NOANO.MTZ
REFMAC_MTZ_NOANO=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac1_noano,g' | sed -e 's,sca,mtz,g'`
OUTPUT_REFMAC1_MTZ_NOANO=`echo "$WDIR"/"$REFMAC_MTZ_NOANO"` #OUTPUT_RBP_REFMAC1_NOANO

# output of RBP_REFMAC (with ano) = REFMAC1_NOANO.PDB
REFMAC_PDB_NOANO=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac1_noano,g' | sed -e 's,sca,pdb,g'`
OUTPUT_REFMAC1_PDB_NOANO=`echo "$WDIR"/"$REFMAC_PDB_NOANO"` #OUTPUT_RBP_REFMAC1_NOANO


#-------# REFMAC_RESTRAINED_ANO

# REFMAC_RESTRAINED input mtz file (with ano) = OUTPUT.mtz (same as input for SCLAEPACK2MTZ) #$OUTPUT_MTZ
# REFMAC_RESTRSINED input pdb file (with ano) = $OUTPUT_REFMAC1_PDB (defined in ccp4_HKL2000_RBP_REFMAC.sh as "OUTPUT_REFMAC1_PDB")

# output of RBP_REFMAC (with ano) = REFMAC1.MTZ
REFMAC2_MTZ=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac2,g' | sed -e 's,sca,mtz,g'`
OUTPUT_REFMAC2_MTZ=`echo "$WDIR"/"$REFMAC2_MTZ"` #OUTPUT_RBP_REFMAC2

# output of RBP_REFMAC (with ano) = REFMAC1.PDB
REFMAC2_PDB=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac2,g' | sed -e 's,sca,pdb,g'`
OUTPUT_REFMAC2_PDB=`echo "$WDIR"/"$REFMAC2_PDB"` #OUTPUT_RBP_REFMAC2


#-------# REFMAC_RESTRAINED_NOANO

# REFMAC_RESTRAINED input mtz file (with ano) = OUTPUT.mtz (same as input for SCLAEPACK2MTZ) #$OUTPUT_MTZ
# REFMAC_RESTRSINED input pdb file (with ano) = $OUTPUT_REFMAC1_PDB (defined in ccp4_HKL2000_RBP_REFMAC.sh as "OUTPUT_REFMAC1_PDB")

# output of RBP_REFMAC (with ano) = REFMAC1.MTZ
REFMAC2_MTZ_NOANO=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac2_noano,g' | sed -e 's,sca,mtz,g'`
OUTPUT_REFMAC2_MTZ_NOANO=`echo "$WDIR"/"$REFMAC2_MTZ_NOANO"` #OUTPUT_RBP_REFMAC2_NOANO

# output of RBP_REFMAC (with ano) = REFMAC1.PDB
REFMAC2_PDB_NOANO=`echo $(basename "${INPUT_SCA}") | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac2_noano,g' | sed -e 's,sca,pdb,g'`
OUTPUT_REFMAC2_PDB_NOANO=`echo "$WDIR"/"$REFMAC2_PDB_NOANO"` #OUTPUT_RBP_REFMAC2_NOANO


#-------# CAD_ANO

# CAD_ANO input mtz file1 (with ano) = OUTPUT.mtz #$OUTPUT_MTZ
# CAD_ANO input mtz file2 (with no ano) = REFMAC2_NOANO.mtz #$OUTPUT_REFMAC2_MTZ_NOANO

NAME_CAD_ANO=`echo $(basename "${INPUT_SCA}") | sed -e 's,P21,P21_CADano,g' | sed -e 's,sca,mtz,g'`
OUTPUT_CAD_ANO=`echo "$WDIR"/"$NAME_CAD_ANO"` #OUTPUT_CAD_ANO


#-------# FFT_ANO

# FFT input mtz file = OUTPUT_CAD_ANO.mtz #$OUTPUT_CAD_ANO
NAME_FFT=`echo $(basename "${OUTPUT_CAD_ANO}") | sed -e 's,mtz,map,g'`
OUTPUT_FFT=`echo "$WDIR"/"$NAME_FFT"` #OUTPUT_FFT


#-------# make file to output all log files in each data set
LOGDIR=$WDIR/log

if [ ! -f $LOGDIR ]; then
  mkdir $LOGDIR
else
   echo "writing progress to log directory. Continuing next step..."
fi


#############################################################################


# Run SCALEPACK2MTZ step 1 of 8
if [ ! -f $OUTPUT_MTZ ]; then
  $RUN_PROGRAMS/ccp4_HKL2000_scalepack2mtz_proc.sh $INPUT_SCA
else
   echo "$OUTPUT_MTZ exists. Continuing next step..."
fi


# Run SCALEPACK2MTZ with noano step 2 of 8
if [ ! -f $OUTPUT_NOANO_MTZ ]; then
  $RUN_PROGRAMS/ccp4_HKL2000_scalepack2mtz_proc_noano.sh $INPUT_SCA
else
   echo "$OUTPUT_NOANO_MTZ exists. Continuing next step..."
fi


# Run REFMAC rigid body refine step 3 of 8
if [ ! -f $OUTPUT_REFMAC1_PDB ]; then
  $RUN_PROGRAMS/ccp4_HKL2000_RBP_REFMAC.sh $OUTPUT_MTZ
else
  echo "$OUTPUT_REFMAC1_PDB exists. Continuing next step.. "
fi


# Run REFMAC rigid body refine step 4 of 8
if [ ! -f $OUTPUT_REFMAC1_PDB_NOANO ]; then
    $RUN_PROGRAMS/ccp4_HKL2000_RBP_REFMAC_noano.sh $OUTPUT_NOANO_MTZ
else
    echo "$OUTPUT_REFMAC1_PDB_NOANO exists. Continuing next step.. "
fi


# Run REFMAC restrained refine step 5 of 8
if [ ! -f $OUTPUT_REFMAC2_MTZ ]; then
  $RUN_PROGRAMS/ccp4_HKL2000_REFMAC_restrained.sh $OUTPUT_MTZ
else
    echo "$OUTPUT_REFMAC2_MTZ exits. Continuing next step..."
fi


# Run REFMAC restrained refine step 6 of 8
if [ ! -f $OUTPUT_REFMAC2_PDB_NOANO ]; then
  $RUN_PROGRAMS/ccp4_HKL2000_REFMAC_restrained_noano.sh $OUTPUT_NOANO_MTZ
else
    echo "$OUTPUT_REFMAC2_PDB_NOANO exits. Continuing next step..."
fi


# Run CAD anomalous maps step 7 of 8
if [ ! -f $OUTPUT_CAD_ANO ]; then
  $RUN_PROGRAMS/ccp4_HKL2000_CADano.sh $OUTPUT_MTZ
else
    echo "$OUTPUT_CAD_ANO exits. Continuing next step..."
fi


# Run FFT convert to map step 8 of 8
if [ ! -f $OUTPUT_FFT ]; then
  $RUN_PROGRAMS/ccp4_HKL2000_FFTano.sh $OUTPUT_CAD_ANO
else
    echo "$OUTPUT_FFT exits. Continuing next step..."
fi




# Check if last set was compeleted
if [ -e "$OUTPUT_FFT" ]; then
    echo "PROCESSING COMPLETE: SUCCESS"
else
    echo "PROCESSING INCOMPLETE FOR THIS DATA SET"
fi

date
