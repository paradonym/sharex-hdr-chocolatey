# ShareX-HDR Chocolatey Package

This is an automatically updating Chocolatey package for ShareX-HDR.

## Structure

- `sharex-hdr.nuspec` - Package metadata and description
- `tools/chocolateyInstall.ps1` - Installation script
- `tools/chocolateyUninstall.ps1` - Uninstallation script
- `update.ps1` - Automatic update script using Chocolatey-AU

## Prerequisites

1. Install Chocolatey-AU module:
   ```powershell
   Install-Module au -Scope CurrentUser
   ```

2. Set up your Chocolatey API key (if pushing to community repository):
   ```powershell
   choco apikey --key YOUR_API_KEY --source https://push.chocolatey.org/
   ```

## Directory Structure

Create the following directory structure:

```
sharex-hdr/
├── sharex-hdr.nuspec
├── update.ps1
└── tools/
    ├── chocolateyInstall.ps1
    └── chocolateyUninstall.ps1
```

## Manual Package Creation

To manually create the package:

```powershell
choco pack
```

This will create a `.nupkg` file.

## Testing Locally

To test the package locally before publishing:

```powershell
choco install sharex-hdr --source .
```

## Automatic Updates

To run the automatic updater:

```powershell
.\update.ps1
```

This script will:
1. Check GitHub releases for the latest version
2. Compare with the current package version
3. If newer, download the installer to calculate checksum
4. Update the nuspec and install script with new version and URLs
5. Create a new package file

## Forcing an Update

If you need to force an update (e.g., to recalculate checksums):

```powershell
$au_Force = $true; .\update.ps1
```

## Automation with GitHub Actions

You can automate this process using GitHub Actions. Create a workflow file that:
1. Runs on a schedule (e.g., daily)
2. Executes the update.ps1 script
3. Pushes updated packages to Chocolatey repository

Example workflow file (`.github/workflows/update.yml`):

```yaml
name: Update Chocolatey Package

on:
  schedule:
    - cron: '0 0 * * *'  # Run daily at midnight
  workflow_dispatch:  # Allow manual trigger

jobs:
  update:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Chocolatey-AU
        run: Install-Module au -Scope CurrentUser -Force
        
      - name: Run update script
        run: .\update.ps1
        env:
          api_key: ${{ secrets.CHOCOLATEY_API_KEY }}
```

## Important Notes

- Before first use, you need to update the CHECKSUM_PLACEHOLDER in chocolateyInstall.ps1
  Run: `update.ps1` once to auto-calculate the checksum
- Update the `owners` field in the nuspec file with your Chocolatey username
- The package requires admin rights to install (uses the 'admin' tag)
- This package downloads from GitHub releases, so internet connection is required during installation

## Links

- ShareX-HDR GitHub: https://github.com/GotoFinal/ShareX-HDR
- Chocolatey-AU documentation: https://github.com/majkinetor/au
- Chocolatey package guidelines: https://docs.chocolatey.org/en-us/create/create-packages