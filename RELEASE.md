## Breaking Changes
**WARNING: This release contains breaking changes**
* The minmum supported PowerShell Versions have been raised to the following:
  * Windows PowerShell: 5.1
  * PowerShell Core: 6.0.0-rc**

## Features
* Feature - Add ability to select SSL Protocol (#159)
* Feature - Single PSM1 file to speed up load times

## Fixes
* Fixed #134 - Issue with double quotes in some functions
* Fixed #135 - Some private functions are being exported
* Fixed #137 - Help examples for Get-vRAResource are incorrect
* Fixed #148 - Request-vRAResourceAction Example Correction
* Fixed #149 - Support Reservation Type change from 'vSphere' to 'vSphere (vCenter)' in vRA 7.3
* Fixed #151 - Get-vRAReservationPolicy
* Fixed #153 - New-vRAReserveration Error
* Fixed #130 - Unable to connect after removing SSLv3/TLSv1 ciphers from vRA Appliance