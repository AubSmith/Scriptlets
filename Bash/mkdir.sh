$mydir

# Does directory exist
if [ -d "$mydir" ]; then 
  if [ -L "$mydir" ]; then
    # It is a symlink!
    # Symbolic link specific commands go here.
    rm "$mydir"
  else
    # It's a directory!
    # Directory command goes here.
    rmdir "$mydir"
  fi
fi

# Make directory
mkdir -p "$mydir"