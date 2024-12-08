#Requires Autohotkey v2
#SingleInstance
SetWorkingDir(A_ScriptDir)
Global IconLib := A_ScriptDir . "\Icons"
, ImageLib := A_ScriptDir . "\Images"
, DonationsLib:= A_ScriptDir . "\Donations"
, Guide := "https://mean-littles-app.gitbook.io/mean-littles-app-docs"
, BuyMeACoffee := "https://buymeacoffee.com/fdjdash"
, IniFile := A_ScriptDir . "\ML_GameControllerRemap.ini"
, CurrentVersion := "0.52"
;----------------------------------------------------
; GUI Properties
GameToolGui := Gui("+AlwaysOnTop")
GameToolGui.Opt("+MinimizeBox +OwnDialogs -Theme")
GameToolGui.SetFont("Bold cLime", "Comic Sans MS")
GameToolGui.BackColor := "0x2F2F2F"
GameToolGui.Add("Picture", "x-16 y0 w304 h712", ImageLib . "\MLGTBackground.png")
;----------------------------------------------------
; Read Ini Properties
ExitMessageTimeWait := IniRead(IniFile, "Properties", "ExitMessageTimeWait")
;----------------------------------------------------
; Read ini Controller
ControllerLoop := IniRead(IniFile, "Controller", "ControllerLoop")
;----------------------------------------------------
; Read ini Cursor Movement
CursorSensRight := IniRead(IniFile, "ControllerCursorMovement", "CursorSensRight")
CursorSensDown := IniRead(IniFile, "ControllerCursorMovement", "CursorSensDown")
CursorSensLeft := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
CursorSensUp := IniRead(IniFile, "ControllerCursorMovement", "CursorSensLeft")
CursorSpeed := IniRead(IniFile, "ControllerCursorMovement", "CursorSpeed")
;----------------------------------------------------
; Controller Camera Rotation
ShiftDownRotation := IniRead(IniFile, "ControllerCameraRotation", "ShiftDownRotation")
CtrlDownRotation := IniRead(IniFile, "ControllerCameraRotation", "CtrlDownRotation")
RotateLeft := IniRead(IniFile, "ControllerCameraRotation", "RotateLeft")
RotateRight := IniRead(IniFile, "ControllerCameraRotation", "RotateRight")
RotateUp := IniRead(IniFile, "ControllerCameraRotation", "RotateUp")
RotateDown := IniRead(IniFile, "ControllerCameraRotation", "RotateDown")
;----------------------------------------------------
; Controller Normal Mode Remap
ButtonA := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonA")
ButtonB := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonB")
ButtonX := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonX")
ButtonY := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonY")
SprintLB := IniRead(IniFile, "ControllerNormalModeRemap", "SprintLB")
ScannerRB := IniRead(IniFile, "ControllerNormalModeRemap", "ScannerRB")
ButtonLT := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonLT")
ButtonRT := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonRT")
ButtonBack := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonBack")
ButtonStart := IniRead(IniFile, "ControllerNormalModeRemap", "ButtonStart")
;----------------------------------------------------
; Controller Race Mode Remap
AfterBurnerButtonA := IniRead(IniFile, "ControllerRaceModeRemap", "AfterBurnerButtonA")
ButtonLB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonLB")
ButtonRB := IniRead(IniFile, "ControllerRaceModeRemap", "ButtonRB")
RespawnY := IniRead(IniFile, "ControllerRaceModeRemap", "RespawnY")
AcelerateButtonRT := IniRead(IniFile, "ControllerRaceModeRemap", "AcelerateButtonRT")
ReverseButtonLT := IniRead(IniFile, "ControllerRaceModeRemap", "ReverseButtonLT")
;----------------------------------------------------
; Controller Axis Remap
TurnLeft := IniRead(IniFile, "ControllerAxisRemap", "TurnLeft")
TurnRight := IniRead(IniFile, "ControllerAxisRemap", "TurnRight")
MoveForward := IniRead(IniFile, "ControllerAxisRemap", "MoveForward")
MoveBackward := IniRead(IniFile, "ControllerAxisRemap", "MoveBackward")
LeftPOV := IniRead(IniFile, "ControllerAxisRemap", "LeftPOV")
RightPOV := IniRead(IniFile, "ControllerAxisRemap", "RightPOV")
ForwadPOV := IniRead(IniFile, "ControllerAxisRemap", "ForwadPOV")
BackwardPOV := IniRead(IniFile, "ControllerAxisRemap", "BackwardPOV")
;----------------------------------------------------
; Setup Menu
FileMenu := Menu()
MenuBar_Storage := MenuBar()
MenuBar_Storage.Add("&File", FileMenu)
FileMenu.Add("&Exit`tCtrl+K",MenuHandlerExit)

