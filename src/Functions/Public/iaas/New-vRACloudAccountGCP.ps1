function New-vRACloudAccountGCP {
<#
    .SYNOPSIS
    Create a vRA Cloud Account for GCP

    .DESCRIPTION
    Create a vRA Cloud Account for GCP

    .PARAMETER Name
    The name of the Cloud Account for GCP

    .PARAMETER Description
    A description of the Cloud Account for GCP

    .PARAMETER ProjectId
    GCP Project Id

    .PARAMETER PrivateKeyId
    GCP Private Key Id

    .PARAMETER PrivateKey
    GCP Private Key

    .PARAMETER ClientEmail
    GCP Client Email

    .PARAMETER RegionIds
    GCP RegionIds to enable

    .PARAMETER CreateDefaultZones
    Enable CreateDefaultZones

    .PARAMETER JSON
    A JSON string with the body payload

    .INPUTS
    System.String
    System.Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $privateKey = @"
-----BEGIN PRIVATE KEY-----
\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDbw8OMwHfait
cx\nKRqp7k2IppvEyuKTPPCNygZvb9HZ6LWV84GWt+RLJ+k5ZmhJ9254qNcV5RUn
sKcF\nhLPD1IPPOGlLTUZ492lH+3k6Uh3RxoGo2fdOuc1SVa/GXREXB0KXj5lYYw
Vjvsu/\n5QYUWwJbUSVd52Q1O4d0toezA/zw54NM5Ijv6P1J2bJ7szODCbh7obb5
J7vtsjfi\n6cik3frRaf13yX/GGghPXOockJ3s7MM4rgfJHSHuQVWOkPaJPiGFd2
d4XMpizAU2\n2hMGbFiAmONgl2HPaw3mqEP3owv1F7ZQ0TWUB1iq3T8xddkacsmB
hyzL4KgPKocR\ng6fh3sjJAgMBAAECggEAFYn+FkM96/w8I5wW+i06SaikrzjAVL
R+EjOJBm6D95LM\ni1YaryI2XJxciizsj0VSPT61F/cEKAfzEsIjGVAwnAR4I3J/
M/dxyOWPh+UI+ai2\nSA2W5M8mncl6qRsxg9uJDhA7tBM+cbx/PT9N5XxXAoq1Oh
sl8eaz+78xFR1Qsu6b\nSwAmL6I2iRR/qijsGYPPyKruEZU3AZg+OETgoHe97F/i
T/dXyIh2YAtaC+g7lpK9\nOA8XavfYHF7tmQ8MnIT0Ez9u2WC5VHJas8+fnQdxkj
o6jwWTgp36hkGcRt+HGLqW\nWDEdzw7TAMTy6KZLZNq39lIwFv24hoyFLECL9o9N
JQKBgQD/gFa3BS/utfmC+oBu\nPIGk/HCTPiQ9bj3leDC8vzmAj3Sohz54xNjvrX
J7XhYGJB3kI+uzjgY0qh45Z/18\ng/bxCEbCW6hgYEkGJu9Pf8hO1E0sMVo3wEFs
ZKymR51+8aqOb27bS/IN5GmLuMby\nZDGZJHELLOjk7PcHJDMo2wsWpQKBgQDcMZ
G/jWLQQJjOGii/I+u7cAB2zOCeBV4w\nlTHEREzOWPZj9gblvBXFlXtaPPpopLdT
RF+rGlP96Dgx0o4wZTT94oL41eYntDBZ\nwY8FJDdPC08AjtYT15ramdc/K+3q+1
QVfG63vC+iSyRP9YBrGFV2bZ8sntQmpC1a\naZMBhz/0VQKBgDlwE45vZxgl5qKw
R+EATzDU40XmqWT5/IYyn9o+ruGc3l/oj328\n2vv+pQbg3tigk+uuu5UQ74o1WD
gVjaHJVOFYt/eHfXG1E5WDeTcHGsHavkKaEasI\n2GxSsZFr9hcMowgEOwqnpxHC
cIvNjUP+jDveL/i8kxKrxtjfJXUg0PxVAoGASjjf\nQy1acI5Fs7t3nq5yCJWC06
Oa10lB7aggRTAohLnSG/HTc18KC7cOhGVnlxxmu0eh\n4+AVDdJYFts9mKyUxzuy
IEShtyJy5d5r4jTJ+/f44lxDZx7XEPaoap/ZK8saFcAC\n5iYl/FPN4rIDXpYuQK
RE8lp7cqcGrqJFrk8zzJ0CgYEAoWa1k6fkuO4XgopiDOgj\n7/sZr6k3fPp9dJYm
roPjeLPtR1AFJJ4NBHlX+r06nZeovTpm3dKPmg01FXV5mUYq\nW1me90GFekjz6W
N/2DOnL7ChnG8ZJp45SKq26g6D+OU5rg83KuNMJQ0w3dXuR2ch\nnLxRJH0dt7oA
44aMzP39X/s=\n
-----END PRIVATE KEY-----
"@

    New-vRACloudAccountGCP -Name "GCP Test" -ProjectId "third-folio-255713" -PrivateKeyId "6226de83c0c6c267f4c80fc9c5ac7dda0293ed9e" -PrivateKey $privateKey -clientEmail "321743978432-compute@developer.gserviceaccount.com" -RegionIds "europe-west1","us-west1"

    .EXAMPLE
    $JSON = @"

        {
            "name": "GCP Test",
            "description": "GCP Test",
            "projectId": "third-folio-255713",
            "privateKeyId": "6226de83c0c6c267f4c80fc9c5ac7dda0293ed9e",
            "privateKey": "-----BEGIN PRIVATE KEY-----\nMIICXgIHAASBgSDHikastc8+I81zCg/qWW8dMr8mqvXQ3qbPAmu0RjxoZVI47tvs\nkYlFAXOf0sPrhO2nUuooJngnHV0639iTHELLOvckNaW2RTHEREdQ5Rq5u+uV3pMk\n7w7Vs4n3urQ4jnqt7rTXbC1DNa/PFeAZatbf7ffBBy0IGO0zc128IshYcwIDAQAB\nAoGBALTNl2JxTvq4SDW/3VH0fZkQXWH1MM10oeMbB2qO5beWb11FGaOO77nGKfWc\nbYgfp5Ogrql2yhBvLAXnxH8bcqqwORtFhlyV68U1y4R+8WxDNh0aevxH8hRS/1X5\n963DJm1JlU0E+vStiktN0tC3ebH5hE+1OxbIHSZ+WOWLYX7JAkEA5uigRgKp8ScG\nauUijvdOLZIhHWq9y5Wz+nOHUuDw8P7wOTKU34QJAoWEe771p9Pf/GTA/kr0BQnP\nQvWUDxGzJwJBAN05C6krwPeryFKrKtjOGJIbiIoY72wRnoNcdEEs3HDRhf48YWFo\nriRbZylzzzNFy/gmzT6XJQTfktGqq+FZD9UCQGIJaGrxHJgfmpDuAhMzGsUsYtTr\niRox0D1Iqa7dhE693t5aBG010OF6MLqdZA1CXrn5SRtuVVaCSLZEL/2J5UcCQQDA\nd3MXucNnN4NPuS/L9HMYJWD7lPoosaORcgyK77bSSNgk+u9WSjbH1uYIAIPSffUZ\nbti+jc2dUg5wb+aeZlgJAkEAurrpmpqj5vg087ZngKfFGR5rozDiTsK5DceTV97K\na1Y+Nzl+XWTxDBWk4YPh2ZlKv402hZEfWBYxUDn5ZkH/bw==\n-----END PRIVATE KEY-----\n",
            "clientEmail": "321743978432-compute@developer.gserviceaccount.com",
            "regionIds": [ "europe-west1","us-west1" ],
            "createDefaultZones": false
        }
"@

    $JSON | New-vRACloudAccountGCP


#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$ProjectId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$PrivateKeyId,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$PrivateKey,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$ClientEmail,

        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String[]]$RegionIds,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [Switch]$CreateDefaultZones,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON

    )

    begin {
        if ($PSBoundParameters.ContainsKey("CreateDefaultZones")) {

            $CreateDefaultZonesStatus = 'true'
        }
        else {

            $CreateDefaultZonesStatus = 'false'
        }
    }

    process {

            if ($PSBoundParameters.ContainsKey("JSON")) {

                $Data = ($JSON | ConvertFrom-Json)

                $Body = $JSON
                $Name = $Data.name
            }
            else {

                # Format RegionIds with surrounding quotes and join into single string
                $RegionIdsAddQuotes = $RegionIDs | ForEach-Object {"`"$_`""}
                $RegionIdsFormatForBodyText = $RegionIdsAddQuotes -join ","

                $Body = @"
                    {
                        "name": "$($Name)",
                        "description": "$($Description)",
                        "projectId": "$($ProjectId)",
                        "privateKeyId": "$($PrivateKeyId)",
                        "privateKey": "$($PrivateKey)",
                        "clientEmail": "$($ClientEmail)",
                        "regionIds": [ $($RegionIdsFormatForBodyText) ],
                        "createDefaultZones": $($CreateDefaultZonesStatus)
                    }
"@
            }

        # --- Create new GCP Cloud Account
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/iaas/api/cloud-accounts-gcp"
                $CloudAccount = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                [PSCustomObject] @{

                    Name = $CloudAccount.name
                    Description = $CloudAccount.description
                    Id = $CloudAccount.id
                    CloudAccountType = 'gcp'
                    ProjectId = $CloudAccount.projectId
                    PrivateKeyId = $CloudAccount.privateKeyId
                    ClientEmail = $CloudAccount.clientEmail
                    EnabledRegionIds = $CloudAccount.enabledRegionIds
                    CustomProperties = $CloudAccount.customProperties
                    OrganizationId = $CloudAccount.organizationId
                    Links = $CloudAccount._links
                }
            }
        }
        catch [Exception] {

            throw
        }
    }
    end {

    }
}