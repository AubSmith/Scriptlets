<#
Most people will want to use Exit to terminate a running scripts. However, if your script is merely declaring functions to later be used in a shell, then you will want to use Return in the definitions of said functions.

Exit vs Return vs Break vs Throw vs Write-Error
Exit:
- This will "exit" the currently running context. If you call this command from a script it will exit the script. If you call this command from the shell it will exit the shell.
- If a function calls the Exit command it will exit what ever context it is running in. So if that function is only called from within a running script it will exit that script. However, if your script merely declares the function so that it can be used from the current shell and you run that function from the shell, it will exit the shell because the shell is the context in which the function contianing the Exit command is running.
-Exit can take a return code as a parameter (defaults to 0 = success)

Return:
- This will return to the previous call point. If you call this command from a script (outside any functions) it will return to the shell. If you call this command from the shell it will return to the shell (which is the previous call point for a single command ran from the shell). If you call this command from a function it will return to where ever the function was called from.
- Execution of any commands after the call point that it is returned to will continue from that point. If a script is called from the shell and it contains the Return command outside any functions then when it returns to the shell there are no more commands to run thus making a Return used in this way essentially the same as Exit.

Break:
- This will break out of loops and switch cases. If you call this command while not in a loop or switch case it will break out of the script. If you call Break inside a loop that is nested inside a loop it will only break out of the loop it was called in.
- There is also an interesting feature of Break where you can prefix a loop with a label and then you can break out of that labeled loop even if the Break command is called within several nested groups within that labeled loop.

Throw:
- For terminating errors

Write-Error:
- Use for non-terminating errors

#>

While ($true) {
    # Code here will run

    :myLabel While ($true) {
        # Code here will run

        While ($true) {
            # Code here will run

            While ($true) {
                # Code here will run
                Break myLabel
                # Code here will not run
            }

            # Code here will not run
        }

        # Code here will not run
    }

    # Code here will run
}



"Exit 5" > test1.ps1
powershell.exe .\test1.ps1 $lastexitcode > lastexit1.txt

"[Environment]::Exit(5)" > test2.ps1 
powershell.exe .\test2.ps1 $lastexitcode > lastexit2.txt
