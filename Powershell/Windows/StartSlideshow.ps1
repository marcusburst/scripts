## Auto-starts a powerpoint file in slideshow mode, great for public/display TV's. Ideally you want to call this script with a .bat file in the startup folder of the host ##

$ppt = "\\mynetworklocation\Please update this version.pptx"

$app = New-Object -ComObject powerpoint.application
          $pres = $app.Presentations.open($ppt)
          $app.visible = "msoTrue"
          $pres.SlideShowSettings.Run()                         
          $pres.visible = "msoTrue"