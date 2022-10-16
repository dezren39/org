SetCapsLockState, alwaysoff
^SPACE::  Winset, Alwaysontop, , A
^#g::Reload

;+capslock::
;        Keywait, Capslock
;	SetCapsLockState Off
;	Return
capslock::ctrl
;capslock::shift

;z/2022/10/16/05/49/34/Sunday, October 16/
!right::
FormatTime, time, A_nowutc, yyyy'/'MM'/'dd'/'HH'/'mm'/'ss
FormatTime, date, A_now, dddd', 'MMMM' 'dd
send z/%time%/%date%/
return

;[[2022-10-16 Sunday]][[z/2022/10/16]]
#!right::
FormatTime, time, A_now, yyyy'-'MM'-'dd
FormatTime, date, A_now, dddd
FormatTime, timeu, A_nowutc, yyyy'/'MM'/'dd'
send [[%time% %date%]][[z/%timeu%]]
return
