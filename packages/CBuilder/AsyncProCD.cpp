//---------------------------------------------------------------------------

#include <System.hpp>
#pragma hdrstop
USEFORMNS("..\..\source\adabout.pas", Adabout, ApdAboutForm);
USEFORMNS("..\..\source\adpacked.pas", Adpacked, PacketEditor);
USEFORMNS("..\..\source\Adpedit0.pas", Adpedit0, AdPEdit);
USEFORMNS("..\..\source\AdStatE0.pas", Adstate0, frmConditionEdit);
USEFORMNS("..\..\source\AdStatEd.pas", Adstated, frmStateEdit);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package-Quelltext.
//---------------------------------------------------------------------------


#pragma argsused
extern "C" int _libmain(unsigned long reason)
{
	return 1;
}
//---------------------------------------------------------------------------
