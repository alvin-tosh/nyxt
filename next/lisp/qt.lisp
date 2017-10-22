;;;; qt.lisp --- QT helper functions & data

(in-package :next)

(qrequire :webkit)

(defun start-gui ()
  ;; remove margins around root widgets
  (|setSpacing| *root-layout* 0)
  (|setContentsMargins| *root-layout* 0 0 0 0)
   ;; arguments for grid layout: row, column, rowspan, colspan
  (|addLayout| *root-layout* *stack-layout*              0 0 1 1)
  (|addWidget| *root-layout* (buffer-view *minibuffer*)  1 0 1 1)
  (|hide| (buffer-view *minibuffer*))
  (|setLayout| *window* *root-layout*)
  (|show| *window*))

(defun set-visible-view (view)
  (|setCurrentWidget| *stack-layout* view))

(defun add-to-stack-layout (view)
  (|addWidget| *stack-layout* view))

(defun delete-view (view)
  (qdelete view))

(defun web-view-scroll-down (view)
  (|scroll| (|mainFrame| (|page| view))
	    0 scroll-distance))

(defun web-view-scroll-up (view)
  (|scroll| (|mainFrame| (|page| view))
	    0 (- scroll-distance)))

(defun web-view-set-url (view url)
  (qlet ((url (qnew "QUrl(QString)" url)))
	(|setUrl| view url)))

(defun web-view-set-url-loaded-callback (view function)
  (qconnect (|mainFrame| (|page| view)) "loadFinished(bool)"
	    function))

(defun web-view-get-url (view)
  (|toString| (|url| view)))

(defun make-web-view ()
  (qnew "QWebView"))

(defparameter *control-key* 16777249) ; OSX: command
(defparameter *meta-key* 16777250)    ; OSX: control
(defparameter *alt-key* 16777251)     ; OSX: option
(defparameter *super-key* 16777249)   ; OSX: command

