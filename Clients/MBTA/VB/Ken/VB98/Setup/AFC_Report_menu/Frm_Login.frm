VERSION 5.00
Begin VB.Form Frm_Login 
   Caption         =   "AFC Inventory Login"
   ClientHeight    =   2670
   ClientLeft      =   840
   ClientTop       =   1650
   ClientWidth     =   5370
   LinkTopic       =   "Form1"
   ScaleHeight     =   2670
   ScaleWidth      =   5370
   Begin VB.Timer Timer1 
      Interval        =   60000
      Left            =   4200
      Top             =   480
   End
   Begin VB.CommandButton Cmd_save 
      Caption         =   "Save Password"
      Height          =   615
      Left            =   3480
      TabIndex        =   8
      Top             =   1800
      Width           =   1215
   End
   Begin VB.TextBox Txt_Conf_pw 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1680
      PasswordChar    =   "*"
      TabIndex        =   4
      Top             =   1320
      Width           =   1455
   End
   Begin VB.TextBox Txt_New_pw 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1680
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   840
      Width           =   1455
   End
   Begin VB.TextBox Txt_Password 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1680
      PasswordChar    =   "*"
      TabIndex        =   2
      Top             =   840
      Width           =   1455
   End
   Begin VB.TextBox Txt_ID 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Top             =   360
      Width           =   1455
   End
   Begin VB.Label Label4 
      Caption         =   "Confirm  Password"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1320
      Width           =   1455
   End
   Begin VB.Label Label3 
      Caption         =   "New Password"
      Height          =   255
      Left            =   360
      TabIndex        =   6
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Password"
      Height          =   255
      Left            =   360
      TabIndex        =   5
      Top             =   840
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Employee #"
      Height          =   255
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   975
   End
End
Attribute VB_Name = "Frm_Login"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Cmd_save_Click()
    If PW_Option = "Reset" Then
        ssql = "Update AFC_Technicians set AT_Password = encryptbypassphrase('blind','today') where at_empno = " & Txt_ID.Text
        SQLData.Execute (ssql)
        MsgBox ("users Password has been reset to 'today'"), vbOKOnly
        Unload Me
        Exit Sub
    End If
    
    If Txt_New_pw.Text <> Txt_Conf_pw.Text Then
        MsgBox ("Your new passwords don't match")
        Txt_New_pw.Text = ""
        Txt_Conf_pw.Text = ""
        Txt_New_pw.SetFocus
    Else
    'Update AFC_Technicians
    ssql = "Update AFC_Technicians set AT_Password = encryptbypassphrase('blind','" & Trim(Txt_New_pw) & "') where at_id = " & Current_User_Index
    SQLData.Execute (ssql)
    Unload Me
    End If
End Sub

Private Sub Form_Load()
    If PW_Option = "Login" Then
        Label3.Visible = False
        Label4.Visible = False
        Txt_New_pw.Visible = False
        Txt_Conf_pw.Visible = False
        Cmd_save.Visible = False
        Txt_ID.Enabled = True
        Txt_ID.BackColor = &HFFFFFF

    ElseIf PW_Option = "Change" Then
        Label3.Visible = True
        Label4.Visible = True
        Txt_New_pw.Visible = True
        Txt_Conf_pw.Visible = True
        Cmd_save.Caption = "Save Password"

        Cmd_save.Visible = True
        Txt_ID.Enabled = False
        Txt_ID.BackColor = &HFFFF&
        Txt_ID.Text = Current_User_Id
        Label2.Visible = False
        Txt_Password.Visible = False
    Else 'reset
        Label2.Visible = False
        Label3.Visible = False
        Label4.Visible = False
        Txt_Password.Visible = False
        Txt_New_pw.Visible = False
        Txt_Conf_pw.Visible = False
        Cmd_save.Visible = True
        Txt_ID.Enabled = True
        Txt_ID.BackColor = &HFFFFFF
        Cmd_save.Caption = "Reset Password"
    End If
End Sub




Private Sub Txt_ID_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
            If Txt_ID.Text <> "" Then
                KeyAscii = 0
                SendKeys "{TAB}"
            End If
        Case 48 To 57
            Exit Sub
    End Select
    KeyAscii = 0

End Sub




Private Sub Txt_Password_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
            If Txt_Password.Text <> "" Then
                KeyAscii = 0
                SendKeys "{TAB}"
            End If
            
        Case Else
            Exit Sub
    End Select
    KeyAscii = 0
End Sub

Private Sub Txt_Password_Validate(Cancel As Boolean)
' routine to allow the users to change there passwords on an ass needed bases
'SELECT     CONVERT(varchar(20), decryptbypassphrase('blind', AT_Password)) AS Expr1
'From AFC_Technicians
    ssql = "select * from afc_technicians where at_empno = " & Txt_ID.Text & " and CONVERT(VARCHAR(20), decryptbypassphrase('blind',at_password)) = '" & Trim(Txt_Password.Text) & "'"
    Set RS_Work = New ADODB.Recordset
    Set RS_Work = SQLData.Execute(ssql)
    If RS_Work.EOF = True Then
        MsgBox ("invalid employee # or password"), vbOKOnly
        Txt_Password.Text = ""
        Txt_ID.SetFocus
        Exit Sub
    End If
    Current_User_Index = RS_Work("at_id")
    Current_User_Id = RS_Work("at_empno")
    Current_User_Name = Trim(RS_Work("at_empfname")) & " " & Trim(RS_Work("at_emplname"))
    Current_User_Level = RS_Work("at_access_level")
    Current_User_Branch = RS_Work("at_branch")
    RS_Work.Close
    Set RS_Work = Nothing
    
    Frm_Login.Hide
End Sub
