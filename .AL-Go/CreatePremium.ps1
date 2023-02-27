Install-Module BcContainerHelper -force

$credential = New-Object pscredential 'Fellow', (ConvertTo-SecureString -String 'P@ssw0rd' -AsPlainText -Force)
New-BcContainerBcUser -assignPremiumPlan -containerName "fellowtemplate" -Credential $credential