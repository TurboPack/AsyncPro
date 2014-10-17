// ExZmodemDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
#include "commondialog.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXZMODEMDLG_H__84600798_3FB8_432A_AC3B_A1CF5D668D52__INCLUDED_)
#define AFX_EXZMODEMDLG_H__84600798_3FB8_432A_AC3B_A1CF5D668D52__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExZmodemDlg dialog

class CExZmodemDlg : public CDialog
{
// Construction
public:
	CExZmodemDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExZmodemDlg)
	enum { IDD = IDD_EXZMODEM_DIALOG };
	CEdit	m_phoneedit;
	CApax	m_apax;
	CCommonDialog1	m_dlg;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExZmodemDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExZmodemDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnTapiConnectApax1();
	afx_msg void OnTapiPortCloseApax1();
	afx_msg void OnTapiGetNumberApax1(BSTR FAR* PhoneNum);
	afx_msg void OnKillfocusEdit1();
	afx_msg void OnSendButtonClickApax1(BOOL FAR* Default);
	afx_msg void OnReceiveButtonClickApax1(BOOL FAR* Default);
	afx_msg void OnProtocolFinishApax1(long ErrorCode);
	afx_msg void OnProtocolAcceptApax1(BOOL FAR* Accept, BSTR FAR* FName);
	afx_msg void OnListenButtonClickApax1(BOOL FAR* Default);
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXZMODEMDLG_H__84600798_3FB8_432A_AC3B_A1CF5D668D52__INCLUDED_)
