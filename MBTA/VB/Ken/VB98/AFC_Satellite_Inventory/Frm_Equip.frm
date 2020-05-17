VERSION 5.00
Begin VB.Form Frm_Equip 
   Caption         =   "Detailed Equipment Report"
   ClientHeight    =   6405
   ClientLeft      =   780
   ClientTop       =   1845
   ClientWidth     =   11745
   LinkTopic       =   "Form1"
   ScaleHeight     =   6405
   ScaleWidth      =   11745
   Begin VB.CommandButton Cmd_Process 
      Caption         =   "Process Report"
      Height          =   495
      Left            =   9600
      TabIndex        =   19
      Top             =   5040
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_ResetScr 
      BackColor       =   &H000000FF&
      Caption         =   "Reset Entry Screen"
      Height          =   495
      Left            =   9600
      MaskColor       =   &H00E0E0E0&
      Style           =   1  'Graphical
      TabIndex        =   18
      Top             =   4080
      Width           =   1815
   End
   Begin VB.TextBox Txt_Sort 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   720
      Locked          =   -1  'True
      TabIndex        =   15
      Top             =   4440
      Width           =   4695
   End
   Begin VB.CommandButton Cmd_Res_Sort 
      Caption         =   "Reset Sort"
      Height          =   375
      Left            =   5640
      TabIndex        =   14
      Top             =   4440
      Width           =   1815
   End
   Begin VB.ListBox Lst_Sort 
      Height          =   645
      ItemData        =   "Frm_Equip.frx":0000
      Left            =   2400
      List            =   "Frm_Equip.frx":0010
      MultiSelect     =   2  'Extended
      TabIndex        =   12
      Top             =   3120
      Width           =   3495
   End
   Begin VB.ComboBox Cbo_Group 
      Height          =   315
      ItemData        =   "Frm_Equip.frx":0046
      Left            =   7680
      List            =   "Frm_Equip.frx":0056
      TabIndex        =   10
      Top             =   3240
      Width           =   3495
   End
   Begin VB.Frame Frame2 
      Caption         =   "Line/Station Options"
      Height          =   1455
      Left            =   240
      TabIndex        =   3
      Top             =   1440
      Width           =   10935
      Begin VB.ListBox Lst_Lines 
         Height          =   840
         ItemData        =   "Frm_Equip.frx":0088
         Left            =   1320
         List            =   "Frm_Equip.frx":008A
         MultiSelect     =   2  'Extended
         TabIndex        =   6
         Top             =   360
         Width           =   1815
      End
      Begin VB.ListBox Lst_Stations 
         Height          =   840
         ItemData        =   "Frm_Equip.frx":008C
         Left            =   4560
         List            =   "Frm_Equip.frx":008E
         MultiSelect     =   2  'Extended
         TabIndex        =   5
         Top             =   360
         Width           =   2415
      End
      Begin VB.ComboBox Cbo_MaintSec 
         Height          =   315
         ItemData        =   "Frm_Equip.frx":0090
         Left            =   8400
         List            =   "Frm_Equip.frx":00C6
         TabIndex        =   4
         Top             =   600
         Width           =   2175
      End
      Begin VB.Label Label9 
         Alignment       =   2  'Center
         Caption         =   "Subway Line (Multi)"
         Height          =   495
         Left            =   240
         TabIndex        =   9
         Top             =   480
         Width           =   975
      End
      Begin VB.Label Label10 
         Alignment       =   2  'Center
         Caption         =   "OR Stations/Garage (Multi)"
         Height          =   735
         Left            =   3240
         TabIndex        =   8
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label Label7 
         Alignment       =   2  'Center
         Caption         =   "OR Service-Area "
         Height          =   495
         Left            =   7200
         TabIndex        =   7
         Top             =   480
         Width           =   1095
      End
   End
   Begin VB.ListBox Lst_Item_Types 
      Height          =   840
      ItemData        =   "Frm_Equip.frx":016C
      Left            =   3600
      List            =   "Frm_Equip.frx":016E
      MultiSelect     =   2  'Extended
      TabIndex        =   1
      Top             =   360
      Width           =   2415
   End
   Begin VB.CheckBox Chk_Rst 
      Alignment       =   1  'Right Justify
      Caption         =   "RST Devices Only"
      Height          =   255
      Left            =   6480
      TabIndex        =   0
      Top             =   600
      Width           =   1815
   End
   Begin VB.Label Label19 
      Caption         =   "Pick up to 2 sort parameters.  "
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   720
      TabIndex        =   17
      Top             =   4200
      Width           =   3495
   End
   Begin VB.Label Label20 
      Caption         =   "(Default is Date Reported/Location Name"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   720
      TabIndex        =   16
      Top             =   3960
      Width           =   3495
   End
   Begin VB.Label Label18 
      Caption         =   "Sort Options"
      Height          =   255
      Left            =   720
      TabIndex        =   13
      Top             =   3240
      Width           =   1215
   End
   Begin VB.Label Label17 
      Caption         =   "Report Grouping for counts"
      Height          =   495
      Left            =   6240
      TabIndex        =   11
      Top             =   3240
      Width           =   1335
   End
   Begin VB.Label Label8 
      Alignment       =   2  'Center
      Caption         =   "Device-Type (Multi)"
      Height          =   495
      Left            =   2400
      TabIndex        =   2
      Top             =   480
      Width           =   975
   End
