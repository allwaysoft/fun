VERSION 5.00
Begin VB.Form Frm_Menu 
   Caption         =   "AFC Custom Reporting Menu"
   ClientHeight    =   6855
   ClientLeft      =   1215
   ClientTop       =   1050
   ClientWidth     =   9510
   LinkTopic       =   "Form1"
   ScaleHeight     =   6855
   ScaleWidth      =   9510
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
    Report_Name = "Availibility"
    Frm_Report.Show vbModal
    Report_Name = ""
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
