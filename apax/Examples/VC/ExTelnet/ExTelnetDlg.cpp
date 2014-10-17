// ExTelnetDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExTelnet.h"
#include "ExTelnetDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CExTelnetDlg dialog

CExTelnetDlg::CExTelnetDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExTelnetDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExTelnetDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExTelnetDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExTelnetDlg)
	DDX_Control(pDX, IDC_EDIT1, m_addressedit);
	DDX_Control(pDX, IDC_APAX1, m_apax);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExTelnetDlg, CDialog)
	//{{AFX_MSG_MAP(CExTelnetDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON1, OnButton1)
	ON_BN_CLICKED(IDC_BUTTON2, OnButton2)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExTelnetDlg message handlers

BOOL CExTelnetDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	m_addressedit.SetWindowText(m_apax.GetWinsockAddress());
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExTelnetDlg::OnPaint() 
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
HCURSOR CExTelnetDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CExTelnetDlg::OnButton1() 
{
	char add[100];
	char* cp = add;
	m_addressedit.GetWindowText(cp,100);
	CString Str = cp;

	m_apax.SetWinsockAddress(Str);	
	m_apax.WinsockConnect();
}

void CExTelnetDlg::OnButton2() 
{
	m_apax.Close();	
}

BEGIN_EVENTSINK_MAP(CExTelnetDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExTelnetDlg)
	ON_EVENT(CExTelnetDlg, IDC_APAX1, 11 /* OnWinsockConnect */, OnWinsockConnectApax1, VTS_NONE)
	ON_EVENT(CExTelnetDlg, IDC_APAX1, 12 /* OnWinsockDisconnect */, OnWinsockDisconnectApax1, VTS_NONE)
	ON_EVENT(CExTelnetDlg, IDC_APAX1, 13 /* OnWinsockError */, OnWinsockErrorApax1, VTS_I4)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExTelnetDlg::OnWinsockConnectApax1() 
{
	this->SetWindowText("Connected");
	m_apax.TerminalSetFocus();
}

void CExTelnetDlg::OnWinsockDisconnectApax1() 
{
	this->SetWindowText("ExTelnet - Telnet Client");	
}

void CExTelnetDlg::OnWinsockErrorApax1(long ErrCode) 
{
	CString Str;
	int x = ErrCode;
	Str.Format("Error Code : %d", x);
	MessageBox(Str);
}
