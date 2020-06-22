Attribute VB_Name = "Movedetect"
Option Explicit

Private Type POINTAPI
x As Integer
y As Integer
End Type

Private Declare Sub GetCursorPos Lib "user32.dll" (lpPoint As POINTAPI)
Private Declare Function GetAsyncKeyState Lib "user32.dll" (ByVal vKey As Long) As Integer

Private posOld As POINTAPI
Private posNew As POINTAPI

Public Function InputCheck() As Boolean
    Dim i As Integer

   'Get the current mouse cursor coordinates
    Call GetCursorPos(posNew)
    'Compare with old coordinates
    If ((posNew.x <> posOld.x) Or (posNew.y <> posOld.y)) Then
        posOld = posNew
        InputCheck = True
        Exit Function
    End If
    'Check keys state
    For i = 0 To 255
        If (GetAsyncKeyState(i) And &H8001) <> 0 Then
            InputCheck = True
            Exit Function
        End If
    Next i
    InputCheck = False
End Function


