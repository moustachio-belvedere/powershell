function prompt {
  $p = Split-Path -leaf -path (Get-Location)
  if ($p.length -gt 3) {
    $p = $p.Substring(0,3)
  }
  "$p> "
}

