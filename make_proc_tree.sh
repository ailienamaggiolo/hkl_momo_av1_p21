#!/bin/bash
# before running "do_all.sh" need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start

###########################################################################
#
# Make file tree for processing crystallography files
#
#                                                 Ailiena Maggiolo 07/23/19
#
###########################################################################

# Make proc directories from all_sca_proc.txt
# Note: directory structure is important here.

INPUT_SCA_FILES="../proc/all_sca_proc_P21.txt"


while read in;
  do DIRS=`echo "$(dirname $in)"`
  mkdir $DIRS
done < $INPUT_SCA_FILES
