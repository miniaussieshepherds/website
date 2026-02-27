param(
  [Parameter(Mandatory=$false)]
  [string]$Message
)

$ErrorActionPreference = 'Stop'

function Ensure-GitRepo {
  if (-not (Test-Path .git)) {
    throw 'Not a git repository (missing .git folder).'
  }
}

function Ensure-OnMain {
  $branch = (git rev-parse --abbrev-ref HEAD).Trim()
  if ($branch -ne 'main') {
    Write-Warning "You are on branch '$branch' (expected 'main')."
  }
}

function Ensure-OriginRemote {
  $remote = (git remote get-url origin 2>$null)
  if (-not $remote) {
    throw 'Missing git remote "origin". Add it first: git remote add origin <url>'
  }
}

Ensure-GitRepo
Ensure-OriginRemote
Ensure-OnMain

# Stage everything (including new files)
git add -A

# If nothing staged, exit cleanly
$porcelain = (git status --porcelain)
if (-not $porcelain) {
  Write-Output 'No changes to commit.'
  exit 0
}

if (-not $Message -or -not $Message.Trim()) {
  $Message = Read-Host 'Commit message'
}

if (-not $Message -or -not $Message.Trim()) {
  throw 'Commit message is required.'
}

git commit -m $Message

# Push to origin/main
git push origin main
