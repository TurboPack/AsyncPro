#if !defined(AFX_DATATRIGGERDLG_H__19676F8D_9F0E_4FD2_8172_921CDF475ECF__INCLUDED_)
#define AFX_DATATRIGGERDLG_H__19676F8D_9F0E_4FD2_8172_921CDF475ECF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DataTriggerDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDataTriggerDlg dialog

class CDataTriggerDlg : public CDialog
{
// Construction
public:
	CDataTriggerDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDataTriggerDlg)
	enum { IDD = IDD_ADDTRIGGER_DIALOG };
	BOOL	m_bEnabled;
	BOOL	m_bIgnoreCase;
	BOOL	m_bIncludeStrings;
	int		m_nPacketSize;
	int		m_nTimeout;
	CString	m_strTriggerString;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDataTriggerDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDataTriggerDlg)
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DATATRIGGERDLG_H__19676F8D_9F0E_4FD2_8172_921CDF475ECF__INCLUDED_)
