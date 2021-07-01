# Tape Archiver (tar) - no compression

tar -cvf file.tar /home /etc # Create
tar -tvf file.tar            # Verify
tar -tvf file.tar | less
tar -xvf file.tar -C ~/      # Extract
tar -xvf file.tar

# Add compression
tar -cvf file.tar /home /etc # Zzip
tar -cvf file.tar /home /etc # Bzip2
tar -cvf file.tar /home /etc # XZ

file file.tar