; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CExLoginDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "ExLogin.h"

ClassCount=3
Class1=CExLoginApp
Class2=CExLoginDlg
Class3=CAboutDlg

ResourceCount=3
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_EXLOGIN_DIALOG

[CLS:CExLoginApp]
Type=0
HeaderFile=ExLogin.h
ImplementationFile=ExLogin.cpp
Filter=N

[CLS:CExLoginDlg]
Type=0
HeaderFile=ExLoginDlg.h
ImplementationFile=ExLoginDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=ExLoginDlg.h
ImplementationFile=ExLoginDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_EXLOGIN_DIALOG]
Type=1
Class=CExLoginDlg
ControlCount=9
Control1=IDC_ADDRESS,edit,1350631552
Control2=IDC_LOGIN_NAME,edit,1350631552
Control3=IDC_PASSWORD,edit,1350631552
Control4=IDC_CONNECT,button,1342242817
Control5=IDC_APAX1,{28E7F3B1-59C2-4B1C-9D8E-0610B280898D},1342177280
Control6=IDC_DISCONNECT,button,1342242816
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352
Control9=IDC_STATIC,static,1342308352

