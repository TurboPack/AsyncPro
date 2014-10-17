// ExCliSrv.h : main header file for the EXCLISRV application
//

#if !defined(AFX_EXCLISRV_H__06ABE2C4_C14E_48E2_8836_9F73D5455EE2__INCLUDED_)
#define AFX_EXCLISRV_H__06ABE2C4_C14E_48E2_8836_9F73D5455EE2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExCliSrvApp:
// See ExCliSrv.cpp for the implementation of this class
//

class CExCliSrvApp : public CWinApp
{
public:
	CExCliSrvApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExCliSrvApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExCliSrvApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXCLISRV_H__06ABE2C4_C14E_48E2_8836_9F73D5455EE2__INCLUDED_)
