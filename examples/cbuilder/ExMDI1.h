// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Async Professional
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1991-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****

/*********************************************************/
/*                      EXMDI1.H                         */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExMDI1H
#define ExMDI1H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "OoMisc.hpp"
#include "ADTrmEmu.hpp"
//---------------------------------------------------------------------------
class TEXMDIF1 : public TForm
{
__published:	// IDE-managed Components
	TApdComPort *ComPort1;
    TAdTerminal *AdTerminal1;
private:	// User declarations
public:		// User declarations
	virtual __fastcall TEXMDIF1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TEXMDIF1 *EXMDIF1;
//---------------------------------------------------------------------------
#endif
