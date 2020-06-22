VERSION 5.00
Begin VB.Form Frm_main 
   Caption         =   "Ridership summary"
   ClientHeight    =   5220
   ClientLeft      =   1965
   ClientTop       =   915
   ClientWidth     =   12960
   LinkTopic       =   "Form1"
   ScaleHeight     =   5220
   ScaleWidth      =   12960
   Begin VB.TextBox Txt_MagPass_Total 
      Height          =   285
      Left            =   8880
      TabIndex        =   23
      Top             =   3240
      Width           =   1815
   End
   Begin VB.TextBox Txt_SC_Total 
      Height          =   285
      Left            =   8880
      TabIndex        =   22
      Top             =   2760
      Width           =   1815
   End
   Begin VB.TextBox Txt_Total 
      Height          =   285
      Left            =   8880
      TabIndex        =   21
      Top             =   2250
      Width           =   1815
   End
   Begin VB.CommandButton cmd_exit 
      BackColor       =   &H000000FF&
      Caption         =   "Exit"
      Height          =   735
      Left            =   10920
      MaskColor       =   &H00E0E0E0&
      Style           =   1  'Graphical
      TabIndex        =   19
      Top             =   4200
      Width           =   1695
   End
   Begin VB.TextBox Txt_Gate_MagPass 
      Height          =   285
      Left            =   6600
      TabIndex        =   18
      Top             =   3240
      Width           =   1815
   End
   Begin VB.TextBox Txt_Gate_SC 
      Height          =   285
      Left            =   6600
      TabIndex        =   17
      Top             =   2760
      Width           =   1815
   End
   Begin VB.TextBox Txt_Gate_TOT 
      Height          =   285
      Left            =   6600
      TabIndex        =   16
      Top             =   2250
      Width           =   1815
   End
   Begin VB.TextBox Txt_FB_Cash 
      Height          =   285
      Left            =   2400
      TabIndex        =   15
      Top             =   3720
      Width           =   1815
   End
   Begin VB.TextBox Txt_FB_Magpass 
      Height          =   285
      Left            =   2400
      TabIndex        =   14
      Top             =   3240
      Width           =   1815
   End
   Begin VB.TextBox Txt_FB_SC 
      Height          =   285
      Left            =   2400
      TabIndex        =   13
      Top             =   2760
      Width           =   1815
   End
   Begin VB.TextBox Txt_FB_Tot 
      Height          =   285
      Left            =   2400
      TabIndex        =   12
      Top             =   2250
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_Get 
      Caption         =   "Get Summary Information"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5640
      TabIndex        =   4
      Top             =   720
      Width           =   2655
   End
   Begin VB.TextBox Txt_Month 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   3840
      TabIndex        =   3
      Top             =   840
      Width           =   1215
   End
   Begin VB.TextBox Txt_Year 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1440
      TabIndex        =   1
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "Grand Totals"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   9000
      TabIndex        =   20
      Top             =   1800
      Width           =   1935
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Gate Mag Pass"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   7
      Left            =   4800
      TabIndex        =   11
      Top             =   3270
      Width           =   1575
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Gate SmartCard"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   6
      Left            =   4800
      TabIndex        =   10
      Top             =   2790
      Width           =   1575
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Gate Total"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   5
      Left            =   4800
      TabIndex        =   9
      Top             =   2280
      Width           =   1575
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Farebox Cash"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   4
      Left            =   600
      TabIndex        =   8
      Top             =   3750
      Width           =   1575
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Farebox Mag Pass"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   3
      Left            =   120
      TabIndex        =   7
      Top             =   3270
      Width           =   2055
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Farebox Smartcard"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   6
      Top             =   2790
      Width           =   2055
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Farebox Total"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   1
      Left            =   480
      TabIndex        =   5
      Top             =   2280
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "Month"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   2880
      TabIndex        =   2
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Year"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   480
      TabIndex        =   0
      Top             =   840
      Width           =   1095
   End
End
Attribute VB_Name = "Frm_main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Fbox_total As Long
Dim Gate_total As Long
Dim Val_Total As Long
Dim sql_Summ As String
Dim sql_Pass As String
Dim sql_group As String
Dim sql_cash As String
Dim year As Long
Dim month As Long


Private Sub cmd_exit_Click()
    
    Unload Me
    
End Sub

