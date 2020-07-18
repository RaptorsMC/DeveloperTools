$binary = "https://dev.azure.com/pocketmine/a29511ba-1771-4ad2-a606-23c00a4b8b92/_apis/build/builds/233/artifacts?artifactName=Windows&api-version=5.1&%24format=zip"
$repo = "https://github.com/pmmp/PocketMine-MP.git"
$gitInstalled = $false;
try {
    if(Get-Command git.exe) {
        $gitInstalled = $true
    } else {
        $gitInstalled = $false
    }
} catch {
    $gitInstalled = $false;
}

if (!$gitInstalled) {
    Write-Host "Git must be installed before continuing" -ForegroundColor Red
    exit
} else {
    Write-Host "Cloning github..." -ForegroundColor Yellow
    git.exe clone --single-branch --branch master $repo
    if (!(Test-Path -Path "./PocketMine-MP")) {
        Write-Host "Failed to clone, unknown reason." -ForegroundColor Red
        exit
    }
    Invoke-WebRequest -Uri $binary -OutFile "./Windows.zip";
    if (!(Test-Path -Path "./Windows.zip")) {
        Write-Host "Failed to find binary archive." -ForegroundColor Red
        exit
    }
    Expand-Archive -Path "./Windows.zip"
}