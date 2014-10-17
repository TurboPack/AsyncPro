// ExCliSrvDlg.h : header file
//
//{{AFX_INCLUDES()
#include "apax.h"
#include "commondialog.h"
//}}AFX_INCLUDES

#if !defined(AFX_EXCLISRVDLG_H__EA3CF9BA_1444_4302_A0C5_8AC76F0ABA4C__INCLUDED_)
#define AFX_EXCLISRVDLG_H__EA3CF9BA_1444_4302_A0C5_8AC76F0ABA4C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CExCliSrvDlg dialog

class CExCliSrvDlg : public CDialog
{
// Construction
public:
	CExCliSrvDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CExCliSrvDlg)
	enum { IDD = IDD_EXCLISRV_DIALOG };
	CApax	m_apax;
	CString	m_edit1;
	CString	m_edit2;
	CCommonDialog1	m_Dlg;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExCliSrvDlg)
	public:
	virtual int DoModal();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CExCliSrvDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnWinsockConnectApax1();
	afx_msg void OnWinsockDisconnectApax1();
	afx_msg void OnWinsockErrorApax1(long ErrCode);
	afx_msg void OnWinsockAcceptApax1(LPCTSTR Addr, BOOL FAR* Accept);
	afx_msg void OnWinsockGetAddressApax1(BSTR FAR* Address, BSTR FAR* Port);
	afx_msg void OnSendButtonClickApax1(BOOL FAR* Default);
	afx_msg void OnReceiveButtonClickApax1(BOOL FAR* Default);
	afx_msg void OnProtocolFinishApax1(long ErrorCode);
	afx_msg void OnProtocolAcceptApax1(BOOL FAR* Accept, BSTR FAR* FName);
	afx_msg void OnListenButtonClickApax1(BOOL FAR* Default);
	afx_msg void OnConnectButtonClickApax1(BOOL FAR* Default);
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXCLISRVDLG_H__EA3CF9BA_1444_4302_A0C5_8AC76F0ABA4C__INCLUDED_)
