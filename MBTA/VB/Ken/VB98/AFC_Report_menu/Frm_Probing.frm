VERSION 5.00
Begin VB.Form Frm_Probing 
   Caption         =   "Bus & G/L Probing"
   ClientHeight    =   2775
   ClientLeft      =   1695
   ClientTop       =   1800
   ClientWidth     =   7560
   LinkTopic       =   "Form1"
   ScaleHeight     =   2775
   ScaleWidth      =   7560
   Begin VB.CommandButton Cmd_Submit 
      Caption         =   "Create Report"
      Height          =   735
      Left            =   5040
      TabIndex        =   2
      Top             =   1680
      Width           =   1575
   End
   Begin VB.OptionButton Option2 
      Caption         =   "G/L Report"
      Height          =   255
      Left            =   2400
      TabIndex        =   1
      Top             =   600
      Width           =   1815
   End
   Begin VB.OptionButton Option1 
      Caption         =   "Bus Report"
      Height          =   255
      Left            =   360
      TabIndex        =   0
      Top             =   600
      Width           =   1455
   End
End
Attribute VB_Name = "Frm_Probing"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Cmd_Submit_Click()
    If Option1.Value = False And Option2 = False Then
        MsgBox ("You must pick a report type"), vbOKOnly
        Exit Sub
    End If
    If Option1.Value = True Then Prob_Flag = "1"
    If Option2.Value = True Then Prob_Flag = "2"
    
    Report_Name = "FareBox"
    Frm_Report.Show vbModal
    
End Sub
