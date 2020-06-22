VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7995
   ClientLeft      =   1455
   ClientTop       =   1515
   ClientWidth     =   6585
   LinkTopic       =   "Form1"
   ScaleHeight     =   7995
   ScaleWidth      =   6585
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   2280
      TabIndex        =   25
      Top             =   4920
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   4200
      TabIndex        =   24
      Top             =   6600
      Width           =   1695
   End
   Begin VB.TextBox Txt_tot 
      Height          =   285
      Left            =   4080
      TabIndex        =   23
      Top             =   4920
      Width           =   2055
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   13
      Left            =   2640
      TabIndex        =   20
      Top             =   4080
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   12
      Left            =   2640
      TabIndex        =   19
      Top             =   3600
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   11
      Left            =   2640
      TabIndex        =   18
      Top             =   3120
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   10
      Left            =   2640
      TabIndex        =   17
      Top             =   2640
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   9
      Left            =   2640
      TabIndex        =   16
      Top             =   2160
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   8
      Left            =   2640
      TabIndex        =   15
      Top             =   1800
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   7
      Left            =   2640
      TabIndex        =   14
      Top             =   1200
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   6
      Left            =   1200
      TabIndex        =   13
      Top             =   4080
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   5
      Left            =   1200
      TabIndex        =   12
      Top             =   3600
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   4
      Left            =   1200
      TabIndex        =   11
      Top             =   3120
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   3
      Left            =   1200
      TabIndex        =   10
      Top             =   2640
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   2
      Left            =   1200
      TabIndex        =   9
      Top             =   2160
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   1
      Left            =   1200
      TabIndex        =   8
      Top             =   1680
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   0
      Left            =   1200
      TabIndex        =   7
      Top             =   1200
      Width           =   1095
   End
   Begin VB.Label Label3 
      Caption         =   "Renewals"
      Height          =   255
      Left            =   2640
      TabIndex        =   22
      Top             =   840
      Width           =   975
   End
   Begin VB.Label Label2 
      Caption         =   "Card Count"
      Height          =   255
      Left            =   1320
      TabIndex        =   21
      Top             =   840
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Aug"
      Height          =   255
      Index           =   6
      Left            =   120
      TabIndex        =   6
      Top             =   4080
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "Jul"
      Height          =   255
      Index           =   5
      Left            =   120
      TabIndex        =   5
      Top             =   3600
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "Jun"
      Height          =   255
      Index           =   4
      Left            =   120
      TabIndex        =   4
      Top             =   3120
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "May"
      Height          =   255
      Index           =   3
      Left            =   120
      TabIndex        =   3
      Top             =   2640
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "Apr"
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   2
      Top             =   2160
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "Mar"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   1
      Top             =   1680
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "Feb"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   1200
      Width           =   855
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
Dim Feb_count As Long
Dim Feb_renew As Long
Dim Mar_count As Long
Dim Mar_renew As Long
Dim Apr_count As Long
Dim Apr_renew As Long
Dim May_count As Long
Dim May_renew As Long
Dim Jun_count As Long
Dim Jun_renew As Long
Dim Jul_count As Long
Dim Jul_renew As Long
Dim Aug_count As Long
Dim Aug_renew As Long
Dim Counter As Long

Dim ORAData As ADODB.Connection
Dim SalesData As ADODB.Recordset
Dim Mine As Long
Dim grand_total As Long
Dim sconn As String
Dim the_date As String
Dim count As Long
    
    Set RS_Work = New ADODB.Recordset
    
    Set ORAData = New ADODB.Connection
    ORAData.Open "dsn=mbta_oracle", "mbta", "hallo"

      RS_Work.CursorLocation = adUseClient
      RS_Work.CursorType = adOpenKeyset
      RS_Work.LockType = adLockBatchOptimistic

      sconn = "DRIVER=Microsoft Excel Driver (*.xls);" & "DBQ=" & "C:\RemovedFromAccount since inception to 8-13.xls"
      RS_Work.Open "SELECT * FROM [removedfromaccount$]", sconn
fix_err:
      Debug.Print Err.Description + " " + _
                  Err.Source, vbCritical, "Import"
      Err.Clear


    Set SalesData = New ADODB.Recordset

    Do While RS_Work.EOF = False
    Select Case RS_Work("Month")
    Case 1
        the_date = "01-feb-2007"
    Case 2
        the_date = "01-mar-2007"
    Case 3
        the_date = "01-apr-2007"
    Case 4
        the_date = "01-may-2007"
    Case 5
        the_date = "01-jun-2007"
    Case 6
        the_date = "01-jul-2007"
    Case 7
        the_date = "01-aug-2007"
    End Select
    
    sSql = "sELECT Count(deviceid)as count FROM misccardmovement " & _
    " where serialnumber =" & RS_Work("serial number") & " AND movementtype = 15 AND timenew >= '" & the_date & "' and partitioningdate >= '" & the_date & "'"
        Debug.Print sSql
        'sSql = "select count(deviceid) as count from salesdetail where ticketserialno = " & RS_Work("serial number") & _
        '" and creadate >= '" & the_date & "' and branchlineid=0 and businessid=0 and salespackcount = 0"
        Set SalesData = ORAData.Execute(sSql)
        If SalesData("count") > 0 Then
            Select Case RS_Work("Month")
            Case 1
            Feb_count = Feb_count + 1
            Feb_renew = Feb_renew + SalesData("Count")
            Case 2
            Mar_count = Mar_count + 1
            Mar_renew = Mar_renew + SalesData("Count")
            Case 3
            Apr_count = Apr_count + 1
            Apr_renew = Apr_renew + SalesData("Count")
            Case 4
            May_count = May_count + 1
            May_renew = May_renew + SalesData("Count")
            Case 5
            Jun_count = Jun_count + 1
            Jun_renew = Jun_renew + SalesData("Count")
            Case 6
            Jul_count = Jul_count + 1
            Jul_renew = Jul_renew + SalesData("Count")
            Case 7
            Aug_count = Aug_count + 1
            Aug_renew = Aug_renew + SalesData("Count")
            End Select
            
            grand_total = grand_total + SalesData("count")
        End If
        count = count + 1

        'SalesData.Close
        'Set SalesData = Nothing
        If count = 100 Then
            Counter = Counter + count
            Text1(0).Text = Feb_count
            Text1(7).Text = Feb_renew
            Text1(1).Text = Mar_count
            Text1(8).Text = Mar_renew
            Text1(2).Text = Apr_count
            Text1(9).Text = Apr_renew
            Text1(3).Text = May_count
            Text1(10).Text = May_renew
            Text1(4).Text = Jun_count
            Text1(11).Text = Jun_renew
            Text1(5).Text = Jul_count
            Text1(12).Text = Jul_renew
            Text1(6).Text = Aug_count
            Text1(13).Text = Aug_renew
            Txt_tot.Text = grand_total
            Text2.Text = Counter
            count = 0
            DoEvents
        End If
    
        RS_Work.MoveNext
    Loop
    RS_Work.Close
    Set rswork = Nothing

End Sub

