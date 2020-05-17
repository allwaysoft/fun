VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form FRM_Main 
   Caption         =   "AFC InventoryTracking Module"
   ClientHeight    =   9480
   ClientLeft      =   195
   ClientTop       =   1125
   ClientWidth     =   12420
   LinkTopic       =   "Form1"
   ScaleHeight     =   9480
   ScaleWidth      =   12420
   Begin VB.Timer Timer1 
      Interval        =   60000
      Left            =   480
      Top             =   360
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   8175
      Left            =   120
      TabIndex        =   15
      Top             =   1080
      Width           =   11655
      _ExtentX        =   20558
      _ExtentY        =   14420
      _Version        =   393216
      Tabs            =   8
      Tab             =   2
      TabsPerRow      =   4
      TabHeight       =   520
      ShowFocusRect   =   0   'False
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      TabCaption(0)   =   "Home"
      TabPicture(0)   =   "FRM_Main.frx":0000
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Label(11)"
      Tab(0).Control(1)=   "Label(10)"
      Tab(0).Control(2)=   "Picture1"
      Tab(0).ControlCount=   3
      TabCaption(1)   =   "Part/Assembly Lookup"
      TabPicture(1)   =   "FRM_Main.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Label(47)"
      Tab(1).Control(1)=   "Label2(0)"
      Tab(1).Control(2)=   "Label(14)"
      Tab(1).Control(3)=   "Label(12)"
      Tab(1).Control(4)=   "Label(15)"
      Tab(1).Control(5)=   "Label(18)"
      Tab(1).Control(6)=   "Label(13)"
      Tab(1).Control(7)=   "Label(16)"
      Tab(1).Control(8)=   "Label(17)"
      Tab(1).Control(9)=   "Label(19)"
      Tab(1).Control(10)=   "Label(20)"
      Tab(1).Control(11)=   "Label(23)"
      Tab(1).Control(12)=   "Label(25)"
      Tab(1).Control(13)=   "Label(24)"
      Tab(1).Control(14)=   "Label(26)"
      Tab(1).Control(15)=   "Label(21)"
      Tab(1).Control(16)=   "Txt_Setteling"
      Tab(1).Control(17)=   "Txt_Usage"
      Tab(1).Control(18)=   "Txt_Received"
      Tab(1).Control(19)=   "Txt_OrigOrd"
      Tab(1).Control(20)=   "Cbo_Parttype(0)"
      Tab(1).Control(21)=   "Lst_UsedIn(0)"
      Tab(1).Control(22)=   "Grid_LocBal"
      Tab(1).Control(23)=   "Txt_OemPart"
      Tab(1).Control(24)=   "Fra_Sat_avail"
      Tab(1).Control(25)=   "Txt_Altpart"
      Tab(1).Control(26)=   "Txt_CurrCost"
      Tab(1).Control(27)=   "Cbo_Partno"
      Tab(1).Control(28)=   "Txt_Notes"
      Tab(1).Control(29)=   "cmd_save_inv"
      Tab(1).Control(30)=   "FRM_PMovement"
      Tab(1).Control(31)=   "cmd_oem_search"
      Tab(1).Control(32)=   "Txt_MaxROP"
      Tab(1).Control(33)=   "Txt_MinROP"
      Tab(1).Control(34)=   "Cbo_RLB"
      Tab(1).Control(35)=   "Cbo_RLS"
      Tab(1).Control(36)=   "Cmd_addpart"
      Tab(1).Control(37)=   "FRM_Newpart"
      Tab(1).ControlCount=   38
      TabCaption(2)   =   "Satellite Inventory Transfer"
      TabPicture(2)   =   "FRM_Main.frx":0038
      Tab(2).ControlEnabled=   -1  'True
      Tab(2).Control(0)=   "Fra_Inv_Transfer"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).ControlCount=   1
      TabCaption(3)   =   "Work Bench"
      TabPicture(3)   =   "FRM_Main.frx":0054
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "Label(55)"
      Tab(3).Control(0).Enabled=   0   'False
      Tab(3).Control(1)=   "Grid_WB"
      Tab(3).Control(1).Enabled=   0   'False
      Tab(3).Control(2)=   "Fra_Workbench"
      Tab(3).Control(2).Enabled=   0   'False
      Tab(3).Control(3)=   "Grid_WB_Open"
      Tab(3).Control(3).Enabled=   0   'False
      Tab(3).Control(4)=   "Cmd_Add_WB"
      Tab(3).Control(4).Enabled=   0   'False
      Tab(3).Control(5)=   "Frm_Inc_excep"
      Tab(3).Control(5).Enabled=   0   'False
      Tab(3).ControlCount=   6
      TabCaption(4)   =   "Physical/Receiving Inv."
      TabPicture(4)   =   "FRM_Main.frx":0070
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Fra_Physical"
      Tab(4).ControlCount=   1
      TabCaption(5)   =   "Equipment Tracking"
      TabPicture(5)   =   "FRM_Main.frx":008C
      Tab(5).ControlEnabled=   0   'False
      Tab(5).Control(0)=   "Fra_Equipopt"
      Tab(5).Control(1)=   "Frame1"
      Tab(5).Control(2)=   "Grid_Equip"
      Tab(5).Control(3)=   "Label(52)"
      Tab(5).ControlCount=   4
      TabCaption(6)   =   "Location Maintenance"
      TabPicture(6)   =   "FRM_Main.frx":00A8
      Tab(6).ControlEnabled=   0   'False
      Tab(6).Control(0)=   "Grid_Loc"
      Tab(6).Control(1)=   "Fra_Location"
      Tab(6).ControlCount=   2
      TabCaption(7)   =   "Technician View/Maintenance"
      TabPicture(7)   =   "FRM_Main.frx":00C4
      Tab(7).ControlEnabled=   0   'False
      Tab(7).Control(0)=   "Label(48)"
      Tab(7).Control(1)=   "Grid_Tech"
      Tab(7).Control(2)=   "FRA_Tech"
      Tab(7).ControlCount=   3
      Begin VB.Frame Fra_Equipopt 
         Height          =   2415
         Left            =   -70800
         TabIndex        =   199
         Top             =   360
         Width           =   10935
         Begin VB.CommandButton Cmd_Busses 
            Caption         =   "Show FareBox Info"
            Height          =   615
            Left            =   6480
            TabIndex        =   201
            Top             =   720
            Width           =   1695
         End
         Begin VB.CommandButton Cmd_subway 
            Caption         =   "Show Subway Info"
            Height          =   615
            Left            =   2880
            TabIndex        =   200
            Top             =   720
            Width           =   1695
         End
      End
      Begin VB.Frame Frame1 
         Height          =   2415
         Left            =   -74520
         TabIndex        =   206
         Top             =   720
         Width           =   10575
         Begin VB.TextBox Txt_Cost 
            BackColor       =   &H00C0FFFF&
            Height          =   285
            Left            =   8760
            Locked          =   -1  'True
            TabIndex        =   232
            Top             =   360
            Width           =   1455
         End
         Begin VB.CommandButton cmd_cal 
            Caption         =   "Calendar"
            Height          =   255
            Left            =   8520
            TabIndex        =   219
            Top             =   750
            Width           =   1095
         End
         Begin VB.TextBox Txt_Rollout 
            BackColor       =   &H00C0FFFF&
            Height          =   285
            Left            =   6960
            Locked          =   -1  'True
            TabIndex        =   223
            Top             =   720
            Width           =   1455
         End
         Begin VB.CheckBox Chk_Moved 
            Alignment       =   1  'Right Justify
            Caption         =   "Moved/Closed"
            Height          =   255
            Left            =   4680
            TabIndex        =   222
            Top             =   1770
            Width           =   1455
         End
         Begin VB.ComboBox Combo 
            Height          =   315
            Index           =   1
            Left            =   5880
            TabIndex        =   220
            Top             =   1020
            Width           =   3375
         End
         Begin VB.ComboBox Combo 
            Height          =   315
            Index           =   2
            Left            =   5880
            TabIndex        =   221
            Top             =   1350
            Width           =   3375
         End
         Begin VB.ComboBox Cbo_Partno3 
            Height          =   315
            Left            =   1920
            TabIndex        =   214
            Top             =   330
            Width           =   6255
         End
         Begin VB.ComboBox Cbo_Locations3 
            Height          =   315
            Left            =   1920
            TabIndex        =   215
            Top             =   720
            Width           =   3495
         End
         Begin VB.TextBox Txt_MBTAno 
            Height          =   285
            Left            =   1920
            MaxLength       =   15
            TabIndex        =   216
            Top             =   1080
            Width           =   1695
         End
         Begin VB.TextBox Txt_SBSerial 
            Height          =   285
            Left            =   1920
            MaxLength       =   12
            TabIndex        =   217
            Top             =   1410
            Width           =   1695
         End
         Begin VB.ComboBox Combo 
            Height          =   315
            Index           =   0
            ItemData        =   "FRM_Main.frx":00E0
            Left            =   1920
            List            =   "FRM_Main.frx":00F6
            TabIndex        =   218
            Top             =   1740
            Width           =   2415
         End
         Begin VB.CommandButton CMD_UnitAdd 
            Caption         =   "Add/Save"
            Height          =   495
            Left            =   9240
            TabIndex        =   208
            Top             =   1800
            Width           =   1215
         End
         Begin VB.CommandButton Cmd_Unit_Clear 
            Caption         =   "Reset Screen"
            Height          =   495
            Left            =   7800
            TabIndex        =   207
            Top             =   1800
            Width           =   1215
         End
         Begin VB.Label Label4 
            Caption         =   "Cost"
            Height          =   255
            Left            =   8280
            TabIndex        =   231
            Top             =   390
            Width           =   495
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "Roll-out Date"
            Height          =   255
            Index           =   9
            Left            =   5640
            TabIndex        =   226
            Top             =   750
            Width           =   1095
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "State Grant/Bond"
            Height          =   255
            Index           =   65
            Left            =   4200
            TabIndex        =   225
            Top             =   1080
            Width           =   1455
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "Federal Grant"
            Height          =   255
            Index           =   66
            Left            =   4440
            TabIndex        =   224
            Top             =   1410
            Width           =   1215
         End
         Begin VB.Label Label2 
            Alignment       =   1  'Right Justify
            Caption         =   "S&&B Part #"
            Height          =   255
            Index           =   1
            Left            =   720
            TabIndex        =   213
            Top             =   390
            Width           =   975
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "Location"
            Height          =   255
            Index           =   0
            Left            =   720
            TabIndex        =   212
            Top             =   720
            Width           =   975
         End
         Begin VB.Label Label2 
            Alignment       =   1  'Right Justify
            Caption         =   "MBTA #"
            Height          =   255
            Index           =   2
            Left            =   720
            TabIndex        =   211
            Top             =   1050
            Width           =   975
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "S&&B Serial Number"
            Height          =   255
            Index           =   8
            Left            =   240
            TabIndex        =   210
            Top             =   1380
            Width           =   1455
         End
         Begin VB.Label Label 
            Caption         =   "Equipment Condition"
            Height          =   255
            Index           =   64
            Left            =   240
            TabIndex        =   209
            Top             =   1740
            Width           =   1575
         End
      End
      Begin VB.Frame Frm_Inc_excep 
         Caption         =   "Incident Inventory Exceptions"
         Height          =   7215
         Left            =   -63240
         TabIndex        =   181
         Top             =   600
         Width           =   11175
         Begin VB.TextBox Txt_Ipol 
            Height          =   285
            Left            =   2280
            TabIndex        =   196
            Top             =   2400
            Width           =   2055
         End
         Begin VB.ComboBox Cbo_Date 
            Height          =   315
            Left            =   2280
            TabIndex        =   193
            Top             =   4320
            Width           =   2175
         End
         Begin VB.CommandButton Cmd_Record 
            Caption         =   "Save Exception"
            Height          =   495
            Left            =   5280
            TabIndex        =   191
            Top             =   4080
            Width           =   1575
         End
         Begin VB.TextBox Txt_Equip_ID 
            Height          =   285
            Left            =   2280
            TabIndex        =   189
            Top             =   3840
            Width           =   2055
         End
         Begin VB.TextBox Txt_Serial 
            BackColor       =   &H0080FFFF&
            Height          =   285
            Left            =   2280
            Locked          =   -1  'True
            TabIndex        =   187
            Top             =   3360
            Width           =   2055
         End
         Begin VB.TextBox Txt_Partno 
            BackColor       =   &H0080FFFF&
            Height          =   285
            Left            =   2280
            Locked          =   -1  'True
            TabIndex        =   185
            Top             =   2880
            Width           =   2055
         End
         Begin VB.TextBox Txt_Incident 
            Height          =   285
            Left            =   2280
            TabIndex        =   183
            Top             =   1920
            Width           =   2055
         End
         Begin VB.Label Label 
            Caption         =   "Or"
            Height          =   255
            Index           =   40
            Left            =   1560
            TabIndex        =   198
            Top             =   2160
            Width           =   375
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "I-Pol #"
            Height          =   255
            Index           =   41
            Left            =   120
            TabIndex        =   197
            Top             =   2400
            Width           =   1815
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "Date Work Performed"
            Height          =   255
            Index           =   46
            Left            =   120
            TabIndex        =   194
            Top             =   4320
            Width           =   1815
         End
         Begin VB.Label Label 
            Caption         =   "Example 060607-00123      mmddyy-####"
            Height          =   255
            Index           =   42
            Left            =   4560
            TabIndex        =   192
            Top             =   1920
            Width           =   3495
         End
         Begin VB.Label Label 
            Caption         =   "Label68"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   13.5
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   855
            Index           =   50
            Left            =   240
            TabIndex        =   190
            Top             =   480
            Width           =   9495
            WordWrap        =   -1  'True
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "MBTA Equipment Id"
            Height          =   255
            Index           =   45
            Left            =   120
            TabIndex        =   188
            Top             =   3840
            Width           =   1815
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "Part Serial#"
            Height          =   255
            Index           =   44
            Left            =   120
            TabIndex        =   186
            Top             =   3360
            Width           =   1815
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "Part Number"
            Height          =   255
            Index           =   43
            Left            =   120
            TabIndex        =   184
            Top             =   2880
            Width           =   1815
         End
         Begin VB.Label Label 
            Alignment       =   1  'Right Justify
            Caption         =   "Incident #"
            Height          =   255
            Index           =   39
            Left            =   120
            TabIndex        =   182
            Top             =   1920
            Width           =   1815
         End
      End
      Begin VB.CommandButton Cmd_Add_WB 
         Caption         =   "Add Component to Work Bench"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   735
         Left            =   -67080
         TabIndex        =   147
         Top             =   6960
         Width           =   2655
      End
      Begin MSFlexGridLib.MSFlexGrid Grid_WB_Open 
         Height          =   2775
         Left            =   -73800
         TabIndex        =   146
         Top             =   4080
         Width           =   8655
         _ExtentX        =   15266
         _ExtentY        =   4895
         _Version        =   393216
      End
      Begin VB.Frame FRA_Tech 
         BorderStyle     =   0  'None
         Height          =   1695
         Left            =   -74880
         TabIndex        =   54
         Top             =   720
         Width           =   11055
         Begin VB.ComboBox Cbo_Branch 
            Height          =   315
            ItemData        =   "FRM_Main.frx":0129
            Left            =   4800
            List            =   "FRM_Main.frx":0136
            TabIndex        =   59
            Top             =   600
            Width           =   1935
         End
         Begin VB.TextBox Txt_CellPhone 
            Alignment       =   1  'Right Justify
            Height          =   285
            Left            =   3120
            TabIndex        =   58
            Top             =   960
            Width           =   1575
         End
         Begin VB.CommandButton Cmd_Reset 
            Caption         =   "Reset"
            CausesValidation=   0   'False
            Height          =   375
            Left            =   8760
            TabIndex        =   64
            Top             =   1080
            Width           =   1575
         End
         Begin VB.CommandButton Cmd_rem_tech 
            Caption         =   "Remove Technician"
            Height          =   375
            Left            =   8760
            TabIndex        =   63
            Top             =   600
            Width           =   1575
         End
         Begin VB.TextBox Txt_tech 
            Height          =   285
            Left            =   120
            TabIndex        =   55
            Top             =   600
            Width           =   975
         End
         Begin VB.TextBox Txt_techfname 
            Height          =   285
            Left            =   1320
            TabIndex        =   56
            Top             =   600
            Width           =   1575
         End
         Begin VB.TextBox Txt_techlname 
            Height          =   285
            Left            =   3120
            TabIndex        =   57
            Top             =   600
            Width           =   1575
         End
         Begin VB.ComboBox Cbo_security 
            Height          =   315
            ItemData        =   "FRM_Main.frx":0162
            Left            =   6840
            List            =   "FRM_Main.frx":0175
            TabIndex        =   60
            Top             =   600
            Width           =   1815
         End
         Begin VB.CommandButton Cmd_Add_tech 
            Caption         =   "Add Technician"
            CausesValidation=   0   'False
            Height          =   375
            Left            =   8760
            TabIndex        =   62
            Top             =   120
            Width           =   1575
         End
         Begin VB.CommandButton Cmd_save_tech 
            Caption         =   "Save Change"
            Height          =   375
            Left            =   8760
            TabIndex        =   61
            Top             =   120
            Width           =   1575
         End
         Begin VB.Label Label3 
            Caption         =   "Access Level"
            Height          =   255
            Index           =   3
            Left            =   6960
            TabIndex        =   119
            Top             =   240
            Width           =   1335
         End
         Begin VB.Label Label 
            Caption         =   "MBTA Cell Phone"
            Height          =   255
            Index           =   49
            Left            =   1440
            TabIndex        =   118
            Top             =   960
            Width           =   1455
         End
         Begin VB.Label Label3 
            Caption         =   "Last Name"
            Height          =   255
            Index           =   2
            Left            =   3240
            TabIndex        =   117
            Top             =   240
            Width           =   1335
         End
         Begin VB.Label Label3 
            Caption         =   "Employee #"
            Height          =   255
            Index           =   0
            Left            =   120
            TabIndex        =   66
            Top             =   240
            Width           =   975
         End
         Begin VB.Label Label3 
            Caption         =   "First Name"
            Height          =   255
            Index           =   1
            Left            =   1560
            TabIndex        =   65
            Top             =   240
            Width           =   975
         End
      End
      Begin VB.Frame Fra_Workbench 
         Height          =   3135
         Left            =   -74760
         TabIndex        =   115
         Top             =   720
         Width           =   11055
         Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
            Height          =   30
            Left            =   720
            TabIndex        =   145
            Top             =   3120
            Width           =   9495
            _ExtentX        =   16748
            _ExtentY        =   53
            _Version        =   393216
         End
         Begin VB.Frame Fra_Receipt 
            Height          =   3135
            Left            =   0
            TabIndex        =   123
            Top             =   120
            Width           =   11055
            Begin VB.CommandButton Cmd_Confirm_Dam 
               Caption         =   "Confirm Damaged"
               Height          =   735
               Left            =   8280
               TabIndex        =   143
               Top             =   600
               Width           =   2055
            End
            Begin VB.TextBox Txt_Label 
               Height          =   285
               Left            =   1560
               TabIndex        =   126
               Top             =   240
               Width           =   3975
            End
            Begin VB.CommandButton cmd_out_date 
               Caption         =   "Calandar"
               Height          =   255
               Left            =   3360
               TabIndex        =   131
               Top             =   2280
               Width           =   1095
            End
            Begin VB.TextBox Txt_Out_Date 
               Height          =   285
               Left            =   1560
               TabIndex        =   130
               Top             =   2280
               Width           =   1695
            End
            Begin VB.CommandButton Cmd_Qa 
               Caption         =   "quick_add"
               Height          =   375
               Left            =   6120
               TabIndex        =   132
               Top             =   1440
               Width           =   1815
            End
            Begin VB.CommandButton Cmd_Close 
               Caption         =   "Close"
               Height          =   495
               Left            =   5760
               TabIndex        =   135
               Top             =   2280
               Width           =   1215
            End
            Begin VB.TextBox Txt_RecQty 
               Height          =   285
               Left            =   1560
               TabIndex        =   129
               Text            =   "1"
               Top             =   1800
               Width           =   735
            End
            Begin VB.CommandButton Cmd_FindWB 
               Caption         =   "Resolve Assembly"
               Height          =   375
               Left            =   6120
               TabIndex        =   133
               Top             =   960
               Width           =   2055
            End
            Begin VB.ComboBox Cbo_Partno4 
               Height          =   315
               Left            =   1560
               TabIndex        =   127
               Top             =   960
               Width           =   4335
            End
            Begin VB.TextBox Txt_RecSerial 
               Height          =   285
               Left            =   1560
               TabIndex        =   128
               Top             =   1440
               Width           =   1815
            End
            Begin VB.Label Label 
               BeginProperty Font 
                  Name            =   "MS Sans Serif"
                  Size            =   12
                  Charset         =   0
                  Weight          =   700
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Height          =   375
               Index           =   54
               Left            =   5640
               TabIndex        =   144
               Top             =   240
               Width           =   5295
            End
            Begin VB.Label Label 
               Caption         =   "Or"
               Height          =   255
               Index           =   34
               Left            =   480
               TabIndex        =   141
               Top             =   600
               Width           =   495
            End
            Begin VB.Label Label 
               Caption         =   "Scan Label "
               Height          =   255
               Index           =   33
               Left            =   360
               TabIndex        =   140
               Top             =   240
               Width           =   855
            End
            Begin VB.Label Label 
               Caption         =   "Date Out"
               Height          =   255
               Index           =   38
               Left            =   360
               TabIndex        =   139
               Top             =   2280
               Width           =   975
            End
            Begin VB.Label Label 
               Caption         =   "Qty Received"
               Height          =   255
               Index           =   37
               Left            =   360
               TabIndex        =   134
               Top             =   1830
               Width           =   1095
            End
            Begin VB.Label Label 
               Caption         =   "Serial #"
               Height          =   255
               Index           =   36
               Left            =   360
               TabIndex        =   125
               Top             =   1470
               Width           =   615
            End
            Begin VB.Label Label 
               Caption         =   "S&&B Part#"
               Height          =   255
               Index           =   35
               Left            =   360
               TabIndex        =   124
               Top             =   1020
               Width           =   975
            End
         End
         Begin VB.CommandButton Cmd_Verify 
            Caption         =   "Verify Damage Parts from Satellite Location"
            Height          =   975
            Left            =   360
            TabIndex        =   142
            Top             =   600
            Width           =   1815
         End
         Begin VB.CommandButton Cmd_Sent 
            Caption         =   "Receive Back from S&&B Workbench"
            Height          =   975
            Left            =   6720
            TabIndex        =   121
            Top             =   600
            Width           =   1815
         End
         Begin VB.CommandButton cmd_open 
            Caption         =   "Print Report and mark as sent Burlington"
            Height          =   975
            Left            =   4560
            TabIndex        =   120
            Top             =   600
            Width           =   1815
         End
         Begin VB.CommandButton Cmd_rec_report 
            Caption         =   "Verification Receipt Report of units back from S&&B"
            Height          =   975
            Left            =   8880
            TabIndex        =   165
            Top             =   600
            Width           =   1815
         End
         Begin VB.CommandButton Cmd_AssBurlington 
            Caption         =   "Assign to Burlington"
            Height          =   975
            Left            =   2400
            TabIndex        =   227
            Top             =   600
            Width           =   1815
         End
         Begin VB.CommandButton Cmd_CoinController 
            BackColor       =   &H00FFFFC0&
            Caption         =   "Assign Swapped Coin Controllers to Burlington"
            Height          =   975
            Left            =   1440
            Style           =   1  'Graphical
            TabIndex        =   233
            Top             =   1800
            Width           =   1815
         End
         Begin VB.CommandButton Cmd_CoinControllerIn 
            BackColor       =   &H00FFFFC0&
            Caption         =   "Receive Swapped Controllers From Burlington"
            Height          =   975
            Left            =   6720
            Style           =   1  'Graphical
            TabIndex        =   234
            Top             =   1800
            Width           =   1815
         End
      End
      Begin VB.Frame Fra_Physical 
         BorderStyle     =   0  'None
         Height          =   7095
         Left            =   -74760
         TabIndex        =   87
         Top             =   840
         Width           =   10815
         Begin VB.CheckBox Chk_Setteling 
            Caption         =   "Setteling"
            Height          =   255
            Left            =   9360
            TabIndex        =   177
            Top             =   1080
            Width           =   1455
         End
         Begin VB.CommandButton Cmd_Print_Rec 
            Caption         =   "Print Receipts"
            Height          =   375
            Left            =   8640
            TabIndex        =   176
            Top             =   6120
            Width           =   2175
         End
         Begin VB.TextBox Txt_Packlist 
            Height          =   315
            Left            =   4440
            TabIndex        =   91
            Top             =   1080
            Width           =   975
         End
         Begin VB.CheckBox Chk_First4 
            Caption         =   "One of first 4 orders"
            Height          =   255
            Left            =   7200
            TabIndex        =   94
            Top             =   1080
            Width           =   1935
         End
         Begin VB.CommandButton Cmd_Post 
            BackColor       =   &H00FFFF00&
            Caption         =   "Post Transactions"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   9.75
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Left            =   8640
            Style           =   1  'Graphical
            TabIndex        =   105
            TabStop         =   0   'False
            Top             =   6720
            Width           =   2175
         End
         Begin VB.TextBox Txt_TransQty 
            Height          =   315
            Left            =   1920
            TabIndex        =   90
            Top             =   1080
            Width           =   975
         End
         Begin VB.TextBox TxT_CurDam 
            BackColor       =   &H0080FFFF&
            Height          =   315
            Left            =   4440
            Locked          =   -1  'True
            TabIndex        =   98
            TabStop         =   0   'False
            Top             =   720
            Width           =   975
         End
         Begin VB.TextBox Txt_CurQty 
            BackColor       =   &H0080FFFF&
            Height          =   315
            Left            =   1920
            Locked          =   -1  'True
            TabIndex        =   96
            TabStop         =   0   'False
            Top             =   720
            Width           =   975
         End
         Begin VB.CommandButton Cmd_add_trans 
            Caption         =   "Add Transaction"
            Height          =   375
            Left            =   7560
            TabIndex        =   95
            Top             =   1800
            Width           =   1335
         End
         Begin VB.OptionButton Option1 
            Caption         =   "New Receipt"
            Height          =   255
            Index           =   1
            Left            =   5520
            TabIndex        =   93
            Top             =   1080
            Width           =   1455
         End
         Begin VB.OptionButton Option1 
            Caption         =   "Physical Inventory"
            Height          =   255
            Index           =   0
            Left            =   5520
            TabIndex        =   92
            Top             =   720
            Width           =   1815
         End
         Begin VB.ComboBox Cbo_Partno2 
            Height          =   315
            Left            =   1920
            TabIndex        =   88
            Top             =   0
            Width           =   6375
         End
         Begin VB.ComboBox Cbo_Locations2 
            Height          =   315
            ItemData        =   "FRM_Main.frx":01DE
            Left            =   1920
            List            =   "FRM_Main.frx":01E0
            TabIndex        =   89
            Top             =   360
            Width           =   3495
         End
         Begin VB.CommandButton Cmd_Removetrans 
            Caption         =   "Delete Entry"
            Height          =   375
            Left            =   6240
            TabIndex        =   97
            Top             =   1800
            Width           =   1215
         End
         Begin MSFlexGridLib.MSFlexGrid Grid_Transactions 
            Height          =   3495
            Left            =   720
            TabIndex        =   99
            Top             =   2400
            Width           =   9495
            _ExtentX        =   16748
            _ExtentY        =   6165
            _Version        =   393216
            FixedRows       =   0
            FixedCols       =   0
            BackColor       =   16777215
         End
         Begin VB.Label Label 
            Caption         =   "S&&B Packing List"
            Height          =   255
            Index           =   6
            Left            =   3000
            TabIndex        =   138
            Top             =   1140
            Width           =   1335
         End
         Begin VB.Label Label 
            Caption         =   "Click on the colmn header of grid to sort.  Click on the item to modify or remove from grid."
            Height          =   255
            Index           =   7
            Left            =   120
            TabIndex        =   106
            Top             =   6240
            Width           =   7575
         End
         Begin VB.Label Label 
            Caption         =   "Trans Quantity"
            Height          =   255
            Index           =   4
            Left            =   480
            TabIndex        =   104
            Top             =   1140
            Width           =   1215
         End
         Begin VB.Label Label 
            Caption         =   "Current Damaged"
            Height          =   255
            Index           =   5
            Left            =   3000
            TabIndex        =   103
            Top             =   780
            Width           =   1335
         End
         Begin VB.Label Label 
            Caption         =   "Current Onhand"
            Height          =   255
            Index           =   3
            Left            =   360
            TabIndex        =   102
            Top             =   780
            Width           =   1455
         End
         Begin VB.Label Label 
            Caption         =   "Location"
            Height          =   255
            Index           =   2
            Left            =   840
            TabIndex        =   101
            Top             =   420
            Width           =   975
         End
         Begin VB.Label Label 
            Caption         =   "S&&B Part #"
            Height          =   255
            Index           =   1
            Left            =   720
            TabIndex        =   100
            Top             =   60
            Width           =   975
         End
      End
      Begin VB.Frame Fra_Inv_Transfer 
         BorderStyle     =   0  'None
         Height          =   7215
         Left            =   240
         TabIndex        =   79
         Top             =   720
         Width           =   10935
         Begin VB.Frame Fra_Manual 
            Caption         =   "Manual Transfer"
            Height          =   6375
            Left            =   10680
            TabIndex        =   151
            Top             =   240
            Width           =   10575
            Begin VB.TextBox txt_onhand 
               Height          =   285
               Left            =   7080
               TabIndex        =   230
               Top             =   1200
               Width           =   975
            End
            Begin VB.TextBox Txt_Avail 
               Height          =   285
               Left            =   7080
               TabIndex        =   229
               Top             =   840
               Width           =   975
            End
            Begin VB.CommandButton Cmd_Move 
               Caption         =   "Move Inventory"
               Height          =   495
               Left            =   6120
               TabIndex        =   161
               Top             =   1560
               Width           =   3135
            End
            Begin MSFlexGridLib.MSFlexGrid Grid_Tranhist 
               Height          =   2775
               Left            =   480
               TabIndex        =   163
               Top             =   2400
               Width           =   9615
               _ExtentX        =   16960
               _ExtentY        =   4895
               _Version        =   393216
            End
            Begin VB.TextBox Txt_ManQty 
               Height          =   285
               Left            =   2400
               TabIndex        =   160
               Top             =   1560
               Width           =   975
            End
            Begin VB.ComboBox Cbo_ToLocation 
               Height          =   315
               Left            =   2400
               TabIndex        =   158
               Top             =   1200
               Width           =   3615
            End
            Begin VB.ComboBox Cbo_FromLocation 
               Height          =   315
               Left            =   2400
               TabIndex        =   154
               Top             =   840
               Width           =   3615
            End
            Begin VB.ComboBox Cbo_Partno5 
               Height          =   315
               Left            =   2400
               TabIndex        =   153
               Top             =   480
               Width           =   3615
            End
            Begin VB.CommandButton Cmd_Close_man 
               Caption         =   "Close"
               Height          =   615
               Left            =   9000
               TabIndex        =   152
               Top             =   5520
               Width           =   1335
            End
            Begin VB.Label Label 
               Caption         =   "Onhand"
               Height          =   255
               Index           =   67
               Left            =   6120
               TabIndex        =   228
               Top             =   1200
               Width           =   855
            End
            Begin VB.Label Label 
               Caption         =   "Available"
               Height          =   255
               Index           =   60
               Left            =   6120
               TabIndex        =   162
               Top             =   840
               Width           =   1095
            End
            Begin VB.Label Label 
               Caption         =   "Quantity"
               Height          =   255
               Index           =   59
               Left            =   480
               TabIndex        =   159
               Top             =   1560
               Width           =   1215
            End
            Begin VB.Label Label 
               Caption         =   "To Location"
               Height          =   255
               Index           =   58
               Left            =   480
               TabIndex        =   157
               Top             =   1200
               Width           =   1695
            End
            Begin VB.Label Label 
               Caption         =   "From Location"
               Height          =   255
               Index           =   57
               Left            =   480
               TabIndex        =   156
               Top             =   840
               Width           =   1695
            End
            Begin VB.Label Label 
               Caption         =   "S&&B Part Number"
               Height          =   255
               Index           =   56
               Left            =   480
               TabIndex        =   155
               Top             =   480
               Width           =   1695
            End
         End
         Begin VB.CommandButton Cmd_Manual_Trans 
            Caption         =   "Manual Transfer"
            Height          =   495
            Left            =   600
            TabIndex        =   150
            Top             =   6720
            Width           =   2895
         End
         Begin VB.ComboBox Cbo_Locations4 
            Height          =   315
            Left            =   480
            TabIndex        =   149
            Top             =   1680
            Width           =   4815
         End
         Begin VB.ComboBox Cbo_Location4 
            Height          =   315
            Left            =   480
            TabIndex        =   85
            Top             =   3000
            Width           =   4455
         End
         Begin VB.CommandButton Cmd_Process_move 
            Caption         =   "Process Inventory Move"
            Height          =   375
            Left            =   7920
            TabIndex        =   84
            Top             =   3000
            Width           =   1935
         End
         Begin VB.ComboBox Cbo_Base 
            Height          =   315
            Left            =   5160
            TabIndex        =   83
            Top             =   3000
            Width           =   2535
         End
         Begin VB.CommandButton Cmd_Sat_requirements 
            Caption         =   "Satellite Inventory Transfer Report"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   12
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   495
            Left            =   5760
            TabIndex        =   81
            Top             =   2040
            Width           =   4335
         End
         Begin VB.TextBox Txt_Info 
            Height          =   975
            Left            =   480
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   80
            Top             =   240
            Width           =   9615
         End
         Begin MSFlexGridLib.MSFlexGrid Grid_Trans 
            Height          =   2775
            Left            =   120
            TabIndex        =   86
            Top             =   3720
            Width           =   10575
            _ExtentX        =   18653
            _ExtentY        =   4895
            _Version        =   393216
            WordWrap        =   -1  'True
            AllowBigSelection=   0   'False
            ScrollTrack     =   -1  'True
            FillStyle       =   1
            AllowUserResizing=   3
         End
         Begin VB.OptionButton Option1 
            Caption         =   " Fullfill and Damages"
            Height          =   255
            Index           =   4
            Left            =   5520
            TabIndex        =   167
            Top             =   1680
            Width           =   1815
         End
         Begin VB.OptionButton Opt_Damonly 
            Caption         =   "Dameges Only"
            Height          =   255
            Left            =   9000
            TabIndex        =   168
            Top             =   1680
            Width           =   1455
         End
         Begin VB.OptionButton Option1 
            Caption         =   "Fullfilment Only"
            Height          =   255
            Index           =   5
            Left            =   7440
            TabIndex        =   169
            Top             =   1680
            Width           =   1455
         End
         Begin VB.Label Label 
            Caption         =   "Base Location"
            Height          =   255
            Index           =   31
            Left            =   5880
            TabIndex        =   173
            Top             =   2640
            Width           =   1095
         End
         Begin VB.Label Label 
            Caption         =   "Location for Transfer"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   12
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   29
            Left            =   1200
            TabIndex        =   170
            Top             =   1320
            Width           =   3135
         End
         Begin VB.Label Label 
            Caption         =   "Shift and click to remove an unwanted item"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H000000FF&
            Height          =   375
            Index           =   32
            Left            =   360
            TabIndex        =   166
            Top             =   3360
            Width           =   5175
         End
         Begin VB.Label Lbl_sermessage 
            Caption         =   "Click and Enter into the display grid the serial numbers being return to the location.  Seperate multiple units by using a comma"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   9.75
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H000000FF&
            Height          =   615
            Left            =   4080
            TabIndex        =   109
            Top             =   6480
            Width           =   6735
         End
         Begin VB.Label Label 
            Caption         =   "Select a location to complete transfer"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   12
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   30
            Left            =   480
            TabIndex        =   82
            Top             =   2520
            Width           =   5175
         End
      End
      Begin VB.Frame Fra_Location 
         BorderStyle     =   0  'None
         Height          =   1695
         Left            =   -74880
         TabIndex        =   67
         Top             =   720
         Width           =   11055
         Begin VB.ComboBox Cbo_PMSec 
            Height          =   315
            ItemData        =   "FRM_Main.frx":01E2
            Left            =   6240
            List            =   "FRM_Main.frx":0204
            TabIndex        =   74
            Top             =   1080
            Width           =   2175
         End
         Begin VB.ComboBox Cbo_MaintSec 
            Height          =   315
            ItemData        =   "FRM_Main.frx":026E
            Left            =   6240
            List            =   "FRM_Main.frx":02A4
            TabIndex        =   73
            Top             =   720
            Width           =   2175
         End
         Begin VB.TextBox Txt_Description 
            Height          =   285
            Left            =   2640
            MaxLength       =   40
            TabIndex        =   69
            Top             =   360
            Width           =   3375
         End
         Begin VB.TextBox Txt_Name 
            Height          =   285
            Left            =   1440
            MaxLength       =   10
            TabIndex        =   68
            Top             =   360
            Width           =   975
         End
         Begin VB.CommandButton Cmd_SaveLoc 
            Caption         =   "Save/Add Location "
            Height          =   375
            Left            =   9000
            TabIndex        =   76
            Top             =   960
            Width           =   1575
         End
         Begin VB.ComboBox Cbo_LocType 
            Height          =   315
            ItemData        =   "FRM_Main.frx":034A
            Left            =   1440
            List            =   "FRM_Main.frx":034C
            TabIndex        =   71
            Top             =   720
            Width           =   2655
         End
         Begin VB.ComboBox Cbo_Line 
            Height          =   315
            ItemData        =   "FRM_Main.frx":034E
            Left            =   1440
            List            =   "FRM_Main.frx":0350
            TabIndex        =   72
            Top             =   1080
            Width           =   2655
         End
         Begin VB.Label Label1 
            Caption         =   "PM-Maintenance Section"
            Height          =   255
            Index           =   4
            Left            =   4200
            TabIndex        =   179
            Top             =   1080
            Width           =   2055
         End
         Begin VB.Label Label1 
            Caption         =   "Maintenance Section"
            Height          =   255
            Index           =   3
            Left            =   4200
            TabIndex        =   178
            Top             =   720
            Width           =   1695
         End
         Begin VB.Label Label1 
            Caption         =   "Location ID"
            Height          =   255
            Index           =   0
            Left            =   240
            TabIndex        =   77
            Top             =   360
            Width           =   975
         End
         Begin VB.Label Label1 
            Caption         =   "Location Type"
            Height          =   255
            Index           =   1
            Left            =   240
            TabIndex        =   75
            Top             =   840
            Width           =   1215
         End
         Begin VB.Label Label1 
            Caption         =   "MBTA Line"
            Height          =   255
            Index           =   2
            Left            =   240
            TabIndex        =   70
            Top             =   1200
            Width           =   975
         End
      End
      Begin VB.PictureBox Picture1 
         Height          =   5895
         Left            =   -73560
         Picture         =   "FRM_Main.frx":0352
         ScaleHeight     =   5835
         ScaleWidth      =   8715
         TabIndex        =   51
         Top             =   2040
         Width           =   8775
      End
      Begin VB.Frame FRM_Newpart 
         BackColor       =   &H0080FFFF&
         Caption         =   "Add S&&B part number to catalogue"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   3495
         Left            =   -63840
         TabIndex        =   33
         Top             =   960
         Width           =   10575
         Begin VB.ListBox Lst_UsedIn 
            Height          =   1230
            Index           =   1
            ItemData        =   "FRM_Main.frx":A432C
            Left            =   1920
            List            =   "FRM_Main.frx":A432E
            MultiSelect     =   2  'Extended
            TabIndex        =   205
            Top             =   1200
            Width           =   1695
         End
         Begin VB.ComboBox Cbo_Parttype 
            Height          =   315
            Index           =   1
            ItemData        =   "FRM_Main.frx":A4330
            Left            =   1920
            List            =   "FRM_Main.frx":A4343
            TabIndex        =   203
            Top             =   840
            Width           =   1695
         End
         Begin VB.CommandButton Cmd_ExitNP 
            Caption         =   "Exit"
            Height          =   495
            Left            =   8880
            TabIndex        =   37
            Top             =   2040
            Width           =   1095
         End
         Begin VB.CommandButton cmd_savepart 
            Caption         =   "Save New Part"
            Height          =   495
            Left            =   8880
            TabIndex        =   36
            Top             =   2760
            Width           =   1095
         End
         Begin VB.TextBox Txt_NewDesc 
            Height          =   285
            Left            =   4680
            TabIndex        =   35
            Top             =   480
            Width           =   4695
         End
         Begin VB.TextBox Txt_NewPart 
            Height          =   285
            Left            =   1920
            TabIndex        =   34
            Top             =   480
            Width           =   1695
         End
         Begin VB.Label Label 
            Alignment       =   2  'Center
            BackColor       =   &H0080FFFF&
            Caption         =   "Used In (Multiselect)"
            Height          =   495
            Index           =   63
            Left            =   720
            TabIndex        =   204
            Top             =   1320
            Width           =   855
         End
         Begin VB.Label Label 
            BackColor       =   &H0080FFFF&
            Caption         =   "Part Type"
            Height          =   255
            Index           =   62
            Left            =   840
            TabIndex        =   202
            Top             =   840
            Width           =   975
         End
         Begin VB.Label Label 
            BackColor       =   &H0080FFFF&
            Caption         =   "Desc"
            Height          =   255
            Index           =   28
            Left            =   3720
            TabIndex        =   39
            Top             =   480
            Width           =   615
         End
         Begin VB.Label Label 
            BackColor       =   &H0080FFFF&
            Caption         =   "P/N"
            Height          =   255
            Index           =   27
            Left            =   1320
            TabIndex        =   38
            Top             =   480
            Width           =   375
         End
      End
      Begin VB.CommandButton Cmd_addpart 
         Caption         =   "Add New S&&B Part"
         Height          =   495
         Left            =   -66480
         TabIndex        =   32
         Top             =   960
         Width           =   2055
      End
      Begin VB.ComboBox Cbo_RLS 
         Height          =   315
         Left            =   -73080
         TabIndex        =   8
         Top             =   3120
         Width           =   1935
      End
      Begin VB.ComboBox Cbo_RLB 
         Height          =   315
         ItemData        =   "FRM_Main.frx":A435F
         Left            =   -73080
         List            =   "FRM_Main.frx":A4361
         TabIndex        =   7
         Top             =   2760
         Width           =   1935
      End
      Begin VB.TextBox Txt_MinROP 
         Height          =   285
         Left            =   -70440
         TabIndex        =   5
         Top             =   1680
         Width           =   855
      End
      Begin VB.TextBox Txt_MaxROP 
         Height          =   285
         Left            =   -72360
         TabIndex        =   4
         Top             =   1680
         Width           =   855
      End
      Begin VB.CommandButton cmd_oem_search 
         Caption         =   "OEM Search"
         Height          =   255
         Left            =   -68160
         TabIndex        =   31
         Top             =   1350
         Width           =   1215
      End
      Begin VB.Frame FRM_PMovement 
         BackColor       =   &H0080FFFF&
         Caption         =   "Part Movement"
         Height          =   2055
         Left            =   -74280
         TabIndex        =   22
         Top             =   4920
         Width           =   9135
         Begin VB.OptionButton Option1 
            BackColor       =   &H0080FFFF&
            Caption         =   "Return Working Part"
            Height          =   255
            Index           =   9
            Left            =   2160
            TabIndex        =   26
            Top             =   720
            Width           =   2055
         End
         Begin VB.OptionButton Option1 
            BackColor       =   &H0080FFFF&
            Caption         =   "Unreserve this part"
            Height          =   255
            Index           =   8
            Left            =   2160
            TabIndex        =   24
            Top             =   360
            Width           =   2055
         End
         Begin VB.ComboBox Cbo_Locations 
            Height          =   315
            ItemData        =   "FRM_Main.frx":A4363
            Left            =   3360
            List            =   "FRM_Main.frx":A4365
            TabIndex        =   28
            Top             =   1080
            Width           =   3495
         End
         Begin VB.CommandButton Cmd_PM_Close 
            Caption         =   "Close"
            Height          =   375
            Left            =   7680
            TabIndex        =   30
            Top             =   1320
            Width           =   1095
         End
         Begin VB.CommandButton Cmd_PM_Submit 
            Caption         =   "Submit"
            Height          =   375
            Left            =   7680
            TabIndex        =   29
            Top             =   360
            Width           =   1095
         End
         Begin VB.OptionButton Option1 
            BackColor       =   &H0080FFFF&
            Caption         =   "Return damage part to this location"
            Height          =   255
            Index           =   10
            Left            =   240
            TabIndex        =   27
            Top             =   1080
            Width           =   2895
         End
         Begin VB.OptionButton Option1 
            BackColor       =   &H0080FFFF&
            Caption         =   "Take this part"
            Height          =   255
            Index           =   7
            Left            =   240
            TabIndex        =   25
            Top             =   720
            Width           =   1815
         End
         Begin VB.OptionButton Option1 
            BackColor       =   &H0080FFFF&
            Caption         =   "Reserve this part"
            Height          =   255
            Index           =   6
            Left            =   240
            TabIndex        =   23
            Top             =   360
            Width           =   1815
         End
      End
      Begin VB.CommandButton cmd_save_inv 
         Caption         =   "Save Changes"
         Height          =   615
         Left            =   -66720
         TabIndex        =   13
         Top             =   4080
         Width           =   1095
      End
      Begin VB.TextBox Txt_Notes 
         Height          =   1095
         Left            =   -73080
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   12
         Text            =   "FRM_Main.frx":A4367
         Top             =   3600
         Width           =   6135
      End
      Begin VB.ComboBox Cbo_Partno 
         Height          =   315
         Left            =   -73080
         TabIndex        =   1
         Top             =   960
         Width           =   6375
      End
      Begin VB.TextBox Txt_CurrCost 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   -73080
         TabIndex        =   6
         Top             =   2400
         Width           =   1575
      End
      Begin VB.TextBox Txt_Altpart 
         Height          =   285
         Left            =   -73080
         TabIndex        =   2
         Top             =   1320
         Width           =   1575
      End
      Begin VB.Frame Fra_Sat_avail 
         Height          =   975
         Left            =   -68640
         TabIndex        =   19
         Top             =   1680
         Width           =   4935
         Begin VB.CheckBox Chk_Franklinharvard 
            Caption         =   "Franklin && Harvard"
            Height          =   195
            Left            =   3120
            TabIndex        =   180
            Top             =   600
            Width           =   1695
         End
         Begin VB.CheckBox Chk_Franklin 
            Caption         =   "Franklin only"
            Height          =   195
            Left            =   3120
            TabIndex        =   164
            Top             =   240
            Width           =   1335
         End
         Begin VB.TextBox Txt_SatQty 
            Height          =   285
            Left            =   2280
            TabIndex        =   11
            Top             =   570
            Width           =   735
         End
         Begin VB.OptionButton Option1 
            Caption         =   "No"
            Height          =   255
            Index           =   3
            Left            =   2400
            TabIndex        =   10
            Top             =   240
            Width           =   735
         End
         Begin VB.OptionButton Option1 
            Caption         =   "Yes"
            Height          =   255
            Index           =   2
            Left            =   1680
            TabIndex        =   9
            Top             =   240
            Width           =   855
         End
         Begin VB.Label Label 
            Caption         =   "Desired onhand in Satellite"
            Height          =   255
            Index           =   22
            Left            =   120
            TabIndex        =   21
            Top             =   600
            Width           =   2055
         End
         Begin VB.Label Label 
            Caption         =   "Available in Satellite"
            Height          =   255
            Index           =   61
            Left            =   120
            TabIndex        =   20
            Top             =   240
            Width           =   1695
         End
      End
      Begin VB.TextBox Txt_OemPart 
         Height          =   285
         Left            =   -70440
         TabIndex        =   3
         Top             =   1320
         Width           =   1575
      End
      Begin MSFlexGridLib.MSFlexGrid Grid_Equip 
         Height          =   4215
         Left            =   -74880
         TabIndex        =   16
         Top             =   3240
         Width           =   11175
         _ExtentX        =   19711
         _ExtentY        =   7435
         _Version        =   393216
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin MSFlexGridLib.MSFlexGrid Grid_LocBal 
         Height          =   2655
         Left            =   -74400
         TabIndex        =   40
         Top             =   4800
         Width           =   10695
         _ExtentX        =   18865
         _ExtentY        =   4683
         _Version        =   393216
      End
      Begin MSFlexGridLib.MSFlexGrid Grid_Loc 
         Height          =   5055
         Left            =   -74520
         TabIndex        =   78
         Top             =   2640
         Width           =   10215
         _ExtentX        =   18018
         _ExtentY        =   8916
         _Version        =   393216
         ScrollTrack     =   -1  'True
      End
      Begin MSFlexGridLib.MSFlexGrid Grid_Tech 
         Height          =   5175
         Left            =   -74400
         TabIndex        =   108
         Top             =   2520
         Width           =   7005
         _ExtentX        =   12356
         _ExtentY        =   9128
         _Version        =   393216
         FixedRows       =   0
         FixedCols       =   0
      End
      Begin MSFlexGridLib.MSFlexGrid Grid_WB 
         Height          =   3975
         Left            =   -74640
         TabIndex        =   122
         Top             =   4080
         Width           =   10815
         _ExtentX        =   19076
         _ExtentY        =   7011
         _Version        =   393216
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
      Begin VB.ListBox Lst_UsedIn 
         Height          =   1035
         Index           =   0
         ItemData        =   "FRM_Main.frx":A4369
         Left            =   -70440
         List            =   "FRM_Main.frx":A4370
         TabIndex        =   174
         Top             =   2040
         Width           =   1695
      End
      Begin VB.ComboBox Cbo_Parttype 
         Height          =   315
         Index           =   0
         ItemData        =   "FRM_Main.frx":A4380
         Left            =   -73080
         List            =   "FRM_Main.frx":A4396
         TabIndex        =   114
         Top             =   2040
         Width           =   1575
      End
      Begin VB.TextBox Txt_OrigOrd 
         BackColor       =   &H0080FFFF&
         Height          =   285
         Left            =   -65400
         Locked          =   -1  'True
         TabIndex        =   112
         Top             =   2640
         Width           =   855
      End
      Begin VB.TextBox Txt_Received 
         BackColor       =   &H0080FFFF&
         Height          =   285
         Left            =   -65400
         Locked          =   -1  'True
         TabIndex        =   137
         Top             =   3000
         Width           =   855
      End
      Begin VB.TextBox Txt_Usage 
         BackColor       =   &H0080FFFF&
         Height          =   285
         Left            =   -65400
         Locked          =   -1  'True
         TabIndex        =   113
         Top             =   3360
         Width           =   855
      End
      Begin VB.TextBox Txt_Setteling 
         BackColor       =   &H0080FFFF&
         Height          =   285
         Left            =   -65400
         Locked          =   -1  'True
         TabIndex        =   171
         Top             =   3720
         Width           =   855
      End
      Begin VB.Label Label 
         Caption         =   "Used In"
         Height          =   255
         Index           =   21
         Left            =   -71400
         TabIndex        =   175
         Top             =   2160
         Width           =   735
      End
      Begin VB.Label Label 
         Caption         =   "Setteling"
         Height          =   255
         Index           =   26
         Left            =   -66600
         TabIndex        =   172
         Top             =   3720
         Width           =   1095
      End
      Begin VB.Label Label 
         Caption         =   "Click on the Serial number in the grid that you beleive the Component to be.  Of click on :Add Component to Work bench"""
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   855
         Index           =   55
         Left            =   -74160
         TabIndex        =   148
         Top             =   7080
         Width           =   5775
      End
      Begin VB.Label Label 
         Caption         =   "Received"
         Height          =   255
         Index           =   24
         Left            =   -66600
         TabIndex        =   136
         Top             =   3030
         Width           =   1095
      End
      Begin VB.Label Label 
         Caption         =   "Usage to date"
         Height          =   255
         Index           =   25
         Left            =   -66600
         TabIndex        =   111
         Top             =   3390
         Width           =   1095
      End
      Begin VB.Label Label 
         Caption         =   "Original Orders"
         Height          =   255
         Index           =   23
         Left            =   -66600
         TabIndex        =   110
         Top             =   2670
         Width           =   1095
      End
      Begin VB.Label Label 
         Caption         =   "Click on the colmn header of grid to sort.  Click on the item to modify or remove from grid."
         Height          =   255
         Index           =   48
         Left            =   -74040
         TabIndex        =   107
         Top             =   7680
         Width           =   6495
      End
      Begin VB.Label Label 
         Caption         =   " FVM and Gate / Component and spare parts tracking"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   14.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   10
         Left            =   -72840
         TabIndex        =   53
         Top             =   1560
         Width           =   7575
      End
      Begin VB.Label Label 
         Caption         =   "Automated Fare Collection's "
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   14.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   11
         Left            =   -71040
         TabIndex        =   52
         Top             =   1080
         Width           =   4215
      End
      Begin VB.Label Label 
         Caption         =   "Minimum"
         Height          =   255
         Index           =   20
         Left            =   -71400
         TabIndex        =   50
         Top             =   1710
         Width           =   735
      End
      Begin VB.Label Label 
         Caption         =   "OEM Part #"
         Height          =   255
         Index           =   19
         Left            =   -71400
         TabIndex        =   49
         Top             =   1350
         Width           =   975
      End
      Begin VB.Label Label 
         Caption         =   "Shelf Location Satellite"
         Height          =   255
         Index           =   17
         Left            =   -74880
         TabIndex        =   48
         Top             =   3120
         Width           =   1695
      End
      Begin VB.Label Label 
         Caption         =   "Rack Location Base"
         Height          =   255
         Index           =   16
         Left            =   -74640
         TabIndex        =   47
         Top             =   2760
         Width           =   1575
      End
      Begin VB.Label Label 
         Caption         =   "Reorder Points              Max"
         Height          =   255
         Index           =   13
         Left            =   -74640
         TabIndex        =   46
         Top             =   1710
         Width           =   2295
      End
      Begin VB.Label Label 
         Caption         =   "Notes"
         Height          =   255
         Index           =   18
         Left            =   -74640
         TabIndex        =   45
         Top             =   3600
         Width           =   975
      End
      Begin VB.Label Label 
         Caption         =   "Current Cost"
         Height          =   255
         Index           =   15
         Left            =   -74640
         TabIndex        =   44
         Top             =   2400
         Width           =   975
      End
      Begin VB.Label Label 
         Caption         =   "Alternate S&&B Part #"
         Height          =   255
         Index           =   12
         Left            =   -74640
         TabIndex        =   43
         Top             =   1350
         Width           =   1575
      End
      Begin VB.Label Label 
         Caption         =   "Part Type"
         Height          =   255
         Index           =   14
         Left            =   -74640
         TabIndex        =   42
         Top             =   2040
         Width           =   975
      End
      Begin VB.Label Label2 
         Caption         =   "S&&B Part #"
         Height          =   255
         Index           =   0
         Left            =   -74640
         TabIndex        =   41
         Top             =   960
         Width           =   1095
      End
      Begin VB.Label Label 
         Caption         =   "Click on the colmn header of grid to sort.  Click on the item to modify or remove from grid."
         Height          =   255
         Index           =   52
         Left            =   -74760
         TabIndex        =   18
         Top             =   7800
         Width           =   6375
      End
      Begin VB.Label Label 
         Caption         =   "Click on the colmn header of grid to sort.  Click on the item to modify or remove from grid."
         Height          =   255
         Index           =   47
         Left            =   -74400
         TabIndex        =   17
         Top             =   7680
         Width           =   7455
      End
   End
   Begin VB.Label Label 
      Alignment       =   1  'Right Justify
      Caption         =   "Incident #"
      Height          =   255
      Index           =   51
      Left            =   840
      TabIndex        =   195
      Top             =   4560
      Width           =   1815
   End
   Begin VB.Label Label 
      Caption         =   "Last name"
      Height          =   255
      Index           =   53
      Left            =   3840
      TabIndex        =   116
      Top             =   2280
      Width           =   975
   End
   Begin VB.Label LBL_Station 
      Caption         =   "Station"
      Height          =   255
      Left            =   7560
      TabIndex        =   14
      Top             =   480
      Width           =   3135
   End
   Begin VB.Label LBL_ID 
      Caption         =   "User"
      Height          =   255
      Left            =   7560
      TabIndex        =   0
      Top             =   120
      Width           =   3135
   End
   Begin VB.Menu File 
      Caption         =   "File"
      WindowList      =   -1  'True
      Begin VB.Menu Logout 
         Caption         =   "Logout"
      End
      Begin VB.Menu Exit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu Data 
      Caption         =   "Data"
      Begin VB.Menu Location_primer 
         Caption         =   "Generate Parts list for location"
      End
      Begin VB.Menu Parts 
         Caption         =   "Parts"
      End
   End
   Begin VB.Menu Reports 
      Caption         =   "Reports"
      Begin VB.Menu Location_Inventorymenu 
         Caption         =   "Location Inventory"
         Begin VB.Menu Mastercomplist 
            Caption         =   "Master Component List"
         End
         Begin VB.Menu Location_Inventory 
            Caption         =   "Inventory By Location"
         End
         Begin VB.Menu Inv_phys 
            Caption         =   "Inventory Physical Report"
         End
      End
      Begin VB.Menu Tech_list 
         Caption         =   "Technicians"
      End
      Begin VB.Menu Tran_History 
         Caption         =   "Transaction History"
      End
      Begin VB.Menu workbench_rpt 
         Caption         =   "Work Bench Reporting"
      End
      Begin VB.Menu inv 
         Caption         =   "Inventory receipts Reconciliation"
         Begin VB.Menu INV_Open 
            Caption         =   "Inventory receipts Reconciliation (Open)"
         End
         Begin VB.Menu Inv_All 
            Caption         =   "Inventory receipts Reconciliation (All)"
         End
      End
      Begin VB.Menu FVM_Gate 
         Caption         =   "Equipment Reporting"
         Begin VB.Menu FVM_Summ 
            Caption         =   "Summary Report"
         End
         Begin VB.Menu FVM_Detail 
            Caption         =   "Detailed"
         End
      End
      Begin VB.Menu IncidentReporting 
         Caption         =   "Incident Reporting"
         Begin VB.Menu DetailedListing 
            Caption         =   "Detailed Listing"
         End
         Begin VB.Menu TotalDefectsBy 
            Caption         =   "Total # Defects By:"
         End
         Begin VB.Menu Meantimetorepair 
            Caption         =   "Mean time to repair"
         End
      End
      Begin VB.Menu Damage_Report 
         Caption         =   "Runner's Damage Report"
      End
      Begin VB.Menu CRS_Status 
         Caption         =   "CRS Status Report"
      End
   End
   Begin VB.Menu maintenance 
      Caption         =   "Maintenance"
      Begin VB.Menu ChangePassword 
         Caption         =   "Change Password"
      End
      Begin VB.Menu PW_Reset 
         Caption         =   "Reset Password"
      End
      Begin VB.Menu res_remove 
         Caption         =   "Remove reservations"
      End
      Begin VB.Menu Funding_Maint 
         Caption         =   "State and Federal Funding"
      End
   End
   Begin VB.Menu Incidents 
      Caption         =   "Incident System"
      Begin VB.Menu Generate_Subway 
         Caption         =   "Generate S&B File Subway"
      End
      Begin VB.Menu Geterate_Farebox 
         Caption         =   "Generate S&B File Farebox"
      End
      Begin VB.Menu CreateRST_Excel 
         Caption         =   "Create RST Excel Sheet"
      End
      Begin VB.Menu Incidentcodemaint 
         Caption         =   "Incident Code Maint"
      End
      Begin VB.Menu Import_MRI 
         Caption         =   "Import Money Room Info"
      End
      Begin VB.Menu Inc_inv_missmatch 
         Caption         =   "Incident Inventory Missmatch"
      End
   End
   Begin VB.Menu Workbench 
      Caption         =   "Workbench"
      Begin VB.Menu Component_Usage 
         Caption         =   "WorkBench Component Usage"
      End
   End
