^SPACE::  Winset, Alwaysontop, , A

;z/2022/10/16/05/49/34/-0500/Sunday, October 16/
!right::
FormatTime, time, A_now, yyyy'/'MM'/'dd'/'HH'/'mm'/'ss/-0500
FormatTime, date, A_now, dddd', 'MMMM' 'dd
send z/%time%/%date%/
return

;[[2022-10-16 Sunday]]
#!right::
FormatTime, time, A_now, yyyy'-'MM'-'dd
FormatTime, date, A_now, dddd
send {enter}[[%time% %date%]]{enter}
return

;[[z/2022/10/16]]
^!right::
FormatTime, time, A_now, yyyy'/'MM'/'dd'
send [[z/%time%]]
return

^#g::Reload
