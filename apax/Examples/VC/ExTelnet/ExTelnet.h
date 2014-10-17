// ExTelnet.h : main header file for the EXTELNET application
//

#if !defined(AFX_EXTELNET_H__C62CA0D3_F7CE_42C5_AD70_8414A449BDCE__INCLUDED_)
#define AFX_EXTELNET_H__C62CA0D3_F7CE_42C5_AD70_8414A449BDCE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExTelnetApp:
// See ExTelnet.cpp for the implementation of this class
//

class CExTelnetApp : public CWinApp
{
public:
	CExTelnetApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExTelnetApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExTelnetApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXTELNET_H__C62CA0D3_F7CE_42C5_AD70_8414A449BDCE__INCLUDED_)
