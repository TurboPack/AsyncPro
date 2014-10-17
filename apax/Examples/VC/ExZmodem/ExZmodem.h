// ExZmodem.h : main header file for the EXZMODEM application
//

#if !defined(AFX_EXZMODEM_H__E6E3BF08_F467_4BD5_BD1E_62DF6F49B1C3__INCLUDED_)
#define AFX_EXZMODEM_H__E6E3BF08_F467_4BD5_BD1E_62DF6F49B1C3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExZmodemApp:
// See ExZmodem.cpp for the implementation of this class
//

class CExZmodemApp : public CWinApp
{
public:
	CExZmodemApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExZmodemApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExZmodemApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXZMODEM_H__E6E3BF08_F467_4BD5_BD1E_62DF6F49B1C3__INCLUDED_)