FileMenu.SetIcon("&Exit`tCtrl+K",IconLib . "\exit.ico")

OptionsMenu := Menu()
MenuBar_Storage.Add("&Options", OptionsMenu)
OptionsMenu.Add("Edit &Ini File", EditIniFileHandler)

OptionsMenu.SetIcon("Edit &Ini File", IconLib . "\File.ico")

DonationsMenu := Menu()
MenuBar_Storage.Add("&Donations", DonationsMenu)
DonationsMenu.Add("Buy me a coffee", DonationsMenuBMACoffeeHandler)
DonationsMenu.Add("ADA Cardano network", DonationsMenuCardanoHandler)
DonationsMenu.Add("EVM-compatible chains", DonationsMenuEVMHandler)
DonationsMenu.Add("BTC - Bitcoin chain", DonationsMenuBTCHandler)

DonationsMenu.SetIcon("Buy me a coffee", IconLib . "\Buymeacoffee.ico")
DonationsMenu.SetIcon("ADA Cardano network", IconLib . "\ada_cardano.ico")
DonationsMenu.SetIcon("EVM-compatible chains", IconLib . "\usdc.ico")
DonationsMenu.SetIcon("BTC - Bitcoin chain", IconLib . "\bitcoin.ico")

HelpMenu := Menu()
MenuBar_Storage.Add("&Help", HelpMenu)
HelpMenu.Add("Guide", MenuHandlerGuide)
HelpMenu.Add("Quick Fix", MenuHandlerQuickFix)
HelpMenu.Insert()
HelpMenu.Add("About", MenuHandlerAbout)

HelpMenu.SetIcon("Guide", IconLib . "\MLCR.ico")
HelpMenu.SetIcon("Quick Fix", IconLib . "\Fix.ico")
HelpMenu.SetIcon("About", IconLib . "\info.ico")

GameToolGui.MenuBar := MenuBar_Storage
;----------------------------------------------------
; Controller
GameToolGui.Add("Text","x10 y10 w68 h20 +0x200", " Controller:")
TextOnOffController := GameToolGui.Add("Text","x85 y10 w155 h20 +0x200", " Controller Not Found.")
ControllerName := GameToolGui.Add("Text","x10 y35 w230 h20 +0x200", " - - - - - - - - - -")
;----------------------------------------------------
GameToolGui.Add("Text", "x1 y59 w250 h2 +0x10") ; Separator
;----------------------------------------------------
GameToolGui.Add("Text","x20 y65 w212 h20 +0x200", " Game Doesn't Detect Controller Device?")
GameToolGui.Add("Text","x20 y90 w98 h20 +0x200", " Controller Remap:")
RadioCtrlRemapYes := GameToolGui.Add("Radio", "x140 y90 w30 h20 +Checked", "Y")
RadioCtrlRemapNo := GameToolGui.Add("Radio", "x200 y90 w31 h20", "N")
;----------------------------------------------------
; Controller Status
TextAxisInfo := GameToolGui.Add("Text","x20 y115 w212 h20 +0x200", " " )

