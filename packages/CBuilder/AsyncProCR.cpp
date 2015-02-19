//---------------------------------------------------------------------------

#include <System.hpp>
#pragma hdrstop
USEFORMNS("..\..\source\AdFIDlg.pas", Adfidlg, ApdFaxJobInfoDialog);
USEFORMNS("..\..\source\Adfpstat.pas", Adfpstat, StandardFaxPrinterStatusDisplay);
USEFORMNS("..\..\source\Adfstat.pas", Adfstat, StandardFaxDisplay);
USEFORMNS("..\..\source\AdLibMdm.pas", Adlibmdm, ApdModemSelectionDialog);
USEFORMNS("..\..\source\AdMdmCfg.pas", Admdmcfg, ApdModemConfigDialog);
USEFORMNS("..\..\source\AdMdmDlg.pas", Admdmdlg, ApdModemStatusDialog);
USEFORMNS("..\..\source\AdPStat.pas", Adpstat, StandardDisplay);
USEFORMNS("..\..\source\AdRStat.pas", Adrstat, RasStatusDisplay);
USEFORMNS("..\..\source\AdSelCom.pas", Adselcom, ComSelectForm);
USEFORMNS("..\..\source\adtsel.pas", Adtsel, DeviceSelectionForm);
USEFORMNS("..\..\source\AdTStat.pas", Adtstat, ApdStandardTapiDisplay);
USEFORMNS("..\..\source\AdVoipEd.pas", Advoiped, VoipAudioVideoEditor);
USEFORMNS("..\..\source\Adxdial.pas", Adxdial, DialDialog);
USEFORMNS("..\..\source\Adxdown.pas", Adxdown, DownloadDialog);
USEFORMNS("..\..\source\Adxport.pas", Adxport, ComPortOptions);
USEFORMNS("..\..\source\Adxprot.pas", Adxprot, ProtocolOptions);
USEFORMNS("..\..\source\Adxup.pas", Adxup, UploadDialog);
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
