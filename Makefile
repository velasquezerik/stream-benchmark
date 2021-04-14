CC = icc
MPICC = mpicc
# CFLAGS = -O3 -xHost
CFLAGS = -O3

all: stream_single stream_multi stream_mpi

stream_single: src/stream.c
	$(CC) $(CFLAGS) src/stream.c -o bin/stream_single

# openmp 
stream_multi: src/stream.c
	$(CC) $(CFLAGS) -qopenmp -DSTREAM_ARRAY_SIZE=100000000 -DNTIMES=20 src/stream.c -o bin/stream_multi

# mpi 
stream_mpi: src/stream_mpi.c
	$(MPICC) $(CFLAGS) -ffreestanding -openmp  -DSTREAM_ARRAY_SIZE=100000000 -DNTIMES=20 -DVERBOSE  src/stream_mpi.c -o bin/stream_mpi

clean:
	rm -f bin/stream_single bin/stream_multi bin/stream_mpi
