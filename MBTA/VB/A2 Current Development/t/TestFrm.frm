VERSION 5.00
Begin VB.Form TestFrm 
   Caption         =   "Form1"
   ClientHeight    =   3585
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6570
   LinkTopic       =   "Form1"
   ScaleHeight     =   3585
   ScaleWidth      =   6570
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Recheckall 
      Caption         =   "All"
      Height          =   855
      Left            =   4320
      TabIndex        =   3
      Top             =   2280
      Width           =   1455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   480
      TabIndex        =   2
      Top             =   1800
      Width           =   1455
   End
   Begin VB.CommandButton AppTest2 
      Caption         =   "Test2"
      Height          =   375
      Left            =   3360
      TabIndex        =   1
      Top             =   1440
      Width           =   1335
   End
   Begin VB.CommandButton AppTest1 
      Caption         =   "Test1"
      Height          =   375
      Left            =   2160
      TabIndex        =   0
      Top             =   240
      Width           =   1335
   End
End
Attribute VB_Name = "TestFrm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Function GetApp() As A2App
    Dim oDS As A2IDataSource
    Set oDS = New A2SQLDataSource
    oDS.ConnectionString = "Provider=sqloledb;Data Source=OPSTECH2\A2PROD;Initial Catalog=attend2"
    
    Dim oApp As A2App
    Set oApp = New A2App
    oApp.Logon oDS, "ajv6412", "doggers"
    Set GetApp = oApp
    
End Function

Private Sub AppTest1_Click()
    Dim oApp As A2App
    Set oApp = GetApp()
    Dim oemp As A2Employee
    Set oemp = oApp.GetEmpByBadgeNum(2322)
    oApp.System.Publish a2PubEvTypeEmpAltered, oemp
    
    Dim oSrc As A2Source
    Set oSrc = oApp.GetObjFromIdent("Src", 1)
    
    Dim oAbs As A2Abs
    Set oAbs = oApp.GetAbsFromEmpAndDate(oemp, #1/5/2006#)
    Dim newabs As A2Abs
    
    
    Dim absType As A2IObjSet
    Set absType = New A2ObjSet
    
    Set newabs = oAbs.Replace(oSrc, absType)

End Sub

Private Sub AppTest2_Click()
    Dim oApp As A2App
    Set oApp = GetApp()
    Dim oemp As A2Employee
    Set oemp = oApp.GetEmpByBadgeNum(66042)
    oApp.System.Publish a2PubEvTypeEmpAltered, oemp
    
    'oApp.RecheckEveryone

'    Dim oApp As A2App
'    Set oApp = GetApp()
'    Dim oemp As A2Employee
'    Set oemp = oApp.GetObjFromIdent("Emp", 337) ' oApp.GetEmpByBadgeNum(67410)
'    oApp.System.Publish a2PubEvTypeEmpAltered, oemp

End Sub

Private Sub Command1_Click()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim oemp As A2Employee
    Dim notifset As A2IObjSet
    Set notifset = oApp.GetOpenNotifications(True, True, True)
    Dim vnotif As Variant, onotif As A2Notif
    For Each vnotif In notifset
        Set onotif = vnotif.AsIDefault
        Set oemp = onotif.Employee
        oApp.System.Publish a2PubEvTypeEmpAltered, oemp
    Next
    
    

End Sub

Private Sub Recheckall_Click()
    Dim oApp As A2App
    Set oApp = GetApp()
    oApp.RecheckEveryone
End Sub
