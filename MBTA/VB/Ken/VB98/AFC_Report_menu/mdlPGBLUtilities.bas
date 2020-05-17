Attribute VB_Name = "mdlPGBLutilities"

Option Explicit
''''' variables used in the routine for checking users
 Public PGBLdbsource As ADODB.Connection
 Public PGBLrsSource As ADODB.Recordset
 Public PGBLsSql As String

   ''''' getting the computer name  and user name from login time out
   ''''''   of the registry..
Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpbuffer As String, nSize As Long) As Long
Private Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpbuffer As String, nSize As Long) As Long

Public PGBLm_NT_UserName       As String
Public PGBLm_ComputerName      As String

''' variables used in the routine tableread
Public PGBLPcursortype As String
Public PGBLPLocktype As String
Public PGBLPTrytimes As Long
Public PGBLretfromfunc As String
Public PGBLretfromadd As String

''' 6 basic Colors
Public Const PGBLcolorBlack = &H80000008
Public Const PGBLcolorBlue = &HFF0000
Public Const PGBLcolorGrey = &H8000000F
Public Const PGBLcoloryellow = &HC0FFFF
Public Const PGBLcolorwhite = &H80000005
Public Const PGBLcolorLTBlue = &HFFFF00

''' variable used in the date entry forms
Public PGBLfrmseldate_begdate  As String
Public PGBLfrmseldate_enddate As String
Public PGBLscreendate As String

'''Variables used in Date to from Julian
Public PGBLmdy6 As Variant
Public PGBLdd8  As Variant
Public PGBLbasedate As Date
''' variables used in check program routine
Public PGBLprogname As String
Public PGBLprogstatus As String
Public PGBLmappedletter As String
''' variables Used to activate a program already running
Public Const GW_HWNDPREV = 3
Declare Function OpenIcon Lib "user32" (ByVal hwnd As Long) As Long
Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long


Public Sub PGBLActivatePrevInstance()

   Dim OldTitle As String
   Dim PrevHndl As Long
   Dim result As Long

   'Save the title of the application.
   OldTitle = App.Title

   'Rename the title of this application so FindWindow
   'will not find this application instance.
   App.Title = "unwanted instance"

   'Attempt to get window handle using VB4 class name.
   PrevHndl = FindWindow("ThunderRTMain", OldTitle)

   'Check for no success.
   If PrevHndl = 0 Then

      'Attempt to get window handle using VB5 class name.
      PrevHndl = FindWindow("ThunderRT5Main", OldTitle)
   End If

   'Check if found
   If PrevHndl = 0 Then
        'Attempt to get window handle using VB6 class name
        PrevHndl = FindWindow("ThunderRT6Main", OldTitle)
   End If

   'Check if found
   If PrevHndl = 0 Then
      'No previous instance found.
      Exit Sub
   End If

   'Get handle to previous window.
   PrevHndl = GetWindow(PrevHndl, GW_HWNDPREV)

   'Restore the program.
   result = OpenIcon(PrevHndl)

   'Activate the application.
   result = SetForegroundWindow(PrevHndl)

   'End the application.
   End

End Sub
Public Function PGBLPrevInstance()
    If App.PrevInstance = True Then
        MsgBox "You're already running This Program.", vbOKOnly, "Already Running"
        PGBLPrevInstance = 1
        Exit Function
    End If
        PGBLPrevInstance = 0
End Function

Function PGBLGetUser_Name() As String
Dim lSize As Long
    
  PGBLm_NT_UserName = Space$(255)
  lSize = Len(PGBLm_NT_UserName)
  Call GetUserName(PGBLm_NT_UserName, lSize)
  If lSize > 0 Then
     PGBLm_NT_UserName = Left$(PGBLm_NT_UserName, lSize - 1)
  Else
     PGBLm_NT_UserName = vbNullString
  End If
  PGBLGetUser_Name = PGBLm_NT_UserName
End Function


Function PGBLGetComputer_Name() As String
Dim lSize As Long

  PGBLm_ComputerName = Space$(255)
  lSize = Len(PGBLm_ComputerName)
  Call GetComputerName(PGBLm_ComputerName, lSize)
  If lSize > 0 Then
     PGBLm_ComputerName = Left$(PGBLm_ComputerName, lSize)
  Else
     PGBLm_ComputerName = vbNullString
  End If
    
  PGBLGetComputer_Name = PGBLm_ComputerName
    
End Function

Public Function PGBLcheckprogstat(ByVal PGBLmappedletter, ByVal PGBLprogname As String) As String
    Dim openstring As String
    Dim aline As String
    Dim FSO As Scripting.FileSystemObject
    Set FSO = CreateObject("Scripting.FileSystemObject")

On Error GoTo checkprogstatexit
    openstring = PGBLmappedletter & PGBLprogname & ".down"
    If FSO.FileExists(openstring) Then
    Else
        Set FSO = Nothing
        GoTo checkprogstatexit
    End If
    Set FSO = Nothing

Open openstring For Input As #1

Do Until EOF(1)
    Line Input #1, aline
Loop
Close #1
If UCase(Trim(aline)) = "DOWN" Then
 ''''   MsgBox "Program Temporarily Closed by MIS Try Again in a Little While ", vbOKOnly, PGBLprogname
    PGBLcheckprogstat = "down"
    Exit Function
End If

checkprogstatexit:
    Exit Function

End Function
