// ExRecvDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExRecv.h"
#include "ExRecvDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CExRecvDlg dialog

CExRecvDlg::CExRecvDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExRecvDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExRecvDlg)
	m_rcvfilename = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExRecvDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExRecvDlg)
	DDX_Control(pDX, IDC_COMBO1, m_cbprotocol);
	DDX_Control(pDX, IDC_BUTTON2, m_stopbtn);
	DDX_Control(pDX, IDC_BUTTON1, m_startbtn);
	DDX_Control(pDX, IDC_APAX1, m_apax);
	DDX_CBString(pDX, IDC_COMBO1, m_rcvfilename);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExRecvDlg, CDialog)
	//{{AFX_MSG_MAP(CExRecvDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON1, OnButton1)
	ON_BN_CLICKED(IDC_BUTTON2, OnButton2)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExRecvDlg message handlers

BOOL CExRecvDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	m_cbprotocol.SetCurSel(m_apax.GetProtocol());
	m_apax.SetTerminalActive(false);
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExRecvDlg::OnPaint() 
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
HCURSOR CExRecvDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

BEGIN_EVENTSINK_MAP(CExRecvDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExRecvDlg)
	ON_EVENT(CExRecvDlg, IDC_APAX1, 17 /* OnTapiConnect */, OnTapiConnectApax1, VTS_NONE)
	ON_EVENT(CExRecvDlg, IDC_APAX1, 27 /* OnProtocolAccept */, OnProtocolAcceptApax1, VTS_PBOOL VTS_PBSTR)
	ON_EVENT(CExRecvDlg, IDC_APAX1, 28 /* OnProtocolFinish */, OnProtocolFinishApax1, VTS_I4)
	ON_EVENT(CExRecvDlg, IDC_APAX1, 21 /* OnTapiPortClose */, OnTapiPortCloseApax1, VTS_NONE)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExRecvDlg::OnButton1() 
{
	m_apax.SetProtocol(m_cbprotocol.GetCurSel());
	m_apax.TapiAnswer();
	this->SetWindowText("Ready");
}

void CExRecvDlg::OnButton2() 
{
	m_apax.Close();
	this->SetWindowText("ExRecv - File Transfer Receiver");
}

void CExRecvDlg::OnTapiConnectApax1() 
{
	m_apax.StartReceive();
}

void CExRecvDlg::OnProtocolAcceptApax1(BOOL FAR* Accept, BSTR FAR* FName) 
{
	m_rcvfilename = *FName;
	this->SetWindowText("Receiving " + m_rcvfilename);
	*Accept = true;
}

void CExRecvDlg::OnProtocolFinishApax1(long ErrorCode) 
{
	if (ErrorCode == 0)	{
		m_apax.TerminalWriteStringCRLF(m_rcvfilename + " received");
		m_apax.StartReceive();
	}
	else	{
		m_apax.TerminalWriteStringCRLF("Protocol error - receiving " + m_rcvfilename);
	}
}

void CExRecvDlg::OnTapiPortCloseApax1() 
{
	this->SetWindowText("ExRecv - File Transfer Receiver");
}
