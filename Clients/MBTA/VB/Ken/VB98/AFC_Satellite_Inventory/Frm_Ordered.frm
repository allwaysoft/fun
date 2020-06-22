VERSION 5.00
Begin VB.Form Frm_Ordered 
   Caption         =   "Part ordered received"
   ClientHeight    =   3315
   ClientLeft      =   1605
   ClientTop       =   1755
   ClientWidth     =   6585
   LinkTopic       =   "Form1"
   ScaleHeight     =   3315
   ScaleWidth      =   6585
   Begin VB.TextBox Txt_Received 
      Height          =   285
      Left            =   1920
      TabIndex        =   3
      Top             =   1680
      Width           =   1455
   End
   Begin VB.TextBox Txt_Ordered 
      Height          =   285
      Left            =   1920
      TabIndex        =   2
      Top             =   1320
      Width           =   1455
   End
   Begin VB.CommandButton Cmd_update 
      Caption         =   "Update"
      Height          =   495
      Left            =   3960
      TabIndex        =   4
      Top             =   2280
      Width           =   2055
   End
   Begin VB.ComboBox Cbo_Partno 
      Height          =   315
      Left            =   1920
      TabIndex        =   1
      Top             =   840
      Width           =   4335
   End
   Begin VB.Label Label3 
      Caption         =   "Received"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1680
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "Ordered"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   1320
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Part"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   840
      Width           =   1335
   End
End
Attribute VB_Name = "Frm_Ordered"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim ent_part As String


Private Sub Cbo_Partno_KeyPress(KeyAscii As Integer)

    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Partno.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Partno, KeyAscii, True)
End Sub

Private Sub Cmd_update_Click()
    sSql = "update afc_inventory set ai_orig_order=" & CLng(Txt_Ordered.Text) & ", ai_received = " & CLng(Txt_Received.Text) & " where ai_index = " & Cbo_Partno.ItemData(Cbo_Partno.ListIndex)
    SQLData.Execute (sSql)
    Cbo_Partno.SetFocus
End Sub

Private Sub Load_SB_Partno_Cbo()
Dim spart As Long
Dim sdesc As String
Dim part_desc As String

    sSql = "select ai_index,ai_partno,AI_Description,AI_Parttype from AFC_Inventory"
    Call Get_Inventory("Read")
    Cbo_Partno.Clear

    Do While RS_Inventory.EOF = False
    
        spart = RS_Inventory("ai_partno")            'part number
        sdesc = Trim(RS_Inventory("ai_description"))              'description
        part_desc = spart & " -  " & sdesc
        If Trim(RS_Inventory("AI_PartType")) = Trim("UNIT") Then
        Else
            Cbo_Partno.AddItem (part_desc)
            Cbo_Partno.ItemData(Cbo_Partno.NewIndex) = RS_Inventory("ai_index")

        End If
themove:
        RS_Inventory.MoveNext

        DoEvents
    Loop
    Call Get_Inventory("Close")

End Sub

Private Sub Form_Load()
Call Load_SB_Partno_Cbo
End Sub
