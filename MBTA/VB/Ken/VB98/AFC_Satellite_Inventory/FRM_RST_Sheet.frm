VERSION 5.00
Begin VB.Form FRM_RST_Sheet 
   Caption         =   "RST Excel Spread sheet"
   ClientHeight    =   2985
   ClientLeft      =   3660
   ClientTop       =   1965
   ClientWidth     =   8070
   LinkTopic       =   "Form1"
   ScaleHeight     =   2985
   ScaleWidth      =   8070
   Begin VB.TextBox Txt_proc 
      BackColor       =   &H00C0C0FF&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   360
      Locked          =   -1  'True
      TabIndex        =   7
      Text            =   "Process Complete"
      Top             =   2400
      Width           =   6015
   End
   Begin VB.CommandButton Cmd_Process 
      Caption         =   "Process List"
      Height          =   615
      Left            =   6600
      TabIndex        =   6
      Top             =   2160
      Width           =   1335
   End
   Begin VB.CommandButton Cmd_Cal 
      Caption         =   "Calendar"
      Height          =   495
      Left            =   3840
      TabIndex        =   5
      Top             =   1680
      Width           =   1095
   End
   Begin VB.TextBox Txt_RST_Date 
      BackColor       =   &H00C0FFFF&
      Height          =   285
      Left            =   1800
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   1800
      Width           =   1575
   End
   Begin VB.Frame Frame1 
      Caption         =   "Maintenance area"
      Height          =   975
      Left            =   360
      TabIndex        =   0
      Top             =   480
      Width           =   4095
      Begin VB.OptionButton Opt_Subway 
         Caption         =   "SubWay"
         Height          =   255
         Left            =   1920
         TabIndex        =   2
         Top             =   360
         Width           =   1455
      End
      Begin VB.OptionButton Opt_Farebox 
         Caption         =   "FareBox"
         Height          =   255
         Left            =   600
         TabIndex        =   1
         Top             =   360
         Width           =   1695
      End
   End
   Begin VB.Label Label1 
      Caption         =   "Date Of Entries"
      Height          =   255
      Left            =   480
      TabIndex        =   3
      Top             =   1800
      Width           =   1215
   End
End
Attribute VB_Name = "FRM_RST_Sheet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim branch As Long
Dim xlApp As Excel.Application
Dim xlBook As Excel.Workbook
Dim xlSheet As Excel.Worksheet
Dim File As String
    

Private Sub Cmd_Cal_Click()
    Txt_RST_Date.Text = Calendar_date(Txt_RST_Date.Text)
End Sub

Private Sub Cmd_Process_Click()
Dim File As String

    If Opt_Farebox = True Then
        branch = 3
        File = "C:\RST_Extract_Farebox_" & Replace(Txt_RST_Date.Text, "/", "-")
    ElseIf Opt_Subway = True Then
        branch = 2
        File = "C:\RST_Extract_SubWay_" & Replace(Txt_RST_Date.Text, "/", "-")
    Else
        MsgBox ("You have to select a maintenance area"), vbOKOnly
        Exit Sub
    End If
    If Txt_RST_Date.Text = "" Then
        MsgBox ("A date must be selected.  This extracts all incidents created on the selected date"), vbOKOnly
        Exit Sub
    End If
    
    sSql = "exec RST_query '" & Format(Txt_RST_Date.Text, "mm/dd/yyyy") & "'," & branch
    
    Call Get_Trans("Read")
    If RS_Trans.EOF = True Then
        MsgBox ("File has already been generated")
    End If
    
    Call Build_Spread_Sheet
    Txt_proc.Text = "Process Complete " & File
    Txt_proc.Visible = True
    Cmd_Process.Visible = False
End Sub
Public Sub Build_Spread_Sheet()

    If Dir(File) <> "" Then
        Kill File
    End If

    Call Build_Excel_Header

    Screen.MousePointer = vbHourglass
    Call Load_Sheet
'file = "shit"
    xlApp.ActiveWorkbook.SaveAs FileName:=File, _
            FileFormat:=xlNormal, _
            Password:="", _
            WriteResPassword:="", _
            ReadOnlyRecommended:=False, _
            CreateBackup:=False
    xlApp.Quit
    Set xlApp = Nothing
    
    Screen.MousePointer = vbDefault

'    update sent status to S&B
    RS_Trans.MoveFirst
    Do While RS_Trans.EOF = False
        sSql = "Update incident set I_Sent_closed_Stat = 'Y' where i_id = " & RS_Trans("I_ID")
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    
    Call Get_Trans("Close")
    
End Sub

