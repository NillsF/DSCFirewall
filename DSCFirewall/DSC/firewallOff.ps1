Configuration FirewallScriptResource            
{            
    param ($MachineName)
	Import-DscResource -ModuleName PSDesiredStateConfiguration            
    Node $MachineName            
    {            
        Script DisableFirewall            
        {            
            # Must return a hashtable with at least one key            
            # named 'Result' of type String            
            GetScript = {            
                Return @{            
                    Result = [string]$(netsh advfirewall show allprofiles)            
                }            
            }            
            
            # Must return a boolean: $true or $false            
            TestScript = {            
                If ((netsh advfirewall show allprofiles) -like "State*on*") {            
                    Write-Verbose "One or more firewall profiles are on"            
                    Return $false            
                } Else {            
                    Write-Verbose "All firewall profiles are off"            
                    Return $true            
                }            
            }            
            
            # Returns nothing            
            SetScript = {            
                Write-Verbose "Setting all firewall profiles to off"            
                netsh advfirewall set allprofiles state off            
            }            
        }            
    }            
}            