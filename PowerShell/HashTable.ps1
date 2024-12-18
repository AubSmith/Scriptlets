# Read the contents of the two text files
$file1 = Get-Content -Path "path\to\file1.txt"
$file2 = Get-Content -Path "path\to\file2.txt"

# Create hashtables for each file
$hashTable1 = @{}
$hashTable2 = @{}

# Populate the hashtables with line numbers as keys and line contents as values
for ($i = 0; $i -lt $file1.Length; $i++) {
    $hashTable1[$i] = $file1[$i]
}

for ($i = 0; $i -lt $file2.Length; $i++) {
    $hashTable2[$i] = $file2[$i]
}

# Compare the hashtables to find differences
$maxLines = [math]::Max($hashTable1.Count, $hashTable2.Count)

for ($i = 0; $i -lt $maxLines; $i++) {
    $line1 = $hashTable1[$i]
    $line2 = $hashTable2[$i]

    if ($line1 -ne $line2) {
        Write-Output "Difference at line $i"
        Write-Output "File1: $line1"
        Write-Output "File2: $line2"
        
    }
}