VERSION 5.00
Object = "{8E27C92E-1264-101C-8A2F-040224009C02}#7.0#0"; "MSCAL.OCX"
Begin VB.Form Frm_Calendar 
   Caption         =   "Select a Date"
   ClientHeight    =   4560
   ClientLeft      =   2895
   ClientTop       =   1530
   ClientWidth     =   5175
   LinkTopic       =   "Form1"
   ScaleHeight     =   4560
   ScaleWidth      =   5175
   Begin VB.CommandButton cmdcancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4080
      TabIndex        =   3
      Top             =   3600
      Width           =   1095
   End
   Begin VB.CommandButton cmdok 
      Caption         =   "OK"
      Height          =   375
      Left            =   2700
      TabIndex        =   2
      Top             =   3600
      Width           =   1275
   End
   Begin VB.TextBox txtdate 
      BackColor       =   &H00C0FFFF&
      Height          =   375
      Left            =   900
      Locked          =   -1  'True
      TabIndex        =   1
      Top             =   3600
      Width           =   1575
   End
   Begin MSACAL.Calendar Cal 
      Height          =   3495
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   5055
      _Version        =   524288
      _ExtentX        =   8916
      _ExtentY        =   6165
      _StockProps     =   1
      BackColor       =   -2147483633
      Year            =   2003
      Month           =   7
      Day             =   17
      DayLength       =   1
      MonthLength     =   2
      DayFontColor    =   0
      FirstDay        =   1
      GridCellEffect  =   1
      GridFontColor   =   10485760
      GridLinesColor  =   -2147483632
      ShowDateSelectors=   -1  'True
      ShowDays        =   -1  'True
      ShowHorizontalGrid=   -1  'True
      ShowTitle       =   -1  'True
      ShowVerticalGrid=   -1  'True
      TitleFontColor  =   10485760
      ValueIsNull     =   0   'False
      BeginProperty DayFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty GridFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty TitleFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
End
Attribute VB_Name = "Frm_Calendar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private sLastDate As Variant
Private vStartDate As Variant
Private sCaption As String

Public Function GetDate() As Variant
    GetDate = sLastDate
End Function


Public Sub SetCaption(ByVal sNewCaption As String)
    Me.Caption = sNewCaption
    sCaption = sNewCaption
End Sub

Public Sub SetStartDate(ByVal sStartDate)
    vStartDate = sStartDate
End Sub

Private Sub cal_SelChange(ByVal StartDate As Date, ByVal EndDate As Date, Cancel As Boolean)
    txtdate.Text = Cal.Value
    cmdok.SetFocus
End Sub


Private Sub Cal_Click()
    txtdate.Text = Cal.Value
    cmdok.SetFocus
End Sub

Private Sub Cal_NewMonth()
    txtdate.Text = ""
End Sub

Private Sub cal_NewYear()
    txtdate.Text = ""
End Sub

Private Sub cmdCancel_Click()
    'sLastDate = ""
    Unload Me
End Sub


Private Sub cmdOK_Click()
Dim formdate As Date
If txtdate.Text = "" Then
    MsgBox "Please Select a Day from the Calendar "
Exit Sub
End If
formdate = Cal.Value
    sLastDate = Format(formdate, "MM/DD/YYYY")
    Unload Me
End Sub


Private Sub Form_Load()
    If (vStartDate <> "") Then
        If IsDate(vStartDate) = True Then
            Cal.Value = vStartDate
            txtdate.Text = vStartDate
            sLastDate = vStartDate
        End If
    Else
        vStartDate = Date
        sLastDate = vStartDate
    End If
End Sub


Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If (UnloadMode = 0) Then    'User clicked the X button
        If (MsgBox("Do you really want to Quit?", vbYesNo, "Really Quit?") = vbYes) Then
            Cancel = False   ' setting Cancel to False will allow the program to continue running
        Else
            Cancel = True    ' setting cancel to true will force the program to keep running
        End If
    End If

End Sub


