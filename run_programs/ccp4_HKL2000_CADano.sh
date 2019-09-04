#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, HKL2000-output
# Step 7 of 8 -- CAD merge anomalous mtz
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Input MTZ_1=output.mtz
INPUT_MTZ_1=$1


# Input MTZ_2=REFMAC2_NOANO.mtz
INPUT_MTZ_2=`echo "$INPUT_MTZ_1" | sed -e 's,output,RBP,g' | sed -e 's,P21,refmac2_noano,g'` # HKLIN2


#comment out block for script testing-- leave commented to run REFMAC
#: <<'STOP'

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT_MTZ_1}")`
FILENAME_MTZ2=`echo $(basename "${INPUT_MTZ_2}")`

WDIR=$(dirname "${INPUT_MTZ_1}")
LOGFILE_CAD="$WDIR"/log/"$FILENAME_MTZ2".log

# Declare output file names for REFMAC rigid body refine
OUTPUT_MTZOUT=$INPUT_MTZ_1.mtz


date

echo "STARTING CAD..."
echo "starting input $INPUT_MTZ_2"



$CCP4/cad HKLIN1 $INPUT_MTZ_1 HKLIN2 $INPUT_MTZ_2 HKLOUT $OUTPUT_MTZOUT <<+ >>$LOGFILE_CAD
 title
monitor BRIEF
labin file 1 -
    E1 = DANO -
    E2 = SIGDANO
labout file 1 -
    E1 = DANO -
    E2 = SIGDANO
ctypin file 1 -
    E1 = D -
    E2 = Q
labin file 2 -
    ALL
+
#STOP

#clean up extensions
echo "cleaning extensions..."
NAME_CAD=`echo "$INPUT_MTZ_1" | cut -d'.' -f 1 | sed -e 's,P21,P21_CADano,g'`
mv $INPUT_MTZ_1.mtz $NAME_CAD.mtz

NAME_LOG=`echo "$FILENAME_MTZ2" | cut -d'.' -f 1 | sed -e 's,P21,P21_CADano,g'`
mv $LOGFILE_CAD "$WDIR"/log/"$NAME_LOG".log

echo 'CAD JOB DONE'
