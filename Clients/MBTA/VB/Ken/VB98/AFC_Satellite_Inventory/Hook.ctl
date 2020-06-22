VERSION 5.00
Begin VB.UserControl Hook 
   BackColor       =   &H000000FF&
   ClientHeight    =   690
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   735
   InvisibleAtRuntime=   -1  'True
   ScaleHeight     =   690
   ScaleWidth      =   735
   Windowless      =   -1  'True
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   120
      Top             =   120
   End
End
Attribute VB_Name = "Hook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'---------------------------------------------------------------------------------------
' Module    : Hook
' DateTime  : 14.04.2004 17:59
' Author    : Alexander Gnauck
'             AG-Software
'             http://www.ag-software.de
'             mailto:gnauck@ag-software.de
' Purpose   : detect User Idle
'---------------------------------------------------------------------------------------

'// Timer intervall is 1 second. When you wanna be notified faster
'// after user is active again then set the timer to another interval

Option Explicit

'// Windows User Activity Functions
Private Declare Function IdleTrackerInit Lib "IdleTrac.dll" () As Boolean 'start the monitoring process
Private Declare Sub IdleTrackerTerm Lib "IdleTrac.dll" () 'stop the monitoring process
Private Declare Function IdleTrackerGetLastTickCount Lib "IdleTrac.dll" () As Long ' get the tick count of last user input
Private Declare Function GetTickCount Lib "kernel32.dll" () As Long ' windows # clock ticks since boot

Private m_lIdleTime As Long
Private b_RaiseIdle As Boolean

Public Event Idle()
Public Event Active()


Public Sub Hook()

On Error GoTo handler
    ChDir App.Path
    
    Call IdleTrackerInit
    
    Timer1.Enabled = True

    Exit Sub
handler:
    
End Sub

Public Sub Unhook()
    On Error GoTo handler
    
    ChDir App.Path
    
    Call IdleTrackerTerm
        
    Timer1.Enabled = False
    
    Exit Sub
handler:

End Sub

Public Property Get IdleTime() As Long

    IdleTime = m_lIdleTime

End Property

Public Property Let IdleTime(ByVal lIdleTime As Long)

    m_lIdleTime = lIdleTime

    Call UserControl.PropertyChanged("IdleTime")

End Property

Private Sub Timer1_Timer()
Dim inactiveTime As Integer
Dim tickCount As Long
Dim lastActive As Long
    
    On Error GoTo handler
    
    tickCount = GetTickCount
    lastActive = IdleTrackerGetLastTickCount
    
    inactiveTime = CLng(((tickCount - lastActive) / 1000))
    
    If inactiveTime >= m_lIdleTime Then
        If b_RaiseIdle = False Then
            RaiseEvent Idle
            b_RaiseIdle = True
        End If
    Else
        If b_RaiseIdle = True Then
            RaiseEvent Active
            b_RaiseIdle = False
        End If
    End If

    On Error GoTo 0
    Exit Sub
handler:
    
End Sub

Public Property Get Running() As Boolean
    If Timer1.Enabled = True Then
        Running = True
    Else
        Running = False
    End If
End Property

