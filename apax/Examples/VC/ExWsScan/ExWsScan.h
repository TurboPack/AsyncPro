// ExWsScan.h : main header file for the EXWSSCAN application
//

#if !defined(AFX_EXWSSCAN_H__64134B38_01E6_41A6_B1A6_156BB483CCC3__INCLUDED_)
#define AFX_EXWSSCAN_H__64134B38_01E6_41A6_B1A6_156BB483CCC3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExWsScanApp:
// See ExWsScan.cpp for the implementation of this class
//

class CExWsScanApp : public CWinApp
{
public:
	CExWsScanApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExWsScanApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExWsScanApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXWSSCAN_H__64134B38_01E6_41A6_B1A6_156BB483CCC3__INCLUDED_)