Private Sub Cmd_Get_Click()
    
    year = CLng(Txt_Year.Text)
    month = CLng(Txt_Month.Text)
    
    
    
    sql_Summ = "select Year, month, SUM(Rider12am + Rider1am + Rider2am + Rider3am + Rider4am + Rider5am " & _
        "+ Rider6am + Rider7am + Rider8am + Rider9am + Rider10am + Rider11am + Rider12pm + Rider1pm " & _
        "+ Rider2pm + Rider3pm + Rider4pm + Rider5pm + Rider6pm + Rider7pm + Rider8pm + Rider9pm + Rider10pm " & _
        "+ Rider11pm) as Month_Sum "

    sql_group = " Group by year, Month"
    
    sql_Pass = " and stocktype <> 'Smart Card Mifare 1k' and stocktype <> '' and product <> 'SV Adult (MC)' " & _
    " and product <> 'SV Adult (SC)' and product <> 'SV Change Card Adult'"
    
    sql_cash = " and product like '%Cash%'"
    
' FBOX TOTAL
    sSql = sql_Summ & " from ridership_farebox where year = " & year & " and month = " & month & sql_group
Debug.Print sSql

    Set RSData = New ADODB.Recordset
    Set RSData = SQLData.Execute(sSql)
    Fbox_total = RSData("month_sum")
        
    Txt_FB_Tot.Text = Replace(Format(Fbox_total, "standard"), ".00", "")
    
' FBOX Smart Cards
     
    sSql = sql_Summ & " from ridership_farebox where year = " & year & " and month = " & month & _
    " and stocktype = 'Smart Card Mifare 1k'" & sql_group
    
    Set RSData = SQLData.Execute(sSql)
    Fbox_total = RSData("month_sum")
    
    Txt_FB_SC.Text = Replace(Format(Fbox_total, "standard"), ".00", "")
    
' FBOX Mag Passes
     
    sSql = sql_Summ & " from ridership_farebox where year = " & year & " and month = " & month & sql_Pass & sql_group
    
    Set RSData = SQLData.Execute(sSql)
    Fbox_total = RSData("month_sum")
    
    Txt_FB_Magpass.Text = Replace(Format(Fbox_total, "standard"), ".00", "")

' FBOX Mag cash
     
    sSql = sql_Summ & " from ridership_farebox where year = " & year & " and month = " & month & sql_cash & sql_group
    
    Set RSData = SQLData.Execute(sSql)
    Fbox_total = RSData("month_sum")
    
    Txt_FB_Cash.Text = Replace(Format(Fbox_total, "standard"), ".00", "")

    
'=============================================================================================================
   
' Gate TOTAL
    sSql = sql_Summ & " from ridership_gates where year = " & year & " and month = " & month & sql_group

    Set RSData = SQLData.Execute(sSql)
    Gate_total = RSData("month_sum")
    
    sSql = sql_Summ & " from ridership_validator where year = " & year & " and month = " & month & sql_group

    Set RSData = SQLData.Execute(sSql)
    Gate_total = Gate_total + RSData("month_sum")
      
    Txt_Gate_TOT.Text = Replace(Format(Gate_total, "standard"), ".00", "")
    
' FBOX Smart Cards
     
    sSql = sql_Summ & " from ridership_gates where year = " & year & " and month = " & month & _
    " and stocktype = 'Smart Card Mifare 1k'" & sql_group
    
    Set RSData = SQLData.Execute(sSql)
    Gate_total = RSData("month_sum")
    
    sSql = sql_Summ & " from ridership_validator where year = " & year & " and month = " & month & _
    " and stocktype = 'Smart Card Mifare 1k'" & sql_group
    
    Set RSData = SQLData.Execute(sSql)
    Gate_total = Gate_total + RSData("month_sum")
    
    Txt_Gate_SC.Text = Replace(Format(Gate_total, "standard"), ".00", "")
    
' FBOX Mag Passes
     
    sSql = sql_Summ & " from ridership_gates where year = " & year & " and month = " & month & sql_Pass & sql_group
    
    Set RSData = SQLData.Execute(sSql)
    Gate_total = RSData("month_sum")
    
    sSql = sql_Summ & " from ridership_validator where year = " & year & " and month = " & month & sql_Pass & sql_group
    
    Set RSData = SQLData.Execute(sSql)
    Gate_total = Gate_total + RSData("month_sum")

    Txt_Gate_MagPass.Text = Replace(Format(Gate_total, "standard"), ".00", "")
    
    RSData.Close
    Set RSData = Nothing
    
    
    Txt_Total = Replace(Format(CLng(Txt_FB_Tot.Text) + CLng(Txt_Gate_TOT.Text), "standard"), ".00", "")
    Txt_SC_Total = Replace(Format(CLng(Txt_FB_SC.Text) + CLng(Txt_Gate_SC.Text), "standard"), ".00", "")
    Txt_MagPass_Total = Replace(Format(CLng(Txt_FB_Magpass.Text) + CLng(Txt_Gate_MagPass.Text), "standard"), ".00", "")
    
End Sub
