// ExSend.h : main header file for the EXSEND application
//

#if !defined(AFX_EXSEND_H__A2F656FA_E004_49AB_88BB_92E8BA7B317E__INCLUDED_)
#define AFX_EXSEND_H__A2F656FA_E004_49AB_88BB_92E8BA7B317E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExSendApp:
// See ExSend.cpp for the implementation of this class
//

class CExSendApp : public CWinApp
{
public:
	CExSendApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExSendApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExSendApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXSEND_H__A2F656FA_E004_49AB_88BB_92E8BA7B317E__INCLUDED_)
