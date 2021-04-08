CC = icc
# CFLAGS = -O3 -xHost
CFLAGS = -O2

all: stream_single stream_multi

stream_single: src/stream.c
	$(CC) $(CFLAGS) src/stream.c -o bin/stream_single

# an example of a more complex build line for the Intel icc compiler
stream_multi: src/stream.c
	$(CC) $(CFLAGS) -qopenmp -DSTREAM_ARRAY_SIZE=100000000 -DNTIMES=20 src/stream.c -o bin/stream_multi

clean:
	rm -f bin/stream_single bin/stream_multi