End
Attribute VB_Name = "Frm_Equip"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim step As Long
Dim index As Long
Private Sub Cmd_Process_Click()
    
    Device_String = " "
    Rpt_Rst = " "
    Subway = " "
    'Rpt_Sort1 = 0
    
    Rpt_Text1 = "Devices: "
    Device_String = "ai_unit_type in (0"
    For index = 0 To Lst_Item_Types.ListCount - 1
        If Lst_Item_Types.Selected(index) = True And Lst_Item_Types.ItemData(index) <> 0 Then
            Device_String = Trim(Device_String) & "," & Lst_Item_Types.ItemData(index)
            Rpt_Text1 = Rpt_Text1 & Lst_Item_Types.List(index) & " "
        End If
    Next
    Device_String = Trim(Device_String) & ")"
    
    If Device_String = "ai_unit_type in (0)" Then Device_String = " "
    Device_String = Replace(Device_String, "(0,", "(")
    Rpt_Rst = ""
    If Chk_Rst.Value = 1 Then
        Rpt_Text1 = Rpt_Text1 & " RST Only"
        Rpt_Rst = "Y"
    End If

' set up the where clause for the Equipment locations
    Rpt_Text2 = "Location: "
    Subway = "al_line in (0"
    For index = 0 To Lst_Lines.ListCount - 1
        If Lst_Lines.Selected(index) = True And Lst_Lines.ItemData(index) <> 0 Then
            Subway = Trim(Subway) & "," & Lst_Lines.ItemData(index)
            Rpt_Text2 = Rpt_Text2 & Lst_Lines.List(index)
        End If
    Next
        Subway = Trim(Subway) & ")"
        If Subway = "al_line in (0)" Then
            Subway = " "
            Rpt_Text2 = "Line/Station: All"
        Else
            Subway = Replace(Subway, "(0,", "(")
            GoTo Skip_Rest
        End If
        
    
    Rpt_Text2 = "Line/Station: "
    Subway = "al_id in (0"
    For index = 0 To Lst_Stations.ListCount - 1
        If Lst_Stations.Selected(index) = True And Lst_Stations.ItemData(index) <> 0 Then
            Subway = Trim(Subway) & "," & Lst_Stations.ItemData(index)
            Rpt_Text2 = Rpt_Text2 & Lst_Stations.List(index)
        End If
    Next
        Subway = Subway & Trim(Stations) & ")"
        If Subway = "al_id in (0)" Then
            Subway = " "
            Rpt_Text2 = "Line/Station: All"
        Else
            Subway = Replace(Subway, "(0,", "(")
            GoTo Skip_Rest
        End If
    If Cbo_MaintSec.ListIndex <> -1 Then
        Subway = " isnull(al.al_maint_Section,0) = " & CLng(Cbo_MaintSec.ItemData(Cbo_MaintSec.ListIndex))
        Rpt_Text2 = "Line/Station: " & Cbo_MaintSec.List(Cbo_MaintSec.ListIndex)
    End If
    
    step = 0
    
