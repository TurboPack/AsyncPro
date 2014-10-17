// ExRecv.h : main header file for the EXRECV application
//

#if !defined(AFX_EXRECV_H__77350C94_1620_4884_AC1C_9E7BAD806C75__INCLUDED_)
#define AFX_EXRECV_H__77350C94_1620_4884_AC1C_9E7BAD806C75__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CExRecvApp:
// See ExRecv.cpp for the implementation of this class
//

class CExRecvApp : public CWinApp
{
public:
	CExRecvApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CExRecvApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CExRecvApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_EXRECV_H__77350C94_1620_4884_AC1C_9E7BAD806C75__INCLUDED_)
