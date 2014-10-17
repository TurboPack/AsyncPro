// ExZmodemDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExZmodem.h"
#include "ExZmodemDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CExZmodemDlg dialog

CExZmodemDlg::CExZmodemDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExZmodemDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExZmodemDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExZmodemDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExZmodemDlg)
	DDX_Control(pDX, IDC_EDIT1, m_phoneedit);
	DDX_Control(pDX, IDC_APAX1, m_apax);
	DDX_Control(pDX, IDC_COMMONDIALOG1, m_dlg);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExZmodemDlg, CDialog)
	//{{AFX_MSG_MAP(CExZmodemDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_EN_KILLFOCUS(IDC_EDIT1, OnKillfocusEdit1)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExZmodemDlg message handlers

BOOL CExZmodemDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	m_phoneedit.SetWindowText(m_apax.GetTapiNumber());
		
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExZmodemDlg::OnPaint() 
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
HCURSOR CExZmodemDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

BEGIN_EVENTSINK_MAP(CExZmodemDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExZmodemDlg)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 17 /* OnTapiConnect */, OnTapiConnectApax1, VTS_NONE)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 21 /* OnTapiPortClose */, OnTapiPortCloseApax1, VTS_NONE)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 20 /* OnTapiGetNumber */, OnTapiGetNumberApax1, VTS_PBSTR)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 35 /* OnSendButtonClick */, OnSendButtonClickApax1, VTS_PBOOL)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 36 /* OnReceiveButtonClick */, OnReceiveButtonClickApax1, VTS_PBOOL)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 28 /* OnProtocolFinish */, OnProtocolFinishApax1, VTS_I4)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 27 /* OnProtocolAccept */, OnProtocolAcceptApax1, VTS_PBOOL VTS_PBSTR)
	ON_EVENT(CExZmodemDlg, IDC_APAX1, 32 /* OnListenButtonClick */, OnListenButtonClickApax1, VTS_PBOOL)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExZmodemDlg::OnTapiConnectApax1() 
{
	SetWindowText("Connected");
	m_apax.SetShowProtocolButtons(true);
}

void CExZmodemDlg::OnTapiPortCloseApax1() 
{
	m_apax.SetShowProtocolButtons(false);
	SetWindowText("ExZmodem - File Transfer Sender/Receiver");
}

void CExZmodemDlg::OnTapiGetNumberApax1(BSTR FAR* PhoneNum) 
{
	
}

void CExZmodemDlg::OnKillfocusEdit1() 
{
	char phoneno[20];
	char* cp = phoneno;
	m_phoneedit.GetWindowText(cp, 20);

	m_apax.SetTapiNumber(cp);	
}

void CExZmodemDlg::OnSendButtonClickApax1(BOOL FAR* Default) 
{
	*Default = false;
	
	m_dlg.ShowOpen();
	CString Str = m_dlg.GetFileName();

	if (Str != "")	{
		m_apax.SetSendFileName(Str);
		m_apax.SetTerminalActive(false);
		m_apax.TerminalWriteString("Sending " + Str);
		m_apax.StartTransmit();
	}
}

void CExZmodemDlg::OnReceiveButtonClickApax1(BOOL FAR* Default) 
{
	m_apax.SetTerminalActive(false);
}

void CExZmodemDlg::OnProtocolFinishApax1(long ErrorCode) 
{
	if (ErrorCode == 0) {
		CString Str;
		Str.Format("%d", ErrorCode);
		m_apax.TerminalWriteStringCRLF("Error " + Str);	
	} else	{
		m_apax.TerminalWriteStringCRLF(" - OK");
	}
	m_apax.SetTerminalActive(true);
}

void CExZmodemDlg::OnProtocolAcceptApax1(BOOL FAR* Accept, BSTR FAR* FName) 
{
	CString Str = *FName;
	m_apax.TerminalWriteStringCRLF("Receiving " + Str);	
}

void CExZmodemDlg::OnListenButtonClickApax1(BOOL FAR* Default) 
{
	SetWindowText("Ready to answer incoming calls");	
}
