// ExSendDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
#include "commondialog.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXSENDDLG_H__22F7567A_C4CB_4287_BFF2_5DFB0CC313FC__INCLUDED_)
#define AFX_EXSENDDLG_H__22F7567A_C4CB_4287_BFF2_5DFB0CC313FC__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExSendDlg dialog

class CExSendDlg : public CDialog
{
// Construction
public:
	CExSendDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExSendDlg)
	enum { IDD = IDD_EXSEND_DIALOG };
	CButton	m_btnsend;
	CEdit	m_phonenoedit;
	CComboBox	m_cbprotocol;
	CApax	m_apax;
	CCommonDialog1	m_dlg;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExSendDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExSendDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButton1();
	afx_msg void OnButton3();
	afx_msg void OnButton2();
	afx_msg void OnTapiConnectApax1();
	afx_msg void OnPortCloseApax1();
	afx_msg void OnProtocolFinishApax1(long ErrorCode);
	afx_msg void OnButton4();
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXSENDDLG_H__22F7567A_C4CB_4287_BFF2_5DFB0CC313FC__INCLUDED_)
