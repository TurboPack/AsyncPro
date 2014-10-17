// ExDataTrDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
#include "DataTriggerDlg.h"	// Added by ClassView
//}}AFX_INCLUDES

#if !defined(AFX_EXDATATRDLG_H__14A8DC72_C26F_476B_9D97_2BBEB9616CD7__INCLUDED_)
#define AFX_EXDATATRDLG_H__14A8DC72_C26F_476B_9D97_2BBEB9616CD7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExDataTrDlg dialog

class CExDataTrDlg : public CDialog
{
// Construction
public:
	CExDataTrDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExDataTrDlg)
	enum { IDD = IDD_EXDATATR_DIALOG };
	CListBox	m_lbTriggersFired;
	CListBox	m_lbTriggersAssigned;
	CApax	m_Apax;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExDataTrDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExDataTrDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnOnPortOpenApax1();
	afx_msg void OnContextMenu(CWnd* pWnd, CPoint point);
	afx_msg void OnDatatriggersAddtrigger();
	afx_msg void OnDatatriggersClear();
	afx_msg void OnDatatriggersDisabletrigger();
	afx_msg void OnDatatriggersEnabletrigger();
	afx_msg void OnDatatriggersRemovetrigger();
	afx_msg void OnOnDataTriggerApax1(long Index, BOOL Timeout, const VARIANT FAR& Data, long Size, BOOL FAR* ReEnable);
	afx_msg void OnDblclkTriggersFired();
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	int GetSelectedIndex();
	CDataTriggerDlg m_DataTriggerDlg;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXDATATRDLG_H__14A8DC72_C26F_476B_9D97_2BBEB9616CD7__INCLUDED_)
