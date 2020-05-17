VERSION 5.00
Begin VB.Form Frm_Export 
   Caption         =   "Export Production Batch cards to CSV File"
   ClientHeight    =   4200
   ClientLeft      =   1845
   ClientTop       =   1605
   ClientWidth     =   10725
   LinkTopic       =   "Form1"
   ScaleHeight     =   4200
   ScaleWidth      =   10725
   Begin VB.ComboBox Cbo_Device 
      Height          =   315
      ItemData        =   "Frm_Export.frx":0000
      Left            =   5880
      List            =   "Frm_Export.frx":0013
      TabIndex        =   13
      Top             =   1080
      Width           =   2415
   End
   Begin VB.CommandButton Cmd_Cal2 
      Caption         =   "Calendar"
      Height          =   255
      Left            =   7680
      TabIndex        =   10
      Top             =   1680
      Width           =   1215
   End
   Begin VB.TextBox Txt_Date2 
      BackColor       =   &H00C0FFFF&
      Height          =   285
      Left            =   6120
      Locked          =   -1  'True
      TabIndex        =   9
      Top             =   1650
      Width           =   1335
   End
   Begin VB.CommandButton Cmd_Cal1 
      Caption         =   "Calendar"
      Height          =   255
      Left            =   3960
      TabIndex        =   8
      Top             =   1680
      Width           =   1215
   End
   Begin VB.TextBox Txt_Date1 
      BackColor       =   &H00C0FFFF&
      Height          =   285
      Left            =   2400
      Locked          =   -1  'True
      TabIndex        =   7
      Top             =   1650
      Width           =   1335
   End
   Begin VB.TextBox Txt_Batch 
      Height          =   285
      Left            =   2400
      TabIndex        =   5
      Top             =   1110
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_Execute 
      Caption         =   "Export Cards"
      Height          =   615
      Left            =   9120
      TabIndex        =   3
      Top             =   2280
      Width           =   1335
   End
   Begin VB.CommandButton Cmd_Exit 
      BackColor       =   &H000000FF&
      Caption         =   "Exit"
      Height          =   615
      Left            =   9120
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   3120
      Width           =   1335
   End
   Begin VB.TextBox Txt_Filename 
      Height          =   285
      Left            =   2400
      TabIndex        =   1
      Top             =   480
      Width           =   3735
   End
   Begin VB.Label Label5 
      Caption         =   "Device #"
      Height          =   255
      Left            =   4800
      TabIndex        =   12
      Top             =   1140
      Width           =   975
   End
   Begin VB.Label Label4 
      Caption         =   "To"
      Height          =   255
      Left            =   5520
      TabIndex        =   11
      Top             =   1680
      Width           =   375
   End
   Begin VB.Label Label3 
      Caption         =   "Date Range of Batch"
      Height          =   255
      Left            =   480
      TabIndex        =   6
      Top             =   1680
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "Batch #"
      Height          =   255
      Left            =   480
      TabIndex        =   4
      Top             =   1140
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "School Name/ Town"
      Height          =   255
      Left            =   480
      TabIndex        =   0
      Top             =   510
      Width           =   1815
   End
End
Attribute VB_Name = "Frm_Export"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Cmd_Cal1_Click()
Dim passdate As String
    passdate = Format(Today, "mm/dd/yyyy")
    
    St_Date = Calendar_date(passdate)
    Txt_Date1.Text = St_Date
    
    
End Sub

Private Sub Cmd_Execute_Click()
Dim DeviceType As String
Dim cmd As ADODB.Command
Dim stdate As String
Dim EndDate As String
Dim sFileText As String
Dim iFileNo As Integer

    If Txt_Filename.Text = "" Then
        MsgBox ("Your School name is blank this can not be."), vbOKOnly
        Exit Sub
    End If
    
    If Txt_Batch.Text = "" Then
        MsgBox ("Your batch # is blank this can not be."), vbOKOnly
        Exit Sub
    End If
    
    
    If St_Date > End_Date Then
        MsgBox ("Your starting date can not be newer than your ending date"), vbOKOnly
        Exit Sub
    End If
    
    If Cbo_Device.ItemData(Cbo_Device.ListIndex) = -1 Then
        MsgBox ("You must select a device where the production occured"), vbOKOnly
        Exit Sub
    End If
    
    DeviceType = Mid(Cbo_Device.Text, 1, 4)
    
    
