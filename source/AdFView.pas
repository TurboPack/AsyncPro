(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *  Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADFVIEW.PAS 4.06                    *}
{*********************************************************}
{* TApdFaxViewer component                               *}
{*********************************************************}

{
  This component is a wrapper around the TViewer class
  found in AwFView.  Lots of room for improvement, or outright
  replacement [unpack APF pages to bitmap, view in TImage]
}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$I+,G+,X+,F+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdFView;
  {-Fax viewer component}

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Messages,
  Controls,
  StdCtrls,
  Forms,
  OoMisc,
  AwFView,
  AdExcept,
  AdFaxCvt;

type
  TViewerRotation = (vr0, vr90, vr180, vr270);

const
  afvDefViewBorderStyle       = bsSingle;
  afvDefFGColor               = clBlack;
  afvDefBGColor               = clWhite;
  afvDefScaling               = False;
  afvDefHorizMult             = 1;
  afvDefHorizDiv              = 1;
  afvDefVertMult              = 1;
  afvDefVertDiv               = 1;
  afvDefViewAutoScaleMode     = asDoubleHeight;                      
  afvDefWhitespaceCompression = False;
  afvDefWhitespaceFrom        = 0;
  afvDefWhitespaceTo          = 0;
  afvDefHorizScroll           = DefHScrollInc;
  afvDefVertScroll            = DefHScrollInc;
  afvDefFileName              = '';
  afvDefAcceptDragged         = True;
  afvDefLoadWholeFax          = False;
  afvDefViewerHeight          = 50;
  afvDefViewerWidth           = 100;
  afvDefRotation              = vr0;
  afvDefBusyCursor            = crDefault;

