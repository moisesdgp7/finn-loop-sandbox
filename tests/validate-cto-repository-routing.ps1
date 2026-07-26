$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$spec = Get-Content -Raw (Join-Path $repoRoot "skills\cto-spec\SKILL.md")
$build = Get-Content -Raw (Join-Path $repoRoot "skills\cto-build\SKILL.md")
$review = Get-Content -Raw (Join-Path $repoRoot "skills\cto-review\SKILL.md")

function Assert-Contains {
    param(
        [string]$Name,
        [string]$Text,
        [string]$Pattern
    )

    if ($Text -notmatch $Pattern) {
        throw "$Name is missing required routing contract: $Pattern"
    }
}

Assert-Contains "CTO Spec" $spec 'CTO GitHub repository:\s*`?owner/repo`?'
Assert-Contains "CTO Spec" $spec 'repository-changing issue'
Assert-Contains "CTO Spec" $spec 'explicit confirmation'
Assert-Contains "CTO Spec" $spec 'do not create (a )?repository'

Assert-Contains "CTO Build" $build 'gh repo view ORIGIN_URL --json nameWithOwner'
Assert-Contains "CTO Build" $build 'git remote get-url origin'
Assert-Contains "CTO Build" $build 'exactly matches\s+the\s+current repository'
Assert-Contains "CTO Build" $build 'do not\s+claim'
Assert-Contains "CTO Build" $build 'repair'
Assert-Contains "CTO Build" $build 'exactly one\s+`Closes TEAM-NNN`'
Assert-Contains "CTO Build" $build 'immediately before\s+every push'

Assert-Contains "CTO Review" $review '\[ROUTING\]'
Assert-Contains "CTO Review" $review 'CTO GitHub repository'
Assert-Contains "CTO Review" $review 'needs-human-review'
Assert-Contains "CTO Review" $review 'Linear Project: PROJECT_ID'
Assert-Contains "CTO Review" $review 'Repository route: owner/repo'
Assert-Contains "CTO Review" $review 'route still match'

$allSkills = "$spec`n$build`n$review"
if ($allSkills -match 'local_path|local path|C:\\') {
    throw "Repository routing must not store machine-specific local paths."
}

function Get-RoutingDecision {
    param(
        [string]$ProjectDescription,
        [string]$CurrentRepository
    )

    $routePattern = '(?im)^CTO GitHub repository:\s*`?([a-z0-9_.-]+/[a-z0-9_.-]+)`?\s*$'
    $routes = [regex]::Matches($ProjectDescription, $routePattern)

    if ($routes.Count -ne 1) {
        return "skip-invalid-route"
    }

    if ($routes[0].Groups[1].Value -ine $CurrentRepository) {
        return "skip-repository-mismatch"
    }

    return "eligible"
}

$matching = @"
Project for the CTO loop.

CTO GitHub repository: moisesdgp7/finn-loop-sandbox
"@
$missing = "Project without a configured repository."
$duplicate = @"
CTO GitHub repository: moisesdgp7/finn-loop-sandbox
CTO GitHub repository: moisesdgp7/propr-automation
"@
$mismatch = "CTO GitHub repository: moisesdgp7/propr-automation"

if ((Get-RoutingDecision $matching "moisesdgp7/finn-loop-sandbox") -ne "eligible") {
    throw "Matching Project route must be eligible."
}
if ((Get-RoutingDecision $missing "moisesdgp7/finn-loop-sandbox") -ne "skip-invalid-route") {
    throw "Missing Project route must be skipped."
}
if ((Get-RoutingDecision $duplicate "moisesdgp7/finn-loop-sandbox") -ne "skip-invalid-route") {
    throw "Duplicate Project routes must be skipped."
}
if ((Get-RoutingDecision $mismatch "moisesdgp7/finn-loop-sandbox") -ne "skip-repository-mismatch") {
    throw "Mismatched Project route must be skipped."
}

Write-Output "CTO repository routing contract: PASS"