End
Attribute VB_Name = "FRM_Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Option Explicit
Dim KeyAscii As Long
Dim LG_GridIdx As Long
Dim LG_GridCol As Long
Dim sline As String
Dim Tech_flag As String
Dim ent_part As String
Dim Ent_Loc As String
Dim hold_keyascii As Long
Dim position As Long
Dim Primer As String
Dim Dprimer As Long
Dim Contrl As Control
Dim step As Long
Dim last_id As Long
Dim Vdate As Date
Dim icol As Long
Dim Edata As String
Dim Master_Base As Long
Dim idx As Integer
Dim Cnt As Long
Dim Trans_cnt As Long
Dim Hold_Serial As String
Dim Hold_Date As Date
Dim Hold_partno As Long
Dim label_part As Long
Dim Label_serial As Long
Dim Ipol_date As Date
Dim Equip_Opt As Long

Private Sub Cbo_FromLocation_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(Ent_Loc) <= 1 Then
            ent_part = ""
            Cbo_FromLocation.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    Ent_Loc = Ent_Loc & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_FromLocation, KeyAscii, True)

End Sub

Private Sub Cbo_FromLocation_Validate(Cancel As Boolean)
If Cbo_Partno5.ListIndex = -1 Then Exit Sub
    sSql = "select alb_onhand, alb_damaged from afc_locbalance where alb_location = " & Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    Call Get_Trans("Read")
    If RS_Trans.EOF = True Then
        MsgBox ("This part is not available from this location."), vbOKOnly
        Cbo_FromLocation.ListIndex = -1
        Exit Sub
    End If
    If Current_User_Branch = 3 And Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) <> 512 Then
        Txt_Avail.Text = RS_Trans("alb_Damaged")
        Label(60).Caption = "Damages"
        Cbo_ToLocation.ListIndex = 5
    Else
        Txt_Avail.Text = RS_Trans("alb_onhand")
    End If
    Call Get_Trans("Close")

