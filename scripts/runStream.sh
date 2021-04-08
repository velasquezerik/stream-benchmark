#!/bin/bash

### Configuration ###################################################

# Compilers and tools
#

	##Compilers for local (example)
	#source /opt/intel/oneapi/setvars.sh

	#Compilers Variables

        # Intel Compilers
        CXX_COMPILER=icpc
        C_COMPILER=icc

        # GNU Compilers
        #CXX_COMPILER=g++
        #C_COMPILER=gcc

	# General Variables
	#
		cd ..
		WORK_DIR=$PWD
		#SRC_DIR=${WORK_DIR}/src
		#INC_DIR=${WORK_DIR}/include
		BIN_DIR=${WORK_DIR}/bin
		LOG_DIR=${WORK_DIR}/logs
    
    # Stream definition variables
        STREAM_ARRAY_SIZE=100000000
        NTIMES=20


#####################################################################

#####################################################################

#Compiling Code

	mkdir -p build && cd build
	#cmake .. && make
    #cmake -D CMAKE_C_COMPILER=icc -D CMAKE_CXX_COMPILER=icpc -D STREAM_ARRAY_SIZE=${STREAM_ARRAY_SIZE} -D NTIMES=${NTIMES} .. && make
    cmake -D CMAKE_C_COMPILER=icc -D CMAKE_CXX_COMPILER=icpc .. && make
	cd ..

#####################################################################


#####################################################################

#Run Code

    # Single Core
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark Application, Single Core..."
	echo "---------------------------------------------------------------------"
	${BIN_DIR}/stream_single &> LogSingleFile.log


    # Multi Core
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark Application, Multi Core..."
	echo "---------------------------------------------------------------------"
	${BIN_DIR}/stream_multi &> LogMultiFile.log

#####################################################################

#####################################################################
# Edit logs name and move

	# Create timestamp

		timestamp=$(date +%Y%d%m-%H%M%S)

	# Edit and move
		echo ""
	    echo "---------------------------------------------------------------------"
	    echo "Renaming Single After execution log file..."
	    echo "---------------------------------------------------------------------"
	    LOGFILE_NAME_SINGLE=STREAM_SINGLE_LOG_${HOSTNAME}_${timestamp}.log
	    mv ${WORK_DIR}/LogSingleFile.log ${LOG_DIR}/${LOGFILE_NAME_SINGLE}

	# Edit and move
		echo ""
	    echo "---------------------------------------------------------------------"
	    echo "Renaming Multi After execution log file..."
	    echo "---------------------------------------------------------------------"
	    LOGFILE_NAME_MULTI=STREAM_MULTI_LOG_${HOSTNAME}_${timestamp}.log
	    mv ${WORK_DIR}/LogMultiFile.log ${LOG_DIR}/${LOGFILE_NAME_MULTI}

#####################################################################

#####################################################################
# Print logs file to stdout
    echo ""
    echo "---------------------------------------------------------------------"
    echo "After execution Logs file content (Single CORE): "
    echo "---------------------------------------------------------------------"
    cat ${LOG_DIR}/${LOGFILE_NAME_SINGLE}
    echo ""
    echo "---------------------------------------------------------------------"
    echo "After execution Logs file content (Multi CORE): "
    echo "---------------------------------------------------------------------"
    cat ${LOG_DIR}/${LOGFILE_NAME_MULTI}
    echo "---------------------------------------------------------------------"
    echo "End of Stream Benchmarck"
    echo "---------------------------------------------------------------------"

#####################################################################