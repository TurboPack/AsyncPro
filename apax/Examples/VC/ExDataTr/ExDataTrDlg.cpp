// ExDataTrDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExDataTr.h"
#include "ExDataTrDlg.h"

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
// CExDataTrDlg dialog

CExDataTrDlg::CExDataTrDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExDataTrDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExDataTrDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CExDataTrDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExDataTrDlg)
	DDX_Control(pDX, IDC_TRIGGERS_FIRED, m_lbTriggersFired);
	DDX_Control(pDX, IDC_TRIGGERS_ASSIGNED, m_lbTriggersAssigned);
	DDX_Control(pDX, IDC_APAX1, m_Apax);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CExDataTrDlg, CDialog)
	//{{AFX_MSG_MAP(CExDataTrDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_CONTEXTMENU()
	ON_COMMAND(ID_DATATRIGGERS_ADDTRIGGER, OnDatatriggersAddtrigger)
	ON_COMMAND(ID_DATATRIGGERS_CLEAR, OnDatatriggersClear)
	ON_COMMAND(ID_DATATRIGGERS_DISABLETRIGGER, OnDatatriggersDisabletrigger)
	ON_COMMAND(ID_DATATRIGGERS_ENABLETRIGGER, OnDatatriggersEnabletrigger)
	ON_COMMAND(ID_DATATRIGGERS_REMOVETRIGGER, OnDatatriggersRemovetrigger)
	ON_LBN_DBLCLK(IDC_TRIGGERS_FIRED, OnDblclkTriggersFired)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExDataTrDlg message handlers

BOOL CExDataTrDlg::OnInitDialog()
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
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CExDataTrDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CExDataTrDlg::OnPaint() 
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
HCURSOR CExDataTrDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

BEGIN_EVENTSINK_MAP(CExDataTrDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CExDataTrDlg)
	ON_EVENT(CExDataTrDlg, IDC_APAX1, 7 /* OnPortOpen */, OnOnPortOpenApax1, VTS_NONE)
	ON_EVENT(CExDataTrDlg, IDC_APAX1, 15 /* OnDataTrigger */, OnOnDataTriggerApax1, VTS_I4 VTS_BOOL VTS_VARIANT VTS_I4 VTS_PBOOL)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CExDataTrDlg::OnOnPortOpenApax1() 
{
	m_Apax.TerminalSetFocus();	
}

void CExDataTrDlg::OnContextMenu(CWnd* pWnd, CPoint point) 
{
	CMenu menuDataTriggers;
	menuDataTriggers.LoadMenu(IDR_MENU1);
	menuDataTriggers.GetSubMenu(0)->TrackPopupMenu(TPM_LEFTALIGN, point.x, point.y, this);
}

void CExDataTrDlg::OnDatatriggersAddtrigger() 
{
	CDataTriggerDlg dlg;

	if (dlg.DoModal() != -1) {
		int nIndex = m_Apax.AddDataTrigger(dlg.m_strTriggerString, dlg.m_nPacketSize,
			dlg.m_nTimeout, dlg.m_bIncludeStrings, dlg.m_bIgnoreCase);
		if (nIndex > -1) 
			m_lbTriggersAssigned.InsertString(nIndex, dlg.m_strTriggerString);
	}
}

void CExDataTrDlg::OnDatatriggersClear() 
{
  m_Apax.RemoveAllDataTriggers();
  m_lbTriggersAssigned.ResetContent();
}

void CExDataTrDlg::OnDatatriggersDisabletrigger() 
{
	int nIndex = GetSelectedIndex();
	if (nIndex > -1)
		m_Apax.DisableDataTrigger(nIndex);
}

void CExDataTrDlg::OnDatatriggersEnabletrigger() 
{
	int nIndex = GetSelectedIndex();
	if (nIndex > -1)
		m_Apax.EnableDataTrigger(nIndex);
}

void CExDataTrDlg::OnDatatriggersRemovetrigger() 
{
	int nIndex = GetSelectedIndex();
	if (nIndex > -1) {
		m_Apax.RemoveDataTrigger(nIndex);
		m_lbTriggersAssigned.DeleteString(nIndex);
	}
}

int CExDataTrDlg::GetSelectedIndex()
{
	if (m_lbTriggersAssigned.GetCount() > 0) {
		
		for (int nIndex = 0; nIndex < m_lbTriggersAssigned.GetCount(); nIndex++) {
			if (m_lbTriggersAssigned.GetSel(nIndex) > 0)
				return nIndex;
		}
	}
	
	return -1;

}

void CExDataTrDlg::OnOnDataTriggerApax1(long Index, BOOL Timeout, 
										const VARIANT FAR& Data, 
										long Size, BOOL FAR* ReEnable) 
{
	CString strItem;

	if ((Index > -1) && (Index < m_lbTriggersAssigned.GetCount())) 
		m_lbTriggersAssigned.GetText(Index, strItem);
	else 
		strItem.Format("Unknown trigger index %d", Index);

	m_lbTriggersFired.AddString(strItem);

	*ReEnable = true;
}

void CExDataTrDlg::OnDblclkTriggersFired() 
{
	m_lbTriggersFired.ResetContent();	
}
