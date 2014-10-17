; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CExDataTrDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "ExDataTr.h"

ClassCount=4
Class1=CExDataTrApp
Class2=CExDataTrDlg
Class3=CAboutDlg

ResourceCount=5
Resource1=IDD_ADDTRIGGER_DIALOG
Resource2=IDR_MAINFRAME
Resource3=IDD_EXDATATR_DIALOG
Resource4=IDD_ABOUTBOX
Class4=CDataTriggerDlg
Resource5=IDR_MENU1

[CLS:CExDataTrApp]
Type=0
HeaderFile=ExDataTr.h
ImplementationFile=ExDataTr.cpp
Filter=N

[CLS:CExDataTrDlg]
Type=0
HeaderFile=ExDataTrDlg.h
ImplementationFile=ExDataTrDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=IDC_APAX1

[CLS:CAboutDlg]
Type=0
HeaderFile=ExDataTrDlg.h
ImplementationFile=ExDataTrDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_EXDATATR_DIALOG]
Type=1
Class=CExDataTrDlg
ControlCount=6
Control1=IDC_APAX1,{28E7F3B1-59C2-4B1C-9D8E-0610B280898D},1342177280
Control2=IDC_STATIC,button,1342177287
Control3=IDC_STATIC,static,1342308352
Control4=IDC_STATIC,static,1342308352
Control5=IDC_TRIGGERS_ASSIGNED,listbox,1352728833
Control6=IDC_TRIGGERS_FIRED,listbox,1352745217

[MNU:IDR_MENU1]
Type=1
Class=?
Command1=ID_DATATRIGGERS_ADDTRIGGER
Command2=ID_DATATRIGGERS_DISABLETRIGGER
Command3=ID_DATATRIGGERS_ENABLETRIGGER
Command4=ID_DATATRIGGERS_REMOVETRIGGER
Command5=ID_DATATRIGGERS_CLEAR
CommandCount=5

[CLS:CDataTriggerDlg]
Type=0
HeaderFile=DataTriggerDlg.h
ImplementationFile=DataTriggerDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CDataTriggerDlg

[DLG:IDD_ADDTRIGGER_DIALOG]
Type=1
Class=CDataTriggerDlg
ControlCount=11
Control1=IDC_TRIGGER_STRING,edit,1350631552
Control2=IDC_PACKET_SIZE,edit,1350631552
Control3=IDC_TIMEOUT,edit,1350631552
Control4=IDC_ENABLED,button,1342243075
Control5=IDC_INCLUDE_STRINGS,button,1342243075
Control6=IDC_IGNORE_CASE,button,1342243075
Control7=IDOK,button,1342242817
Control8=IDCANCEL,button,1342177280
Control9=IDC_STATIC,static,1342308352
Control10=IDC_STATIC,static,1342308352
Control11=IDC_STATIC,static,1342308352

