EnableExplicit

Enumeration window
  #mf  
EndEnumeration

Enumeration library
  #Library
EndEnumeration

Enumeration gadget
  #mfSelect
  #mfScan
EndEnumeration

Global IsAvailable, SelectImageSource, AcquireToFilename

;Plan de l'application
Declare Start()
Declare TWAINSelect()
Declare TWAINSCan()
Declare Exit()

Start()

Procedure Start()
  If OpenLibrary(#Library, "Twain32d.dll")
    
    IsAvailable = GetFunction(#Library, "TWAIN_IsAvailable")
    
    SelectImageSource = GetFunction(#Library, "TWAIN_SelectImageSource")
    AcquireToFilename = GetFunction(#Library, "TWAIN_AcquireToFilename")
    
  Else
    MessageRequester("Error","Could Not Open DLL",#MB_ICONERROR)
    exit()  
  EndIf
  
  If IsAvailable
    OpenWindow(#mf, 0, 0, 800, 600, "Twain.dll", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    ButtonGadget(#mfSelect, 10, 10, 190, 30, "Select TWAIN Source")
    ButtonGadget(#mfScan, 210, 10, 190, 30, "Scan!")
    
    ;Triggers
    BindGadgetEvent(#mfSelect, @TWAINSelect())
    BindGadgetEvent(#mfScan, @TWAINScan())
    BindEvent(#PB_Event_CloseWindow, @Exit())
  Else
    MessageRequester("Error", "Communication problem with the driver")
    Exit()
  EndIf
  
  Repeat : WaitWindowEvent() : ForEver
EndProcedure

Procedure TWAINSelect()
  CallFunctionFast(SelectImageSource, WindowID(#mf))
EndProcedure

Procedure TWAINSCan()
  Static CountScan
  Protected FileName.s = "scan" + Str(CountScan) + ".bmp"
  
  CallFunctionFast(AcquireToFilename, WindowID(#mf), Ascii(FileName))
  RunProgram(FileName)
  
  CountScan + 1
EndProcedure

Procedure Exit()  
  End
EndProcedure
