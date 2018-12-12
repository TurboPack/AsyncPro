// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'AsyncProDD.dpk' rev: 32.00 (Windows)

#ifndef AsyncproddHPP
#define AsyncproddHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// (rtl)
#include <SysInit.hpp>
#include <APROReg.hpp>
#include <AdAbout.hpp>
#include <AdPackEd.hpp>
#include <AdPEdit0.hpp>
#include <AdPEditT.hpp>
#include <Adproped.hpp>
#include <AdStatEd.hpp>
#include <AdStatE0.hpp>
#include <Winapi.Windows.hpp>	// (rtl)
#include <Winapi.PsAPI.hpp>	// (rtl)
#include <System.Character.hpp>	// (rtl)
#include <System.Internal.ExcUtils.hpp>	// (rtl)
#include <System.SysUtils.hpp>	// (rtl)
#include <System.VarUtils.hpp>	// (rtl)
#include <System.Variants.hpp>	// (rtl)
#include <System.Rtti.hpp>	// (rtl)
#include <System.TypInfo.hpp>	// (rtl)
#include <System.Math.hpp>	// (rtl)
#include <System.Generics.Defaults.hpp>	// (rtl)
#include <System.Classes.hpp>	// (rtl)
#include <System.TimeSpan.hpp>	// (rtl)
#include <System.DateUtils.hpp>	// (rtl)
#include <System.IOUtils.hpp>	// (rtl)
#include <System.Win.Registry.hpp>	// (rtl)
#include <Vcl.Graphics.hpp>	// (vcl)
#include <System.Actions.hpp>	// (rtl)
#include <Vcl.ActnList.hpp>	// (vcl)
#include <System.HelpIntfs.hpp>	// (rtl)
#include <System.SyncObjs.hpp>	// (rtl)
#include <Winapi.UxTheme.hpp>	// (rtl)
#include <Vcl.GraphUtil.hpp>	// (vcl)
#include <Vcl.StdCtrls.hpp>	// (vcl)
#include <Winapi.ShellAPI.hpp>	// (rtl)
#include <Vcl.Printers.hpp>	// (vcl)
#include <Vcl.Clipbrd.hpp>	// (vcl)
#include <Vcl.ComCtrls.hpp>	// (vcl)
#include <Vcl.Dialogs.hpp>	// (vcl)
#include <Vcl.ExtCtrls.hpp>	// (vcl)
#include <Vcl.Themes.hpp>	// (vcl)
#include <System.AnsiStrings.hpp>	// (rtl)
#include <System.Win.ComObj.hpp>	// (rtl)
#include <Winapi.FlatSB.hpp>	// (rtl)
#include <Vcl.Forms.hpp>	// (vcl)
#include <Vcl.Menus.hpp>	// (vcl)
#include <Winapi.MsCTF.hpp>	// (rtl)
#include <Vcl.Controls.hpp>	// (vcl)
#include <IDEMessages.hpp>	// (designide)
#include <Vcl.CaptionedDockTree.hpp>	// (vcl)
#include <Vcl.DockTabSet.hpp>	// (vcl)
#include <PercentageDockTree.hpp>	// (designide)
#include <BrandingAPI.hpp>	// (designide)
#include <Vcl.Buttons.hpp>	// (vcl)
#include <Vcl.ExtDlgs.hpp>	// (vcl)
#include <Winapi.Mapi.hpp>	// (rtl)
#include <Vcl.ExtActns.hpp>	// (vcl)
#include <Vcl.ActnMenus.hpp>	// (vclactnband)
#include <Vcl.ActnMan.hpp>	// (vclactnband)
#include <Vcl.PlatformDefaultStyleActnCtrls.hpp>	// (vclactnband)
#include <BaseDock.hpp>	// (designide)
#include <DeskUtil.hpp>	// (designide)
#include <DeskForm.hpp>	// (designide)
#include <DockForm.hpp>	// (designide)
#include <Xml.Win.msxmldom.hpp>	// (xmlrtl)
#include <Xml.xmldom.hpp>	// (xmlrtl)
#include <ToolsAPI.hpp>	// (designide)
#include <Proxies.hpp>	// (designide)
#include <DesignEditors.hpp>	// (designide)
#include <Vcl.AxCtrls.hpp>	// (vcl)
#include <Vcl.OleCtrls.hpp>	// (vcl)
#include <OoMisc.hpp>	// (AsyncProDR)
#include <AdStrMap.hpp>	// (AsyncProDR)
#include <AwUser.hpp>	// (AsyncProDR)
#include <AwAbsPcl.hpp>	// (AsyncProDR)
#include <AdProtcl.hpp>	// (AsyncProDR)
#include <AdWUtil.hpp>	// (AsyncProDR)
#include <AwWnsock.hpp>	// (AsyncProDR)
#include <AdPacket.hpp>	// (AsyncProDR)
#include <AwAbsFax.hpp>	// (AsyncProDR)
#include <AwFaxCvt.hpp>	// (AsyncProDR)
#include <AdTUtil.hpp>	// (AsyncProDR)
#include <AdFax.hpp>	// (AsyncProDR)
#include <AdFaxCvt.hpp>	// (AsyncProDR)
#include <AdFStat.hpp>	// (AsyncProDR)
#include <AdPager.hpp>	// (AsyncProDR)
#include <ADTrmPsr.hpp>	// (AsyncProDR)
#include <ADTrmMap.hpp>	// (AsyncProDR)
#include <ADTrmBuf.hpp>	// (AsyncProDR)
#include <ADTrmEmu.hpp>	// (AsyncProDR)
#include <AdScript.hpp>	// (AsyncProDR)
#include <Vcl.Grids.hpp>	// (vcl)
#include <Vcl.OleServer.hpp>	// (vcl)
#include <AdPgr.hpp>	// (AsyncProDR)
#include <adgsm.hpp>	// (AsyncProDR)
#include <AdRasUtl.hpp>	// (AsyncProDR)
#include <AdSapiGr.hpp>	// (AsyncProDR)
#include <AdFPStat.hpp>	// (AsyncProDR)
// SO_SFX: 250
// PRG_EXT: .bpl
// BPI_DIR: C:\Users\Public\Documents\Embarcadero\Studio\19.0\Dcp
// OBJ_DIR: C:\Users\Public\Documents\Embarcadero\Studio\19.0\Dcp
// OBJ_EXT: .obj

//-- user supplied -----------------------------------------------------------

namespace Asyncprodd
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
}	/* namespace Asyncprodd */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_ASYNCPRODD)
using namespace Asyncprodd;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// AsyncproddHPP
