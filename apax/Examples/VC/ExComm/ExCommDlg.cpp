// ExCommDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExComm.h"
#include "shlwapi.h"
#include "ExCommDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CExCommDlg dialog

CExCommDlg::CExCommDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExCommDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExCommDlg)
	m_comnoedit = _T("");
	m_inputedit = _T("");
	m_resultlist = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExCommDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExCommDlg)
	DDX_Control(pDX, IDC_BUTTON5, m_btnputdata);
	DDX_Control(pDX, IDC_BUTTON4, m_btnputstringcrlf);
	DDX_Control(pDX, IDC_BUTTON3, m_btnputstring);
	DDX_Control(pDX, IDC_BUTTON2, m_btnclose);
	DDX_Control(pDX, IDC_BUTTON1, m_btnopen);
	DDX_Control(pDX, IDC_APAX1, m_apax);
	DDX_Text(pDX, IDC_EDIT2, m_inputedit);
	DDX_LBString(pDX, IDC_LIST1, m_resultlist);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExCommDlg, CDialog)
	//{{AFX_MSG_MAP(CExCommDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON1, OnButton1)
	ON_BN_CLICKED(IDC_BUTTON2, OnButton2)
	ON_BN_CLICKED(IDC_BUTTON3, OnButton3)
	ON_BN_CLICKED(IDC_BUTTON4, OnButton4)
	ON_BN_CLICKED(IDC_BUTTON5, OnButton5)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExCommDlg message handlers

BOOL CExCommDlg::OnInitDialog()
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

void CExCommDlg::OnPaint() 
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
HCURSOR CExCommDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CExCommDlg::OnButton1() 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);	

	pA->SetPromptForPort(true);

	pA->PortOpen();
	pA->SetTerminalActive(true);
}

void CExCommDlg::OnButton2() 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);	

	pA->Close();
}

void CExCommDlg::OnButton3() 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);	
	CEdit* pE = (CEdit*) GetDlgItem(IDC_EDIT2);

	char buff[100];
	char* pbuff = buff;

	pE->GetWindowText(pbuff,100);
	pA->PutString(pbuff);
}

void CExCommDlg::OnButton4() 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);	
	CEdit* pE = (CEdit*) GetDlgItem(IDC_EDIT2);

	char buff[100];
	char* pbuff = buff;

	pE->GetWindowText(pbuff,100);
	pA->PutStringCRLF(pbuff);
}

BEGIN_EVENTSINK_MAP(CExCommDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExCommDlg)
	ON_EVENT(CExCommDlg, IDC_APAX1, 9 /* OnRXD */, OnRXDApax1, VTS_VARIANT)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExCommDlg::OnRXDApax1(const VARIANT FAR& Data) 
{
	CListBox* pL = (CListBox*) GetDlgItem(IDC_LIST1);
	SAFEARRAY* psa;
	void HUGEP ** ppvData = NULL;
	char * cp;
	char * tmp;
	
	psa = (SAFEARRAY*)Data.pparray;
	SafeArrayAccessData(psa, ppvData);
	cp = (char*)psa->pvData;
	tmp = cp;

	tmp += psa->cbElements * psa->rgsabound->cElements;
	*tmp = 0;
	pL->AddString(cp);
	SafeArrayUnaccessData(psa);
}

void CExCommDlg::OnButton5() 
{
	CApax* pA = (CApax*) GetDlgItem(IDC_APAX1);	
	CEdit* pE = (CEdit*) GetDlgItem(IDC_EDIT2);
	char buff[100];
	char* pbuff = buff;
	pE->GetWindowText(pbuff,100);
	char* tmp = pbuff;

	CByteArray ba;
	while (*tmp != 0) {
		ba.Add(BYTE(*tmp));
		tmp++;
	}

	COleVariant ov;
	ov = COleVariant(ba);
	pA->PutData(ov);
}
