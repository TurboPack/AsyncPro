// ExLoginDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExLogin.h"
#include "ExLoginDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExLoginDlg dialog

CExLoginDlg::CExLoginDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExLoginDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExLoginDlg)
	m_strAddress = _T("");
	m_strLoginName = _T("");
	m_strPassword = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExLoginDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExLoginDlg)
	DDX_Control(pDX, IDC_APAX1, m_Apax);
	DDX_Text(pDX, IDC_ADDRESS, m_strAddress);
	DDX_Text(pDX, IDC_LOGIN_NAME, m_strLoginName);
	DDX_Text(pDX, IDC_PASSWORD, m_strPassword);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExLoginDlg, CDialog)
	//{{AFX_MSG_MAP(CExLoginDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_CONNECT, OnConnect)
	ON_BN_CLICKED(IDC_DISCONNECT, OnDisconnect)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExLoginDlg message handlers

BOOL CExLoginDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// Initialize APAX data triggers
	m_Apax.SetDeviceType(2);  // dtWinsock
	m_Apax.AddDataTrigger("login:", 0, 0, true, true);
	m_Apax.AddDataTrigger("password:", 0, 36, true, true);
	m_Apax.AddDataTrigger("$", 0, 0, true, true);
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CExLoginDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExLoginDlg::OnPaint() 
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
HCURSOR CExLoginDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CExLoginDlg::OnConnect() 
{
	UpdateData();
	m_Apax.SetWinsockAddress(m_strAddress);
	m_Apax.EnableDataTrigger(0);
	m_Apax.EnableDataTrigger(1);
	m_Apax.EnableDataTrigger(2);
	m_Apax.WinsockConnect();
}

void CExLoginDlg::OnDisconnect() 
{
	m_Apax.Close();
	
}

BEGIN_EVENTSINK_MAP(CExLoginDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExLoginDlg)
	ON_EVENT(CExLoginDlg, IDC_APAX1, 11 /* OnWinsockConnect */, OnOnWinsockConnectApax1, VTS_NONE)
	ON_EVENT(CExLoginDlg, IDC_APAX1, 12 /* OnWinsockDisconnect */, OnOnWinsockDisconnectApax1, VTS_NONE)
	ON_EVENT(CExLoginDlg, IDC_APAX1, 15 /* OnDataTrigger */, OnOnDataTriggerApax1, VTS_I4 VTS_BOOL VTS_VARIANT VTS_I4 VTS_PBOOL)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExLoginDlg::OnOnWinsockConnectApax1() 
{
	SetWindowText("Connected");	
}

void CExLoginDlg::OnOnWinsockDisconnectApax1() 
{
	SetWindowText("ExLogin - Automated Telnet Login");	
}

void CExLoginDlg::OnOnDataTriggerApax1(long Index, BOOL Timeout, const VARIANT FAR& Data, long Size, BOOL FAR* ReEnable) 
{
	ReEnable = false;

	switch (Index)
	{
		case 0 :	if (Timeout == false)
						m_Apax.PutStringCRLF(m_strLoginName);
					else
						MessageBox("Timed out waiting for login prompt");
					return;

		case 1 :	if (Timeout == false)
						m_Apax.PutStringCRLF(m_strPassword);
					else
						MessageBox("Timed out waiting for password prompt");
					return;

	    case 2 :	if (Timeout == false)
					{
						SetWindowText("Logged in");
						m_Apax.TerminalSetFocus();
					}
					else
						MessageBox("Timed out waiting for password verification");
					return;
	}
}
