def read_file_as_csv(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    return [line.replace(' ', ',').strip().split(',') for line in lines]

def get_columns(data, col_indices):
    return [[row[i] for i in col_indices if len(row) > i] for row in data]

def check_values_in_file(values, file_path):
    with open(file_path, 'r') as file:
        file_content = file.read()
    return [value for value in values if value in file_content]

def log_values(values, log_file_path):
    with open(log_file_path, 'w') as log_file:
        for value in values:
            log_file.write(f"{value}\n")

# Paths to your files
file1_path = 'file1.txt'
file2_path = 'file2.txt'
log_file_path = 'log.txt'

# Read and process the first file
file1_data = read_file_as_csv(file1_path)
file1_columns = get_columns(file1_data, [1, 4])  # Get 2nd and 5th columns (index 1 and 4)

# Read and process the second file
file2_data = read_file_as_csv(file2_path)
file2_columns = get_columns(file2_data, [1, 4])  # Get 2nd and 5th columns (index 1 and 4)

# Flatten the lists for comparison
file1_values = [item for sublist in file1_columns for item in sublist]
file2_values = [item for sublist in file2_columns for item in sublist]

# Check if values in file2 are not in file1
unique_values = [value for value in file2_values if value not in file1_values]

# Log the unique values
log_values(unique_values, log_file_path)

print("Values from the second and fifth columns of the second file that do not exist in the first file have been logged.")