End Sub

Private Sub Cbo_Line_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Line.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Line, KeyAscii, True)
End Sub

Private Sub Cbo_Location4_Click()
    Call Load_Grid_Trans
    
End Sub

Private Sub Cbo_Locations2_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(Ent_Loc) <= 1 Then
            Ent_Loc = ""
            Cbo_Locations2.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    Ent_Loc = Ent_Loc & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Locations2, KeyAscii, True)
End Sub

Private Sub Cbo_Locations2_Validate(Cancel As Boolean)
    If Cbo_Partno2.Text <> "" And Cbo_Locations2.Text <> "" Then
        sSql = "select * from AFC_Locbalance where aLb_location = " & Cbo_Locations2.ItemData(Cbo_Locations2.ListIndex) & " and alb_partno = " & Cbo_Partno2.ItemData(Cbo_Partno2.ListIndex)
        Call Get_LocInventory("Read")
        If RS_LocInventory.EOF Then
            Txt_CurQty.Text = 0
            TxT_CurDam.Text = 0
        Else
            Txt_CurQty.Text = RS_LocInventory("alb_onhand")
            TxT_CurDam.Text = RS_LocInventory("alb_damaged")
        End If
    
        Get_LocInventory ("Close")
    End If
End Sub



Private Sub Cbo_Locations3_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Locations3.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Locations3, KeyAscii, True)

End Sub



Private Sub Cbo_LocType_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_LocType.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_LocType, KeyAscii, True)
End Sub

Private Sub Cbo_LocType_Validate(Cancel As Boolean)
    If Cbo_LocType.ListIndex = -1 Then
        Cbo_Line.Locked = True
        Exit Sub
    End If
    If Cbo_LocType.ItemData(Cbo_LocType.ListIndex) = 5 Or Cbo_LocType.ItemData(Cbo_LocType.ListIndex) = 19 Or Cbo_LocType.ItemData(Cbo_LocType.ListIndex) = 20 Then
        Cbo_Line.Locked = False
    Else
        Cbo_Line.Locked = True
    End If
End Sub

Private Sub Cbo_Partno2_Validate(Cancel As Boolean)
    'If Cbo_Partno2.ListIndex = -1 Then Exit Sub
    'sSql = "select ai_satellite from AFC_Inventory where ai_index = " & Cbo_Partno2.ItemData(Cbo_Partno2.ListIndex)
    'Call Get_Trans("Read")
    'If RS_Trans("ai_satellite") <> "Y" Then
    '    Cbo_Locations2.ListIndex = 0
    '    Cbo_Locations2.Locked = True
    '    Txt_TransQty.SetFocus
    'Else
        Cbo_Locations2.Locked = False
        If Cbo_Locations2.ListIndex <> -1 Then Txt_TransQty.SetFocus
   'End If
'    RS_Trans.Close
'    Set RS_Trans = Nothing
'        sSql = "select * from afc_phyreceipt where apr_partno=" & Cbo_Partno2.ItemData(Cbo_Partno2.ListIndex)
'        Call Get_Trans("Read")

End Sub

Private Sub Cbo_Partno3_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Partno3.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Partno3, KeyAscii, True)
End Sub

Private Sub Cbo_Partno4_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Partno4.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Partno4, KeyAscii, True)
    
End Sub



Private Sub Cbo_Partno5_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Partno5.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Partno5, KeyAscii, True)

End Sub

Private Sub Cbo_Partno5_Validate(Cancel As Boolean)
    Txt_Avail.Text = ""
End Sub

Private Sub Cbo_RLB_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        Cbo_RLB.Text = ""
        Exit Sub
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    KeyAscii = AutoFind(Cbo_RLB, KeyAscii, True)
End Sub

Private Sub Cbo_RLS_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        Cbo_RLB.Text = ""
        Exit Sub
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    KeyAscii = AutoFind(Cbo_RLB, KeyAscii, True)
End Sub

Private Sub Cbo_ToLocation_KeyPress(KeyAscii As Integer)
    
    If KeyAscii = 8 Then
        If Len(Ent_Loc) <= 1 Then
            ent_part = ""
            Cbo_ToLocation.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    Ent_Loc = Ent_Loc & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_ToLocation, KeyAscii, True)

End Sub

Private Sub CD_Report_Click()
   Report_Name = "Open Damages"
    Frm_RptViewer.Show vbModal
    Report_Name = ""
End Sub

Private Sub Cbo_ToLocation_Validate(Cancel As Boolean)
    If Cbo_ToLocation.ListIndex = -1 Then Exit Sub
    If Current_User_Branch = 3 And Cbo_ToLocation.ListIndex <> 5 Then
    sSql = "select alb_onhand, isnull(alb_maximum,0) as alb_maximum from afc_locbalance where alb_location = " & Cbo_ToLocation.ItemData(Cbo_ToLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    Call Get_Trans("Read")
    If RS_Trans.EOF = True Then
        MsgBox ("This part is not available from this location."), vbOKOnly
        Cbo_FromLocation.ListIndex = -1
        Exit Sub
    End If
        Techs_Allowed_Qty = RS_Trans("alb_maximum") - RS_Trans("alb_onhand")
    If Techs_Allowed_Qty <= 0 Then
        MsgBox ("You are past the maximum qty for this Part type"), vbOKOnly
        Cbo_Partno5.ListIndex = -1
        Cbo_FromLocation.ListIndex = -1
        Cbo_ToLocation.ListIndex = -1
        Txt_Avail.Text = ""
        Exit Sub
    End If
    txt_onhand.Text = RS_Trans("alb_onhand")
    Call Get_Trans("Close")
    End If
End Sub

Private Sub ChangePassword_Click()
'Launch the password maintenance form
    PW_Option = "Change"
    Frm_Login.Show vbModal
    
End Sub

Private Sub Cbo_Partno_Click()
    If KeyAscii = 0 And hold_keyascii = 0 Then
            SendKeys "{TAB}"
    End If
End Sub
Private Sub Cbo_Partno2_Click()
    If KeyAscii = 0 And hold_keyascii = 0 Then
            SendKeys "{TAB}"
    End If
End Sub
Private Sub Cbo_Partno2_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Partno2.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Partno2, KeyAscii, True)

End Sub
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

Private Sub Cbo_Partno_Validate(Cancel As Boolean)
    hold_keyascii = 0
    If Len(Trim(Cbo_Partno.Text)) < 1 Or Cbo_Partno.ListIndex = -1 Then
        Exit Sub
    End If
    
    sSql = "select * from afc_inventory where ai_index = " & Cbo_Partno.ItemData(Cbo_Partno.ListIndex)
    Call Get_Inventory("Read")
    If RS_Inventory.EOF = True Then
        MsgBox ("Selected item not found in the Inventory Table"), vbOKOnly
        Call Get_Inventory("Close")
    End If
    Call Display_Part_Data

End Sub
Public Sub Display_Part_Data()

'**********************************************************************
' move data to temp values
    
    Call PGBLRecToTemp_afc_inventory(RS_Inventory)
    Txt_MaxROP.Text = ""
        sSql = "SELECT DISTINCT ATH_Partno, ISNULL((SELECT SUM(ATH_Qty) AS Expr1 FROM AFC_Transaction_History " & _
            "WHERE ISNULL(ATH_First4,' ') = 'Y' AND ATH_Partno = c.ATH_Partno), 0) AS received, " & _
            "ISNULL((SELECT SUM(ATH_Qty) AS Expr1 FROM AFC_Transaction_History " & _
            "WHERE ISNULL(ATH_First4,' ') = 'Y' AND ISNULL(ATH_Setteling,' ') = 'Y' AND ATH_Partno = c.ATH_Partno), 0) AS setteling " & _
            "FROM AFC_Transaction_History as c Where ATH_Partno = " & tAI_Index
    Call Get_Trans("Read")

    Txt_Altpart.Text = tAI_AltPartno
    Txt_OemPart.Text = tAI_OEMPartno
    Txt_CurrCost.Text = FormatCurrency(tAI_CurrentCost, 2)
    Txt_MaxROP.Text = tAI_MaxROP
    Txt_MinROP.Text = tAI_MinROP
    Txt_OrigOrd.Text = tAI_Order1 + tAI_Order2 + tAI_Order3 + tAI_Order4 + tAI_Tom_Order + tAI_Scim_Order + tAI_Order_Other + tAI_Farebox_Order1 + tAI_Farebox_Order2 + tAI_FMV_Order
    If RS_Trans.EOF = False Then
        Txt_Received.Text = RS_Trans("Received")
        Txt_Setteling.Text = tAI_SettelingSB - RS_Trans("Setteling")
    Else
        Txt_Received.Text = 0
        Txt_Setteling.Text = tAI_SettelingSB
    End If
    Txt_Usage.Text = tAI_Usage
    Cbo_Parttype(0).Text = tAI_PartType
    
    Cbo_RLB.ListIndex = -1
    Cbo_RLS.ListIndex = -1
    Call Get_Trans("Close")
    If IsNull(tAI_RLBase) = False And tAI_RLBase <> 0 Then
    For step = 0 To Cbo_RLB.ListCount
        If Cbo_RLB.ItemData(step) = tAI_RLBase Then
            Cbo_RLB.ListIndex = step
            step = Cbo_RLB.ListCount
        End If
    Next
    End If
    If IsNull(tAI_RLSatellite) = False And tAI_RLSatellite <> 0 Then
    For step = 0 To Cbo_RLS.ListCount
        If Cbo_RLS.ItemData(step) = tAI_RLSatellite Then
            Cbo_RLS.ListIndex = step
            step = Cbo_RLS.ListCount
        End If
    Next
    End If
    
    Txt_Notes.Text = IIf(IsNull(RS_Inventory("AI_Notes")) = True, " ", RS_Inventory("AI_Notes"))
    If tAI_Satellite = "Y" Or tAI_Satellite = "F" Then
        Option1(2) = True
        Txt_SatQty.Text = tAI_Required
    Else
        Option1(3) = True
        Txt_SatQty.Text = ""
    End If
    If tAI_Satellite = "F" Then
        Chk_Franklin.Value = 1
    Else
        Chk_Franklin.Value = 0
    End If
    If tAI_Satellite = "H" Then
        Chk_Franklinharvard.Value = 1
    Else
        Chk_Franklinharvard.Value = 0
    End If
    sSql = "SELECT APTabrv FROM AFC_Where_Used " & _
    "LEFT OUTER JOIN AFC_Parttypes ON AWU_Equiptype = APTidx " & _
    "LEFT OUTER JOIN AFC_Inventory ON AWU_Partno = AI_Index " & _
    "Where AWU_Partno = " & tAI_Index & "ORDER BY APTidx"
    Call Get_Trans("Read")
    Lst_UsedIn(0).Clear
    
    Do While RS_Trans.EOF = False
        Lst_UsedIn(0).AddItem RS_Trans("aptabrv")
        RS_Trans.MoveNext
    Loop
    
    Call Load_Grid_LocBal

End Sub
Public Sub Load_Grid_LocBal()
Dim Tot_Onhand As Long
Dim Tot_Damage As Long
Dim Tot_Reserve As Long
Dim dis_loc As String
Dim WorkB As Long
Dim dis_names As String

    Call Grid_LocBal_Init
    sSql = "select al.al_abrv, al.al_location_name, alb.alb_location, alb.alb_onhand, alb.alb_damaged, alb.alb_reserve from afc_locbalance alb "
    sSql = sSql & " left outer join afc_location al on alb.alb_location = al.al_id where alb.alb_partno=" & tAI_Index
    Call Get_LocInventory("Read")
    If RS_LocInventory.EOF = True Then
        MsgBox ("There arn't any locations with the requested part"), vbOKOnly
        Call Get_LocInventory("Close")
        Exit Sub
    End If
    Tot_Onhand = 0
    Tot_Damage = 0
    Do While RS_LocInventory.EOF = False
        dis_loc = Trim(RS_LocInventory("al_abrv")) & "  " & Trim(RS_LocInventory("al_location_name"))
        sSql = "select ate.at_emplname, ate.at_empfname from afc_technicians ate " & _
                "left outer join afc_transaction_history ath on ate.at_id = ath.ath_empno " & _
                "where ath.ath_tran_type = 1 and isnull(ath.ath_closed,0) <> 1 and ath.ath_partno =" & tAI_Index & _
                " and ath.ath_location = " & RS_LocInventory("alb_location")
        Call Get_Trans("Read")
        dis_names = ""
        Do While RS_Trans.EOF = False
            dis_names = dis_names & Trim(RS_Trans("at_emplname")) & " " & Mid(RS_Trans("at_empfname"), 1, 1) & ", "
            RS_Trans.MoveNext
        Loop
        
        RS_Trans.Close
        Set RS_Trans = Nothing
        
        sline = RS_LocInventory("alb_location") & vbTab & _
        dis_loc & vbTab & _
        RS_LocInventory("alb_reserve") & vbTab & _
        RS_LocInventory("alb_onhand") & vbTab & _
        RS_LocInventory("alb_damaged") & vbTab & _
        "" & vbTab & _
        dis_names
        
        Tot_Reserve = Tot_Reserve + RS_LocInventory("alb_reserve")
        Tot_Onhand = Tot_Onhand + RS_LocInventory("alb_onhand")
        Tot_Damage = Tot_Damage + RS_LocInventory("alb_damaged")
        Grid_LocBal.AddItem sline
        RS_LocInventory.MoveNext

    Loop

    Call Get_LocInventory("Close")
    WorkB = 0
    sSql = "SELECT AI_Index, ISNULL ((SELECT COUNT(AWB_Id) AS bwb_count From AFC_WorkBench WHERE " & _
    "(AWB_Partno = a.AI_Index) AND (ISNULL(AWB_Date_Back, 0) = 0) and isnull(awb_verified,' ')<>'Y'), 0) AS bwb_count, " & _
    " ISNULL ((SELECT COUNT(AWB_Id) AS wb_count FROM AFC_WorkBench AS AFC_WorkBench_1 " & _
    "WHERE (AWB_Partno = a.AI_Index) AND (ISNULL(AWB_Date_Sent, 0) = 0) AND (ISNULL(AWB_Verified, ' ') <> ' ')), 0) " & _
    "AS wb_count FROM AFC_Inventory AS a WHERE AI_INDEX = " & tAI_Index
    
    Call Get_Trans("Read")
    
    If RS_Trans.EOF = False Then
        sline = 0 & vbTab & _
            "Work Bench" & vbTab & _
            " " & vbTab & _
            " " & vbTab & _
            RS_Trans("wb_Count") & vbTab & _
            RS_Trans("bwb_Count")
            WorkB = RS_Trans("Bwb_Count")
            Tot_Damage = Tot_Damage + RS_Trans("wb_Count")
        Grid_LocBal.AddItem sline
    End If
    Call Get_Trans("Close")
    
    sline = 0 & vbTab & _
        "Totals" & vbTab & _
        Tot_Reserve & vbTab & _
        Tot_Onhand & vbTab & _
        Tot_Damage & vbTab & _
        WorkB
        Grid_LocBal.AddItem sline

End Sub


Private Sub Grid_LocBal_Init()

' initilize the location balance grid on the Main parts tab

    Grid_LocBal.Clear
    Grid_LocBal.AllowUserResizing = flexResizeColumns
    
    Grid_LocBal.Rows = 1
    Grid_LocBal.Cols = 7
    Grid_LocBal.FixedCols = 0
    
    Grid_LocBal.TextMatrix(0, 0) = "Location"
    Grid_LocBal.TextMatrix(0, 1) = "Location"
    
    Grid_LocBal.TextMatrix(0, 2) = "Reserved"
    Grid_LocBal.TextMatrix(0, 3) = "Onhand"
    Grid_LocBal.TextMatrix(0, 4) = "Current Damage"
    Grid_LocBal.TextMatrix(0, 5) = "Work Bench"
    Grid_LocBal.TextMatrix(0, 6) = "Reserved by"

    Grid_LocBal.ColWidth(0) = 0
    Grid_LocBal.ColWidth(1) = 2500
    Grid_LocBal.ColWidth(2) = 1000
    Grid_LocBal.ColWidth(3) = 1000
    Grid_LocBal.ColWidth(4) = 1400
    Grid_LocBal.ColWidth(5) = 1200
    Grid_LocBal.ColWidth(6) = 2500

    Grid_LocBal.ColAlignment(0) = flexAlignLeftCenter
    Grid_LocBal.ColAlignment(1) = flexAlignLeftCenter
    Grid_LocBal.ColAlignment(2) = flexAlignLeftCenter
    Grid_LocBal.ColAlignment(3) = flexAlignLeftCenter
    Grid_LocBal.ColAlignment(4) = flexAlignLeftCenter
    Grid_LocBal.ColAlignment(5) = flexAlignLeftCenter

End Sub

Private Sub Check1_Click()

End Sub

Private Sub Cmd_Add_tech_Click()
    If Cbo_security.ListIndex = -1 Then
        MsgBox (" A security Level must be selected")
        Cbo_security.SetFocus
        Exit Sub
    End If
    If Cbo_Branch.ListIndex = -1 Then
        MsgBox (" A Maintenance Branch must be selected")
        Cbo_security.SetFocus
        Exit Sub
    End If
    
    tAT_Empno = CLng(Txt_tech.Text)
    tAT_EmpFname = Trim(Txt_techfname.Text)
    tAT_EmpLName = Trim(Txt_techlname.Text)
    tAT_Access_level = Cbo_security.ItemData(Cbo_security.ListIndex)
    tAT_Branch = Cbo_Branch.ItemData(Cbo_Branch.ListIndex)
    tAT_CellPhone = Replace(Replace(Replace(Txt_CellPhone.Text, "(", ""), ")", ""), "-", "")
    If Tech_flag = "Save" Then
        Call PGBLUpdateafc_technicians
        sSql = sSql & " where at_id = " & tAT_ID
    Else
        tAT_Password = "today"
        Call PGBLinsertintoafc_technicians
    End If
        
    SQLData.Execute (sSql)
    Txt_tech.Text = ""
    Txt_techfname.Text = ""
    Txt_techlname.Text = ""
    Txt_CellPhone.Text = ""
    Cbo_security.ListIndex = -1
    Call Load_Grid_Tech
    Tech_flag = ""
    Txt_tech.SetFocus
    

End Sub

Private Sub Cmd_add_trans_Click()
Dim part As String
Dim yesno(2) As String
yesno(0) = "N"
yesno(1) = "Y"
    
    If Option1(1) = True Then
        tAPR_Trantype = "Receipt"
    ElseIf Option1(0) = True Then
        tAPR_Trantype = "Physical"
        If Chk_First4.Value = 1 Then
            MsgBox (" You can't received product of the first orders on a physical transaction"), vbOKOnly
            Exit Sub
        End If
    Else
        MsgBox ("You Must select a transaction type to process an entry"), vbOKOnly
        Exit Sub
    End If
    If Cbo_Partno2.ListIndex = -1 Then
        MsgBox ("A Part number must be selected")
        Exit Sub
    End If
    If Cbo_Locations2.ListIndex = -1 Then
        MsgBox ("A Location must be selected")
        Exit Sub
    End If
    
    tAPR_Location = Cbo_Locations2.ItemData(Cbo_Locations2.ListIndex)
    tAPR_Partno = Cbo_Partno2.ItemData(Cbo_Partno2.ListIndex)
    tAPR_Qty = Txt_TransQty
    tAPR_Machine = m_ComputerName
    tAPR_Empno = Current_User_Index
    tAPR_First4 = yesno(Chk_First4.Value)
    tAPR_Setteling = yesno(Chk_Setteling.Value)
    If tAPR_First4 = "Y" And Txt_Packlist.Text = "" Then
        MsgBox ("You Must enter a Packing List number"), vbOKOnly
        Exit Sub
    End If
    If Txt_Packlist.Text = "" Then Txt_Packlist.Text = 0
    tAPR_PackList = CLng(Txt_Packlist.Text) + 0
    
    part = Mid(Cbo_Partno2.Text, 1, InStr(1, Cbo_Partno2.Text, "-") - 1)
    If Cmd_add_trans.Caption = "Save Changes" Then
        tAPR_Index = Grid_Transactions.TextMatrix(LG_GridIdx, 0)
        Call PGBLUpdateafc_phyreceipt
        sSql = sSql & " where apr_index = " & tAPR_Index
        Cmd_Removetrans.Visible = False
        
        SQLData.Execute (sSql)
        last_id = tAPR_Index
    Else
        Call PGBLinsertintoafc_phyreceipt
        SQLData.Execute (sSql)
        sSql = "select Max(apr_index)as maxid from afc_phyreceipt"
        Call Get_Trans("Read")
        last_id = RS_Trans("maxid")
    End If
    
    If Cmd_add_trans.Caption = "Save Changes" Then
        Grid_Transactions.RemoveItem (LG_GridIdx)
        Cmd_add_trans.Caption = "Add Transaction"
    End If
    
    sline = last_id & vbTab & _
    Mid(Cbo_Partno2.Text, 1, InStr(1, Cbo_Partno2.Text, "-") - 1) & vbTab & _
    Cbo_Partno2.Text & vbTab & _
    Cbo_Locations2.Text & vbTab & _
    Txt_TransQty & vbTab & _
    tAPR_Trantype & vbTab & _
    yesno(Chk_First4.Value) & vbTab & _
    tAPR_PackList
    Grid_Transactions.AddItem sline
    Call Reset_Cmd_Add_Trans
End Sub
Public Sub Reset_Cmd_Add_Trans()
    Cmd_add_trans.Caption = "Add Transaction"
    Cmd_Removetrans.Visible = False
    'Cbo_Locations2.ListIndex = -1
    Cbo_Partno2.ListIndex = -1
    Txt_TransQty = ""
    Cbo_Partno2.SetFocus
    
End Sub

Private Sub Cmd_Add_WB_Click()
    sSql = "insert into afc_workbench(awb_partno, awb_serialno, awb_location, awb_date_collected,awb_verified,awb_work_branch) values("
    'If Current_User_Branch = 2 Then
    '    sSql = sSql & tATH_Partno & ",'" & Trim(Txt_RecSerial.Text) & "',166,'" & Format(Now, "mm/dd/yyyy") & "','Y'," & Current_User_Branch & ")"
    'Else
        sSql = sSql & tATH_Partno & ",'" & Trim(Txt_RecSerial.Text) & "',165,'" & Format(Now, "mm/dd/yyyy") & "','Y'," & Current_User_Branch & ")"
    'End If
    SQLData.Execute (sSql)
    Grid_WB_Open.Visible = False
    Grid_WB.Visible = True
    Cmd_Add_WB.Visible = False
    Call Confirm_Incident
    tATH_Part_Serialno = Txt_RecSerial.Text
    
    Call PGBLinsertintoAFC_Transaction_History
    SQLData.Execute (sSql)

    Call Load_Grid_WB
    Txt_Label.Text = ""
    Cbo_Partno4.ListIndex = -1
    Txt_RecSerial.Text = ""
    Txt_Label.SetFocus
    
End Sub

Private Sub Cmd_addpart_Click()
    Txt_NewPart.Text = ""
    Txt_NewDesc.Text = ""
    FRM_Newpart.Left = 120
    FRM_Newpart.Top = 720
    FRM_Newpart.Visible = True
End Sub

Private Sub Cmd_AssBurlington_Click()
    Fra_Receipt.Left = 120
    Fra_Receipt.Top = 120
    Cmd_FindWB.Visible = False
    Cmd_Confirm_Dam.Visible = True
    Cmd_Confirm_Dam.Caption = "Assign to Burlington"
    Fra_Receipt.Visible = True
    WB_Flag = "Assign"
    Label(54) = "Send Items to Burlington"
    Txt_Label.SetFocus

End Sub

Private Sub Cmd_Busses_Click()
    Equip_Opt = 2
    Fra_Equipopt.Visible = False
    If Current_User_Branch <> 3 And Current_User_Level > 5 Then
        Frame1.Visible = True
        Cbo_Partno3.SetFocus
    End If
    If Current_User_Branch = 3 Then
        Frame1.Visible = True
        Cbo_Partno3.SetFocus
    End If
    
    Call Load_Grid_Equip

End Sub

Private Sub Cmd_Cal_Click()
    If Not IsDate(Txt_Rollout.Text) Then
        Vdate = Date - 1
    Else
        Vdate = Txt_Rollout.Text
    End If
    Call Frm_Calendar.SetStartDate(Vdate)
startit:
    Frm_Calendar.Show vbModal
    Vdate = Frm_Calendar.GetDate
    If IsDate(Vdate) = True Then
        If Vdate > Date Then
            If (MsgBox("Date Cannot be greater than Todays date", vbRetryCancel) = vbRetry) Then
                GoTo startit
            Else
                Exit Sub
            End If
        End If
        Txt_Rollout.Text = Format(Vdate, "MM/DD/YYYY")
    End If
End Sub

Private Sub Cmd_Close_Click()
    Grid_WB_Open.Visible = False
    Grid_WB.Visible = True
    Cmd_Add_WB.Visible = False
    
    Fra_Receipt.Visible = False
End Sub

Private Sub Cmd_Close_man_Click()
    Fra_Manual.Visible = False
    Cmd_Manual_Trans.Visible = True
End Sub

Private Sub Cmd_CoinController_Click()
    Fra_Receipt.Left = 0
    Fra_Receipt.Top = 0
    Cmd_FindWB.Visible = False
    Cmd_Confirm_Dam.Visible = True
    Cmd_Confirm_Dam.Caption = "Swapped coin boards to Burlington"
    Fra_Receipt.Visible = True
    WB_Flag = "Assign Coin"
    Label(54) = "Send swapped coin boards to Burlington"
    Txt_Label.SetFocus

End Sub

Private Sub Cmd_CoinControllerIn_Click()
    Fra_Receipt.Left = 0
    Fra_Receipt.Top = 0
    Fra_Receipt.Visible = True
    Cmd_FindWB.Visible = True
    Cmd_Confirm_Dam.Visible = False
    WB_Flag = "Receive Coin"
    Label(54) = "Receive Swapped Coin Boards"
    Txt_Label.SetFocus