type
  TViewerFileDropEvent = procedure(Sender : TObject; FileName : String) of object;
  TViewerErrorEvent = procedure(Sender : TObject; ErrorCode : Integer) of object;

  {base fax viewer component}
  TApdCustomFaxViewer = class(TApdBaseWinControl)
  protected {private}
    {.Z+}
    {property fields}
    FBorderStyle           : TBorderStyle;
    FFGColor               : TColor;
    FBGColor               : TColor;
    FScaling               : Boolean;
    FHorizMult             : Cardinal;
    FHorizDiv              : Cardinal;
    FVertMult              : Cardinal;
    FVertDiv               : Cardinal;
    FAutoScaleMode         : TAutoScaleMode;
    FWhitespaceCompression : Boolean;
    FWhitespaceFrom        : Cardinal;
    FWhitespaceTo          : Cardinal;
    FHorizScroll           : Cardinal;
    FVertScroll            : Cardinal;
    FFileName              : String;
    FAcceptDragged         : Boolean;
    FLoadWholeFax          : Boolean;
    FRotation              : TViewerRotation;
    FBusyCursor            : TCursor;
    FFileDrop              : TViewerFileDropEvent;
    FPageChange            : TNotifyEvent;
    FViewerError           : TViewerErrorEvent;
    HasBeenCreated         : Boolean;

    procedure CreateWnd; override;
    procedure CreateParams(var Params : TCreateParams); override;
    procedure SetName(const NewName : TComponentName); override;

    {property set methods}
    procedure SetBorderStyle(const NewStyle : TBorderStyle);
    procedure SetFGColor(const NewColor : TColor);
    procedure SetBGColor(const NewColor : TColor);
    procedure SetScaling(const NewScaling : Boolean);
    procedure SetHorizMult(const NewHorizMult : Cardinal);
    procedure SetHorizDiv(const NewHorizDiv : Cardinal);
    procedure SetVertMult(const NewVertMult : Cardinal);
    procedure SetVertDiv(const NewVertDiv : Cardinal);
    procedure SetAutoScaleMode(const NewAutoScaleMode : TAutoScaleMode);
    procedure SetWhitespaceCompression(const NewCompression : Boolean);
    procedure SetWhitespaceFrom(const NewWhitespaceFrom : Cardinal);
    procedure SetWhitespaceTo(const NewWhitespaceTo : Cardinal);
    procedure SetHorizScroll(const NewHorizScroll : Cardinal);
    procedure SetVertScroll(const NewVertScroll : Cardinal);
    procedure SetAcceptDragged(const NewAccept : Boolean);
    procedure SetLoadWholeFax(const NewLoadWholeFax : Boolean);
    procedure SetFileName(const NewFileName : String);
    procedure SetRotation(const NewRotation : TViewerRotation);
    procedure SetBusyCursor(const NewBusyCursor : TCursor);
    procedure SetActivePage(const NewPage : Cardinal);

    {property get methods}
    function GetPageBitmaps(const PageNum : Integer) : TBitmap;
    function GetNumPages : Cardinal;
    function GetActivePage : Cardinal;
    function GetPageWidth : Cardinal;
    function GetPageHeight : Cardinal;
    function GetPageFlags : Word;                                    

    {event virtual methods}
    procedure FileDropped; virtual;
      {-Called when a file is dropped into the viewer}
    procedure PageChange(var Msg : TMessage); message apw_ViewNotifyPage;
      {-Called when the active page changes}
    procedure ViewerError(var Msg : TMessage); message apw_ViewerError;
      {-Called when an error occurs and no result can be returned}

    procedure FillScaleSettings(var Settings : TScaleSettings);
      {-Fill a TScaleSettings structure with current scaling settings}

    procedure wmDropFiles(var Msg : wMsg); message wm_DropFiles;
      {-get a dropped file}

    procedure wmEraseBkGnd(var Msg : TMessage); message wm_EraseBkGnd; 
      {-erase background}

  public
    {creation/destriction}
    constructor Create(AOwner : TComponent); override;
      {-Create a TApdCustomFaxViewer component}
    {.Z-}

    {public methods}
    procedure BeginUpdate;
      {-Begin changing the properties of the viewer--no visual changes}
    procedure EndUpdate;
      {-Invalidates the window and repaints}
    procedure FirstPage;
      {-Move to first page}
    procedure LastPage;
      {-Move to last page}
    procedure NextPage;
      {-Move to next page}
    procedure PrevPage;
      {-Move to previous page}
    procedure SelectRegion(const R : TRect);
      {-Select the image bounded by R}
    procedure SelectImage;
      {-Select entire image}
    procedure CopyToClipBoard;
      {-Copy selected text to clipboard}

    {public properties}
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle default afvDefViewBorderStyle;
    property FGColor : TColor
      read FFGColor write SetFGColor default afvDefFGColor;
    property BGColor : TColor
      read FBGColor write SetBGColor default afvDefBGColor;
    property Scaling : Boolean
      read FScaling write SetScaling;
    property HorizMult : Cardinal
      read FHorizMult write SetHorizMult default afvDefHorizMult;
    property HorizDiv : Cardinal
      read FHorizDiv write SetHorizDiv default afvDefHorizDiv;
    property VertMult : Cardinal
      read FVertMult write SetVertMult default afvDefVertMult;
    property VertDiv : Cardinal
      read FVertDiv write SetVertDiv default afvDefVertDiv;
    property AutoScaleMode : TAutoScaleMode
      read  FAutoScaleMode write SetAutoScaleMode default afvDefViewAutoScaleMode; 
    property WhitespaceCompression : Boolean
      read FWhitespaceCompression write SetWhitespaceCompression default afvDefWhitespaceCompression;
    property WhitespaceFrom : Cardinal
      read FWhitespaceFrom write SetWhitespaceFrom default afvDefWhitespaceFrom;
    property WhitespaceTo : Cardinal
      read FWhitespaceTo write SetWhitespaceTo default afvDefWhitespaceTo;
    property HorizScroll : Cardinal
      read FHorizScroll write SetHorizScroll default afvDefHorizScroll;
    property VertScroll : Cardinal
      read FVertScroll write SetVertScroll default afvDefVertScroll;
    property AcceptDragged : Boolean
      read FAcceptDragged write SetAcceptDragged default afvDefAcceptDragged;
    property LoadWholeFax : Boolean
      read FLoadWholeFax write SetLoadWholeFax default afvDefLoadWholeFax;
    property FileName : String
      read FFileName write SetFileName;
    property Rotation : TViewerRotation
      read FRotation write SetRotation default afvDefRotation;
    property BusyCursor : TCursor
      read FBusyCursor write SetBusyCursor default afvDefBusyCursor;

    {unpublished in TApdFaxViewer}
    property PageBitmaps[const Index : Integer] : TBitmap
      read GetPageBitmaps;
    property NumPages : Cardinal
      read GetNumPages;
    property ActivePage : Cardinal
      read GetActivePage write SetActivePage;
    property PageWidth : Cardinal
      read GetPageWidth;
    property PageHeight : Cardinal
      read GetPageHeight;
    property PageFlags : Word
      read GetPageFlags;                            

    {events}
    property OnDropFile : TViewerFileDropEvent
      read FFileDrop write FFileDrop;
    property OnPageChange : TNotifyEvent
      read FPageChange write FPageChange;
    property OnViewerError : TViewerErrorEvent
      read FViewerError write FViewerError;
  end;

  {fax viewer component}
  TApdFaxViewer = class(TApdCustomFaxViewer)
  published
    {published properties}
    property Version;                                           
    property BorderStyle;
    property FGColor;
    property BGColor;
    property Scaling;
    property HorizMult;
    property HorizDiv;
    property VertMult;
    property VertDiv;
    property AutoScaleMode;
    property WhitespaceCompression;
    property WhitespaceFrom;
    property WhitespaceTo;
    property HorizScroll;
    property VertScroll;
    property AcceptDragged;
    property LoadWholeFax;
    property BusyCursor;
    property FileName;

    {published events}
    property OnDropFile;
    property OnPageChange;
    property OnViewerError;

    {published inherited properties}
    property Align;
    property Ctl3D;
    property Cursor;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property TabOrder;
    property TabStop;
    property Visible;

    {Published inherited events}
    property OnClick;
    property OnDblClick;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

