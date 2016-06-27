# RULE 1: Any containers created by this Makefile should be automatically cleaned up

PWD := $(shell pwd)

clean:
	rm bin/drip-exported
	docker rmi buildertools/drip:dev

# Using `docker cp` to copy a file out of an image requires three steps:
#  1. Create a container from the target image
#  2. Run `docker cp` to copy the file 
#  3. Remove the temporary container
# The biggest problem with this handshake is the need to maintain references to the
# target container. This is compounded in Makefiles. So, forget about that nonsense.
#   Instead I'm using a volume and a copy command from a self-destructing container.
# This has the nice property of being able to run in a single step and potentially 
# performing more complex copy operations.
build:
	docker build -t buildertools/drip:dev -f build.df .
	docker run --rm -v $(PWD)/bin:/xfer buildertools/drip:dev /bin/sh -c 'cp /go/bin/drip* /xfer/'

release: build
	docker build -t buildertools/drip:latest -f release.df .
	docker tag buildertools/drip:latest buildertools/drip:poc

