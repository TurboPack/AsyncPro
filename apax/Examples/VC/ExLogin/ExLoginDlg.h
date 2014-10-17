// ExLoginDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXLOGINDLG_H__B3F4CB92_0465_44CD_B88C_AB22464DA661__INCLUDED_)
#define AFX_EXLOGINDLG_H__B3F4CB92_0465_44CD_B88C_AB22464DA661__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExLoginDlg dialog

class CExLoginDlg : public CDialog
{
// Construction
public:
	CExLoginDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExLoginDlg)
	enum { IDD = IDD_EXLOGIN_DIALOG };
	CApax	m_Apax;
	CString	m_strAddress;
	CString	m_strLoginName;
	CString	m_strPassword;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExLoginDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExLoginDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnConnect();
	afx_msg void OnDisconnect();
	afx_msg void OnOnWinsockConnectApax1();
	afx_msg void OnOnWinsockDisconnectApax1();
	afx_msg void OnOnDataTriggerApax1(long Index, BOOL Timeout, const VARIANT FAR& Data, long Size, BOOL FAR* ReEnable);
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXLOGINDLG_H__B3F4CB92_0465_44CD_B88C_AB22464DA661__INCLUDED_)
