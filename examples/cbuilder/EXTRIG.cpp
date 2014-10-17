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
/*                      EXTRIG.CPP                       */
/*********************************************************/
//---------------------------------------------------------------------------
#include <condefs.h>
#include <vcl\vcl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#pragma hdrstop

//---------------------------------------------------------------------------
USERES("ExIcon.res");
USEFORM("extrig0.cpp", ExTrigTest);

#include "extrig0.h"

//---------------------------------------------------------------------------
int main(int argc, char **argv)
{
	ExTrigTest = new TExTrigTest(0);
  ExTrigTest->ShowModal();
	return 0;
}
//---------------------------------------------------------------------------
