// ExRecvDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXRECVDLG_H__B4007622_83CC_476F_B3D4_E804CD8353A0__INCLUDED_)
#define AFX_EXRECVDLG_H__B4007622_83CC_476F_B3D4_E804CD8353A0__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExRecvDlg dialog

class CExRecvDlg : public CDialog
{
// Construction
public:
	CExRecvDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExRecvDlg)
	enum { IDD = IDD_EXRECV_DIALOG };
	CComboBox	m_cbprotocol;
	CButton	m_stopbtn;
	CButton	m_startbtn;
	CApax	m_apax;
	CString	m_rcvfilename;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExRecvDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExRecvDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButton1();
	afx_msg void OnButton2();
	afx_msg void OnTapiConnectApax1();
	afx_msg void OnProtocolAcceptApax1(BOOL FAR* Accept, BSTR FAR* FName);
	afx_msg void OnProtocolFinishApax1(long ErrorCode);
	afx_msg void OnTapiPortCloseApax1();
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXRECVDLG_H__B4007622_83CC_476F_B3D4_E804CD8353A0__INCLUDED_)
