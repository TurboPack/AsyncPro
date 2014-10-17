// ExTelnetDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXTELNETDLG_H__8456F5FA_80C2_4283_955E_7241DDB51710__INCLUDED_)
#define AFX_EXTELNETDLG_H__8456F5FA_80C2_4283_955E_7241DDB51710__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExTelnetDlg dialog

class CExTelnetDlg : public CDialog
{
// Construction
public:
	CExTelnetDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExTelnetDlg)
	enum { IDD = IDD_EXTELNET_DIALOG };
	CEdit	m_addressedit;
	CApax	m_apax;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExTelnetDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExTelnetDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButton1();
	afx_msg void OnButton2();
	afx_msg void OnWinsockConnectApax1();
	afx_msg void OnWinsockDisconnectApax1();
	afx_msg void OnWinsockErrorApax1(long ErrCode);
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXTELNETDLG_H__8456F5FA_80C2_4283_955E_7241DDB51710__INCLUDED_)
