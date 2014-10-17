// ExLogin.h : main header file for the EXLOGIN application
//

#if !defined(AFX_EXLOGIN_H__A6DF7406_4497_4F1F_B1CD_58C8CE52CE67__INCLUDED_)
#define AFX_EXLOGIN_H__A6DF7406_4497_4F1F_B1CD_58C8CE52CE67__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExLoginApp:
// See ExLogin.cpp for the implementation of this class
//

class CExLoginApp : public CWinApp
{
public:
	CExLoginApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExLoginApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExLoginApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXLOGIN_H__A6DF7406_4497_4F1F_B1CD_58C8CE52CE67__INCLUDED_)
