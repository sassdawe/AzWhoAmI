# AzWhoAmI

WhoAmI for Azure Cloud Shell

## Why?

I had the need to know the current user in Azure Cloud Shell without hardcoding the UPN for my scripts.

Sadly the Cloud Shell had very little information about the user, so this module was born brining us the `Get-AzWhoAmI` cmdlet and its alias `whoami`.
