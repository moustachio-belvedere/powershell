function putbranch {
    Param($dir)
    # modified from:
    # https://stackoverflow.com/a/44411205/2665020
    try {
        $branch = git --git-dir $dir rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git --git-dir $dir rev-parse --short HEAD
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        $branch = "(no branches)"
    }
    Write-Host "($branch) " -NoNewLine
}

function findclosestgit {
    Param($loc)
    # function climbs dir structure
    # until it finds a git repo
    $gitquery = Join-Path -Path $loc -ChildPath ".git"
    if ($loc) {
        if (Test-Path $gitquery) {
            putbranch($gitquery)
        }
        else {
            $par = Split-Path -Parent $loc
            findclosestgit($par)
        }
    }
}

function shorteneddir {
    Param($loc)
    $p = Split-Path -leaf -path $loc
    if ($p.length -gt 3) {
      $p = $p.Substring(0,3)
    }
    Write-Host "$p " -NoNewLine
}

function prompt {
    $loc = (Get-Location)
    shorteneddir($loc)
    findclosestgit($loc)
    return "> "
}
