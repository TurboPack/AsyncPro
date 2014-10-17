// ExWsScanDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExWsScan.h"
#include "ExWsScanDlg.h"

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
// CExWsScanDlg dialog

CExWsScanDlg::CExWsScanDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExWsScanDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExWsScanDlg)
	m_strAddress = _T("");
	m_nFrom = 1;
	m_nTo = 1024;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExWsScanDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExWsScanDlg)
	DDX_Control(pDX, IDC_PORTS_FOUND, m_lbPortsFound);
	DDX_Text(pDX, IDC_ADDRESS, m_strAddress);
	DDX_Text(pDX, IDC_FROM, m_nFrom);
	DDX_Text(pDX, IDC_TO, m_nTo);
	DDX_Control(pDX, IDC_APAX1, m_Apax);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExWsScanDlg, CDialog)
	//{{AFX_MSG_MAP(CExWsScanDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_SCAN, OnScan)
	ON_LBN_DBLCLK(IDC_PORTS_FOUND, OnDblclkPortsFound)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExWsScanDlg message handlers

BOOL CExWsScanDlg::OnInitDialog()
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
	
	m_Apax.SetVisible(false);
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CExWsScanDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CExWsScanDlg::OnPaint() 
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
HCURSOR CExWsScanDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CExWsScanDlg::OnScan() 
{
	UpdateData();
	m_Apax.SetWinsockAddress(m_strAddress);
	DoNextPort(m_nFrom);
}

void CExWsScanDlg::DoNextPort(int nPort)
{
	CString s;
	s.Format("%d", nPort);
	m_nCurrentPort = nPort;
	m_Apax.SetWinsockPort(s);

	s.Format("Scanning port %d", nPort);
	SetWindowText(s);
	m_Apax.WinsockConnect();
}

BEGIN_EVENTSINK_MAP(CExWsScanDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExWsScanDlg)
	ON_EVENT(CExWsScanDlg, IDC_APAX1, 11 /* OnWinsockConnect */, OnOnWinsockConnectApax1, VTS_NONE)
	ON_EVENT(CExWsScanDlg, IDC_APAX1, 12 /* OnWinsockDisconnect */, OnOnWinsockDisconnectApax1, VTS_NONE)
	ON_EVENT(CExWsScanDlg, IDC_APAX1, 13 /* OnWinsockError */, OnOnWinsockErrorApax1, VTS_I4)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExWsScanDlg::OnOnWinsockConnectApax1() 
{
	CString s;
	s.Format("%d", m_nCurrentPort);
	m_lbPortsFound.AddString(s);
	m_Apax.Close();
}

void CExWsScanDlg::OnOnWinsockDisconnectApax1() 
{
	if (m_nCurrentPort < m_nTo)
		DoNextPort(m_nCurrentPort + 1);
	else
		SetWindowText("Done");
	
}

void CExWsScanDlg::OnOnWinsockErrorApax1(long ErrCode) 
{
	m_Apax.Close();	
}

void CExWsScanDlg::OnDblclkPortsFound() 
{
	m_lbPortsFound.ResetContent();	
}
