#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Generate anomalous maps, HKL2000-output
# Be sure to have already made output mtz with anomalous contributions (pipeline.sh)
# Step 1 of 8 -- SCALEPACK2MTZ with no anolaous reflections
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Retrieve HKL2000 output.sca
INPUT=$1
#INPUT="/Users/AilienaMaggiolo/Desktop/ccp4_scripts/test/297_test/A3/Av1_297A3_12658_output_P21.sca"
#INPUT="/data/ailiena/AM_Drive_6/data/190326_test/297/A2_15000/Av1_297A2_15000_output_P21.sca"

#Import FreeR_flags from another file
IMPORT_FREER="/data/mag/AM_Drive_8/data/FreeR_MTZs/Av1/Av1_190110_210A7_12658_output_P21.mtz"

#comment out block for script testing-- leave commented to run REFMAC
#: <<'STOP'

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT}")`

# Assign a cassette number from directory
CASSETTE=`echo $(dirname "${INPUT}") | rev | cut -d"/" -f 2 | rev`

#WDIR=$(dirname "${INPUT}")
WDIR=`echo $(dirname "${INPUT}") | sed -e "s,$CASSETTE,proc,g"`

LOGFILE="$WDIR"/log/"$FILENAME"_noano.log

# Extract SYMM output.sca
SYMM=$WDIR/SYMM.txt
head -3 $INPUT | tail -1 | cut -d" " -f 23 > $SYMM

# Extract CELL output.sca
CELL=$WDIR/CELL.txt
head -3 $INPUT | tail -1 | cut -d" " -f 5,8,11,15,18,22 > $CELL

# Extract RESOLUTION output.sca.log [created during proc]
RES=$WDIR/RES.txt



# Declare output file names for SCALEPACK
OUTPUT_HKL="$WDIR"/"$FILENAME".hkl_done
OUTPUT_TRUNCATE=$OUTPUT_HKL.truncate_done
OUTPUT_UNIQUE=$OUTPUT_TRUNCATE.unique_done
OUTPUT_CAD=$OUTPUT_UNIQUE.cad_done
OUTPUT_FREERFLAG=$OUTPUT_CAD.freerflag_done
OUTPUT_MTZ="$WDIR"/"$FILENAME".mtz

date

################################################


#CCP4i SCALEPACK2MTZ
echo 'starting SCALEPACK2MTZ'
$CCP4/scalepack2mtz HKLIN $INPUT HKLOUT $OUTPUT_HKL <<+ >$LOGFILE
symmetry $(cat $SYMM)
cell $(cat $CELL)
scale 1.0
anomalous -
    NO
NAME -
    PROJECT av1
end
+

#CTRUNCATE
echo 'starting CTRUNCTATE'
$CCP4/ctruncate -hklin $OUTPUT_HKL -hklout $OUTPUT_TRUNCATE -colin "/*/*/[IMEAN,SIGIMEAN]" <<+ >>$LOGFILE
+

echo 'finished CTRUNCATE'
echo "extracting RESOLUTION from $LOGFILE"

grep "Resolution range of data" $LOGFILE | cut -d" " -f7 > $RES
echo "RESOLUTION = " $(cat $RES)

#MTZ_DUMP
echo 'starting MTZ DUMP'
$CCP4/mtzdump HKLIN $OUTPUT_TRUNCATE <<+ >>$LOGFILE

NREF 0
SYMMETRY
END
+

#UNIQUE
echo 'starting UNIQUE'
$CCP4/unique HKLOUT $OUTPUT_UNIQUE <<+ >>$LOGFILE

 CELL $(cat $CELL)
SYMMETRY $(cat $SYMM)
LABOUT F=FUNI SIGF=SIGFUNI
RESOLUTION $(cat $RES)
+

#CAD
echo 'starting CAD'
$CCP4/cad HKLIN2 $OUTPUT_UNIQUE HKLIN1 $OUTPUT_TRUNCATE HKLOUT $OUTPUT_CAD HKLIN3 $IMPORT_FREER <<+ >>$LOGFILE

LABIN FILE 1  ALLIN
LABIN FILE 2  ALLIN
LABIN FILE 3 E1 = FreeR_flag
END
+


#FREER_FLAG
echo 'starting FREER FLAG'
$CCP4/freerflag HKLIN $OUTPUT_CAD  HKLOUT $OUTPUT_FREERFLAG <<+ >>$LOGFILE

COMPLETE FREE=FreeR_flag
END
+

#MTZ_UTILS
echo 'starting MTZ UTILS'
$CCP4/mtzutils HKLIN $OUTPUT_FREERFLAG HKLOUT $OUTPUT_MTZ <<+ >>$LOGFILE
EXCLUDE FUNI SIGFUNI
END
+



#clean up extensions
echo "cleaning extensions..."
NAME_MTZ=`echo "$OUTPUT_MTZ" | cut -d'.' -f1`
mv $OUTPUT_MTZ "$NAME_MTZ"_noano.mtz
NAME_MTZ_LOG=`echo "$FILENAME" | cut -d'.' -f1`
mv $LOGFILE "$WDIR"/log/"$NAME_MTZ_LOG"_sca2mtz_noano.log



# cleanup
echo "cleaning directory..."
rm $OUTPUT_HKL
rm $OUTPUT_TRUNCATE
rm $OUTPUT_UNIQUE
rm $OUTPUT_CAD
rm $OUTPUT_FREERFLAG
rm $CELL
rm $SYMM
rm $RES


#STOP
echo 'SCALEPACK JOB DONE'