Public Sub Build_Excel_Header()
    Screen.MousePointer = vbHourglass
    DoEvents


   'Start a new workbook in Excel
   'Set OExcel = CreateObject("Excel.Application")
   'Set OBook = OExcel.Workbooks.Add


   'Add data to cells of the first worksheet in the new workbook
   'Set OSheet = OBook.Worksheets(1)

   'Save the Workbook and Quit Excel
    ' Create the Excel application.
    sSql = "Insert into stuff (s_sql) values('before create')"
    SQLData.Execute (sSql)
    Set xlApp = CreateObject("Excel.Application")
    Set xlBook = xlApp.Workbooks.Add
    Set xlSheet = xlBook.Worksheets(1)
    sSql = "Insert into stuff (s_sql) values('after Sheet')"
    SQLData.Execute (sSql)

    ' Uncomment this line to make Excel visible.
   xlApp.Visible = False
    ' Create a new spreadsheet.

    ' Insert data into Excel.
    
    With xlSheet 'excel_app

        .Columns("A:A").ColumnWidth = 15
        .Cells(2, 1).Value = "Incident#"
        .Cells.ColumnWidth = 10
        
        .Columns("B:B").ColumnWidth = 15
        .Cells(2, 2).HorizontalAlignment = xlCenter
        .Cells(2, 2).Value = "Device #"
        
        .Columns("C:C").ColumnWidth = 20
        .Cells(2, 3).HorizontalAlignment = xlCenter
        .Cells(2, 3).Value = "Device Type"
        .Cells(2, 3).WrapText = True
        
        .Columns("D:D").ColumnWidth = 20
        .Cells(2, 4).HorizontalAlignment = xlCenter
        .Cells(2, 4).Value = "I-Pol#"
        .Cells(2, 4).WrapText = True
        
        .Columns("E:E").ColumnWidth = 20
        .Cells(2, 5).HorizontalAlignment = xlCenter
        .Cells(2, 5).Value = "Station"
        .Cells(2, 5).WrapText = True
        
        .Columns("F:F").ColumnWidth = 20
        .Columns("F:F").HorizontalAlignment = xlCenter
        .Cells(2, 6).Value = "Reported Description of Problem"
        .Cells(2, 6).WrapText = True
    
        .Columns("G:G").ColumnWidth = 20
        .Columns("G:G").HorizontalAlignment = xlCenter
        .Cells(2, 7).Value = "Original Description of Problem"
        .Cells(2, 7).WrapText = True
        
        .Columns("H:H").ColumnWidth = 20
        .Columns("H:H").HorizontalAlignment = xlCenter
        .Cells(2, 8).Value = "Defect Description"
        .Cells(2, 8).WrapText = True
        
        .Columns("I:I").ColumnWidth = 20
        .Columns("I:I").HorizontalAlignment = xlCenter
        .Cells(2, 9).Value = "Action Taken"
        .Cells(2, 9).WrapText = True
        
        .Columns("J:J").ColumnWidth = 20
        .Columns("J:J").HorizontalAlignment = xlCenter
        .Cells(2, 10).Value = "Error Codes from Simm"
        .Cells(2, 10).WrapText = True
        
        .Columns("K:K").ColumnWidth = 12
        .Columns("K:K").HorizontalAlignment = xlCenter
        .Columns("K:K").WrapText = True
        .Cells(2, 11).Value = "Incident Created"
        
        .Columns("L:L").ColumnWidth = 12
        .Columns("L:L").HorizontalAlignment = xlCenter
        .Columns("L:L").WrapText = True
        .Cells(2, 12).Value = "Work Started"
        
        .Columns("M:M").ColumnWidth = 12
        .Columns("M:M").HorizontalAlignment = xlCenter
        .Columns("M:M").WrapText = True
        .Cells(2, 13).Value = "Work Finished"
        
        .Columns("N:N").ColumnWidth = 12
        .Columns("N:N").HorizontalAlignment = xlCenter
        .Cells(2, 14).Value = "Incident Closed"
        .Cells(2, 14).WrapText = True
        
        .Columns("O:O").ColumnWidth = 15
        .Columns("O:O").HorizontalAlignment = xlCenter
        .Cells(2, 15).Value = "Technician"
    
        .Columns("P:P").ColumnWidth = 15
        .Columns("P:P").HorizontalAlignment = xlCenter
        .Cells(2, 16).Value = "Jam Type"
        .Cells(2, 16).WrapText = True
    
        .Columns("Q:Q").ColumnWidth = 30
        .Columns("Q:Q").HorizontalAlignment = xlCenter
        .Columns("Q:Q").WrapText = True
        .Cells(2, 17).Value = "Jam Location"
        
        .Columns("R:R").ColumnWidth = 20
        .Columns("R:R").HorizontalAlignment = xlCenter
        .Cells(2, 18).Value = "Item Condition"
        .Cells(2, 17).WrapText = True

        .Columns("S:S").ColumnWidth = 10
        .Columns("S:S").HorizontalAlignment = xlCenter
        .Cells(2, 19).Value = "Jam Reason"
        .Cells(2, 19).WrapText = True


        If branch = 3 Then
            .Columns("T:T").ColumnWidth = 16
            .Columns("T:T").HorizontalAlignment = xlCenter
            .Cells(2, 20).Value = "OCU_Color"
            .Cells(2, 20).WrapText = True
            
            .Columns("U:U").ColumnWidth = 10
            .Columns("U:U").HorizontalAlignment = xlCenter
            .Cells(2, 21).Value = "SC-Reader Light"
            .Cells(2, 21).WrapText = True
            
            .Columns("V:V").ColumnWidth = 10
            .Columns("V:V").HorizontalAlignment = xlCenter
            .Cells(2, 22).Value = "Reading Cards?"
            .Cells(2, 22).WrapText = True
            
            .Columns("W:W").ColumnWidth = 10
            .Columns("W:W").HorizontalAlignment = xlCenter
            .Cells(2, 23).Value = "Value Added"
            .Cells(2, 23).WrapText = True
            
            .Columns("Y:Y").ColumnWidth = 10
            .Columns("Y:Y").HorizontalAlignment = xlCenter
            .Cells(2, 24).Value = "Change Ticket Issued"
            .Cells(2, 24).WrapText = True
            
            .Columns("Z:Z").ColumnWidth = 40
            .Columns("Z:Z").HorizontalAlignment = xlLeft
            .Cells(2, 25).Value = "Tech Notes"
            .Cells(2, 25).WrapText = True
            
            .Columns("AA:AA").ColumnWidth = 40
            .Columns("AA:AA").HorizontalAlignment = xlLeft
            .Cells(2, 26).Value = "I-pol Reported prob"
            .Cells(2, 26).WrapText = True
            
            .Columns("AB:AB").ColumnWidth = 40
            .Columns("AB:AB").HorizontalAlignment = xlLeft
            .Cells(2, 27).Value = "I-Pol Narrative"
            .Cells(2, 27).WrapText = True
        
        Else
            .Columns("T:T").ColumnWidth = 40
            .Columns("T:T").HorizontalAlignment = xlLeft
            .Cells(2, 20).Value = "Tech Notes"
            .Cells(2, 20).WrapText = True
            
            .Columns("U:U").ColumnWidth = 40
            .Columns("U:U").HorizontalAlignment = xlLeft
            .Cells(2, 21).Value = "I-pol Reported prob"
            .Cells(2, 21).WrapText = True
            
            .Columns("V:V").ColumnWidth = 40
            .Columns("V:V").HorizontalAlignment = xlLeft
            .Cells(2, 22).Value = "I-Pol Narrative"
            .Cells(2, 22).WrapText = True

        End If
    End With
    