implementation

  procedure TApdCustomFaxViewer.CreateWnd;
  var
    Opt      : Word;
    Settings : TScaleSettings;
    TempZ    : array[0..255] of Char;

  begin
    inherited CreateWnd;

    HasBeenCreated := True;

    if csDesigning in ComponentState then
      SendMessage(Handle, apw_ViewSetDesignMode, 0, Integer(StrPCopy(TempZ, Name)));

    SendMessage(Handle, apw_ViewSetFG, 0, FGColor);
    SendMessage(Handle, apw_ViewSetBG, 0, BGColor);

    if not (csDesigning in ComponentState) then begin
      if FScaling then begin
        FillScaleSettings(Settings);
        SendMessage(Handle, apw_ViewSetScale, 0, Integer(@Settings));
      end;
      if FWhitespaceCompression then
        SendMessage(Handle, apw_ViewSetWhitespace, FWhitespaceFrom, FWhitespaceTo);
      SendMessage(Handle, apw_ViewSetScroll, FHorizScroll, FVertScroll);
      SendMessage(Handle, apw_ViewSetScroll, FHorizScroll, FVertScroll);
      case FAutoScaleMode of
        asDoubleHeight: Opt := ufAutoDoubleHeight;
        asHalfWidth   : Opt := ufAutoHalfWidth;
        else
          Opt := 0;
      end;
      SendMessage(Handle, apw_ViewSetAutoScale, Opt, 0);

      if not (csDesigning in ComponentState) then
        CheckException(Self, SendMessage(Handle, apw_ViewSetFile, 0, Integer(StrPCopy(TempZ, FFileName))));

      SendMessage(Handle, apw_ViewsetLoadWholeFax, Ord(FLoadWholeFax), 0);
      SendMessage(Handle, apw_ViewSetBusyCursor, Screen.Cursors[BusyCursor], 0);
    end;
  end;

  procedure TApdCustomFaxViewer.CreateParams(var Params : TCreateParams);
  begin
    inherited CreateParams(Params);

    if csDesigning in ComponentState then begin
      RegisterFaxViewerClass(True);
      CreateSubClass(Params, FaxViewerClassNameDesign);
    end else begin
      RegisterFaxViewerClass(False);
      CreateSubClass(Params, FaxViewerClassName);
      Params.Style := Params.Style or vws_DragDrop;
    end;

    if (FBorderStyle = bsSingle) then
      Params.Style := Params.Style or ws_Border;
  end;

  procedure TApdCustomFaxViewer.SetName(const NewName : TComponentName);
  var
    TempZ : array[0..255] of Char;

  begin
    inherited SetName(NewName);

    if (csDesigning in ComponentState) and HasBeenCreated then
      SendMessage(Handle, apw_ViewSetDesignMode, 0, Integer(StrPCopy(TempZ, NewName)));
  end;

  procedure TApdCustomFaxViewer.SetBorderStyle(const NewStyle : TBorderStyle);
  begin
    if (NewStyle = FBorderStyle) then
      Exit;

    FBorderStyle := NewStyle;
    if HandleAllocated then
      RecreateWnd;
  end;

  procedure TApdCustomFaxViewer.SetFGColor(const NewColor : TColor);
  begin
    if NewColor <> FFGColor then begin
      FFGColor := NewColor;
      SendMessage(Handle, apw_ViewSetFG, 0, NewColor);
      Invalidate;
    end;                                                          
  end;

  procedure TApdCustomFaxViewer.SetBGColor(const NewColor : TColor);
  begin
    if NewColor <> FBGColor then begin
      FBGColor := NewColor;
      SendMessage(Handle, apw_ViewSetBG, 0, NewColor);
      Invalidate;
    end;                                                         
  end;

  procedure TApdCustomFaxViewer.SetScaling(const NewScaling : Boolean);
  var
    Settings : TScaleSettings;

  begin
    if (FScaling <> NewScaling) then begin
      FScaling := NewScaling;

      if not FScaling then
        with Settings do begin
          HMult := 1;
          HDiv  := 1;
          VMult := 1;
          VDiv  := 1;
        end
      else
        FillScaleSettings(Settings);

      CheckException(Self, SendMessage(Handle, apw_ViewSetScale, 0, Integer(@Settings)));
    end;
  end;

  procedure TApdCustomFaxViewer.SetHorizMult(const NewHorizMult : Cardinal);
  var
    Settings : TScaleSettings;

  begin
    if (NewHorizMult = FHorizMult) or (NewHorizMult = 0) then
      Exit;

    FHorizMult := NewHorizMult;

    if FScaling then begin
      FillScaleSettings(Settings);
      Settings.HMult := NewHorizMult;
      CheckException(Self, SendMessage(Handle, apw_ViewSetScale, 0, Integer(@Settings)));
    end;
  end;

  procedure TApdCustomFaxViewer.SetHorizDiv(const NewHorizDiv : Cardinal);
  var
    Settings : TScaleSettings;

  begin
    if (NewHorizDiv = FHorizDiv) or (NewHorizDiv = 0) then
      Exit;

    FHorizDiv := NewHorizDiv;

    if FScaling then begin
      FillScaleSettings(Settings);
      Settings.HDiv := NewHorizDiv;
      CheckException(Self, SendMessage(Handle, apw_ViewSetScale, 0, Integer(@Settings)));
    end;
  end;

  procedure TApdCustomFaxViewer.SetVertMult(const NewVertMult : Cardinal);
  var
    Settings : TScaleSettings;

  begin
    if (NewVertMult = FVertMult) or (NewVertMult = 0) then
      Exit;

    FVertMult := NewVertMult;

    if FScaling then begin
      FillScaleSettings(Settings);
      Settings.VMult := NewVertMult;
      CheckException(Self, SendMessage(Handle, apw_ViewSetScale, 0, Integer(@Settings)));
    end;
  end;

  procedure TApdCustomFaxViewer.SetVertDiv(const NewVertDiv : Cardinal);
  var
    Settings : TScaleSettings;

  begin
    if (NewVertDiv = FVertDiv) or (NewVertDiv = 0) then
      Exit;

    FVertDiv := NewVertDiv;

    if FScaling then begin
      FillScaleSettings(Settings);
      Settings.VDiv := NewVertDiv;
      CheckException(Self, SendMessage(Handle, apw_ViewSetScale, 0, Integer(@Settings)));
    end;
  end;

  procedure TApdCustomFaxViewer.SetAutoScaleMode(const NewAutoScaleMode : TAutoScaleMode);
  var
    Opt : Word;

  begin
    if (NewAutoScaleMode = FAutoScaleMode) then
      Exit;
    case NewAutoScaleMode of
      asDoubleHeight: Opt := ufAutoDoubleHeight;
      asHalfWidth   : Opt := ufAutoHalfWidth;
      else
        Opt := 0;
    end;
    SendMessage(Handle, apw_ViewSetAutoScale, Opt, 0);

    FAutoScaleMode := NewAutoScaleMode;
  end;

  procedure TApdCustomFaxViewer.SetWhitespaceCompression(const NewCompression : Boolean);
  begin
    if (FWhitespaceCompression <> NewCompression) then begin
      FWhitespaceCompression := NewCompression;

      if not FWhitespaceCompression then
        CheckException(Self, SendMessage(Handle, apw_ViewSetWhitespace, 0, 0))
      else
        CheckException(Self, SendMessage(Handle, apw_ViewSetWhitespace, FWhitespaceFrom, FWhitespaceTo));
    end;
  end;

  procedure TApdCustomFaxViewer.SetWhitespaceFrom(const NewWhitespaceFrom : Cardinal);
  begin
    if (NewWhitespaceFrom <> FWhitespaceFrom) then begin
      FWhitespaceFrom := NewWhitespaceFrom;

      if FWhitespaceCompression then
        CheckException(Self, SendMessage(Handle, apw_ViewSetWhitespace, FWhitespaceFrom, FWhitespaceTo));
    end;
  end;

  procedure TApdCustomFaxViewer.SetWhitespaceTo(const NewWhitespaceTo : Cardinal);
  begin
    if (NewWhitespaceTo <> FWhitespaceTo) then begin
      FWhitespaceTo := NewWhitespaceTo;

      if FWhitespaceCompression then
        CheckException(Self, SendMessage(Handle, apw_ViewSetWhitespace, FWhitespaceFrom, FWhitespaceTo));
    end;
  end;

  procedure TApdCustomFaxViewer.SetHorizScroll(const NewHorizScroll : Cardinal);
  begin
    if (NewHorizScroll <> FHorizScroll) then begin
      FHorizScroll := NewHorizScroll;

      SendMessage(Handle, apw_ViewSetScroll, FHorizScroll, FVertScroll);
    end;
  end;

  procedure TApdCustomFaxViewer.SetVertScroll(const NewVertScroll : Cardinal);
  begin
    if (NewVertScroll <> FVertScroll) then begin
      FVertScroll := NewVertScroll;

      SendMessage(Handle, apw_ViewSetScroll, FHorizScroll, FVertScroll);
    end;
  end;

  procedure TApdCustomFaxViewer.SetAcceptDragged(const NewAccept : Boolean);
  begin
  end;

  procedure TApdCustomFaxViewer.SetLoadWholeFax(const NewLoadWholeFax : Boolean);
  begin
    if (NewLoadWholeFax = FLoadWholeFax) then
      Exit;

    SendMessage(Handle, apw_ViewsetLoadWholeFax, Ord(NewLoadWholeFax), 0);
    FLoadWholeFax := NewLoadWholeFax;
  end;

  procedure TApdCustomFaxViewer.SetFileName(const NewFileName : String);
  var
    FNameZ : array[0..255] of Char;
  begin
    FFileName := NewFileName;

    if not (csDesigning in ComponentState) then begin
      CheckException(Self, SendMessage(Handle, apw_ViewSetFile, 0, Integer(StrPCopy(FNameZ, FFileName))));

      FRotation  := vr0;
      FHorizMult := 1;
      FHorizDiv  := 1;
      FVertMult  := 1;
      FVertDiv   := 1;
    end;
  end;

  procedure TApdCustomFaxViewer.SetRotation(const NewRotation : TViewerRotation);
  begin
    if (NewRotation = FRotation) then
      Exit;

    CheckException(Self, SendMessage(Handle, apw_ViewSetRotation, Ord(NewRotation), 0));
    FRotation := NewRotation;
  end;

  procedure TApdCustomFaxViewer.SetBusyCursor(const NewBusyCursor : TCursor);
  begin
    if (NewBusyCursor = BusyCursor) then
      Exit;

    SendMessage(Handle, apw_ViewSetBusyCursor, Screen.Cursors[NewBusyCursor], 0);
    FBusyCursor := NewBusyCursor;
  end;

  procedure TApdCustomFaxViewer.SetActivePage(const NewPage : Cardinal);
  begin
    if (ActivePage <> NewPage) and (FFileName <> '') then begin
      if (NewPage = 0) or (NewPage > NumPages) then
        CheckException(Self, ecBadArgument);

      CheckException(Self, SendMessage(Handle, apw_ViewGotoPage, NewPage, 0));
    end;
  end;

  function TApdCustomFaxViewer.GetPageBitmaps(const PageNum : Integer) : TBitmap;
  var
    H : HBitmap;
    P : TPoint;

  begin
    if (PageNum = 0) or (PageNum > Integer(NumPages)) then           
      CheckException(Self, ecBadArgument);

    H := SendMessage(Handle, apw_ViewGetBitmap, PageNum, Integer(@P));
    if (H = 0) then
      Result := nil
    else begin
      Result := TBitmap.Create;
      Result.Handle := H;
    end;
  end;

  function TApdCustomFaxViewer.GetNumPages : Cardinal;
  begin
    Result := SendMessage(Handle, apw_ViewGetNumPages, 0, 0);
  end;

  function TApdCustomFaxViewer.GetActivePage : Cardinal;
  begin
    Result := SendMessage(Handle, apw_ViewGetCurPage, 0, 0);
  end;

  function TApdCustomFaxViewer.GetPageWidth : Cardinal;
  var
    R : TRect;

  begin
    SendMessage(Handle, apw_ViewGetPageDim, 0, Integer(@R));
    Result := Succ(R.Right);
  end;

  function TApdCustomFaxViewer.GetPageHeight : Cardinal;
  var
    R : TRect;

  begin
    SendMessage(Handle, apw_ViewGetPageDim, 0, Integer(@R));
    Result := Succ(R.Bottom);
  end;

  function TApdCustomFaxViewer.GetPageFlags : Word;                  
  begin
    Result := SendMessage(Handle, apw_ViewGetPageFlags, 0, 0);
  end;

  procedure TApdCustomFaxViewer.FileDropped;
    {-Called when a file is dropped into the viewer}
  begin
    FFileName := StrPas(PChar(SendMessage(Handle, apw_ViewGetFileName, 0, 0))); 
    if Assigned(FFileDrop) then
      FFileDrop(Self, FileName);
  end;

  procedure TApdCustomFaxViewer.PageChange;
    {-Called when the active page changes}
  begin
    if Assigned(FPageChange) then
      FPageChange(Self);
  end;

  procedure TApdCustomFaxViewer.ViewerError(var Msg : TMessage);
    {-Called when an error occurs and no result can be returned}
  begin
    if Assigned(FViewerError) then
      FViewerError(Self, Integer(Msg.wParam));
  end;

  procedure TApdCustomFaxViewer.wmDropFiles(var Msg : wMsg);
  {-get a dropped file}
  begin
    inherited;
    FileDropped;
  end;

  procedure TApdCustomFaxViewer.wmEraseBkGnd(var Msg : TMessage);
  {-erase background}
  begin
    Msg.Result := 1;
  end;

  procedure TApdCustomFaxViewer.FillScaleSettings(var Settings : TScaleSettings);
    {-Fill a TScaleSettings structure with current scaling settings}
  begin
    with Settings do begin
      HMult := FHorizMult;
      HDiv  := FHorizDiv;
      VMult := FVertMult;
      VDiv  := FVertDiv;
    end;
  end;

  constructor TApdCustomFaxViewer.Create(AOwner : TComponent);
    {-Create a TApdCustomFaxViewer component}
  begin
    inherited Create(AOwner);

    {inits}
    FBorderStyle           := afvDefViewBorderStyle;
    FFGColor               := afvDefFGColor;
    FBGColor               := afvDefBGColor;
    FScaling               := afvDefScaling;
    FHorizMult             := afvDefHorizMult;
    FHorizDiv              := afvDefHorizDiv;
    FVertMult              := afvDefVertMult;
    FVertDiv               := afvDefVertDiv;
    FAutoScaleMode         := afvDefViewAutoScaleMode;               
    FWhitespaceCompression := afvDefWhitespaceCompression;
    FWhitespaceFrom        := afvDefWhitespaceFrom;
    FWhitespaceTo          := afvDefWhitespaceTo;
    FHorizScroll           := afvDefHorizScroll;
    FVertScroll            := afvDefVertScroll;
    FFileName              := afvDefFileName;
    FAcceptDragged         := afvDefAcceptDragged;
    FLoadWholeFax          := afvDefLoadWholeFax;
    FFileDrop              := nil;
    FPageChange            := nil;
    FViewerError           := nil;
    FRotation              := vr0;
    FBusyCursor            := afvDefBusyCursor;
    Height                 := afvDefViewerHeight;
    Width                  := afvDefViewerWidth;
    TabStop                := True;
    HasBeenCreated         := False;
  end;

  procedure TApdCustomFaxViewer.BeginUpdate;
    {-Begin changing the properties of the viewer--no visual changes}
  begin
    SendMessage(Handle, apw_ViewStartUpdate, 0, 0);
  end;

  procedure TApdCustomFaxViewer.EndUpdate;
    {-Invalidates the window and repaints}
  begin
    SendMessage(Handle, apw_ViewEndUpdate, 0, 0);
  end;

  procedure TApdCustomFaxViewer.FirstPage;
    {-Move to first page}
  begin
    if (FFileName <> '') then
      ActivePage := 1;
  end;

  procedure TApdCustomFaxViewer.LastPage;
    {-Move to last page}
  begin
    if (FFileName <> '') then
      ActivePage := NumPages;
  end;

  procedure TApdCustomFaxViewer.NextPage;
    {-Move to next page}
  begin
    if (FFileName <> '') and (ActivePage <> NumPages) then
      ActivePage := ActivePage + 1;
  end;

  procedure TApdCustomFaxViewer.PrevPage;
    {-Move to previous page}
  begin
    if (FFileName <> '') and (ActivePage <> 1) then
      ActivePage := ActivePage - 1;
  end;

  procedure TApdCustomFaxViewer.SelectRegion(const R : TRect);
    {-Select the image bounded by R}
  begin
    SendMessage(Handle, apw_ViewSelect, 0, Integer(@R));
  end;

  procedure TApdCustomFaxViewer.SelectImage;
    {-Select entire image}
  begin
    SendMessage(Handle, apw_ViewSelectAll, 0, 0);
  end;

  procedure TApdCustomFaxViewer.CopyToClipBoard;
    {-Copy selected text to clipboard}
  begin
    SendMessage(Handle, apw_ViewCopy, 0, 0);
  end;

end.
