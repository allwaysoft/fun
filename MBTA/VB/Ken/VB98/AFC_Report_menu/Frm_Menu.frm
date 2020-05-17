VERSION 5.00
Begin VB.Form Frm_Menu 
   Caption         =   "AFC Custom Reporting Menu"
   ClientHeight    =   6855
   ClientLeft      =   1305
   ClientTop       =   2520
   ClientWidth     =   9510
   LinkTopic       =   "Form1"
   ScaleHeight     =   6855
   ScaleWidth      =   9510
   Begin VB.Timer Timer1 
      Left            =   960
      Top             =   5520
   End
   Begin VB.Menu TStats 
      Caption         =   "T-Stats"
      Begin VB.Menu DeviceAvailability 
         Caption         =   "Device Availability Report"
      End
      Begin VB.Menu Incidentsbycat 
         Caption         =   "Incidents by Catagory"
      End
   End
   Begin VB.Menu MoneyRoom 
      Caption         =   "MoneyRoom"
      Begin VB.Menu MoneyStatus 
         Caption         =   "Money Status"
      End
      Begin VB.Menu Datelastvaulted 
         Caption         =   "Date Last Vaulted"
      End
   End
   Begin VB.Menu AFCfunctions 
      Caption         =   "AFC-Functions"
      Begin VB.Menu importnewusers 
         Caption         =   "Import New Users"
      End
      Begin VB.Menu RemoveAFCUsers 
         Caption         =   "Remove users from AFC"
      End
   End
   Begin VB.Menu AFCPreports 
      Caption         =   "AFC Reports"
      Begin VB.Menu Probing_Report 
         Caption         =   "Bus & G/L Probing Report"
      End
   End
End
Attribute VB_Name = "Frm_Menu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit



Private Sub Datelastvaulted_Click()
    Report_Name = "DateLastVaulted"
    Frm_Report.Show vbModal
    Report_Name = ""

End Sub

Private Sub DeviceAvailability_Click()
    Frm_Dev_Avail.Show vbModal

End Sub

Private Sub Form_Load()

    mappedletter = "\\mbtasql\Sharing and apps\"
    PGBLprogname = App.EXEName
    UpdownCount = 0
    
    PGBLprogstatus = PGBLcheckprogstat(mappedletter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        SQLData.Close
        Set SQLData = Nothing
        Unload Me
        End
     End If
End Sub

Private Sub Incidentsbycat_Click()
    Frm_Incident_Counts.Show vbModal
    
End Sub

Private Sub MoneyStatus_Click()
Current_User_Id = 0
    PW_Option = "Login"
    Frm_Login.Show vbModal
    Unload Frm_Login
    If Current_User_Id = 0 Then
        Exit Sub
    End If

    Report_Name = "Money Status"
    Frm_Report.Show vbModal
    Report_Name = ""

End Sub

Private Sub Probing_Report_Click()
    Frm_Probing.Show vbModal
    
End Sub

Private Sub Timer1_Timer()

    
    mappedletter = "\\mbtasql\Sharing and apps\"
    PGBLprogname = App.EXEName
    UpdownCount = 0
    PGBLprogstatus = PGBLcheckprogstat(mappedletter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        Unload Me
        End
     End If

    If Inputcheck = True Then '<<<<<<<<<<<<<<<<<<< this will detect any mousemove or key
         myloop = 0
         Exit Sub
    End If
    
    PGBLprogstatus = PGBLcheckprogstat(mappedletter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        SQLData.Close
        Set SQLData = Nothing
        Unload Me
        End
     End If

Dim myForm As Form

myloop = myloop + 1
If myloop < 3 Then Exit Sub 'if not 5 minutes then do nothing
SQLData.Close
Set SQLData = Nothing

'this will close all open forms beside the main form
End

'put the code for logoff here

myloop = 0 'zero myLoop
End Sub
