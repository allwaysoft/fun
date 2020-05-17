Attribute VB_Name = "combomodule"
Option Explicit

'**** The following two constants and SendMessage function
'**** are needed for the combo box autofind function
'**** SendMessage also needed for other API calls
Declare Function SendMessage Lib "user32" Alias _
                                 "SendMessageA" _
                                 (ByVal hwnd As Long, _
                                  ByVal wMsg As Long, _
                                  ByVal wParam As Long, _
                                  lParam As Any) As Long
Public Const CB_FINDSTRING = &H14C
Public Const CB_ERR = (-1)
Public lCB As Long
'****


Public Function AutoFind(ByRef cboCurrent As ComboBox, _
                         ByVal Keyascii As Integer, _
                         Optional ByVal LimitToList As Boolean = False)
        
'*** Function to control combo box input


Dim sFindString As String

'On Error GoTo Err_Handler
If Keyascii = 8 Then
        If cboCurrent.SelStart <= 1 Then
            cboCurrent = ""
            AutoFind = 0
            Exit Function
        End If
        If cboCurrent.SelLength = 0 Then
            sFindString = UCase(Left(cboCurrent, Len(cboCurrent) - 1))
        Else
            sFindString = Left$(cboCurrent.Text, cboCurrent.SelStart - 1)
        End If
    ElseIf Keyascii < 32 Or Keyascii > 132 Then
        Exit Function
    Else
        If cboCurrent.SelLength = 0 Then
            sFindString = UCase(cboCurrent.Text & Chr$(Keyascii))
        Else
            sFindString = Left$(cboCurrent.Text, cboCurrent.SelStart) & Chr$(Keyascii)
        End If
    End If
    lCB = SendMessage(cboCurrent.hwnd, CB_FINDSTRING, -1, ByVal sFindString)

    If lCB <> CB_ERR Then
        cboCurrent.ListIndex = lCB
        cboCurrent.SelStart = Len(sFindString)
        cboCurrent.SelLength = Len(cboCurrent.Text) - cboCurrent.SelStart
        AutoFind = 0
    Else
        If LimitToList = True Then
            AutoFind = 0
        Else
            AutoFind = Keyascii
        End If
    End If
        
End Function

Public Function Prime_Cbo(ByRef cboCurrent As ComboBox, _
                         ByVal findstring As String, _
                         Optional ByVal LimitToList As Boolean = False)
                         
    lCB = SendMessage(cboCurrent.hwnd, CB_FINDSTRING, -1, ByVal findstring)

    If lCB <> CB_ERR Then
        cboCurrent.ListIndex = lCB
        cboCurrent.SelStart = Len(findstring)
        cboCurrent.SelLength = Len(cboCurrent.Text) - cboCurrent.SelStart
        Prime_Cbo = 0
    Else
        Prime_Cbo = 0
    End If
End Function
    
 


