# Rebuild GIFs from every .mov in this folder (requires ffmpeg on PATH).
# Run from repo root: pwsh docs/videos/convert-mov-to-gif.ps1
# Or: cd docs/videos; ./convert-mov-to-gif.ps1

$here = $PSScriptRoot
Get-ChildItem $here -Filter *.mov | ForEach-Object {
    $out = $_.FullName -replace '\.mov$', '.gif'
    Write-Host "Converting $($_.Name) -> $(Split-Path $out -Leaf)"
    ffmpeg -y -hide_banner -loglevel error -i $_.FullName -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen=reserve_transparent=0:stats_mode=full[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" -loop 0 $out
}
