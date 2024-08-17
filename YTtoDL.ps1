function Get-YouTubeVideo {
    param(
        [Parameter(Mandatory=$true)]
        [string]$UrlVideo,
        [string]$OutputDirectory = ""
    )

    try {
        yt-dlp -f bestvideo+bestaudio[ext=mp4] --output "$OutputDirectory\%(title)s.%(ext)s" "$UrlVideo"
    }
    catch {
        Write-Warning "Erreur lors du téléchargement : $($_.Exception.Message)"
    }
}

function Get-YouTubeAudio {
    param(
        [Parameter(Mandatory=$true)]
        [string]$UrlVideo,
        [string]$OutputDirectory = ""
    )

    try {
        yt-dlp --extract-audio --audio-format mp3 -o "$OutputDirectory\%(title)s.%(ext)s" "$UrlVideo"
    }
    catch {
        Write-Warning "Erreur lors du téléchargement : $($_.Exception.Message)"
    }
}


function Get-YouTube {
  $urls = @()
  $format = ""
  [string]$OutputDirectory = Join-Path $env:USERPROFILE "Downloads"

  while ($true) {
      Write-Host "Saisissez une URL de vidéo YouTube (vide ou 'q' pour terminer) :"
      $url = Read-Host

      # Check for empty input or 'q' to break
      if ($url -eq "" -or $url -eq "q") {
          break
      }

      $urls += $url
  }

  # Check if the script was terminated early
  if ($urls.Count -eq 0) {
      Write-Host "Aucune URL saisie. Fin du script."
      return
  }

  Write-Host "Choisissez le format de téléchargement (MP3 ou MP4) :"
  $format = Read-Host

  foreach ($url in $urls) {
      if ($format -eq "MP3") {
          Get-YouTubeAudio -UrlVideo $url -OutputDirectory $outputDirectory
      } elseif ($format -eq "MP4") {
          Get-YouTubeVideo -UrlVideo $url -OutputDirectory $outputDirectory
      } else {
          Write-Warning "Format de téléchargement invalide."
      }
  }
}


Write-Host "`n"
Write-Host "
██╗   ██╗████████╗  ████████╗ ██████╗         ███╗   ███╗██████╗ ██████╗     ██╗███╗   ███╗██████╗ ██╗  ██╗
╚██╗ ██╔╝╚══██╔══╝  ╚══██╔══╝██╔═══██╗        ████╗ ████║██╔══██╗╚════██╗   ██╔╝████╗ ████║██╔══██╗██║  ██║
 ╚████╔╝    ██║        ██║   ██║   ██║        ██╔████╔██║██████╔╝ █████╔╝  ██╔╝ ██╔████╔██║██████╔╝███████║
  ╚██╔╝     ██║        ██║   ██║   ██║        ██║╚██╔╝██║██╔═══╝  ╚═══██╗ ██╔╝  ██║╚██╔╝██║██╔═══╝ ╚════██║
   ██║      ██║███████╗██║   ╚██████╔╝███████╗██║ ╚═╝ ██║██║     ██████╔╝██╔╝   ██║ ╚═╝ ██║██║          ██║
   ╚═╝      ╚═╝╚══════╝╚═╝    ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝     ╚═════╝ ╚═╝    ╚═╝     ╚═╝╚═╝          ╚═╝"
            Write-Host "A Youtube downloader, by Pooueto"
Write-Host "`n"


Get-YouTube