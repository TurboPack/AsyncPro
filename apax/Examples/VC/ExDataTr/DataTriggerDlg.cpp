// DataTriggerDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExDataTr.h"
#include "DataTriggerDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDataTriggerDlg dialog


CDataTriggerDlg::CDataTriggerDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDataTriggerDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDataTriggerDlg)
	m_bEnabled = true;
	m_bIgnoreCase = true;
	m_bIncludeStrings = true;
	m_nPacketSize = 0;
	m_nTimeout = 0;
	m_strTriggerString = _T("");
	//}}AFX_DATA_INIT
}


void CDataTriggerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDataTriggerDlg)
	DDX_Check(pDX, IDC_ENABLED, m_bEnabled);
	DDX_Check(pDX, IDC_IGNORE_CASE, m_bIgnoreCase);
	DDX_Check(pDX, IDC_INCLUDE_STRINGS, m_bIncludeStrings);
	DDX_Text(pDX, IDC_PACKET_SIZE, m_nPacketSize);
	DDV_MinMaxInt(pDX, m_nPacketSize, 0, 1024);
	DDX_Text(pDX, IDC_TIMEOUT, m_nTimeout);
	DDV_MinMaxInt(pDX, m_nTimeout, 0, 999999);
	DDX_Text(pDX, IDC_TRIGGER_STRING, m_strTriggerString);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDataTriggerDlg, CDialog)
	//{{AFX_MSG_MAP(CDataTriggerDlg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDataTriggerDlg message handlers

void CDataTriggerDlg::OnOK() 
{
	UpdateData();
	
	CDialog::OnOK();
}
