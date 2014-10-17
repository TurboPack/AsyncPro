// ExDataTr.h : main header file for the EXDATATR application
//

#if !defined(AFX_EXDATATR_H__6DD5F80C_EE80_4969_AECA_5AE48F256C69__INCLUDED_)
#define AFX_EXDATATR_H__6DD5F80C_EE80_4969_AECA_5AE48F256C69__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExDataTrApp:
// See ExDataTr.cpp for the implementation of this class
//

class CExDataTrApp : public CWinApp
{
public:
	CExDataTrApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExDataTrApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExDataTrApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXDATATR_H__6DD5F80C_EE80_4969_AECA_5AE48F256C69__INCLUDED_)
