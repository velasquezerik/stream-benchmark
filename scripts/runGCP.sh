#!/bin/bash

### GCP EXECUTION

### Configuration ###################################################

# Time and executions options

    # Create timestamp
		timestamp=$(date +%Y%d%m-%H%M%S)

# Compilers and tools
#

	##Compilers for GCP (example)
	#source /opt/intel/oneapi/setvars.sh

	#Compilers Variables

        # Intel Compilers
        CXX_COMPILER=icpc
        C_COMPILER=icc
		MPI_COMPILER=mpicc

        # GNU Compilers
        #CXX_COMPILER=g++
        #C_COMPILER=gcc

	# General Variables
	#
		WORK_DIR=${PWD}/Stream
		BIN_DIR=${WORK_DIR}/bin
		LOG_DIR=${WORK_DIR}/logs
		cd ${WORK_DIR}

		# For MPI execution
		NP=4
    
    # Stream definition variables
        STREAM_ARRAY_SIZE=100000000
        NTIMES=20
    
    # Logs files
        LOG_SINGLE=LogSingleFile.log
        LOG_MULTI=LogMultiFile.log
        LOG_MPI=LogMPIFile.log

        # Execution logs
        LOGFILE_NAME_SINGLE=GCP_STREAM_SINGLE_LOG_${HOSTNAME}_${timestamp}.log
        LOGFILE_NAME_MULTI=GCP_STREAM_MULTI_LOG_${HOSTNAME}_${timestamp}.log
        LOGFILE_NAME_MPI=GCP_STREAM_MPI_LOG_${HOSTNAME}_${timestamp}.log

        # Data logs
        LOGFILE_NAME_SINGLE_DATA=GCP_STREAM_SINGLE_DATA_LOG_${HOSTNAME}_${timestamp}.log
        LOGFILE_NAME_MULTI_DATA=GCP_STREAM_MULTI_DATA_LOG_${HOSTNAME}_${timestamp}.log
        LOGFILE_NAME_MPI_DATA=GCP_STREAM_MPI_DATA_LOG_${HOSTNAME}_${timestamp}.log



#####################################################################

#####################################################################

#Compiling Code

	mkdir -p build && cd build
	cmake -D CMAKE_C_COMPILER=icc -D CMAKE_CXX_COMPILER=icpc .. && make
	cd ${WORK_DIR}

#####################################################################


#####################################################################

#Run Code

    # Single Core
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark Application, Single Core..."
	echo "---------------------------------------------------------------------"
	${BIN_DIR}/stream_single &> ${LOG_DIR}/${LOG_SINGLE}


    # Multi Core
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark Application, Multi Core..."
	echo "---------------------------------------------------------------------"
	${BIN_DIR}/stream_multi &> ${LOG_DIR}/${LOG_MULTI}

	# MPI
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark Application, MPI..."
	echo "---------------------------------------------------------------------"
	mpirun -np ${NP} ${BIN_DIR}/stream_mpi &> ${LOG_DIR}/${LOG_MPI}

#####################################################################

#####################################################################
# Edit logs name and move

	# Edit and move
		echo ""
	    echo "---------------------------------------------------------------------"
	    echo "Renaming Single After execution log file..."
	    echo "---------------------------------------------------------------------"
	    mv ${LOG_DIR}/${LOG_SINGLE} ${LOG_DIR}/${LOGFILE_NAME_SINGLE}
		# Move Log Data
	    mv ${WORK_DIR}/STREAM_BENCHMARK_SINGLE_log.log ${LOG_DIR}/${LOGFILE_NAME_SINGLE_DATA}


	# Edit and move
		echo ""
	    echo "---------------------------------------------------------------------"
	    echo "Renaming Multi After execution log file..."
	    echo "---------------------------------------------------------------------"
	    mv ${LOG_DIR}/${LOG_MULTI} ${LOG_DIR}/${LOGFILE_NAME_MULTI}
		# Move log data
	    mv ${WORK_DIR}/STREAM_BENCHMARK_MULTI_log.log ${LOG_DIR}/${LOGFILE_NAME_MULTI_DATA}
	
	# Edit and move
		echo ""
	    echo "---------------------------------------------------------------------"
	    echo "Renaming MPI After execution log file..."
	    echo "---------------------------------------------------------------------"
	    mv ${LOG_DIR}/${LOG_MPI} ${LOG_DIR}/${LOGFILE_NAME_MPI}
		# Move log data
	    mv ${WORK_DIR}/STREAM_BENCHMARK_MPI_log.log ${LOG_DIR}/${LOGFILE_NAME_MPI_DATA}

#####################################################################
