#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, HKL2000-output
# Step 8 of 8 -- FFT convert anomalous mtz to map
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Input output_CAD_ANO.mtz
INPUT_MTZ=$1

# Input CADano.mtz (output Cadano.map) (only uncomment this if $INPUT_MTZ is the OUTPUT.mtz with ano)
#INPUT_CAD_MTZ=`echo "$INPUT_MTZ" | sed -e 's,P21,P21_CADano,g'` # HKLIN2


#comment out block for script testing-- leave commented to run
#: <<'STOP'

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT_MTZ}")`

WDIR=$(dirname "${INPUT_MTZ}")

LOGFILE_FFT="$WDIR"/log/"$FILENAME".log

# Declare output file names for REFMAC rigid body refine
OUTPUT_HKLOUT=$INPUT_MTZ.map


date

echo "STARTING FFT..."
echo "starting input $INPUT_MTZ"


$CCP4/fft HKLIN $INPUT_MTZ MAPOUT $OUTPUT_HKLOUT <<+ >>$LOGFILE_FFT
title
xyzlim asu
scale F1 1.0
labin -
  DANO=DANO SIG1=SIGDANO PHI=PHIC
end
+

#STOP
#clean up extensions
echo "cleaning extensions..."
NAME_FFT=`echo "$INPUT_MTZ" | cut -d'.' -f 1`
mv $INPUT_MTZ.map $NAME_FFT.map

NAME_LOG=`echo "$FILENAME" | cut -d'.' -f 1`
mv $LOGFILE_FFT "$WDIR"/log/"$NAME_LOG"_map.log

echo 'FFT JOB DONE'