ButtonAOnOff := GameToolGui.Add("Text","x20 y140 w20 h20 +0x200", " - ")
ButtonBOnOff := GameToolGui.Add("Text","x40 y140 w20 h20 +0x200", " - ")
ButtonXOnOff := GameToolGui.Add("Text","x60 y140 w20 h20 +0x200", " - ")
ButtonYOnOff := GameToolGui.Add("Text","x80 y140 w20 h20 +0x200", " - ")
ButtonLBOnOff := GameToolGui.Add("Text","x100 y140 w20 h20 +0x200", " - ")
ButtonRBOnOff := GameToolGui.Add("Text","x120 y140 w20 h20 +0x200", " - ")
ButtonBackOnOff := GameToolGui.Add("Text","x140 y140 w45 h20 +0x200", " -   -")
ButtonStartOnOff := GameToolGui.Add("Text","x185 y140 w47 h20 +0x200", "-   -")

NormalMode := GameToolGui.Add("Radio", "x20 y165 w95 h20 +Checked", " Normal Mode")
RaceMode := GameToolGui.Add("Radio", "x150 y165 w82 h20 ", " Race Mode")
;----------------------------------------------------
GameToolGui.Add("Text", "x1 y188 w250 h2 +0x10") ; Separator
GameToolGui.Add("Text","x80 y195 w90 h20 +0x200", " Camera Rotation")
CursorMovement := GameToolGui.Add("Radio", "x20 y220 h20 +Checked", " Cursor Movement")
RotateCamera := GameToolGui.Add("Radio", "x20 y245 h20", " Rotate with arrow keys")
RotateCameraCtrldown := GameToolGui.Add("Radio", "x20 y270 h20", " Rotate Ctrl Down + arrow keys")
RotateCameraShiftdown := GameToolGui.Add("Radio", "x20 y295 h20", " Rotate Shift Down + arrow keys")
GameToolGui.Add("Text", "x1 y318 w250 h2 +0x10") ; Separator
GameToolGui.Add("Text","x10 y320 h20 +0x200", " ADVICE: Minimize the app once you check")
GameToolGui.Add("Text","x10 y345 h20 +0x200", " any rotation to avoid switching selectors.")
;----------------------------------------------------
SB := GameToolGui.Add("StatusBar", , "Ready.")
;----------------------------------------------------
GameToolGui.OnEvent('Close', (*) => ExitApp())
GameToolGui.Title := "ML Game Controller Remap"
GameToolGui.Show("w250 h395")
Saved := GameToolGui.Submit(false)
;----------------------------------------------------
OnExit ExitMenu
ExitMenu(ExitReason,ExitCode)
{
		SB.SetText("Quiting..")
		If ExitReason == "Reload" {
			return 0
		}
		else {
			Send("{w up}")
			Send("{shift up}")
			ExitMsg
			sleep ExitMessageTimeWait
			return 0
		}
}
;----------------------------------------------------
; Auto-detect the controller number if called for:
ControllerNumber := 0 ; Auto-detect Controller

if ControllerNumber <= 0
{
    Loop 16  ; Query each controller number to find out which ones exist.
    {
        if GetKeyState(A_Index "JoyName")
        {
            ControllerNumber := A_Index
            break
        }
    }
    if ControllerNumber <= 0
    {
        ControllerAvailable := false
    } else {
		ControllerAvailable := true
	}
}
;----------------------------------------------------
DonationsMenuCardanoHandler(*){
ShowCardano:
		Cardano := Gui("+AlwaysOnTop")
		Cardano.BackColor := "0x2F2F2F"
		Cardano.Add("Picture", "x-120 y0 w712 h300", DonationsLib . "\CardanoAddress.png")
		Cardano.SetFont("s9 cLime", "Comic Sans MS")
		Cardano.Add("Text", "x93 y10", " ADA - Cardano Chain - ADA Handle: $grey.dash")
		EditADA := Cardano.Add("Edit", "x20 y245 w430 h40 +Readonly", "addr1qxlvz257exqmlfe9edzxgug3vfz59fajc4f6x3mr0053pqvqlegkyt3v299y5mjuxx0zk7ezpvesgqjp69g8q9whykzqtfz2u4")
		EditADA.Opt("Background2F2F2F")
		Cardano.Title := "Cardano"
		Cardano.Show("w470 h300")
		ControlFocus(" ", "Cardano")
		Cardano.Opt("+LastFound")
	Return
}
;----------------------------------------------------
DonationsMenuEVMHandler(*){
ShowUSDC:
		EVM := Gui("+AlwaysOnTop")
		EVM.BackColor := "0x2F2F2F"
		EVM.Add("Picture", "x-120 y0 w712 h300", DonationsLib . "\USDCBaseAddress.png")
		EVM.SetFont("s9 cLime", "Comic Sans MS")
		EVM.Add("Text", "x65 y10", " Copi, USDC, Ethereum, BNB and any EVM-compatible chain")
		EditEVM := EVM.Add("Edit", "x70 y245 w310 h20 +Readonly", "0xd6F28E0fDacee390Bee8a8E37cdBA458629bf184")
		EditEVM.Opt("Background2F2F2F")
		EVM.Title := "EVM"
		EVM.Show("w470 h300")
		ControlFocus(" ", "EVM")
		EVM.Opt("+LastFound")
	Return
}

