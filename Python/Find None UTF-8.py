def find_none_utf8(source_file, output_path):
    with open(source_file, 'rb') as f:
        with open(output_path, 'wb') as output_file:
            for line in f:
                try:
                    line.decode('utf-8')
                except UnicodeDecodeError:
                    output_file.write(line)

if __name__ == "__main__":
    source_file = 'E:\\Code\\Test\\bigfile.txt'
    output_path = 'E:\\Code\\Test\\outfile.txt'
    find_none_utf8(source_file, output_path)