Skip_Rest:
    
    If Cbo_Group.ListIndex <> -1 Then
        Rpt_Group = Cbo_Group.ItemData(Cbo_Group.ListIndex)
        Rpt_Text3 = "Group by: " & Cbo_Group.List(Cbo_Group.ListIndex) & Trim(Rpt_Text4)
    End If
    
    
    Report_Name = "FVM Gate Detail"
    
    
    
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub Cmd_Res_Sort_Click()
    Txt_Sort.Text = ""
    Rpt_Sort1 = 0
    Rpt_Text4 = ""
    Rpt_Sort2 = 0

End Sub

Private Sub Cmd_ResetScr_Click()
    
    For index = 0 To Lst_Item_Types.ListCount - 1
        Lst_Item_Types.Selected(index) = False
    Next
    Chk_Rst.Value = 0
    For index = 0 To Lst_Lines.ListCount - 1
        Lst_Lines.Selected(index) = False
    Next
    For index = 0 To Lst_Stations.ListCount - 1
        Lst_Stations.Selected(index) = False
    Next
    Cbo_MaintSec.ListIndex = -1
    Cbo_Group.ListIndex = -1
    For index = 0 To Lst_Sort.ListCount - 1
        Lst_Sort.Selected(index) = False
    Next
    Txt_Sort.Text = ""

End Sub

Private Sub Form_Load()
    Rpt_Text12 = "Sort Options = Date Reported/Location"
' load the device # combo boxes for a device range
    
    sSql = "select * from afc_parttypes"
    Call Get_Trans("Read")
    Lst_Item_Types.AddItem " "
    Lst_Item_Types.ItemData(Lst_Item_Types.NewIndex) = 0
    
    Do While RS_Trans.EOF = False
        Lst_Item_Types.AddItem RS_Trans("APTdesc")
        Lst_Item_Types.ItemData(Lst_Item_Types.NewIndex) = RS_Trans("APTidx")
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")

'Load the Line List box

    sSql = "select * from afc_locationtype where alt_line = 'Y'"
    Call Get_Trans("Read")
    Lst_Lines.AddItem " "
    Lst_Lines.ItemData(Lst_Lines.NewIndex) = 0

    Do While RS_Trans.EOF = False
        Lst_Lines.AddItem RS_Trans("alt_description")
        Lst_Lines.ItemData(Lst_Lines.NewIndex) = RS_Trans("alt_index")
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
    
' Load the location list box
    sSql = "select * from afc_location where al_location_type in (5,19,20) order by al_location_name"
    Call Get_Trans("Read")
    Lst_Stations.AddItem " "
    Lst_Stations.ItemData(Lst_Stations.NewIndex) = 0

    Do While RS_Trans.EOF = False
        Lst_Stations.AddItem RS_Trans("al_location_name")
        Lst_Stations.ItemData(Lst_Stations.NewIndex) = RS_Trans("al_id")
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
End Sub

Private Sub Lst_Sort_Click()
    For index = 0 To Lst_Sort.ListCount - 1
        If Lst_Sort.Selected(index) = True And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort1 And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort2 Then 'And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort3 Then
            If Rpt_Sort1 = 0 Then
                Rpt_Sort1 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
                Rpt_Text4 = "Sort Options = " & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
                Txt_Sort.Text = Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            ElseIf Rpt_Sort2 = 0 Then
                Rpt_Sort2 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
                Rpt_Text4 = Rpt_Text4 & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
                Txt_Sort.Text = Txt_Sort.Text & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            Else
                MsgBox ("You have picked too many Sort Parameters.  Reset and start over")
                Exit Sub
            End If
        End If
    Next

End Sub