End Sub

Public Sub Load_Sheet()
Dim row As Long
Dim count As Long
    row = 3
    Do While Not RS_Trans.EOF
    
        With xlSheet 'excel_app
       
            .Cells(row, 1).Value = RS_Trans("I_Incidentno")
            
            .Cells(row, 2).Value = RS_Trans("au_mbtano")
            
            .Cells(row, 3).Value = RS_Trans("ai_Description")
            
            .Cells(row, 4).Value = RS_Trans("I_Ipol")
            .Cells(row, 5).Value = RS_Trans("al_location_name")
            
            .Cells(row, 6).Value = RS_Trans("I_orig_STATUS")
            .Cells(row, 7).Value = RS_Trans("Iorig_description")
            .Cells(row, 8).Value = RS_Trans("IDef_description")
            .Cells(row, 9).Value = RS_Trans("IAct_description")
            .Cells(row, 10).Value = RS_Trans("I_error_Codes")
            .Cells(row, 11).Value = "'" & RS_Trans("I_DT_Reported")
            .Cells(row, 12).Value = "'" & RS_Trans("I_Start_work")
            .Cells(row, 13).Value = "'" & RS_Trans("I_Finish_Work")
            .Cells(row, 14).Value = "'" & RS_Trans("I_DT_Closed")
            .Cells(row, 15).Value = Trim(RS_Trans("at_empfname")) & " " & Trim(RS_Trans("at_Emplname"))
            count = 0
            If RS_Trans("ibj_id") <> 0 Then
                .Cells(row, 16).Value = "Bill Jam"
                .Cells(row, 17).Value = RS_Trans("Bill_Jam_Location")
                .Cells(row, 18).Value = RS_Trans("Bill_Jam_Condition")
                .Cells(row, 19).Value = "Belt Off(" & RS_Trans("Belts_Off") & ")"
                If branch = 3 Then
                    .Cells(row, 20).Value = "OCU Color (" & RS_Trans("Bill_OCUcolor") & ")"
                    .Cells(row, 21).Value = RS_Trans("IC_Comment")
                    .Cells(row, 26).Value = RS_Trans("PROBLEMREPORTED")
                    .Cells(row, 27).Value = RS_Trans("repairnarrative")
                Else
                    .Cells(row, 20).Value = RS_Trans("IC_Comment")
                End If
                count = count + 1
            End If
            
            If RS_Trans("itj_id") <> 0 Then
                If Trim(RS_Trans("Gate_Ticket_Jam")) = "" Then
                    .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                    .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                    .Cells(row + count, 16).Value = "Ticket Jam FVM"
                    .Cells(row + count, 17).Value = RS_Trans("FVM_Ticket_Jam")
                    .Cells(row + count, 18).Value = RS_Trans("Ticket_Jam_Condition")
                    .Cells(row + count, 19).Value = ""
                    If branch = 3 Then
                        .Cells(row, 25).Value = RS_Trans("IC_Comment")
                        .Cells(row, 26).Value = RS_Trans("PROBLEMREPORTED")
                        .Cells(row, 27).Value = RS_Trans("repairnarrative")
                    Else
                        .Cells(row, 20).Value = RS_Trans("IC_Comment")
                    End If
                
                Else
                    .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                    .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                    .Cells(row + count, 16).Value = "Ticket Jam Gate"
                    .Cells(row + count, 17).Value = RS_Trans("Gate_Ticket_Jam")
                    .Cells(row + count, 18).Value = RS_Trans("Ticket_Jam_condition")
                    .Cells(row + count, 19).Value = ""
                    
                    If branch = 3 Then
                        .Cells(row + count, 20).Value = "OCU Color (" & RS_Trans("Ticket_OCUcolor") & ")"
                        .Cells(row, 25).Value = RS_Trans("IC_Comment")
                        .Cells(row, 26).Value = RS_Trans("PROBLEMREPORTED")
                        .Cells(row, 27).Value = RS_Trans("repairnarrative")
                    Else
                        .Cells(row, 20).Value = RS_Trans("IC_Comment")
                    End If

                    count = count + 1
                End If
            End If
            
            If RS_Trans("icj_id") <> 0 Then
                .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                .Cells(row + count, 16).Value = "Coin Jam"
                .Cells(row + count, 17).Value = RS_Trans("Coin_Jam")
                If Trim(RS_Trans("coin_jam")) = "Other" Then
                    .Cells(row + count, 17).Value = RS_Trans("ICJ_Loc_Other")
                End If
                
                .Cells(row + count, 18).Value = RS_Trans("Coin_Jam_Reason")
                If Trim(RS_Trans("coin_jam_reason")) = "Other" Then
                    .Cells(row + count, 18).Value = RS_Trans("ICJ_Res_Other")
                End If
                .Cells(row + count, 19).Value = ""
                If count = 0 Then .Cells(row, 20).Value = RS_Trans("IC_Comment")

                If branch = 3 Then
                    .Cells(row + count, 20).Value = "OCU Color (" & RS_Trans("Coin_OCUcolor") & ")"
                    .Cells(row, 25).Value = RS_Trans("IC_Comment")
                    .Cells(row, 26).Value = RS_Trans("PROBLEMREPORTED")
                    .Cells(row, 27).Value = RS_Trans("repairnarrative")
                Else
                    .Cells(row, 20).Value = RS_Trans("IC_Comment")
                End If
                count = count + 1
            End If
            
            If RS_Trans("io_id") <> 0 Then
                .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                .Cells(row + count, 16).Value = "Other Issue"
                .Cells(row + count, 17).Value = RS_Trans("Io_other")
                If branch = 3 Then
                    .Cells(row, 25).Value = RS_Trans("IC_Comment")
                    .Cells(row, 26).Value = RS_Trans("PROBLEMREPORTED")
                    .Cells(row, 27).Value = RS_Trans("repairnarrative")
                Else
                    If count = 0 Then .Cells(row, 20).Value = RS_Trans("IC_Comment")
                End If


            End If
            If RS_Trans("Isc_ID") <> 0 Then
                .Cells(row, 21).Value = RS_Trans("isc_ocucolor")
                .Cells(row, 22).Value = RS_Trans("isc_Reader")
                .Cells(row, 23).Value = RS_Trans("isc_Value")
                .Cells(row, 24).Value = RS_Trans("isc_chticket")
                .Cells(row, 25).Value = RS_Trans("IC_Comment")
                .Cells(row, 26).Value = RS_Trans("PROBLEMREPORTED")
                .Cells(row, 27).Value = RS_Trans("repairnarrative")

            End If
            If branch = 3 Then
                .Cells(row, 26).Value = RS_Trans("PROBLEMREPORTED")
                .Cells(row, 27).Value = RS_Trans("repairnarrative")
            End If
        End With

        row = (row + count + 1)

Next_Record:
        RS_Trans.MoveNext
    Loop
    
End Sub

Private Sub Form_Load()
    Txt_proc.Visible = False

End Sub
