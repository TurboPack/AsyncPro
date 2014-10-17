// ExWsScanDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXWSSCANDLG_H__DB8BFBC1_D921_4DEB_BB7E_461750A10CEB__INCLUDED_)
#define AFX_EXWSSCANDLG_H__DB8BFBC1_D921_4DEB_BB7E_461750A10CEB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExWsScanDlg dialog

class CExWsScanDlg : public CDialog
{
// Construction
public:
	CExWsScanDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExWsScanDlg)
	enum { IDD = IDD_EXWSSCAN_DIALOG };
	CListBox	m_lbPortsFound;
	CString	m_strAddress;
	int		m_nFrom;
	int		m_nTo;
	CApax	m_Apax;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExWsScanDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExWsScanDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnScan();
	afx_msg void OnOnWinsockConnectApax1();
	afx_msg void OnOnWinsockDisconnectApax1();
	afx_msg void OnOnWinsockErrorApax1(long ErrCode);
	afx_msg void OnDblclkPortsFound();
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	int m_nCurrentPort;
	int nCurrentPort;
	void DoNextPort(int nPort);
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXWSSCANDLG_H__DB8BFBC1_D921_4DEB_BB7E_461750A10CEB__INCLUDED_)
