function getbranch() {
    # modified from:
    # https://stackoverflow.com/a/44411205/2665020
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        $branch = "(no branches)"
    }
    return " ($branch)"
}

function findclosestgit() {
    # function climbs dir structure
    # until it finds a git repo

}

function prompt {
    $p = Split-Path -leaf -path (Get-Location)
    if ($p.length -gt 3) {
      $p = $p.Substring(0,3)
    }
    Write-Host $p -NoNewLine
        
    if (Test-Path .git) {
        $branch = getbranch
        $out = "$p $branch"
    }
    else {
        $out = $p 
    }

    return " > "
}
