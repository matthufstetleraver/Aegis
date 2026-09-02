# bind-to-extraction.ps1
# Helper that reads aegis/ and returns JSON with canonical sources that forward skills should consult.
#
# Usage:
#   bind-to-extraction.ps1 [-Json] [-For <command>]
#
# -For requirements   architecture, domain, inventory
# -For plan           architecture, c4-context, state-machines, dependencies, code-analysis
# -For to-do          architecture, code-analysis
# -For audit          architecture, domain
# -For coding         architecture, domain, code-analysis
# no -For             all canonical files in aegis/
#
# Exit codes: 0 ok, 1 aegis/ missing, 2 invalid usage.

[CmdletBinding()]
param(
  [switch]$Json,
  [string]$For = ''
)

$ErrorActionPreference = 'Stop'

$scriptDir   = Split-Path -Parent $PSCommandPath
$projectRoot = (Resolve-Path (Join-Path $scriptDir '..\..')).Path
$aegisDir    = Join-Path $projectRoot 'aegis'

if (-not (Test-Path -LiteralPath $aegisDir -PathType Container)) {
  Write-Error "$aegisDir does not exist. run the extraction pipeline first."
  exit 1
}

$wanted = switch ($For) {
  'requirements' { @('architecture/architecture.md','reports/domain.md','reports/inventory.md') }
  'plan'         { @('architecture/architecture.md','architecture/c4-context.md','reports/state-machines.md','reports/dependencies.md','reports/code-analysis.md') }
  'to-do'        { @('architecture/architecture.md','reports/code-analysis.md') }
  'todo'         { @('architecture/architecture.md','reports/code-analysis.md') }
  'audit'        { @('architecture/architecture.md','reports/domain.md') }
  'coding'       { @('architecture/architecture.md','reports/domain.md','reports/code-analysis.md') }
  default        { @('architecture/architecture.md','architecture/c4-context.md','reports/code-analysis.md','reports/confidence-report.md','reports/dependencies.md','reports/domain.md','reports/inventory.md','reports/questions.md','reports/state-machines.md') }
}

$present = New-Object System.Collections.Generic.List[string]
$absent  = New-Object System.Collections.Generic.List[string]

foreach ($f in $wanted) {
  $full = Join-Path $aegisDir $f
  if (Test-Path -LiteralPath $full) {
    $present.Add($full) | Out-Null
  } else {
    $absent.Add($f) | Out-Null
  }
}

$result = [ordered]@{
  'aegis-dir' = $aegisDir
  'target'    = $For
  'present'   = @($present)
  'absent'    = @($absent)
}

if ($Json) {
  $result | ConvertTo-Json -Compress -Depth 4 | Write-Output
} else {
  Write-Output 'present:'
  foreach ($p in $present) { Write-Output "  $p" }
  Write-Output 'absent:'
  foreach ($a in $absent) { Write-Output "  $a" }
}

exit 0
