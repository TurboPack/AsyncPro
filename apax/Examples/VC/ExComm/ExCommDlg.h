// ExCommDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXCOMMDLG_H__A26A3762_1676_45AE_9B82_9810CBC25B49__INCLUDED_)
#define AFX_EXCOMMDLG_H__A26A3762_1676_45AE_9B82_9810CBC25B49__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExCommDlg dialog

class CExCommDlg : public CDialog
{
// Construction
public:
	CExCommDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExCommDlg)
	enum { IDD = IDD_EXCOMM_DIALOG };
	CButton	m_btnputdata;
	CButton	m_btnputstringcrlf;
	CButton	m_btnputstring;
	CButton	m_btnclose;
	CButton	m_btnopen;
	CApax	m_apax;
	CString	m_comnoedit;
	CString	m_inputedit;
	CString	m_resultlist;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExCommDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExCommDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButton1();
	afx_msg void OnButton2();
	afx_msg void OnButton3();
	afx_msg void OnButton4();
	afx_msg void OnRXDApax1(const VARIANT FAR& Data);
	afx_msg void OnButton5();
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXCOMMDLG_H__A26A3762_1676_45AE_9B82_9810CBC25B49__INCLUDED_)