End Sub

Private Sub Cmd_Confirm_Dam_Click()
        Call Cmd_FindWB_Click
End Sub

Private Sub Cmd_ExitNP_Click()
FRM_Newpart.Visible = False

End Sub



Private Sub Cmd_FindWB_Click()

' 1 check on part#
' 2 check on serial #
' 3 search on part # no date back
'   Found. then update
'   not found then offer to add
'
' 4 search on serial/part no date back
'   found then update
'   not found  search on part serial with alt serial #
'          found offer switch of information then move alt serial from orig item to new item
'          not found offer to put serial with oldest unreceived part in the system.
'
' 5 Check the incident system for an occurance of the part used and the serial number scanned
'   If found with in the last 10 day disregard.  other wise load to Incident exceptions for investigateion.
'
'**********************************************************************
' no serial # entered.  Update first record found for the item entered.
    If Cbo_Partno4.ListIndex = -1 And Trim(Txt_Label.Text) = "" Then
        MsgBox ("A Bar Code must be scanned or a part/Assembly number must be entered.")
        Exit Sub
    End If
    If Txt_Label.Text <> "" Then
        sSql = "select ai_index from afc_inventory where ai_partno = '" & Trim(label_part) & "'"
        Call Get_Trans("Read")
        tATH_Partno = RS_Trans("AI_Index")
        Call Get_Trans("Close")
    Else
        tATH_Partno = Cbo_Partno4.ItemData(Cbo_Partno4.ListIndex)
    End If
    
    tATH_Empno = Current_User_Index
    tATH_Location = 165
    tATH_Part_Serialno = "" 'Txt_Serialno.Text
    tATH_Tran_Date = Format(Now, "mm/dd/yyyy")
    tATH_Time = Now
    tATH_Tran_type = 18
    tATH_Machine = m_ComputerName
    tATH_Qty = Txt_RecQty.Text
    tATH_Comments = ""
    
    If WB_Flag = "Assign Coin" Then
        If tATH_Partno <> 70 Then
            MsgBox ("This option is for Coin controller boards only"), vbOKOnly
            Exit Sub
        End If
        tATH_Qty = 1
        tATH_Comments = "Swapped Coin Controller board"
        sSql = "insert into afc_workbench(awb_partno, awb_serialno, awb_location, awb_date_collected, awb_verified, awb_work_branch,awb_fleet_swap,awb_notes) Values (" & _
        tATH_Partno & ",'" & Trim(Txt_RecSerial.Text) & "',166,'" & Format(Now, "mm/dd/yyyy") & "','Y'," & Current_User_Branch & ",'Y','" & tAWB_Notes & "')"
        SQLData.Execute (sSql)
        tATH_Tran_type = 26
        tATH_Location = 166
        tATH_Tran_Location = 166
        tATH_Part_Serialno = Trim(Txt_RecSerial.Text)
        Call PGBLinsertintoAFC_Transaction_History
        SQLData.Execute (sSql)
        Txt_Label.Text = ""
        Cbo_Partno4.ListIndex = -1
        Txt_RecSerial.Text = ""
        Exit Sub
    End If
    
    If IsNumeric(Txt_RecSerial.Text) Then
        Txt_RecSerial.Text = CLng(Txt_RecSerial.Text)
    End If
    
    If WB_Flag = "Assign" Then
        Call Assign_Lookup
        Exit Sub
    End If
    
    If WB_Flag = "Verify" Then
        Call Verify_Lookup
        Exit Sub
    End If

'**********************************************************************
' Check for open workbench items by partno only for receiving back from Work Bench


    If Trim(Txt_RecSerial.Text) = "" Then
            
        sSql = "select * from afc_workbench where awb_partno=" & tATH_Partno & _
        " and isnull(awb_date_back,0)=0 and and isnull(awb_date_sent,0) <> 0 and awb_work_branch = " & Current_User_Branch
        
        If WB_Flag = "Receive Coin" Then
            SQL = SQL & " and awb_fleet_swap = 'Y'"
        End If
        
        'Else
        '    sSql = "select * from afc_workbench where awb_partno=" & tATH_Partno & _
        '    " and isnull(awb_date_sent,0) <> 0 and isnull(awb_date_back,0)=0 and awb_work_branch = " & Current_User_Branch
        'End If
        
        Call Get_Trans("Read")
    
'**********************************************************************
' Nothing found.  Need to add the workbench item to the Table. (mut have been missed on entry)
        If RS_Trans.EOF = True Then
            If MsgBox("There are no open Work Bench Items for that Part#." & vbCrLf & " " & vbCrLf & "Do you wish to add it to the Current List?", vbQuestion + vbYesNo) = vbYes Then
                Hold_partno = Cbo_Partno4.ItemData(Cbo_Partno4.ListIndex)
                Hold_Serial = Trim(Txt_RecSerial.Text)
                Hold_Date = Format(Now, "mm/dd/yyyy")
                Call Insert_WB_Receipt
                tATH_Tran_Location = tAWB_Location
                tATH_Tran_type = 21
                If WB_Flag = "Receive Coin" Then tATH_Tran_type = 27
                Call PGBLinsertintoAFC_Transaction_History
                SQLData.Execute (sSql)
            End If
        Else

'**********************************************************************
' Check to see if there are more than one item available for update.
            Cnt = 0
            Do While RS_Trans.EOF = False
                Cnt = Cnt + 1
                RS_Trans.MoveNext
            Loop
            RS_Trans.MoveFirst

'**********************************************************************
' loop thru the recordset for the # of pieces entered to work bench(this is for components and consumables.)
            If Cnt >= CLng(Txt_RecQty.Text) Then
                For Trans_cnt = 1 To CLng(Txt_RecQty.Text)
                    sSql = "update afc_workbench set awb_location = 165, awb_date_back='" & Format(Now, "mm/dd/yyyy") & "' where awb_id = " & RS_Trans("awb_id")
                    SQLData.Execute (sSql)
                    tATH_Tran_Location = RS_Trans("AWB_Location")
                    SQLData.Execute (sSql)
                    RS_Trans.MoveNext
                Next
                tATH_Tran_type = 21
                Call PGBLinsertintoAFC_Transaction_History
                SQLData.Execute (sSql)
                Call Get_Trans("Close")
            End If
        End If
    Else

'**********************************************************************
' A serial number has been entered.
        
        sSql = "select * from afc_workbench where awb_partno =" & tATH_Partno & " and awb_serialno='" & Trim(Txt_RecSerial.Text) & "'"
        sSql = sSql & " and awb_work_branch = " & Current_User_Branch
        If WB_Flag = "Receive Coin" Then
            sSql = sSql & " and awb_fleet_swap = 'Y'"
        End If
        
        
        sSql2 = sSql
        sSql = sSql & " and isnull(awb_date_back,0)=0"
        Call Get_Trans("Read")
        Debug.Print sSql
'**********************************************************************
' check for nonreceived by part/serial #
        If RS_Trans.EOF = True Then
            If WB_Flag <> "Receive Coin" Then
                sSql = sSql2 & " and rtrim(isnull(awb_altserialno,'')) > '' "
            End If
'**********************************************************************
' check for it being received via an alternat serial #
            Call Get_Trans("Read")
            If RS_Trans.EOF = True Then

'**********************************************************************
' no entry was found.  Place the receipt against the oldest entry in the system for that part #
                If MsgBox("There are no open entries in the Work Bench with this Serial number/part number Combination" & vbCrLf & _
                "Do you wish to receive against the oldest Part/Serial Combination?", vbQuestion + vbYesNo) = vbYes Then
                    Hold_partno = Cbo_Partno4.ItemData(Cbo_Partno4.ListIndex)
                    Hold_Serial = Trim(Txt_RecSerial.Text)
                    Hold_Date = Format(Now, "mm/dd/yyyy")
                    Call Update_WB_Oldest
                    ' transaction history in the subroutine
                Else
                    Exit Sub
                End If
            Else

'**********************************************************************
' old entry found swap the serial numbers
                Hold_partno = RS_Trans("awb_partno")
                Hold_Serial = RS_Trans("awb_Altserialno")
                Hold_Date = RS_Trans("awb_date_back")

'Change back to now.
                
                sSql = "update afc_workbench set awb_date_back='" & Format(Now, "mm/dd/yyyy") & "', awb_altserialno = '' where awb_id = " & RS_Trans("awb_id")
                SQLData.Execute (sSql)
                Call Update_WB_Oldest
                ' transaction history in the subroutine

            End If
        Else

'**********************************************************************
'exact match found make the entry
            sSql = "update afc_workbench set awb_date_back='" & Format(Now, "mm/dd/yyyy") & "' where awb_id = " & RS_Trans("awb_id")
            SQLData.Execute (sSql)
            tATH_Part_Serialno = Txt_RecSerial.Text
            tATH_Tran_type = 21
            tATH_Tran_Location = RS_Trans("awb_location")
            Call PGBLinsertintoAFC_Transaction_History
            SQLData.Execute (sSql)
            Call Get_Trans("Close")
        End If
    End If

'**********************************************************************
' update the base location with the addition of repaired/replaced components.
    If Current_User_Branch = 2 Or Current_User_Branch = 1 Then
        sSql = "update afc_locbalance set alb_onhand = alb_onhand + " & CLng(Txt_RecQty.Text) & " where alb_location = 1 and alb_partno = " & tATH_Partno
    Else
        sSql = "update afc_locbalance set alb_onhand = alb_onhand + " & CLng(Txt_RecQty.Text) & " where alb_location = 512 and alb_partno = " & tATH_Partno
    End If
    Debug.Print sSql
    SQLData.Execute (sSql)
    
    Call Load_Grid_WB
    
    Cbo_Partno4.ListIndex = -1
    Txt_RecSerial.Text = ""
    Txt_RecQty.Text = 1
    Txt_Label.Text = ""
    Txt_Label.SetFocus
    Refresh
End Sub


Public Sub Verify_Lookup()
    tATH_Location = 165
    tATH_Empno = Current_User_Index

'**********************************************************************
' Check for open workbench items by partno only for receiving back from Work Bench
    IT_Partno = tATH_Partno

    If Trim(Txt_RecSerial.Text) = "" Then
        sSql = "select * from afc_workbench where awb_partno=" & tATH_Partno & _
        " and isnull(awb_date_sent,0) = 0 and isnull(awb_serialno,'') = '' and isnull(awb_verified,'')='' and awb_work_branch = " & Current_User_Branch
        Call Get_Trans("Read")
    
'**********************************************************************
' Nothing found.  Need to add the workbench item to the Table. (mut have been missed on entry)
        If RS_Trans.EOF = True Then
            If MsgBox("There are no open Work Bench Items for that Part#." & vbCrLf & " " & vbCrLf & "Do you wish to add it to the Current List?", vbQuestion + vbYesNo) = vbYes Then
                Hold_partno = tATH_Partno
                Hold_Serial = Trim(Txt_RecSerial.Text)
                Hold_Date = Format(Now, "mm/dd/yyyy")
                
                If Current_User_Branch = 3 Then
                    tATH_Tran_Location = 165
                Else
                '    tATH_Tran_Location = 166
                    tATH_Tran_Location = 165
                    tATH_Tran_type = 19
                End If
                
                sSql = "insert into afc_workbench(awb_partno, awb_serialno, awb_location, awb_date_collected, awb_verified, awb_work_branch,awb_notes) Values (" & _
                tATH_Partno & ",'" & Trim(Txt_RecSerial.Text) & "'," & tATH_Tran_Location & ",'" & Format(Now, "mm/dd/yyyy") & "','Y'," & Current_User_Branch & ",'" & tAWB_Notes & "')"
                SQLData.Execute (sSql)
                                Call PGBLinsertintoAFC_Transaction_History
                SQLData.Execute (sSql)
                SQLData.Execute (sSql)
 
            Else
                Exit Sub
            End If
        
        Else

'**********************************************************************
' Check to see if there are more than one item available for update.
            Cnt = 0
            Do While RS_Trans.EOF = False
                Cnt = Cnt + 1
                RS_Trans.MoveNext
            Loop
            RS_Trans.MoveFirst

'**********************************************************************
' loop thru the recordset for the # of pieces entered to work bench(this is for components and consumables.)
            If Cnt >= CLng(Txt_RecQty.Text) Then
                For Trans_cnt = 1 To CLng(Txt_RecQty.Text)
                    
                    If Current_User_Branch = 3 Then
                        tATH_Tran_Location = 165
                    Else
                        'tATH_Tran_Location = 166
                        tATH_Tran_Location = 165
                        tATH_Tran_type = 19
                    End If
                    
                    sSql = "update afc_workbench set awb_verified='Y',awb_date_collected = '" & Format(Now, "mm/dd/yyyy") & "', awb_serialno='', awb_location = " & tATH_Tran_Location & " where awb_id = " & RS_Trans("awb_id")
                    SQLData.Execute (sSql)

                    Call PGBLinsertintoAFC_Transaction_History
                    SQLData.Execute (sSql)
                    RS_Trans.MoveNext
                Next
                Call Get_Trans("Close")
                MsgBox ("Component Verified"), vbOKOnly
            End If
        End If
    Else

'**********************************************************************
' A serial number has been entered.

        sSql = "select * from afc_workbench where awb_partno =" & tATH_Partno & " and "
        sSql = sSql & " awb_serialno='" & CStr(Trim(Txt_RecSerial.Text)) & "' and isnull(awb_verified,'') = '' And awb_work_branch = " & Current_User_Branch
        Call Get_Trans("Read")

        If RS_Trans.EOF = True Then
'**********************************************************************
' no entry was found.
            Grid_WB.Visible = False
            Grid_WB_Open.Visible = True
            Call Grid_WB_Open_Init
            Cmd_Add_WB.Visible = True
            sSql = "select * from afc_workbench where awb_partno=" & tATH_Partno & _
            " and isnull(awb_date_sent,0) = 0 and isnull(awb_verified,'') <> 'Y' And awb_work_branch = " & Current_User_Branch
            Debug.Print sSql
            Call Get_Trans("Read")
            If RS_Trans.EOF = True Then
                MsgBox ("There are no Un-Verified components with the Part number Entered.  Please add it to the List")
                Txt_Label.Text = ""
                Exit Sub
            Else
                Do While RS_Trans.EOF = False
                    sline = RS_Trans("awb_id") & vbTab & _
                    Trim(RS_Trans("awb_serialno")) & vbTab & _
                    RS_Trans("awb_date_collected")
                    Grid_WB_Open.AddItem sline
                    RS_Trans.MoveNext
                Loop
                RS_Trans.Close
                Set RS_Trans = Nothing
                MsgBox ("Select the item with the miss-entered from the list below by clicking on the row, or add the item to the list"), vbOKOnly
                Exit Sub
            End If
        Else

'**********************************************************************
'exact match found make the entry
            tATH_Tran_Location = RS_Trans("awb_location")
                            
            If Current_User_Branch = 3 Then
                tATH_Tran_Location = 165
            Else
                'tATH_Tran_Location = 166
                tATH_Tran_Location = 165
                tATH_Tran_type = 19
            End If
            
            sSql = "update afc_workbench set awb_verified='Y', awb_date_collected = '" & Format(Now, "mm/dd/yyyy") & "', awb_location = " & tATH_Tran_Location & " where awb_id = " & RS_Trans("awb_id")
            Debug.Print sSql
            SQLData.Execute (sSql)

            Call PGBLinsertintoAFC_Transaction_History
            SQLData.Execute (sSql)
            Call Get_Trans("Close")
            MsgBox ("Component Verified"), vbOKOnly
        End If
    End If
' Search Incident system for Item scanned
    If Current_User_Branch <> 3 Then
        Call Confirm_Incident
    End If
    
    Cbo_Partno4.ListIndex = -1
    Txt_RecSerial.Text = ""
    Txt_RecQty.Text = 1
    Txt_Label.Text = ""
    Txt_Label.SetFocus
    Refresh
End Sub

Public Sub Assign_Lookup()


'**********************************************************************
' Check for open workbench items by partno only for receiving back from Work Bench
    IT_Partno = tATH_Partno
    tATH_Tran_type = 19
    tATH_Location = 165
    tATH_Tran_Location = 166
    tATH_Empno = Current_User_Index
    If Trim(Txt_RecSerial.Text) = "" Then
        sSql = "select * from afc_workbench where awb_partno=" & tATH_Partno & _
        " and isnull(awb_date_sent,0) = 0 and isnull(awb_serialno,'') = '' and isnull(awb_verified,'')='Y' and awb_location = 165 and awb_work_branch = " & Current_User_Branch
        Call Get_Trans("Read")
    
'**********************************************************************
' Nothing found.  Need to add the workbench item to the Table. (mut have been missed on entry)
        If RS_Trans.EOF = True Then
            If MsgBox("There are no open Work Bench Items for that Part#." & vbCrLf & " " & vbCrLf & "Do you wish to add it to the Current List?", vbQuestion + vbYesNo) = vbYes Then
                Hold_partno = tATH_Partno
                Hold_Serial = Trim(Txt_RecSerial.Text)
                Hold_Date = Format(Now, "mm/dd/yyyy")
                tATH_Tran_type = 19
                
                sSql = "insert into afc_workbench(awb_partno, awb_serialno, awb_location, awb_date_collected, awb_verified, awb_work_branch,awb_notes) Values (" & _
                tATH_Partno & ",'" & Trim(Txt_RecSerial.Text) & "',166,'" & Format(Now, "mm/dd/yyyy") & "','Y'," & Current_User_Branch & ",'" & tAWB_Notes & "')"
                SQLData.Execute (sSql)
                Call PGBLinsertintoAFC_Transaction_History
                SQLData.Execute (sSql)
            Else
                Exit Sub
            End If
        Else

'**********************************************************************
' Check to see if there are more than one item available for update.
            Cnt = 0
            Do While RS_Trans.EOF = False
                Cnt = Cnt + 1
                RS_Trans.MoveNext
            Loop
            RS_Trans.MoveFirst

'**********************************************************************
' loop thru the recordset for the # of pieces entered to work bench(this is for components and consumables.)
            If Cnt >= CLng(Txt_RecQty.Text) Then
                For Trans_cnt = 1 To CLng(Txt_RecQty.Text)
                    sSql = "update afc_workbench set awb_location=166 where awb_id = " & RS_Trans("awb_id")
                    SQLData.Execute (sSql)

                    Call PGBLinsertintoAFC_Transaction_History
                    SQLData.Execute (sSql)
                    RS_Trans.MoveNext
                Next
                Call Get_Trans("Close")
                MsgBox ("Component Verified"), vbOKOnly
            End If
        End If
    Else

'**********************************************************************
' A serial number has been entered.

        sSql = "select * from afc_workbench where awb_partno =" & tATH_Partno & " and "
        sSql = sSql & " awb_serialno='" & CStr(Trim(Txt_RecSerial.Text)) & "' and awb_location =165 and isnull(awb_verified,'') = 'Y' and isnull(awb_date_sent,0)=0  And awb_work_branch = " & Current_User_Branch
        Call Get_Trans("Read")
    Debug.Print sSql
        If RS_Trans.EOF = True Then
'**********************************************************************
' no entry was found.
            Grid_WB.Visible = False
            Grid_WB_Open.Visible = True
            Call Grid_WB_Open_Init
            Cmd_Add_WB.Visible = True
            sSql = "select * from afc_workbench where awb_partno=" & tATH_Partno & _
            " and isnull(awb_date_sent,0) = 0 and isnull(awb_verified,'') = 'Y' And awb_location = 165 and awb_work_branch = " & Current_User_Branch
            Call Get_Trans("Read")
            If RS_Trans.EOF = True Then
                MsgBox ("There are no verified components with the Part number Entered.  Please add it to the List")
                Exit Sub
            Else
                Do While RS_Trans.EOF = False
                    sline = RS_Trans("awb_id") & vbTab & _
                    Trim(RS_Trans("awb_serialno")) & vbTab & _
                    RS_Trans("awb_date_collected")
                    Grid_WB_Open.AddItem sline
                    RS_Trans.MoveNext
                Loop
                RS_Trans.Close
                Set RS_Trans = Nothing
                MsgBox ("Select the item with the miss-entered from the list below by clicking on the row, or add the item to the list"), vbOKOnly
                Exit Sub
            End If
        Else

'**********************************************************************
'exact match found make the entry
            sSql = "update afc_workbench set awb_location= 166 where awb_id = " & RS_Trans("awb_id")
            SQLData.Execute (sSql)
            tATH_Part_Serialno = Txt_RecSerial.Text
            Call PGBLinsertintoAFC_Transaction_History
            SQLData.Execute (sSql)
            Call Get_Trans("Close")
            MsgBox ("Component Verified"), vbOKOnly
        End If
    End If
' Search Incident system for Item scanned
    
    'Call Confirm_Incident
    
    Cbo_Partno4.ListIndex = -1
    Txt_RecSerial.Text = ""
    Txt_RecQty.Text = 1
    Txt_Label.Text = ""
    Txt_Label.SetFocus
    Refresh
End Sub

Public Sub Confirm_Incident()

    sSql = "select * from Incident_parts left_outer join incident on ip_incident = i_id where ip_partindex = " & _
    tATH_Partno & " and rtrim(ip_orig_serial) = '" & Trim(Txt_RecSerial.Text) & _
    "' and isnull(ip_verified,'') = ''  and CAST(FLOOR(CAST(i_dt_reported AS float)) as datetime) > '" & Format(Now - 14, "mm/dd/yyyy") & "'"
    Debug.Print sSql
    Call Get_Trans("Read")
    
    If RS_Trans.EOF = False Then
        Call Update_Incident_Parts
        GoTo Item_Found
    Else
        Call Get_Trans("Close")
        sSql = "select * from Incident_parts left_outer join incident on ip_incident = i_id where ip_partindex = " & _
        tATH_Partno & " and rtrim(ip_new_serial) = '" & Trim(Txt_RecSerial.Text) & _
        "' and isnull(ip_verified,'') = ''  and CAST(FLOOR(CAST(i_dt_reported AS float)) as datetime) > '" & Format(Now - 14, "mm/dd/yyyy") & "'"
        Call Get_Trans("Read")
    
        If RS_Trans.EOF = False Then
            Call Update_Incident_Parts
            GoTo Item_Found
        Else
            Call Get_Trans("Close")
        End If
    End If
    
    sSql = "select * from Incident_parts left_outer join incident on ip_incident = i_id where ip_partindex = " & _
    tATH_Partno & " and ip_orig_serial Like '%" & Trim(Txt_RecSerial.Text) & _
    "%' and isnull(ip_verified,'') = ''  and CAST(FLOOR(CAST(i_dt_reported AS float)) as datetime) > '" & Format(Now - 14, "mm/dd/yyyy") & "'"
    
    Call Get_Trans("Read")
    
    If RS_Trans.EOF = False Then
        Call Update_Incident_Parts
        GoTo Item_Found
    Else
        Call Get_Trans("Close")
        sSql = "select * from Incident_parts left_outer join incident on ip_incident = i_id where ip_partindex = " & _
        tATH_Partno & " and rtrim(ip_new_serial) like '%" & Trim(Txt_RecSerial.Text) & _
        "%' and isnull(ip_verified,'') = ''  and CAST(FLOOR(CAST(i_dt_reported AS float)) as datetime) > '" & Format(Now - 14, "mm/dd/yyyy") & "'"
        Call Get_Trans("Read")
        
        If RS_Trans.EOF = False Then
            Call Update_Incident_Parts
            GoTo Item_Found
        Else
            Call Get_Trans("Close")
        End If
    End If

    
    
    Label(50).Caption = "The Item Scanned could not be found in the Incident system. Please enter any pertanent information from the tag on the item."
    For idx = 0 To 20
        Cbo_Date.AddItem Format(Now - idx, "mm/dd/yyyy")
    Next
    Txt_Partno.Text = Cbo_Partno4.List(Cbo_Partno4.ListIndex)
    Txt_Serial.Text = Txt_RecSerial.Text
    Frm_Inc_excep.Left = 120
    Frm_Inc_excep.Visible = True
        
Item_Found:


End Sub
Public Sub Update_Incident_Parts()
        sSql = "update incident_parts set ip_verified = 'Y' where ip_id = " & RS_Trans("ip_id")
        SQLData.Execute (sSql)
        Call Get_Trans("Close")

End Sub

Public Sub Insert_WB_Receipt()
    tAWB_Partno = Hold_partno
    tAWB_Serialno = Hold_Serial
    tAWB_Location = 165  ' force a received location
    If awb_flag = "Receive Coin" Then tAWB_Location = 166
    tAWB_Verified = "Y"
    tAWB_Date_collected = Format(Now, "mm/dd/yyyy")
    tAWB_Date_Sent = Format(Now, "mm/dd/yyyy")
    tAWB_Work_Branch = Current_User_Branch
    tAWB_Date_Back = Hold_Date
    tAWB_Notes = "No original submition for the unit was found"
    Call PGBLinsertintoAFC_WorkBench
    SQLData.Execute (sSql)

End Sub

Public Sub Update_WB_Oldest()
' update the oldest unreceived part with the date and serial number of the curent entry

    If WB_Flag = "Receive Coin" Then

        sSql = "select awb_id, awb_location from afc_workbench where awb_id in (select MIN(aw.awb_id) from afc_workbench aw " & _
        " where aw.awb_partno = " & Cbo_Partno4.ItemData(Cbo_Partno4.ListIndex) & _
        " and isnull(aw.awb_date_back,0)=0 and awb_work_Branch = " & Current_User_Branch & " and awb_fleet_swap = 'Y')"
        tATH_Tran_type = 27
        
    Else
        sSql = "select awb_id, awb_location from afc_workbench where awb_id in (select MIN(aw.awb_id) from afc_workbench aw " & _
        " where aw.awb_partno = " & Cbo_Partno4.ItemData(Cbo_Partno4.ListIndex) & _
        " and isnull(aw.awb_date_back,0)=0 and awb_work_Branch = " & Current_User_Branch & ")"
        tATH_Tran_type = 21
    End If
    
    Debug.Print sSql
    tATH_Part_Serialno = Txt_RecSerial.Text
    
    Call Get_Trans("Read")
    
    If RS_Trans.EOF = False Then
        sSql = "update afc_workbench set awb_date_back='" & Hold_Date & "', awb_altserialno = '" & Hold_Serial & "' where awb_id = " & RS_Trans("awb_id")
        SQLData.Execute (sSql)
        tATH_Tran_Location = RS_Trans("awb_location")

        Call PGBLinsertintoAFC_Transaction_History
        SQLData.Execute (sSql)
        Call Get_Trans("Close")
    Else
        If WB_Flag = "Receive Coin" Then tAWB_Fleet_Swap = "Y"
        Call Insert_WB_Receipt
        tAWB_Fleet_Swap = ""
        tATH_Tran_Location = 166
        tATH_Part_Serialno = Txt_RecSerial.Text ' force the burlington work bench
        Call PGBLinsertintoAFC_Transaction_History
        SQLData.Execute (sSql)
    End If

End Sub

Private Sub Cmd_Manual_Trans_Click()
    Fra_Manual.Visible = True
    Fra_Manual.Top = 120
    Fra_Manual.Left = 120
    Cmd_Manual_Trans.Visible = False
    Call Grid_TranHist_Init
    If Current_User_Branch = 3 Then
        For step = 0 To Cbo_FromLocation.ListCount - 1
        If Cbo_FromLocation.ItemData(step) = 512 Then
            Cbo_FromLocation.ListIndex = step
            step = Cbo_FromLocation.ListCount
        End If
    Next
    End If
    
End Sub

Private Sub Cmd_Move_Click()
    ' Default Location to location transfer
    tATH_Tran_type = 4


    If Cbo_Partno5.ListIndex = -1 Or Cbo_ToLocation.ListIndex = -1 Or Cbo_FromLocation.ListIndex = -1 Then
        MsgBox ("To move inventory you must pick a Part# a 'From' location and a 'To' Location"), vbOKOnly
        Exit Sub
    End If
    If Current_User_Branch = 3 And Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) <> 512 Then
        sSql = "select alb_damaged as alb_onhand from afc_locbalance where alb_location = " & Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    Else
        sSql = "select alb_onhand from afc_locbalance where alb_location = " & Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    End If
    Call Get_Trans("Read")
    
    If RS_Trans.EOF = True Then
        MsgBox ("The system shows that there is no inventory at the specified location"), vbCritical + vbOKOnly
        Cbo_Partno5.ListIndex = -1
        Cbo_ToLocation.ListIndex = -1
        Cbo_FromLocation.ListIndex = -1
        Exit Sub
    End If
    If CLng(Txt_ManQty.Text) > RS_Trans("alb_onhand") Then
        MsgBox ("You only have " & RS_Trans("alb_onhand") & " available to you to move"), vbOKOnly
        Exit Sub
    End If
    
    sSql = "select alb_onhand from afc_locbalance where alb_location = " & Cbo_ToLocation.ItemData(Cbo_ToLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    Call Get_Inventory("Read")
    If RS_Inventory.EOF = True Then
        sSql = "insert into afc_locbalance(alb_location, alb_partno, alb_onhand, alb_reserve, alb_Damaged) values(" & _
        Cbo_ToLocation.ItemData(Cbo_ToLocation.ListIndex) & "," & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex) & ",0,0,0)"
        SQLData.Execute (sSql)
    End If
    RS_Inventory.Close
    Set RS_Inventory = Nothing

