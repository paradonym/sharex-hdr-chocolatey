$ErrorActionPreference = 'Stop'

$packageName = 'sharex-hdr'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/GotoFinal/ShareX-HDR/releases/download/v21.0.6-hdr/ShareX-21.0.6-setup-x64.exe'
$checksum64 = 'f8dfe12fd38ff64a1cad5ba2ff70db3899cd8a25e13156d3bf596a351089ee1b'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'EXE'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
  softwareName   = 'ShareX*'
}

Install-ChocolateyPackage @packageArgs
