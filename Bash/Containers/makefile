hello_world:
		echo "Hello world"

say_hello:
        @echo "Hello World"

generate:
        @echo "Creating empty text files..."
        touch file-{1..10}.txt

clean:
        @echo "Cleaning up..."
        rm *.txt

# Copy below, excl comt, to top of file
#  .DEFAULT_GOAL := generate

# Remove .DEFAULT_GOAL := generate
# Copy below, excl comt, to top of file
# all: say_hello generate

# Copy below, excl comt, to top of file
# .PHONY: all say_hello generate clean

# It is a good practice not to call clean in all or put it as the first target. clean should be called manually
# make clean