'reduce from location
    If Current_User_Branch = 3 And Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) <> 512 Then
        tATH_Tran_type = 20
        sSql = "Update afc_locbalance set alb_damaged = alb_damaged-" & CLng(Txt_ManQty.Text) & " where alb_location = " & Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    Else
        sSql = "Update afc_locbalance set alb_onhand = alb_onhand-" & CLng(Txt_ManQty.Text) & " where alb_location = " & Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    End If
    
    SQLData.Execute (sSql)
' increase to location
    If Current_User_Branch = 3 And Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex) <> 512 Then
        sSql = "Update afc_locbalance set alb_damaged = alb_damaged+" & CLng(Txt_ManQty.Text) & " where alb_location = " & Cbo_ToLocation.ItemData(Cbo_ToLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    Else
        sSql = "Update afc_locbalance set alb_onhand = alb_onhand+" & CLng(Txt_ManQty.Text) & " where alb_location = " & Cbo_ToLocation.ItemData(Cbo_ToLocation.ListIndex) & " and alb_partno = " & Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    End If
    SQLData.Execute (sSql)
    tATH_Partno = Cbo_Partno5.ItemData(Cbo_Partno5.ListIndex)
    tATH_Empno = Current_User_Index
    tATH_Machine = m_ComputerName
    tATH_Qty = CLng(Txt_ManQty.Text)
    tATH_Location = Cbo_FromLocation.ItemData(Cbo_FromLocation.ListIndex)
    tATH_Tran_Location = Cbo_ToLocation.ItemData(Cbo_ToLocation.ListIndex)
    tATH_Tran_Date = Format(Now, "mm/dd/yyyy")
    tATH_Time = Now
    Call PGBLinsertintoAFC_Transaction_History
    SQLData.Execute (sSql)

    sline = Cbo_Partno5.List(Cbo_Partno5.ListIndex) & vbTab & _
    Txt_ManQty.Text & vbTab & _
    Cbo_FromLocation.List(Cbo_FromLocation.ListIndex) & vbTab & _
    Cbo_ToLocation.List(Cbo_ToLocation.ListIndex)
    Grid_Tranhist.AddItem sline

    Cbo_Partno5.ListIndex = -1
    Cbo_ToLocation.ListIndex = -1
    Cbo_FromLocation.ListIndex = -1
    Txt_ManQty.Text = ""
    Txt_Avail.Text = ""
    Cbo_Partno5.SetFocus
    

End Sub

Private Sub cmd_open_Click()
    If MsgBox("Send All unsent Components and Assemblies to S&B Burlington", vbQuestion + vbYesNo) = vbNo Then
        Exit Sub
    Else
        Report_Name = "Send to Burlington"
        Frm_RptViewer.Show vbModal
        Report_Name = ""
        If Printed = True Then
            If MsgBox("Do you want to update the sent date to S&B now", vbYesNo + vbQuestion) = vbYes Then
                sSql = "Update AFC_Workbench set awb_date_sent='" & Format(Now, "mm/dd/yyyy") & "' where isnull(awb_date_sent,0) =0 and awb_verified='Y' and awb_location=166 and awb_work_branch = " & Current_User_Branch
                SQLData.Execute (sSql)
                MsgBox ("Item Status Changed and Date sent has been updated")
                Load_Grid_WB
            End If
        End If
    
    End If
End Sub

Private Sub cmd_out_date_Click()

    Txt_Out_Date.Text = Calendar_date(Txt_Out_Date.Text)

End Sub

Private Sub Cmd_Print_Rec_Click()
    Report_Name = "Receipts"
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub Cmd_Process_move_Click()
Dim Comma As Long
Dim Serial(10) As String
Dim Notes(10) As String
Dim Serial_Str As String
Dim Notes_Str As String

For index = 1 To Grid_Trans.Rows - 1
    If Trim(Grid_Trans.TextMatrix(index, 6) = "") And CLng(Grid_Trans.TextMatrix(index, 9)) = 2 Then
        If Trim(Grid_Trans.TextMatrix(index, 3) = "FRA") Then
            MsgBox ("You have to enter the Seral# for all FRA (Field Replaceable Assemblies)")
            Exit Sub
        End If
        If MsgBox("You are receiving item(s) back to workbench that haven't" & vbCrLf & _
        "had the serial number recorded.  Do you want to continue the Posting?", vbYesNo + vbQuestion) = vbNo Then
            Exit Sub
        Else
            index = Grid_Trans.Rows - 1
        End If
    End If
Next
    
    For index = 1 To Grid_Trans.Rows - 1
        
        tATH_Partno = CLng(Grid_Trans.TextMatrix(index, 7))
        tATH_Empno = Current_User_Index
        tATH_Location = CLng(Grid_Trans.TextMatrix(index, 8))
        tATH_Tran_type = 14
        tATH_Tran_Date = Format(Now, "mm/dd/yyyy")
        tATH_Time = Now
        tATH_Machine = m_ComputerName
        tATH_Part_Serialno = ""
        tATH_Qty = CLng(Grid_Trans.TextMatrix(index, 5))
        tATH_Comments = ""

        
        Select Case CLng(Grid_Trans.TextMatrix(index, 9))
        Case 1 ' fulfillment from base
            tATH_Tran_type = 10 ' already established in the DB under AFC_TranTypes

            sSql = "update afc_locbalance set alb_onhand = alb_onhand + " & CLng(Grid_Trans.TextMatrix(index, 5)) & " where alb_location = " & CLng(Grid_Trans.TextMatrix(index, 8)) & " and alb_partno = " & CLng(Grid_Trans.TextMatrix(index, 7))
            SQLData.Execute (sSql)
    
            If Master_Base = 0 Then
                If Cbo_Base.ListIndex = -1 Then
                    MsgBox ("A Base location must be selected to move inventory to and from")
                    Exit Sub
                End If
                tATH_Tran_Location = Cbo_Base.ItemData(Cbo_Base.ListIndex)
            Else
                tATH_Tran_Location = Master_Base
            End If
            

' add to transaction history
            Call PGBLinsertintoAFC_Transaction_History
            SQLData.Execute (sSql)
            
' remove the inventory from the base location
            
            sSql = "update afc_locbalance set alb_onhand = alb_onhand - " & CLng(Grid_Trans.TextMatrix(index, 5))
            If Master_Base = 0 Then
                sSql = sSql & " where alb_location = " & Cbo_Base.ItemData(Cbo_Base.ListIndex)
            Else
                sSql = sSql & " where alb_location = " & Master_Base
            End If
            sSql = sSql & " and alb_partno = " & CLng(Grid_Trans.TextMatrix(index, 7))
            SQLData.Execute (sSql)
            
' update the usage of the component in afc inventory
            If Trim(Grid_Trans.TextMatrix(index, 3)) <> "Unit" And Trim(Grid_Trans.TextMatrix(index, 3)) <> "FRA" And Trim(Grid_Trans.TextMatrix(index, 3)) <> "FRC" Then
                sSql = "update afc_inventory set ai_usage = ai_usage + " & CLng(Grid_Trans.TextMatrix(index, 5)) & "where ai_index = " & CLng(Grid_Trans.TextMatrix(index, 7))
                SQLData.Execute (sSql)
            End If
        Case 2 ' add to work bench

' proces for multiple serial numbers
            Serial_Str = Trim(Grid_Trans.TextMatrix(index, 6))
            For idx = 1 To 10
                Serial(idx) = "" '0
                Notes(idx) = ""
            Next
            
            For idx = 1 To 10
                Comma = InStr(1, Serial_Str, ",")
                If Comma = 0 Then
                    Serial(idx) = Serial_Str
                    idx = 10
                Else
                    Serial(idx) = Mid(Serial_Str, 1, Comma - 1)
                    Serial_Str = Mid(Serial_Str, Comma + 1, 50)
                End If
            Next
                
            For idx = 1 To 10
                Comma = InStr(1, Notes_Str, ",")
                If Comma = 0 Then
                    Notes(idx) = Notes_Str
                    idx = 10
                Else
                    Notes(idx) = Mid(Notes_Str, 1, Comma - 1)
                    Notes_Str = Mid(Notes_Str, Comma + 1, 50)
                End If
            Next
                sSql = "update afc_locbalance set alb_damaged = alb_damaged - " & CLng(Grid_Trans.TextMatrix(index, 5)) & " where alb_location = " & CLng(Grid_Trans.TextMatrix(index, 8)) & " and alb_partno = " & CLng(Grid_Trans.TextMatrix(index, 7))
                SQLData.Execute (sSql)

' update the location balance table
            For idx = 1 To 10
            

'add the item to workbench table
                If Trim(Serial(idx)) > "" Then
                    sSql = "select * from afc_workbench where awb_partno = " & CLng(Grid_Trans.TextMatrix(index, 7)) & " and awb_serialno = '" & Serial(idx) & "' and awb_date_collected <= '" & Format(Now - 10, "mm/dd/yyyy") & "' and isnull(awb_verified,'')<> 'Y'"
                    Call Get_Trans("Read")
                    If RS_Trans.EOF = False Then
                        'If Current_User_Branch = 3 Then
                            tAWB_Location = 165  ' force a received location
                        'Else
                        '    tAWB_Location = 166  ' force a received location
                        'End If
                        sSql = "update afc_workbench set awb_verified = 'Y', awb_location = " & tAWB_Location & " where awb_id = " & RS_Trans("awb_id")
                        Call Get_Trans("Close")
                        GoTo Skip_Insert
                    End If
                Call Get_Trans("Close")
                    
                End If
                sSql = "Insert into AFC_WorkBench(awb_partno, awb_serialno, awb_location, awb_date_Collected, awb_work_branch, awb_notes) " & _
                " Values (" & CLng(Grid_Trans.TextMatrix(index, 7)) & ", '" & Serial(idx) & "',165,'" & Format(Now, "mm/dd/yyyy") & "'," & Current_User_Branch & ",'" & Replace(Trim(Grid_Trans.TextMatrix(index, 10)), "'", "''") & "')"
                SQLData.Execute (sSql)
                tATH_Part_Serialno = Serial(idx)
'Add to transaction history table
                tATH_Tran_type = 11
                tATH_Qty = 1
                Call PGBLinsertintoAFC_Transaction_History
                SQLData.Execute (sSql)
Skip_Insert:
                If Serial(idx + 1) = "" Then idx = 10
            Next
            
' Close the Damage components in the transaction History Table
            sSql = "update afc_transaction_history set ath_Closed = 1, ath_candate='" & Format(Now, "mm/dd/yyyy") & "' where ath_tran_type=3 and ath_partno = " & CLng(Grid_Trans.TextMatrix(index, 7)) & " and isnull(ath_closed,0) = 0 and ath_location = " & CLng(Grid_Trans.TextMatrix(index, 8))
            SQLData.Execute (sSql)

        End Select
        sSql = "delete from afc_Inventory_trans where ait_id = " & CLng(Grid_Trans.TextMatrix(index, 0))
        SQLData.Execute (sSql)
        
        


' reset the screen after posting

    Next
    
    Call SSTab1_Click(2)
    Call Grid_Trans_Init

End Sub

Private Sub Cmd_Qa_Click()
    If Trim(Txt_RecSerial.Text) <> "" Then
        sSql = "select * from afc_workbench where awb_partno =" & Cbo_Partno4.ItemData(Cbo_Partno4.ListIndex) & " and "
        sSql = sSql & " awb_serialno='" & CStr(Trim(Txt_RecSerial.Text)) & "' and awb_work_Branch = " & Current_User_Branch
        sSql2 = sSql
        sSql = sSql & " and isnull(awb_date_sent,0) <> 0 and isnull(awb_date_back,0)=0"
        Call Get_Trans("Read")
        If RS_Trans.EOF = False Then
            MsgBox ("already have the entry in the system")
            Call Get_Trans("Close")
            Exit Sub
        Else
            Call Get_Trans("Close")
        End If
    End If
    sSql = "insert into afc_workBench (awb_partno, awb_serialno, Awb_location, awb_date_collected, awb_date_sent,awb_verified, awb_work_Branch) values (" & Cbo_Partno4.ItemData(Cbo_Partno4.ListIndex) & ",'" & Trim(Txt_RecSerial.Text) & "',166,'" & Format(Now, "mm/dd/yyyy") & "','" & Format(Now, "mm/dd/yyyy") & "','Y'," & Current_User_Branch & ")"
        SQLData.Execute (sSql)
    Txt_RecSerial.Text = ""
    Cbo_Partno4.SetFocus
    
    End Sub

Private Sub Cmd_rec_report_Click()

    Report_Name = "S&B Receipts"
    Frm_RptViewer.Show vbModal
    
End Sub

Private Sub Cmd_Remove_Click()
    sSql = "delete from afc_Unittable where au_index = " & tAU_Index
    SQLData.Execute (sSql)
    Unit_Modify = False
    Grid_Equip.RemoveItem (LG_GridIdx)
    Cbo_Partno3.ListIndex = -1
    Cbo_Locations3.ListIndex = -1
    Txt_MBTAno.Text = ""
    Txt_SBSerial.Text = ""
    Txt_Rollout.Text = ""

End Sub

Private Sub Cmd_Record_Click()
    If Cbo_Date.Text = "" Then
        MsgBox ("There has to be a date selected to verify the part")
    Else
        sSql = "insert into incident_exceptions(IE_Incident, IE_Partno, IE_Serialno, IE_Machineno, " & _
            "IE_Date_Worked,IE_Date_Saved) values(" & IT_Incident & "," & IT_Partno & ",'" & Trim(Txt_Serial.Text) & _
            "'," & IT_Machineno & ",'" & Format(Cbo_Date.Text, "mm/dd/yyyy") & "','" & Format(Now, "mm/dd/yyyy") & "')"
        SQLData.Execute (sSql)

    End If

    IT_Incident = 0
    IT_Partno = 0
    Txt_Serial.Text = ""
    Txt_Partno.Text = ""
    IT_Machineno = 0
    Frm_Inc_excep.Visible = False


End Sub

Private Sub Cmd_Removetrans_Click()
    sSql = "delete from AFC_Phyreceipt where apr_index = " & Grid_Transactions.TextMatrix(LG_GridIdx, 0)
    SQLData.Execute (sSql)
    Call Load_Grid_Transactions
    Cmd_Removetrans.Visible = False
    Call Reset_Cmd_Add_Trans
End Sub

Private Sub Cmd_Sat_requirements_Click()
    Report_Name = "Inventory_Request"
    If Cbo_Locations4.ListIndex = -1 Then
        MsgBox ("You have to select a Location to Report on")
        Exit Sub
    End If
    
    Rpt_Location = Cbo_Locations4.ItemData(Cbo_Locations4.ListIndex)
    Rpt_Type = "Everything"
    If Option1(5) = True Then
        Rpt_Type = "Fullfill"
    End If
    If Option1(6).Value = True Then 'reserve part
        Rpt_Type = "Damages"
    End If
    Frm_RptViewer.Show vbModal
    Call SSTab1_Click(2)
    
End Sub

Private Sub cmd_unit_Click()
    Set RS_Trans = New ADODB.Recordset
    Set RS_Trans = Header_Query()
    If Header_Query.EOF = True Then
        MsgBox ("ok")
    End If
End Sub

Private Sub Cmd_Sent_Click()
    Fra_Receipt.Left = 120
    Fra_Receipt.Top = 120
    Fra_Receipt.Visible = True
    Cmd_FindWB.Visible = True
    Cmd_Confirm_Dam.Visible = False
    WB_Flag = "Receive"
    Label(54) = "Receive Parts"
    Txt_Label.SetFocus
End Sub

Private Sub Cmd_subway_Click()
    Equip_Opt = 1
    Fra_Equipopt.Visible = False
    Call Load_Grid_Equip
    If Current_User_Level < 5 Then Exit Sub
    Frame1.Visible = True
    Cbo_Partno3.SetFocus

End Sub

Private Sub Cmd_Unit_Clear_Click()
    Cbo_Partno3.ListIndex = -1
    Cbo_Locations3.ListIndex = -1
    Txt_MBTAno.Text = ""
    Txt_SBSerial.Text = ""
    Txt_Rollout.Text = ""
    Combo(1).ListIndex = -1
    Combo(2).ListIndex = -1
    Combo(0).ListIndex = -1
    
End Sub

Private Sub CMD_UnitAdd_Click()

    If Cbo_Locations3.ListIndex = -1 Then
        MsgBox ("A location Must be selected,  If it is not available.  It must be added"), vbOKOnly
        Exit Sub
    End If
    If Cbo_Partno3.ListIndex = -1 Then
        MsgBox ("A part number must be selected."), vbOKOnly
        Exit Sub
    End If
    If Combo(1).ListIndex = -1 Then
        MsgBox ("A State Grant/Bond must be selected"), vbOKOnly
        Exit Sub
    End If
    If Combo(2).ListIndex = -1 Then
        MsgBox ("A Federal Grant must be selected"), vbOKOnly
        Exit Sub
    End If
    
    If Txt_Rollout.Text = "" Then
        MsgBox ("You must select a rollout_date"), vbCritical + vbOKOnly
        Txt_Rollout.SetFocus
        Exit Sub
    End If
    
'check for the serial number
If Trim(Txt_SBSerial.Text) <> "" And Unit_Modify = False Then
    sSql = "select AU_Serialno from AFC_UnitTable where AU_Serialno ='" & Trim(Txt_SBSerial.Text) & "'"
    Call Get_Trans("Read")
    If RS_Trans.EOF = False Then
        MsgBox ("The S&B Serial number supplied has already been entered."), vbOKOnly + vbCritical
        Txt_SBSerial.SetFocus
        Call Get_Trans("Close")
        Exit Sub
    End If
    Call Get_Trans("Close")

End If

'Check for the mbtano
    If Trim(Txt_MBTAno.Text) = "" Then GoTo Skip_MBTA
    If Unit_Modify = True Then GoTo Skip_MBTA
    If UCase(Trim(Txt_MBTAno.Text)) = "END" Then GoTo Skip_MBTA
    sSql = "select AU_mbtano from AFC_UnitTable where AU_Mbtano='" & Trim(Txt_MBTAno.Text) & "'"
    Call Get_Trans("Read")
    If RS_Trans.EOF = False Then
        MsgBox ("The MBTA Equipment Number supplied has already been entered."), vbOKOnly + vbCritical
        Txt_MBTAno.SetFocus
        Call Get_Trans("Close")
        Exit Sub
    End If
    Call Get_Trans("Close")

Skip_MBTA:
    
    tAU_Location = Cbo_Locations3.ItemData(Cbo_Locations3.ListIndex)
    tAU_Partno = Cbo_Partno3.ItemData(Cbo_Partno3.ListIndex)
    tAU_MBTAno = Trim(Txt_MBTAno.Text)
    tAU_Serialno = Trim(Txt_SBSerial.Text)
    tAU_DateRolledOut = Txt_Rollout.Text
    tAU_Condition = Combo(0).ItemData(Combo(0).ListIndex)
    tAU_StateFunding = Combo(1).ItemData(Combo(1).ListIndex)
    tAU_FederalFunding = Combo(2).ItemData(Combo(2).ListIndex)
    If Chk_Moved = 1 Then
        tAU_Moved = "Y"
    Else
        tAU_Moved = " "
    End If
    
    If Unit_Modify = True Then
        Call PGBLUpdateafc_unittable
        sSql = sSql & " where au_index = " & tAU_Index
    Else
        Call PGBLinsertintoafc_unittable
    End If
    SQLData.Execute (sSql)

    If Unit_Modify = True Then
        Grid_Equip.TextMatrix(LG_GridIdx, 1) = Trim(Cbo_Partno3.Text)
        Grid_Equip.TextMatrix(LG_GridIdx, 2) = Trim(Txt_MBTAno.Text)
        Grid_Equip.TextMatrix(LG_GridIdx, 3) = Trim(Cbo_Locations3.Text)
        Grid_Equip.TextMatrix(LG_GridIdx, 4) = Trim(Txt_SBSerial.Text)
        Grid_Equip.TextMatrix(LG_GridIdx, 5) = Txt_Rollout.Text
        If Chk_Moved = 1 Then
            Grid_Equip.TextMatrix(LG_GridIdx, 6) = "Yes"
        Else
            Grid_Equip.TextMatrix(LG_GridIdx, 6) = " "
        End If
        
        Grid_Equip.TextMatrix(LG_GridIdx, 7) = Conditions(Combo(0).ListIndex)
        Grid_Equip.TextMatrix(LG_GridIdx, 8) = Cbo_Partno3.ItemData(Cbo_Partno3.ListIndex)
        Grid_Equip.TextMatrix(LG_GridIdx, 9) = Cbo_Locations3.ItemData(Cbo_Locations3.ListIndex)
        Grid_Equip.TextMatrix(LG_GridIdx, 10) = Combo(1).ItemData(Combo(1).ListIndex)
        Grid_Equip.TextMatrix(LG_GridIdx, 11) = Combo(2).ItemData(Combo(2).ListIndex)
        Grid_Equip.TextMatrix(LG_GridIdx, 12) = Combo(0).ItemData(Combo(0).ListIndex)
        Cbo_Partno3.ListIndex = -1
        Cbo_Locations3.ListIndex = -1
        Combo(1).ListIndex = -1
        Combo(2).ListIndex = -1
        Combo(0).ListIndex = -1
        Unit_Modify = False
    Else
        sSql = "select Max(au_index)as maxid from afc_unittable"
        Call Get_Trans("Read")
        last_id = RS_Trans("maxid")

        sline = last_id & vbTab & _
            Trim(Cbo_Partno3.Text) & vbTab & _
            Trim(Txt_MBTAno.Text) & vbTab & _
            Trim(Cbo_Locations3.Text) & vbTab & _
            Trim(Txt_SBSerial.Text) & vbTab & _
            Txt_Rollout.Text & vbTab & _
            " " & vbTab & _
            Conditions(Combo(0).ListIndex) & vbTab & _
            Cbo_Partno3.ItemData(Cbo_Partno3.ListIndex) & vbTab & _
            Cbo_Locations3.ItemData(Cbo_Locations3.ListIndex) & vbTab & _
            Combo(2).ItemData(Combo(2).ListIndex) & vbTab & _
            Combo(1).ItemData(Combo(1).ListIndex) & vbTab & _
            Combo(0).ItemData(Combo(0).ListIndex)
        Grid_Equip.AddItem sline
       End If
    Unit_Modify = False
    Grid_Equip.FixedRows = 1
    Grid_Equip.col = 0
    Grid_Equip.sort = 2
    Grid_Equip.Refresh
    Grid_Equip.FixedRows = 0
    If Scanning = True Then
        Txt_MBTAno.Text = ""
        Txt_SBSerial.Text = ""
        Txt_MBTAno.SetFocus
    End If
    'Call Cmd_Unit_Clear_Click
End Sub

Private Sub cmd_oem_search_Click()

    Frm_Oem.Show vbModal
    If Pass_Index = 0 Then Exit Sub

    sSql = "select * from AFC_Inventory where AI_index = " & Pass_Index
    Call Get_Inventory("Read")
    If RS_Inventory.EOF = True Then
        MsgBox ("the item your looking for can not be found"), vbOKOnly
    End If
    Call Display_Part_Data
    For step = 0 To Cbo_Partno.ListCount
        If Cbo_Partno.ItemData(step) = tAI_Index Then
            Cbo_Partno.ListIndex = step
            step = Cbo_Partno.ListCount
        End If
    Next

    Call Get_Inventory("Close")


End Sub

Private Sub Cmd_PM_Close_Click()
    FRM_PMovement.Visible = False
    Cbo_Partno.SetFocus
End Sub

Private Sub Cmd_PM_Submit_Click()
    Dim location As Long
    Dim alocation As String
    
    alocation = ""
    location = CLng(Grid_LocBal.TextMatrix(LG_GridIdx, 0))
   'Cbo_RLB.ItemData (Cbo_RLB.ListIndex)
 
'************************************************************
' Execute the requested transaction(reserve, take, place in damage)
    
'Reserve the part
    If Option1(6) = True Then ' reserve part
        If Tran_Status("Check Reserve", location) = True Then
            If MsgBox("You have already reserved this part.  Are you reserving another at this time", vbYesNo + vbQuestion) = vbNo Then Exit Sub
            sSql = "Update AFC_LocBalance set alb_reserve = alb_reserve + 1 where alb_location = " & location & " and ALB_partno = " & tAI_Index
        End If
        sSql = "Update AFC_LocBalance set alb_reserve = alb_reserve + 1 where alb_location = " & location & " and ALB_partno = " & tAI_Index
' Take the part
    ElseIf Option1(7) = True Then ' take part
        If Tran_Status("Check Reserve", location) = False Then
            MsgBox ("The system does not show that you have reserved this part with in the last day")
            Exit Sub
        End If
        sSql = "Update AFC_LocBalance set alb_onhand = alb_onhand -1,alb_reserve = alb_reserve -1 where alb_location = " & location & " and ALB_partno = " & tAI_Index
    
'Return a damaged part to a location
    ElseIf Option1(10) = True Then ' return damage
        If Cbo_Locations.Text = "" Then
            MsgBox ("A Location must be selected"), vbOKOnly
            Exit Sub
        End If
        If Tran_Status("Check Location", Cbo_Locations.ItemData(Cbo_Locations.ListIndex)) = True Then
            sSql = "Update AFC_LocBalance set alb_damaged = alb_damaged + 1 where alb_location = " & Cbo_Locations.ItemData(Cbo_Locations.ListIndex) & " and ALB_partno = " & tAI_Index
        Else
            sSql = "Insert into afc_LocBalance (ALB_Location, ALB_Partno, ALB_Onhand, ALB_Damaged, ALB_Reserve)" & _
            "values(" & Cbo_Locations.ItemData(Cbo_Locations.ListIndex) & "," & tAI_Index & ",0,1,0)"
        End If
'Unreserve the part
    ElseIf Option1(8) = True Then ' unreserve
            ' check to see if this tech actually did reserve the part
        If Tran_Status("Check Reserve", location) = False Then
            MsgBox ("The system does not show that you have reserved this part with in the last day")
            Exit Sub
        End If
        sSql = "Update AFC_LocBalance set alb_reserve = alb_reserve  -1 where alb_location = " & location & " and ALB_partno =" & tAI_Index

'Return an unused part
    ElseIf Option1(9) = True Then ' nuntake part
        If Tran_Status("Check take", location) = False Then
            MsgBox ("The system does not show that you have taken this part with in the last day")
            Exit Sub
        End If
        sSql = "Update AFC_LocBalance set alb_onhand= alb_onhand +1 where alb_location = " & location & " and ALB_partno =" & tAI_Index
    
    Else
        MsgBox ("A selection must be made before you may make a submition"), vbOKOnly
        Exit Sub
    End If
    
    SQLData.Execute (sSql)
    
'************************************************************
' Create transaction by user this will record the user and the type of transaction made
    
    tATH_Partno = tAI_Index
    tATH_Empno = Current_User_Index
    tATH_Location = location
    
    tATH_Tran_Date = Format(Now, "mm/dd/yyyy")
    tATH_Time = Now
    tATH_Machine = m_ComputerName
    tATH_Tran_Location = 0
    tATH_Part_Serialno = ""
    tATH_Qty = 1
    tATH_Comments = ""
    
    If Option1(6) = True Then 'reserve part
        tATH_Tran_type = 1
    ElseIf Option1(7) = True Then ' take part
        tATH_Tran_type = 2
    ElseIf Option1(10) = True Then ' return damage
        tATH_Tran_type = 3
    ElseIf Option1(8) = True Then ' unreserve part
        tATH_Tran_type = 7
    ElseIf Option1(9) = True Then ' untake part
        tATH_Tran_type = 8
    End If
    
    Call PGBLinsertintoAFC_Transaction_History

    SQLData.Execute (sSql)
    
    Call Load_Grid_LocBal
    FRM_PMovement.Visible = False
    Cbo_Partno.SetFocus
    
End Sub

Private Sub Cmd_Post_Click()

'Executes a stored procedure in the SQL Server Data base for the posting of these transactions.
'
    sSql = "Exec afc_post_trans '" & Format(Now, "mm/dd/yyyy") & "'"
    SQLData.Execute (sSql)
    Call Grid_Transactions_Init
End Sub

Private Sub Cmd_rem_tech_Click()
    sSql = "delete from afc_technicians where at_id =" & tAT_ID
    SQLData.Execute (sSql)
    Call Load_Grid_Tech
End Sub

Private Sub Cmd_Reset_Click()
    Txt_tech.Text = ""
    Txt_techfname.Text = ""
    Txt_techlname.Text = ""
    Txt_CellPhone.Text = ""
    Cmd_save_tech.Visible = False
    Cmd_rem_tech.Visible = False
    Cmd_Add_tech.Visible = False
    Cbo_security.ListIndex = -1
    
End Sub

Private Sub Cmd_SaveLoc_Click()
    If Cbo_LocType.ListIndex = -1 Then
        MsgBox ("A location Type Must be selected."), vbOKOnly
        Exit Sub
    End If
    
    tAL_Abrv = Trim(Txt_Name.Text)
    tAL_Location_Name = Trim(Txt_Description.Text)
    tAL_Location_type = Cbo_LocType.ItemData(Cbo_LocType.ListIndex)
    If tAL_Location_type = 5 Or tAL_Location_type = 19 Or tAL_Location_type = 20 Then
        If Cbo_Line.ListIndex = -1 Then
            MsgBox ("you need to select a line for this location"), vbOKOnly
            Exit Sub
        End If
        tAL_Line = Cbo_Line.ItemData(Cbo_Line.ListIndex)
    End If
    If Cbo_MaintSec.ListIndex <> -1 Then tAL_Maint_Section = Cbo_MaintSec.ItemData(Cbo_MaintSec.ListIndex)
        
    If Cbo_PMSec.ListIndex <> -1 Then tAL_PM_Section = Cbo_PMSec.ItemData(Cbo_PMSec.ListIndex)

    sSql = "select * from AFC_Location where al_id = '" & tAL_ID & "'"
    Call Get_Location("Read")
    If RS_Location.EOF = True Then
        Call PGBLinsertintoAFC_Location
    Else
        Call PGBLUpdateAFC_Location
        sSql = sSql & "where al_id = " & tAL_ID
    End If
    Call Get_Location("Close")
    SQLData.Execute (sSql)
    Txt_Name.Text = ""
    Txt_Description.Text = ""
    Cbo_LocType.Text = ""
    Cbo_Line.Text = ""
    
    Call Load_Grid_Loc
    Call Load_location_Cbo
    tAL_ID = 0
End Sub

Private Sub cmd_save_inv_Click()
    If Current_User_Level = 9 Then
        tAI_PartType = Trim(Cbo_Parttype(0).Text)
        tAI_OEMPartno = Txt_OemPart.Text
        tAI_CurrentCost = Txt_CurrCost.Text
        tAI_AltPartno = Txt_Altpart.Text
        If Option1(2) = True Then
            tAI_Satellite = "Y"
            If Chk_Franklin.Value = 1 Then
                tAI_Satellite = "F"
            End If
            If Chk_Franklinharvard.Value = 1 Then
                tAI_Satellite = "H"
            End If
            tAI_Required = Txt_SatQty.Text
        Else
            tAI_Satellite = "N"
            tAI_Required = 0
        End If
        tAI_MaxROP = CInt(Txt_MaxROP.Text)
        'tAI_MinROP = CInt(Txt_MinROP.Text)
        If Cbo_RLB.ListIndex <> -1 Then tAI_RLBase = Cbo_RLB.ItemData(Cbo_RLB.ListIndex)
        If Cbo_RLS.ListIndex <> -1 Then tAI_RLSatellite = Cbo_RLS.ItemData(Cbo_RLS.ListIndex)
        tAI_SettelingSB = CLng(Txt_Setteling.Text)
    End If
    tAI_Notes = Trim(Txt_Notes.Text)
    Call PGBLUpdateafc_inventory
    sSql = sSql & "where AI_index = " & tAI_Index
    SQLData.Execute (sSql)

    For Each Contrl In FRM_Main.Controls
    If (TypeOf Contrl Is TextBox) Then Contrl.Text = ""
    Next Contrl

    For Each Contrl In FRM_Main.Controls
    If (TypeOf Contrl Is ComboBox) Then Contrl.Text = ""
    Next Contrl
    
    For Each Contrl In FRM_Main.Controls
    If (TypeOf Contrl Is CheckBox) Then Contrl.Value = 0
    Next Contrl
    
    
    Call Grid_LocBal_Init
    Cbo_Partno.SetFocus
    
End Sub

Private Sub Cmd_save_tech_Click()
    Tech_flag = "Save"
    Call Cmd_Add_tech_Click

End Sub


Private Sub cmd_savepart_Click()
Dim New_ID As Long
    If Txt_NewPart.Text = "" Then Exit Sub
    tAI_PartType = Trim(Cbo_Parttype(0).Text)
    If Cbo_Parttype(0).index = -1 Then
        MsgBox ("A Part type must be selected"), vbOKOnly
    End If

    sSql = "insert into AFC_Inventory(ai_partno, ai_description,ai_parttype) values(" & Txt_NewPart.Text & ",'" & Trim(Txt_NewDesc.Text) & "','" & tAI_PartType & "')"
    SQLData.Execute (sSql)
    sSql = "select Max(ai_index)as maxid from afc_inventory"
    Call Get_Trans("Read")
    New_ID = RS_Trans("maxid")
    
    Call Get_Trans("Close")
    
    For idx = 0 To Lst_UsedIn(1).ListCount - 1
        If Lst_UsedIn(1).Selected(idx) = True Then
            sSql = "insert into afc_where_used (awu_partno,awu_equiptype) values(" & New_ID & "," & Lst_UsedIn(1).ItemData(idx) & ")"
            SQLData.Execute (sSql)
        End If
    Next
    FRM_Newpart.Visible = False
    Call Load_SB_Partno_Cbo
    sSql = "select * from afc_inventory where ai_index = " & New_ID
    Call Get_Inventory("Read")
    If RS_Inventory.EOF = True Then
        MsgBox ("Selected item not found in the Inventory Table"), vbOKOnly
        Call Get_Inventory("Close")
        Exit Sub
    End If
    Cbo_Partno.Text = RS_Inventory("ai_partno")
    Call Display_Part_Data

End Sub



Private Sub Cmd_Verify_Click()
Dim List As String
    
    If Current_User_Branch <> 3 Then
        sSql = "SELECT DISTINCT AFC_Location.AL_Location_Name FROM AFC_Inventory_Trans INNER JOIN AFC_Location ON AFC_Inventory_Trans.AIT_Location = AFC_Location.AL_ID WHERE     (AFC_Inventory_Trans.AIT_TranType = 2)"
        Call Get_Trans("Read")
    
        List = ""
        If RS_Trans.EOF = False Then
            Do While RS_Trans.EOF = False
                If List <> "" Then List = List & ", "
                List = List & Trim(RS_Trans("al_location_name"))
                RS_Trans.MoveNext
            Loop
            MsgBox ("There are unprocessed Damage Transactions For " & List & " on the satellite Inventory Transfer Tab, These Need to be processed before you can scan any verifications"), vbQuestion + vbOKOnly
            Exit Sub
        End If
        Call Get_Trans("Close")
    End If
    
    sSql = "select count(awb_id) as count from afc_workbench where isnull(awb_date_sent,0)=0 and isnull(awb_date_back,0)=0 and isnull(awb_verified,' ') = ' ' and awb_work_Branch =" & Current_User_Branch

    Call Get_Trans("Read")
    
    test = RS_Trans("count")
    Call Get_Trans("Close")
    
    If test = 0 Then
        If MsgBox("There arn't any open Workbench items to be verified.  You must process damages on the Satellite Inventory Transfer tab first.", vbYesNo + vbQuestion) = vbNo Then
            Exit Sub
        End If
    End If
    
    Cmd_Confirm_Dam.Caption = "Confirm Damages"
    
    Call Get_Trans("Close")
    Fra_Receipt.Left = 120
    Fra_Receipt.Top = 120
    Cmd_FindWB.Visible = False
    Cmd_Confirm_Dam.Visible = True
    Fra_Receipt.Visible = True
    WB_Flag = "Verify"
    Label(54) = "Verify Components to W-B"
    Txt_Label.SetFocus

End Sub


Private Sub Component_Usage_Click()
Frm_Component.Show vbModal

End Sub

Private Sub CreateRST_Excel_Click()
    FRM_RST_Sheet.Show vbModal
    
End Sub

Private Sub CRS_Status_Click()
    Report_Name = "CRS Status"
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub Damage_Report_Click()
    Report_Name = "Open Damages"
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub DetailedListing_Click()
    Report_Name = "Incident Detail"
    Frm_Incident.Show vbModal
    Report_Name = ""

End Sub

Private Sub Exit_Click()
    Unload Me

End Sub

Private Sub First_4_Click()
    Report_Name = "First 4"
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub Form_Load()
If Current_User_Level < 5 Then
    Data.Enabled = False
    PW_Reset.Enabled = False
    res_remove.Enabled = False
    Funding_Maint.Enabled = False
    Incidentcodemaint.Enabled = False
    Import_MRI = False
    Inc_inv_missmatch.Enabled = False
End If
    
'A way to stop processing of the application if a necessary shutdown is needed.
'locate the file rename the file to *.down, this will force the termication of the application.

    mappedletter = "\\mbtasql\Sharing and apps\"
    PGBLprogname = App.EXEName
    updowncount = 0
    
    PGBLprogstatus = PGBLcheckprogstat(mappedletter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        SQLData.Close
        Set SQLData = Nothing
        Unload Me
        End
     End If
    
    LBL_ID = "User: " & Current_User_Id & " " & Current_User_Name
    LBL_Station = "Station id: " & m_ComputerName
    SSTab1.Tab = 0
    FRM_Newpart.Visible = False
    FRM_PMovement.Visible = False
    Frm_Inc_excep.Visible = False
    Cbo_Line.Locked = True
    Cbo_Base.Visible = False
    Cmd_Removetrans.Visible = False
    Lbl_sermessage.Visible = False
    Call Load_SB_Partno_Cbo
    Call Load_location_Cbo
    Call Load_Grants
    Txt_Info.Text = "The Satellite Inventory transfer consists of a series of reports " & _
                    "that must be run to compare the required # of assemblies and components " & _
                    "and the actual current on hand.  This report will list only the location/item " & _
                    "combinations that require Parts to be distributed.  Based on this list; the " & _
                    "system will produce a picking list for the runner, and create a transaction " & _
                    "journal to be posted on a location by location basis as parts are delivered " & _
                    "to the satellite locations."
    
    sSql = "select * from afc_parttypes"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        Lst_UsedIn(1).AddItem Trim(RS_Trans("aptdesc"))
        Lst_UsedIn(1).ItemData(Lst_UsedIn(1).NewIndex) = RS_Trans("aptidx")
        RS_Trans.MoveNext
    Loop

    Call Load_Cbo_Loctype_and_Line
    If Current_User_Level < 6 Then
    
'lock Certain fileds on the part/assembly lookup

        Txt_Altpart.Locked = True
        Txt_CurrCost.Visible = False
        Cbo_Parttype(0).Locked = True
        Txt_SatQty.Locked = True
        Txt_MaxROP.Locked = True
        Txt_MinROP.Locked = True
        Cbo_RLB.Locked = True
        Cbo_RLS.Locked = True
        Fra_Sat_avail.Enabled = False
        Txt_Altpart.BackColor = &H80FFFF
        Txt_CurrCost.BackColor = &H80FFFF
        Cbo_Parttype(0).BackColor = &H80FFFF
        Txt_SatQty.BackColor = &H80FFFF
        Txt_MaxROP.BackColor = &H80FFFF
        Txt_MinROP.BackColor = &H80FFFF
        Cmd_addpart.Visible = False
        Cmd_SaveLoc.Visible = False
        
        Cbo_RLS.BackColor = &H80FFFF
        Cbo_RLB.BackColor = &H80FFFF
        Label(15).Visible = False
        Txt_CurrCost.Visible = False
'       option1(2).Enabled = False
'       Option1(3).Enabled = False
    End If
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    SQLData.Close
    Set SQLData = Nothing
    Unload Me
End Sub






Private Sub Funding_Maint_Click()
    If Current_User_Level <> 9 Then
        MsgBox ("You do NOT have the appropriote priviliges to access this utility"), vbOKOnly
        Exit Sub
    End If
    Frm_Funding.Show vbModal
    
End Sub

Private Sub FVM_Detail_Click()
    Frm_Equip.Show vbModal

End Sub

Private Sub FVM_Summ_Click()
    Report_Name = "FVM Gate"
    Frm_RptViewer.Show vbModal
    Report_Name = ""
End Sub

Public Sub Build_Spread_Sheet()
    Dim File As String
    File = "C:\S&B_Ipol_" & SandB_Generate & "_" & Format(Now - 1, "yyyymmdd")
    'File = "C:\S&B_Ipol_" & Format(Ipol_date, "yyyymmdd")
    If Dir(File) <> "" Then
        Kill File
    End If

    Call Build_Excel_Header

    Screen.MousePointer = vbHourglass
    Call Get_Data

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
    
    Set xlApp = CreateObject("Excel.Application")
    Set xlBook = xlApp.Workbooks.Add
    Set xlSheet = xlBook.Worksheets(1)
'   Set excel_app = CreateObject("Excel.Application")

    ' Uncomment this line to make Excel visible.
   xlApp.Visible = False
    ' Create a new spreadsheet.
'   excel_app.Workbooks.Add

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
        .Cells(2, 4).Value = "Station"
        .Cells(2, 4).WrapText = True
        
        .Columns("E:E").ColumnWidth = 20
        .Columns("E:E").HorizontalAlignment = xlCenter
        .Cells(2, 5).Value = "Reported Description of Problem"
        .Cells(2, 5).WrapText = True
        
        .Columns("F:F").ColumnWidth = 20
        .Columns("F:F").HorizontalAlignment = xlCenter
        .Cells(2, 6).Value = "Original Description of Problem"
        .Cells(2, 6).WrapText = True
        
        .Columns("G:G").ColumnWidth = 20
        .Columns("G:G").HorizontalAlignment = xlCenter
        .Cells(2, 7).Value = "Defect Description"
        .Cells(2, 7).WrapText = True
        
        .Columns("H:H").ColumnWidth = 20
        .Columns("H:H").HorizontalAlignment = xlCenter
        .Cells(2, 8).Value = "Action Taken"
        .Cells(2, 8).WrapText = True
        
        .Columns("I:I").ColumnWidth = 20
        .Columns("I:I").HorizontalAlignment = xlCenter
        .Cells(2, 9).Value = "Error Codes from Simm"
        .Cells(2, 9).WrapText = True
        
        .Columns("J:J").ColumnWidth = 12
        .Columns("J:J").HorizontalAlignment = xlCenter
        .Columns("J:J").WrapText = True
        .Cells(2, 10).Value = "Incident Created"
        
        .Columns("K:K").ColumnWidth = 12
        .Columns("K:K").HorizontalAlignment = xlCenter
        .Columns("K:K").WrapText = True
        .Cells(2, 11).Value = "Work Started"
        
        .Columns("L:L").ColumnWidth = 12
        .Columns("L:L").HorizontalAlignment = xlCenter
        .Columns("L:L").WrapText = True
        .Cells(2, 12).Value = "Work Finished"
        
        .Columns("M:M").ColumnWidth = 12
        .Columns("M:M").HorizontalAlignment = xlCenter
        .Cells(2, 13).Value = "Incident Closed"
        .Cells(2, 13).WrapText = True
        
        .Columns("N:N").ColumnWidth = 15
        .Columns("N:N").HorizontalAlignment = xlCenter
        .Cells(2, 14).Value = "Technician"
    
        .Columns("O:O").ColumnWidth = 15
        .Columns("O:O").HorizontalAlignment = xlCenter
        .Cells(2, 15).Value = "Jam Type"
        .Cells(2, 15).WrapText = True
        
        .Columns("P:P").ColumnWidth = 30
        .Columns("P:P").HorizontalAlignment = xlCenter
        .Columns("P:P").WrapText = True
        .Cells(2, 16).Value = "Jam Location"

        .Columns("Q:Q").ColumnWidth = 20
        .Columns("Q:Q").HorizontalAlignment = xlCenter
        .Cells(2, 17).Value = "Item Condition"
        .Cells(2, 17).WrapText = True

        .Columns("R:R").ColumnWidth = 10
        .Columns("R:R").HorizontalAlignment = xlCenter
        .Cells(2, 18).Value = "Jam Reason"
        .Cells(2, 18).WrapText = True

        .Columns("S:S").ColumnWidth = 16
        .Columns("S:S").HorizontalAlignment = xlCenter
        .Cells(2, 19).Value = "OCU_Color"
        .Cells(2, 19).WrapText = True
        
        If SandB_Generate = "FareBox" Then
            .Columns("T:T").ColumnWidth = 10
            .Columns("T:T").HorizontalAlignment = xlCenter
            .Cells(2, 20).Value = "SC-Reader Light"
            .Cells(2, 20).WrapText = True
            
            .Columns("U:U").ColumnWidth = 10
            .Columns("U:U").HorizontalAlignment = xlCenter
            .Cells(2, 21).Value = "Reading Cards?"
            .Cells(2, 21).WrapText = True
            
            .Columns("V:V").ColumnWidth = 10
            .Columns("V:V").HorizontalAlignment = xlCenter
            .Cells(2, 22).Value = "Value Added"
            .Cells(2, 22).WrapText = True
            
            .Columns("W:W").ColumnWidth = 10
            .Columns("W:W").HorizontalAlignment = xlCenter
            .Cells(2, 23).Value = "Change Ticket Issued"
            .Cells(2, 23).WrapText = True
            
            .Columns("Y:Y").ColumnWidth = 30
            .Columns("Y:Y").HorizontalAlignment = xlCenter
            .Cells(2, 25).Value = "Tech Notes"
            .Cells(2, 25).WrapText = True
        
        Else
            .Columns("T:T").ColumnWidth = 30
            .Columns("T:T").HorizontalAlignment = xlCenter
            .Cells(2, 20).Value = "Tech Notes"
            .Cells(2, 20).WrapText = True
        End If
    End With

    ' Comment the rest of the lines to keep
    ' Excel running so you can see it.

    ' Close the workbook without saving.

End Sub

Public Sub Get_Data()
    Dim sline As String
    Dim count As Integer
    
    ' load the base varaibles for the report calculations
    '
    row = 3

    Do While Not RS_Trans.EOF
    
        With xlSheet 'excel_app
       
            .Cells(row, 1).Value = RS_Trans("I_Incidentno")
            
            .Cells(row, 2).Value = RS_Trans("au_mbtano")
            
            .Cells(row, 3).Value = RS_Trans("ai_Description")
            
            .Cells(row, 4).Value = RS_Trans("al_location_name")
            
            .Cells(row, 5).Value = RS_Trans("I_orig_STATUS")
            .Cells(row, 6).Value = RS_Trans("Iorig_description")
            .Cells(row, 7).Value = RS_Trans("IDef_description")
            .Cells(row, 8).Value = RS_Trans("IAct_description")
            .Cells(row, 9).Value = RS_Trans("I_error_Codes")
            .Cells(row, 10).Value = "'" & RS_Trans("I_DT_Reported")
            .Cells(row, 11).Value = "'" & RS_Trans("I_Start_work")
            .Cells(row, 12).Value = "'" & RS_Trans("I_Finish_Work")
            .Cells(row, 13).Value = "'" & RS_Trans("I_DT_Closed")
            .Cells(row, 14).Value = Trim(RS_Trans("at_empfname")) & " " & Trim(RS_Trans("at_Emplname"))
            count = 0
            If RS_Trans("ibj_id") <> 0 Then
                .Cells(row, 15).Value = "Bill Jam"
                .Cells(row, 16).Value = RS_Trans("Bill_Jam_Location")
                .Cells(row, 17).Value = RS_Trans("Bill_Jam_Condition")
                .Cells(row, 18).Value = "Belt Off(" & RS_Trans("Belts_Off") & ")"
                If SandB_Generate = "FareBox" Then
                    .Cells(row, 19).Value = "OCU Color (" & RS_Trans("Bill_OCUcolor") & ")"
                End If
                count = count + 1
            End If
            
            If RS_Trans("itj_id") <> 0 Then
                If Trim(RS_Trans("Gate_Ticket_Jam")) = "" Then
                    .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                    .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                    .Cells(row + count, 15).Value = "Ticket Jam FVM"
                    .Cells(row + count, 16).Value = RS_Trans("FVM_Ticket_Jam")
                    .Cells(row + count, 17).Value = RS_Trans("Ticket_Jam_Condition")
                    .Cells(row + count, 18).Value = ""
                Else
                    .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                    .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                    .Cells(row + count, 15).Value = "Ticket Jam Gate"
                    .Cells(row + count, 16).Value = RS_Trans("Gate_Ticket_Jam")
                    .Cells(row + count, 17).Value = RS_Trans("Ticket_Jam_condition")
                    .Cells(row + count, 18).Value = ""
                    If SandB_Generate = "FareBox" Then
                        .Cells(row + count, 19).Value = "OCU Color (" & RS_Trans("Ticket_OCUcolor") & ")"
                    End If
                    count = count + 1
                End If
            End If
            
            If RS_Trans("icj_id") <> 0 Then
                .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                .Cells(row + count, 15).Value = "Coin Jam"
                .Cells(row + count, 16).Value = RS_Trans("Coin_Jam")
                If Trim(RS_Trans("coin_jam")) = "Other" Then
                    .Cells(row + count, 16).Value = RS_Trans("ICJ_Loc_Other")
                End If
                
                .Cells(row + count, 17).Value = RS_Trans("Coin_Jam_Reason")
                If Trim(RS_Trans("coin_jam_reason")) = "Other" Then
                    .Cells(row + count, 17).Value = RS_Trans("ICJ_Res_Other")
                End If
                .Cells(row + count, 18).Value = ""
                If SandB_Generate = "FareBox" Then
                    .Cells(row + count, 19).Value = "OCU Color (" & RS_Trans("Coin_OCUcolor") & ")"
                End If
                count = count + 1
            End If
            
            If RS_Trans("io_id") <> 0 Then
                .Cells(row + count, 1).Value = RS_Trans("I_Incidentno")
                .Cells(row + count, 2).Value = RS_Trans("au_mbtano")
                .Cells(row + count, 15).Value = "Other Issue"
                .Cells(row + count, 16).Value = RS_Trans("Io_other")
            End If
            If RS_Trans("Isc_ID") <> 0 Then
                .Cells(row, 20).Value = RS_Trans("isc_ocucolor")
                .Cells(row, 21).Value = RS_Trans("isc_Reader")
                .Cells(row, 22).Value = RS_Trans("isc_Value")
                .Cells(row, 23).Value = RS_Trans("isc_chticket")
            End If
        End With
        row = (row + count + 1)

Next_Record:
        RS_Trans.MoveNext
    Loop
    
End Sub

Private Sub Generate_Subway_Click()
    SandB_Generate = "Subway"
    sSql = "exec SandB_Ipol '" & Format(Now - 1, "mm/dd/yyyy") & "',2"
    
    Call Get_Trans("Read")
    If RS_Trans.EOF = True Then
        MsgBox ("File has already been generated")
    End If
    
    Call Build_Spread_Sheet
    SandB_Generate = ""

End Sub

Private Sub Geterate_Farebox_Click()
    SandB_Generate = "FareBox"
    sSql = "exec SandB_Ipol '" & Format(Now - 1, "mm/dd/yyyy") & "',3"
    
    Call Get_Trans("Read")
    If RS_Trans.EOF = True Then
        MsgBox ("File has already been generated")
    End If
    
    Call Build_Spread_Sheet
    SandB_Generate = ""
End Sub

Private Sub Grid_Equip_Click()
    LG_GridIdx = Grid_LocBal.row

    LG_GridIdx = Grid_Equip.row
    If LG_GridIdx = 0 Then
        Grid_Equip.FixedRows = 1
        Grid_Equip.sort = 1
        Grid_Equip.Refresh
        Grid_Equip.FixedRows = 0
        Txt_MBTAno.Text = ""
        Txt_SBSerial.Text = ""
        Txt_Rollout.Text = ""
        Cbo_Partno3.ListIndex = -1
        Cbo_Locations3.ListIndex = -1
        Exit Sub
    End If
    If Current_User_Level < 5 Then Exit Sub
    
    For step = 0 To Cbo_Partno3.ListCount
        If Cbo_Partno3.ItemData(step) = CInt(Trim(Grid_Equip.TextMatrix(LG_GridIdx, 8))) Then
            Cbo_Partno3.ListIndex = step
            step = Cbo_Partno3.ListCount
        End If
    Next
        sSql = "select ai_currentcost from afc_inventory where ai_index = " & Grid_Equip.TextMatrix(LG_GridIdx, 8)

    For step = 0 To Cbo_Locations3.ListCount
        If Cbo_Locations3.ItemData(step) = CInt(Trim(Grid_Equip.TextMatrix(LG_GridIdx, 9))) Then
            Cbo_Locations3.ListIndex = step
            step = Cbo_Locations3.ListCount
        End If
    Next
    For step = 0 To Combo(1).ListCount
        If Combo(1).ItemData(step) = CInt(Trim(Grid_Equip.TextMatrix(LG_GridIdx, 11))) Then
            Combo(1).ListIndex = step
            step = Combo(1).ListCount
        End If
    Next
    For step = 0 To Combo(2).ListCount
        If Combo(2).ItemData(step) = CInt(Trim(Grid_Equip.TextMatrix(LG_GridIdx, 10))) Then
            Combo(2).ListIndex = step
            step = Combo(1).ListCount
        End If
    Next
    For step = 0 To Combo(0).ListCount
        If Combo(0).ItemData(step) = CInt(Trim(Grid_Equip.TextMatrix(LG_GridIdx, 12))) Then
            Combo(0).ListIndex = step
            step = Combo(0).ListCount
        End If
    Next
    Debug.Print sSql
    
    Set RS_Work = New ADODB.Recordset
    Set RS_Work = SQLData.Execute(sSql)
    Txt_Cost.Text = FormatCurrency(RS_Work("ai_currentcost"))
    RS_Work.Close
    Set RS_Work = Nothing
    
    Txt_MBTAno.Text = Trim(Grid_Equip.TextMatrix(LG_GridIdx, 2))
    Txt_SBSerial.Text = Trim(Grid_Equip.TextMatrix(LG_GridIdx, 4))
    Txt_Rollout.Text = Trim(Grid_Equip.TextMatrix(LG_GridIdx, 5))
    Chk_Moved = 0
    If Trim(Grid_Equip.TextMatrix(LG_GridIdx, 6)) = "Yes" Then
        Chk_Moved = 1
    End If
    Unit_Modify = True
    tAU_Index = Trim(Grid_Equip.TextMatrix(LG_GridIdx, 0))

End Sub

Private Sub Grid_LocBal_Click()
Dim Reserved As Long
Dim Onhand As Long
Dim Damaged As Long

    If Grid_LocBal.col <> 1 And Grid_LocBal.col <> 6 Then Exit Sub
    
    If Grid_LocBal.col = 6 Then
        Frm_Reservations.Show vbModal
        Exit Sub
    End If
    LG_GridIdx = Grid_LocBal.row
    If CLng(Grid_LocBal.TextMatrix(LG_GridIdx, 0)) = 0 Then Exit Sub

    Exit Sub
    If LG_GridIdx < 1 Then Exit Sub
    
    Option1(7).Enabled = True  'take part
    Option1(6).Enabled = True 'reserve part
    Option1(8).Enabled = True ' unreserve

    tAT_ID = Grid_LocBal.TextMatrix(LG_GridIdx, 0)
    ' Pos 2 is reservations, pos 3 is onhand, pos 4 is damaged
    'Check to see if there are any reservations on the part
    Reserved = CLng(Grid_LocBal.TextMatrix(LG_GridIdx, 2))
    Onhand = CLng(Grid_LocBal.TextMatrix(LG_GridIdx, 3))
    Damaged = CLng(Grid_LocBal.TextMatrix(LG_GridIdx, 4))
    
    If Reserved = 0 Then
        Option1(8).Enabled = False ' unreserve part
        Option1(7).Enabled = False ' take part
    End If
    
    If Onhand - Reserved <= 0 Then
        Option1(6).Enabled = False ' reserve part
    End If
    
    
' set default location for product movement

    Dprimer = Prime_Cbo(Cbo_Locations, Trim(Grid_LocBal.TextMatrix(LG_GridIdx, 1)), True)
    Option1(7).Value = False ' take part
    Option1(6).Value = False ' reserve part
    Option1(9).Value = False ' untake part
    Option1(8).Value = False ' unreserve
    Option1(10).Value = False ' return damage
    FRM_PMovement.Top = 3120
    FRM_PMovement.Left = 360
    FRM_PMovement.Visible = True
    
End Sub

Private Sub Grid_tech_Click()
    
 LG_GridIdx = Grid_Tech.row
    If LG_GridIdx = 0 Then
        Grid_Tech.FixedRows = 1
        Grid_Tech.sort = 1
        Grid_Tech.Refresh
        Grid_Tech.FixedRows = 0
        Exit Sub
    End If
    
    If Current_User_Level <> 9 Then Exit Sub
        
    tAT_ID = Grid_Tech.TextMatrix(LG_GridIdx, 0)
    tAT_Empno = Trim(Grid_Tech.TextMatrix(LG_GridIdx, 1))
    tAT_EmpFname = Trim(Grid_Tech.TextMatrix(LG_GridIdx, 2))
    tAT_EmpLName = Trim(Grid_Tech.TextMatrix(LG_GridIdx, 3))
    tAT_Access_level = CLng(Trim(Grid_Tech.TextMatrix(LG_GridIdx, 5)))
    Txt_tech.Text = tAT_Empno
    Txt_techfname.Text = tAT_EmpFname
    Txt_techlname.Text = tAT_EmpLName
    For step = 0 To Cbo_security.ListCount
        If Cbo_security.ItemData(step) = CInt(Trim(Grid_Tech.TextMatrix(LG_GridIdx, 5))) Then
            Cbo_security.ListIndex = step
            step = Cbo_security.ListCount
        End If
    Next
    For step = 0 To Cbo_Branch.ListCount
        If Cbo_Branch.ItemData(step) = CInt(Trim(Grid_Tech.TextMatrix(LG_GridIdx, 7))) Then
            Cbo_Branch.ListIndex = step
            step = Cbo_security.ListCount
        End If
    Next
    Txt_CellPhone.Text = Grid_Tech.TextMatrix(LG_GridIdx, 4)
    Cmd_save_tech.Visible = True
    Cmd_Reset.Visible = True
    Cmd_Add_tech.Visible = False
    Cmd_rem_tech.Visible = True
    
End Sub

Private Sub Grid_Trans_KeyPress(KeyAscii As Integer)

    With Grid_Trans
        If .col <> 5 And .col <> 6 And .col <> 10 Then Exit Sub
        If .TextMatrix(.row, 4) <> "Damage" And .col <> 5 Then
            MsgBox ("You can only add serial #'s and Notes to damaged items"), vbOKOnly
            Exit Sub
        End If
        Select Case KeyAscii
            Case 8
                If Not .Text = "" Then
                    .Text = Left(.Text, Len(.Text) - 1)
                End If
            Case 9 ' Tab
                If .col + 1 = .Cols Then
                    .col = 0
                    If .row + 1 = .Rows Then
                        .row = 0
                    Else
                        .row = .row + 1
                    End If
                Else
                    .col = .col + 1
                End If
            Case Else
                .Text = .Text & Chr(KeyAscii)
        End Select
    End With

End Sub

Private Sub Grid_Trans_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 And Shift = 1 Then
        If MsgBox("Do you want to remove this item from the list?", vbYesNo + vbCritical) = vbNo Then
            Exit Sub
        Else
            LG_GridIdx = Grid_Trans.row
            sSql = "delete from afc_inventory_trans where ait_id = " & CLng(Grid_Trans.TextMatrix(LG_GridIdx, 0))
            SQLData.Execute (sSql)
            Grid_Trans.RemoveItem (LG_GridIdx)
            MsgBox ("The Item Has been removed from list")
        End If
    End If

End Sub

Private Sub Grid_Transactions_Click()

    LG_GridIdx = Grid_Transactions.row
    If LG_GridIdx = 0 Then
        Grid_Transactions.FixedRows = 1
        Grid_Transactions.sort = 1
        Grid_Transactions.Refresh
        Grid_Transactions.FixedRows = 0
        Call Reset_Cmd_Add_Trans
        Exit Sub
    End If

    LG_GridCol = Grid_Transactions.col
    Dim test As String
    test = Grid_Transactions.RowSel
    
    sSql = "select * from afc_phyreceipt where apr_index =" & Grid_Transactions.TextMatrix(LG_GridIdx, 0)
    Call Get_Trans("Read")
    For step = 0 To Cbo_Partno2.ListCount
        If Cbo_Partno2.ItemData(step) = RS_Trans("apr_Partno") Then
            Cbo_Partno2.ListIndex = step
            step = Cbo_Partno2.ListCount
        End If
    Next
    
    For step = 0 To Cbo_Locations2.ListCount
        If Cbo_Locations2.ItemData(step) = RS_Trans("apr_location") Then
            Cbo_Locations2.ListIndex = step
            step = Cbo_Locations2.ListCount
        End If
    Next
    
    Select Case RS_Trans("apr_trantype")
    Case "Receipt"
        Option1(1) = True
    Case "Physical"
        Option1(0) = True
    End Select
    Txt_TransQty.Text = RS_Trans("apr_qty")
    Cmd_add_trans.Caption = "Save Changes"
    Cmd_Removetrans.Visible = True
End Sub

Private Sub Grid_WB_Click()

    LG_GridIdx = Grid_WB.row
    Dim col As Long
    col = Grid_WB.col
    If col = 6 Then Grid_WB.col = 11
    If col = 7 Then Grid_WB.col = 12
    If col = 8 Then Grid_WB.col = 13
        Grid_WB.FixedRows = 1
        Grid_WB.sort = 1
        Grid_WB.Refresh
        Exit Sub

End Sub

Private Sub Grid_WB_Open_Click()
Dim ID As Long
    If MsgBox("Are you sure you wish to change this serial number?", vbExclamation + vbYesNo) = vbNo Then
        Exit Sub
    End If
    
    LG_GridIdx = Grid_WB_Open.row
    ID = CLng(Grid_WB_Open.TextMatrix(LG_GridIdx, 0))
    sSql = "update AFC_WorkBench set awb_serialno = '" & Trim(Txt_RecSerial.Text) & "', awb_verified='Y' where awb_id = " & ID
    SQLData.Execute (sSql)
    Grid_WB_Open.Visible = False
    Grid_WB.Visible = True
    Cmd_Add_WB.Visible = False
    Call Confirm_Incident
    tATH_Part_Serialno = Txt_RecSerial.Text
    Call PGBLinsertintoAFC_Transaction_History
    SQLData.Execute (sSql)
    Call Load_Grid_WB

    Txt_RecSerial.Text = ""
    Cbo_Partno.ListIndex = -1
    Txt_Label.Text = ""
    Txt_Label.SetFocus
End Sub

Private Sub Import_MRI_Click()
    Frm_FileFinder.Show vbModal
End Sub

Private Sub Inc_inv_missmatch_Click()
    Frm_Incident_MM.Show vbModal

End Sub

Private Sub Incidentcodemaint_Click()
Frm_ICodes.Show vbModal
End Sub


Private Sub Inv_All_Click()
    Report_Name = "INV Reconcile"
    Rpt_Outstanding = ""
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub INV_Open_Click()
    Report_Name = "INV Reconcile"
    Rpt_Outstanding = "Y"
    Frm_RptViewer.Show vbModal
    Rpt_Outstanding = ""
    
    Report_Name = ""

End Sub

Private Sub Inv_phys_Click()
    Report_Name = "Physical Rpt"
    Frm_Location.Show vbModal
    
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub inv_recon_Click()
    Report_Name = "INV Reconcile"
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub Location_Inventory_Click()
    Report_Name = "Location Rpt"
    Frm_Location.Show vbModal
    If Rpt_Location <> 0 Then
        Frm_RptViewer.Show vbModal
    End If
    Report_Name = ""
End Sub

Private Sub Location_primer_Click()
    Frm_Loc_Prime.Show vbModal
End Sub

Private Sub Logout_Click()
    Unload Me
    Current_User_Index = 0
    Current_User_Id = 0
    Current_User_Name = ""
    Current_User_Level = 0
    Call Main
End Sub



Private Sub Mastercomplist_Click()
    Report_Name = "Master_Component_Report"
    'Frm_Location.Show vbModal
    'If Rpt_Location <> 0 Then
        Frm_RptViewer.Show vbModal
    'End If
    Report_Name = ""
End Sub

Private Sub Open_WBItems_Click()
    Report_Name = "Open WB Items"
    Frm_RptViewer.Show vbModal
    Report_Name = ""

End Sub

Private Sub Meantimetorepair_Click()
    Report_Name = "Mean Time"
    Frm_Meantime.Show vbModal
    Report_Name = ""

End Sub

Private Sub Option1_Click(index As Integer)
Select Case index
Case 0
    Txt_Packlist.Text = ""
End Select
End Sub

Private Sub Parts_Click()
Frm_Ordered.Show vbModal
End Sub

Private Sub PW_Reset_Click()
    If Current_User_Level <> 9 Then
        MsgBox ("You Dont have Access to this option")
        Exit Sub
    End If
    PW_Option = "Reset"
    Frm_Login.Show vbModal
    
End Sub

Private Sub res_remove_Click()
    If Current_User_Level <> 9 Then Exit Sub
    Frm_Res_Rem.Show vbModal

End Sub

Private Sub SSTab1_Click(PreviousTab As Integer)

    'SSTab1.Picture.Render (0,0,0,0,0)
    Select Case SSTab1.Tab
    Case 0 'HOME
    
    Case 1  ' Part/Assembly Lookup
        Call Clear_tab(1)
        Call Load_location_Cbo
        Cbo_Partno.SetFocus
        
    Case 2  ' Satelite Inventory Transfer
            ' checks on whether the transfer process has started as of yet.  if so don't
            ' allow it to be restarted.
            Cbo_Base.Visible = False
            Label(30).Visible = False
            Lbl_sermessage.Visible = False
            Cmd_Manual_Trans.Visible = True
            Fra_Manual.Visible = False
            Label(31).Visible = False
        If Current_User_Branch = 2 Then
            If Current_User_Level < 6 Then
                Fra_Inv_Transfer.Visible = False
                Exit Sub
            End If
        Else
            Fra_Inv_Transfer.Visible = True
            If Current_User_Branch = 3 Then
                Cmd_Close_man.Visible = False
                Call Cmd_Manual_Trans_Click
            End If

        End If
        sSql = "select distinct al_id, al_abrv, al_location_name from AFC_Inventory_trans ait " & _
                "left outer join afc_location al on ait.ait_location=al.al_id"
        Call Get_Location("Read")
            
        If RS_Location.EOF = False Then
            Cbo_Location4.Clear
'            Cmd_Sat_requirements.Enabled = False
            Cbo_Locations4.Enabled = True
            Do While RS_Location.EOF = False
                sline = Trim(RS_Location("al_abrv")) & " " & Trim(RS_Location("al_location_name"))
                Cbo_Location4.AddItem sline
                Cbo_Location4.ItemData(Cbo_Location4.NewIndex) = RS_Location("al_id")
                RS_Location.MoveNext
            Loop
            Get_Location ("Close")
            Cbo_Locations4.Clear
            sSql = "select * from afc_location where al_location_Type = 2"
            Call Get_Trans("Read")
            Do While RS_Trans.EOF = False
                sSql = "select * from afc_inventory_Trans where ait_location=" & RS_Trans("al_id")
                Call Get_Location("Read")
                If RS_Location.EOF = True Then
                    sline = Trim(RS_Trans("al_abrv")) & " " & Trim(RS_Trans("al_location_name"))
                    Cbo_Locations4.AddItem sline
                    Cbo_Locations4.ItemData(Cbo_Locations4.NewIndex) = RS_Trans("al_id")
                End If
                RS_Trans.MoveNext
            Loop
            
            
            Cmd_Process_move.Visible = True
            Cbo_Location4.Visible = True
            'Label34.Visible = True
            Grid_Trans.Visible = True
            'Label59.Visible = True
            Cbo_Base.Clear
            sSql = "select * from AFC_Location where al_location_type = 1"
            Call Get_Location("Read")
            index = 0
            
            ' checking to see if there is more than 1 master warehouse.
            
            Do While RS_Location.EOF = False
                index = index + 1
                sline = Trim(RS_Location("AL_Abrv")) & "  " & _
                        Trim(RS_Location("AL_Location_Name"))
                Cbo_Base.AddItem sline
                Cbo_Base.ItemData(Cbo_Base.NewIndex) = RS_Location("al_id")
                RS_Location.MoveNext
                
            Loop
            If index > 1 Then
                Master_Base = 0
                Cbo_Base.Visible = True
            Else
                RS_Location.MoveFirst
                
                Cbo_Base.Visible = False
                Master_Base = RS_Location("al_id")
            End If

        Else
            Cmd_Sat_requirements.Enabled = True
            Cbo_Locations4.Enabled = True
            Cmd_Process_move.Visible = False
            Cbo_Location4.Visible = False
            Label(32).Visible = False
            Grid_Trans.Visible = False

        End If
        Call Get_Location("Close")
    
    Case 3  'Work Bench (transfer from holding to Burlington and MBTA work bench
        'If Current_User_Branch <> 3 Then
        '    Cmd_AssBurlington.Enabled = False
        'End If
        
        IT_Incident = 0
        IT_Partno = 0
        Txt_Serial.Text = ""
        Txt_Partno.Text = ""
        IT_Machineno = 0
        Frm_Inc_excep.Visible = False

        If Current_User_Level < 6 Then
            Fra_Workbench.Visible = False
        Else
            Fra_Workbench.Visible = True
        End If
        Cmd_Qa.Visible = False
        Fra_Receipt.Visible = False
        'Label49.Visible = False
        Txt_Out_Date.Visible = False
        cmd_out_date.Visible = False
        Grid_WB_Open.Visible = False
        Cmd_Add_WB.Visible = False
        Call Load_Grid_WB

    Case 4  ' Physical/Receiving Inv.
        If Current_User_Branch = 2 Then
            If Current_User_Level < 6 Then
                Fra_Physical.Visible = False
                Exit Sub
            End If
            Fra_Physical.Visible = True
            Call Load_Grid_Transactions
            Cbo_Partno2.SetFocus
            Fra_Physical.Visible = True
            Call Load_Grid_Transactions
            Cbo_Partno2.SetFocus
            Exit Sub
        End If
        If Current_User_Branch = 3 Then
            If Current_User_Level >= 5 Then
                Option1(1).Visible = False
                Chk_First4.Visible = False
                Chk_Setteling.Visible = False
                Txt_Packlist.Visible = False
                Label(6).Visible = False
                Fra_Physical.Visible = True
                Call Load_Grid_Transactions
                Cbo_Partno2.SetFocus
                Exit Sub
            Else
                Fra_Physical.Visible = False
                Exit Sub
               End If
        End If
        If Current_User_Branch = 1 And Current_User_Level < 9 Then
            Fra_Physical.Visible = False
            Exit Sub
        End If
            Fra_Physical.Visible = True
            Call Load_Grid_Transactions
            Cbo_Partno2.SetFocus
            Fra_Physical.Visible = True
            Call Load_Grid_Transactions
            Cbo_Partno2.SetFocus

        
    Case 5  'Gate && FVM Tracking
        
        Call Grid_Equip_Init
        Frame1.Visible = False
        Fra_Equipopt.Visible = True
        Fra_Equipopt.Left = 240
        Fra_Equipopt.Top = 720

    Case 6  'Location Maintenance
        If Current_User_Level < 5 Then
            Fra_Location.Visible = False
        Else
            Fra_Location.Visible = True
            Txt_Name.SetFocus
        End If
        
        Call Load_Grid_Loc
        tAL_ID = 0

    Case 7  'Technician View/Maintenance
        If Current_User_Level < 9 Then
            FRA_Tech.Visible = False
            Grid_Tech.Width = 6000
        Else
            FRA_Tech.Visible = True
            Grid_Tech.Width = 7500

        End If
        
        Call Load_Grid_Tech
        
    End Select

        
End Sub
Private Sub Load_Grid_WB()

Call Grid_WB_Init
    
    sSql = "SELECT aw.AWB_Id, aw.AWB_Serialno, aw.AWB_Date_collected, aw.AWB_Date_Sent, " & _
            "aw.AWB_Date_Back, isnull(aw.awb_altserialno,'') as awb_altserialno ,isnull(aw.AWB_Notes,'') as AWB_Notes, ai.AI_Partno, ai.AI_Description, ai.AI_PartType, " & _
            "alt.AL_location_name " & _
            "FROM AFC_WorkBench aw " & _
            "Inner Join AFC_Location alt ON aw.AWB_Location= alt.AL_ID " & _
            "INNER JOIN AFC_Inventory ai ON aw.AWB_Partno = ai.AI_Index "
            If WB_Flag = "Receive" Then
                If Current_User_Branch = 1 Then
                    sSql = sSql & " where (isnull(aw.awb_date_back,0) = 0 or isnull(aw.awb_date_back,0) > dateadd(mm,-1,getdate()))" & _
                    " order by aw.awb_date_sent, aw.awb_date_back, ai.ai_partno"
                Else
                    sSql = sSql & " where (isnull(aw.awb_date_back,0) = 0 or isnull(aw.awb_date_back,0) > dateadd(mm,-1,getdate()))" & _
                    " and awb_work_branch = " & Current_User_Branch & " order by aw.awb_date_sent, aw.awb_date_back, ai.ai_partno"
                End If
            Else
                If Current_User_Branch = 1 Then
                    sSql = sSql & " where (isnull(aw.awb_verified,'')='' or (isnull(aw.awb_date_back,0) = 0 and isnull(aw.awb_date_back,0) > dateadd(mm,-2,getdate()))) order by aw.awb_date_sent, aw.awb_date_back, ai.ai_partno"
                Else
                    sSql = sSql & " where (isnull(aw.awb_verified,'')='' or (isnull(aw.awb_date_back,0) = 0 and isnull(aw.awb_date_back,0) > dateadd(mm,-2,getdate()))) and awb_work_branch = " & Current_User_Branch & " order by aw.awb_date_sent, aw.awb_date_back, ai.ai_partno"
                End If
            End If
            Debug.Print sSql
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        sline = RS_Trans("awB_id") & vbTab & _
                RS_Trans("ai_partno") & vbTab & _
                RS_Trans("ai_description") & vbTab & _
                RS_Trans("awb_serialno") & vbTab & _
                RS_Trans("ai_parttype") & vbTab & _
                RS_Trans("al_location_name") & vbTab & _
                RS_Trans("awb_date_collected") & vbTab & _
                RS_Trans("awb_date_sent") & vbTab & _
                RS_Trans("awb_date_back") & vbTab & _
                RS_Trans("awb_altserialno") & vbTab & _
                RS_Trans("awb_notes") & vbTab & _
                Format(RS_Trans("awb_date_collected"), "yyyymmdd") & vbTab & _
                Format(RS_Trans("awb_date_sent"), "yyyymmdd") & vbTab & _
                Format(RS_Trans("awb_date_back"), "yyyymmdd")
        Grid_WB.AddItem sline
        
        RS_Trans.MoveNext
    Loop
End Sub

Private Sub Load_Grid_Tech()
Dim Dis_level As String
Dim dis_phone As String

    Call Grid_Tech_Init
    sSql = "select * from AFC_technicians order by at_empno"
    Call Get_Tech("Read")
    If RS_Tech.EOF Then
        MsgBox ("There are no Technicians available.")
        Call Get_Tech("Close")
        Exit Sub
    End If

    Do While RS_Tech.EOF = False
        Call PGBLRecToTemp_afc_technicians(RS_Tech)
        For index = 0 To 4
            If Cbo_security.ItemData(index) = tAT_Access_level Then
                Dis_level = Cbo_security.List(index)
                index = 4
            End If
        Next
        dis_phone = Format$(tAT_CellPhone, "(000)000-0000")

        
        sline = RS_Tech("AT_ID") & vbTab & _
        RS_Tech("AT_Empno") & vbTab & _
        RS_Tech("AT_EmpFname") & vbTab & _
        RS_Tech("AT_EmpLName") & vbTab & _
        dis_phone & vbTab & _
        RS_Tech("AT_Access_level") & vbTab & _
        Dis_level & vbTab & _
        RS_Tech("AT_Branch")

        
        Grid_Tech.AddItem sline
        RS_Tech.MoveNext
    Loop
    Txt_tech.Text = ""
    Txt_techfname.Text = ""
    Txt_techlname.Text = ""
    Cmd_Add_tech.Visible = False
    Cmd_rem_tech.Visible = False
    Cmd_save_tech.Visible = False
    
End Sub
Private Sub Load_Grid_Loc()
' Loads the location grid for viewing and maintenance purposes.

    Call Grid_Loc_Init
    sSql = "select al.al_id, al.al_abrv, al.al_location_name, alt.alt_index, alt.alt_description,isnull(alt2.alt_index,0) as line_index, isnull(alt2.alt_description,' ')as line_desc, isnull(al.al_Maint_Section,0) as Al_Maint_Section, isnull(al.AL_PM_Section,0) as AL_PM_Section from AFC_location al " & _
    " left outer join afc_locationtype alt on alt.alt_index = al.al_location_type" & _
    " left outer join afc_locationtype alt2 on alt2.alt_index = al.al_line"
    
    Call Get_Location("Read")
    If RS_Location.EOF Then
        MsgBox ("There are no Satellite Locations available.")
        Call Get_Location("Close")
        Exit Sub
    End If

    Do While RS_Location.EOF = False
        
        sline = RS_Location("AL_ID") & vbTab & _
        RS_Location("AL_Abrv") & vbTab & _
        RS_Location("AL_Location_Name") & vbTab & _
        RS_Location("alt_index") & vbTab & _
        RS_Location("alt_description") & vbTab & _
        RS_Location("Line_index") & vbTab & _
        RS_Location("Line_desc") & vbTab & _
        RS_Location("AL_Maint_section") & vbTab & _
        RS_Location("AL_PM_Section")
        Grid_Loc.AddItem sline
        RS_Location.MoveNext
    Loop
    Call Get_Location("Close")
End Sub
Private Sub Load_Grid_Trans()
Dim transtype(2) As String
Dim Notes As String
Dim Serials As String
    
    transtype(0) = ""
    transtype(1) = "Fullfillment"
    transtype(2) = "Damage"
    Lbl_sermessage.Visible = False
    
    Call Grid_Trans_Init
    
    sSql = "SELECT ait.AIT_Id, ait.ait_partno as ait_partno, ait.ait_location as ait_location, ait.AIT_TranType AS AIT_TranType, ait.AIT_Qty AS AIT_Qty, al.AL_Abrv AS AL_Abrv, " & _
                "al.AL_Location_Name AS AL_Location_Name, al.AL_ID AS AL_ID, ai.AI_Partno AS AI_Partno, " & _
                "ai.AI_Description AS AI_Description, ai.ai_parttype as ai_parttype " & _
                "FROM AFC_Inventory_Trans ait " & _
                "INNER JOIN AFC_Location al ON ait.AIT_Location = al.AL_ID " & _
                "INNER JOIN AFC_Inventory ai ON ait.AIT_Partno = ai.AI_Index " & _
                "where ait.ait_location = " & Cbo_Location4.ItemData(Cbo_Location4.ListIndex)
    
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        Notes = ""
        Serials = ""
        If RS_Trans("ait_trantype") = 2 Then
            Lbl_sermessage.Visible = True
            sSql = "select isnull(ath_part_serialno,'') as ath_part_serialno, isnull(ath_comments,' ') as ath_comments from afc_transaction_history where ath_tran_type = 3 and isnull(ath_closed,0) = 0 and ath_location = " & Cbo_Location4.ItemData(Cbo_Location4.ListIndex) & " and ath_partno = " & RS_Trans("Ait_Partno")
            Call Get_Work("Read")
            Do While RS_Work.EOF <> True
                If Notes <> "" Then
                    Notes = Notes + ": "
                End If
                If RS_Work("ATH_Comments") <> "" Then
                    Notes = Notes + Trim(RS_Work("ATH_Comments"))
                Else
                    Notes = Notes + "-"
                End If
                
                If Serials <> "" Then
                    Serials = Serials + ","
                End If
                If RS_Work("ath_part_serialno") <> "" Then
                    Serials = Serials & RS_Work("ath_part_serialno")
                Else
                    Serials = Serials + "-"
                End If
            RS_Work.MoveNext
            Loop
        Call Get_Work("Close")
        End If
        sline = RS_Trans("ait_id") & vbTab & _
        Trim(RS_Trans("al_abrv")) & "  " & Trim(RS_Trans("AL_Location_name")) & vbTab & _
        Trim(RS_Trans("ai_partno")) & "   " & Trim(RS_Trans("ai_Description")) & vbTab & _
        Trim(RS_Trans("ai_parttype")) & vbTab & _
        transtype(RS_Trans("ait_trantype")) & vbTab & _
        RS_Trans("ait_qty") & vbTab & _
        Serials & vbTab & _
        RS_Trans("ait_partno") & vbTab & _
        RS_Trans("ait_location") & vbTab & _
        RS_Trans("ait_trantype") & vbTab & _
        Notes
        
        Grid_Trans.AddItem sline
        RS_Trans.MoveNext
        
    Loop
End Sub

Private Sub Load_Grid_Transactions()
    Call Grid_Transactions_Init
    sSql = "SELECT ap.APR_Index, ap.APR_Qty, ap.APR_Trantype, apr_first4, apr_packlist, ai.AI_Partno, " & _
    "ai.AI_Description, al.AL_Abrv, al.AL_Location_Name " & _
    "FROM AFC_PhyReceipt ap " & _
    "INNER JOIN AFC_Location al ON ap.APR_Location = al.AL_ID " & _
    "INNER JOIN AFC_Inventory ai ON ap.APR_Partno = ai.AI_Index order by al.al_location_name, ai.ai_partno"
    Call Get_Trans("Read")
    If RS_Trans.EOF = True Then Exit Sub

    Do While RS_Trans.EOF = False
    
        sline = RS_Trans("apr_index") & vbTab & _
        Trim(RS_Trans("ai_partno")) & vbTab & _
        Trim(RS_Trans("ai_description")) & vbTab & _
        Trim(RS_Trans("al_abrv")) & "  " & Trim(RS_Trans("al_location_name")) & vbTab & _
        RS_Trans("apr_qty") & vbTab & _
        RS_Trans("APR_Trantype") & vbTab & _
        RS_Trans("APr_First4") & vbTab & _
        RS_Trans("APR_PackList")
        Grid_Transactions.AddItem sline
        RS_Trans.MoveNext
    Loop
    Get_Trans ("Close")
End Sub
Private Sub Load_Grid_Equip()
    Dim yesno As String
    Call Grid_Equip_Init
    
    sSql = "SELECT au.AU_Index, au.AU_MBTAno, au.AU_Serialno, au.AU_DateRolledOut, isnull(Au_Moved,'') as au_moved, isnull(au_condition,0) as au_condition, isnull(AU_FederalFunding,0) as au_FederalFunding, " & _
    "isnull(AU_StateFunding,0) as au_StateFunding, ai.ai_index, ai.AI_Description, ai.AI_Partno, al_id, al.AL_Abrv, al.AL_Location_Name " & _
    "FROM AFC_UnitTable au " & _
    "INNER JOIN AFC_Inventory ai ON au.AU_Partno = ai.AI_Index " & _
    "INNER JOIN AFC_Location al ON au.AU_Location = al.AL_ID "
    
    If Equip_Opt = 1 Then
        sSql = sSql & " where al.al_location_type = 5 "
    End If
    
    If Equip_Opt = 2 Then
        sSql = sSql & " where al.al_location_type in(1,18,19,20) "
    End If

    sSql = sSql & " order by al.al_line, al.al_station_order"
    
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        yesno = ""
        If RS_Trans("Au_moved") = "Y" Then yesno = "Yes"

        sline = RS_Trans("au_index") & vbTab & _
        Trim(RS_Trans("ai_partno")) & " - " & Trim(RS_Trans("ai_description")) & vbTab & _
        Trim(RS_Trans("au_Mbtano")) & vbTab & _
        Trim(RS_Trans("al_abrv")) & "  " & Trim(RS_Trans("al_location_name")) & vbTab & _
        Trim(RS_Trans("au_serialno")) & vbTab & _
        RS_Trans("AU_DateRolledOut") & vbTab & _
        yesno & vbTab & _
        Conditions(RS_Trans("AU_Condition")) & vbTab & _
        RS_Trans("ai_index") & vbTab & _
        RS_Trans("al_ID") & vbTab & _
        RS_Trans("au_federalfunding") & vbTab & _
        RS_Trans("au_statefunding") & vbTab & _
        RS_Trans("au_condition")
        
        Grid_Equip.AddItem sline
        
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
End Sub
Private Sub Grid_Tech_Init()
    Grid_Tech.Clear
    Grid_Tech.AllowUserResizing = flexResizeColumns
    
    Grid_Tech.Rows = 1
    Grid_Tech.Cols = 8
    Grid_Tech.FixedCols = 0
    
    Grid_Tech.TextMatrix(0, 0) = "Index"
    Grid_Tech.TextMatrix(0, 1) = "Employee #"
    Grid_Tech.TextMatrix(0, 2) = "First Name"
    Grid_Tech.TextMatrix(0, 3) = "Last Name"
    Grid_Tech.TextMatrix(0, 4) = "Cell Phone"
    Grid_Tech.TextMatrix(0, 5) = "Security Level"
    Grid_Tech.TextMatrix(0, 6) = "Security Level"
    Grid_Tech.TextMatrix(0, 7) = "Branch"
   

    Grid_Tech.ColWidth(0) = 0
    Grid_Tech.ColWidth(1) = 1300
    Grid_Tech.ColWidth(2) = 1500
    Grid_Tech.ColWidth(3) = 1500
    Grid_Tech.ColWidth(4) = 1300
    Grid_Tech.ColWidth(5) = 0
    If Current_User_Level < 9 Then
        Grid_Tech.ColWidth(6) = 0
    Else
        Grid_Tech.ColWidth(6) = 1500
    End If
    Grid_Tech.ColWidth(7) = 0

    Grid_Tech.ColAlignment(0) = flexAlignLeftCenter
    Grid_Tech.ColAlignment(1) = flexAlignLeftCenter
    Grid_Tech.ColAlignment(2) = flexAlignLeftCenter
    Grid_Tech.ColAlignment(3) = flexAlignLeftCenter
    Grid_Tech.ColAlignment(4) = flexAlignLeftCenter
    Grid_Tech.ColAlignment(5) = flexAlignLeftCenter
    Grid_Tech.ColAlignment(6) = flexAlignLeftCenter
    Grid_Tech.ColAlignment(7) = flexAlignLeftCenter
    For icol = 0 To 7
        Grid_Tech.col = icol
        Grid_Tech.row = 0
        Grid_Tech.CellBackColor = &HC0C0C0
    Next

End Sub
Private Sub Grid_Equip_Init()
With Grid_Equip
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 13
    .FixedCols = 0
    .FixedRows = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Part ID/Desc"
    .TextMatrix(0, 2) = "Equip ID"
    .TextMatrix(0, 3) = "Location"
    .TextMatrix(0, 4) = "Serial #"
    .TextMatrix(0, 5) = "Commissioned"
    .TextMatrix(0, 6) = "Moved"
    .TextMatrix(0, 7) = "Condition"
    .TextMatrix(0, 8) = "Part Index"
    .TextMatrix(0, 9) = "Loc Index"
    .TextMatrix(0, 10) = "Federal"
    .TextMatrix(0, 11) = "State"
    .TextMatrix(0, 12) = "State"
    


    .ColWidth(0) = 0
    .ColWidth(1) = 2500
    .ColWidth(2) = 1100
    .ColWidth(3) = 2400
    .ColWidth(4) = 1100
    .ColWidth(5) = 1500
    .ColWidth(6) = 900
    .ColWidth(7) = 900
    .ColWidth(8) = 0
    .ColWidth(9) = 0
    .ColWidth(10) = 0
    .ColWidth(11) = 0
    .ColWidth(12) = 0
    
    
    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    .ColAlignment(6) = flexAlignCenterCenter
    .ColAlignment(7) = flexAlignCenterCenter
    
    For icol = 0 To 7
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With
End Sub

Private Sub Grid_Loc_Init()
With Grid_Loc
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 9
    .FixedCols = 0
    .FixedRows = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Location ID"
    .TextMatrix(0, 2) = "Description"
    .TextMatrix(0, 3) = "Location index"
    .TextMatrix(0, 4) = "Location Type"
    .TextMatrix(0, 5) = "Line index"
    .TextMatrix(0, 6) = "Line"
    .TextMatrix(0, 7) = "Maint-Section"
    .TextMatrix(0, 8) = "Maint-Section"
    

    .ColWidth(0) = 1200
    .ColWidth(1) = 1500
    .ColWidth(2) = 2500
    .ColWidth(3) = 0
    .ColWidth(4) = 2000
    .ColWidth(5) = 0
    .ColWidth(6) = 2000
    .ColWidth(7) = 0
    .ColWidth(8) = 0

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    .ColAlignment(6) = flexAlignLeftCenter
    For icol = 0 To 8
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With

End Sub
Private Sub Grid_Transactions_Init()

With Grid_Transactions
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 8
    .FixedCols = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "S&B Part"
    .TextMatrix(0, 2) = "Description"
    .TextMatrix(0, 3) = "Location"
    .TextMatrix(0, 4) = "Qty"
    .TextMatrix(0, 5) = "Action"
    .TextMatrix(0, 6) = "1st Orders"
    .TextMatrix(0, 7) = "S&B Pack list"

    .ColWidth(0) = 0
    .ColWidth(1) = 900
    .ColWidth(2) = 2200
    .ColWidth(3) = 2400
    .ColWidth(4) = 800
    .ColWidth(5) = 1000
    .ColWidth(6) = 900
    .ColWidth(6) = 1000

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    
    For icol = 0 To 7
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With

End Sub

Public Sub Grid_WB_Init()
With Grid_WB
    
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 14
    .FixedCols = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "S&B Part"
    .TextMatrix(0, 2) = "Description"
    .TextMatrix(0, 3) = "Serial#"
    .TextMatrix(0, 4) = "Part Typ"
    .TextMatrix(0, 5) = "Workbench"
    .TextMatrix(0, 6) = "Collected"
    .TextMatrix(0, 7) = "Sent"
    .TextMatrix(0, 8) = "Received"
    .TextMatrix(0, 9) = "Alt Serial"
    .TextMatrix(0, 10) = "Notes"
    .TextMatrix(0, 11) = "Collected sort"
    .TextMatrix(0, 12) = "Sent sort"
    .TextMatrix(0, 13) = "Received sort"
    
    .ColWidth(0) = 0
    .ColWidth(1) = 800
    .ColWidth(2) = 1500
    .ColWidth(3) = 1000
    .ColWidth(4) = 800
    .ColWidth(5) = 1800
    .ColWidth(6) = 1000
    .ColWidth(7) = 1000
    .ColWidth(8) = 1000
    .ColWidth(9) = 1000
    .ColWidth(10) = 10000
    .ColWidth(11) = 0
    .ColWidth(12) = 0
    .ColWidth(13) = 0

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    .ColAlignment(6) = flexAlignLeftCenter
    .ColAlignment(7) = flexAlignLeftCenter
    .ColAlignment(8) = flexAlignLeftCenter
    .ColAlignment(9) = flexAlignLeftCenter

    For icol = 0 To 10
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With

End Sub

Public Sub Grid_WB_Open_Init()

With Grid_WB_Open
    
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 4
    .FixedCols = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Serial#"
    .TextMatrix(0, 2) = "Date Collected"
    .TextMatrix(0, 3) = "Notes"
    
    .ColWidth(0) = 0
    .ColWidth(1) = 1000
    .ColWidth(2) = 1000
    .ColWidth(3) = 2000

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter

    For icol = 0 To 3
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With

End Sub

Public Sub Grid_Trans_Init()

With Grid_Trans
    
    .Clear
    .AllowUserResizing = flexResizeColumns
   ' .RowHeight = 285
    .Rows = 1
    .Cols = 11
    '.FixedCols = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Location"
    .TextMatrix(0, 2) = "Part"
    .TextMatrix(0, 3) = "Part Type"
    .TextMatrix(0, 4) = "Tran-Type"
    .TextMatrix(0, 5) = "Qty"
    .TextMatrix(0, 6) = "Serial #"
    .TextMatrix(0, 7) = "partindex"
    .TextMatrix(0, 8) = "locationindex"
    .TextMatrix(0, 9) = "trantype"
    .TextMatrix(0, 10) = "Notes"
    

    .ColWidth(0) = 0
    .ColWidth(1) = 2200
    .ColWidth(2) = 2800
    .ColWidth(3) = 800
    .ColWidth(4) = 1100
    .ColWidth(5) = 600
    .ColWidth(6) = 1500
    .ColWidth(7) = 0
    .ColWidth(8) = 0
    .ColWidth(9) = 0
    .ColWidth(10) = 10000
    
    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    .ColAlignment(6) = flexAlignLeftCenter
    .ColAlignment(10) = flexAlignLeftCenter
    
    For icol = 0 To 10
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With

End Sub

Public Sub Grid_TranHist_Init()
    
    With Grid_Tranhist
    .Clear
    .AllowUserResizing = flexResizeColumns
    .Rows = 1
    .Cols = 4
    .FixedCols = 0
    
    .TextMatrix(0, 0) = "S&B Part/Description"
    .TextMatrix(0, 1) = "Qty"
    .TextMatrix(0, 2) = "From Loc"
    .TextMatrix(0, 3) = "To Loc"
    

    .ColWidth(0) = 3000
    .ColWidth(1) = 800
    .ColWidth(2) = 2000
    .ColWidth(3) = 2000
    
    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    
    End With
End Sub
Private Sub Grid_Loc_Click()
    If Current_User_Level <> 9 Then Exit Sub
    LG_GridIdx = Grid_Loc.row
    
    LG_GridIdx = Grid_Loc.row
    If LG_GridIdx = 0 Then
        Grid_Loc.FixedRows = 1
        Grid_Loc.sort = 1
        Grid_Loc.Refresh
        Grid_Loc.FixedRows = 0
        Txt_Name.Text = ""
        Txt_Description.Text = ""
        Cbo_LocType.ListIndex = -1
        Cbo_Line.ListIndex = -1
        
        Exit Sub
    End If
    
    If Current_User_Level < 5 Then Exit Sub
    
    tAL_ID = Grid_Loc.TextMatrix(LG_GridIdx, 0)
    tAL_Abrv = Trim(Grid_Loc.TextMatrix(LG_GridIdx, 1))
    tAL_Location_Name = Trim(Grid_Loc.TextMatrix(LG_GridIdx, 2))
    
    Txt_Name.Text = tAL_Abrv
    Txt_Description.Text = tAL_Location_Name
    
    For step = 0 To Cbo_LocType.ListCount - 1
        If Cbo_LocType.ItemData(step) = CInt(Trim(Grid_Loc.TextMatrix(LG_GridIdx, 3))) Then
            Cbo_LocType.ListIndex = step
            step = Cbo_LocType.ListCount
        End If
    Next
    If CInt(Trim(Grid_Loc.TextMatrix(LG_GridIdx, 5))) <> 0 Then
        For step = 0 To Cbo_Line.ListCount
            If Cbo_Line.ItemData(step) = CInt(Trim(Grid_Loc.TextMatrix(LG_GridIdx, 5))) Then
                Cbo_Line.ListIndex = step
                step = Cbo_Line.ListCount
            End If
        Next
    Else
        Cbo_Line.ListIndex = -1
    End If
    For step = 0 To Cbo_MaintSec.ListCount - 1
        If Cbo_MaintSec.ItemData(step) = CInt(Trim(Grid_Loc.TextMatrix(LG_GridIdx, 7))) Then
            Cbo_MaintSec.ListIndex = step
            step = Cbo_MaintSec.ListCount
        End If
    Next
    For step = 0 To Cbo_PMSec.ListCount - 1
        If Cbo_PMSec.ItemData(step) = CInt(Trim(Grid_Loc.TextMatrix(LG_GridIdx, 8))) Then
            Cbo_PMSec.ListIndex = step
            step = Cbo_PMSec.ListCount
        End If
    Next
    

    Select Case CInt(Trim(Grid_Loc.TextMatrix(LG_GridIdx, 3)))
    Case 5, 19, 20
        Cbo_Line.Locked = False
    
    Case Else
        Cbo_Line.Locked = True
    End Select
End Sub

Private Sub Tech_list_Click()
    Report_Name = "Technicians"
    Frm_RptViewer.Show vbModal
    Report_Name = ""


End Sub


Private Sub Text1_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
        Case 48 To 57
        Exit Sub
        Case Else
            KeyAscii = 0
    End Select
    KeyAscii = 0

End Sub


Private Sub Timer1_Timer()
    mappedletter = "\\mbtasql\Sharing and apps\"
    PGBLprogname = App.EXEName
    updowncount = 0
    PGBLprogstatus = PGBLcheckprogstat(mappedletter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        Unload Me
        End
     End If

    If InputCheck = True Then '<<<<<<<<<<<<<<<<<<< this will detect any mousemove or key
         myloop = 0
         Exit Sub
    End If
    
    PGBLprogstatus = PGBLcheckprogstat(mappedletter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        SQLData.Close
        Set SQLData = Nothing
        Unload Me
        End
     End If

Dim myForm As Form

myloop = myloop + 1
If myloop < 3 Then Exit Sub 'if not 5 minutes then do nothing
SQLData.Close
Set SQLData = Nothing

'this will close all open forms beside the main form
End

'put the code for logoff here

myloop = 0 'zero myLoop
End Sub

Private Sub TotalDefectsBy_Click()
    Report_Name = "Incident Totals"
    Frm_Incident.Show vbModal
    Report_Name = ""

End Sub

Private Sub Tran_History_Click()
    Report_Name = "Tran History"
    Frm_Trans_History.Show vbModal
    Report_Name = ""
End Sub

Private Sub txt_CellPhone_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            If Len(Txt_CellPhone.Text) >= 1 Then
                Txt_CellPhone.Text = Mid(Txt_CellPhone.Text, 1, Len(Txt_CellPhone.Text) - 1)
                KeyAscii = 0
            End If
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
        Case 48 To 57
        Exit Sub
        Case Else
            KeyAscii = 0
    End Select
    KeyAscii = 0

End Sub

Private Sub txt_CellPhone_Validate(Cancel As Boolean)
Dim My_phone As String

    My_phone = Replace(Txt_CellPhone.Text, "(", "")
    My_phone = Replace(My_phone, ")", "")
    My_phone = Replace(My_phone, "-", "")
    Txt_CellPhone.Text = Format$(My_phone, "(000)000-0000")

End Sub

Private Sub Txt_currcost_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            If Len(Txt_CurrCost.Text) >= 1 Then
                Txt_CurrCost.Text = Mid(Txt_CurrCost.Text, 1, Len(Txt_CurrCost.Text) - 1)
                KeyAscii = 0
            End If
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
        Case 46 To 57
            'Txt_CurrCost.Text = PGBLFormdollars(Txt_CurrCost.Text, Chr(KeyAscii))
'            Txt_CurrCost.Text = FormatCurrency(CLng(Txt_CurrCost.Text), 2)
        Case Else
            KeyAscii = 0
    End Select
   ' KeyAscii = 0
End Sub



Private Sub Txt_Incident_Validate(Cancel As Boolean)
    If Txt_Incident.Text = "" Then Exit Sub
    sSql = "select i_id, i_incidentno, i_device, au_mbtano, isnull(I_DT_Closed,'') as I_DT_Closed, isnull(i_ipol,'') as i_ipol from incident left outer join afc_unittable on" & _
    " i_device = au_index where i_incidentno = '" & Trim(Txt_Incident.Text) & "'"
    Call Get_Work("Read")
    If RS_Work.EOF = True Then
        Call Get_Work("Close")
        sSql = "select i_id, i_incidentno, i_device, au_mbtano, isnull(I_DT_Closed,'') as I_DT_Closed, isnull(i_ipol,'') as i_ipol from incident left outer join afc_unittable on" & _
        " i_device = au_index where i_incidentno = '0" & Trim(Txt_Incident.Text) & "'"
        Call Get_Work("Read")
    End If
    If RS_Work.EOF = True Then
        Call Get_Work("Close")
        MsgBox ("The Incident entered does not exisit"), vbOKOnly
        Exit Sub
    End If
    Txt_Equip_ID.Text = RS_Work("au_mbtano")
    Txt_Ipol.Text = RS_Work("I_Ipol")
    Cbo_Date.Text = Format(RS_Work("I_dt_Closed"), "mm/dd/yyyy")
    IT_Incident = RS_Work("i_id")
    IT_Machineno = RS_Work("i_device")

End Sub



Private Sub Txt_Ipol_Validate(Cancel As Boolean)
    If Txt_Ipol.Text = "" Then Exit Sub
    sSql = "select i_id, i_incidentno, i_device, au_mbtano, I_DT_Closed, isnull(i_ipol,'') as i_ipol from incident left outer join afc_unittable on" & _
    " i_device = au_index where i_ipol = '" & Trim(Txt_Ipol.Text) & "'"
    Call Get_Work("Read")
    If RS_Work.EOF = True Then
        MsgBox ("The Incident entered does not exisit"), vbOKOnly
        Exit Sub
    End If
    Dim test  As String
    Txt_Equip_ID.Text = RS_Work("au_mbtano")
    Txt_Incident.Text = RS_Work("i_incidentno")
    Txt_Ipol.Text = RS_Work("I_Ipol")
    Cbo_Date.Text = Format(RS_Work("I_dt_Closed"), "mm/dd/yyyy")
    IT_Incident = RS_Work("i_id")
    IT_Machineno = RS_Work("i_device")
End Sub

Private Sub Txt_Label_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
    End Select
End Sub

Private Sub Txt_Label_Validate(Cancel As Boolean)
Dim splitter As String
Dim Pos As Integer
Dim KeyAscii As Integer
    If Txt_Label.Text = "" Then Exit Sub
    Pos = InStr(1, Txt_Label, " ")
    If Pos = 0 Then
        Txt_Label.Text = Replace(Txt_Label.Text, "(A)", " A")
        Txt_Label.Text = Replace(Txt_Label.Text, "D", " D")
        Pos = InStr(1, Txt_Label, " ")
    End If

label_part = CLng(Trim(Mid(Txt_Label.Text, 1, Pos)))
    sSql = "select ai_index from afc_inventory where ai_partno='" & label_part & "'"
    Call Get_Trans("Read")
        If RS_Trans.EOF = True Then
            label_part = CLng(Trim(Mid(Txt_Label.Text, 1, Pos - 2)))
            sSql = "select ai_index from afc_inventory where ai_partno='" & label_part & "'"
            Call Get_Trans("Read")
        End If
    splitter = Trim(Mid(Txt_Label.Text, Pos, Len(Txt_Label.Text)))
    If Mid(splitter, 1, 1) > 9 Then
        splitter = Mid(splitter, 2, Len(splitter))
    End If
    
    If Mid(splitter, 2, 1) > 9 Then
        splitter = Mid(splitter, 3, Len(splitter))
    End If
    Label_serial = CLng(splitter)
    Txt_RecSerial.Text = CLng(splitter)
    
    For step = 0 To Cbo_Partno4.ListCount - 1
    If Cbo_Partno4.ItemData(step) = RS_Trans("ai_index") Then
        Cbo_Partno4.ListIndex = step
        step = Cbo_Partno4.ListCount
    End If
    Next
    RS_Trans.Close
    Set RS_Trans = Nothing
    
    Call Cmd_FindWB_Click
    Txt_Label.SetFocus
End Sub

Private Sub Txt_MaxROP_KeyPress(KeyAscii As Integer)
    
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
        Case 48 To 57
            Exit Sub
    End Select
    KeyAscii = 0
    
End Sub

Private Sub Txt_MBTAno_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
    End Select
End Sub

Private Sub Txt_MBTAno_Validate(Cancel As Boolean)
    If Cbo_Partno3.Text <> "" Then Exit Sub
    
    Scanning = True
    
    sSql = "SELECT au.AU_Index, au.AU_MBTAno, au.AU_Serialno, au.AU_DateRolledOut, isnull(Au_Moved,'') as au_moved, isnull(au_condition,0) as au_condition, isnull(AU_FederalFunding,0) as au_FederalFunding, " & _
    "isnull(AU_StateFunding,0) as au_StateFunding, ai.ai_index, ai.AI_Description, ai.AI_Partno, al_id, al.AL_Abrv, al.AL_Location_Name " & _
    "FROM AFC_UnitTable au " & _
    "INNER JOIN AFC_Inventory ai ON au.AU_Partno = ai.AI_Index " & _
    "INNER JOIN AFC_Location al ON au.AU_Location = al.AL_ID where au.au_mbtano = '" & Txt_MBTAno & "'"
    
    
    Set RS_Work = New ADODB.Recordset
    Set RS_Work = SQLData.Execute(sSql)
    For step = 0 To Cbo_Partno3.ListCount
    If Cbo_Partno3.ItemData(step) = RS_Work("ai_index") Then
            Cbo_Partno3.ListIndex = step
            step = Cbo_Partno3.ListCount
    End If
    Next
    For step = 0 To Cbo_Locations3.ListCount
        If Cbo_Locations3.ItemData(step) = RS_Work("al_id") Then
            Cbo_Locations3.ListIndex = step
            step = Cbo_Locations3.ListCount
        End If
    Next
    Dim tester As String
    
    For step = 0 To Combo(1).ListCount
        tester = Combo(1).ItemData(step)
        If Combo(1).ItemData(step) = CInt(RS_Work("au_StateFunding")) Then
            Combo(1).ListIndex = step
            step = Combo(1).ListCount
        End If
    Next
    For step = 0 To Combo(2).ListCount
        If Combo(2).ItemData(step) = CInt(RS_Work("au_FederalFunding")) Then
            Combo(2).ListIndex = step
            step = Combo(1).ListCount
        End If
    Next
    For step = 0 To Combo(0).ListCount
        If Combo(0).ItemData(step) = CInt(RS_Work("au_condition")) Then
            Combo(0).ListIndex = step
            step = Combo(0).ListCount
        End If
    Next

    'Txt_MBTAno.Text = Trim(Grid_Equip.TextMatrix(LG_GridIdx, 2))
    Txt_SBSerial.Text = RS_Work("AU_Serialno")
    Txt_Rollout.Text = RS_Work("AU_DateRolledOut")
    Chk_Moved = 0
    If Trim(Grid_Equip.TextMatrix(LG_GridIdx, 6)) = "Yes" Then
        Chk_Moved = 1
    End If
    Unit_Modify = True
    tAU_Index = RS_Work("au_index")
    
End Sub

Private Sub Txt_MinROP_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
        Case 48 To 57
            Exit Sub
    End Select
    KeyAscii = 0
End Sub

Private Sub Txt_NewPart_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If

End Sub
Private Sub Txt_RecSerial_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
    End Select
    'KeyAscii = 0

End Sub

Private Sub Txt_SatQty_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
        Case 48 To 57
            Exit Sub
    End Select
    KeyAscii = 0
End Sub

Private Sub Txt_tech_GotFocus()
    If Txt_tech.Text = "" And Current_User_Level = 9 Then
    Cmd_Reset.Visible = True
    Cmd_Add_tech.Visible = True
    Cmd_save_tech.Visible = False
    End If

End Sub

Private Sub Load_SB_Partno_Cbo()
Dim spart As Long
Dim sdesc As String
Dim part_desc As String

    sSql = "select ai_index,ai_partno,AI_Description,AI_Parttype, ai_rolledout from AFC_Inventory order by ai_partno"
    Call Get_Inventory("Read")
    Cbo_Partno.Clear
    Cbo_Partno2.Clear
    Cbo_Partno3.Clear
    Cbo_Partno4.Clear
    Cbo_Partno5.Clear

    Do While RS_Inventory.EOF = False
    
        spart = RS_Inventory("ai_partno")            'part number
        sdesc = Trim(RS_Inventory("ai_description"))              'description
        part_desc = spart & " -  " & sdesc
        Cbo_Partno.AddItem (part_desc)
        Cbo_Partno.ItemData(Cbo_Partno.NewIndex) = RS_Inventory("ai_index")
        
        If Trim(RS_Inventory("AI_PartType")) = Trim("UNIT") Or RS_Inventory("ai_rolledout") = "Y" Then
            Cbo_Partno3.AddItem (part_desc)
            Cbo_Partno3.ItemData(Cbo_Partno3.NewIndex) = RS_Inventory("ai_index")
        Else
        
            Cbo_Partno2.AddItem (part_desc)
            Cbo_Partno2.ItemData(Cbo_Partno2.NewIndex) = RS_Inventory("ai_index")
            
            If Current_User_Branch = 3 Then
                Select Case Trim(RS_Inventory("ai_partno"))
                Case "348370", "348590", "8628193", "348675", "5061992", "348716", "8628215", "8629150", "347218"
                    Cbo_Partno5.AddItem (part_desc)
                    Cbo_Partno5.ItemData(Cbo_Partno5.NewIndex) = RS_Inventory("ai_index")
                    Cbo_Partno4.AddItem (part_desc)
                    Cbo_Partno4.ItemData(Cbo_Partno4.NewIndex) = RS_Inventory("ai_index")
                
                End Select
            Else
                Cbo_Partno4.AddItem (part_desc)
                Cbo_Partno4.ItemData(Cbo_Partno4.NewIndex) = RS_Inventory("ai_index")
                Cbo_Partno5.AddItem (part_desc)
                Cbo_Partno5.ItemData(Cbo_Partno5.NewIndex) = RS_Inventory("ai_index")
            End If
        
        End If
themove:
        RS_Inventory.MoveNext

        DoEvents
    Loop
    Call Get_Inventory("Close")

End Sub
Public Sub Load_Grants()

    Combo(1).Clear
    
    sSql = "select * from afc_grants"
    Call Get_Trans("Read")
    Combo(1).AddItem " "
    Combo(1).ItemData(Combo(1).NewIndex) = 0
    Combo(2).AddItem " "
    Combo(2).ItemData(Combo(2).NewIndex) = 0
    
    Do While RS_Trans.EOF = False
        If RS_Trans("ag_grant_type") = 2 Then
            Combo(1).AddItem Trim(RS_Trans("AG_grantno")) & " " & Trim(RS_Trans("ag_description")) & " " & RS_Trans("ag_percentage") & "%"
            Combo(1).ItemData(Combo(1).NewIndex) = RS_Trans("AG_id")
        End If
        If RS_Trans("ag_grant_type") = 1 Then
            Combo(2).AddItem Trim(RS_Trans("AG_grantno")) & " " & Trim(RS_Trans("ag_description")) & " " & RS_Trans("ag_percentage") & "%"
            Combo(2).ItemData(Combo(2).NewIndex) = RS_Trans("AG_id")
        End If
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close

End Sub
Public Sub Load_location_Cbo()
    sSql = "select * from AFC_location order by al_location_name"
    Call Get_Location("Read")
    Cbo_Locations.Clear
    Cbo_Locations2.Clear
    Cbo_Locations3.Clear
    Cbo_Locations4.Clear
    Cbo_FromLocation.Clear
    Cbo_ToLocation.Clear
    
    If RS_Location.EOF Then
        MsgBox ("There are no Satellite Locations available.")
        Call Get_Location("Close")
        Exit Sub
    End If

    Do While RS_Location.EOF = False
        
        sline = Trim(RS_Location("AL_Location_Name"))
        If Current_User_Branch = 2 Or Current_User_Branch = 1 Then
            If RS_Location("AL_Location_type") = 1 Or RS_Location("AL_Location_type") = 2 Then
                Cbo_Locations.AddItem sline
                Cbo_Locations.ItemData(Cbo_Locations.NewIndex) = RS_Location("al_id")
                Cbo_Locations2.AddItem sline
                Cbo_Locations2.ItemData(Cbo_Locations2.NewIndex) = RS_Location("al_id")
                Cbo_FromLocation.AddItem sline
                Cbo_FromLocation.ItemData(Cbo_FromLocation.NewIndex) = RS_Location("al_id")
                Cbo_ToLocation.AddItem sline
                Cbo_ToLocation.ItemData(Cbo_ToLocation.NewIndex) = RS_Location("al_id")
                Cbo_Locations4.AddItem sline
                Cbo_Locations4.ItemData(Cbo_Locations4.NewIndex) = RS_Location("al_id")
            End If
            
            If (RS_Location("AL_Location_type") = 5 Or RS_Location("AL_Location_type") = 1 Or RS_Location("AL_Location_type") = 19 Or RS_Location("AL_Location_type") = 20) Then
                Cbo_Locations3.AddItem sline
                Cbo_Locations3.ItemData(Cbo_Locations3.NewIndex) = RS_Location("al_id")

            End If
        Else
            If RS_Location("AL_Location_type") = 1 Or RS_Location("AL_Location_type") = 19 Or RS_Location("AL_Location_type") = 20 Then
                Cbo_Locations.AddItem sline
                Cbo_Locations.ItemData(Cbo_Locations.NewIndex) = RS_Location("al_id")
                Cbo_Locations2.AddItem sline
                Cbo_Locations2.ItemData(Cbo_Locations2.NewIndex) = RS_Location("al_id")
                Select Case RS_Location("al_id")
                Case 1, 527, 530, 531, 532, 534
                Case Else
                    Cbo_FromLocation.AddItem sline
                    Cbo_FromLocation.ItemData(Cbo_FromLocation.NewIndex) = RS_Location("al_id")
                    Cbo_ToLocation.AddItem sline
                    Cbo_ToLocation.ItemData(Cbo_ToLocation.NewIndex) = RS_Location("al_id")
                End Select
                Cbo_Locations4.AddItem sline
                Cbo_Locations4.ItemData(Cbo_Locations4.NewIndex) = RS_Location("al_id")
            End If
            If RS_Location("AL_Location_type") = 19 Or RS_Location("AL_Location_type") = 20 Then
                Cbo_Locations3.AddItem sline
                Cbo_Locations3.ItemData(Cbo_Locations3.NewIndex) = RS_Location("al_id")
            End If
        End If
        
        If RS_Location("AL_Location_type") = 3 Then
            Cbo_RLB.AddItem sline
            Cbo_RLB.ItemData(Cbo_RLB.NewIndex) = RS_Location("al_id")
        End If
        
        If RS_Location("AL_Location_type") = 4 Then
            Cbo_RLS.AddItem sline
            Cbo_RLS.ItemData(Cbo_RLS.NewIndex) = RS_Location("al_id")
        End If

        RS_Location.MoveNext
    Loop
    Call Get_Location("Close")
End Sub

Public Sub Load_Cbo_Loctype_and_Line()
    sSql = "select * from afc_locationType"
    Call Get_Location("Read")
    
    
    Do While RS_Location.EOF = False
        If RS_Location("ALT_Line") = "N" Then
            Cbo_LocType.AddItem Trim(RS_Location("ALt_description"))
            Cbo_LocType.ItemData(Cbo_LocType.NewIndex) = RS_Location("alt_index")
            
        ElseIf RS_Location("ALT_Line") = "Y" Then
            Cbo_Line.AddItem Trim(RS_Location("ALt_description"))
            Cbo_Line.ItemData(Cbo_Line.NewIndex) = RS_Location("alt_index")

        Else
        End If
        RS_Location.MoveNext
    Loop
    
    Call Get_Location("Close")
End Sub

Private Sub Clear_tab(X As Integer)
    Select Case X
    Case 1
        Cbo_Partno.Text = ""
        Txt_Altpart.Text = ""
        Txt_OemPart.Text = ""
        Txt_MaxROP.Text = ""
        Txt_MinROP.Text = ""
        Cbo_Parttype(0).Text = ""
        Txt_CurrCost.Text = ""
        Cbo_RLB.Text = ""
        Cbo_RLS.Text = ""
        Txt_Notes.Text = ""
        Call Grid_LocBal_Init
    Case 2
    
    Case 3
    
    Case 4
    
    Case 5
    
    Case 6
        Txt_Name.Text = ""
        Txt_Description.Text = ""
        Cbo_LocType.Text = ""
        Cbo_Line.Text = ""
    
    Case 7
        Txt_tech.Text = ""
        Txt_techfname.Text = ""
        Txt_techlname.Text = ""
        
    End Select

End Sub


Private Sub workbench_rpt_Click()
    Report_Name = "Work Bench"
    Frm_WorkBench.Show vbModal
    Report_Name = ""
End Sub
