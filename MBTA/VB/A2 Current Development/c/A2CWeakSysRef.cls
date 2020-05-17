VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2CWeakSysRef"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Description = "Refers to a COM object without increasing that objects reference count.  Can be used to prevent circular references"
'PURPOSE
'Refers to a COM object without increasing that objects
'reference count.  Can be used to prevent circular
'references
'
'WARNING
'The Class_Terminate event of the object referred to must
'call the Destroy method of this class
'

Option Explicit

'Windows API function which copies a block of memory from
'one location to another
Private Declare Sub RtlMoveMemory Lib "kernel32" (Dest As Any, Source As Any, ByVal Bytes As Long)

Private mPointer As Long        'Address of the object in memory
Private mbHasBeenSet As Boolean 'True if Target has been set

'If this class is added to a DLL consider making the
'following changes to provide a constructor method:
'
'1  Change the instancing property of this class to
'   PublicNotCreatable
'
'2  Change the scope of the Initialize method from Public
'   to Friend
'
'3  Add the following procedure to another class in the
'   DLL whose instancing property is GlobalMultiUse:
'
'   Public Function NewWeakReference(ByVal Target As Object) As WeakReference
'
'       Set NewWeakReference = New WeakReference
'       NewWeakReference.Initialize Target
'
'   End Function

'PURPOSE
'Sets the object referred to
'
Public Sub Initialize(ByVal Target As A2System)
Attribute Initialize.VB_Description = "Sets the object referred to"

    'Raise error if target is Nothing
    If Target Is Nothing Then
        Err.Raise vbObjectError, "WeakReference", "Target cannot be Nothing."
    End If
    
    'Raise error if target has already been set
    If mbHasBeenSet Then
        Err.Raise vbObjectError, "WeakReference", "Target has already been set."
    End If
    
    'Use hidden VBA method to get address of object
    mPointer = VBA.ObjPtr(Target)
    
    'Set flag
    mbHasBeenSet = True
    
End Sub

'PURPOSE
'Returns the object referred to
'
Public Property Get Target() As A2System
Attribute Target.VB_Description = "Returns the object referred to"

Dim oObject As A2System

    'Use the Windows API function RtlMoveMemory to convert
    'an address into an object reference

    If mPointer = 0 Then
        'Raise error if target no longer exists
        Err.Raise a2ErrDisconnected, "A2SQLDS.A2SQLWeakRef", "Object is no longer available as it has become disconnected from its host."
    
    Else

        'Copy the stored address the into the object variable.
        'This does not increase the reference count maintained
        'by the object.
        RtlMoveMemory oObject, mPointer, 4

        'Use a Set command to return the object - this increments the
        'reference count maintained by oObject
        Set Target = oObject

        'Clear the dummy object before VB sets it to Nothing.
        'The reference count maintained by the object is now
        'correct, and one more than when the procedure started.
        RtlMoveMemory oObject, 0&, 4

    End If
    
End Property

'PURPOSE
'Resets the object referred to.  Must be called in the
'Terminate event of the object referred to
'
Public Sub Destroy()
Attribute Destroy.VB_Description = "Resets the object referred to.  Must be called in the Terminate event of the object referred to"

    mPointer = 0
    
End Sub

'PURPOSE
'Returns True if the object referred to still exists
'
Public Property Get IsAlive() As Boolean
Attribute IsAlive.VB_Description = "Returns True if the object referred to still exists"

    If mPointer > 0 Then
        IsAlive = True
    End If

End Property
