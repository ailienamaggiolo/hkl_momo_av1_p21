#!/bin/bash
# before running "do_all.sh" need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start

###########################################################################
#
# Fetch all sca files for scripted processing, HKL2000-output
#
#                                                 Ailiena Maggiolo 07/23/19
#
###########################################################################


# Extracts all sca files from cassette directory and exports into "all_sca.txt"
# Creates a second file which templates the processed files directory tree called "all_sca_proc.txt"
# Note: directory structure is important here. Have all sca files in a folder named with the cassette number.
# May need to trouble shoot by telling the script where the cassette number is in the directory. In this case, if each field is defined by "/" then the cassette number is the 7th field.

# Can easily grab all necessary sca from cassette directory by using the following command then sorting by hand
  #>rsync -avh --include='*/' --include='*.sca' --exclude='*' 297 297_sca

# Assign input directory, which must be a cassette number
IMPORT="/data/mag/AM_Drive_8/data/190110_sca/210"

# Assign a cassette number from directory
CASSETTE=$(basename "${IMPORT}")

# Assign a working directory
WDIR=$(dirname "${IMPORT}")

# Assign a folder for proceesed files: proc
PROC=$WDIR/proc

###################################################################################

# make proc folder
if [ ! -f $PROC ]; then
  mkdir $PROC
else
   echo "output files to proc directory"
fi

EXPORT1=$WDIR/proc/all_sca_P21.txt
EXPORT2=$WDIR/proc/all_sca_proc_P21.txt

find $IMPORT -name "*P21*.sca" > $EXPORT1
find $IMPORT -name "*P21*.sca" | sed -e "s,$CASSETTE,proc,g" > $EXPORT2
