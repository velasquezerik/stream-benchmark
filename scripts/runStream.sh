#!/bin/bash

### Configuration ###################################################

# tools

	# General Variables
	#
		cd ../..
		WORK_DIR=$PWD
        STREAM_DIR=${PWD}/Stream
		LOG_DIR=${STREAM_DIR}/logs
        SCRIPT_DIR=${STREAM_DIR}/scripts
    
    # GCP variables
        COMPUTE_INSTANCE=tmi-test
    
    # Remote variables
        COMPUTE_NODE=192.168.1.144
        COMPUTE_USER=root


# Define local execution

local_execution(){ 
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark: LOCAL"
	echo "---------------------------------------------------------------------"
    
    sh ${SCRIPT_DIR}/runLocal.sh

    echo "---------------------------------------------------------------------"
    echo "End of Stream Benchmarck"
    echo "---------------------------------------------------------------------"
}

# Define gcp execution

gcp_execution(){ 
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark: GCP"
	echo "---------------------------------------------------------------------"

    # Copy data
    gcloud compute scp ${STREAM_DIR}/ ${COMPUTE_INSTANCE}:~/

    #execute command
    gcloud compute ssh ${COMPUTE_INSTANCE} --command="sh Stream/scripts/runGCP.sh"

    # Get data
    gcloud compute scp ${COMPUTE_INSTANCE}:~/Stream/logs/ ${LOG_DIR}

    echo "---------------------------------------------------------------------"
    echo "End of Stream Benchmarck"
    echo "---------------------------------------------------------------------"
}

# Define remote execution

remote_execution(){ 
    echo ""
	echo "---------------------------------------------------------------------"
	echo "Executing Stream benchmark: REMOTE"
	echo "---------------------------------------------------------------------"
    
    # Copy data
    scp ${STREAM_DIR}/ ${COMPUTE_USER}@${COMPUTE_NODE}:~/

    #execute command
    ssh ${COMPUTE_USER}@${COMPUTE_NODE} "sh Stream/scripts/runRemote.sh"

    # Get data
    scp ${COMPUTE_USER}@${COMPUTE_NODE}:~/Stream/logs/ ${LOG_DIR}

    echo "---------------------------------------------------------------------"
    echo "End of Stream Benchmarck"
    echo "---------------------------------------------------------------------"
}


#####################################################################

### Execution #######################################################

# Define options for execution

    case "$1" in
        "local")
            local_execution
        ;;

        "gcp")
            gcp_execution
        ;;

        "remote")
            remote_execution
        ;;

        *)
        echo "You have failed to specify what to do correctly."
        echo "Default option local"
        local_execution
        exit 1
        ;;
    esac

#####################################################################