' oradata is pointing to the reporting instance 172.17.0.52
' I created a new SP called _ken and removed the time as part of the date criteria

    Set cmd = New ADODB.Command
    cmd.ActiveConnection = ORAdata
    cmd.CommandType = adCmdStoredProc
    cmd.CommandText = "sp_jce_2005_ken"

    cmd.Parameters.Append cmd.CreateParameter("P_QueryID", adInteger, adParamInput, , 401)
    cmd.Parameters.Append cmd.CreateParameter("P_AgentCreated", adVarChar, adParamInput, 128, "All")
    cmd.Parameters.Append cmd.CreateParameter("P_AgentExecuted", adVarChar, adParamInput, 128, "All")
    cmd.Parameters.Append cmd.CreateParameter("P_DeviceClass", adVarChar, adParamInput, 128, DeviceType)
    cmd.Parameters.Append cmd.CreateParameter("P_DeviceGroupID", adVarChar, adParamInput, 128, "All")
    cmd.Parameters.Append cmd.CreateParameter("P_DeviceID", adVarChar, adParamInput, 128, Cbo_Device.Text)
    cmd.Parameters.Append cmd.CreateParameter("P_ProductionType", adVarChar, adParamInput, 128, "All")
    cmd.Parameters.Append cmd.CreateParameter("P_ProductionJob", adVarChar, adParamInput, 128, Trim(Txt_Batch.Text))
    cmd.Parameters.Append cmd.CreateParameter("P_MediaType", adVarChar, adParamInput, 128, "All")
    cmd.Parameters.Append cmd.CreateParameter("P_DateFirst", adDBDate, adParamInput, 24, St_Date)
    cmd.Parameters.Append cmd.CreateParameter("P_DateLast", adDBDate, adParamInput, 24, End_Date)
    cmd.Parameters.Append cmd.CreateParameter("P_DateFilter", adVarChar, adParamInput, 10, "1=1")
    cmd.Parameters.Append cmd.CreateParameter("P_Details", adInteger, adParamInput, , 2)

    cmd.Execute
    
    sSql = "SELECT * FROM tempQueryResult"
    
    Set RSWork = New ADODB.Recordset
    Set RSWork = ORAdata.Execute(sSql)
    If RSWork.EOF = True Then
        MsgBox ("There are no cards to export for this batch"), vbOKOnly
        Close RSWork
        Set RSWork = Nothing
        Exit Sub
    End If
    Do While RSWork.EOF = False
        

    iFileNo = FreeFile
    'open the file for writing
    sFileText = "X:\tokens" & Now & ".txt"
    sFileText = Replace(sFileText, ":", "-")
    sFileText = Replace(sFileText, "/", "-")
    sFileText = Replace(sFileText, "X-", "X:")
    Open sFileText For Output As #iFileNo

    sSql = "select tvmid, al_location_name, tokencountprior, tokencountcurrent from fullservicetokens left outer join afc_unittable on au_mbtano = vartvmid " & _
    "left outer join afc_location on au_location = al_id where tokencountcurrent - tokencountprior > 5"
    
    Set RS_Work = New ADODB.Recordset
    Set RS_Work = SQLData.Execute(sSql)
    
    Do While RS_Work.EOF = False
        Print #iFileNo, RS_Work("tvmid") & "  " & RS_Work("al_location_name") & "  " & RS_Work("tokencountcurrent") - RS_Work("tokencountprior") & vbCrLf
        RS_Work.MoveNext
    Loop
    
    Close #iFileNo
End Sub
   
        RSWork.MoveNext
    Loop

End Sub

Private Sub Cmd_Exit_Click()
    Unload Me
End Sub

Private Sub Cmd_Cal2_Click()
Dim passdate As String
    passdate = St_Date
    
    End_Date = Calendar_date(passdate)
    If St_Date > End_Date Then
        MsgBox ("Your starting date can not be newer than your ending date"), vbOKOnly
    End If
    Txt_Date2.Text = End_Date

End Sub

Private Sub Dir1_Change()

End Sub
