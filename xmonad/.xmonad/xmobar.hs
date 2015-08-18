Config { font = "xft:Inconsolata:pixelsize=11:antialias=true",
    bgColor = "#2d2d2d",
    fgColor = "#f2f0ec",
    position = Static { xpos = 0, ypos = 0, width = 1208, height = 18 },
    lowerOnStart = True,
    pickBroadest = False,
    persistent = False,
    hideOnStart = False,
    commands = [
        Run Weather "EDSB" [
            "-t", "<tempC>°C","-d","1",
            "-L","14","-H","25",
            "-h","#f2777a","-n","#ffcc66","-l","#6699cc"
        ] 36000,
        Run Network "eth0" [
            "-t", "wire: <rx> | <tx>","-L","100","-H","1000",
            "-h","#f2777a","-n","#ffcc66","-l","#99cc99",
            "-w","4"
        ] 10,
        Run Network "wlan0" [
            "-t", "air: <rx> | <tx>","-L","100",
            "-h","#f2777a","-n","#ffcc66","-l","#99cc99",
            "-w","4"] 10,
        Run MultiCpu [
            "-t","cpu: <total0> <total1>",
            "-h","#f2777a","-n","#ffcc66","-l","#99cc99",
            "-w","3"
        ] 10,
        Run Memory [
            "-t","mem: <usedratio>",
            "-h","#f2777a","-n","#ffcc66","-l","#99cc99",
            "-w","3"
        ] 10,
        Run Swap [
            "-t", "<usedratio>",
            "-h","#f2777a","-n","#ffcc66","-l","#99cc99",
            "-w","3"
        ] 10,                    
	Run BatteryP [ "BAT1" ]
            ["-t", "<acstatus>",
            "-p", "3",
            "-L", "25", "-H", "65",
            "-l", "#f2777a",
            "-n", "#ffcc66",
	    "-h", "#99cc99",
            "--",
            "-O", "batt+: <left>",
            "-i", "batt: <left>",
            "-o", "batt: <left> <timeleft>"
            ]
            150,
        Run Com "uname" ["-s","-r"] "" 36000,
        Run Date "<fc=#cc99cc>%a %b %d %Y %H:%M</fc>" "date" 10,
        Run Com "/home/blangguth/.xmonad/bin/getVolume.sh" [] "vol" 10,
--      Run Brightness ["-t","light: <percent>","-D","sony","-w","3"] 10, -- @todo: -D seems to be an unrecognized option
        Run StdinReader
      ],
      sepChar = "%",
      alignSep = "}{",
      template = "%StdinReader%}{ %multicpu%   %memory% | %swap%   %eth0%%wlan0%   %battery%   vol: %vol%   %EDSB%   %date% |"
    }
