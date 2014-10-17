// ExCliSrvDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExCliSrv.h"
#include "ExCliSrvDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CExCliSrvDlg dialog

CExCliSrvDlg::CExCliSrvDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExCliSrvDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExCliSrvDlg)
	m_edit1 = _T("");
	m_edit2 = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExCliSrvDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExCliSrvDlg)
	DDX_Control(pDX, IDC_APAX1, m_apax);
	DDX_Text(pDX, IDC_EDIT1, m_edit1);
	DDX_Text(pDX, IDC_EDIT2, m_edit2);
	DDX_Control(pDX, IDC_COMMONDIALOG1, m_Dlg);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExCliSrvDlg, CDialog)
	//{{AFX_MSG_MAP(CExCliSrvDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExCliSrvDlg message handlers

BOOL CExCliSrvDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExCliSrvDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CExCliSrvDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

BEGIN_EVENTSINK_MAP(CExCliSrvDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExCliSrvDlg)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 11 /* OnWinsockConnect */, OnWinsockConnectApax1, VTS_NONE)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 12 /* OnWinsockDisconnect */, OnWinsockDisconnectApax1, VTS_NONE)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 13 /* OnWinsockError */, OnWinsockErrorApax1, VTS_I4)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 10 /* OnWinsockAccept */, OnWinsockAcceptApax1, VTS_BSTR VTS_PBOOL)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 14 /* OnWinsockGetAddress */, OnWinsockGetAddressApax1, VTS_PBSTR VTS_PBSTR)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 35 /* OnSendButtonClick */, OnSendButtonClickApax1, VTS_PBOOL)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 36 /* OnReceiveButtonClick */, OnReceiveButtonClickApax1, VTS_PBOOL)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 28 /* OnProtocolFinish */, OnProtocolFinishApax1, VTS_I4)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 27 /* OnProtocolAccept */, OnProtocolAcceptApax1, VTS_PBOOL VTS_PBSTR)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 32 /* OnListenButtonClick */, OnListenButtonClickApax1, VTS_PBOOL)
	ON_EVENT(CExCliSrvDlg, IDC_APAX1, 31 /* OnConnectButtonClick */, OnConnectButtonClickApax1, VTS_PBOOL)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExCliSrvDlg::OnWinsockConnectApax1() 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);
	
	this->SetWindowText("Connected - " + pA->GetWinsockAddress());
	pA->SetShowProtocolButtons(true);
	pA->TerminalSetFocus();
}

void CExCliSrvDlg::OnWinsockDisconnectApax1() 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);
	
	this->SetWindowText("ExCliSrv - Winsock Client/Server");
	pA->SetShowProtocolButtons(false);
		
}

void CExCliSrvDlg::OnWinsockErrorApax1(long ErrCode) 
{
  this->SetWindowText("Winsock Error");	
}

void CExCliSrvDlg::OnWinsockAcceptApax1(LPCTSTR Addr, BOOL FAR* Accept) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);
	
	this->SetWindowText("Connected - " + *Addr);
	pA->SetShowProtocolButtons(true);
	pA->TerminalSetFocus();
	
}

void CExCliSrvDlg::OnWinsockGetAddressApax1(BSTR FAR* Address, BSTR FAR* Port) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);
	CEdit* pE1 = (CEdit*) GetDlgItem(IDC_EDIT1);
	CEdit* pE2 = (CEdit*) GetDlgItem(IDC_EDIT2);

	char A1[50];
	char A2[50];

	char* cp1 = A1;
	char* cp2 = A2;

	pE1->GetWindowText(cp1, 50);
	pE2->GetWindowText(cp2, 50);

	pA->SetWinsockAddress(cp1);
	pA->SetWinsockPort(cp2);

}

void CExCliSrvDlg::OnSendButtonClickApax1(BOOL FAR* Default) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);
	CCommonDialog1* pD = (CCommonDialog1*) GetDlgItem(IDC_COMMONDIALOG1);
	CString FName;

	*Default = false;
	pD->ShowOpen();
	FName = pD->GetFileName();
	if (FName != "")  {
		pA->SetSendFileName(FName);
		pA->SetTerminalActive(false);
		pA->TerminalWriteString("sending " + pA->GetSendFileName());
		pA->StartTransmit();
	}	
}

void CExCliSrvDlg::OnReceiveButtonClickApax1(BOOL FAR* Default) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);

	pA->SetTerminalActive(false);
}

void CExCliSrvDlg::OnProtocolFinishApax1(long ErrorCode) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);

	if (ErrorCode == 0) 
		pA->TerminalWriteStringCRLF("OK");
	else
		pA->TerminalWriteStringCRLF("Error");

	pA->SetTerminalActive(false);

}

void CExCliSrvDlg::OnProtocolAcceptApax1(BOOL FAR* Accept, BSTR FAR* FName) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);

	pA->TerminalWriteStringCRLF("Receiving " + **FName);
	*Accept = true;
}

void CExCliSrvDlg::OnListenButtonClickApax1(BOOL FAR* Default) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);
	CString Prt;
	
	Prt = pA->GetWinsockPort();
	this->SetWindowText("Listening on " + Prt);
	
}

int CExCliSrvDlg::DoModal() 
{
	return CDialog::DoModal();
}

void CExCliSrvDlg::OnConnectButtonClickApax1(BOOL FAR* Default) 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);
	CEdit* pE1 = (CEdit*) GetDlgItem(IDC_EDIT1);
	CEdit* pE2 = (CEdit*) GetDlgItem(IDC_EDIT2);

	char A1[50];
	char A2[50];

	char* cp1 = A1;
	char* cp2 = A2;

	pE1->GetWindowText(cp1, 50);
	pE2->GetWindowText(cp2, 50);

	pA->SetWinsockAddress(cp1);
	pA->SetWinsockPort(cp2);
	pA->SetDeviceType(2);		//dtWinsock
	pA->SetWinsockMode(0);

	pA->WinsockConnect();
	
}