DonationsMenuBTCHandler(*){
ShowBTC:
		BTC := Gui("+AlwaysOnTop")
		BTC.BackColor := "0x2F2F2F"
		BTC.Add("Picture", "x-120 y0 w712 h300", DonationsLib . "\BtcAddress.png")
		BTC.SetFont("s9 cLime", "Comic Sans MS")
		BTC.Add("Text", "x170 y10", " BTC - Bitcoin chain")
		EditBTC := BTC.Add("Edit", "x88 y245 w285 h20 +Readonly", "bc1qnh2lw9tmkte2yjq9lujc80qq7ke32ps0wj30ss")
		EditBTC.Opt("Background2F2F2F")
		BTC.Title := "BTC"
		BTC.Show("w470 h300")
		ControlFocus(" ", "BTC")
		BTC.Opt("+LastFound")
	Return
}

DonationsMenuBMACoffeeHandler(*){
ShowBMACoffee:
		BMACoffee := Gui("+AlwaysOnTop")
		BMACoffee.BackColor := "0x2F2F2F"
		BMACoffee.Add("Picture", "x-120 y0 w712 h300", ImageLib . "\MLGTBackground2.png")
		BMACoffee.Add("Picture", "x9 y10 w64 h64", IconLib . "\MLCR.ico")
		BMACoffee.SetFont("s18 W700 Q4 cLime", "Georgia")
		BMACoffee.Add("Text", "x80 y8", "ML Game Controller Remap")
		BMACoffee.SetFont("s9 cLime", "Comic Sans MS")
		BMACoffee.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		BMACoffee.SetFont()
		BMACoffee.SetFont("s12 cLime", "Comic Sans MS")
		BMACoffee.Add("Text", "x50 y135", "My buy me a coffee page will open in your browser.")
		BMACoffee.Add("Text", "x137 y160", "You can close this message.")
		BMACoffee.SetFont()
		BMACoffee.SetFont("s12 cLime", "Comic Sans MS")
		BMACoffee.Add("Text", "x187 y205", " Thank you! ")
		BMACoffee.Title := "BMACoffee"
		BMACoffee.Show("w470 h300")
		ControlFocus(" ", "BMACoffee")
		BMACoffee.Opt("+LastFound")
		Run BuyMeACoffee
	Return
}
;----------------------------------------------------
MenuHandlerAbout(*)
{
	ShowAbout:
		About := Gui("+AlwaysOnTop")
		About.BackColor := "0x2F2F2F"
		About.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLGTBackground2.png")
		About.Add("Picture", "x9 y10 w64 h64", IconLib . "\MLCR.ico")
		About.SetFont("s18 W700 Q4 cLime", "Georgia")
		About.Add("Text", "x80 y8", "ML Game Controller Remap")
		About.SetFont("s9 cLime", "Comic Sans MS")
		About.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		About.SetFont()
		About.SetFont("s12 cLime", "Comic Sans MS")
		About.Add("Text", "x80 y100", "Programmed and designed by:")
		About.Add("Link", "x310 y100", "<a href=`"https://github.com/FDJ-Dash/ML-Game-Controller-Remap`">FDJ-Dash</a>")
		About.Add("Text", "x80 y130", "Also known as Mean Little.")
		About.SetFont()
		About.SetFont("s9 cLime", "Comic Sans MS")
		About.Add("Text", "x30 y200", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := About.Add("Button", "x370 y200 w80 h24", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
		About.Title := "About"
		About.Show("w470 h240")
		ControlFocus("Button1", "About")
		About.Opt("+LastFound")
	Return
	Destroy(*){
		About.Destroy()
	}
}
;----------------------------------------------------
ExitMsg(*){
	ShowExit:
		Exitmsg := Gui("+AlwaysOnTop")
		Exitmsg.BackColor := "0x2F2F2F"
		Exitmsg.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLGTBackground2.png")
		Exitmsg.Add("Picture", "x9 y10 w64 h64", IconLib . "\MLCR.ico")
		Exitmsg.SetFont("s18 W700 Q4 cLime", "Georgia")
		Exitmsg.Add("Text", "x80 y8", "ML Game Controller Remap")
		Exitmsg.SetFont("s9 cLime", "Comic Sans MS")
		Exitmsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		Exitmsg.SetFont()
		Exitmsg.SetFont("s12 cLime", "Comic Sans MS")
		Exitmsg.Add("Text", "x45 y100", "ML Game Controller Remap will close in " ExitMessageTimeWait / 1000 " seconds.")
		Exitmsg.Add("Text", "x175 y130", "Have a nice day!")
		Exitmsg.SetFont()
		Exitmsg.SetFont("s9 cLime", "Comic Sans MS")
		Exitmsg.Add("Text", "x30 y200", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		Exitmsg.Title := "Goodbye!"
		Exitmsg.Show("w470 h240")
		Exitmsg.Opt("+LastFound")
	Return
}
;----------------------------------------------------
MenuHandlerExit(*){
	ExitApp()
}
;----------------------------------------------------
MenuHandlerGuide(*) {
	ShowGuide:
		GuideMsg := Gui("+AlwaysOnTop")
		GuideMsg.BackColor := "0x2F2F2F"
		GuideMsg.Add("Picture", "x-32 y0 w712 h300", ImageLib . "\MLGTBackground2.png")
		GuideMsg.Add("Picture", "x9 y10 w64 h64", IconLib . "\MLCR.ico")
		GuideMsg.SetFont("s18 W700 Q4 cLime", "Georgia")
		GuideMsg.Add("Text", "x80 y8", "ML Game Controller Remap")
		GuideMsg.SetFont("s9 cLime", "Comic Sans MS")
		GuideMsg.Add("Text", "x80 y45", "Mean Little's Game Controller Remap v" CurrentVersion)
		GuideMsg.SetFont()
		GuideMsg.SetFont("s12 cLime", "Comic Sans MS")
		GuideMsg.Add("Text", "x105 y100", "The guide will open in your browser.")
		GuideMsg.Add("Text", "x140 y125", "You can close this message.")
		GuideMsg.SetFont()
		GuideMsg.SetFont("s9 cLime", "Comic Sans MS")
		GuideMsg.Add("Text", "x30 y200", "Made with AutoHotkey V" A_AhkVersion . " " . (1 ? "Unicode" : "ANSI") . " " . (A_PtrSize == 8 ? "64-bit" : "32-bit"))
		ogcButtonOK := GuideMsg.Add("Button", "x370 y200 w80 h24 Default", "OK")
		ogcButtonOK.OnEvent("Click", Destroy)
		GuideMsg.Title := "Guide"
		GuideMsg.Show("w470 h240")
		ControlFocus("Button1", "Guide")
		GuideMsg.Opt("+LastFound")
		run Guide
	Return

	Destroy(*){
		GuideMsg.Destroy()
	}
}
;----------------------------------------------------
MenuHandlerQuickFix(*) {
	Send("{w up}")
	Send("{shift up}")
	Reload
}
;----------------------------------------------------
EditIniFileHandler(*) {
	run IniFile
}
;----------------------------------------------------
if ControllerAvailable == true {
	TextOnOffController.Value := " Controller Found"
	ControllerName.Value := GetKeyState(ControllerNumber "JoyName")
	cont_info := GetKeyState(ControllerNumber "JoyInfo")
	axis_info := " -   -   -   -   -   -   -   -   -   -"
	CoordMode "Mouse", "Screen"

	; Controller AutoRun Loop
	Loop {
		if RadioCtrlRemapYes.Value == true {
			RadioCtrlRemapNo.Value := false
			SB.SetText("Controller remap to keyboard active.")
			; Status info axis
			try {
					axis_info := " X" Round(GetKeyState(ControllerNumber "JoyX"))
				}
				catch as e {
					; the controller was disconnected
					TextOnOffController.Value := " Controller Not Found."
					ControllerName.Value := " "
					axis_info := " -   -   -   -   -   -   -   -   -   -"
					TextAxisInfo.Value := axis_info
					break
				}
			axis_info .= "  Y" Round(GetKeyState(ControllerNumber "JoyY"))
			;----------------------------------------------------
			; Jump Key - A
			if GetKeyState(ControllerNumber "Joy1", "P") {
				ButtonAOnOff.Value := " A"
				if NormalMode.Value == true {
					RaceMode.Value := false

					Send("{" . ButtonA . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . AfterBurnerButtonA . " down}")
				}
			} else {
				if ButtonAOnOff.Value == " A" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . ButtonA . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . AfterBurnerButtonA . " up}")
					}
					Send("{" . ButtonA . " up}")
					ButtonAOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Exit Key - B
			if GetKeyState(ControllerNumber "Joy2", "P") {
				ButtonBOnOff.Value := " B"
				Send("{" . ButtonB . " down}")
			} else {
				if ButtonBOnOff.Value == " B" {
					Send("{" . ButtonB . " up}")
					ButtonBOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Key - X
			if GetKeyState(ControllerNumber "Joy3", "P") {
				ButtonXOnOff.Value := " X"
				Send("{" . ButtonX . " down}")
			} else {
				if ButtonXOnOff.Value == " X" {
					Send("{" . ButtonX . " up}")
					ButtonXOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Interaction Key - Y
			if GetKeyState(ControllerNumber "Joy4", "P") {
				ButtonYOnOff.Value := " Y"
				if NormalMode.Value == true {
					RaceMode.Value := false
					Send("{" . ButtonY . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . RespawnY . " down}")
				}
			} else {
				if ButtonYOnOff.Value == " Y" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . ButtonY . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . RespawnY . " up}")
					}
					ButtonYOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			;  Key - LB
			if GetKeyState(ControllerNumber "Joy5", "P") {
				ButtonLBOnOff.Value := "LB"
				if NormalMode.Value == true {
					RaceMode.Value := false
					Send("{" . SprintLB . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . ButtonLB . " down}")
				}
			} else {
				if ButtonLBOnOff.Value == "LB" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . SprintLB . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . ButtonLB . " up}")
					}
					ButtonLBOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			; Scanner Key - RB
			if GetKeyState(ControllerNumber "Joy6", "P") {
				ButtonRBOnOff.Value := "RB"
				if NormalMode.Value == true {
					RaceMode.Value := false
					Send("{" . ScannerRB . " down}")
				} else {
					RaceMode.Value := true
					Send("{" . ButtonRB . " down}")
				}
			} else {
				if ButtonRBOnOff.Value == "RB" {
					if NormalMode.Value == true {
						RaceMode.Value := false
						Send("{" . ScannerRB . " up}")
					} else {
						RaceMode.Value := true
						Send("{" . ButtonRB . " up}")
					}
					ButtonRBOnOff.Value := " - "
				}
			}
			;----------------------------------------------------
			;  Key - Back
			if GetKeyState(ControllerNumber "Joy7", "P") {
				ButtonBackOnOff.Value := "BACK"
				Send("{" . ButtonBack . " down}")
			} else {
				if ButtonBackOnOff.Value == "BACK" {
					Send("{" . ButtonBack . " up}")
					ButtonBackOnOff.Value := " -   -"
				}
			}
			;----------------------------------------------------
			;  Key - Start
			if GetKeyState(ControllerNumber "Joy8", "P") {
				ButtonStartOnOff.Value := "START"
				Send("{" . ButtonStart . " down}")
			} else {
				if ButtonStartOnOff.Value == "START" {
					Send("{" . ButtonStart . " up}")
					ButtonStartOnOff.Value := "-   -"
				}
			}
			;----------------------------------------------------
			axis_info_X := Round(GetKeyState(ControllerNumber "JoyX"))
			If axis_info_X >= 45 and axis_info_X <= 55 {
				Send("{" . TurnLeft . " up}")
				Send("{" . TurnRight . " up}")
			}
			; Turn Left
			If axis_info_X < 45 {
				Send("{" . TurnRight . " up}")
				Send("{" . TurnLeft . " down}")
			}
			; Turn Right
			If axis_info_X > 55 {
				Send("{" . TurnLeft . " up}")
				Send("{" . TurnRight . " down}")
			}
			;----------------------------------------------------
			axis_info_Y := Round(GetKeyState(ControllerNumber "JoyY"))
			If axis_info_Y >= 45 and axis_info_Y <= 55 {
				Send("{" . MoveForward . " up}")
				Send("{" . MoveBackward . " up}")
			}
			; Go forward
			If axis_info_Y < 45 {
				Send("{" . MoveBackward . " up}")
				Send("{" . MoveForward . " down}")
			}
			; Go backward
			If axis_info_Y > 55 {
				Send("{" . MoveForward . " up}")
				Send("{" . MoveBackward . " down}")
			}
			;----------------------------------------------------
			; LT and RT
			if InStr(cont_info, "Z") {
				axis_info_Z := Round(GetKeyState(ControllerNumber "JoyZ"))
				axis_info .= "  Z" Round(GetKeyState(ControllerNumber "JoyZ"))
				if NormalMode.Value == true {
					RaceMode.Value := false
					if axis_info_Z >= 45 and axis_info_Z <= 55 {
						Send("{" . ButtonLT . " up}")
						Send("{" . ButtonRT . " up}")
					}
					; Controller RT key
					if axis_info_Z < 45 {
						Send("{" . ButtonLT . " up}")
						Send("{" . ButtonRT . " down}")
					}
					; Controller LT key
					if axis_info_Z > 55 {
						Send("{" . ButtonRT . " up}")
						Send("{" . ButtonLT . " down}")
					}
				} else {
					RaceMode.Value := true
					if axis_info_Z >= 45 and axis_info_Z <= 55 {
						Send("{" . ReverseButtonLT . " up}")
						Send("{" . AcelerateButtonRT . " up}")
					}
					; Controller RT key
					if axis_info_Z < 45 {
						Send("{" . ReverseButtonLT . " up}")
						Send("{" . AcelerateButtonRT . " down}")
					}
					; Controller LT key
					if axis_info_Z > 55 {
						Send("{" . AcelerateButtonRT . " up}")
						Send("{" . ReverseButtonLT . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "R"){
				; MouseMove X, Y , Speed, Relative
				axis_info_R := Round(GetKeyState(ControllerNumber "JoyR"))
				axis_info .= "  R" Round(GetKeyState(ControllerNumber "JoyR"))
				if axis_info_R >= 45 and axis_info_R <= 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraCtrldown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					}
				}
				; Look Up
				if axis_info_R < 45 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x, "int", y + CursorSensUp)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateUp . " down}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateUp . " down}")
					}
				}
				; Look Down
				if axis_info_R > 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x, "int", y + CursorSensDown)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateDown . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateDown . " down}")	
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateDown . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "U") {
				axis_info_U := Round(GetKeyState(ControllerNumber "JoyU"))
				axis_info .= "  U" Round(GetKeyState(ControllerNumber "JoyU"))
				if axis_info_U >= 45 and axis_info_U <= 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateUp . " up}")
						Send("{" . RotateDown . " up}")
					case RotateCameraCtrldown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " up}")
						Send("{" . RotateRight . " up}")
					}
				}
				; Look Left
				if axis_info_U < 45 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x + CursorSensLeft, "int", y)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateLeft . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateLeft . " down}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateLeft . " down}")
					}
				}
				; Look Right
				if axis_info_U > 55 {
					Switch true {
					case CursorMovement.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						MouseGetPos(&x, &y)
						DllCall("SetCursorPos", "int", x + CursorSensRight, "int", y)
					case RotateCamera.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . RotateRight . " down}")
					case RotateCameraCtrldown.Value:
						Send("{" . ShiftDownRotation . " up}")
						Send("{" . CtrlDownRotation . " down}")
						Send("{" . RotateRight . " down}")
					case RotateCameraShiftdown.Value:
						Send("{" . CtrlDownRotation . " up}")
						Send("{" . ShiftDownRotation . " down}")
						Send("{" . RotateRight . " down}")
					}
				}
			}
			;----------------------------------------------------
			if InStr(cont_info, "V") {
				axis_info_V :=  Round(GetKeyState(ControllerNumber "JoyV"))
			}
			;----------------------------------------------------
			if InStr(cont_info, "P") {
				axis_info_POV := Round(GetKeyState(ControllerNumber "JoyPOV"))
				axis_info .= "  POV" Round(GetKeyState(ControllerNumber "JoyPOV"))
				if axis_info_POV == -1 {
					Send("{" . LeftPOV . " up}")
					Send("{" . RightPOV . " up}")
					Send("{" . ForwadPOV . " up}")
					Send("{" . BackwardPOV . " up}")
				}
				; Go Upper Left
				if axis_info_POV  == 31500 {
					Send("{" . RightPOV . " up}")
					Send("{" . BackwardPOV . " up}")
					Send("{" . LeftPOV . " down}")
					Send("{" . ForwadPOV . " down}")
				}
				; Go Upper Right
				if axis_info_POV  == 4500 {
					Send("{" . LeftPOV . " up}")
					Send("{" . BackwardPOV . " up}")
					Send("{" . RightPOV . " down}")
					Send("{" . ForwadPOV . " down}")
				}
				; Go Lower Left
				if axis_info_POV  == 22500 {
					Send("{" . RightPOV . " up}")
					Send("{" . ForwadPOV . " up}")
					Send("{" . LeftPOV . " down}")
					Send("{" . BackwardPOV . " down}")
				}
				; Go Lower Right
				if axis_info_POV  == 13500 {
					Send("{" . LeftPOV . " up}")
					Send("{" . ForwadPOV . " up}")
					Send("{" . RightPOV . " down}")
					Send("{" . BackwardPOV . " down}")
				}
				; Turn Left
				If axis_info_POV  == 27000 {
					Send("{" . RightPOV . " up}")
					Send("{" . LeftPOV . " down}")
				}
				; Turn Right
				If axis_info_POV == 9000 {
					Send("{" . LeftPOV . " up}")
					Send("{" . RightPOV . " down}")
				}
				; Go Forward
				If axis_info_POV == 0 {
					Send("{" . BackwardPOV . " up}")
					Send("{" . ForwadPOV . " down}")
				}
				; Go Backward
				If axis_info_POV == 18000 {
					Send("{" . ForwadPOV . " up}")
					Send("{" . BackwardPOV . " down}")
				}
			}
		} else {
			SB.SetText("Ready.")
			axis_info := " -   -   -   -   -   -   -   -   -   -"
		}
		TextAxisInfo.Value := axis_info
		Sleep ControllerLoop
	} ; End Controller loop
} ; End Controller Available
;----------------------------------------------------