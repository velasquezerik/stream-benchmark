#!/bin/bash

### Configuration ###################################################

# tools

	# General Variables
	#
		cd ../..
		WORK_DIR=$PWD
        WORK_STREAM=${PWD}/Stream
		LOG_DIR=${WORK_STREAM}/logs
    
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
    
    source runLocal.sh

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
    gcloud compute scp ${WORK_STREAM}/ ${COMPUTE_INSTANCE}:~/

    #execute command
    gcloud compute ssh ${COMPUTE_INSTANCE} --command="cd Stream &&  ./scripts/runGCP.sh"

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
    scp ${WORK_STREAM}/ ${COMPUTE_USER}@${COMPUTE_NODE}:~/

    #execute command
    ssh ${COMPUTE_USER}@${COMPUTE_NODE} "cd Stream && ./scripts/runGCP.sh"

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
