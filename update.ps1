import-module au

$releases = 'https://api.github.com/repos/GotoFinal/ShareX-HDR/releases'

function global:au_GetLatest {
    # Optional: mit $env:GITHUB_TOKEN vermeidet man das Rate-Limit der GitHub-API
    $headers = @{}
    if ($env:GITHUB_TOKEN) { $headers['Authorization'] = "Bearer $env:GITHUB_TOKEN" }

    $download_page = Invoke-RestMethod -Uri $releases -Headers $headers -UseBasicParsing

    # Neuestes echtes Release (keine Drafts/Pre-Releases)
    $latestRelease = $download_page |
        Where-Object { -not $_.draft -and -not $_.prerelease } |
        Select-Object -First 1

    # Tag-Format: v21.0.6-hdr
    $version = $latestRelease.tag_name -replace '^v', '' -replace '-hdr$', ''

    # Seit 21.x heißt das Asset ShareX-<version>-setup-x64.exe (vorher: *-setup.exe)
    $asset = $latestRelease.assets |
        Where-Object { $_.name -like '*-setup-x64.exe' } |
        Select-Object -First 1

    if (-not $asset) {
        throw "Kein *-setup-x64.exe Asset im neuesten Release gefunden"
    }

    Write-Host "Found version: $version"
    Write-Host "Download URL: $($asset.browser_download_url)"

    @{
        Version      = $version
        URL64        = $asset.browser_download_url
        ReleaseNotes = $latestRelease.html_url
    }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^\`$url64\s*=\s*)('.*')"      = "`${1}'$($Latest.URL64)'"
            "(^\`$checksum64\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum64)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(<version>).*?(</version>)"           = "`${1}$($Latest.Version)`${2}"
            "(<releaseNotes>).*?(</releaseNotes>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
        }
    }
}

function global:au_BeforeUpdate {
    Write-Host "Calculating checksum for: $($Latest.URL64)"
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
    $Latest.ChecksumType64 = 'sha256'
    Write-Host "Calculated checksum: $($Latest.Checksum64)"
}

update -ChecksumFor none
