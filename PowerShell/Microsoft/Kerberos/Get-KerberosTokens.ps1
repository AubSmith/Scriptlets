# A function that returns all kerberos tokens on local machine
# Usage: Get-KerberosTokens


# Get all kerberos tokens on local machine
function Get-KerberosTokens {
    # Execute klist command to get kerberos tickets
    $output = & klist

    # Return the output
    return $output
}
