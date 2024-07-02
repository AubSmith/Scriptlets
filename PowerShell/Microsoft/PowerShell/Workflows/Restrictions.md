
# Workflow Restrictions

Workflow restrictions tend to fall into the following groups:
* Unsupported Windows PowerShell activities
* Scope of variables
* Objects are de-serialized
* Cmdlets that haven’t had workflow activities created
* Using custom Windows PowerShell drives—workflows may fail if they are present.


## Unsupported Windows PowerShell activities
A number of Windows PowerShell keywords and techniques aren’t supported in workflows. The following table provides a summary.

| Unsupported PowerShell techniques |                                   |                               |
|-----------------------------------|-----------------------------------|-------------------------------|
| Begin,Process,End                 | Break,Continue                    | Subexpressions                |
| Multiple assignment               | Modify loop variable              | Dynamic parameters            |
| Set properties                    | Dot sourcing                      | Advanced parameter validation |
| Positional parameters             | Switch statement                  | Trap statement                |
| Inline help                       | Setting drive qualified variables | Method invocation on objects  |
| Single #requires                  |                                   |                               |

 Instead of using the trap statement, use a try-catch block. 
 

### Switch Statement

    workflow testswitch {
    param (
    [string]$os
    )
    switch ($os) {
    “XP”        {“Time to upgrade”}
    “Windows7”  {“OK – but not the lastest”}
    “Windows 8” {“Latest and greatest”}
    }
    }

