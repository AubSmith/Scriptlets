def compare_files(new_file, old_file, output_path):
    with open(new_file, 'r') as file1, open(old_file, 'r') as file2:
        file1_lines = set(file1)
        with open(output_path, 'w') as output_file:
            for line in file2:
                if line not in file1_lines:
                    output_file.write(line)

if __name__ == "__main__":
    new_file = 'E:\\Code\\Test\\bigfile.txt'
    old_file = 'E:\\Code\\Test\\bigfileold.txt'
    output_path = 'E:\\Code\\Test\\outfile.txt'
    compare_files(new_file, old_file, output_path)
    