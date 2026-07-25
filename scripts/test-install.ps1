[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$taskTestRoot = Join-Path ([System.IO.Path]::GetTempPath()) "titus-ai-install-test-$([guid]::NewGuid())"
$testCodexHome = Join-Path $taskTestRoot 'codex home'
$testAgentsHome = Join-Path $taskTestRoot 'agents home'
$previousCodexHome = [Environment]::GetEnvironmentVariable('CODEX_HOME', 'Process')
$previousAgentsHome = [Environment]::GetEnvironmentVariable('AGENTS_HOME', 'Process')

function Assert-Condition {
    param(
        [Parameter(Mandatory)]
        [bool] $Condition,

        [Parameter(Mandatory)]
        [string] $Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Assert-Link {
    param(
        [Parameter(Mandatory)]
        [string] $Target,

        [Parameter(Mandatory)]
        [string] $Source
    )

    $item = Get-Item -LiteralPath $Target -Force
    Assert-Condition ($item.LinkType -eq 'SymbolicLink') "Expected symbolic link: $Target"

    $linkTarget = [string] $item.Target
    if (-not [System.IO.Path]::IsPathRooted($linkTarget)) {
        $linkTarget = Join-Path (Split-Path -Parent $item.FullName) $linkTarget
    }

    $actual = [System.IO.Path]::GetFullPath($linkTarget)
    $expected = [System.IO.Path]::GetFullPath($Source)
    Assert-Condition ($actual -eq $expected) "Unexpected link target: $Target"
}

try {
    New-Item -ItemType Directory -Path $testCodexHome -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $testCodexHome 'AGENTS.md') -Value 'original global instructions'

    $env:CODEX_HOME = $testCodexHome
    $env:AGENTS_HOME = $testAgentsHome
    & (Join-Path $repoRoot 'scripts/install.ps1') | Out-Null

    Assert-Link (Join-Path $testCodexHome 'AGENTS.md') (Join-Path $repoRoot 'codex-home/AGENTS.md')
    Assert-Link (Join-Path $testCodexHome 'config.toml') (Join-Path $repoRoot 'codex-home/config.toml')
    Assert-Link (Join-Path $testCodexHome 'rules') (Join-Path $repoRoot 'codex-home/rules')
    Assert-Link (Join-Path $testCodexHome 'ollama.config.toml') (Join-Path $repoRoot 'codex-home/ollama.config.toml')
    Assert-Link (Join-Path $testCodexHome 'llamacpp.config.toml') (Join-Path $repoRoot 'codex-home/llamacpp.config.toml')

    Get-ChildItem -LiteralPath (Join-Path $repoRoot '.agents/skills') -Directory |
        ForEach-Object {
            Assert-Link (Join-Path (Join-Path $testAgentsHome 'skills') $_.Name) $_.FullName
        }

    $instructionBackups = @(
        Get-ChildItem -LiteralPath (Join-Path $testCodexHome 'backups') -Filter 'AGENTS.md' -File -Recurse
    )
    Assert-Condition ($instructionBackups.Count -eq 1) "Expected one AGENTS.md backup, found $($instructionBackups.Count)"
    $backupContent = Get-Content -LiteralPath $instructionBackups[0].FullName -Raw
    Assert-Condition ($backupContent.Trim() -eq 'original global instructions') 'AGENTS.md backup content changed'

    & (Join-Path $repoRoot 'scripts/install.ps1') | Out-Null
    Assert-Link (Join-Path $testCodexHome 'AGENTS.md') (Join-Path $repoRoot 'codex-home/AGENTS.md')
    $instructionBackups = @(
        Get-ChildItem -LiteralPath (Join-Path $testCodexHome 'backups') -Filter 'AGENTS.md' -File -Recurse
    )
    Assert-Condition ($instructionBackups.Count -eq 1) 'Idempotent install created another AGENTS.md backup'

    $dryRunCodexHome = Join-Path $taskTestRoot 'dry run codex'
    $dryRunAgentsHome = Join-Path $taskTestRoot 'dry run agents'
    $env:CODEX_HOME = $dryRunCodexHome
    $env:AGENTS_HOME = $dryRunAgentsHome
    & (Join-Path $repoRoot 'scripts/install.ps1') -DryRun | Out-Null
    Assert-Condition (-not (Test-Path -LiteralPath $dryRunCodexHome)) 'Dry-run created CODEX_HOME'
    Assert-Condition (-not (Test-Path -LiteralPath $dryRunAgentsHome)) 'Dry-run created AGENTS_HOME'

    Write-Output 'installer integration test passed'
}
finally {
    if ($null -eq $previousCodexHome) {
        Remove-Item Env:CODEX_HOME -ErrorAction SilentlyContinue
    }
    else {
        $env:CODEX_HOME = $previousCodexHome
    }

    if ($null -eq $previousAgentsHome) {
        Remove-Item Env:AGENTS_HOME -ErrorAction SilentlyContinue
    }
    else {
        $env:AGENTS_HOME = $previousAgentsHome
    }

    $tempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    $normalizedTestRoot = [System.IO.Path]::GetFullPath($taskTestRoot)
    if (
        $normalizedTestRoot.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase) -and
        (Split-Path -Leaf $normalizedTestRoot).StartsWith('titus-ai-install-test-')
    ) {
        Remove-Item -LiteralPath $normalizedTestRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
