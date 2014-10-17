// ExComm.h : main header file for the EXCOMM application
//

#if !defined(AFX_EXCOMM_H__B02A0962_E5A3_4254_8C8F_1CE869429830__INCLUDED_)
#define AFX_EXCOMM_H__B02A0962_E5A3_4254_8C8F_1CE869429830__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExCommApp:
// See ExComm.cpp for the implementation of this class
//

class CExCommApp : public CWinApp
{
public:
	CExCommApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExCommApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExCommApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXCOMM_H__B02A0962_E5A3_4254_8C8F_1CE869429830__INCLUDED_)