(qadd-event-filter nil |QEvent.KeyPress| 'key-press)
(qadd-event-filter nil |QEvent.KeyRelease| 'key-release)

(defun key-press (obj event)
  ;; Invoked upon key-press
  (declare (ignore obj)) ; supress unused warnings
  (let ((key (|key| event)))
    (cond
      ((equalp key *control-key*)
       (setf *control-modifier* t))
      ((equalp key *meta-key*)
       (setf *meta-modifier* t))
      ((equalp key *super-key*)
       (setf *super-modifier* t))
      (t (progn
	   (push-key-chord key)
	   (consume-key-sequence))))))

(defun key-release (obj event)
  ;; Invoked upon key-release
  (declare (ignore obj)) ; supress unused warnings
  (let ((key (|key| event)))
    (cond
      ((equalp key *control-key*)
       (setf *control-modifier* nil))
      ((equalp key *meta-key*)
       (setf *meta-modifier* nil))
      ((equalp key *super-key*)
       (setf *super-modifier* nil))
      (t (return-from key-release)))))

;; create a character->keycode hashmap
(defparameter *character->keycode* (make-hash-table :test 'equalp))

(defun keycode (character keycode)
  (setf (gethash character *character->keycode*) keycode))

(defun initialize-keycodes ()
  (keycode "0" 48)
  (keycode "0" 48)
  (keycode "1" 49)
  (keycode "2" 50)
  (keycode "3" 51)
  (keycode "4" 52)
  (keycode "5" 53)
  (keycode "6" 54)
  (keycode "7" 55)
  (keycode "8" 56)
  (keycode "9" 57)
  (keycode "AE" 198)
  (keycode "Aacute" 193)
  (keycode "Acircumflex" 194)
  (keycode "AddFavorite" 16777408)
  (keycode "Adiaeresis" 196)
  (keycode "Agrave" 192)
  (keycode "AltGr" 16781571)
  (keycode "Alt" 16777251)
  (keycode "Ampersand" 38)
  (keycode "Any" 32)
  (keycode "Apostrophe" 39)
  (keycode "ApplicationLeft" 16777415)
  (keycode "ApplicationRight" 16777416)
  (keycode "Aring" 197)
  (keycode "AsciiCircum" 94)
  (keycode "AsciiTilde" 126)
  (keycode "Asterisk" 42)
  (keycode "Atilde" 195)
  (keycode "At" 64)
  (keycode "AudioCycleTrack" 16777478)
  (keycode "AudioForward" 16777474)
  (keycode "AudioRandomPlay" 16777476)
  (keycode "AudioRepeat" 16777475)
  (keycode "AudioRewind" 16777413)
  (keycode "Away" 16777464)
  (keycode "A" 65)
  (keycode "BackForward" 16777414)
  (keycode "Backslash" 92)
  (keycode "Backspace" 16777219)
  (keycode "Backtab" 16777218)
  (keycode "Back" 16777313)
  (keycode "Bar" 124)
  (keycode "BassBoost" 16777331)
  (keycode "BassDown" 16777333)
  (keycode "BassUp" 16777332)
  (keycode "Battery" 16777470)
  (keycode "Bluetooth" 16777471)
  (keycode "Blue" 16777495)
  (keycode "Book" 16777417)
  (keycode "BraceLeft" 123)
  (keycode "BraceRight" 125)
  (keycode "BracketLeft" 91)
  (keycode "BracketRight" 93)
  (keycode "BrightnessAdjust" 16777410)
  (keycode "B" 66)
  (keycode "CD" 16777418)
  (keycode "Calculator" 16777419)
  (keycode "Calendar" 16777444)
  (keycode "Call" 17825796)
  (keycode "CameraFocus" 17825825)
  (keycode "Camera" 17825824)
  (keycode "Cancel" 16908289)
  (keycode "CapsLock" 16777252)
  (keycode "Ccedilla" 199)
  (keycode "ChannelDown" 16777497)
  (keycode "ChannelUp" 16777496)
  (keycode "ClearGrab" 16777421)
  (keycode "Clear" 16777227)
  (keycode "Close" 16777422)
  (keycode "Codeinput" 16781623)
  (keycode "Colon" 58)
  (keycode "Comma" 44)
  (keycode "Community" 16777412)
  (keycode "Context1" 17825792)
  (keycode "Context2" 17825793)
  (keycode "Context3" 17825794)
  (keycode "Context4" 17825795)
  (keycode "ContrastAdjust" 16777485)
  (keycode "Control" 16777249)
  (keycode "Copy" 16777423)
  (keycode "Cut" 16777424)
  (keycode "C" 67)
  (keycode "DOS" 16777426)
  (keycode "Delete" 16777223)
  (keycode "Dollar" 36)
  (keycode "Down" 16777237)
  (keycode "D" 68)
  (keycode "ETH" 208)
  (keycode "Eacute" 201)
  (keycode "Ecircumflex" 202)
  (keycode "Ediaeresis" 203)
  (keycode "Egrave" 200)
  (keycode "Eject" 16777401)
  (keycode "End" 16777233)
  (keycode "Enter" 16777221)
  (keycode "Equal" 61)
  (keycode "Escape" 16777216)
  (keycode "Exclam" 33)
  (keycode "Execute" 16908291)
  (keycode "Exit" 16908298)
  (keycode "Explorer" 16777429)
  (keycode "E" 69)
  (keycode "F10" 16777273)
  (keycode "F11" 16777274)
  (keycode "F12" 16777275)
  (keycode "F13" 16777276)
  (keycode "F14" 16777277)
  (keycode "F15" 16777278)
  (keycode "F16" 16777279)
  (keycode "F17" 16777280)
  (keycode "F18" 16777281)
  (keycode "F19" 16777282)
  (keycode "F1" 16777264)
  (keycode "F20" 16777283)
  (keycode "F21" 16777284)
  (keycode "F22" 16777285)
  (keycode "F23" 16777286)
  (keycode "F24" 16777287)
  (keycode "F25" 16777288)
  (keycode "F26" 16777289)
  (keycode "F27" 16777290)
  (keycode "F28" 16777291)
  (keycode "F29" 16777292)
  (keycode "F2" 16777265)
  (keycode "F30" 16777293)
  (keycode "F31" 16777294)
  (keycode "F32" 16777295)
  (keycode "F33" 16777296)
  (keycode "F34" 16777297)
  (keycode "F35" 16777298)
  (keycode "F3" 16777266)
  (keycode "F4" 16777267)
  (keycode "F5" 16777268)
  (keycode "F6" 16777269)
  (keycode "F7" 16777270)
  (keycode "F8" 16777271)
  (keycode "F9" 16777272)
  (keycode "Favorites" 16777361)
  (keycode "Finance" 16777411)
  (keycode "Find" 16777506)
  (keycode "Flip" 17825798)
  (keycode "Forward" 16777314)
  (keycode "F" 70)
  (keycode "Game" 16777430)
  (keycode "Go" 16777431)
  (keycode "Greater" 62)
  (keycode "Green" 16777493)
  (keycode "Guide" 16777498)
  (keycode "G" 71)
  (keycode "Help" 16777304)
  (keycode "Henkan" 16781603)
  (keycode "Hibernate" 16777480)
  (keycode "History" 16777407)
  (keycode "HomePage" 16777360)
  (keycode "Home" 16777232)
  (keycode "HotLinks" 16777409)
  (keycode "Hyper_L" 16777302)
  (keycode "Hyper_R" 16777303)
  (keycode "H" 72)
  (keycode "Iacute" 205)
  (keycode "Icircumflex" 206)
  (keycode "Idiaeresis" 207)
  (keycode "Igrave" 204)
  (keycode "Info" 16777499)
  (keycode "Insert" 16777222)
  (keycode "I" 73)
  (keycode "J" 74)
  (keycode "KeyboardBrightnessDown" 16777398)
  (keycode "KeyboardBrightnessUp" 16777397)
  (keycode "KeyboardLightOnOff" 16777396)
  (keycode "K" 75)
  (keycode "Launch0" 16777378)
  (keycode "Launch1" 16777379)
  (keycode "Launch2" 16777380)
  (keycode "Launch3" 16777381)
  (keycode "Launch4" 16777382)
  (keycode "Launch5" 16777383)
  (keycode "Launch6" 16777384)
  (keycode "Launch7" 16777385)
  (keycode "Launch8" 16777386)
  (keycode "Launch9" 16777387)
  (keycode "LaunchA" 16777388)
  (keycode "LaunchB" 16777389)
  (keycode "LaunchC" 16777390)
  (keycode "LaunchD" 16777391)
  (keycode "LaunchE" 16777392)
  (keycode "LaunchF" 16777393)
  (keycode "LaunchG" 16777486)
  (keycode "LaunchH" 16777487)
  (keycode "LaunchMail" 16777376)
  (keycode "LaunchMedia" 16777377)
  (keycode "Left" 16777234)
  (keycode "Less" 60)
  (keycode "LightBulb" 16777405)
  (keycode "LogOff" 16777433)
  (keycode "L" 76)
  (keycode "MailForward" 16777467)
  (keycode "Market" 16777434)
  (keycode "Massyo" 16781612)
  (keycode "MediaLast" 16842751)
  (keycode "MediaNext" 16777347)
  (keycode "MediaPause" 16777349)
  (keycode "MediaPlay" 16777344)
  (keycode "MediaPrevious" 16777346)
  (keycode "MediaRecord" 16777348)
  (keycode "MediaStop" 16777345)
  (keycode "MediaTogglePlayPause" 16777350)
  (keycode "Meeting" 16777435)
  (keycode "Memo" 16777404)
  (keycode "MenuKB" 16777436)
  (keycode "MenuPB" 16777437)
  (keycode "Menu" 16777301)
  (keycode "Messenger" 16777465)
  (keycode "Meta" 16777250)
  (keycode "MicMute" 16777491)
  (keycode "MicVolumeDown" 16777502)
  (keycode "MicVolumeUp" 16777501)
  (keycode "Minus" 45)
  (keycode "M" 77)
  (keycode "News" 16777439)
  (keycode "New" 16777504)
  (keycode "No" 16842754)
  (keycode "Ntilde" 209)
  (keycode "NumLock" 16777253)
  (keycode "NumberSign" 35)
  (keycode "N" 78)
  (keycode "Oacute" 211)
  (keycode "Ocircumflex" 212)
  (keycode "Odiaeresis" 214)
  (keycode "OfficeHome" 16777440)
  (keycode "Ograve" 210)
  (keycode "Ooblique" 216)
  (keycode "OpenUrl" 16777364)
  (keycode "Open" 16777505)
  (keycode "Option" 16777441)
  (keycode "Otilde" 213)
  (keycode "O" 79)
  (keycode "PageDown" 16777239)
  (keycode "PageUp" 16777238)
  (keycode "ParenLeft" 40)
  (keycode "ParenRight" 41)
  (keycode "Paste" 16777442)
  (keycode "Pause" 16777224)
  (keycode "Percent" 37)
  (keycode "Period" 46)
  (keycode "Phone" 16777443)
  (keycode "Pictures" 16777468)
  (keycode "Play" 16908293)
  (keycode "Plus" 43)
  (keycode "PowerDown" 16777483)
  (keycode "PowerOff" 16777399)
  (keycode "PreviousCandidate" 16781630)
  (keycode "Printer" 16908290)
  (keycode "Print" 16777225)
  (keycode "P" 80)
  (keycode "Question" 63)
  (keycode "QuoteDbl" 34)
  (keycode "QuoteLeft" 96)
  (keycode "Q" 81)
  (keycode "Redo" 16777508)
  (keycode "Red" 16777492)
  (keycode "Refresh" 16777316)
  (keycode "Reload" 16777446)
  (keycode "Reply" 16777445)
  (keycode "Return" 16777220)
  (keycode "Right" 16777236)
  (keycode "Romaji" 16781604)
  (keycode "RotateWindows" 16777447)
  (keycode "RotationKB" 16777449)
  (keycode "RotationPB" 16777448)
  (keycode "R" 82)
  (keycode "Save" 16777450)
  (keycode "ScreenSaver" 16777402)
  (keycode "ScrollLock" 16777254)
  (keycode "Search" 16777362)
  (keycode "Select" 16842752)
  (keycode "Semicolon" 59)
  (keycode "Send" 16777451)
  (keycode "Settings" 16777500)
  (keycode "Shift" 16777248)
  (keycode "Shop" 16777406)
  (keycode "SingleCandidate" 16781628)
  (keycode "Slash" 47)
  (keycode "Sleep" 16908292)
  (keycode "Space" 32)
  (keycode "Spell" 16777452)
  (keycode "SplitScreen" 16777453)
  (keycode "Standby" 16777363)
  (keycode "Stop" 16777315)
  (keycode "Subtitle" 16777477)
  (keycode "Super_L" 16777299)
  (keycode "Super_R" 16777300)
  (keycode "Support" 16777454)
  (keycode "Suspend" 16777484)
  (keycode "SysReq" 16777226)
  (keycode "S" 83)
  (keycode "THORN" 222)
  (keycode "Tab" 16777217)
  (keycode "TaskPane" 16777455)
  (keycode "Terminal" 16777456)
  (keycode "Time" 16777479)
  (keycode "ToDoList" 16777420)
  (keycode "ToggleCallHangup" 17825799)
  (keycode "Tools" 16777457)
  (keycode "TopMenu" 16777482)
  (keycode "TouchpadOff" 16777490)
  (keycode "TouchpadOn" 16777489)
  (keycode "TouchpadToggle" 16777488)
  (keycode "Touroku" 16781611)
  (keycode "Travel" 16777458)
  (keycode "TrebleDown" 16777335)
  (keycode "TrebleUp" 16777334)
  (keycode "T" 84)
  (keycode "UWB" 16777473)
  (keycode "Uacute" 218)
  (keycode "Ucircumflex" 219)
  (keycode "Udiaeresis" 220)
  (keycode "Ugrave" 217)
  (keycode "Underscore" 95)
  (keycode "Undo" 16777507)
  (keycode "Up" 16777235)
  (keycode "U" 85)
  (keycode "Video" 16777459)
  (keycode "View" 16777481)
  (keycode "VoiceDial" 17825800)
  (keycode "VolumeDown" 16777328)
  (keycode "VolumeMute" 16777329)
  (keycode "VolumeUp" 16777330)
  (keycode "V" 86)
  (keycode "WLAN" 16777472)
  (keycode "WWW" 16777403)
  (keycode "WakeUp" 16777400)
  (keycode "WebCam" 16777466)
  (keycode "Word" 16777460)
  (keycode "W" 87)
  (keycode "Xfer" 16777461)
  (keycode "X" 88)
  (keycode "Yacute" 221)
  (keycode "Yellow" 16777494)
  (keycode "Yes" 16842753)
  (keycode "Y" 89)
  (keycode "ZoomIn" 16777462)
  (keycode "ZoomOut" 16777463)
  (keycode "Zoom" 16908294)
  (keycode "Z" 90)
  (keycode "acute" 180)
  (keycode "brokenbar" 166)
  (keycode "cedilla" 184)
  (keycode "cent" 162)
  (keycode "copyright" 169)
  (keycode "currency" 164)
  (keycode "degree" 176)
  (keycode "diaeresis" 168)
  (keycode "division" 247)
  (keycode "exclamdown" 161)
  (keycode "guillemotleft" 171)
  (keycode "guillemotright" 187)
  (keycode "hyphen" 173)
  (keycode "iTouch" 16777432)
  (keycode "macron" 175)
  (keycode "masculine" 186)
  (keycode "multiply" 215)
  (keycode "mu" 181)
  (keycode "nobreakspace" 160)
  (keycode "notsign" 172)
  (keycode "onehalf" 189)
  (keycode "onequarter" 188)
  (keycode "onesuperior" 185)
  (keycode "ordfeminine" 170)
  (keycode "paragraph" 182)
  (keycode "periodcentered" 183)
  (keycode "plusminus" 177)
  (keycode "questiondown" 191)
  (keycode "registered" 174)
  (keycode "section" 167)
  (keycode "ssharp" 223)
  (keycode "sterling" 163)
  (keycode "threequarters" 190)
  (keycode "threesuperior" 179)
  (keycode "twosuperior" 178)
  (keycode "unknown" 33554431)
  (keycode "ydiaeresis" 255)
  (keycode "yen" 165))
