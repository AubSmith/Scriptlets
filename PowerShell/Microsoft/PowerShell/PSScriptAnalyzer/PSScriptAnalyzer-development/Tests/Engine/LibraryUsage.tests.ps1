$directory = Split-Path -Parent $MyInvocation.MyCommand.Path
$testRootDirectory = Split-Path -Parent $directory
Import-Module (Join-Path $testRootDirectory 'PSScriptAnalyzerTestHelper.psm1')
Import-Module PSScriptAnalyzer

# test is meant to verify functionality if chsarp apis are used. Hence not if psedition is CoreCLR
if ((Test-PSEditionCoreCLR))
{
	return
}

$directory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Overwrite Invoke-ScriptAnalyzer with a version that
# wraps the usage of ScriptAnalyzer as a .NET library 
function Invoke-ScriptAnalyzer {
	param (
        [CmdletBinding(DefaultParameterSetName="File")]

		[parameter(Mandatory = $true, Position = 0, ParameterSetName="File")]
		[Alias("PSPath")]
		[string] $Path,

		[parameter(Mandatory = $true, ParameterSetName="ScriptDefinition")]
		[string] $ScriptDefinition,

        [Parameter(Mandatory = $false)]
		[Alias("CustomizedRulePath")]
		[string[]] $CustomRulePath = $null,

		[Parameter(Mandatory = $false)]
		[switch] $RecurseCustomRulePath,

        [Parameter(Mandatory=$false)]
        [string[]] $ExcludeRule = $null,

        [Parameter(Mandatory = $false)]
        [string[]] $IncludeRule = $null, 

        [ValidateSet("Warning", "Error", "Information", IgnoreCase = $true)]
        [Parameter(Mandatory = $false)]
        [string[]] $Severity = $null,
        
        [Parameter(Mandatory = $false)]
		[switch] $Recurse,

        [Parameter(Mandatory = $false)]
		[switch] $IncludeDefaultRules,

        [Parameter(Mandatory = $false)]
        [switch] $SuppressedOnly
	)	

    if ($null -eq $CustomRulePath)
    {
        $IncludeDefaultRules = $true
    }
	# There is an inconsistency between this implementation and c# implementation of the cmdlet. 
	# The CustomRulePath parameter here is of "string[]" type whereas in the c# implementation it is of "string" type.
	# If we set the CustomRulePath parameter here to  "string[]", then the library usage test fails when run as an administrator. 
	# We want to note that the library usage test doesn't fail when run as a non-admin user.
	# The following is the error statement when the test runs as an administrator. 
	# Assert failed on "Initialize" with "7" argument(s): "Test failed due to terminating error: The module was expected to contain an assembly manifest. (Exception from HRESULT: 0x80131018)"

	$scriptAnalyzer = New-Object "Microsoft.Windows.PowerShell.ScriptAnalyzer.ScriptAnalyzer";
	$scriptAnalyzer.Initialize(
		$runspace, 
		$testOutputWriter, 
		$CustomRulePath, 
		$IncludeRule,
		$ExcludeRule,
		$Severity,
        $IncludeDefaultRules.IsPresent,
		$SuppressedOnly.IsPresent
	);

    if ($PSCmdlet.ParameterSetName -eq "File") {
    	return $scriptAnalyzer.AnalyzePath($Path, $Recurse.IsPresent);
    }
    else {
        return $scriptAnalyzer.AnalyzeScriptDefinition($ScriptDefinition);
    }
}

# Define an implementation of the IOutputWriter interface
Add-Type -Language CSharp @"
using System.Management.Automation;
using System.Management.Automation.Host;
using Microsoft.Windows.PowerShell.ScriptAnalyzer;

public class PesterTestOutputWriter : IOutputWriter 
{
	private PSHost psHost;

	public string MostRecentWarningMessage { get; private set; }

	public static PesterTestOutputWriter Create(PSHost psHost)
	{
		PesterTestOutputWriter testOutputWriter = new PesterTestOutputWriter();
		testOutputWriter.psHost = psHost;
		return testOutputWriter;
	}

	public void WriteError(ErrorRecord error)
	{
		// We don't write errors to avoid misleading
		// error messages in test output
	}

	public void WriteWarning(string message)
	{
		psHost.UI.WriteWarningLine(message);

		this.MostRecentWarningMessage = message;
	}

	public void WriteVerbose(string message)
	{
		// We don't write verbose output to avoid lots
		// of unnecessary messages in test output
	}

	public void WriteDebug(string message)
	{
		psHost.UI.WriteDebugLine(message);
	}

	public void ThrowTerminatingError(ErrorRecord record)
	{
		throw new RuntimeException(
			"Test failed due to terminating error: \r\n" + record.ToString(), 
			null, 
			record);
	}
}
"@ -ReferencedAssemblies "Microsoft.Windows.PowerShell.ScriptAnalyzer" -ErrorAction SilentlyContinue

if ($testOutputWriter -eq $null)
{
	$testOutputWriter = [PesterTestOutputWriter]::Create($Host);
}

# Create a fresh runspace to pass into the ScriptAnalyzer class
$initialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault2();
$runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace([System.Management.Automation.Host.PSHost]$Host, [System.Management.Automation.Runspaces.InitialSessionState]$initialSessionState);
$runspace.Open();

# Let other test scripts know we are testing library usage now
$testingLibraryUsage = $true

# Force Get-Help not to prompt for interactive input to download help using Update-Help
# By adding this registry key we force to turn off Get-Help interactivity logic during ScriptRule parsing
$null,"Wow6432Node" | ForEach-Object {
	try
	{
		Set-ItemProperty -Name "DisablePromptToUpdateHelp" -Path "HKLM:\SOFTWARE\$($_)\Microsoft\PowerShell" -Value 1 -Force
	} 
	catch
	{
		# Ignore for cases when tests are running in non-elevated more or registry key does not exist or not accessible
	}
}

# Invoke existing test files that use Invoke-ScriptAnalyzer
. $directory\InvokeScriptAnalyzer.tests.ps1
. $directory\RuleSuppression.tests.ps1
. $directory\CustomizedRule.tests.ps1

# We're done testing library usage
$testingLibraryUsage = $false

# Clean up the test runspace
$runspace.Dispose();

# Re-import the PSScriptAnalyzer module to overwrite the library test cmdlet
Import-Module PSScriptAnalyzer
