// ExSendDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExSend.h"
#include "ExSendDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CExSendDlg dialog

CExSendDlg::CExSendDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExSendDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExSendDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExSendDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExSendDlg)
	DDX_Control(pDX, IDC_BUTTON3, m_btnsend);
	DDX_Control(pDX, IDC_EDIT1, m_phonenoedit);
	DDX_Control(pDX, IDC_COMBO1, m_cbprotocol);
	DDX_Control(pDX, IDC_APAX1, m_apax);
	DDX_Control(pDX, IDC_COMMONDIALOG1, m_dlg);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExSendDlg, CDialog)
	//{{AFX_MSG_MAP(CExSendDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON1, OnButton1)
	ON_BN_CLICKED(IDC_BUTTON3, OnButton3)
	ON_BN_CLICKED(IDC_BUTTON2, OnButton2)
	ON_BN_CLICKED(IDC_BUTTON4, OnButton4)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExSendDlg message handlers

BOOL CExSendDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	m_cbprotocol.SetCurSel(m_apax.GetProtocol());
	m_phonenoedit.SetWindowText(m_apax.GetTapiNumber());
	m_apax.SetTerminalActive(false);
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExSendDlg::OnPaint() 
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
HCURSOR CExSendDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CExSendDlg::OnButton1() 
{
	char pno[20];
	char* cp = pno;
	
	m_phonenoedit.GetWindowText(cp, 15);
	CString Str = cp;
	m_apax.SetTapiNumber(Str);

	m_apax.TapiDial();
}

void CExSendDlg::OnButton3() 
{
	m_dlg.ShowOpen();
	CString str = m_dlg.GetFileName();

	if (str != "")	{
		m_apax.SetSendFileName(str);
		this->SetWindowText("Sending " + str);
		m_apax.SetProtocol(m_cbprotocol.GetCurSel());
		m_apax.StartTransmit();
	}
}

void CExSendDlg::OnButton2() 
{
	m_apax.Close();	
}

BEGIN_EVENTSINK_MAP(CExSendDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExSendDlg)
	ON_EVENT(CExSendDlg, IDC_APAX1, 17 /* OnTapiConnect */, OnTapiConnectApax1, VTS_NONE)
	ON_EVENT(CExSendDlg, IDC_APAX1, 6 /* OnPortClose */, OnPortCloseApax1, VTS_NONE)
	ON_EVENT(CExSendDlg, IDC_APAX1, 28 /* OnProtocolFinish */, OnProtocolFinishApax1, VTS_I4)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExSendDlg::OnTapiConnectApax1() 
{
	this->SetWindowText("Connected");	
	m_btnsend.EnableWindow(true);
}

void CExSendDlg::OnPortCloseApax1() 
{
	this->SetWindowText("ExSend - File Transfer Sender");	
	m_btnsend.EnableWindow(false);
}

void CExSendDlg::OnProtocolFinishApax1(long ErrorCode) 
{
	if (ErrorCode == 0) {
		m_apax.TerminalWriteStringCRLF(m_apax.GetSendFileName() + " sent");	
	} else {
		m_apax.TerminalWriteStringCRLF(m_apax.GetSendFileName() + " protocol error");
	}
}

void CExSendDlg::OnButton4() 
{
	m_apax.CancelProtocol();	
}