Will result in a sea of red error messages:

    At line:5 char:2
    +  switch ($os) {
    +  ~~~~~~~~~~~~~~   Case-insensitive switch statements are not supported in a Windows PowerShell workflow. Supply the -CaseSensitive flag, and ensure that case clauses are written appropriately. To write a case-insensitive case statement, first convert the input to either uppercase or lowercase, and update the case clauses to match.

        + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordEx
    ception

        + FullyQualifiedErrorId : SwitchCaseSensitive   
    
This won't work either:

    workflow testswitchi {
    param (
    [string]$os
    )
    switch -CaseSensitive ($os.ToUpper())  {
    “XP”        {“Time to upgrade”}
    “WINDOWS7”  {“OK – but not the lastest”}
    “WINDOWS 8” {“Latest and greatest”}
    }
    }

It will result in this:

    At line:5 char:25
    +  switch -CaseSensitive ($os.ToUpper())  {
    +                         ~~~~~~~~~~~~~   

    Method invocation is not supported in a Windows PowerShell Workflow. To use .NET Framework scripting, place your commands in an inline script:

    InlineScript {
    <commands> }.

        + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordEx
    ception

        + FullyQualifiedErrorId : MethodInvocationNotSupported

Make use of the InlineScript function:

    workflow testswitch {
    param (
    [string]$os
    )
    InlineScript {
    switch ($using:os) {
    “XP”        {“Time to upgrade”}
    “Windows7”  {“OK – but not the lastest”}
    “Windows 8” {“Latest and greatest”}
    }
    }
    }
    
Other restrictions such as the BEGIN, PROCESS, and END blocks that you can use in functions impact features that don’t really fit with the workflow concept. The other restriction that can have a big impact is that you can’t use inline comment-based Help. You have to use XML-based Help files. There are a number of ways to generate these files—one of the easiest is through InfoPath as described by James O’Neill. Not having parameter validation available could be a big problem if your workflows are heavily parameterized. This restriction doesn’t appear to have a workaround unless you create the validation code inside the workflow. You will have noticed the $using:computer I used last time and $using:os in the code demonstrating the switch statement. This syntax is part of the solution to overcoming the second restriction that is the scope of variables.

### Scope of variables
In workflows, the following restrictions on the use of variables occur:

* Variables defined in a higher scope are visible to lower workflow scopes but not Inlinescript scopes
* CANNOT have a variable in a lower scope with same name as a variable in higher scope
* if define or redefine variable can use it in that scope without problems
* There is no $global scope
* Use “$using” in InlineScript blocks to access variables defined in a higher scope
* Modification of a variable from a higher scope in an InlineScript requires the use of a temporary variable
* Use “$workflow” to modify variable defined in a higher scope
* CANNOT use subexpressions

That probably looks very confusing but this demonstration should help clear things up.

    workflow demo-scope {

    # This is a workflow top-level variable
    $a = 22

    “Initial value of A is: $a”

    # Access $a from Inlinescript (bringing a workflow variable to the Windows PowerShell session) using $using
    inlinescript {“PowerShell variable A is: $a”}

    inlinescript {“Workflow variable A is: $using:a”}

    ## changing a variable value
    $a = InlineScript {$b = $Using:a+5; $b}

    “Workflow variable A after InlineScript change is: $a”


    parallel {
    sequence {

    # Reading a top-level variable (no $workflow: needed)
    “Value of A inside parallel is: $a”

    # Updating a top-level variable with $workflow:<variable name>
    $workflow:a = 3

    }
    }

    “Updated value of A is: $a”

    }


demo-scope You should see something like this as your output:

    Initial value of A is: 22

    PowerShell variable A is:

    Workflow variable A is: 22

    Workflow variable A after InlineScript change is: 27

    Value of A inside parallel is: 27

    Updated value of A is: 3 

The workflow starts by defining a variable, $a = 22, and then displaying its value. In an InlineScript, if you try to access a variable defined in a higher scope, you get nothing as shown in the second line of the output. You have to use $using:a to access the variable. If you want to change that variable you have to use a second variable and return it to the original variable:

$a = InlineScript {$b = $Using:a+5; $b} The output shows the variable now has a value of 27. Moving into the parallel block you can read the variable without any scope issues. If you need to change the variable’s value you access via the $workflow scope. Bottom line with variables: keep it simple and be careful.

### Objects are de-serialized
The third restriction is that objects in workflows are de-serialized. This is similar to the position in Windows PowerShell remoting (which is not surprising as workflows use the same transport mechanism). As an aside object de-serialization is becoming much more prevalent in Windows PowerShell. It appears in:
* Windows PowerShell remoting
* Remote access via CIM sessions
* WSMAN cmdlets
* Workflows

Perhaps it’s time for the normal approach to become one of working in this manner. A de-serialized object gives you the properties of the object BUT not the methods. In other words, it is inert. Lots of Windows PowerShell code does something like these examples:

    $string = “abcde”
    $string.ToUpper()

    $os = Get-WmiObject -Class Win32_OperatingSystem
    $os.ConvertToDateTime($os.LastBootUpTime)   This approach isn’t going to work.
    workflow test2 {


    $string = “abcde”
    $string.ToUpper()

    
    $os = Get-WmiObject -Class Win32_OperatingSystem

    $os.ConvertToDateTime($os.LastBootUpTime)
    }

Will throw an error about method invocation not being supported. You can however do this:

    workflow test2 {
    inlinescript {
    $string = “abcde”
    $string.ToUpper()

    $os = Get-WmiObject -Class Win32_OperatingSystem

    $os.ConvertToDateTime($os.LastBootUpTime)

    }

    }
    
Don’t try and access variables from a higher scope that represent objects and then invoke methods—it won’t work. Bottom line on de-serialized objects—if you need the methods of an object, access it through an inlinescript. Remember that you can nest InlineScript blocks in parallel blocks!

### Cmdlets that haven’t had workflow activities created
The final restriction is around the cmdlets that haven’t been turned into workflows. Remember last time there was a problem with using the Format* cmdlets in workflows. The way around it is to use the InlineScript keyword like this:

    workflow foreachpitest {
    param([string[]]$computers)
    foreach –parallel ($computer in $computers){
        InlineScript {
        Get-WmiObject –Class Win32_OperatingSystem –ComputerName $using:computer |
        Format-List
        }
    }
    }

Other cmdlets that haven’t been turned into workflow activities are shown in the following table. You can use them in InlineScript blocks. 

| Unsupported cmdlet (group)                                                                                                                              | Reason                                                           |
|---------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| *Alias, *FormatData, *History, *Location, *PSDrive, *Transcript, *TypeDate, *Variable, Connect/Disconnect-Wsman                                         | Only change Windows PowerShell session so not needed in workflow |
| Show-Command, Show-ControlPanelItem, Get-Credential, Show-EventLog, Out-Gridview, Read-Host, Debug-Process                                              | Workflows don’t support interactive cmdlets                      |
| *BreakPoint, Get-PSCallStack, Set-PSDebug                                                                                                               | Workflows don’t support script debugging                         |
| *Transaction                                                                                                                                            | Workflows don’t support transactions                             |
| Format*                                                                                                                                                 | No formatting support                                            |
| *PSsession, *PSsessionoption                                                                                                                            | Remoting controlled by workflow                                  |
| Export-Console,Get-ControlPanelItem, Out-Default, Out-Null, Write-Host, Export-ModuleMember, Add-PSSnapin, Get-PSSnapin, Remove-PSSnapin, Trace-Command |                                                                  |

There are a number of cmdlets that are local execution only in workflows.
| Add-Member               | Compare-Object                | ConvertFrom-Csv         | ConvertFrom-Json                |
|--------------------------|-------------------------------|-------------------------|---------------------------------|
| ConvertFrom-StringData   | Convert-Path                  | ConvertTo-Csv           | ConvertTo-Html                  |
| ConvertTo-Json           | ConvertTo-Xml                 | ForEach-Object          | Get-Host                        |
| Get-Member               | Get-Random                    | Get-Unique              | Group-Object                    |
| Measure-Command          | Measure-Object                | New-PSSessionOption     | New-PSTransportOption           |
| New-TimeSpan             | Out-Default                   | Out-Host                | Out-Null                        |
| Out-String               | Select-Object                 | Sort-Object             | Update-List                     |
| Where-Object             | Write-Debug                   | Write-Error             | Write-Host                      |
| Write-Output             | Write-Progress                | Write-Verbose           |                                 |

If you want to use them remotely use an InlineScript.
