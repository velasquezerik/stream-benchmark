CC = icc
# CFLAGS = -O3 -xHost
CFLAGS = -O2

all: stream_single stream_multi

stream_single: stream.c
	$(CC) $(CFLAGS) stream.c -o stream_single

# an example of a more complex build line for the Intel icc compiler
stream_multi: stream.c
	$(CC) $(CFLAGS) -qopenmp -DSTREAM_ARRAY_SIZE=100000000 -DNTIMES=20 stream.c -o stream_multi

clean:
	rm -f stream_c.exe stream_single stream_multi stream.omp.AVX2.80M.20x.icc *.o
