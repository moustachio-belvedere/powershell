function Get-Branch {
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
        $branch = "no branches"
    }
    return "($branch)"
}

function Get-Status {
    Param($dir)
    # Doesn't notify if there are untracked
    # files (not in .gitignore). This could be added
    # later using:
    # `git ls-files . --exclude-standard --others`
    #
    # 0 -> All up to date
    # 1 -> Changes to tracked file(s) not staged
    # 2 -> Some stages changed, but not committed
    # 3 -> Not a git repo (see Find-Closest-Git)
    $status = 0
    if (git --git-dir $dir diff --name-only) {
        $status = 1
    }
    elseif (git --git-dir $dir diff --staged --name-only) {
        $status = 2
    }
    return $status
}

function Find-Closest-Git {
    Param($loc)
    # function climbs dir structure
    # until it finds a git repo
    try {
        $gitquery = Join-Path -Path $loc -ChildPath ".git"

        if ($loc) {
            if (Test-Path $gitquery) {
                $branch = Get-Branch($gitquery)
                $status = Get-Status($gitquery)
                return $branch, $status
            }
            else {
                $par = Split-Path -Parent $loc
                Find-Closest-Git($par)
            }
        } 
    } catch {
        return "(.)", 3
    }
}

function Short-Dir-Return {
    Param($loc)
    $p = Split-Path -leaf -path $loc
    if ($p.length -gt 3) {
      $p = $p.Substring(0,3)
    }
    return $p
}

function Prompt {
    $loc = (Get-Location)
    $d = Short-Dir-Return($loc)
    $g = Find-Closest-Git($loc)
    $b = $g[0]
    $s = $g[1]
    "$d $b $s > "
}
