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
{*                   ADTRMEMU.PAS 4.06                   *}
{*********************************************************}
{*   Terminal: Terminal, Emulator ancestor, and TTY &    *}
{*                    VT100 Emulators                    *}
{*********************************************************}

unit ADTrmEmu;                 

{Notes:
        To speed up the display of lots of data, the terminal provides
        a lazy display option. If data is arriving at full speed, the
        terminal 'saves up' the data it needs to display until either
        (a) it receives a certain number of bytes (defaulting to 200
        bytes), or (b) until no data has arrived or the keyboard was
        not used for a certain amount of time (default 100
        milliseconds). This improves the perceived speed of the
        terminal display.

        The BlinkTime property can be set to 0, meaning no blinking.
        This in turn means that text on the display marked as blinking
        will not, it'll be 'on' all the time. For efficiency reasons,
        the blink rate cannot be set to anything less than 250 milli-
        seconds.

        The Capture property has only two values on reading: whether
        data capture is 'on' or 'off'. It has three possible values on
        writing: 'on', 'off', or 'append'. If the value written is
        'append' and the current value is 'off', the capture file is
        opened in non-sharing mode for appending data and the value of
        the Capture property is then set to 'on' (note that if the
        file doesn't exist, it will be created). If the value written
        is 'append' and the current value is 'on', nothing happens.

        A valid value for the CaptureFile property is required to set
        Capture to 'on' or 'append'. If Capture is 'on' and the value
        of CaptureFile is changed, Capture is set 'off', the internal
        file name changed and then Capture is set back 'on'. If you
        want to append to the new file in this situation, the user is
        responsible for manually setting Capture 'off' before and then
        'append' afterwards.
        }

{ several preliminary code changes are left in the code, marked by !!.!! }
{ comments.  They should be invisible to current applications }

{$I AWDEFINE.INC}

{$Z-}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  Forms,
  Dialogs,
  ClipBrd,
  Menus,
  OOMisc,
  ADPort,
  ADExcept,
  ADTrmPsr,
  ADTrmMap,
  ADTrmBuf;

type
  TAdCharSource = (csUnknown, csKeyboard, csPort, csWriteChar);        {!!.04}

  TAdEmuCommand = (ecNone,                                             {!!.04}
                   ecBell,                                             {!!.04}
                   ecBackspace,                                        {!!.04}
                   ecTabHorz,                                          {!!.04}
                   ecLF,                                               {!!.04}
                   ecCR,                                               {!!.04}
                   ecBackTabHorz,                                      {!!.04}
                   ecCursorDown,                                       {!!.04}
                   ecCursorLeft,                                       {!!.04}
                   ecCursorRight,                                      {!!.04}
                   ecCursorUp,                                         {!!.04}
                   ecCursorPos,                                        {!!.04}
                   ecDeleteChars,                                      {!!.04}
                   ecDeleteLines,                                      {!!.04}
                   ecInsertChars,                                      {!!.04}
                   ecInsertLines,                                      {!!.04}
                   ecEraseAll,                                         {!!.04}
                   ecEraseChars,                                       {!!.04}
                   ecEraseFromBOW,                                     {!!.04}
                   ecEraseFromBOL,                                     {!!.04}
                   ecEraseLine,                                        {!!.04}
                   ecEraseScreen,                                      {!!.04}
                   ecEraseToEOL,                                       {!!.04}
                   ecEraseToEOW,                                       {!!.04}
                   ecSetHorzTabStop,                                   {!!.04}
                   ecClearHorzTabStop,                                 {!!.04}
                   ecClearVertTabStop,                                 {!!.04}
                   ecClearAllHorzTabStops,                             {!!.04}
                   ecSetVertTabStop,                                   {!!.04}
                   ecClearAllVertTabStops,                             {!!.04}
                   ecSetScrollRegion,                                  {!!.04}
                   ecTabVert,                                          {!!.04}
                   ecBackTabVert,                                      {!!.04}
                   ecBackColor,                                        {!!.04}
                   ecForeColor,                                        {!!.04}
                   ecAbsAddress,                                       {!!.04}
                   ecNoAbsAddress,                                     {!!.04}
                   ecAutoWrap,                                         {!!.04}
                   ecNoAutoWrap,                                       {!!.04}
                   ecAutoWrapDelay,                                    {!!.04}
                   ecNoAutoWrapDelay,                                  {!!.04}
                   ecInsertMode,                                       {!!.04}
                   ecNoInsertMode,                                     {!!.04}
                   ecNewLineMode,                                      {!!.04}
                   ecNoNewLineMode,                                    {!!.04}
                   ecScrollRegion,                                     {!!.04}
                   ecNoScrollRegion,                                   {!!.04}
                   ecSetCharAttr,                                      {!!.04}
                   ecAddBold,                                          {!!.04}
                   ecBoldOnly,                                         {!!.04}
                   ecRemoveBold,                                       {!!.04}
                   ecInvertBold,                                       {!!.04}
                   ecAddUnderLine,                                     {!!.04}
                   ecUnderlineOnly,                                    {!!.04}
                   ecRemoveUnderline,                                  {!!.04}
                   ecInvertUnderline,                                  {!!.04}
                   ecAddStrikethrough,                                 {!!.04}
                   ecStrikethroughOnly,                                {!!.04}
                   ecRemoveStrikethrough,                              {!!.04}
                   ecInvertStrikethrough,                              {!!.04}
                   ecAddBlink,                                         {!!.04}
                   ecBlinkOnly,                                        {!!.04}
                   ecRemoveBlink,                                      {!!.04}
                   ecInvertBlink,                                      {!!.04}
                   ecAddReverse,                                       {!!.04}
                   ecReverseOnly,                                      {!!.04}
                   ecRemoveReverse,                                    {!!.04}
                   ecInvertReverse,                                    {!!.04}
                   ecAddInvisible,                                     {!!.04}
                   ecInvisibleOnly,                                    {!!.04}
                   ecRemoveInvisible,                                  {!!.04}
                   ecInvertInvisible,                                  {!!.04}
                   ecAddSelected,                                      {!!.04}
                   ecRemoveSelected,                                   {!!.04}
                   ecSelectedOnly,                                     {!!.04}
                   ecInvertSelected,                                   {!!.04}
                   ecRemoveAllAttr,                                    {!!.04}
                   ecRemoveAllAttrIgnoreSelect,                        {!!.04}
                   ecClearAndHome,                                     {!!.04}
                   ecHome,                                             {!!.04}
                   ecCursorEOL,                                        {!!.04}
                   ecCursorBOL,                                        {!!.04}
                   ecCursorTop,                                        {!!.04}
                   ecCursorBottom,                                     {!!.04}
                   ecWriteString,                                      {!!.04}
                   ecColor,                                            {!!.04}
                   ecSaveCursorPos,                                    {!!.04}
                   ecRestoreCursorPos,                                 {!!.04}
                   ecDeviceAttributesReport,                           {!!.04}
                   ecNEL,                                              {!!.04}
                   ecReset,                                            {!!.04}
                   ecAnswerback,                                       {!!.04}
                   ecDECALN,                                           {!!.04}
                   ecDeviceStatusReport,                               {!!.06}
                   ecCursorOff,                                        {!!.06}
                   ecCursorUnderline,                                  {!!.06}
                   ecCursorBlock                                       {!!.06}
                  );                                                   {!!.04}

type
  TAdCaptureMode = ( {terminal data capture modes..}
          cmOff,     {..no capturing of data}
          cmOn,      {..capture new data to new file}
          cmAppend); {..capture data, appending to old file}

  TAdTerminalCursorMovedEvent =
     procedure (aSender : TObject; aRow, aCol : integer) of object;

  TAdCursorType = (  {cursor types}
    ctNone,          {..no cursor is visible}
    ctUnderline,     {..underline cursor}
    ctBlock);        {..block cursor}

  TAdVT100LineAttr = ( {special VT100 line attributes}
    ltNormal,          {..normal, no special attrs}
    ltDblHeightTop,    {..line is top half of double-height line}
    ltDblHeightBottom, {..line is bottom half of double-height line}
    ltDblWidth);       {..line is double-width}

const
  {default property values for the terminal}
  adc_TermActive = true;
  adc_TermBackColor = adc_TermBufBackColor;
  adc_TermBlinkTime = 500;
  adc_TermBorderStyle = bsSingle;
  adc_TermCapture = cmOff;
  adc_TermCaptureFile = 'APROTERM.CAP';
  adc_TermColumnCount = adc_TermBufColCount;
  adc_TermCursorType = ctBlock;
  adc_TermFontName = 'Terminal';
  adc_TermForeColor = adc_TermBufForeColor;
  adc_TermHalfDuplex = false;
  adc_TermHeight = 200;
  adc_TermLazyByteDelay = 200;
  adc_TermLazyTimeDelay = 100;
  adc_TermRowCount = adc_TermBufRowCount;
  adc_TermScrollback = false;
  adc_TermScrollRowCount = adc_TermBufScrollRowCount;
  adc_TermUseLazyDisplay = true;
  adc_TermWantAllKeys = true;
  adc_TermWidth = 300;
  adc_FreezeScrollback = true;
  adc_TermMouseSelect = True;                                            {!!.03}
  adc_TermAutoCopy = True;                                               {!!.03}
  adc_TermAutoScrollback = True;                                         {!!.03}
  adc_TermHideScrollbars = False;                                        {!!.03}
  adc_TermFollowsCursor = True;                                          {!!.03}
  adc_TermPasteToPort = False;                                           {!!.04}
  adc_TermPasteToScreen = False;                                         {!!.04}

  {default property values for the VT100 emulator--'power-up' values}
  adc_VT100ANSIMode = true;
  adc_VT100Answerback = 'APROterm';
  adc_VT100AppKeyMode = false;
  adc_VT100AppKeypadMode = false;
  adc_VT100AutoRepeat = true;
  adc_VT100Col132Mode = false;
  adc_VT100G0CharSet = 0;
  adc_VT100G1CharSet = 0;
  adc_VT100GPOMode = false;
  adc_VT100InsertMode = adc_TermBufUseInsertMode;
  adc_VT100Interlace = false;
  adc_VT100NewLineMode = adc_TermBufUseNewLineMode;
  adc_VT100RelOriginMode = not adc_TermBufUseAbsAddress;
  adc_VT100RevScreenMode = false;
  adc_VT100SmoothScrollMode = false;
  adc_VT100WrapAround = adc_TermBufUseAutoWrap;

type                          

  TAdEmuCommandList = class;                                           {!!.04}

  TAdOnProcessChar = procedure (    Sender      : TObject;             {!!.04}
                                    Character   : AnsiChar;                {!!.04}
                                var ReplaceWith : Ansistring;              {!!.04}
                                    Commands    : TAdEmuCommandList;   {!!.04}
                                    CharSource  : TAdCharSource) of object; {!!.04}

  TAdEmuCommandParams = class;                                         {!!.04}

  TAdEmuCommandParamsItem = class (TCollectionItem)                    {!!.04}
    private                                                            {!!.04}
      FCollection : TAdEmuCommandParams;                               {!!.04}
      FName       : string;                                            {!!.04}
      FValue      : string;                                            {!!.04}

    protected                                                          {!!.04}

    public                                                             {!!.04}
      constructor Create (Collection : TCollection); override;         {!!.04}
      destructor  Destroy; override;                                   {!!.04}

    published                                                          {!!.04}
      property Collection : TAdEmuCommandParams                        {!!.04}
               read FCollection write FCollection;                     {!!.04}
      property Name : string read FName write FName;                   {!!.04}
      property Value : string read FValue write FValue;                {!!.04}
  end;                                                                 {!!.04}

  TAdEmuCommandParams = class (TCollection)                            {!!.04}
    private                                                            {!!.04}
      FOwner : TPersistent;                                            {!!.04}

    protected                                                          {!!.04}
      function  GetItem (Index : Integer) : TAdEmuCommandParamsItem;   {!!.04}
      function  GetOwner : TPersistent; override;                      {!!.04}
      procedure SetItem (Index : Integer; Value : TAdEmuCommandParamsItem); {!!.04}

    public                                                             {!!.04}
      constructor Create (AOwner : TPersistent);                       {!!.04}

      function FindName (AName : string) : Integer;                    {!!.04}
      function GetBooleanValue (AName : string; APosition : Integer;   {!!.04}
                                ADefault : Boolean) : Boolean;         {!!.04}
      function GetIntegerValue (AName : string; APosition : Integer;   {!!.04}
                                ADefault : Integer) : Integer;         {!!.04}
      function GetStringValue (AName : string; APosition : Integer;    {!!.04}
                               ADefault : string) : string;            {!!.04}
      function GetTColorValue (AName : string; APosition : Integer;    {!!.04}
                               ADefault : TColor) : TColor;            {!!.04}

      property Items[Index : Integer] : TAdEmuCommandParamsItem        {!!.04}
               read GetItem write SetItem;                             {!!.04}
  end;                                                                 {!!.04}

  TAdEmuCommandListItem = class (TCollectionItem)                      {!!.04}
    private                                                            {!!.04}
      FCollection : TAdEmuCommandList;                                 {!!.04}
      FCommand    : TAdEmuCommand;                                     {!!.04}
      FParams     : TAdEmuCommandParams;                               {!!.04}

    protected                                                          {!!.04}

    public                                                             {!!.04}
      constructor Create (Collection : TCollection); override;         {!!.04}
      destructor  Destroy; override;                                   {!!.04}

      procedure AddBooleanArg (v : Boolean);                           {!!.04}
      procedure AddIntegerArg (v : Integer);                           {!!.04}
      procedure AddNamedBooleanArg (AName : string; v : Boolean);      {!!.04}
      procedure AddNamedIntegerArg (AName : string; v : Integer);      {!!.04}
      procedure AddNamedStringArg (AName : string; v : string);        {!!.04}
      procedure AddNamedTColorArg (AName : string; v : TColor);        {!!.04}
      procedure AddStringArg (v : string);                             {!!.04}
      procedure AddTColorArg (v : TColor);                             {!!.04}

    published                                                          {!!.04}
      property Collection : TAdEmuCommandList                          {!!.04}
               read FCollection write FCollection;                     {!!.04}
      property Command : TAdEmuCommand read FCommand write FCommand;   {!!.04}
      property Params : TAdEmuCommandParams read FParams write FParams;{!!.04}
  end;                                                                 {!!.04}

  TAdEmuCommandList = class (TCollection)                              {!!.04}
    private                                                            {!!.04}
      FOwner : TPersistent;                                            {!!.04}

    protected                                                          {!!.04}
      function  GetItem (Index : Integer) : TAdEmuCommandListItem;     {!!.04}
      function  GetOwner : TPersistent; override;                      {!!.04}
      procedure SetItem (Index : Integer; Value : TAdEmuCommandListItem); {!!.04}

    public                                                             {!!.04}
      constructor Create (AOwner : TPersistent);                       {!!.04}
      function AddCommand (ACommand : TAdEmuCommand) : TAdEmuCommandListItem; {!!.04}
      property Items[Index : Integer] : TAdEmuCommandListItem          {!!.04}
               read GetItem write SetItem;                             {!!.04}
  end;                                                                 {!!.04}

  TAdTerminalEmulator = class;

  TAdCustomTerminal = class(TApdBaseWinControl)
    private
      FActive         : boolean;
      FBlinkTime      : integer;
      FBlinkTimeCount : integer;
      FBlinkTextVisible : boolean;
      FBorderStyle    : TBorderStyle;
      FByteQueue      : pointer;
      FCapture        : TAdCaptureMode;
      FCaptureFile    : string;
      FCaptureStream  : TFileStream;
      FCanvas         : TCanvas;
      FCharHeight     : integer; {height of char cell in pixels}
      FCharWidth      : integer; {width of char cell in pixels}
      FClientCols     : integer; {client width in columns, incl part}
      FClientFullCols : integer; {client width in *full* columns}
      FClientRows     : integer; {client height in rows, incl part}
      FClientFullRows : integer; {client height in *full* rows}
      FComPort        : TapdCustomComPort;
      FCreatedCaret   : boolean;
      FCursorType     : TAdCursorType;
      FDefEmulator    : TAdTerminalEmulator; {default = tty}
      FEmulator       : TAdTerminalEmulator;
      FHalfDuplex     : boolean;
      FHaveSelection  : boolean;
      FHeartbeat      : TTimer;
      FLazyByteCount  : integer;
      FLazyTimeCount  : integer;
      FLazyByteDelay  : integer;
      FLazyTimeDelay  : integer;
      FLButtonAnchor  : TPoint;
      FLButtonDown    : boolean;
      FLButtonRect    : TRect;
      FOnCursorMoved  : TAdTerminalCursorMovedEvent;
      FOriginCol      : integer;
      FOriginRow      : integer;
      FScrollback     : boolean;
      FFreezeScrollBack : boolean;                                     
      FScrollHorzInfo : TScrollInfo;
      FScrollVertInfo : TScrollInfo;
      FShowingCaret   : boolean;
      FTriggerHandlerOn : boolean;
      FUsedRect       : TRect;
      FUseLazyDisplay : boolean;
      FUnusedRightRect    : TRect;
      FUnusedBottomRect   : TRect;
      FUseHScrollBar  : boolean;
      FUseVScrollBar  : boolean;
      FWantAllKeys    : boolean;
      FWaitingForComPortOpen : boolean;
      FWaitingForPort        : Boolean;                                  {!!.03}
      FMouseSelect           : Boolean;                                  {!!.03}
      FAutoCopy              : Boolean;                                  {!!.03}
      FAutoScrollback        : Boolean;                                  {!!.03}
      FHideScrollbars        : Boolean;                                  {!!.03}
      FHideScrollbarHActive  : Boolean;                                  {!!.03}
      FHideScrollBarVActive  : Boolean;                                  {!!.03}
      FFollowCursor          : Boolean;                                  {!!.03}
      FPasteToPort           : Boolean;                                  {!!.04}
      FPasteToScreen         : Boolean;                                  {!!.04}
      FCharHPadding          : Integer;                                  {!!.06}
      FCharVPadding          : Integer;                                  {!!.06}

    protected
      procedure Loaded; override;                                        {!!.03}
      procedure tmFollowCursor;                                          {!!.03}
      {get and set methods for properties}
      function tmGetAttributes(aRow, aCol : integer) : TAdTerminalCharAttrs;
      function tmGetBackColor(aRow, aCol : integer) : TColor;
      function tmGetCharSet(aRow, aCol : integer) : byte;
      function tmGetColumns : integer;
      function tmGetEmulator : TAdTerminalEmulator;
      function tmGetForeColor(aRow, aCol : integer) : TColor;
      function tmGetLine(aRow : integer) : AnsiString;
      function tmGetRows : integer;
      function tmGetScrollbackRows : integer;

      procedure tmSetActive(aValue : boolean);
      procedure tmSetAttributes(aRow, aCol : integer;
                        const aAttr      : TAdTerminalCharAttrs);
      procedure tmSetAutoCopy (const v : Boolean);                       {!!.03}
      procedure tmSetAutoScrollback (const v : Boolean);                 {!!.03}
      procedure tmSetBackColor(aRow, aCol : integer; aValue : TColor);
      procedure tmSetBlinkTime(aValue : integer);
      procedure tmSetBorderStyle(aBS : TBorderStyle);
      procedure tmSetCapture(aValue : TAdCaptureMode);
      procedure tmSetCaptureFile(const aValue : string);
      procedure tmSetCharHPadding (const v : Integer);                   {!!.06}
      procedure tmSetCharSet(aRow, aCol : integer; aValue : byte);
      procedure tmSetCharVPadding (const v : Integer);                   {!!.06}
      procedure tmSetComPort(aValue : TapdCustomComPort);
      procedure tmSetColumns(aValue : integer);
      procedure tmSetCursorType(aValue : TAdCursorType);
      procedure tmSetFollowCursor (const v : Boolean);                   {!!.03}
      procedure tmSetForeColor(aRow, aCol : integer; aValue : TColor);
      procedure tmSetEmulator(aValue : TAdTerminalEmulator);
      procedure tmSetHideScrollbars (const v : Boolean);                 {!!.03}
      procedure tmSetLazyByteDelay(aValue : integer);
      procedure tmSetLazyTimeDelay(aValue : integer);
      procedure tmSetLine(aRow : integer; const aValue : Ansistring);
      procedure tmSetMouseSelect (const v : Boolean);                    {!!.03}
      procedure tmSetOriginCol(aValue : integer);
      procedure tmSetOriginRow(aValue : integer);
      procedure tmSetPasteToPort (const v : Boolean);                    {!!.04}
      procedure tmSetPasteToScreen (const v : Boolean);                  {!!.04}
      procedure tmSetRows(aValue : integer);
      procedure tmSetScrollback(aValue : boolean);
      procedure tmSetScrollbackRows(aValue : integer);
      procedure tmSetUseLazyDisplay(aValue : boolean);
      procedure tmSetWantAllKeys(aValue : boolean);
      procedure tmSetFreezeScrollBack (v : boolean);                   

      {various miscellaneous methods}
      procedure tmDrawDefaultText;
      procedure tmAttachToComPort;
      procedure tmCalcExtent;
      procedure tmDetachFromComPort;
      procedure tmGetFontInfo;
      procedure tmInvalidateRow(aRow : integer);

      {caret methods}
      procedure tmFreeCaret;
      procedure tmHideCaret;
      procedure tmMakeCaret;
      procedure tmPositionCaret;
      procedure tmShowCaret;

      {scrollbar stuff}
      procedure tmInitHScrollBar;
      procedure tmInitVScrollBar;
      function  tmNeedHScrollbar : Boolean;                              {!!.03}
      function  tmNeedVScrollbar : Boolean;                              {!!.03}
      procedure tmRemoveHScrollBar;                                      {!!.03}
      procedure tmRemoveVScrollBar;                                      {!!.03}
      procedure tmScrollHorz(aDist : integer);
      procedure tmScrollVert(aDist : integer);

      {selection stuff}
      procedure tmGrowSelect(X, Y : integer);
      procedure tmMarkDeselected(aRow : integer;
                                 aFromCol, aToCol : integer);
      procedure tmMarkSelected(aRow : integer;
                               aFromCol, aToCol : integer);
      function tmProcessClipboardCopy(var Msg : TWMKeyDown) : boolean;
      procedure tmStartSelect(X, Y : integer);

      {overridden ancestor methods}
      procedure KeyDown(var Key : word; Shift: TShiftState); override;
      procedure KeyPress(var Key: Char); override;
      procedure MouseDown(Button : TMouseButton; Shift : TShiftState;
                          X, Y : integer); override;
      procedure MouseMove(Shift : TShiftState; X, Y : integer); override;
      procedure MouseUp(Button : TMouseButton; Shift : TShiftState;
                        X, Y : integer); override;
      procedure PaintWindow(DC : HDC); override;
      procedure Notification(AComponent : TComponent;
                             Operation  : TOperation); override;

      {message and event handlers}
      procedure ApwPortOpen(var Msg : TMessage); message APW_PORTOPEN;
      procedure ApwPortClose(var Msg : TMessage); message APW_PORTCLOSE;
      procedure ApwPortClosing(var Msg : TMessage); message APW_CLOSEPENDING;   {!!.03}
      procedure ApwTermForceSize(var Msg : TMessage); message APW_TERMFORCESIZE;
      procedure ApwTermNeedsUpdate (var Msg : TMessage);                 {!!.05}
                message apw_TermNeedsUpdate;                             {!!.05}
      procedure ApwTermStuff(var Msg : TMessage); message APW_TERMSTUFF;
      procedure AwpWaitForPort (var Msg : TMessage); message apw_TermWaitForPort;{!!.03}
      procedure CMCtl3DChanged(var Msg : TMessage); message CM_CTL3DCHANGED;
      procedure CMFontChanged(var Msg : TMessage); message CM_FONTCHANGED;
      procedure CNKeyDown(var Msg : TWMKeyDown); message CN_KEYDOWN;
      procedure CNSysKeyDown(var Msg : TWMKeyDown); message CN_SYSKEYDOWN;
      procedure tmBeat(Sender: TObject);
      procedure tmTriggerHandler(Msg, wParam : Cardinal; lParam : Integer);
      procedure WMCancelMode(var Msg : TMessage); message WM_CANCELMODE;
      procedure WMCopy(var Msg : TMessage); message WM_COPY;
      procedure WMEraseBkgnd(var Msg : TMessage); message WM_ERASEBKGND;
      procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
      procedure WMHScroll(var Msg : TWMScroll); message WM_HSCROLL;
      procedure WMKillFocus(var Msg: TWMSetFocus); message WM_KILLFOCUS;
      procedure WMPaint(var Msg : TWMPaint); message WM_PAINT;
      procedure WMPaste (var Msg : TWMPaste); message WM_PASTE;          {!!.04}
      procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
      procedure WMSize(var Msg : TWMSize); message WM_SIZE;
      procedure WMVScroll(var Msg : TWMScroll); message WM_VSCROLL;

      {TCustomControl emulation}
      procedure Paint;

    public
      constructor Create(aOwner : TComponent); override;
      destructor Destroy; override;

      {overridden ancestor methods}
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure DestroyWnd; override;

      {terminal methods}
      procedure Clear;
      procedure ClearAll;
      procedure CopyToClipboard;
      function GetTotalCharWidth : Integer;                              {!!.06}
      function GetTotalCharHeight : Integer;                             {!!.06}
      procedure HideSelection;
      procedure WriteChar(aCh : AnsiChar);
      procedure WriteString(const aSt : string); overload;
      procedure WriteString(const aSt : AnsiString); overload;
      procedure WriteCharSource(aCh : AnsiChar; Source:TAdCharSource);      // SWB
      procedure WriteStringSource(const aSt : AnsiString; Source:TAdCharSource);// SWB
      function HasFocus : Boolean;
      procedure PasteFromClipboard;                                      {!!.04}

      {public properties}
      property Attributes [aRow, aCol : integer] : TAdTerminalCharAttrs
                  read tmGetAttributes write tmSetAttributes;
      property BackColor [aRow, aCol : integer] : TColor
                  read tmGetBackColor write tmSetBackColor;
      property Color;                                                
      property Canvas : TCanvas
                  read FCanvas;
      property CharHeight : integer
                  read FCharHeight;
      property CharHPadding : Integer                                    {!!.06}
               read FCharHPadding write tmSetCharHPadding default 0;     {!!.06}
      property CharSet [aRow, aCol : integer] : byte
                  read tmGetCharSet write tmSetCharSet;
      property CharVPadding : Integer                                    {!!.06}
               read FCharVPadding write tmSetCharVPadding default 0;     {!!.06}
      property CharWidth : integer
                  read FCharWidth;
      property ClientCols : integer
                  read FClientCols;
      property ClientRows : integer
                  read FClientRows;
      property ClientOriginCol : integer
                  read FOriginCol write tmSetOriginCol;
      property ClientOriginRow : integer
                  read FOriginRow write tmSetOriginRow;
      property ForeColor [aRow, aCol : integer] : TColor
                  read tmGetForeColor write tmSetForeColor;
      property HaveSelection : boolean                         
                  read FHaveSelection;                         
      property Line [aRow : integer] : Ansistring
                  read tmGetLine write tmSetLine;

      property Emulator : TAdTerminalEmulator
                  read tmGetEmulator write tmSetEmulator;

   {published}                                                         
      property Active : boolean
                  read FActive write tmSetActive
                  default adc_TermActive;
      property AutoCopy : Boolean                                        {!!.03}
               read FAutoCopy write tmSetAutoCopy                        {!!.03}
               default adc_TermAutoCopy;                                 {!!.03}
      property AutoScrollback : Boolean                                  {!!.03}
               read FAutoScrollback write tmSetAutoScrollback            {!!.03}
               default adc_TermAutoScrollback;                           {!!.03}
      property BlinkTime : integer
                  read FBlinkTime write tmSetBlinkTime
                  default adc_TermBlinkTime;
      property BorderStyle : TBorderStyle
                  read FBorderStyle write tmSetBorderStyle
                  default adc_TermBorderStyle;
      property Capture : TAdCaptureMode
                  read FCapture write tmSetCapture
                  default adc_TermCapture;
      property CaptureFile : string
                  read FCaptureFile write tmSetCaptureFile;
      property Columns : integer
                  read tmGetColumns write tmSetColumns
                  default adc_TermColumnCount;
      property ComPort : TapdCustomComPort
                  read FComPort write tmSetComPort;
      property CursorType : TAdCursorType
                  read FCursorType write tmSetCursorType
                  default adc_TermCursorType;
      property FollowCursor : Boolean                                    {!!.03}
               read FFollowCursor write tmSetFollowCursor                {!!.03}
               default adc_TermFollowsCursor;                            {!!.03}
      property HalfDuplex : boolean
                  read FHalfDuplex write FHalfDuplex
                  default adc_TermHalfDuplex;
      property HideScrollbars : Boolean                                  {!!.03}
               read FHideScrollbars write tmSetHideScrollbars            {!!.03}
               default adc_TermHideScrollbars;                           {!!.03}
      property LazyByteDelay : integer
                  read FLazyByteDelay write tmSetLazyByteDelay
                  default adc_TermLazyByteDelay;
      property LazyTimeDelay : integer
                  read FLazyTimeDelay write tmSetLazyTimeDelay
                  default adc_TermLazyTimeDelay;
      property MouseSelect : Boolean                                     {!!.03}
               read FMouseSelect write tmSetMouseSelect                  {!!.03}
               default adc_TermMouseSelect;                              {!!.03}
      property PasteToPort : Boolean                                     {!!.04}
               read FPasteToPort write tmSetPasteToPort                  {!!.04}
               default adc_TermPasteToPort;                              {!!.04}
      property PasteToScreen : Boolean                                   {!!.04}
               read FPasteToScreen write tmSetPasteToScreen              {!!.04}
               default adc_TermPasteToScreen;                            {!!.04}
      property Rows : integer
                  read tmGetRows write tmSetRows
                  default adc_TermRowCount;
      property ScrollbackRows : integer
                  read tmGetScrollbackRows write tmSetScrollbackRows
                  default adc_TermScrollRowCount;
      property Scrollback : boolean
                  read FScrollback write tmSetScrollback;
      property UseLazyDisplay : boolean
                  read FUseLazyDisplay write tmSetUseLazyDisplay
                  default adc_TermUseLazyDisplay;
      property UsingHScrollBar : Boolean                                 {!!.06}
               read FUseHScrollbar;                                      {!!.06}
      property UsingVScrollBar : Boolean                                 {!!.06}
               read FUseVScrollbar;                                      {!!.06}
      property WantAllKeys : boolean
                  read FWantAllKeys write tmSetWantAllKeys
                  default adc_TermWantAllKeys;
      property FreezeScrollBack : boolean
                  read FFreezeScrollBack write tmSetFreezeScrollBack
                  default adc_FreezeScrollBack;

      property OnCursorMoved : TAdTerminalCursorMovedEvent
                  read FOnCursorMoved write FOnCursorMoved;

      {publish ancestor's properties}
      { section moved to TAdTerminal declaration }                     
  end;

  TAdTerminalEmulator = class(TApdBaseComponent)
    private
      FAnswerback      : string;                                         {!!.06}
      FTerminalBuffer  : TAdTerminalBuffer;
      FCharSetMapping  : TAdCharSetMapping;
      FIsDefault       : boolean;
      FKeyboardMapping : TAdKeyboardMapping;
      FParser          : TAdTerminalParser;
      FTerminal        : TAdCustomTerminal;

      {saved cursor details}
      FSavedAttrs : TAdTerminalCharAttrs;
      FSavedBackColor : TColor;
      FSavedCharSet : byte;
      FSavedCol : integer;
      FSavedForeColor : TColor;
      FSavedRow : integer;
      FOnProcessChar : TAdOnProcessChar;                               {!!.04}
      FCommandList : TAdEmuCommandList;                                {!!.04}

    protected
      { Answerback Property Maintenance }                                {!!.06}
      procedure DefineProperties (Filer : TFiler); override;             {!!.06}
      function IsAnswerbackStored: Boolean;                              {!!.06}
      procedure ReadAnswerback (Reader : TReader);                       {!!.06}
      procedure WriteAnswerback (Writer : TWriter);                      {!!.06}
      {property access methods}
      function teGetNeedsUpdate : boolean; virtual;
      procedure teSetTerminal(aValue : TAdCustomTerminal); virtual;

      {overridden ancestor methods}
      procedure Notification(AComponent : TComponent;
                             Operation  : TOperation); override;

      {new virtual methods}
      procedure teClear; virtual;
      procedure teClearAll; virtual;
      procedure teSendChar (aCh : Ansichar; aCanEcho : boolean;            {!!.04}
                            CharSource : TAdCharSource   ); virtual;   {!!.04}

      {Cursor Movement Methods}
      procedure teHandleCursorMovement (Sender : TObject;
                                        Row    : Integer;
                                        Col    : Integer);

      { Command methods }
      procedure teClearCommandList;                                    {!!.04}
      procedure teProcessCommand (Command : TAdEmuCommand;             {!!.04}
                                  Params  : TAdEmuCommandParams);      {!!.04}
      procedure teProcessCommandList (CommandList : TAdEmuCommandList);{!!.04}

      property TerminalBuffer : TAdTerminalBuffer                      {!!.04}
               read FTerminalBuffer write FTerminalBuffer;             {!!.04}

    public
      constructor Create(aOwner : TComponent); override;
      destructor Destroy; override;

      procedure BlinkPaint(aVisible : boolean); virtual;
      procedure ExecuteTerminalCommands (CommandList : TAdEmuCommandList);{!!.04}
      function HasBlinkingText : boolean; virtual;
      procedure KeyDown(var Key : word; Shift: TShiftState); virtual;
      procedure KeyPress(var Key : Char); virtual;
      procedure LazyPaint; virtual;
      procedure Paint; virtual;
      procedure ProcessBlock(aData : pointer; aDataLen : Integer;      {!!.04}
                             CharSource : TAdCharSource); virtual;     {!!.04}
      procedure GetCursorPos(var aRow, aCol : Integer); virtual;

      property Answerback : string                                       {!!.06}
                  read FAnswerback write FAnswerback;                    {!!.06}
      {read-only properties for low-level objects}
      property Buffer : TAdTerminalBuffer
                  read FTerminalBuffer;
      property CharSetMapping : TAdCharSetMapping
                  read FCharSetMapping;
      property KeyboardMapping : TAdKeyboardMapping
                  read FKeyboardMapping;
      property Parser : TAdTerminalParser
                  read FParser;

      property NeedsUpdate : boolean
                  read teGetNeedsUpdate;

      property OnProcessChar : TAdOnProcessChar                        {!!.04}
               read FOnProcessChar write FOnProcessChar;               {!!.04}
    published
      property Terminal : TAdCustomTerminal
         read FTerminal write teSetTerminal;

  end;

  TAdTerminal = class(TAdCustomTerminal)
    published
      { these properties moved here from TAdCustomTerminal declaration}
      property Active;
      property AutoCopy;                                                 {!!.03}
      property AutoScrollback;                                           {!!.03}
      property BlinkTime;
      property BorderStyle;
      property Capture;
      property CaptureFile;
      property Columns;
      property ComPort;
      property CursorType;
      property FollowCursor;                                             {!!.03}
      property HalfDuplex;
      property HideScrollbars;                                           {!!.03}
      property LazyByteDelay;
      property LazyTimeDelay;
      property MouseSelect;                                              {!!.03}
      property PasteToPort;                                              {!!.04}
      property PasteToScreen;                                            {!!.04}
      property Rows;
      property ScrollbackRows;
      property Scrollback;
      property UseLazyDisplay;
      property WantAllKeys;
      property FreezeScrollBack;                                       

      property OnCursorMoved;

      {publish ancestor's properties}
      property Align;
      property Color;
      property Ctl3D;
      property Emulator;                                                      
      property Enabled;
      property Font;
      property Height;
      property ParentColor;
      property ParentCtl3D;
      property ParentFont;
      property TabOrder;
      property TabStop;
      property Visible;
      property Width;
      property PopupMenu;                                              

      {publish ancestor's events}
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

type
  TAdTTYEmulator = class(TAdTerminalEmulator)
    private
      FCellWidths    : PAdIntegerArray;
      FDisplayStr    : PAnsiChar;
      FDisplayStrSize: integer;
      FPaintFreeList : pointer;
      FRefresh       : Boolean;

    protected
      {property accessor methods}
      function teGetNeedsUpdate : boolean; override;

      {overridden ancestor methods}
      procedure teClear; override;
      procedure teClearAll; override;
      procedure teSetTerminal(aValue : TAdCustomTerminal); override;

      {miscellaneous}
      function  ttyCharToCommand (aCh : AnsiChar) : TAdEmuCommand;     {!!.04}
      procedure ttyDrawChars(aRow, aStartCol, aEndCol : integer;
                             aVisible : boolean);

      {paint node methods}
      procedure ttyExecutePaintScript(aRow    : integer;
                                      aScript : pointer);
      procedure ttyFreeAllPaintNodes;
      procedure ttyFreePaintNode(aNode : pointer);
      function ttyNewPaintNode : pointer;

    public
      constructor Create(aOwner : TComponent); override;
      destructor Destroy; override;

      {overridden ancestor methods}
      procedure KeyPress(var Key : Char); override;
      procedure LazyPaint; override;
      procedure Paint; override;
      procedure ProcessBlock (aData : pointer; aDataLen : Integer;     {!!.04}
                              CharSource : TAdCharSource); override;   {!!.04}
    published
      property OnProcessChar;                                          {!!.04}
  end;

type
  TAdVT100Emulator = class(TAdTerminalEmulator)
    private
      {FAnswerback     : string;}                                        {!!.06}
      FBlinkers       : pointer;
      FBlinkFreeList  : pointer;
      FCellWidths     : PAdIntegerArray;
      FDisplayStr     : PAnsiChar;
      FDisplayStrSize : integer;
      FDispUpperASCII : boolean;
      FLEDs           : integer;
      FLineAttrArray  : TObject;
      FPaintFreeList  : pointer;
      FRefresh        : boolean;
      FSecondaryFont  : TFont;

      {modes}
      FANSIMode         : boolean;
      FAppKeyMode       : boolean;
      FAppKeypadMode    : boolean;
      FAutoRepeat       : boolean;
      FCol132Mode       : boolean;
      FGPOMode          : boolean;{graphics proc.option not supported}
      FInsertMode       : boolean;
      FInterlace        : boolean;{interlace chgs are not supported}
      FNewLineMode      : boolean;
      FRelOriginMode    : boolean;
      FRevScreenMode    : boolean;
      FSmoothScrollMode : boolean;{smooth scrolling is not supported}
      FWrapAround       : boolean;

      {character sets}
      FUsingG1   : boolean;                                   
      FG0CharSet : integer;
      FG1CharSet : integer;

    protected
      { Answerback Property Maintenance }                                {!!.06}
      {procedure DefineProperties (Filer : TFiler); override;          } {!!.06}
      {function IsAnswerbackStored: Boolean;                           } {!!.06}
      {procedure ReadAnswerback (Reader : TReader);                    } {!!.06}
      {procedure WriteAnswerback (Writer : TWriter);                   } {!!.06}
      {property accessor methods}
      function teGetNeedsUpdate : boolean; override;
      procedure vttSetCol132Mode(aValue : boolean);
      procedure vttSetRelOriginMode(aValue : boolean);
      procedure vttSetRevScreenMode(aValue : boolean);

      {overridden ancestor methods}
      procedure teClear; override;
      procedure teClearAll; override;
      procedure teSetTerminal(aValue : TAdCustomTerminal); override;

      {miscellaneous}
      procedure vttDrawChars(aRow, aStartVal, aEndVal : integer;
                             aVisible : boolean;
                             aCharValues : boolean);
      procedure vttProcessCommand;
      function vttGenerateDECREPTPARM(aArg : integer) : string;
      procedure vttInvalidateRow(aRow : integer);
      procedure vttProcess8bitChar(aCh : AnsiChar);
      procedure vttScrollRowsHandler(aSender : TObject;
                                     aCount, aTop, aBottom : integer);
      procedure vttToggleNumLock;

      {blink node methods}
      procedure vttCalcBlinkScript;
      procedure vttClearBlinkScript;
      procedure vttDrawBlinkOffCycle(aRow, aStartCh, aEndCh : integer);
      procedure vttFreeAllBlinkNodes;
      procedure vttFreeBlinkNode(aNode : pointer);
      function vttNewBlinkNode : pointer;

      {paint node methods}
      procedure vttExecutePaintScript(aRow    : integer;
                                      aScript : pointer);
      procedure vttFreeAllPaintNodes;
      procedure vttFreePaintNode(aNode : pointer);
      function vttNewPaintNode : pointer;

    public
      constructor Create(aOwner : TComponent); override;
      destructor Destroy; override;

      {overridden ancestor methods}
      procedure BlinkPaint(aVisible : boolean); override;
      function HasBlinkingText : boolean; override;
      procedure KeyDown(var Key : word; Shift: TShiftState); override;
      procedure KeyPress(var Key : Char); override;
      procedure LazyPaint; override;
      procedure Paint; override;
      procedure ProcessBlock (aData : pointer; aDataLen : Integer;     {!!.04}
                              CharSource : TAdCharSource); override;   {!!.04}

      {modes}
      property ANSIMode : boolean
                  read FANSIMode write FANSIMode;
      property AppKeyMode : boolean
                  read FAppKeyMode write FAppKeyMode;
      property AppKeypadMode : boolean
                  read FAppKeypadMode write FAppKeypadMode;
      property AutoRepeat : boolean
                  read FAutoRepeat write FAutoRepeat;
      property Col132Mode : boolean
                  read FCol132Mode write vttSetCol132Mode;
      property GPOMode : boolean
                  read FGPOMode write FGPOMode;
      property InsertMode : boolean
                  read FInsertMode write FInsertMode;
      property Interlace : boolean
                  read FInterlace write FInterlace;
      property NewLineMode : boolean
                  read FNewLineMode write FNewLineMode;
      property RelOriginMode : boolean
                  read FRelOriginMode write vttSetRelOriginMode;
      property RevScreenMode : boolean
                  read FRevScreenMode write vttSetRevScreenMode;
      property SmoothScrollMode : boolean
                  read FSmoothScrollMode write FSmoothScrollMode;
      property WrapAround : boolean
                  read FWrapAround write FWrapAround;

      {miscellaneous}
      property LEDs : integer
                  read FLEDs write FLEDs;

    published
      property Answerback;                                               {!!.06}
      {property Answerback : string                                    } {!!.06}
      {            read FAnswerback write FAnswerback;                 } {!!.06}
      property DisplayUpperASCII : boolean
                  read FDispUpperASCII write FDispUpperASCII;
      property OnProcessChar;                                            {!!.04}
  end;

implementation

uses
  AnsiStrings;

const
  BeatInterval = 100;

type
  PBlinkNode = ^TBlinkNode;
  TBlinkNode = packed record
    bnNext    : PBlinkNode;
    bnRow     : integer;
    bnStartCh : integer;
    bnEndCh   : integer;
  end;

type
  PPaintNode = ^TPaintNode;
  TPaintNode = packed record
    pnNext : PPaintNode;
    pnStart: integer;              {start column of range}
    pnEnd  : integer;              {end column of range}
    pnFore : TColor;               {foreground color for range}
    pnBack : TColor;               {background color for range}
    pnAttr : TAdTerminalCharAttrs; {attributes for range}
    pnCSet : byte;                 {charset for range}
  end;

const
  VT52DeviceAttrs  = #27'/Z';      {"VT100 acting as VT52"}
  VT100DeviceAttrs = #27'[?1;0c';  {"Base VT100, no options"}
  VT100StatusRpt   = #27'[0n';     {"terminal OK"}
  VT100CursorPos   = #27'[%d;%dR'; {"cursor is at row;col"}
  VT100ReportParm  = #27'[%d;%d;%d;%d;%d;%d;%dx';
                                   {report terminal parameters}

const
  VT100CharSetNames : array [0..4] of string =
                      ('VT100-USASCII',           {charset 0}
                       'VT100-UK',                {charset 1}
                       'VT100-linedraw',          {charset 2}
                       'VT100-ROM1',              {charset 3}
                       'VT100-ROM2');             {charset 4}


{===Terminal/Emulator links==========================================}
type
  PTermEmuLink = ^TTermEmuLink;
  TTermEmuLink = record
    telNext : PTermEmuLink;
    telTerm : TAdCustomTerminal;
    telEmu  : TAdTerminalEmulator;
  end;
{--------}
var
  TermEmuLink : PTermEmuLink;
  TermEmuLinkFreeList : PTermEmuLink;
{--------}
procedure AddTermEmuLink(aTerminal : TAdCustomTerminal;
                         aEmulator : TAdTerminalEmulator);
var
  Node : PTermEmuLink;
begin
  {if the link already exists, exit}
  Node := TermEmuLink;
  while (Node <> nil) do begin
    if (Node^.telTerm = aTerminal) then
      Exit;
    Node := Node^.telNext;
  end;
  {otherwise, add it}
  if (TermEmuLinkFreeList = nil) then
    New(Node)
  else begin
    Node := TermEmuLinkFreeList;
    TermEmuLinkFreeList := Node^.telNext;
  end;
  Node^.telTerm := aTerminal;
  Node^.telEmu := aEmulator;
  Node^.telNext := TermEmuLink;
  TermEmuLink := Node;
  {now update each object to point to the other}
  aTerminal.Emulator := aEmulator;
  aEmulator.Terminal := aTerminal;
end;
{--------}
procedure RemoveTermEmuLink(aTerminal : TAdCustomTerminal;
                            aNotify   : boolean);
var
  Dad, Node : PTermEmuLink;
  Emulator  : TAdTerminalEmulator;
begin
  {remove the link}
  Emulator := nil;
  Dad := nil;
  Node := TermEmuLink;
  while (Node <> nil) do begin
    if (Node^.telTerm = aTerminal) then begin
      if (Dad = nil) then
        TermEmuLink := Node^.telNext
      else
        Dad^.telNext := Node^.telNext;
      Emulator := Node^.telEmu;
      Node^.telNext := TermEmuLinkFreeList;
      TermEmuLinkFreeList := Node;
      Break;
    end;
    Dad := Node;
    Node := Node^.telNext;
  end;
  {now update each object to point to nil instead of each other}
  if aNotify and (Emulator <> nil) then begin
    aTerminal.Emulator := nil;
    Emulator.Terminal := nil;
  end;
end;
{====================================================================}


// TAdEmuCommandParamsItem **************************************************** {!!.04}

constructor TAdEmuCommandParamsItem.Create (Collection : TCollection); {!!.04}
begin                                                                  {!!.04}
  inherited Create (Collection);                                       {!!.04}
  FCollection := TAdEmuCommandParams.Create (TAdEmuCommandParams (Collection).FOwner); {!!.04}

  FName  := '';                                                        {!!.04}
  FValue := '';                                                        {!!.04}
end;                                                                   {!!.04}

destructor TAdEmuCommandParamsItem.Destroy;                            {!!.04}
begin                                                                  {!!.04}
  FCollection.Free;                                                    {!!.04}
  FCollection := nil;                                                  {!!.04}
  inherited Destroy;                                                   {!!.04}
end;                                                                   {!!.04}

// TAdEmuCommandParams ******************************************************** {!!.04}

constructor TAdEmuCommandParams.Create(AOwner : TPersistent);          {!!.04}
begin                                                                  {!!.04}
  inherited Create (TAdEmuCommandParamsItem);                          {!!.04}
  FOwner := AOwner;                                                    {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

function TAdEmuCommandParams.FindName (AName : string) : Integer;      {!!.04}
var                                                                    {!!.04}
  i : Integer;                                                         {!!.04}

begin                                                                  {!!.04}
  Result := -1;                                                        {!!.04}
  if AName = '' then                                                   {!!.04}
    Exit;                                                              {!!.04}                                                                     
  for i := 0 to Count - 1 do                                           {!!.04}
    if TAdEmuCommandParamsItem (Items[i]).Name = AName then begin      {!!.04}
      Result := i;                                                     {!!.04}
      Exit;                                                            {!!.04}
    end;                                                               {!!.04}
end;                                                                   {!!.04}

function TAdEmuCommandParams.GetItem (Index : Integer) : TAdEmuCommandParamsItem; {!!.04}
begin                                                                  {!!.04}
  Result := TAdEmuCommandParamsItem (inherited GetItem (Index));       {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

function TAdEmuCommandParams.GetBooleanValue (AName     : string;      {!!.04}
                                              APosition : Integer;     {!!.04}
                                              ADefault  : Boolean) : Boolean; {!!.04}
var                                                                    {!!.04}
  RealPosition : Integer;                                              {!!.04}
  Value        : string;                                               {!!.04}

begin                                                                  {!!.04}
  Result := ADefault;                                                  {!!.04}
  RealPosition := FindName (AName);                                    {!!.04}
  if RealPosition < 0 then                                             {!!.04}
    RealPosition := APosition;                                         {!!.04}
  if (RealPosition >= 0) and (RealPosition < Count) then begin         {!!.04}
    Value := LowerCase (TAdEmuCommandParamsItem (Items[RealPosition]).Value);  {!!.04}
    if (Value = 't') or (Value = 'true') or (Value = '1') or (Value = 'on') or {!!.04}
       (Value = 'yes') then                                            {!!.04}
      Result := True                                                   {!!.04}
    else if (Value = 'f') or (Value = 'false') or (Value = '0') or     {!!.04}
            (Value = 'off') or (Value = 'no') then                     {!!.04}
      Result := False;                                                 {!!.04}
  end;                                                                 {!!.04}
end;                                                                   {!!.04}

function TAdEmuCommandParams.GetIntegerValue (AName     : string;      {!!.04}
                                              APosition : Integer;     {!!.04}
                                              ADefault  : Integer) : Integer; {!!.04}
var                                                                    {!!.04}
  RealPosition : Integer;                                              {!!.04}

begin                                                                  {!!.04}
  Result := ADefault;                                                  {!!.04}
  RealPosition := FindName (AName);                                    {!!.04}
  if RealPosition < 0 then                                             {!!.04}
    RealPosition := APosition;                                         {!!.04}
  if (RealPosition >= 0) and (RealPosition < Count) then begin         {!!.04}
    try                                                                {!!.04}
      Result := StrToInt (TAdEmuCommandParamsItem (Items[RealPosition]).Value);  {!!.04}
    except                                                             {!!.04}
      on EConvertError do                                              {!!.04}
        Result := ADefault;                                            {!!.04}
    end;                                                               {!!.04}
  end;                                                                 {!!.04}
end;                                                                   {!!.04}

function TAdEmuCommandParams.GetOwner : TPersistent;                   {!!.04}
begin                                                                  {!!.04}
  Result := FOwner;                                                    {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

function TAdEmuCommandParams.GetStringValue (AName     : string;       {!!.04}
                                             APosition : Integer;      {!!.04}
                                             ADefault  : string) : string; {!!.04}
var                                                                    {!!.04}
  RealPosition : Integer;                                              {!!.04}

begin                                                                  {!!.04}
  Result := ADefault;                                                  {!!.04}
  RealPosition := FindName (AName);                                    {!!.04}
  if RealPosition < 0 then                                             {!!.04}
    RealPosition := APosition;                                         {!!.04}
  if (RealPosition >= 0) and (RealPosition < Count) then               {!!.04}
    Result := TAdEmuCommandParamsItem (Items[RealPosition]).Value;     {!!.04}
end;                                                                   {!!.04}

function TAdEmuCommandParams.GetTColorValue (AName     : string;       {!!.04}
                                             APosition : Integer;      {!!.04}
                                             ADefault  : TColor) : TColor; {!!.04}
var                                                                    {!!.04}
  RealPosition : Integer;                                              {!!.04}

begin                                                                  {!!.04}
  Result := ADefault;                                                  {!!.04}
  RealPosition := FindName (AName);                                    {!!.04}
  if RealPosition < 0 then                                             {!!.04}
    RealPosition := APosition;                                         {!!.04}
  if (RealPosition >= 0) and (RealPosition < Count) then begin         {!!.04}
    try                                                                {!!.04}
      Result := StrToInt (TAdEmuCommandParamsItem (Items[RealPosition]).Value);  {!!.04}
    except                                                             {!!.04}
      on EConvertError do                                              {!!.04}
        Result := ADefault;                                            {!!.04}
    end;                                                               {!!.04}
  end;                                                                 {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandParams.SetItem (Index : Integer; Value : TAdEmuCommandParamsItem); {!!.04}
begin                                                                  {!!.04}
  inherited SetItem (Index, Value);                                    {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

// TAdEmuCommandListItem ****************************************************** {!!.04}

constructor TAdEmuCommandListItem.Create (Collection : TCollection);   {!!.04}
begin                                                                  {!!.04}
  inherited Create (Collection);                                       {!!.04}
  FCollection := TAdEmuCommandList.Create (TAdEmuCommandList (Collection).FOwner); {!!.04}

  FParams := TAdEmuCommandParams.Create (Self);                        {!!.04}
  FCommand := ecNone;                                                  {!!.04}
end;                                                                   {!!.04}

destructor TAdEmuCommandListItem.Destroy;                              {!!.04}
begin                                                                  {!!.04}
  FCollection.Free;                                                    {!!.04}
  FCollection := nil;                                                  {!!.04}

  FParams.Free;                                                        {!!.04}

  inherited Destroy;                                                   {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddBooleanArg (v : Boolean);           {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}
                                                                             
begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  if v then                                                            {!!.04}
    NewParam.Value := 'TRUE'                                           {!!.04}
  else                                                                 {!!.04}
    NewParam.Value := 'FALSE';                                         {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddIntegerArg (v : Integer);           {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  NewParam.Value := IntToStr (v);                                      {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddNamedBooleanArg (AName : string;    {!!.04}
                                                    v     : Boolean);  {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  NewParam.Name := AName;                                              {!!.04}
  if v then                                                            {!!.04}
    NewParam.Value := 'TRUE'                                           {!!.04}
  else                                                                 {!!.04}
    NewParam.Value := 'FALSE';                                         {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddNamedIntegerArg (AName : string;    {!!.04}
                                                   v      : Integer);  {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  NewParam.Name := AName;                                              {!!.04}
  NewParam.Value := IntToStr (v);                                      {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddNamedStringArg (AName : string;     {!!.04}
                                                   v     : string);    {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  NewParam.Name := AName;                                              {!!.04}
  NewParam.Value := v;                                                 {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddNamedTColorArg (AName : string;     {!!.04}
                                                   v     : TColor);    {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  NewParam.Name := AName;                                              {!!.04}
  NewParam.Value := IntToStr (v);                                      {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddStringArg (v : string);             {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  NewParam.Value := v;                                                 {!!.04}
end;                                                                   {!!.04}

procedure TAdEmuCommandListItem.AddTColorArg (v : TColor);             {!!.04}
var                                                                    {!!.04}
  NewParam : TAdEmuCommandParamsItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewParam := TAdEmuCommandParamsItem (FParams.Add);                   {!!.04}
  NewParam.Value := IntToStr (v);                                      {!!.04}
end;                                                                   {!!.04}

// TAdEmuCommandList ********************************************************** {!!.04}

constructor TAdEmuCommandList.Create (AOwner : TPersistent);           {!!.04}
begin                                                                  {!!.04}
  inherited Create (TAdEmuCommandListItem);                            {!!.04}
  FOwner := AOwner;                                                    {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

function TAdEmuCommandList.AddCommand (ACommand : TAdEmuCommand) : TAdEmuCommandListItem; {!!.04}
var                                                                    {!!.04}
  NewCommand : TAdEmuCommandListItem;                                  {!!.04}

begin                                                                  {!!.04}
  NewCommand := TAdEmuCommandListItem (Add);                           {!!.04}
  NewCommand.Command := ACommand;                                      {!!.04}
  Result := NewCommand;                                                {!!.04}     
end;                                                                   {!!.04}

function TAdEmuCommandList.GetItem (Index : Integer) : TAdEmuCommandListItem; {!!.04}
begin                                                                  {!!.04}
  Result := TAdEmuCommandListItem (inherited GetItem (Index));         {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

function TAdEmuCommandList.GetOwner : TPersistent;                     {!!.04}
begin                                                                  {!!.04}
  Result := FOwner;                                                    {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

procedure TAdEmuCommandList.SetItem (Index : Integer; Value : TAdEmuCommandListItem); {!!.04}
begin                                                                  {!!.04}
  inherited SetItem (Index, Value);                                    {!!.04}
end;                                                                   {!!.04}
{=====}                                                                {!!.04}

{===Byte queue=======================================================}
{Notes: this byte queue was published in Algorithms Alfresco in The
        Delphi Magazine, December 1988. It is reproduced and used here
        with permission.
        Copyright (c) Julian M Bucknall, 1998. All Rights Reserved.}
type
  TaaByteQueue = class
    private
      bqHead      : PAnsiChar;
      bqTail      : PAnsiChar;
      bqQMidPoint : PAnsiChar;
      bqQueue     : PAnsiChar;
      bqQueueEnd  : PAnsiChar;
    protected
      function getCapacity : integer;
      function getCount : integer;
      procedure setCapacity(aValue : integer);
    public
      constructor Create;
      destructor Destroy; override;

      procedure AdvanceAfterPut(aDataLen : integer);
      procedure Clear;
      (***** not used yet
      procedure Get(var aData; aDataLen : integer);
      function IsEmpty : boolean;
      *****)
      procedure Put(const aData; aDataLen : integer);
      function PutPeek(aDataLen : integer) : pointer;
      function Peek(aDataLen : integer) : pointer;
      procedure Remove(aDataLen : integer);

      property Capacity : integer
         read getCapacity write setCapacity;
      property Count : integer
         read getCount;
  end;
{--------}
procedure NotEnoughDataError(aAvail, aReq : integer);
begin
  raise Exception.Create(
          Format('Not enough data in queue (%d bytes) to satisfy read request (%d bytes)', //SWB
                 [aAvail, aReq]));
end;
{--------}
constructor TaaByteQueue.Create;
begin
  inherited Create;
  Capacity := 64;
end;
{--------}
destructor TaaByteQueue.Destroy;
begin
  if Assigned(bqQueue) then
    FreeMem(bqQueue, bqQueueEnd - bqQueue);
  inherited Destroy;
end;
{--------}
procedure TaaByteQueue.AdvanceAfterPut(aDataLen : integer);
begin
  inc(bqTail, aDataLen);
end;
{--------}
procedure TaaByteQueue.Clear;
begin
  bqHead := bqQueue;
  bqTail := bqQueue;
end;
{--------}
(***** not used yet
procedure TaaByteQueue.Get(var aData; aDataLen : integer);
var
  ByteCount : integer;
begin
  {check for enough data}
  if (aDataLen > Count) then
    NotEnoughDataError(Count, aDataLen);
  {move the data}
  Move(bqHead^, aData, aDataLen);
  inc(bqHead, aDataLen);
  {if we've emptied the queue, move the head/tail pointers back}
  ByteCount := Count;
  if (ByteCount = 0) then begin
    bqHead := bqQueue;
    bqTail := bqQueue;
  end
  {if the head of the queue has moved into the overflow zone, move the
   data back, and reset the head/tail pointers}
  else if (bqHead >= bqQMidPoint) then begin
    Move(bqHead^, bqQueue^, ByteCount);
    bqHead := bqQueue;
    bqTail := bqHead + ByteCount;
  end;
end;
*****)
{--------}
function TaaByteQueue.getCapacity : integer;
begin
  Result := (bqQueueEnd - bqQueue) div 2;
end;
{--------}
function TaaByteQueue.getCount : integer;
begin
  Result := bqTail - bqHead;
end;
{--------}
(***** not used yet
function TaaByteQueue.IsEmpty : boolean;
begin
  Result := bqHead = bqTail;
end;
*****)
{--------}
procedure TaaByteQueue.Put(const aData; aDataLen : integer);
var
  ByteCount : integer;
begin
  {if required, grow the queue by at least doubling its size}
  ByteCount := Count;
  while (ByteCount + aDataLen > Capacity) do
    Capacity := Capacity * 2;
  {we now have enough room, so add the new data}
  Move(aData, bqTail^, aDataLen);
  inc(bqTail, aDataLen);
end;
{--------}
function TaaByteQueue.PutPeek(aDataLen : integer) : pointer;
var
  ByteCount : integer;
begin
  {if required, grow the queue by at least doubling its size}
  ByteCount := Count;
  while (ByteCount + aDataLen > Capacity) do
    Capacity := Capacity * 2;
  {just return the tail pointer}
  Result := bqTail;
end;
{--------}
function TaaByteQueue.Peek(aDataLen : integer) : pointer;
begin
  {check for enough data}
  if (aDataLen > Count) then
    NotEnoughDataError(Count, aDataLen);
  {just return the head pointer}
  Result := bqHead;
end;
{--------}
procedure TaaByteQueue.Remove(aDataLen : integer);
begin
  {check for enough data}
  if (aDataLen > Count) then
    NotEnoughDataError(Count, aDataLen);
  {move the remaining data to the head}
  Move((bqHead+aDataLen)^, bqHead^, Count - aDataLen);
  bqTail := bqTail - aDataLen;
end;
{--------}
procedure TaaByteQueue.setCapacity(aValue : integer);
var
  ByteCount : integer;
  NewQueue  : PAnsiChar;
begin
  {don't allow data to be lost}
  ByteCount := Count;
  if (aValue < ByteCount) then
    aValue := ByteCount;
  {round the requested capacity to nearest 64 bytes}
  aValue := (aValue + 63) and $7FFFFFC0;
  {get a new buffer}
  GetMem(NewQueue, aValue * 2);
  {if we have data to transfer from the old buffer, do so}
  if (ByteCount <> 0) then
    Move(bqHead^, NewQueue^, ByteCount);
  {destroy the old buffer}
  if (bqQueue <> nil) then
    FreeMem(bqQueue, bqQueueEnd - bqQueue);
  {set the head/tail and other pointers}
  bqQueue := NewQueue;
  bqHead := NewQueue;
  bqTail := NewQueue + ByteCount;
  bqQueueEnd := NewQueue + (aValue * 2);
  bqQMidPoint := NewQueue + aValue;
end;
{====================================================================}


{===VT100 line attributes array======================================}
type
  TAdLineAttrArray = class
    private
      FArray          : PAnsiChar;
      FEmulator       : TAdVT100Emulator;
      FTotalLineCount : integer;
    protected
      function laaGetAttr(aInx : integer) : TAdVT100LineAttr;
      procedure laaSetAttr(aInx   : integer;
                           aValue : TAdVT100LineAttr);

      procedure laaResize;
    public
      constructor Create(aEmulator : TAdVT100Emulator);
      destructor Destroy; override;

      procedure Scroll(aCount, aTop, aBottom : integer);

      property Attr [aInx : integer] : TAdVT100LineAttr
                  read laaGetAttr write laaSetAttr;
  end;
{--------}
constructor TAdLineAttrArray.Create(aEmulator : TAdVT100Emulator);
begin
  inherited Create;
  FEmulator := aEmulator;
  FTotalLineCount := aEmulator.Buffer.SVRowCount;
  FArray := AllocMem(FTotalLineCount * sizeof(TAdVT100LineAttr));
end;
{--------}
destructor TAdLineAttrArray.Destroy;
begin
  if (FArray <> nil) then
    FreeMem(FArray, FTotalLineCount * sizeof(TAdVT100LineAttr));
  inherited Destroy;
end;
{--------}
function TAdLineAttrArray.laaGetAttr(aInx : integer) : TAdVT100LineAttr;
begin
  if (FTotalLineCount <> FEmulator.Buffer.SVRowCount) then
    laaResize;
  aInx := aInx + FTotalLineCount - FEmulator.Buffer.RowCount - 1;
  if (aInx < 0) or (aInx >= FTotalLineCount) then
    Result := ltNormal
  else
    Result := TAdVT100LineAttr(FArray[aInx]);
end;
{--------}
procedure TAdLineAttrArray.laaResize;
var
  NewArray      : PAnsiChar;
  NewTotalCount : integer;
begin
  {allocate the new array}
  NewTotalCount := FEmulator.Buffer.SVRowCount;
  NewArray := AllocMem(NewTotalCount * sizeof(TAdVT100LineAttr));
  {copy over the old array from the end, *not* the beginning}
  if (NewTotalCount < FTotalLineCount) then
    Move(FArray[FTotalLineCount - NewTotalCount], NewArray[0],
         NewTotalCount)
  else {FTotalLineCount <= NewTotalCount}
    Move(FArray[0], NewArray[FTotalLineCount - NewTotalCount],
         FTotalLineCount);
  {free the old array, save the new one}
  FreeMem(FArray, FTotalLineCount * sizeof(TAdVT100LineAttr));
  FArray := NewArray;
  FTotalLineCount := NewTotalCount;
end;
{--------}
procedure TAdLineAttrArray.laaSetAttr(aInx   : integer;
                                      aValue : TAdVT100LineAttr);
begin
  if (FTotalLineCount <> FEmulator.Buffer.SVRowCount) then
    laaResize;
  aInx := aInx + FTotalLineCount - FEmulator.Buffer.RowCount - 1;
  if (0 <= aInx) and (aInx < FTotalLineCount) then
    FArray[aInx] := AnsiChar(aValue);
end;
{--------}
procedure TAdLineAttrArray.Scroll(aCount, aTop, aBottom : integer);
var
  i     : integer;
  ToInx : integer;
begin
  aTop := aTop + FTotalLineCount - FEmulator.Buffer.RowCount - 1;
  aBottom := aBottom + FTotalLineCount - FEmulator.Buffer.RowCount - 1;
  if (aCount > 0) then {scroll upwards} begin
    ToInx := aTop;
    for i := (aTop + aCount) to aBottom do begin
      FArray[ToInx] := FArray[i];
      inc(ToInx);
    end;
    for i := ToInx to aBottom do
      FArray[i] := #0;
  end
  else if (aCount < 0) then {scroll downwards} begin
    ToInx := aBottom;
    for i := (aBottom + aCount) downto aTop do begin
      FArray[ToInx] := FArray[i];
      dec(ToInx);
    end;
    for i := ToInx downto aTop do
      FArray[i] := #0;
  end;
end;
{====================================================================}


{===Helper routines==================================================}
function MinI(A, B : integer) : integer;
begin
  if (A < B) then
    Result := A
  else
    Result := B;
end;
{--------}
function MaxI(A, B : integer) : integer;
begin
  if (A > B) then
    Result := A
  else
    Result := B;
end;
{--------}
function BoundI(aLow, X, aHigh : integer) : integer;
begin
  if (aLow < aHigh) then
    if (X <= aLow) then
      Result := aLow
    else if (X >= aHigh) then
      Result := aHigh
    else
      Result := X
  else {aHigh is less than aLow}
    if (X <= aHigh) then
      Result := aHigh
    else if (X >= aLow) then
      Result := aLow
    else
      Result := X;
end;
{--------}
procedure GetOrientedRect(var aRect   : TRect;
                        const aAnchor : TPoint;
                              X, Y    : integer);
begin
  if (X < aAnchor.X) then begin
    aRect.Left := X;
    aRect.Right := aAnchor.X;
  end
  else begin
    aRect.Left := aAnchor.X;
    aRect.Right := X;
  end;
  if (Y < aAnchor.Y) then begin
    aRect.Top := Y;
    aRect.Bottom := aAnchor.Y;
  end
  else begin
    aRect.Top := aAnchor.Y;
    aRect.Bottom := Y;
  end;
end;
{====================================================================}


{===TAdTerminal======================================================}
constructor TAdCustomTerminal.Create(aOwner : TComponent);
begin
  inherited Create(aOwner);

  FWaitingForPort := False;                                              {!!.03}

  {create our canvas}
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  {set up heartbeat timer}
  FHeartbeat := TTimer.Create(Self);
  FHeartbeat.Interval := BeatInterval;
  FHeartbeat.OnTimer := tmBeat;
  FHeartbeat.Enabled := false;

  {create a byte queue to receive data}
  FByteQueue := TaaByteQueue.Create;

  {make sure the origin is at (1,1)}
  FOriginCol := 1;
  FOriginRow := 1;

  {create the default emulator}
  FDefEmulator := TAdTTYEmulator.Create(nil);
  FDefEmulator.FIsDefault := true;
  FDefEmulator.Terminal := Self;
  if (FEmulator =  nil) then begin                                       {!!.05}
    FEmulator := FDefEmulator;
    if (Assigned (FEmulator)) and                                        {!!.05}
       (Assigned (FEmulator.Buffer)) and                                 {!!.05}
       HandleAllocated then                                              {!!.05}
      FEmulator.Buffer.RegisterTerminalHandle (Handle);                  {!!.05}
  end;                                                                   {!!.05}

  {set up the default values of the terminal's properties}
  Active := adc_TermActive; {the set access method must be called}
  FBlinkTime := adc_TermBlinkTime;
  FBorderStyle := adc_TermBorderStyle;
  FCapture := adc_TermCapture;
  FCaptureFile := adc_TermCaptureFile;
  FCursorType := adc_TermCursorType;
  FHalfDuplex := adc_TermHalfDuplex;
  FLazyByteDelay := adc_TermLazyByteDelay;
  FLazyTimeDelay := adc_TermLazyTimeDelay;
  FUseLazyDisplay := adc_TermUseLazyDisplay;
  FWantAllKeys := adc_TermWantAllKeys;
  FFreezeScrollBack := adc_FreezeScrollBack;

  Width := adc_TermWidth;
  Height := adc_TermHeight;
  Font.Name := adc_TermFontName;
  Font.Size := 9;
  Font.Color := adc_TermForeColor;
  Color := adc_TermBackColor;
  FMouseSelect          := adc_TermMouseSelect;                          {!!.03}
  FAutoCopy             := adc_TermAutoCopy;                             {!!.03}
  FAutoScrollback       := adc_TermAutoScrollback;                       {!!.03}
  FHideScrollbars       := adc_TermHideScrollbars;                       {!!.03}
  FHideScrollbarHActive := False;                                        {!!.03}
  FHideScrollBarVActive := False;                                        {!!.03}
  FFollowCursor         := adc_TermFollowsCursor;                        {!!.03}
  FCharHPadding         := 0;                                            {!!.06}
  FCharVPadding         := 0;                                            {!!.06}
  {miscellaneous}
  with FScrollHorzInfo do
    cbSize := sizeof(FScrollHorzInfo);
  with FScrollVertInfo do
    cbSize := sizeof(FScrollVertInfo);
end;
{--------}
destructor TAdCustomTerminal.Destroy;
begin
  Emulator := nil;
  FEmulator := nil;
  FDefEmulator.Free;
  FDefEmulator := nil;
  FCanvas.Free;
  FHeartbeat.Free;
  RemoveTermEmuLink(Self, false);
  TaaByteQueue(FByteQueue).Free;
  inherited Destroy;
end;
{--------}
procedure TAdCustomTerminal.ApwPortOpen(var Msg : TMessage);
begin
  {note: if FWaitingForComPortOpen is true, Active is also true}
  if FWaitingForComPortOpen then
    tmAttachToComPort;
end;
{--------}
procedure TAdCustomTerminal.ApwPortClose(var Msg : TMessage);
begin
  tmDetachFromComPort;
end;
{--------}
procedure TAdCustomTerminal.ApwPortClosing (var Msg : TMessage);         {!!.03}
begin                                                                    {!!.03}
  tmDetachFromComPort;                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.ApwTermForceSize(var Msg : TMessage);
begin
  RecreateWnd;
end;
{--------}
procedure TAdCustomTerminal.ApwTermNeedsUpdate (var Msg : TMessage);     {!!.05}
var                                                                      {!!.05}
  PaintRgn : HRGN;                                                       {!!.05}

begin                                                                    {!!.05}
  if not FUseLazyDisplay then begin                                      {!!.05}
    tmHideCaret;                                                         {!!.05}
    try                                                                  {!!.05}
      PaintRgn := CreateRectRgn (0,                                      {!!.05}
                                 0,                                      {!!.05}
                                 ClientCols * GetTotalCharWidth,         {!!.05} {!!.06}
                                 ClientRows * GetTotalCharHeight);       {!!.05} {!!.06}
      SelectClipRgn (Canvas.Handle, PaintRgn);                           {!!.05}
      DeleteObject (PaintRgn);                                           {!!.05}
      FEmulator.LazyPaint;                                               {!!.05}
    finally                                                              {!!.05}
      tmShowCaret;                                                       {!!.05}
    end;                                                                 {!!.05}
  end;                                                                   {!!.05}
end;                                                                     {!!.05}
{--------}
procedure TAdCustomTerminal.ApwTermStuff(var Msg : TMessage);
var
  DataLen  : integer;
  DataPtr  : pointer;
  PaintRgn : HRGN;
begin
  {this message is sent by the tmTriggerAvail, and the WriteChar/
   WriteString methods; note that if there are two or more
   APW_TERMSTUFF messages in the message queue, the first one to be
   accepted will clear the byte queue, so the others need to take
   account of the fact that there may be no data}

  DataLen := TaaByteQueue(FByteQueue).Count;
  if (DataLen > 0) then begin
    DataPtr := TaaByteQueue(FByteQueue).Peek(DataLen);

    {if we are capturing, save the data to file}
    if (Capture = cmOn) then begin
      if (FCaptureStream <> nil) then
        FCaptureStream.Write(DataPtr^, DataLen);
    end;

    {otherwise get the emulator to process the block}
    FEmulator.ProcessBlock (DataPtr, DataLen,                          {!!.04}
                            TAdCharSource (Msg.WParam));               {!!.04}
    if (not UseLazyDisplay) and FEmulator.NeedsUpdate then begin
      {hide the caret}
      tmHideCaret;
      try
        PaintRgn := CreateRectRgn(0, 0,
                       ClientCols * GetTotalCharWidth,                   {!!.06}
                       ClientRows * GetTotalCharHeight);                 {!!.06}
        SelectClipRgn(Canvas.Handle, PaintRgn);
        DeleteObject(PaintRgn);
        FEmulator.LazyPaint;
      finally
        tmShowCaret;
      end;
    end;

    {increment the byte count for the lazy painting}
    inc(FLazyByteCount, DataLen);

    {now we've processed all the data, clear the byte queue}
    if (DataLen <> TaaByteQueue(FByteQueue).Count) then
      TaaByteQueue(FByteQueue).Remove(DataLen)
    else
      TaaByteQueue(FByteQueue).Clear;
  end;
end;
{--------}
procedure TAdCustomTerminal.AwpWaitForPort (var Msg : TMessage);         {!!.03}
begin                                                                    {!!.03}
  if FWaitingForPort then                                                {!!.03}
    Exit;                                                                {!!.03}
  FWaitingForPort := True;

  if not Assigned (FComPort) then                                        {!!.03}
    Exit;                                                                {!!.03}

  if csLoading in FComport.ComponentState then                           {!!.03}
    PostMessage (Handle, apw_TermWaitForPort, 0, 0)                      {!!.03}

  else begin                                                             {!!.03}
    if (not FTriggerHandlerOn) and                                       {!!.03}
       (ComPort.AutoOpen or ComPort.Open) then begin                     {!!.03}
      FWaitingForComPortOpen := false;                                   {!!.03}
      if not ComPort.Open then                                           {!!.03}
       ComPort.Open := true;                                             {!!.03}
      if FActive then begin                                              {!!.05}
        ComPort.Dispatcher.RegisterEventTriggerHandler(tmTriggerHandler);{!!.03}
        FTriggerHandlerOn := true;                                       {!!.03}
       end;                                                              {!!.05}
      { call loaded again to make sure things are set up correctly }
      Loaded;                                                            {!!.04}

    end else                                                             {!!.03}
      FWaitingForComPortOpen := Active;                                  {!!.04}
  end;                                                                   {!!.03}

  FWaitingForPort := False;                                              {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.Clear;
begin
  FEmulator.teClear;
end;
{--------}
procedure TAdCustomTerminal.ClearAll;
begin
  FEmulator.teClearAll;
end;
{--------}
procedure TAdCustomTerminal.CMCtl3DChanged(var Msg : TMessage);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  inherited;
end;
{--------}
procedure TAdCustomTerminal.CMFontChanged(var Msg : TMessage);
begin
  {make sure our ancestors do their stuff}
  inherited;
  {if we're loading, don't bother doing anything}
  if (csLoading in ComponentState) then
    Exit;
  {if we have no handle, there's nothing we can do}
  if not HandleAllocated then
    Exit;
  {otherwise, work out the character size}
  tmGetFontInfo;
end;
{--------}
procedure TAdCustomTerminal.CNKeyDown(var Msg : TWMKeyDown);
var
  Shift  : TShiftState;
  EnhKey : boolean;
  Key    : word;
  NumLockState : TKeyboardState;
begin
  {if the left button is down (we're selecting) and the key is Escape,
   cancel the mode}
  if FLButtonDown and (Msg.CharCode = VK_ESCAPE) then begin
    Perform(WM_CANCELMODE, 0, 0);
    Msg.Result := 1;
    Exit;
  end;
  {if we have a selection and the key is Ctrl+C or Ctrl+Insert, copy
   the selection to the clipboard}
  if tmProcessClipboardCopy(Msg) then begin
    Msg.Result := 1;
    Exit;
  end;
  {process the keystroke}
  with Msg do begin
    {ignore all shift and supershift keys}
    if (CharCode = VK_SHIFT) or
       (CharCode = VK_CONTROL) or
       (CharCode = VK_MENU) then
      Exit;
    {calculate the shift state}
    Shift := KeyDataToShiftState(KeyData);
    {calculate whether this is an enhanced key}
    EnhKey := (KeyData and $1000000) <> 0;
    {get the key}
    Key := CharCode;
    {convert some keys}
    if EnhKey then begin
      {convert VK_RETURN to VK_EXECUTE for the Keypad}
      if (Key = VK_RETURN) then
        Key := VK_EXECUTE;
    end
    else {not an enhanced keyboard} begin
      {convert unNumLocked keys on Keypad to their Keypad values}
      GetKeyboardState(NumLockState);
      if ((NumLockState[VK_NUMLOCK] and $01) = 0) then
        case Key of
          VK_CLEAR  : Key := VK_NUMPAD5;
          VK_PRIOR  : Key := VK_NUMPAD9;
          VK_NEXT   : Key := VK_NUMPAD3;
          VK_END    : Key := VK_NUMPAD1;
          VK_HOME   : Key := VK_NUMPAD7;
          VK_LEFT   : Key := VK_NUMPAD4;
          VK_UP     : Key := VK_NUMPAD8;
          VK_RIGHT  : Key := VK_NUMPAD6;
          VK_DOWN   : Key := VK_NUMPAD2;
          VK_INSERT : Key := VK_NUMPAD0;
          VK_DELETE : Key := VK_DECIMAL;
        end;{case}
    end;
    {calculate whether this is an autorepeat}
    if ((KeyData and $40000000) <> 0) then
      Key := Key or $8000;
    {pass the key, etc, onto the emulator}
    FEmulator.KeyDown(Key, Shift);
    {if the emulator successfully processed the key, let the caller
     know that it's been processed}
    if (Key = 0) then
      Result := 1;
  end;
end;
{--------}
procedure TAdCustomTerminal.CNSysKeyDown(var Msg : TWMKeyDown);
begin
  CNKeyDown(Msg);
end;
{--------}
procedure TAdCustomTerminal.CopyToClipboard;
var
  i         : integer;
  CharCount : integer;
  StartCol  : integer;
  ColCount  : integer;
  CurInx    : integer;
  RowText   : PAnsiChar;
  TextPtr   : PAnsiChar;
begin
  {calculate the amount of text in the selection; this equals the
   number of characters for each line, plus CR/LF per line}
  ColCount := FEmulator.Buffer.ColCount;
  CharCount := 0;
  StartCol := FLButtonRect.Left;
  for i := FLButtonRect.Top to pred(FLButtonRect.Bottom) do begin
    CharCount := CharCount + (ColCount - StartCol + 1) + 2;
    StartCol := 1;
  end;
  CharCount := CharCount + FLButtonRect.Right + 2;
  {allocate enough memory to store this set of characters, plus the
   terminating null}
  GetMem(TextPtr, CharCount + 1);
  {copy all the selected characters}
  CurInx := 0;
  StartCol := FLButtonRect.Left;
  for i := FLButtonRect.Top to pred(FLButtonRect.Bottom) do begin
    RowText := FEmulator.Buffer.GetLineCharPtr(i);
    Move(RowText[StartCol - 1], TextPtr[CurInx],
         ColCount - StartCol + 1);
    inc(CurInx, ColCount - StartCol + 1);
    TextPtr[CurInx] := ^M;
    TextPtr[CurInx+1] := ^J;
    inc(CurInx, 2);
    StartCol := 1;
  end;
  RowText := FEmulator.Buffer.GetLineCharPtr(FLButtonRect.Bottom);
  Move(RowText[StartCol - 1], TextPtr[CurInx],
       FLButtonRect.Right - StartCol + 1);
  inc(CurInx, FLButtonRect.Right - StartCol + 1);
  TextPtr[CurInx] := ^M;
  TextPtr[CurInx+1] := ^J;
  inc(CurInx, 2);
  TextPtr[CurInx] := #0;

  Clipboard.Open;
  Clipboard.SetTextBuf(pchar(string(TextPtr)));
  Clipboard.Close;
  FreeMem(TextPtr);                                                      {!!.04}
end;
{--------}
procedure TAdCustomTerminal.CreateParams(var Params: TCreateParams);
const
  BorderStyles : array [TBorderStyle] of Integer =
                 (0, WS_BORDER);
begin
  inherited CreateParams(Params);

  with Params do begin
    Style := Integer(Style) or BorderStyles[FBorderStyle];
    if tmNeedHScrollbar then                                             {!!.03}
      Style := Integer(Style) or WS_HSCROLL;
    if tmNeedVScrollbar then                                             {!!.03}
      Style := Integer(Style) or WS_VSCROLL;
  end;

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;
{--------}
procedure TAdCustomTerminal.CreateWnd;
  {------}
  function FindComPort(aForm : TWinControl) : TApdCustomComPort;
    {-Search for an existing TComPort}
  var
    i : Integer;
  begin
    for i := 0 to pred(aForm.ComponentCount) do
      if aForm.Components[i] is TApdCustomComPort then begin
        Result := TApdCustomComPort(aForm.Components[i]);
        Exit;
      end;
    Result := nil;
  end;
  {------}
var
  ParentForm : TWinControl;
begin
  {it is possible that the last message to be sent to the old window
   handle was a WM_SETFOCUS: this would have created the caret, so
   free it: it's attached to a window handle that no longer exists}
  tmFreeCaret;
  {call our ancestor to create the window}
  inherited CreateWnd;
  {Hoperfully, a handle was created...}
  if HandleAllocated then begin
    {if we don't have a com port, go find one}
    if (ComPort = nil) then begin
      ParentForm := GetParentForm(Self);
      if (ParentForm <> nil) then
        FComPort := FindComPort(ParentForm);
    end;
    {check to see if we're attached to a comport, if so, register}
    if (ComPort <> nil) and
       not (csDesigning in ComponentState) then begin
      ComPort.RegisterUserEx(Handle);                                    {!!.03}
      if Active then
        tmAttachToComPort;
    end;
    {calculate the character sizes}
    tmGetFontInfo;
    {start the heartbeat}
    FHeartbeat.Enabled := true;
    if (csDesigning in ComponentState) then
      tmDrawDefaultText;

    if (Assigned (FEmulator)) and                                        {!!.05}
       (Assigned (FEmulator.Buffer)) and                                 {!!.05}
       HandleAllocated and                                               {!!.05}
       (not (csDestroying in ComponentState)) then                       {!!.05}
      FEmulator.Buffer.RegisterTerminalHandle (Self.Handle);             {!!.05}
  end;
end;
{--------}
procedure TAdCustomTerminal.DestroyWnd;
begin
  if HandleAllocated then begin
    {check to see if we're attached to a comport, if so, deregister}
    if (ComPort <> nil) and
       not (csDesigning in ComponentState) then begin
      tmDetachFromComPort;
      ComPort.DeregisterUser(Handle);
    end;
    {stop the heartbeat}
    FHeartbeat.Enabled := false;
    {destroy the caret}
    tmFreeCaret;
  end;
  inherited DestroyWnd;
end;
{--------}
function TAdCustomTerminal.GetTotalCharWidth : Integer;                  {!!.06}
begin                                                                    {!!.06}
  if (FCharWidth + FCharHPadding <> 0) then                              {!!.06}
    Result := FCharWidth + FCharHPadding                                 {!!.06}
  else                                                                   {!!.06}
    Result := 1;                                                         {!!.06}
end;                                                                     {!!.06}
{--------}                                                               {!!.06}
function TAdCustomTerminal.GetTotalCharHeight : Integer;                 {!!.06}
begin                                                                    {!!.06}
  if (FCharHeight + FCharVPadding <> 0) then                             {!!.06}
    Result := FCharHeight + FCharVPadding                                {!!.06}
  else                                                                   {!!.06}
    Result := 1;                                                         {!!.06}
end;                                                                     {!!.06}
{--------}
procedure TAdCustomTerminal.HideSelection;
var
  i        : integer;
  ColCount : integer;
begin
  {clear the current selection}
  ColCount := FEmulator.Buffer.ColCount;
  tmMarkDeselected(FLButtonRect.Top, FLButtonRect.Left, ColCount);
  for i := succ(FLButtonRect.Top) to pred(FLButtonRect.Bottom) do
    tmMarkDeselected(i, 1, ColCount);
  tmMarkDeselected(FLButtonRect.Bottom, 1, FLButtonRect.Right);
  {initialize the selection variables}
  SetRectEmpty(FLButtonRect);
  FLButtonAnchor.X := 0;
  FLButtonAnchor.Y := 0;
  FHaveSelection := false;
end;
{--------}
procedure TAdCustomTerminal.KeyDown(var Key : word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (not WantAllKeys) and (Key <> 0) then
    FEmulator.KeyDown(Key, Shift);
end;
{--------}
procedure TAdCustomTerminal.KeyPress(var Key: Char);
var                                                                      {!!.03}
  PaintRgn : HRGN;                                                       {!!.03}

begin
  inherited KeyPress(Key);
  if (Key <> #0) then
    FEmulator.KeyPress(Key);

  if (not UseLazyDisplay) and FEmulator.NeedsUpdate then begin           {!!.03}
    {hide the caret}                                                     {!!.03}
    tmHideCaret;                                                         {!!.03}
    try                                                                  {!!.03}
      PaintRgn := CreateRectRgn (0, 0,                                   {!!.03}
                                 ClientCols * GetTotalCharWidth,         {!!.03} {!!.06}
                                 ClientRows * GetTotalCharHeight);       {!!.03} {!!.06}
      SelectClipRgn (Canvas.Handle, PaintRgn);                           {!!.03}
      DeleteObject (PaintRgn);                                           {!!.03}
      FEmulator.LazyPaint;                                               {!!.03}
    finally                                                              {!!.03}
      tmShowCaret;                                                       {!!.03}
    end;                                                                 {!!.03}
  end;                                                                   {!!.03}
end;
{--------}
procedure TAdCustomTerminal.Loaded;                                      {!!.03}
begin                                                                    {!!.03}
  { Force reloading of font information }                                {!!.03}
  tmGetFontInfo;                                                         {!!.03}
  { Force the terminal to start in the upper left hand corner }
  if Assigned (FEmulator) then begin                                     {!!.03}
    if Assigned (FEmulator.Buffer) then begin                            {!!.03}
      FEmulator.Buffer.Row := 1;                                         {!!.03}
    end;                                                                 {!!.03}
  end;                                                                   {!!.03}
  inherited Loaded;                                                      {!!.05}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.MouseDown(Button : TMouseButton;
                                      Shift  : TShiftState;
                                      X, Y   : integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) then begin
    if not Focused then begin
      if CanFocus then
        SetFocus
      else if (Handle <> 0) then
        Windows.SetFocus(Handle);
    end;
    FLButtonDown := true;
    {force mouse position into bounds}
    X := BoundI(0, X, pred(ClientCols * GetTotalCharWidth));             {!!.06}
    Y := BoundI(0, Y, pred(ClientRows * GetTotalCharHeight));            {!!.06}
    {start the selection}
    if FMouseSelect then                                                 {!!.03}
      tmStartSelect(X, Y);
  end;
end;
{--------}
procedure TAdCustomTerminal.MouseMove(Shift : TShiftState; X, Y : integer);
begin
  inherited MouseMove(Shift, X, Y);
  if FLButtonDown then begin
    {force mouse position into bounds}
    X := BoundI(0, X, pred(ClientCols * GetTotalCharWidth));             {!!.06}
    Y := BoundI(0, Y, pred(ClientRows * GetTotalCharHeight));            {!!.06}
    {update the selection}
    if FMouseSelect then                                                 {!!.03}
      tmGrowSelect(X, Y);
  end;
end;
{--------}
procedure TAdCustomTerminal.MouseUp(Button : TMouseButton;
                              Shift : TShiftState; X, Y : integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FLButtonDown and (Button = mbLeft) then begin
    if (FMouseSelect) and (FAutoCopy) then                               {!!.03}
      CopyToClipboard;                                                   {!!.03}
    FLButtonDown := false;
  end;
end;
{--------}
procedure TAdCustomTerminal.Notification(AComponent : TComponent;
                                         Operation  : TOperation);
begin
  if (Operation = opRemove) then begin
    if (AComponent = Emulator) then
      Emulator := nil
    else if (AComponent = ComPort) then begin
      Active := false;
      ComPort := nil;
    end;
  end
  else {Operation = opInsert} begin
    if (AComponent is TAdTerminalEmulator) then begin
      if (Emulator = nil) then
        Emulator := TAdTerminalEmulator(AComponent);
    end
    else if (AComponent is TApdCustomComPort) then begin
      if (ComPort = nil) then
        ComPort := TApdCustomComPort(AComponent);
    end;
  end;
  inherited Notification(AComponent, Operation);
end;
{--------}
function TermIntersectRect(var lprcDst : TRect;
                         const lprcSrc1, lprcSrc2: TRect) : boolean;
begin
  Result := IntersectRect(lprcDst, lprcSrc1, lprcSrc2);
end;
{--------}
procedure TAdCustomTerminal.Paint;
var
  DirtyRect : TRect;
  PaintRect : TRect;
  PaintRgn  : HRGN;
begin
  {hide the caret}
  tmHideCaret;
  try
    {get the current clip rect--ie, the rect that needs painting}
    DirtyRect := Canvas.ClipRect;
    {paint any unused bits of that rect}
    if TermIntersectRect(PaintRect, DirtyRect, FUnusedRightRect) then begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(PaintRect);
    end;
    if TermIntersectRect(PaintRect, DirtyRect, FUnusedBottomRect) then begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(PaintRect);
    end;
    {find out if there is anything else to paint}
    if TermIntersectRect(PaintRect, DirtyRect, FUsedRect) then begin
      {create a clipping region and select it into the canvas, so that
       the emulator only gets to know about bits it can paint}
      with PaintRect do
        PaintRgn := CreateRectRgn(Left, Top, Right, Bottom);
      SelectClipRgn(Canvas.Handle, PaintRgn);
      DeleteObject(PaintRgn);
      {tell the emulator to paint what it has}
      FEmulator.Paint
    end;
  finally
    {show the caret again}
    tmShowCaret;
  end;
end;
{--------}
procedure TAdCustomTerminal.PaintWindow(DC : HDC);
begin
  Canvas.Handle := DC;
  try
    Paint;
  finally
    Canvas.Handle := 0;
  end;
end;
{--------}
procedure TAdCustomTerminal.PasteFromClipboard;                          {!!.04}
var                                                                      {!!.04}
  i             : Integer;                                               {!!.04}
  ClipboardText : ansistring;                                                {!!.04}
  ClipboardLen  : Integer;                                               {!!.04}

begin                                                                    {!!.04}
  Clipboard.Open;                                                        {!!.04}
  try                                                                    {!!.04}
    if Clipboard.HasFormat (CF_TEXT) then begin                          {!!.04}
      ClipboardText := AnsiString(Clipboard.AsText);                     {!!.04}
      ClipboardLen  := Length (ClipboardText);                           {!!.04}

      if FPasteToScreen and FPasteToPort and                             {!!.04}
         Assigned (FComPort) then begin                                  {!!.04}
        for i := 1 to ClipboardLen do begin                              {!!.04}
          WriteChar (ClipboardText[i]);                                  {!!.04}
          FComPort.PutChar(ClipboardText[i]);                            {!!.04}
        end;                                                             {!!.04}
        Exit;                                                            {!!.04}
      end;                                                               {!!.04}

      if FPasteToScreen then                                             {!!.04}
        Self.WriteString (ClipboardText);                                {!!.04}

      if FPasteToPort and Assigned (FComPort) then                       {!!.04}
        FComPort.Output := ClipboardText;                                {!!.04}

    end;                                                                 {!!.04}
  finally                                                                {!!.04}
    Clipboard.Close;                                                     {!!.04}
  end;                                                                   {!!.04}
end;                                                                     {!!.04}
{--------}
procedure TAdCustomTerminal.tmAttachToComPort;
begin
  {Assumptions: not designtime
                ComPort <> nil
                Active = true
                FWaitingForComPort = don't care}

  FWaitingForComPortOpen := true;                                        {!!.03}
  PostMessage (Handle, apw_TermWaitForPort, 0, 0)                        {!!.03}
end;
{--------}
procedure TAdCustomTerminal.tmBeat(Sender: TObject);
var
  PaintRgn : HRGN;
  MousePt  : TPoint;
  Msg      : TWMScroll;
begin
  {if the left mouse button is down we may need to scroll to help the
   user select text}
  if FLButtonDown then begin
    GetCursorPos(MousePt);
    MousePt := ScreenToClient(MousePt);
    if FUseHScrollBar then
      if (MousePt.X < 0) then begin
        Msg.ScrollCode := SB_LINELEFT;
        WMHScroll(Msg);
      end
      else if (MousePt.X >= ClientWidth) then begin
        Msg.ScrollCode := SB_LINERIGHT;
        WMHScroll(Msg);
      end;
    if (MousePt.Y < 0) then begin
      Msg.ScrollCode := SB_LINEUP;
      WMVScroll(Msg);
    end
    else if (MousePt.Y >= ClientHeight) then begin
      Msg.ScrollCode := SB_LINEDOWN;
      WMVScroll(Msg);
    end;
    MouseMove([ssLeft], MousePt.X, MousePt.Y);
  end;
  {only blink if the blink time is not zero}
  if (BlinkTime > 0) then begin
    inc(FBlinkTimeCount, BeatInterval);
    if (FBlinkTimeCount > BlinkTime) then begin
      FBlinkTextVisible := not FBlinkTextVisible;
      if FEmulator.HasBlinkingText then begin
        tmHideCaret;
        try
          PaintRgn := CreateRectRgn(0, 0,
                         ClientCols * GetTotalCharWidth,                 {!!.06}
                         ClientRows * GetTotalCharHeight);               {!!.06}
          SelectClipRgn(Canvas.Handle, PaintRgn);
          DeleteObject(PaintRgn);
          FEmulator.BlinkPaint(FBlinkTextVisible);
        finally
          tmShowCaret;
        end;
      end;
      FBlinkTimeCount := 0;
    end;
  end;

  {only use the lazy display option if requested to}
  if UseLazyDisplay then begin
    {check for a lazy display time or byte count}
    inc(FLazyTimeCount, BeatInterval);
    if FEmulator.NeedsUpdate and
       ((FLazyTimeCount > FLazyTimeDelay) or
        (FLazyByteCount > FLazyByteDelay)) then begin
      tmHideCaret;
      try
        PaintRgn := CreateRectRgn(0, 0,
                       ClientCols * GetTotalCharWidth,                   {!!.06}
                       ClientRows * GetTotalCharHeight);                 {!!.06}
        SelectClipRgn(Canvas.Handle, PaintRgn);
        DeleteObject(PaintRgn);
        FEmulator.LazyPaint;
      finally
        tmShowCaret;
      end;
      FLazyTimeCount := 0;
      FLazyByteCount := 0;
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmCalcExtent;
var
  WorkColCount : integer;
  WorkRowCount : integer;
begin
  {ASSUMPTION: there is a handle allocated, but an emulator may not be
               attached. Since there is a handle, we've already
               calculated the character width and height.}

  {first calculate the max number of columns and rows in the client
   area}
  if (FEmulator = nil) then begin
    FClientCols := 0;
    FClientRows := 0;
    Exit;
  end;

  WorkColCount := Columns;
  WorkRowCount := Rows;

  FClientCols := (ClientWidth + pred(GetTotalCharWidth))                 {!!.06}
                  div GetTotalCharWidth;                                 {!!.06}
  FClientCols := MinI(FClientCols, WorkColCount - ClientOriginCol + 1);
  FClientFullCols := ClientWidth div GetTotalCharWidth;                  {!!.06}
  FClientFullCols := MinI(FClientFullCols, WorkColCount - ClientOriginCol + 1);

  FClientRows := (ClientHeight + pred(GetTotalCharHeight))               {!!.06}
                 div GetTotalCharHeight;                                 {!!.06}
  FClientRows := MinI(FClientRows, WorkRowCount - ClientOriginRow + 1);
  FClientFullRows := ClientHeight div GetTotalCharHeight;                {!!.06}
  FClientFullRows := MinI(FClientFullRows, WorkRowCount - ClientOriginRow + 1);

  {if there is a handle for the terminal, we have to worry about
   whether the scrollbars are visible or not}
  if HandleAllocated then begin
    {if the width is too small, force a horizontal scroll bar; if too
     large, force the horizontal scroll bar off}
    if (FClientFullCols < WorkColCount) then begin
      if (not FUseHScrollBar) and (not FHideScrollbars) then begin       {!!.03} {!!.06}
        FUseHScrollBar := true;
        PostMessage(Handle, APW_TERMFORCESIZE, 0, 0);
        Exit;
      end
    end
    else begin
      if tmNeedHScrollbar then begin                                     {!!.03}
        FUseHScrollBar := false;
        PostMessage(Handle, APW_TERMFORCESIZE, 0, 0);
        Exit;
      end
    end;
    {if the height is too small, force a vertical scroll bar; if too
     large, force the vertical scroll bar off}
    if (FClientFullRows < WorkRowCount) then begin
      if (not FUseVScrollBar) and (not FHideScrollbars) then begin       {!!.06}
        FUseVScrollBar := true;
        {note: if we have scrollback rows we already have a vertical
               scrollbar}
        if (ScrollbackRows <= Rows) then begin
          PostMessage(Handle, APW_TERMFORCESIZE, 0, 0);
          Exit;
        end
      end
    end
    else begin
      if FUseVScrollBar then begin
        FUseVScrollBar := false;
        PostMessage(Handle, APW_TERMFORCESIZE, 0, 0);
        Exit;
      end
    end;
  end;

  {now calculate the used and unused area rects}
  FUsedRect := Rect(0, 0, ClientWidth, ClientHeight);
  FUnusedRightRect := FUsedRect;
  FUnusedBottomRect := FUsedRect;

  FUsedRect.Right := MinI (ClientCols * GetTotalCharWidth,               {!!.06}
                           ClientWidth);                                 {!!.06}
  FUsedRect.Bottom := MinI (ClientRows * GetTotalCharHeight,             {!!.06}
                            ClientHeight);                               {!!.06}

  FUnusedRightRect.Left := FUsedRect.Right;
  FUnusedRightRect.Bottom := FUsedRect.Bottom;
  FUnusedBottomRect.Top := FUsedRect.Bottom;

  {if we are using a horizontal scroll bar, set the range}
  if tmNeedHScrollbar then begin                                         {!!.03}
    tmInitHScrollBar;
  end;

  {if we are using a vertical scroll bar, set the range}
  if tmNeedVScrollbar then begin                                         {!!.03}
    tmInitVScrollBar;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmDetachFromComPort;
begin
  {Assumptions: ComPort <> nil}
  if FTriggerHandlerOn and Assigned(ComPort.Dispatcher) then begin       {!!.03}
    ComPort.Dispatcher.DeregisterEventTriggerHandler(tmTriggerHandler);
    FTriggerHandlerOn := false;
  end;
  if Active then
    FWaitingForComPortOpen := true;
end;
{--------}
procedure TAdCustomTerminal.tmDrawDefaultText;
const
  FormatMost = 'Design mode; line %.2d'^M^J;
  FormatLast = 'Design mode; line %.2d'^M;
  VT100Most = #27'[0;%dmDesign mode; line %.2d'^M^J;
  VT100Last = #27'[0;%dmDesign mode; line %.2d'^M;
var
  i  : integer;
  S  : string;
  VTColor : integer;
begin
  {ASSUMPTION: Handle is allocated}

  if (FByteQueue = nil) or
     (FEmulator.Buffer = nil) then
    Exit;

  for i := 1 to ScrollbackRows do
    WriteString(^M^J);

  if (FEmulator is TAdVT100Emulator) then begin
    VTColor := 31;
    for i := 1 to pred(Rows) do begin
      S := Format(VT100Most, [VTColor, i]);
      WriteString(S);
      inc(VTColor);
      if (VTColor = 38) then
        VTColor := 31;
    end;
    S := Format(VT100Last, [VTColor, Rows]);
    WriteString(S);
  end
  else begin
    for i := 1 to pred(Rows) do begin
      S := Format(FormatMost, [i]);
      WriteString(S);
    end;
    S := Format(FormatLast, [Rows]);
    WriteString(S);
  end;
  Invalidate;
end;
{--------}
procedure TAdCustomTerminal.tmFollowCursor;                              {!!.03}
begin                                                                    {!!.03}
  if not FFollowCursor then                                              {!!.03}
    Exit;                                                                {!!.03}
  if not Assigned (Emulator) then                                        {!!.03}
    Exit;                                                                {!!.03}
  if not Assigned (Emulator.Buffer) then                                 {!!.03}
    Exit;                                                                {!!.03}

  if Emulator.Buffer.Col < ClientOriginCol then                          {!!.03}
    ClientOriginCol := Emulator.Buffer.Col;                              {!!.03}
  if Emulator.Buffer.Col > ClientOriginCol + FClientFullCols then        {!!.03}
    ClientOriginCol := Emulator.Buffer.Col - FClientFullCols;            {!!.03}

  if Emulator.Buffer.Row < ClientOriginRow then                          {!!.03}
    ClientOriginRow := Emulator.Buffer.Row;                              {!!.03}
  if Emulator.Buffer.Row >= ClientOriginRow + FClientFullRows then       {!!.03}
    ClientOriginRow := Emulator.Buffer.Row - FClientFullRows;            {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmFreeCaret;
begin
  if FCreatedCaret then begin
    DestroyCaret;
    FCreatedCaret := false;
  end;
end;
{--------}
function TAdCustomTerminal.tmGetAttributes(aRow, aCol : integer) : TAdTerminalCharAttrs;
var
  AttrArray : PByteArray;
begin
  if (FEmulator.Buffer <> nil) then begin
    AttrArray := FEmulator.Buffer.GetLineAttrPtr(aRow);
    Result := TAdTerminalCharAttrs(AttrArray^[pred(aCol)]);
  end
  else
    Result := [];
end;
{--------}
function TAdCustomTerminal.tmGetBackColor(aRow, aCol : integer) : TColor;
var
  ColorArray : PadtLongArray;
begin
  if (FEmulator.Buffer <> nil) then begin
    ColorArray := FEmulator.Buffer.GetLineBackColorPtr(aRow);
    Result := TColor(ColorArray^[pred(aCol)]);
  end
  else
    Result := adc_TermBackColor;
end;
{--------}
function TAdCustomTerminal.tmGetCharSet(aRow, aCol : integer) : byte;
var
  CharSetArray : PByteArray;
begin
  if (FEmulator.Buffer <> nil) then begin
    CharSetArray := FEmulator.Buffer.GetLineCharSetPtr(aRow);
    Result := CharSetArray^[pred(aCol)];
  end
  else
    Result := 0;
end;
{--------}
function TAdCustomTerminal.tmGetColumns : integer;
begin
  if (FEmulator.Buffer <> nil) then
    Result := FEmulator.Buffer.ColCount
  else
    Result := 0;
end;
{--------}
function TAdCustomTerminal.tmGetEmulator : TAdTerminalEmulator;
begin
  if (FEmulator = FDefEmulator) then
    Result := nil
  else
    Result := FEmulator;
end;
{--------}
procedure TAdCustomTerminal.tmGetFontInfo;
var
  DC              : HDC;
  i               : integer;
  SavedFontHandle : THandle;
  Metrics         : TTextMetric;
  SizeChanged     : boolean;
  NewValue        : integer;
  TempFont        : TFont;
  FontList        : TStringList;
  {------}
  procedure UpdateCharSizes;
  begin
    with Metrics do begin
      {calculate the height}
      NewValue := tmHeight + tmExternalLeading;
      if (NewValue > FCharHeight) then begin
        SizeChanged := true;
        FCharHeight := NewValue;
      end;
      { Always use the max width.  With fixed pitch fonts, this should be
        the same for all characters }
      { Non proportional fonts will look odd, but should still not overlap }
      {if it's a fixed pitch font, use the average char width}
      NewValue := tmMaxCharWidth;                                        {!!.03}
      if (NewValue <> FCharWidth) then begin                             {!!.03}
        SizeChanged := true;
        FCharWidth := NewValue;
      end;
    end;
  end;
  {------}

begin
  if (FEmulator.CharSetMapping <> nil) then begin
    FontList := TStringList.Create;
    try
      FEmulator.CharSetMapping.GetFontNames(FontList);
    except
      FontList.Free;
      raise;
    end;
  end
  else
    FontList := nil;

  {get a DC, in order that we can get the font metrics for the current
   font; release the DC afterwards}
  DC := GetDC(0);
  SavedFontHandle := SelectObject(DC, Font.Handle);
  TempFont := nil;
  FCharWidth := 0;
  FCharHeight := 0;
  try
    {obtain the character cell height and width from the metrics}
    SizeChanged := false;
    if (FontList = nil) then begin
      GetTextMetrics(DC, Metrics);
      UpdateCharSizes;
    end
    else begin
      TempFont := TFont.Create;
      TempFont.Assign(Font);
      TempFont.CharSet := DEFAULT_CHARSET;
      for i := 0 to pred(FontList.Count) do begin
        if (FontList[i] = string(DefaultFontName)) then
          TempFont.Name := Font.Name
        else
          TempFont.Name := FontList[i];
        SelectObject(DC, Font.Handle);
        GetTextMetrics(DC, Metrics);
        UpdateCharSizes;
      end;
    end;
    {if either the width or height changed, invalidate the display}
    if HandleAllocated then begin
      if SizeChanged then begin
        tmCalcExtent;
        Invalidate;
      end;
    end;
  finally
    SelectObject(DC, SavedFontHandle);
    ReleaseDC(0, DC);
    FontList.Free;
    TempFont.Free;
  end;
end;
{--------}
function TAdCustomTerminal.tmGetForeColor(aRow, aCol : integer) : TColor;
var
  ColorArray : PadtLongArray;
begin
  if (FEmulator.Buffer <> nil) then begin
    ColorArray := FEmulator.Buffer.GetLineForeColorPtr(aRow);
    Result := TColor(ColorArray^[pred(aCol)]);
  end
  else
    Result := clWhite;
end;
{--------}
function TAdCustomTerminal.tmGetLine(aRow : integer) : AnsiString;
var
  CharArray : PAnsiChar;
begin
  if (FEmulator.Buffer <> nil) then begin
    CharArray := FEmulator.Buffer.GetLineCharPtr(aRow);
    SetLength(Result, FEmulator.Buffer.ColCount);
    Move(CharArray^, Result[1], FEmulator.Buffer.ColCount);
  end
  else
    Result := '';
end;
{--------}
function TAdCustomTerminal.tmGetRows : integer;
begin
  if (FEmulator.Buffer <> nil) then
    Result := FEmulator.Buffer.RowCount
  else
    Result := 0;
end;
{--------}
function TAdCustomTerminal.tmGetScrollbackRows : integer;
begin
  if (FEmulator.Buffer <> nil) then
    Result := FEmulator.Buffer.SVRowCount
  else
    Result := 0;
end;
{--------}
procedure TAdCustomTerminal.tmGrowSelect(X, Y : integer);
var
  NewRow   : integer;
  NewCol   : integer;
  StartCol : integer;
  ColCount : integer;
  NewRgn   : TRect;
  i        : integer;
begin
  {if this gets called, we have a selection}
  FHaveSelection := true;

  {get the column count as a local variable: we'll be using it a lot}
  ColCount := FEmulator.Buffer.ColCount;

  {X and Y are mouse coordinates on the terminal display; convert to a
   row/col position}
  NewCol := (X div GetTotalCharWidth) + ClientOriginCol;                 {!!.06}
  NewCol := MinI(MaxI(NewCol, 1), ColCount);
  NewRow := (Y div GetTotalCharHeight) + ClientOriginRow;                {!!.06}
  with FEmulator.Buffer do
    NewRow := MinI(MaxI(NewRow, RowCount-SVRowCount), RowCount);

  {generate the new selected region}
  if (NewRow < FLButtonAnchor.Y) then begin
    NewRgn.Top := NewRow;
    NewRgn.Left := NewCol;
    NewRgn.Bottom := FLButtonAnchor.Y;
    NewRgn.Right := FLButtonAnchor.X;
  end
  else if (NewRow > FLButtonAnchor.Y) then begin
    NewRgn.Top := FLButtonAnchor.Y;
    NewRgn.Left := FLButtonAnchor.X;
    NewRgn.Bottom := NewRow;
    NewRgn.Right := NewCol;
  end
  else {NewRow and the anchor row are the same} begin
    NewRgn.Top := NewRow;
    NewRgn.Bottom := NewRow;
    if (NewCol <= FLButtonAnchor.X) then begin
      NewRgn.Left := NewCol;
      NewRgn.Right := FLButtonAnchor.X;
    end
    else begin
      NewRgn.Left := FLButtonAnchor.X;
      NewRgn.Right := NewCol;
    end;
  end;

  {check to see how the current selection grew (we need to mark the
   new bits as selected) or shrank (the new bits need to be
   deselected)}
  if (NewRgn.Top = NewRgn.Bottom) then begin
    StartCol := FLButtonRect.Left;
    for i := FLButtonRect.Top to pred(FLButtonRect.Bottom) do begin
      tmMarkDeselected(i, StartCol, ColCount);
      StartCol := 1;
    end;
    tmMarkDeselected(FLButtonRect.Bottom, 1, FLButtonRect.Right);
    tmMarkSelected(NewRgn.Top, NewRgn.Left, NewRgn.Right);
  end
  else begin
    if (NewRgn.Top < FLButtonRect.Top) then begin
      {the selection grew upwards}
      StartCol := NewRgn.Left;
      for i := NewRgn.Top to pred(FLButtonRect.Top) do begin
        tmMarkSelected(i, StartCol, ColCount);
        StartCol := 1;
      end;
      tmMarkSelected(FLButtonRect.Top, 1, FLButtonRect.Left);
    end
    else if (NewRgn.Top = FLButtonRect.Top) then begin
      {the selection might have changed on the top row}
      if (NewRgn.Left < FLButtonRect.Left) then
        tmMarkSelected(NewRgn.Top, NewRgn.Left, FLButtonRect.Left)
      else if (NewRgn.Left > FLButtonRect.Left) then
        tmMarkDeselected(NewRgn.Top, FLButtonRect.Left, NewRgn.Left);
    end
    else {new top > old top} begin
      StartCol := FLButtonRect.Left;
      for i := FLButtonRect.Top to pred(NewRgn.Top) do begin
        tmMarkDeselected(i, StartCol, ColCount);
        StartCol := 1;
      end;
      tmMarkDeselected(NewRgn.Top, 1, NewRgn.Left);
    end;
    if (NewRgn.Bottom > FLButtonRect.Bottom) then begin
      {the selection grew downwards}
      StartCol := FLButtonRect.Right;
      tmMarkSelected(FLButtonRect.Bottom, FLButtonRect.Right, ColCount);
      for i := FLButtonRect.Bottom to pred(NewRgn.Bottom) do begin
        tmMarkSelected(i, StartCol, ColCount);
        StartCol := 1;
      end;
      tmMarkSelected(NewRgn.Bottom, 1, NewRgn.Right);
    end
    else if (NewRgn.Bottom = FLButtonRect.Bottom) then begin
      {the selection might have changed on the bottom row}
      if (NewRgn.Right > FLButtonRect.Right) then
        tmMarkSelected(NewRgn.Bottom, FLButtonRect.Right, NewRgn.Right)
      else if (NewRgn.Right < FLButtonRect.Right) then
        tmMarkDeselected(NewRgn.Bottom, NewRgn.Right, FLButtonRect.Right);
    end
    else {new bottom < old bottom} begin
      StartCol := NewRgn.Right;
      for i := NewRgn.Bottom to pred(FLButtonRect.Bottom) do begin
        tmMarkDeselected(i, StartCol, ColCount);
        StartCol := 1;
      end;
      tmMarkDeselected(FLButtonRect.Bottom, 1, FLButtonRect.Right);
    end;
  end;
  FLButtonRect := NewRgn;
end;
{--------}
procedure TAdCustomTerminal.tmHideCaret;
begin
  if FShowingCaret then begin
    HideCaret(Handle);
    FShowingCaret := false;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmInitHScrollBar;
begin
  {Assumptions: FUseHScrollBar = true
                FClientFullCols < Columns}
  with FScrollHorzInfo do begin
    fMask := SIF_ALL;
    nMin := 0;
    nMax := Columns - 1;
    nPage := FClientFullCols;
    nPos := ClientOriginCol-1;
  end;
  SetScrollInfo(Handle, SB_HORZ, FScrollHorzInfo, true);
end;
{--------}
procedure TAdCustomTerminal.tmInitVScrollBar;
begin
  {Assumptions: FUseVScrollBar = true AND FClientFullRows < Rows
                OR ScrollbackRows > Rows}
  if FUseVScrollBar and (not Scrollback) then begin
    with FScrollVertInfo do begin
      fMask := SIF_ALL;
      nMin := 0;
      nMax := Rows - 1;
      nPage := FClientFullRows;
      nPos := ClientOriginRow-1;
    end;
  end
  else begin
    with FScrollVertInfo do begin
      fMask := SIF_ALL;
      nMin := Rows - ScrollbackRows;
      nMax := Rows - 1;
      nPage := FClientFullRows;
      nPos := ClientOriginRow-1;
    end;
  end;
  SetScrollInfo(Handle, SB_VERT, FScrollVertInfo, true);
end;
{--------}
procedure TAdCustomTerminal.tmMakeCaret;
begin
  FCreatedCaret := true;
  if (CursorType = ctUnderline) then
    CreateCaret(Handle, 0, GetTotalCharWidth, 2)                         {!!.06}
  else if (CursorType = ctBlock) then
    CreateCaret(Handle, 0, GetTotalCharWidth, GetTotalCharHeight)        {!!.06}
  else
    FCreatedCaret := false;
end;
{--------}
procedure TAdCustomTerminal.tmInvalidateRow(aRow : integer);
var
  InvRect : TRect;
begin
  if HandleAllocated and (ClientOriginRow <= aRow) and
     (aRow < ClientOriginRow + ClientRows) then begin
    InvRect.Left := 0;
    InvRect.Top := (aRow - ClientOriginRow) * GetTotalCharHeight;        {!!.06}
    InvRect.Right := ClientWidth;
    InvRect.Bottom := InvRect.Top + GetTotalCharHeight;                  {!!.06}
    InvalidateRect(Handle, @InvRect, false);
  end;
end;
{--------}
procedure TAdCustomTerminal.tmMarkDeselected(aRow : integer;
                                             aFromCol, aToCol : integer);
var
  AttrArray : PByteArray;
  i         : integer;
  CharAttrs : TAdTerminalCharAttrs;
begin
  {get the attributes for this line}
  AttrArray := FEmulator.Buffer.GetLineAttrPtr(aRow);
  for i := pred(aFromCol) to pred(aToCol) do begin
    CharAttrs := TAdTerminalCharAttrs(AttrArray^[i]);
    Exclude(CharAttrs, tcaSelected);
    AttrArray^[i] := byte(CharAttrs);
  end;
  tmInvalidateRow(aRow);
end;
{--------}
procedure TAdCustomTerminal.tmMarkSelected(aRow : integer;
                                           aFromCol, aToCol : integer);
var
  AttrArray : PByteArray;
  i         : integer;
  CharAttrs : TAdTerminalCharAttrs;
begin
  {get the attributes for this line}
  AttrArray := FEmulator.Buffer.GetLineAttrPtr(aRow);
  for i := pred(aFromCol) to pred(aToCol) do begin
    CharAttrs := TAdTerminalCharAttrs(AttrArray^[i]);
    Include(CharAttrs, tcaSelected);
    AttrArray^[i] := byte(CharAttrs);
  end;
  tmInvalidateRow(aRow);
end;
{--------}
function  TAdCustomTerminal.tmNeedHScrollbar : Boolean;                  {!!.03}
begin                                                                    {!!.03}
  Result := FUseHScrollBar and (not FHideScrollbars);                    {!!.03}
  if FHideScrollbars and FHideScrollbarHActive and FUseHScrollBar then   {!!.03}
    Result := True;                                                      {!!.03}
end;                                                                     {!!.03}
{--------}
function  TAdCustomTerminal.tmNeedVScrollbar : Boolean;                  {!!.03}
begin                                                                    {!!.03}
  Result := (FUseVScrollBar and (not FHideScrollbars)) or                {!!.03}
            ((ScrollbackRows > Rows) and (FScrollback));                 {!!.03}
  if FHideScrollbars and FHideScrollBarVActive and FUseVScrollBar then   {!!.03}
    Result := True;                                                      {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmPositionCaret;
var
  X, Y : integer;
begin
  with FEmulator.Buffer do begin
    if UseAbsAddress then begin
      X := (Col - FOriginCol) * GetTotalCharWidth;                       {!!.06}
      Y := (Row - FOriginRow) * GetTotalCharHeight;                      {!!.06}
    end
    else begin
      X := (Col + OriginCol - 1 - FOriginCol) * GetTotalCharWidth;       {!!.06}
      Y := (Row + OriginRow - 1 - FOriginRow) * GetTotalCharHeight;      {!!.06}
    end;
  end;
  if (CursorType = ctUnderline) then
    inc(Y, GetTotalCharHeight - 2);                                      {!!.06}       
  if (0 <= X) and (X < ClientWidth) and
     (0 <= Y) and (Y < ClientHeight) then begin     
    ShowCaret(Handle);
    SetCaretPos(X, Y);
    FShowingCaret := true;
  end;
end;
{--------}
function TAdCustomTerminal.tmProcessClipboardCopy(
                                      var Msg : TWMKeyDown) : boolean;
const
  VK_C = $43;
var
  Shift  : TShiftState;
begin
  {this method is called from the main keydown methods to check for
   Ctrl+C or Ctrl+Insert, so that the selected text can get copied to
   the clipboard}
  Result := false;
  {check whether we have a selection}
  if not FHaveSelection then
    Exit;
  {check whether the key is a C or an Insert}
  if (Msg.CharCode <> VK_C) and (Msg.CharCode <> VK_INSERT) then
    Exit;
  {see if the Ctrl key is down and the shift and Alt keys are not}
  Shift := KeyDataToShiftState(Msg.KeyData);
  if (not (ssCtrl in Shift)) or
     (ssShift in Shift) or (ssAlt in Shift) then
    Exit;
  {we have the required keystroke and a selection: copy to clipboard}
  Result := true;
  CopyToClipboard;
end;
{--------}
procedure TAdCustomTerminal.tmRemoveHScrollbar;                          {!!.03}
var                                                                      {!!.03}
  Style : Integer;                                                       {!!.03}

begin                                                                    {!!.03}
  Style := GetWindowLong (Handle, GWL_STYLE);                            {!!.03}
  if ((Style and WS_HSCROLL) <> 0) then begin                            {!!.03}
    SetWindowLong (Handle, GWL_STYLE, Style and not WS_HSCROLL);         {!!.03}
    RecreateWnd;                                                         {!!.03}
  end;                                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmRemoveVScrollbar;                          {!!.03}
var                                                                      {!!.03}
  Style : Integer;                                                       {!!.03}

begin                                                                    {!!.03}
  Style := GetWindowLong (Handle, GWL_STYLE);                            {!!.03}
  if ((Style and WS_VSCROLL) <> 0) then begin                            {!!.03}
    SetWindowLong (Handle, GWL_STYLE, Style and not WS_VSCROLL);         {!!.03}
    RecreateWnd;                                                         {!!.03}
  end;                                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmScrollHorz(aDist : integer);
begin
  {aDist is +ve if we are scrolling to the right (ie the current
   window contents are moved to a position aDist pixels to the right),
   and is -ve for a leftward scroll}
  ScrollWindow(Handle, aDist, 0, nil, nil);
end;
{--------}
procedure TAdCustomTerminal.tmScrollVert(aDist : integer);
begin
  {aDist is +ve if we are scrolling downwards (ie the current window
   contents are moved to a position aDist pixels down), and is -ve for
   a upward scroll}
  ScrollWindow(Handle, 0, aDist, nil, nil);
end;
{--------}
procedure TAdCustomTerminal.tmSetActive(aValue : boolean);
begin
  if (aValue <> Active) then begin
    FWaitingForComPortOpen := false;
    FActive := aValue;
    {if we have a comport then either attach to or detach from it}
    if (ComPort <> nil) then begin
      if not (csDesigning in ComponentState) then
        if Active then
          tmAttachToComPort
        else
          tmDetachFromComPort;
    end
    else if Active then
      FWaitingForComPortOpen := true;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetAttributes(aRow, aCol : integer;
                               const aAttr      : TAdTerminalCharAttrs);
var
  AttrArray : PByteArray;
begin
  if (FEmulator.Buffer <> nil) then begin                    
    AttrArray := FEmulator.Buffer.GetLineAttrPtr(aRow);
    TAdTerminalCharAttrs(AttrArray^[pred(aCol)]) := aAttr;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetAutoCopy (const v : Boolean);           {!!.03}
begin                                                                    {!!.03}
  if v <> FAutoCopy then                                                 {!!.03}
    FAutoCopy := v;                                                      {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmSetAutoScrollback (const v : Boolean);     {!!.03}
begin                                                                    {!!.03}
  if v <> FAutoScrollback then begin                                     {!!.03}
    FAutoScrollback := v;                                                {!!.03}
    if tmNeedVScrollBar then                                             {!!.03}
      tmInitVScrollbar                                                   {!!.03}
    else                                                                 {!!.03}
      tmRemoveVScrollbar;                                                {!!.03}
  end;                                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmSetBackColor(aRow, aCol : integer;
                                    aValue     : TColor);
var
  ColorArray : PadtLongArray;
begin
  if (FEmulator.Buffer <> nil) then begin
    ColorArray := FEmulator.Buffer.GetLineBackColorPtr(aRow);
    TColor(ColorArray^[pred(aCol)]) := aValue;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetBlinkTime(aValue : integer);
begin
  if (aValue <> BlinkTime) then begin
    if (aValue <= 0) then
      aValue := 0
    else if (aValue <= 250) then
      aValue := 250;
    FBlinkTime := aValue;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetBorderStyle(aBS : TBorderStyle);
begin
  if (aBS <> BorderStyle) then begin
    FBorderStyle := aBS;
    RecreateWnd;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetCapture(aValue : TAdCaptureMode);
begin
  if (aValue <> Capture) then begin
    if (aValue = cmAppend) and (Capture = cmOn) then
      Exit;
    {if we're capturing now, close the stream}
    if (Capture = cmOn) then begin
      FCaptureStream.Free;
      FCaptureStream := nil;
    end;
    {save the new value}
    FCapture := aValue;
    {if we should now be capturing, open the stream}
    if (Capture <> cmOff) then begin
      if (CaptureFile = '') then
        FCaptureFile := adc_TermCaptureFile;
      if not (csDesigning in ComponentState) then begin
        if (Capture = cmOn) then
        begin
            // This bit of cruft is needed to allow the capture             // SWB
            // file to be opened in share mode.                             // SWB
            FCaptureStream := TFileStream.Create(CaptureFile, fmCreate);    // SWB
            FCaptureStream.Destroy;                                         // SWB
            FCaptureStream := TFileStream.Create(CaptureFile,               // SWB
                                                 fmOpenReadWrite or         // SWB
                                                 fmShareDenyWrite);         // SWB
        end
        else if (Capture = cmAppend) then begin
          FCaptureStream := TFileStream.Create(CaptureFile,                 // SWB
                                               fmOpenReadWrite or           // SWB
                                               fmShareDenyWrite);           // SWB
          FCaptureStream.Seek(0, soFromEnd);
          FCapture := cmOn;
        end;
      end;
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetCaptureFile(const aValue : string);
var
  WasCapturing : boolean;
begin
  if (aValue <> CaptureFile) then begin
    {first turn off capturing if needed}
    if (Capture = cmOff) then
      WasCapturing := false
    else begin
      WasCapturing := true;
      Capture := cmOff;
    end;
    {save the new filename}
    FCaptureFile := aValue;
    {now turn capturing back on}
    if WasCapturing then
      Capture := cmOn;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetCharHPadding (const v : Integer);       {!!.06}
begin                                                                    {!!.06}
  if v <> FCharHPadding then begin                                       {!!.06}
    FCharHPadding := v;                                                  {!!.06}
    if not HandleAllocated then                                          {!!.06}
      Exit;                                                              {!!.06}
    tmGetFontInfo;                                                       {!!.06}
  end;                                                                   {!!.06}
end;                                                                     {!!.06}
{--------}
procedure TAdCustomTerminal.tmSetCharSet(aRow, aCol : integer; aValue : byte);
var
  CharSetArray : PByteArray;
begin
  if (FEmulator.Buffer <> nil) then begin
    CharSetArray := FEmulator.Buffer.GetLineCharSetPtr(aRow);
    CharSetArray^[pred(aCol)] := aValue;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetCharVPadding (const v : Integer);       {!!.06}
begin                                                                    {!!.06}
  if v <> FCharVPadding then begin                                       {!!.06}
    FCharVPadding := v;                                                  {!!.06}
    if not HandleAllocated then                                          {!!.06}
      Exit;                                                              {!!.06}
    tmGetFontInfo;                                                       {!!.06}
  end;                                                                   {!!.06}
end;                                                                     {!!.06}
{--------}
procedure TAdCustomTerminal.tmSetColumns(aValue : integer);
var
  OldValue : integer;
begin
  if (FEmulator.Buffer <> nil) and
     (aValue > 0) then begin
    OldValue := FEmulator.Buffer.ColCount;
    if (OldValue <> aValue) then begin
      FEmulator.Buffer.ColCount := aValue;
      FOriginCol := 1;
      FOriginRow := 1;
      tmCalcExtent;
      Invalidate;
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetComPort(aValue : TapdCustomComPort);
begin
  if (aValue <> ComPort) then begin
    {if we don't yet have a handle, just save the new value}
    if not HandleAllocated then begin
      if (FComPort <> nil) and (FComPort.MasterTerminal = Self) then
        FComPort.MasterTerminal := nil;
      FComPort := aValue;
      if (FComPort <> nil) and (FComPort.MasterTerminal = nil) then
        FComPort.MasterTerminal := Self;
    end
    {otherwise we need to do some comport registration}
    else begin
      {detach/deregister from the old comport}
      if (ComPort <> nil) and
         not (csDesigning in ComponentState) then begin
        tmDetachFromComPort;
        ComPort.DeregisterUser(Handle);
        if (FComPort.MasterTerminal = Self) then
          FComPort.MasterTerminal := nil;
      end;
      {save the new value}
      FComPort := aValue;
      {register/attach with the new comport}
      if (ComPort <> nil) and
         not (csDesigning in ComponentState) then begin
        ComPort.RegisterUserEx(Handle);
        if (FComPort.MasterTerminal = nil) then
          FComPort.MasterTerminal := Self;
        if Active then
          tmAttachToComPort;
      end;
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetCursorType(aValue : TAdCursorType);
begin
  if (aValue <> CursorType) then begin
    tmHideCaret;
    tmFreeCaret;
    FCursorType := aValue;
    tmMakeCaret;
    tmShowCaret;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetEmulator(aValue : TAdTerminalEmulator);
var
  OldRowCount : integer;                                       
  OldColCount : integer;                                       
  OldSVRowCount : integer;                                     
begin
  if not Assigned (FEmulator) then                                       {!!.03}
    Exit;                                                                {!!.03}
  if not Assigned (FEmulator.Buffer) then                                {!!.03}
    Exit;                                                                {!!.03}
  if (aValue <> Emulator) then begin
    if HandleAllocated then
      FHeartbeat.Enabled := false;
    {if we were attached to an emulator, remove its link}
    OldSVRowCount := FEmulator.Buffer.SVRowCount;              
    OldRowCount := FEmulator.Buffer.RowCount;                  
    OldColCount := FEmulator.Buffer.ColCount;                  
    if (Emulator <> nil) then begin
      if (Assigned (FEmulator)) and                                      {!!.05}
         (Assigned (FEmulator.Buffer)) and                               {!!.05}
         HandleAllocated and                                             {!!.05}
         (not (csDestroying in ComponentState)) then                     {!!.05}
        FEmulator.Buffer.DeregisterTerminalHandle;                       {!!.05}
      FEmulator := nil; {to stop recursion with the next call}
      RemoveTermEmuLink(Self, true);
    end;
    {attach ourselves to the new emulator}
    if (aValue = nil) then begin                                         {!!.05}
      FEmulator := FDefEmulator;                                         {!!.05}
      if (Assigned (FEmulator)) and                                      {!!.05}
         (Assigned (FEmulator.Buffer)) and                               {!!.05}
         HandleAllocated and                                             {!!.05}
         (not (csDestroying in ComponentState)) then                     {!!.05}
        FEmulator.Buffer.RegisterTerminalHandle (Self.Handle);           {!!.05}
    end else begin                                                       {!!.05}
      FEmulator := aValue;
      if (Assigned (FEmulator)) and                                      {!!.05}
         (Assigned (FEmulator.Buffer)) and                               {!!.05}
         HandleAllocated and                                             {!!.05}
         (not (csDestroying in ComponentState)) then                     {!!.05}
        FEmulator.Buffer.RegisterTerminalHandle (Self.Handle);           {!!.05}
      AddTermEmuLink(Self, Emulator);
    end;
    {set the new emulator up}                                 
    if (OldSVRowCount > 0) then begin                         
      FEmulator.Buffer.SVRowCount := OldSVRowCount;           
      FEmulator.Buffer.RowCount := OldRowCount;               
      FEmulator.Buffer.ColCount := OldColCount;               
    end;
    if HandleAllocated then begin
      FHeartbeat.Enabled := true;
      if (csDesigning in ComponentState) then
        tmDrawDefaultText;
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetFollowCursor (const v : Boolean);       {!!.03}
begin                                                                    {!!.03}
  if v <> FFollowCursor then begin                                       {!!.03}
    FFollowCursor := v;                                                  {!!.03}
    tmFollowCursor;                                                      {!!.03}
  end;                                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmSetForeColor(aRow, aCol : integer;
                                     aValue     : TColor);
var
  ColorArray : PadtLongArray;
begin
  if (FEmulator.Buffer <> nil) then begin
    ColorArray := FEmulator.Buffer.GetLineForeColorPtr(aRow);
    TColor(ColorArray^[pred(aCol)]) := aValue;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetHideScrollbars (const v : Boolean);     {!!.03}
begin                                                                    {!!.03}
  if v <> FHideScrollbars then begin                                     {!!.03}
    FHideScrollbars := v;                                                {!!.03}
    if tmNeedVScrollBar then                                             {!!.03}
      tmInitVScrollbar                                                   {!!.03}
    else                                                                 {!!.03}
      tmRemoveVScrollbar;                                                {!!.03}
    if tmNeedHScrollbar then                                             {!!.03}
      tmInitHScrollbar                                                   {!!.03}
    else                                                                 {!!.03}
      tmRemoveHScrollbar;                                                {!!.03}
  end;                                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmSetLazyByteDelay(aValue : integer);
begin
  if (0 < aValue) and (aValue <= 1024) and
     (aValue <> LazyByteDelay) then begin
    FLazyByteDelay := aValue;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetLazyTimeDelay(aValue : integer);
begin
  if (0 < aValue) and (aValue <= 1000) and
     (aValue <> LazyTimeDelay) then begin
    FLazyTimeDelay := aValue;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetLine(aRow : integer; const aValue : Ansistring);
var
  CharArray : PAnsiChar;
  StLen     : integer;
  i         : integer;
begin
  if (FEmulator.Buffer <> nil) then begin
    CharArray := FEmulator.Buffer.GetLineCharPtr(aRow);
    StLen := length(aValue);
    if (StLen > FEmulator.Buffer.ColCount) then
      Move(aValue[1], CharArray[0], FEmulator.Buffer.ColCount)
    else begin
      Move(aValue[1], CharArray[0], StLen);
      for i := StLen to pred(FEmulator.Buffer.ColCount) do
        CharArray[i] := ' ';
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetMouseSelect (const v : Boolean);        {!!.03}
begin                                                                    {!!.03}
  if v <> FMouseSelect then begin                                        {!!.03}
    FMouseSelect := v;                                                   {!!.03}
    FLButtonDown := False;                                               {!!.05}
    if not v then begin                                                  {!!.05}
      if (Assigned (FEmulator)) and                                      {!!.05}
         (Assigned (FEmulator.Buffer)) then                              {!!.05}
        HideSelection;                                                   {!!.03}
    end;                                                                 {!!.05}
  end;                                                                   {!!.03}
end;                                                                     {!!.03}
{--------}
procedure TAdCustomTerminal.tmSetOriginCol(aValue : integer);
var
  MaxOriginCol : integer;
  OldOrigin    : integer;
begin
  if (aValue <> ClientOriginCol) then begin
    {work out the maximum value}
    MaxOriginCol := Columns - FClientFullCols + 1;
    if (MaxOriginCol < 1) then
      MaxOriginCol := 1;
    {save the old value}
    OldOrigin := FOriginCol;
    {set the new value}
    if (aValue < 1) then
      FOriginCol := 1
    else if (aValue > MaxOriginCol) then
      FOriginCol := MaxOriginCol
    else
      FOriginCol := aValue;
    {scroll the window, set the scrollbar position}
    if (OldOrigin <> ClientOriginCol) then begin
      tmScrollHorz((OldOrigin - ClientOriginCol) * GetTotalCharWidth);   {!!.06}
      tmCalcExtent;
      with FScrollHorzInfo do begin
        fMask := SIF_POS;
        nPos := ClientOriginCol-1;
      end;
      SetScrollInfo(Handle, SB_HORZ, FScrollHorzInfo, true);
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetOriginRow(aValue : integer);
var
  MinOriginRow : integer;
  MaxOriginRow : integer;
  OldOrigin    : integer;
begin
  if (aValue <> ClientOriginRow) then begin
    {work out the minimum value}
    if FUseVScrollBar and (not Scrollback) then
      MinOriginRow := 1
    else
      MinOriginRow := Rows - ScrollbackRows + 1;
    {work out the maximum value}
    MaxOriginRow := Rows - FClientFullRows + 1;
    if (MaxOriginRow < 1) then
      MaxOriginRow := 1;
    {save the old value}
    OldOrigin := FOriginRow;
    {set the new value}
    if (aValue < MinOriginRow) then
      FOriginRow := MinOriginRow
    else if (aValue > MaxOriginRow) then
      FOriginRow := MaxOriginRow
    else
      FOriginRow := aValue;
    {scroll the window, set the scrollbar position}
    if (OldOrigin <> ClientOriginRow) then begin
      tmScrollVert((OldOrigin - ClientOriginRow) * GetTotalCharHeight);  {!!.06}
      tmCalcExtent;
      with FScrollVertInfo do begin
        fMask := SIF_POS;
        nPos := ClientOriginRow-1;
      end;
      SetScrollInfo(Handle, SB_VERT, FScrollVertInfo, true);
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetPasteToPort (const v : Boolean);        {!!.04}
begin                                                                    {!!.04}
  if v <> FPasteToPort then                                              {!!.04}
    FPasteToPort := v;                                                   {!!.04}
end;                                                                     {!!.04}
{--------}
procedure TAdCustomTerminal.tmSetPasteToScreen (const v : Boolean);      {!!.04}
begin                                                                    {!!.04}
  if v <> FPasteToScreen then                                            {!!.04}
    FPasteToScreen := v;                                                 {!!.04}
end;                                                                     {!!.04}
{--------}
procedure TAdCustomTerminal.tmSetRows(aValue : integer);
var
  OldValue : integer;
begin
  if (FEmulator.Buffer <> nil) and
     (aValue > 0) then begin
    OldValue := FEmulator.Buffer.RowCount;
    if (OldValue <> aValue) then begin
      FEmulator.Buffer.RowCount := aValue;
      tmCalcExtent;
      Invalidate;
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetScrollback(aValue : boolean);
begin
  if (aValue <> Scrollback) then begin
    FScrollback := aValue;
    if tmNeedVScrollbar then                                             {!!.03}
      tmInitVScrollBar                                                   {!!.03}
    else                                                                 {!!.03}
      tmRemoveVScrollBar;                                                {!!.03}
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetScrollbackRows(aValue : integer);
begin
  if (FEmulator.Buffer <> nil) and (aValue > 0) then
    FEmulator.Buffer.SVRowCount := aValue;
end;
{--------}
procedure TAdCustomTerminal.tmSetUseLazyDisplay(aValue : boolean);
begin
  FUseLazyDisplay := aValue;
end;
{--------}
procedure TAdCustomTerminal.tmSetWantAllKeys(aValue : boolean);
begin
  if (aValue <> WantAllKeys) then begin
    FWantAllKeys := aValue;
  end;
end;
{--------}
procedure TAdCustomTerminal.tmSetFreezeScrollBack (v : boolean);
begin
  if (v <> FFreezeScrollBack) then
    FFreezeScrollBack := v;
end;
{--------}
procedure TAdCustomTerminal.tmShowCaret;
begin
  if (not FShowingCaret) and FCreatedCaret and
     (not (csDesigning in ComponentState)) and
     Focused then
    tmPositionCaret;
end;
{--------}
procedure TAdCustomTerminal.tmStartSelect(X, Y : integer);
begin
  {clear the current selection}
  if (FLButtonRect.Left > 0) and                                         {!!.03}
     (FLButtonRect.Top > Rows - ScrollbackRows ) and                     {!!.03}
     (FLButtonRect.Bottom > Rows - ScrollbackRows) and                   {!!.03}
     (FLButtonRect.Right > 0) then                                       {!!.03}
    HideSelection;
  {X and Y are mouse coordinates on the terminal display; convert to a
   row/col position}
  FLButtonAnchor.X := (X div GetTotalCharWidth) + ClientOriginCol;       {!!.06}
  FLButtonAnchor.Y := (Y div GetTotalCharHeight) + ClientOriginRow;      {!!.06}
  {reset the current selection}
  FLButtonRect.Left := FLButtonAnchor.X;
  FLButtonRect.Top := FLButtonAnchor.Y;
  FLButtonRect.Right := FLButtonAnchor.X;
  FLButtonRect.Bottom := FLButtonAnchor.Y;
end;
{--------}
procedure TAdCustomTerminal.tmTriggerHandler(Msg, wParam : Cardinal;
                                       lParam : Integer);
var
  Buffer : pointer;
begin
  if (Msg = APW_TRIGGERAVAIL) then begin
    {we get all the data available and buffer it elsewhere}
    Buffer := TaaByteQueue(FByteQueue).PutPeek(wParam);
    ComPort.Dispatcher.GetBlock(Buffer, wParam);
    TaaByteQueue(FByteQueue).AdvanceAfterPut(wParam);
    {tell ourselves that we have more data}
    PostMessage (Handle, APW_TERMSTUFF,                                {!!.04}
                 Integer (TAdCharSource (csPort)), 0);                 {!!.04}
  end;
end;
{--------}
procedure TAdCustomTerminal.WMCancelMode(var Msg : TMessage);
begin
  HideSelection;
  FLButtonDown := false;
end;
{--------}
procedure TAdCustomTerminal.WMCopy(var Msg : TMessage);
begin
  CopyToClipboard;
  Msg.Result := 1;
end;
{--------}
procedure TAdCustomTerminal.WMEraseBkgnd(var Msg : TMessage);
begin
  Msg.Result := 1
end;
{--------}
procedure TAdCustomTerminal.WMGetDlgCode(var Msg : TMessage);
begin
  {we want as many keys as we can get for the emulatation}
  if WantAllKeys then
    Msg.Result := DLGC_WANTALLKEYS +
                  DLGC_WANTARROWS +
                  DLGC_WANTCHARS +
                  DLGC_WANTMESSAGE +
                  DLGC_WANTTAB
  else
    inherited;
end;
{--------}
procedure TAdCustomTerminal.WMHScroll(var Msg : TWMScroll);
var
  PageSize : integer;
  NewPos   : integer;
  MaxOriginCol : integer;
begin
  PageSize := FClientFullCols;
  MaxOriginCol := Columns - PageSize + 1;
  case Msg.ScrollCode of
    SB_LINELEFT      : NewPos := ClientOriginCol - 1;
    SB_LINERIGHT     : NewPos := ClientOriginCol + 1;
    SB_PAGELEFT      : NewPos := ClientOriginCol - PageSize;
    SB_PAGERIGHT     : NewPos := ClientOriginCol + PageSize;
    SB_THUMBPOSITION : NewPos := Msg.Pos + 1;
    SB_THUMBTRACK    : NewPos := Msg.Pos + 1;
  else
    Exit; {ignore it}
  end;
  if (NewPos < 1) then
    NewPos := 1
  else if (NewPos > MaxOriginCol) then
    NewPos := MaxOriginCol;
  if (NewPos <> ClientOriginCol) then
    ClientOriginCol := NewPos;
end;
{--------}
procedure TAdCustomTerminal.WMKillFocus(var Msg: TWMSetFocus);
begin
  tmHideCaret;
  tmFreeCaret;
  inherited;
end;
{--------}
procedure TAdCustomTerminal.WMPaint(var Msg : TWMPaint);
begin
  PaintHandler(Msg);
end;
{--------}
procedure TAdCustomTerminal.WMPaste (var Msg : TWMPaste);                {!!.04}
begin                                                                    {!!.04}
  PasteFromClipboard;                                                    {!!.04}
end;                                                                     {!!.04}
{--------}
procedure TAdCustomTerminal.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  if not FCreatedCaret then
    tmHideCaret;
    tmMakeCaret;
  if not FShowingCaret then
    tmShowCaret;
end;
{--------}
procedure TAdCustomTerminal.WMSize(var Msg : TWMSize);
begin
  if (GetTotalCharWidth > 0) then begin                                  {!!.06}
    {calculate the new values for the extent of the window}
    tmCalcExtent;
    {if the current origin column is not 1 and we can show more of the
     terminal if it were less, then do so}
    if (ClientOriginCol > 1) then begin
      if ((ClientCols * GetTotalCharWidth) < ClientWidth) then           {!!.06}
        ClientOriginCol := Columns -                                     {!!.06}
                           (ClientWidth div GetTotalCharWidth) + 1;      {!!.06}
    end;
    {if the current origin row is not 1 and we can show more of the
     terminal if it were less, then do so}
    if (ClientOriginRow > 1) then begin
      if ((ClientRows * GetTotalCharHeight) < ClientHeight) then         {!!.06}
        ClientOriginRow := Rows -                                        {!!.06}
                          (ClientHeight div GetTotalCharHeight) + 1;     {!!.06}
    end;
  end;
end;
{--------}
procedure TAdCustomTerminal.WMVScroll(var Msg : TWMScroll);
var
  PageSize : integer;
  NewPos   : integer;
  MinOriginRow : integer;
  MaxOriginRow : integer;
begin
  {if we've a vertical scrollbar because the window is smaller than
   the terminal screen...}
  if FUseVScrollBar then begin
    {if we're not currently going through the scrollback buffer and
     the current origin row is 1 and the user clicks the up arrow on
     the scrollbar, auto switch into scrollback mode}
    if (not Scrollback) and (FAutoScrollback) then begin                 {!!.03}
      if (Msg.ScrollCode = SB_LINEUP) and (ClientOriginRow = 1) then
        Scrollback := true;
    end
    {if we're currently going through the scrollback buffer and the
     current origin row is greater than 1, auto switch into
     non-scrollback mode}
    else if Scrollback and FAutoScrollback then begin                    {!!.03}
      if (ClientOriginRow > 1) then
        Scrollback := false;
    end;
  end;

  PageSize := FClientFullRows;
  if FUseVScrollBar and (not Scrollback) then
    MinOriginRow := 1
  else
    MinOriginRow := Rows - ScrollbackRows - 1;
  MaxOriginRow := Rows - PageSize + 1;
  if (MaxOriginRow < 1) then
    MaxOriginRow := 1;
  case Msg.ScrollCode of
    SB_LINEUP        : NewPos := ClientOriginRow - 1;
    SB_LINEDOWN      : NewPos := ClientOriginRow + 1;
    SB_PAGEUP        : NewPos := ClientOriginRow - PageSize;
    SB_PAGEDOWN      : NewPos := ClientOriginRow + PageSize;
    SB_THUMBPOSITION : NewPos := Msg.Pos + 1;
    SB_THUMBTRACK    : NewPos := Msg.Pos + 1;
  else
    Exit; {if anything else, ignore it}
  end;
  if (NewPos < MinOriginRow) then
    NewPos := MinOriginRow
  else if (NewPos > MaxOriginRow) then
    NewPos := MaxOriginRow;
  if (NewPos <> ClientOriginRow) then
    ClientOriginRow := NewPos;
end;
{--------}
procedure TAdCustomTerminal.WriteChar(aCh : AnsiChar);
begin
  {stuff the data into the byte queue}
  TaaByteQueue(FByteQueue).Put(aCh, sizeof(AnsiChar));
  {tell ourselves that we have more data}
  PostMessage (Handle, APW_TERMSTUFF,                                  {!!.04}
               Integer (TAdCharSource (csWriteChar)), 0);              {!!.04}
end;
{--------}
procedure TAdCustomTerminal.WriteString(const aSt : string);
begin
  WriteString(AnsiString(ASt));
end;
{--------}
procedure TAdCustomTerminal.WriteString(const aSt : AnsiString);
begin
  {stuff the data into the byte queue}
  TaaByteQueue(FByteQueue).Put(ASt[1], length(ASt));
  {tell ourselves that we have more data}
  PostMessage (Handle, APW_TERMSTUFF,                                  {!!.04}
               Integer (TAdCharSource (csWriteChar)), 0);              {!!.04}
end;
{--------}                                                                  // SWB
procedure TAdCustomTerminal.WriteCharSource(aCh : AnsiChar;                 // SWB
                                            Source:TAdCharSource);          // SWB
begin                                                                       // SWB
  {stuff the data into the byte queue}                                      // SWB
  TaaByteQueue(FByteQueue).Put(aCh, sizeof(AnsiChar));                      // SWB
  {tell ourselves that we have more data}                                   // SWB
  PostMessage (Handle, APW_TERMSTUFF,                                       // SWB
               Integer (Source), 0);                                        // SWB
end;                                                                        // SWB
{--------}                                                                  // SWB
procedure TAdCustomTerminal.WriteStringSource(const aSt : AnsiString;           // SWB
                                              Source:TAdCharSource);        // SWB
begin                                                                       // SWB
  {stuff the data into the byte queue}                                      // SWB
  TaaByteQueue(FByteQueue).Put(aSt[1], length(aSt));                        // SWB
  {tell ourselves that we have more data}                                   // SWB
  PostMessage (Handle, APW_TERMSTUFF,                                       // SWB
               Integer (Source), 0);                                        // SWB
end;                                                                        // SWB
{--------}
{ Required for Keyboard Hook in APAX }
function TAdCustomTerminal.HasFocus : Boolean;
begin
  Result := Focused;
end;

{====================================================================}


{===TAdTerminalEmulator==============================================}
constructor TAdTerminalEmulator.Create(aOwner : TComponent);
begin
  inherited Create(aOwner);

  FCommandList := TAdEmuCommandList.Create (Self);
  FAnswerback := adc_VT100Answerback;                                    {!!.06}
end;
{--------}
destructor TAdTerminalEmulator.Destroy;
begin
  if not FIsDefault then
    Terminal := nil;

  FCommandList.Free;

  inherited Destroy;
end;
{--------}
procedure TAdTerminalEmulator.BlinkPaint(aVisible : boolean);
begin
  {do nothing}
end;
{--------}
procedure TAdTerminalEmulator.DefineProperties (Filer : TFiler);         {!!.06}
begin                                                                    {!!.06}
  inherited DefineProperties (Filer);                                    {!!.06}

  Filer.DefineProperty ('Answerback',                                    {!!.06}
                        ReadAnswerback,                                  {!!.06}
                        WriteAnswerback,                                 {!!.06}
                        Answerback = '');                                {!!.06}
end;                                                                     {!!.06}
{--------}
procedure TAdTerminalEmulator.ExecuteTerminalCommands (                  {!!.04}
              CommandList : TAdEmuCommandList);                          {!!.04}
begin                                                                    {!!.04}
  teProcessCommandList (CommandList);                                    {!!.04}
  if Assigned (Terminal) then                                            {!!.04}
    Terminal.Repaint;                                                    {!!.04}
end;                                                                     {!!.04}
{--------}
function TAdTerminalEmulator.HasBlinkingText : boolean;
begin
  Result := false;
end;
{--------}
function TAdTerminalEmulator.IsAnswerbackStored : Boolean;               {!!.06}
begin                                                                    {!!.06}
  Result := Answerback <> adc_VT100Answerback;                           {!!.06}
end;                                                                     {!!.06}
{--------}
procedure TAdTerminalEmulator.KeyDown(var Key : word; Shift: TShiftState);
begin
  {do nothing}
end;
{--------}
procedure TAdTerminalEmulator.KeyPress(var Key : Char);
begin
  {do nothing}
end;
{--------}
procedure TAdTerminalEmulator.LazyPaint;
begin
  {do nothing}
end;
{--------}
procedure TAdTerminalEmulator.Notification(AComponent : TComponent;
                                           Operation  : TOperation);
begin
  if (Operation = opRemove) and (AComponent = Terminal) then begin
    FTerminal := nil;
  end;
  if (Operation = opInsert) and
     (AComponent is TAdTerminal) and
     (Terminal = nil) then begin
    Terminal := TAdTerminal(AComponent);
  end;
  inherited Notification(AComponent, Operation);
end;
{--------}
procedure TAdTerminalEmulator.Paint;
begin
  {do nothing}
end;
{--------}
procedure TAdTerminalEmulator.ProcessBlock (aData      : pointer;      {!!.04}
                                            aDataLen   : Integer;      {!!.04}
                                            CharSource : TAdCharSource);{!!.04}
begin
  {do nothing}
end;
{--------}
procedure TAdTerminalEmulator.GetCursorPos(var aRow, aCol: Integer);
begin
  {do nothing}
end;
{--------}
procedure TAdTerminalEmulator.ReadAnswerback (Reader : TReader);         {!!.06}
begin                                                                    {!!.06}
  Answerback := Reader.ReadString;                                       {!!.06}
end;                                                                     {!!.06}
{--------}
procedure TAdTerminalEmulator.teClear;
begin
  {do nothing};
end;
{--------}
procedure TAdTerminalEmulator.teClearAll;
begin
  {do nothing};
end;
{--------}
procedure TAdTerminalEmulator.teClearCommandList;
begin
  FCommandList.Clear;
end;
{--------}
function TAdTerminalEmulator.teGetNeedsUpdate : boolean;
begin
  Result := Buffer.HasDisplayChanged or Buffer.HasCursorMoved;
end;
{--------}
procedure TAdTerminalEmulator.teHandleCursorMovement (Sender : TObject;
                                                      Row    : Integer;
                                                      Col    : Integer);
{ HandleCursorMovement
  Method is called by the Terminal Buffer's OnCursorMoved event}
var                                                                      {!!.03}
  Changed : Boolean;                                                     {!!.03}

begin
  { Handle scroll bars if the cursor moves out of range }
  Changed := False;                                                      {!!.03}

  if Assigned (FTerminal) then begin                                     {!!.03}
    if (not FTerminal.UseLazyDisplay) then                               {!!.05}
      PostMessage (FTerminal.Handle, apw_TermNeedsUpdate, 0, 1);         {!!.05}

    if FTerminal.FFollowCursor then                                      {!!.03}
      FTerminal.tmFollowCursor;                                          {!!.03}
  end;                                                                   {!!.03}

  if Assigned (FTerminal) then begin                                     {!!.03}
    if FTerminal.HideScrollbars then begin                               {!!.03}
      if (Row > FTerminal.FClientFullRows) and                           {!!.03}
         (not FTerminal.FHideScrollBarVActive) then begin                {!!.03}
        FTerminal.FHideScrollBarVActive := True;                         {!!.03}
        Changed := True;                                                 {!!.03}
      end else if (Row <= FTerminal.FClientFullRows) and                 {!!.03}
                  (FTerminal.FHideScrollBarVActive) then begin           {!!.03}
        FTerminal.FHideScrollBarVActive := False;                        {!!.03}
        Changed := True;                                                 {!!.03}
      end;                                                               {!!.03}

      if (Col > FTerminal.FClientFullCols) and                           {!!.03}
         (not FTerminal.FHideScrollbarHActive) then begin                {!!.03}
        FTerminal.FHideScrollbarHActive := True;                         {!!.03}
        Changed := True;                                                 {!!.03}
      end else if (Col <= FTerminal.FClientFullCols) and                 {!!.03}
                  (FTerminal.FHideScrollbarHActive) then begin           {!!.03}
        FTerminal.FHideScrollbarHActive := False;                        {!!.03}
        Changed := True;                                                 {!!.03}
      end;                                                               {!!.03}

      if Changed then begin                                              {!!.03}
        if FTerminal.tmNeedVScrollbar then                               {!!.03}
          FTerminal.tmInitVScrollBar                                     {!!.03}
        else                                                             {!!.03}
          FTerminal.tmRemoveVScrollBar;                                  {!!.03}
        if FTerminal.tmNeedHScrollbar then                               {!!.03}
          FTerminal.tmInitHScrollBar                                     {!!.03}
        else                                                             {!!.03}
          FTerminal.tmRemoveHScrollBar;                                  {!!.03}
      end;                                                               {!!.03}
    end;                                                                 {!!.03}
  end;                                                                   {!!.03}

  { Fire the OnCursorMoved event }
  if assigned (FTerminal) then begin
    if assigned (FTerminal.FOnCursorMoved) then
      FTerminal.OnCursorMoved (Sender, Row, Col);
  end;
end;
{--------}
procedure TAdTerminalEmulator.teProcessCommand (Command : TAdEmuCommand; {!!.04}
                                                Params  : TAdEmuCommandParams);{!!.04}

  function InvertAttrSetItem (var ASet  : TAdTerminalCharAttrs;          {!!.04}
                                  AItem : TAdTerminalCharAttr) : TAdTerminalCharAttrs; {!!.04}
  begin                                                                {!!.04}
    if AItem in ASet then                                              {!!.04}
      ASet := ASet - [AItem]                                           {!!.04}
    else                                                               {!!.04}
      ASet := ASet + [AItem];                                          {!!.04}
    Result := ASet;                                                    {!!.04}
  end;                                                                 {!!.04}

  function GetBooleanArg (aName : string; aPosition : Integer;         {!!.04}
                          aDefault : Boolean) : Boolean;               {!!.04}
  begin                                                                {!!.04}
    Result := aDefault;                                                {!!.04}

    if not Assigned (Params) then                                      {!!.04}
      Exit;                                                            {!!.04}

    Result := Params.GetBooleanValue (aName, aPosition, aDefault);     {!!.04}
  end;                                                                 {!!.04}

  function GetIntegerArg (aName : string; aPosition : Integer;         {!!.04}
                          aDefault : Integer) : Integer;               {!!.04}
  begin                                                                {!!.04}
    Result := aDefault;                                                {!!.04}

    if not Assigned (Params) then                                      {!!.04}
      Exit;                                                            {!!.04}

    Result := Params.GetIntegerValue (aName, aPosition, aDefault);     {!!.04}
  end;                                                                 {!!.04}

  function GetStringArg (aName : string; aPosition : Integer;          {!!.04}
                         aDefault : string) : string;                  {!!.04}
  begin                                                                {!!.04}
    Result := aDefault;                                                {!!.04}

    if not Assigned (Params) then                                      {!!.04}
      Exit;                                                            {!!.04}

    Result := Params.GetStringValue (aName, aPosition, aDefault);      {!!.04}
  end;                                                                 {!!.04}

  function GetTColorArg (aName : string; aPosition : Integer;          {!!.04}
                         aDefault : TColor) : TColor;                  {!!.04}
  begin                                                                {!!.04}
    Result := aDefault;                                                {!!.04}

    if not Assigned (Params) then                                      {!!.04}
      Exit;                                                            {!!.04}

    Result := Params.GetTColorValue (aName, aPosition, aDefault);      {!!.04}
  end;                                                                 {!!.04}

var                                                                    {!!.04}
  CharAttrs  : TAdTerminalCharAttrs;                                   {!!.04}
  OldDefChar : AnsiChar;                                               {!!.04}
  i          : Integer;

begin
  {Assumption: aCh is less than space, i.e., is one of the unprintable
               characters}
  case Command of                                                      {!!.04}
    ecBell : {bell}                                                    {!!.04}
      MessageBeep(MB_ICONASTERISK);                                    {!!.04}
    ecBackspace : {backspace}                                          {!!.04}
      Buffer.DoBackspace;                                              {!!.04}
    ecTabHorz : {tab}                                                  {!!.04}
      Buffer.DoHorzTab;                                                {!!.04}
    ecLF : {linefeed}                                                  {!!.04}
      Buffer.DoLineFeed;                                               {!!.04}
    ecCR : {carriage return}                                           {!!.04}
      Buffer.DoCarriageReturn;                                         {!!.04}
    ecBackTabHorz :                                                    {!!.04}
      Buffer.DoBackHorzTab;                                            {!!.04}
    ecCursorDown :                                                     {!!.04}
      Buffer.MoveCursorDown (GetBooleanArg ('Scroll', 0, False));      {!!.04}
    ecCursorLeft :                                                     {!!.04}
      Buffer.MoveCursorLeft (GetBooleanArg ('Wrap', 0, False),         {!!.04}
                             GetBooleanArg ('Scroll', 1, False));      {!!.04}
    ecCursorRight :                                                    {!!.04}
      Buffer.MoveCursorRight (GetBooleanArg ('Wrap', 0, False),        {!!.04}
                              GetBooleanArg ('Scroll', 1, False));     {!!.04}
    ecCursorUp :                                                       {!!.04}
      Buffer.MoveCursorUp (GetBooleanArg ('Scroll', 0, False));        {!!.04}
    ecCursorPos :                                                      {!!.04}
      Buffer.SetCursorPosition (GetIntegerArg ('Row', 0, 1),           {!!.04}
                                GetIntegerArg ('Col', 1, 1));          {!!.04}
    ecDeleteChars :                                                    {!!.04}
      Buffer.DeleteChars (GetIntegerArg ('Count', 0, 1));              {!!.04}
    ecDeleteLines :                                                    {!!.04}
      Buffer.DeleteLines (GetIntegerArg ('Count', 0, 1));              {!!.04}
    ecInsertChars :                                                    {!!.04}
      Buffer.InsertChars (GetIntegerArg ('Count', 0, 1));              {!!.04}
    ecInsertLines :                                                    {!!.04}
      Buffer.InsertLines (GetIntegerArg ('Count', 0, 1));              {!!.04}
    ecEraseAll :                                                       {!!.04}
      Buffer.EraseAll;                                                 {!!.04}
    ecEraseChars :                                                     {!!.04}
      Buffer.EraseChars (GetIntegerArg ('Count', 0, 1));               {!!.04}
    ecEraseFromBOW :                                                   {!!.04}
      Buffer.EraseFromBOW;                                             {!!.04}
    ecEraseFromBOL :                                                   {!!.04}
      Buffer.EraseFromBOL;                                             {!!.04}
    ecEraseLine :                                                      {!!.04}
      Buffer.EraseLine;                                                {!!.04}
    ecEraseScreen :                                                    {!!.04}
      Buffer.EraseScreen;                                              {!!.04}
    ecEraseToEOL :                                                     {!!.04}
      Buffer.EraseToEOL;                                               {!!.04}
    ecEraseToEOW :                                                     {!!.04}
      Buffer.EraseToEOW;                                               {!!.04}
    ecSetHorzTabStop :                                                 {!!.04}
      Buffer.SetHorzTabStop;                                           {!!.04}
    ecClearHorzTabStop :                                               {!!.04}
      Buffer.ClearHorzTabStop;                                         {!!.04}
    ecClearVertTabStop :                                               {!!.04}
      Buffer.ClearVertTabStop;                                         {!!.04}
    ecClearAllHorzTabStops :                                           {!!.04}
      Buffer.ClearAllHorzTabStops;                                     {!!.04}
    ecSetVertTabStop :                                                 {!!.04}
      Buffer.SetVertTabStop;                                           {!!.04}
    ecClearAllVertTabStops :                                           {!!.04}
      Buffer.ClearAllVertTabStops;                                     {!!.04}
    ecSetScrollRegion :                                                {!!.04}
      Buffer.SetScrollRegion (GetIntegerArg ('Top', 0, 1),             {!!.04}
                              GetIntegerArg ('Bottom', 1, 1));         {!!.04}
    ecTabVert :                                                        {!!.04}
      Buffer.DoVertTab;                                                {!!.04}
    ecBackTabVert :                                                    {!!.04}
      Buffer.DoBackVertTab;                                            {!!.04}
    ecBackColor : begin                                                {!!.04}
      Buffer.BackColor := GetTColorArg ('Color', 0, clBlack);          {!!.04}
      if GetBooleanArg ('Persistent', 1, True) and                     {!!.04}
         Assigned (Terminal) then                                      {!!.04}
        Terminal.Color := Buffer.BackColor;                            {!!.04}
    end;                                                               {!!.04}
    ecForeColor : begin                                                {!!.04}
      Buffer.ForeColor := GetTColorArg ('Color', 0, clSilver);         {!!.04}
      if GetBooleanArg ('Persistent', 1, True) and                     {!!.04}
         Assigned (Terminal) then                                      {!!.04}
        Terminal.Font.Color := Buffer.ForeColor;                       {!!.04}
    end;                                                               {!!.04}
    ecAbsAddress :                                                     {!!.04}
      Buffer.UseAbsAddress := True;                                    {!!.04}
    ecNoAbsAddress :                                                   {!!.04}
      Buffer.UseAbsAddress := False;                                   {!!.04}
    ecAutoWrap :                                                       {!!.04}
      Buffer.UseAutoWrap := True;                                      {!!.04}
    ecNoAutoWrap :                                                     {!!.04}
      Buffer.UseAutoWrap := False;                                     {!!.04}
    ecAutoWrapDelay :                                                  {!!.04}
      Buffer.UseAutoWrapDelay := True;                                 {!!.04}
    ecNoAutoWrapDelay :                                                {!!.04}
      Buffer.UseAutoWrapDelay := False;                                {!!.04}
    ecInsertMode :                                                     {!!.04}
      Buffer.UseInsertMode := True;                                    {!!.04}
    ecNoInsertMode :                                                   {!!.04}
      Buffer.UseInsertMode := False;                                   {!!.04}
    ecNewLineMode :                                                    {!!.04}
      Buffer.UseNewLineMode := True;                                   {!!.04}
    ecNoNewLineMode :                                                  {!!.04}
      Buffer.UseNewLineMode := False;                                  {!!.04}
    ecScrollRegion :                                                   {!!.04}
      Buffer.UseScrollRegion := True;                                  {!!.04}
    ecNoScrollRegion :                                                 {!!.04}
      Buffer.UseScrollRegion := False;                                 {!!.04}
    ecSetCharAttr : begin                                              {!!.04}
      CharAttrs := [];                                                 {!!.04}
      if GetBooleanArg ('Bold', 0, False) then                         {!!.04}
        Include (CharAttrs, tcaBold);                                  {!!.04}
      if GetBooleanArg ('Underline', 1, False) then                    {!!.04}
        Include (CharAttrs, tcaUnderline);                             {!!.04}
      if GetBooleanArg ('Strikethrough', 2, False) then                {!!.04}
        Include (CharAttrs, tcaStrikethrough);                         {!!.04}
      if GetBooleanArg ('Blink', 3, False) then                        {!!.04}
        Include (CharAttrs, tcaBlink);                                 {!!.04}
      if GetBooleanArg ('Reverse', 4, False) then                      {!!.04}
        Include (CharAttrs, tcaReverse);                               {!!.04}
      if GetBooleanArg ('Invisible', 5, False) then                    {!!.04}
        Include (CharAttrs, tcaInvisible);                             {!!.04}
      if GetBooleanArg ('Selected', 6, False) then                     {!!.04}
        Include (CharAttrs, tcaSelected);                              {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecAddBold : begin                                                  {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs + [tcaBold]);                     {!!.04}
    end;                                                               {!!.04}
    ecBoldOnly :                                                       {!!.04}
      Buffer.SetCharAttrs ([tcaBold]);                                 {!!.04}
    ecRemoveBold : begin                                               {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs - [tcaBold]);                     {!!.04}
    end;                                                               {!!.04}
    ecInvertBold : begin                                               {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      InvertAttrSetItem (CharAttrs, tcaBold);                          {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecAddUnderLine : begin                                             {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs + [tcaUnderline]);                {!!.04}
    end;                                                               {!!.04}
    ecUnderlineOnly :                                                  {!!.04}
      Buffer.SetCharAttrs ([tcaUnderline]);                            {!!.04}
    ecRemoveUnderline : begin                                          {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs - [tcaUnderline]);                {!!.04}
    end;                                                               {!!.04}
    ecInvertUnderline : begin                                          {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      InvertAttrSetItem (CharAttrs, tcaUnderline);                     {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecAddStrikethrough : begin                                         {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs + [tcaStrikethrough]);            {!!.04}
    end;                                                               {!!.04}
    ecStrikethroughOnly :                                              {!!.04}
      Buffer.SetCharAttrs ([tcaStrikethrough]);                        {!!.04}
    ecRemoveStrikethrough : begin                                      {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs - [tcaStrikethrough]);            {!!.04}
    end;                                                               {!!.04}
    ecInvertStrikethrough : begin                                      {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      InvertAttrSetItem (CharAttrs, tcaStrikethrough);                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecAddBlink : begin                                                 {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs + [tcaBlink]);                    {!!.04}
    end;                                                               {!!.04}
    ecBlinkOnly :                                                      {!!.04}
      Buffer.SetCharAttrs ([tcaBlink]);                                {!!.04}
    ecRemoveBlink : begin                                              {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs - [tcaBlink]);                    {!!.04}
    end;                                                               {!!.04}
    ecInvertBlink : begin                                              {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      InvertAttrSetItem (CharAttrs, tcaStrikethrough);                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecAddReverse : begin                                               {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs + [tcaReverse]);                  {!!.04}
    end;                                                               {!!.04}
    ecReverseOnly :                                                    {!!.04}
      Buffer.SetCharAttrs ([tcaReverse]);                              {!!.04}
    ecRemoveReverse : begin                                            {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs - [tcaReverse]);                  {!!.04}
    end;                                                               {!!.04}
    ecInvertReverse : begin                                            {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      InvertAttrSetItem (CharAttrs, tcaReverse);                       {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecAddInvisible : begin                                             {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs + [tcaInvisible]);                {!!.04}
    end;                                                               {!!.04}
    ecInvisibleOnly :                                                  {!!.04}
      Buffer.SetCharAttrs ([tcaInvisible]);                            {!!.04}
    ecRemoveInvisible : begin                                          {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs - [tcaInvisible]);                {!!.04}
    end;                                                               {!!.04}
    ecInvertInvisible : begin                                          {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      InvertAttrSetItem (CharAttrs, tcaInvisible);                     {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecAddSelected : begin                                              {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs + [tcaSelected]);                 {!!.04}
    end;                                                               {!!.04}
    ecRemoveSelected :                                                 {!!.04}
      Buffer.SetCharAttrs ([tcaSelected]);                             {!!.04}
    ecSelectedOnly : begin                                             {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      Buffer.SetCharAttrs (CharAttrs - [tcaSelected]);                 {!!.04}
    end;                                                               {!!.04}
    ecInvertSelected : begin                                           {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      InvertAttrSetItem (CharAttrs, tcaSelected);                      {!!.04}
      Buffer.SetCharAttrs (CharAttrs);                                 {!!.04}
    end;                                                               {!!.04}
    ecRemoveAllAttr :                                                  {!!.04}
      Buffer.SetCharAttrs ([]);                                        {!!.04}
    ecRemoveAllAttrIgnoreSelect : begin                                {!!.04}
      Buffer.GetCharAttrs (CharAttrs);                                 {!!.04}
      if tcaSelected in CharAttrs then                                 {!!.04}
        Buffer.SetCharAttrs ([tcaSelected])                            {!!.04}
      else                                                             {!!.04}
        Buffer.SetCharAttrs ([]);                                      {!!.04}
    end;                                                               {!!.04}
    ecHome :                                                           {!!.04}
      Buffer.SetCursorPosition (1, 1);                                 {!!.04}
    ecClearAndHome : begin                                             {!!.04}
      Buffer.EraseScreen;                                              {!!.04}
      Buffer.SetCursorPosition (1, 1);                                 {!!.04}
    end;                                                               {!!.04}
    ecCursorEOL :                                                      {!!.04}
      Buffer.Col := Buffer.ColCount;                                   {!!.04}
    ecCursorBOL :                                                      {!!.04}
      Buffer.Col := 1;                                                 {!!.04}
    ecCursorTop :                                                      {!!.04}
      Buffer.Row := 1;                                                 {!!.04}
    ecCursorBottom :                                                   {!!.04}
      Buffer.Row := Buffer.RowCount;                                   {!!.04}
    ecWriteString :                                                    {!!.04}
      Buffer.WriteString (GetStringArg ('String', 0, ''));             {!!.04}
    ecColor : begin                                                    {!!.04}
      Buffer.ForeColor := GetTColorArg ('Fore', 0, clSilver);          {!!.04}
      Buffer.BackColor := GetTColorArg ('Back', 1, clBlack);           {!!.04}
      if GetBooleanArg ('Persistent', 2, True) and                     {!!.04}
         Assigned (Terminal) then begin                                {!!.04}
        Terminal.Font.Color := Buffer.ForeColor;                       {!!.04}
        Terminal.Color := Buffer.BackColor;                            {!!.04}
      end;                                                             {!!.04}
    end;                                                               {!!.04}
    ecSaveCursorPos : begin                                            {!!.04}
      Buffer.GetCharAttrs(FSavedAttrs);                                {!!.04}
      FSavedBackColor := Buffer.BackColor;                             {!!.04}
      FSavedCharSet := Buffer.CharSet;                                 {!!.04}
      FSavedCol := Buffer.Col;                                         {!!.04}
      FSavedForeColor := Buffer.ForeColor;                             {!!.04}
      FSavedRow := Buffer.Row;                                         {!!.04}
    end;                                                               {!!.04}
    ecRestoreCursorPos : begin                                         {!!.04}
      Buffer.SetCharAttrs(FSavedAttrs);                                {!!.04}
      Buffer.BackColor := FSavedBackColor;                             {!!.04}
      Buffer.CharSet := FSavedCharSet;                                 {!!.04}
      Buffer.Col := FSavedCol;                                         {!!.04}
      Buffer.ForeColor := FSavedForeColor;                             {!!.04}
      Buffer.Row := FSavedRow;                                         {!!.04}
    end;                                                               {!!.04}
    ecDeviceStatusReport  : begin                                      {!!.04}
      {we *only* issue a reply if we are the master terminal,
       otherwise if there were several terminals on a form, all
       attached to the same comport, the host would get several
       responses}
      if (Assigned (Terminal)) then begin                                {!!.06}
        if (Terminal.ComPort.MasterTerminal = Terminal) then begin       {!!.04}
          i := GetIntegerArg ('Type', 0, 5);                             {!!.04}
          if (i = 5) then                                                {!!.04}
            Terminal.ComPort.PutString(VT100StatusRpt)                   {!!.04}
          else if (i = 6) then                                           {!!.04}
            Terminal.ComPort.PutString(                                  {!!.04}
               Format(VT100CursorPos, [Buffer.Row, Buffer.Col]));        {!!.04}
        end;                                                             {!!.04}
      end;                                                               {!!.06}
    end;                                                               {!!.04}
    ecDeviceAttributesReport : begin                                   {!!.04}
      {we *only* issue a reply if we are the master terminal,
       otherwise if there were several terminals on a form, all
       attached to the same comport, the host would get several
       responses}
      if (Assigned (Terminal)) then begin                                {!!.06}
        if (Terminal.ComPort.MasterTerminal = Terminal) then begin       {!!.04}
          i := GetIntegerArg ('Type', 0, 0);                             {!!.04}
          if (i = 0) then                                                {!!.04}
            Terminal.ComPort.PutString(VT100DeviceAttrs)                 {!!.04}
          else if (i = 52) then                                          {!!.04}
            Terminal.ComPort.PutString(VT52DeviceAttrs);                 {!!.04}
        end;                                                             {!!.04}
      end;                                                               {!!.06}
    end;                                                               {!!.04}
    ecNEL : begin                                                      {!!.04}
        Buffer.DoLineFeed;                                             {!!.04}
        if not Buffer.UseNewLineMode then                              {!!.04}
          Buffer.DoCarriageReturn;                                     {!!.04}
      end;                                                             {!!.04}
    ecReset : begin                                                    {!!.04}
      Buffer.Reset; {also clears the screen}                           {!!.04}
    end;                                                               {!!.04}
    ecDECALN : begin                                                   {!!.04}
      {scroll buffer up, fill screen with character E's}               {!!.04}
      OldDefChar := Buffer.DefAnsiChar;                                {!!.04}
      Buffer.DefAnsiChar := 'E';                                       {!!.04}
      Buffer.EraseScreen;                                              {!!.04}
      Buffer.DefAnsiChar := OldDefChar;                                {!!.04}
    end;                                                               {!!.04}
    ecAnswerback : begin                                                 {!!.06}
      { we *only* issue a reply if we are the master terminal,        }  {!!.06}
      { otherwise if there were several terminals on a form, all      }  {!!.06}
      { attached to the same comport, the host would get several      }  {!!.06}
      { responses                                                     }  {!!.06}
      if (Assigned (Terminal)) then                                      {!!.06}
        if (Terminal.ComPort.MasterTerminal = Terminal) then begin       {!!.06}
          Terminal.ComPort.PutString (AnsiString(FAnswerback));          {!!.06}
      end;                                                               {!!.06}
    end;                                                                 {!!.06}
    ecCursorOff : begin                                                  {!!.06}
      if (Assigned (Terminal)) then                                      {!!.06}
        Terminal.CursorType := ctNone;                                   {!!.06}
    end;                                                                 {!!.06}
    ecCursorUnderline : begin                                            {!!.06}
      if (Assigned (Terminal)) then                                      {!!.06}
        Terminal.CursorType := ctUnderline;                              {!!.06}
    end;                                                                 {!!.06}
    ecCursorBlock : begin                                                {!!.06}
      if (Assigned (Terminal)) then                                      {!!.06}
        Terminal.CursorType := ctBlock;                                  {!!.06}
    end;                                                                 {!!.06}
  end;{case}
end;
{--------}
procedure TAdTerminalEmulator.teProcessCommandList (                     {!!.04}
              CommandList : TAdEmuCommandList);                          {!!.04}
var                                                                      {!!.04}
  i : Integer;                                                           {!!.04}
begin                                                                    {!!.04}
  for i := 0 to CommandList.Count - 1 do begin                           {!!.04}
    teProcessCommand (TAdEmuCommandListItem (CommandList.Items[i]).Command, {!!.04}
                      TAdEmuCommandListItem (CommandList.Items[i]).Params); {!!.04}
  end;                                                                   {!!.04}
end;                                                                     {!!.04}
{--------}
procedure TAdTerminalEmulator.teSendChar (aCh        : Ansichar;           {!!.04}
                                          aCanEcho   : boolean;        {!!.04}
                                          CharSource : TAdCharSource); {!!.04}
begin
  {Assumptions: aCh is a printable character or is one of the standard
                non-printable characters}
  if (Terminal <> nil) then begin
    if aCanEcho and Terminal.HalfDuplex then
      ProcessBlock(@aCh, 1, CharSource);                               {!!.04}
    if (Terminal.ComPort <> nil) and Terminal.ComPort.Open then
      Terminal.ComPort.PutChar(aCh);
  end;
end;
{--------}
procedure TAdTerminalEmulator.teSetTerminal(aValue : TAdCustomTerminal);
var
  OldTerminal : TAdCustomTerminal;
begin
  if (aValue <> Terminal) then begin
    {if we were attached to a terminal, remove its link}
    if (Terminal <> nil) and (not FIsDefault) then begin
      OldTerminal := Terminal;
      FTerminal := nil; {to stop recursion in the following call}
      RemoveTermEmuLink(OldTerminal, true);
    end;
    FTerminal := aValue;
    {attach ourselves to the new terminal}
    if (Terminal <> nil) and (not FIsDefault) then begin
      if (Terminal.Emulator <> nil) and (Terminal.Emulator <> Self) then
        RemoveTermEmuLink(Terminal, true);
      AddTermEmuLink(Terminal, Self);
    end;
  end;
end;
{--------}
procedure TAdTerminalEmulator.WriteAnswerback (Writer : TWriter);        {!!.06}
begin                                                                    {!!.06}
  Writer.WriteString (Answerback);                                       {!!.06}
end;                                                                     {!!.06}
{====================================================================}


{====================================================================}
constructor TAdTTYEmulator.Create(aOwner : TComponent);
begin
  {Note: the buffer *must* be created before the ancestor can perform
         initialization. The reason is that at design time dropping an
         emulator on the form will cause a series of Notification
         calls to take place. This in turn could cause a terminal's
         tmSetEmulator method to be called, which would then set up
         some default text in the emulator's buffer.}

  {create the buffer}
  FTerminalBuffer := TAdTerminalBuffer.Create(false);

  {now let the ancestor do his stuff}
  inherited Create(aOwner);

  {set up the terminal buffer and ourselves}
  FDisplayStrSize := 256; {enough for standard terminals}
  GetMem(FDisplayStr, FDisplayStrSize);
  GetMem(FCellWidths, 255 * sizeof(integer));
  FillChar(FCellWidths^, 255 * sizeof(integer), 0);

  FTerminalBuffer.OnCursorMoved := teHandleCursorMovement;
end;
{--------}
destructor TAdTTYEmulator.Destroy;
begin
  {free the paint node free list}
  ttyFreeAllPaintNodes;
  {free the cell widths array}
  if (FCellWidths <> nil) then
    FreeMem(FCellWidths, 255 * sizeof(integer));
  {free the display string}
  if (FDisplayStr <> nil) then
    FreeMem(FDisplayStr, FDisplayStrSize);
  {free the internal objects}
  FTerminalBuffer.Free;
  inherited Destroy;
end;
{--------}
procedure TAdTTYEmulator.KeyPress(var Key : Char);
begin
  {send it to the host}
  if (Key = ^H) then
    Key := #127;
  teSendChar(ansiChar(Key), true, csKeyboard);                                   {!!.04}
end;
{--------}
procedure TAdTTYEmulator.LazyPaint;
var
  DirtyRect : TRect;
  Row       : integer;
begin
  {the LazyPaint method is called by the terminal, if and only if
   either of the lazy timers expired; in other words, either a certain
   amount of data has been received by the terminal, or a certain time
   has elapsed since the last update}

  if (Terminal.Color <> Buffer.BackColor) or
     (Terminal.Font.Color <> Buffer.ForeColor) then begin
    Buffer.DefBackColor := Terminal.Color;
    Buffer.DefForeColor := Terminal.Font.Color;
    Buffer.BackColor := Terminal.Color;
    Buffer.ForeColor := Terminal.Font.Color;
    FRefresh := true;
  end;

  {if we have to refresh the display, do it, and throw away all the
   'dirty' data}
  if FRefresh then begin
    FRefresh := false;
    for Row := 1 to Buffer.RowCount do
      ttyDrawChars(Row, 1, Buffer.ColCount, true);
    while Buffer.GetInvalidRect(DirtyRect) do {nothing};
  end
  else begin
    {using the 'dirty' data in the buffer, draw the required
     characters}
    while Buffer.GetInvalidRect(DirtyRect) do begin
      if not Terminal.FreezeScrollBack then begin
        Inc (DirtyRect.Top, Terminal.FScrollVertInfo.nPos);
        Inc (DirtyRect.Bottom, Terminal.FScrollVertInfo.nPos + 1);
      end;
      for Row := DirtyRect.Top to DirtyRect.Bottom do
        ttyDrawChars(Row, DirtyRect.Left, DirtyRect.Right, true);
    end;
  end;
end;
{--------}
procedure TAdTTYEmulator.Paint;
var
  DirtyRect : TRect;
  Row       : integer;
begin
  {the Paint method is called by the terminal, if and only if the
   terminal component received a WM_PAINT message}

  if (Terminal.Color <> Buffer.BackColor) or
     (Terminal.Font.Color <> Buffer.ForeColor) then begin
    Buffer.DefBackColor := Terminal.Color;
    Buffer.DefForeColor := Terminal.Font.Color;
    Buffer.BackColor := Terminal.Color;
    Buffer.ForeColor := Terminal.Font.Color;
    FRefresh := true;
  end;

  {repaint the clip region}
  DirtyRect := Terminal.Canvas.ClipRect;
  with Terminal do begin
    DirtyRect.Left :=
       (DirtyRect.Left div GetTotalCharWidth) + ClientOriginCol;         {!!.06}
    DirtyRect.Right :=
       (pred(DirtyRect.Right) div GetTotalCharWidth) + ClientOriginCol;  {!!.06}
    DirtyRect.Top :=
       (DirtyRect.Top div GetTotalCharHeight) + ClientOriginRow;         {!!.06}
    DirtyRect.Bottom :=
       (pred(DirtyRect.Bottom) div GetTotalCharHeight) + ClientOriginRow;{!!.06}
  end;
  if not Terminal.FreezeScrollBack then begin
    Inc (DirtyRect.Top, Terminal.FScrollVertInfo.nPos);
    Inc (DirtyRect.Bottom, Terminal.FScrollVertInfo.nPos + 1);
  end;
  for Row := DirtyRect.Top to DirtyRect.Bottom do
    ttyDrawChars(Row, DirtyRect.Left, DirtyRect.Right, true);
end;
{--------}
procedure TAdTTYEmulator.ProcessBlock (aData      : pointer;             {!!.04}
                                       aDataLen   : Integer;             {!!.04}
                                       CharSource : TAdCharSource);      {!!.04}
var
  DataAsChar : PAnsiChar absolute aData;
  i          : integer;
  j          : Integer;                                                  {!!.03}
  Ch         : AnsiChar;
  Str        : AnsiString;                                                   {!!.03}
  StrLen     : Integer;                                                  {!!.03}

begin
  for i := 0 to pred (aDataLen) do begin
    Ch := DataAsChar[i];
    SetLength (Str, 1);                                                  {!!.03}
    Str[1] := Ch;                                                        {!!.03}
    teClearCommandList;                                                  {!!.04}
    if Assigned (FOnProcessChar) then                                    {!!.04}
      FOnProcessChar (Self, Ch, Str, FCommandList, CharSource);          {!!.04}
    teProcessCommandList (FCommandList);                                 {!!.04}
    StrLen := Length (Str);                                              {!!.03}
    for j := 1 to StrLen do begin                                        {!!.03}
      Ch := Str[j];                                                      {!!.03}
      if (Ch < ' ') then
        teProcessCommand (ttyCharToCommand (Ch), nil)                    {!!.04}
      else
        Buffer.WriteChar(Ch);                                            {!!.04}
    end;                                                                 {!!.03}
  end;
end;
{--------}
procedure TAdTTYEmulator.teClear;
begin
  Buffer.EraseScreen;
end;
{--------}
procedure TAdTTYEmulator.teClearAll;
begin
  Buffer.EraseAll;
end;
{--------}
function TAdTTYEmulator.teGetNeedsUpdate : boolean;
begin
  Result := Buffer.HasDisplayChanged or FRefresh or
            Buffer.HasCursorMoved;
end;
{--------}
procedure TAdTTYEmulator.teSetTerminal(aValue : TAdCustomTerminal);
begin
  inherited teSetTerminal(aValue);
end;
{--------}
function TAdTTYEmulator.ttyCharToCommand (aCh : AnsiChar) : TAdEmuCommand; {!!.04}
begin                                                                  {!!.04}
  case aCh of                                                          {!!.04}
    ^G : Result := ecBell;                                             {!!.04}
    ^H : Result := ecBackspace;                                        {!!.04}
    ^I : Result := ecTabHorz;                                          {!!.04}
    ^J : Result := ecLF;                                               {!!.04}
    ^M : Result := ecCR;                                               {!!.04}
    else                                                               {!!.04}
      Result := ecNone;                                                {!!.04}
  end;{case}                                                           {!!.04}
end;                                                                   {!!.04}
{--------}
procedure TAdTTYEmulator.ttyDrawChars(aRow, aStartCol, aEndCol : integer;
                                      aVisible : boolean);
var
  ColNum     : integer;
  StartColNum: integer;
  BackColor  : TColor;
  ForeColor  : TColor;
  Attr       : TAdTerminalCharAttrs;
  ForeColors : PadtLongArray;
  BackColors : PadtLongArray;
  Attrs      : PByteArray;
  Script     : PPaintNode;
  PaintNode  : PPaintNode;
begin
  {ASSUMPTION: aStartCol <= aEndCol}

  {avoid any drawing if the row simply is not visible}
  if (aRow < Terminal.ClientOriginRow) or
     (aRow >= Terminal.ClientOriginRow + Terminal.ClientRows) then
    Exit;
  {same if the range of columns is not visible}
  if (aEndCol < Terminal.ClientOriginCol) or
     (aStartCol >= Terminal.ClientOriginCol + Terminal.ClientCols) then
    Exit;

  {if this point is reached, we have to paint *something*}

  {force the parameter values in range}
  if (aStartCol < Terminal.ClientOriginCol) then
    aStartCol := Terminal.ClientOriginCol;
  if (aEndCol > Terminal.ClientOriginCol + Terminal.ClientCols) then
    aEndCol := Terminal.ClientOriginCol + Terminal.ClientCols;

  {this is the main processing: in general we'll be displaying text in
   this section; what will happen here, is that we first generate a
   script of drawing commands (which background color, which text
   color, which attributes, which text), and then we execute the
   script}

  {get the pointers to the colors, the attributes}
  BackColors := Buffer.GetLineBackColorPtr(aRow);
  ForeColors := Buffer.GetLineForeColorPtr(aRow);
  Attrs := Buffer.GetLineAttrPtr(aRow);

  {get the initial values for the display variables}
  BackColor := BackColors^[aStartCol-1];
  ForeColor := ForeColors^[aStartCol-1];
  Attr := TAdTerminalCharAttrs(Attrs^[aStartCol-1]);

  {make a note of the start column}
  StartColNum := aStartCol;
  ColNum := aStartCol;

  {build the script as a stack of paint commands}
  Script := nil;
  while (ColNum < aEndCol) do begin
    {look at the next column}
    inc(ColNum);
    {if any info has changed...}
    if (ForeColor <> ForeColors^[ColNum-1]) or
       (BackColor <> BackColors^[ColNum-1]) or
       (Attr <> TAdTerminalCharAttrs(Attrs^[ColNum-1])) then begin
      {get a new node, initialize it}
      PaintNode := ttyNewPaintNode;
      PaintNode^.pnStart := StartColNum;
      PaintNode^.pnEnd := pred(ColNum);
      PaintNode^.pnFore := ForeColor;
      PaintNode^.pnBack := BackColor;
      PaintNode^.pnAttr := Attr;
      PaintNode^.pnCSet := 0;
      {add it to the script}
      PaintNode^.pnNext := Script;
      Script := PaintNode;
      {save the new values of the variables}
      ForeColor := ForeColors^[ColNum-1];
      BackColor := BackColors^[ColNum-1];
      Attr := TAdTerminalCharAttrs(Attrs^[ColNum-1]);
      StartColNum := ColNum;
    end;
  end;
  {create the final paint command}
  PaintNode := ttyNewPaintNode;
  PaintNode^.pnStart := StartColNum;
  PaintNode^.pnEnd := aEndCol;
  PaintNode^.pnFore := ForeColor;
  PaintNode^.pnBack := BackColor;
  PaintNode^.pnAttr := Attr;
  PaintNode^.pnCSet := 0;
  {add it to the script}
  PaintNode^.pnNext := Script;
  Script := PaintNode;

  {now execute the paint script}
  ttyExecutePaintScript(aRow, Script);
end;
{--------}
procedure TAdTTYEmulator.ttyExecutePaintScript(aRow    : integer;
                                               aScript : pointer);
var
  Canvas       : TCanvas;
  Font         : TFont;
  Walker, Temp : PPaintNode;
  ForeColor    : TColor;
  BackColor    : TColor;
  CharWidth    : integer;
  CharHeight   : integer;
  OriginCol    : integer;
  TextStrLen   : integer;
  TextChars    : PAnsiChar;
  WorkRect     : TRect;
  Y            : integer;
  R, G, B      : integer;
  Reversed     : boolean;
begin
  {get some values as local variables}
  Canvas := Terminal.Canvas;
  Font := Terminal.Font;
  TextChars := Buffer.GetLineCharPtr(aRow);
  CharHeight := Terminal.GetTotalCharHeight;                             {!!.06}
  WorkRect.Top := (aRow - Terminal.ClientOriginRow) * CharHeight;
  WorkRect.Bottom := WorkRect.Top + CharHeight;
  CharWidth := Terminal.GetTotalCharWidth;                               {!!.06}
  OriginCol := Terminal.ClientOriginCol;
  {set the cell widths}
  for Y := 0 to pred(Buffer.ColCount) do
    FCellWidths^[Y] := CharWidth;
  {process the script}
  Walker := PPaintNode(aScript);
  while (Walker <> nil) do begin
    {check for reverse}
    Reversed := (tcaReverse in Walker^.pnAttr) xor
                (tcaSelected in Walker^.pnAttr);
    if Reversed then begin
      ForeColor := Walker^.pnBack;
      BackColor := Walker^.pnFore;
    end
    else begin
      ForeColor := Walker^.pnFore;
      BackColor := Walker^.pnBack;
    end;
    {check for invisible}
    if (tcaInvisible in Walker^.pnAttr) then
      ForeColor := BackColor
    {check for bold}
    else if (tcaBold in Walker^.pnAttr) then begin
      if Reversed then begin
        R := MinI(integer(GetRValue(BackColor)) + $80, $FF);
        G := MinI(integer(GetGValue(BackColor)) + $80, $FF);
        B := MinI(integer(GetBValue(BackColor)) + $80, $FF);
        BackColor := RGB(R, G, B);
      end
      else begin
        R := MinI(integer(GetRValue(ForeColor)) + $80, $FF);
        G := MinI(integer(GetGValue(ForeColor)) + $80, $FF);
        B := MinI(integer(GetBValue(ForeColor)) + $80, $FF);
        ForeColor := RGB(R, G, B);
      end;
    end;

    {get the length of the text to display}
    TextStrLen := succ(Walker^.pnEnd - Walker^.pnStart);

    {move the required text to our display string}
    Move(TextChars[Walker^.pnStart - 1], FDisplayStr^, TextStrLen);
    FDisplayStr[TextStrLen] := #0;

    {set the correct background}
    Canvas.Brush.Color := BackColor;

    {calculate the left and right values for the rect}
    WorkRect.Left := (Walker^.pnStart - OriginCol) * CharWidth;
    WorkRect.Right := WorkRect.Left + (TextStrLen * CharWidth);

    {display the bit o'text}
    Canvas.Font := Font;
    Canvas.Font.Color := ForeColor;

    ExtTextOut(Canvas.Handle,
               WorkRect.Left,
               WorkRect.Top,
               ETO_OPAQUE,
               @WorkRect,
               PChar(FDisplayStr),
               TextStrLen,
               @FCellWidths^);

    {finally, draw the underline and/or strike through}
    Canvas.Pen.Color := ForeColor;
    if (tcaUnderline in Walker^.pnAttr) then begin
      Y := WorkRect.Bottom - 2;
      Canvas.MoveTo(WorkRect.Left, Y);
      Canvas.LineTo(WorkRect.Right, Y);
    end;
    if (tcaStrikeThrough in Walker^.pnAttr) then begin
      Y := WorkRect.Top + (WorkRect.Bottom - WorkRect.Top) div 2;
      Canvas.MoveTo(WorkRect.Left, Y);
      Canvas.LineTo(WorkRect.Right, Y);
    end;

    {walk to the next paint node, free this one}
    Temp := Walker;
    Walker := Walker^.pnNext;
    ttyFreePaintNode(Temp);
  end;
end;
{--------}
procedure TAdTTYEmulator.ttyFreeAllPaintNodes;
var
  Walker, Temp : PPaintNode;
begin
  Walker := FPaintFreeList;
  while (Walker <> nil) do begin
    Temp := Walker;
    Walker := Walker^.pnNext;
    Dispose(Temp);
  end;
  FPaintFreeList := nil;
end;
{--------}
procedure TAdTTYEmulator.ttyFreePaintNode(aNode : pointer);
begin
  PPaintNode(aNode)^.pnNext := FPaintFreeList;
  FPaintFreeList := aNode;
end;
{--------}
function TAdTTYEmulator.ttyNewPaintNode : pointer;
begin
  if (FPaintFreeList = nil) then
    New(PPaintNode(Result))
  else begin
    Result := FPaintFreeList;
    FPaintFreeList := PPaintNode(Result)^.pnNext;
  end;
end;
{====================================================================}


{====================================================================}
constructor TAdVT100Emulator.Create(aOwner : TComponent);
begin
  {Note: the buffer *must* be created before the ancestor can perform
         initialization. The reason is that at design time dropping an
         emulator on the form will cause a series of Notification
         calls to take place. This in turn could cause a terminal's
         tmSetEmulator method to be called, which would then set up
         some default text in the emulator's buffer.}

  {create the buffer and parser and keyboard mapper}
  FTerminalBuffer := TAdTerminalBuffer.Create(false);
  FParser := TAdVT100Parser.Create(false);
  FKeyboardMapping := TAdKeyboardMapping.Create;
  FCharSetMapping := TAdCharSetMapping.Create;

  {now let the ancestor do his stuff}
  inherited Create(aOwner);

  {set up our default values}
  ANSIMode := adc_VT100ANSIMode;
  AppKeyMode := adc_VT100AppKeyMode;
  AppKeypadMode := adc_VT100AppKeypadMode;
  AutoRepeat := adc_VT100AutoRepeat;
  FCol132Mode := adc_VT100Col132Mode;
  GPOMode := adc_VT100GPOMode;
  InsertMode := adc_VT100InsertMode;
  Interlace := adc_VT100Interlace;
  NewLineMode := adc_VT100NewLineMode;
  FRelOriginMode := adc_VT100RelOriginMode;
  FRevScreenMode := adc_VT100RevScreenMode;
  SmoothScrollMode := adc_VT100SmoothScrollMode;
  WrapAround := adc_VT100WrapAround;

  {FAnswerback := adc_VT100Answerback;                                 } {!!.06}
  FG0CharSet := adc_VT100G0CharSet;
  FG1CharSet := adc_VT100G1CharSet;

  FDisplayStrSize := 133; {enough for both 80- and 132-column mode}
  GetMem(FDisplayStr, FDisplayStrSize);

  {make sure we're told about scrolling rows so we can track double
   height and double width lines}
  FLineAttrArray := TAdLineAttrArray.Create(Self);
  FTerminalBuffer.OnScrollRows := vttScrollRowsHandler;

  {make sure the mappers are initialized}
  FKeyboardMapping.LoadFromRes(hInstance, 'ADVT100KeyMap');
  FCharSetMapping.LoadFromRes(hInstance, 'ADVT100CharSet');

  {initialize the secondary font--a cache to help charset switches}
  FSecondaryFont := TFont.Create;
  if (Terminal <> nil) then
    FSecondaryFont.Assign(Terminal.Font);
  GetMem(FCellWidths, 132 * sizeof(integer));
  FillChar(FCellWidths^, 132 * sizeof(integer), 0);
  FTerminalBuffer.OnCursorMoved := teHandleCursorMovement;
end;
{--------}
destructor TAdVT100Emulator.Destroy;
begin
  {clear the current blink script, free the blink node free list}
  vttClearBlinkScript;
  vttFreeAllBlinkNodes;
  {free the paint node free list}
  vttFreeAllPaintNodes;
  FreeMem(FCellWidths, 132 * sizeof(integer));
  {free the display string}
  if (FDisplayStr <> nil) then
    FreeMem(FDisplayStr, FDisplayStrSize);
  {free the internal objects}
  FSecondaryFont.Free;
  FLineAttrArray.Free;
  FKeyboardMapping.Free;
  FCharSetMapping.Free;
  FParser.Free;
  FTerminalBuffer.Free;
  inherited Destroy;
end;
{--------}
procedure TAdVT100Emulator.BlinkPaint(aVisible : boolean);
var
  Walker : PBlinkNode;
begin
  {the BlinkPaint method is called by the terminal, if and only if
   the blink timer expired; in other words, the blinking text must be
   displayed in the opposite sense, on or off}

  {read all the nodes in the blink linked list, redraw them}
  Walker := PBlinkNode(FBlinkers);
  while (Walker <> nil) do
    with Walker^ do begin
      vttDrawChars(bnRow, bnStartCh, bnEndCh, aVisible, true);
      Walker := bnNext;
    end;
end;
{--------}
{procedure TAdVT100Emulator.DefineProperties (Filer : TFiler);         } {!!.04}
{begin                                                                 } {!!.04}
{  inherited DefineProperties (Filer);                                 } {!!.04}

{  Filer.DefineProperty ('Answerback',                                 } {!!.04}
{                        ReadAnswerback,                               } {!!.04}
{                        WriteAnswerback,                              } {!!.04}
{                        Answerback = '');                             } {!!.04}
{end;                                                                  } {!!.04}
{--------}
function TAdVT100Emulator.HasBlinkingText : boolean;
begin
  Result := FBlinkers <> nil;
end;
{--------}
{function TAdVT100Emulator.IsAnswerbackStored : Boolean;               } {!!.04}
{begin                                                                 } {!!.04}
{  Result := Answerback <> adc_VT100Answerback;                        } {!!.04}
{end;                                                                  } {!!.04}
{--------}
procedure TAdVT100Emulator.KeyDown(var Key : word; Shift: TShiftState);
  {------}
  function CvtHexChar(const S : AnsiString; aInx : integer) : AnsiChar;
  var
    Hex : string[3];
    Value : integer;
    ec    : integer;
  begin
    Hex := '$  ';
    Hex[2] := S[aInx];
    Hex[3] := S[aInx+1];
    Val(string(Hex), Value, ec);
    if (ec = 0) then
      Result := AnsiChar(Value)
    else
      Result := '?';
  end;
  {------}
var
  VKKey     : AnsiString;
  VTKey     : AnsiString;
  VTKeyString : AnsiString;
  i         : integer;
  EscChar   : boolean;
  HexChar1  : boolean;
  HexChar2  : boolean;
  IsEscSeq  : boolean;
  IsRepeat  : boolean;
  IsNumLock : boolean;
  Ch        : AnsiChar;
begin
  {check for a repeated key and AutoRepeat is off}
  IsRepeat := (Key and $8000) <> 0;
  if IsRepeat then begin
    if not AutoRepeat then begin
      Key := 0;
      Exit;
    end;
    Key := Key and $7FFF;
  end;
  {make a note in case we hit the numlock key}
  IsNumLock := Key = VK_NUMLOCK;
  {we need to convert this keystroke into a VT100 string to pass back
   to the server; this is a three step process...}
  {first, convert the keystroke to its name}
  VKKey := AnsiString(Format('\x%.2x', [Key]));
  VKKey := KeyboardMapping.Get(VKKey);
  {if we can continue, add the shift state in the order shift, ctrl,
   then alt}
  if (VKKey = '') then
    Exit;
  if ssAlt in Shift then
    VKKey := 'alt+' + VKKey;
  if ssCtrl in Shift then
    VKKey := 'ctrl+' + VKKey;
  if ssShift in Shift then
    VKKey := 'shift+' + VKKey;
  {now convert this into a DEC VT100 keyname}
  VTKey := KeyboardMapping.Get(VKKey);
  {if we managed to convert it to a VT100 key, modify the name to
   include the application/cursor key mode}
  if (VTKey = '') then
    Exit;
  {if this is a cursor key the name ends in 'c', replace it with 0, 1,
   or 2, depending on whether we're in VT52 mode, ANSI mode with
   cursor key mode reset, or ANSI mode with cursor key mode set}
  if (VTKey[length(VTKey)] = 'c') then begin
    if not ANSIMode then
      VTKey[length(VTKey)] := '0'
    else if not AppKeyMode then
      VTKey[length(VTKey)] := '1'
    else
      VTKey[length(VTKey)] := '2';
  end
  {if this is a Keypad key the name ends in 'k', replace it with 3, 4,
   5, or 6, depending on whether we're in VT52 numeric mode, VT52
   application mode, ANSI numeric mode, or ANSI application mode}
  else if (VTKey[length(VTKey)] = 'k') then begin
    if not ANSIMode then
      if not AppKeypadMode then
        VTKey[length(VTKey)] := '3'
      else
        VTKey[length(VTKey)] := '4'
    else
      if not AppKeypadMode then
        VTKey[length(VTKey)] := '5'
      else
        VTKey[length(VTKey)] := '6';
  end;
  {now get the string we need to send to the host for this key}
  VTKeyString := KeyboardMapping.Get(VTKey);
  if (VTKeyString <> '') then begin
    IsEscSeq := false;
    EscChar := false;
    HexChar1 := false;
    HexChar2 := false;
    {interpret the key string}
    for i := 1 to length(VTKeyString) do begin
      {get the next character}
      Ch := VTKeyString[i];
      {if the previous character was a '\' then we're reading an
       escaped character, either of the form \e or \xhh}
      if EscChar then begin
        if (Ch = 'e') then begin
          teSendChar(#27, false, csKeyboard);                          {!!.04}
          IsEscSeq := true;
        end
        else if (Ch = 'x') then begin
          HexChar1 := true;
          Ch := CvtHexChar(VTKeyString, i+1);
          if (Ch = #13) then begin
            teSendChar(Ch, true, csKeyboard);                          {!!.04}
            if NewLineMode then
              teSendChar(#10, true, csKeyboard);                       {!!.04}
          end
          else if (Ch = #27) then begin
            teSendChar(#27, false, csKeyboard);                        {!!.04}
            IsEscSeq := true;
          end
          else
            teSendChar(Ch, not IsEscSeq, csKeyboard);                  {!!.04}
        end
        else {it's not \e or \xhh} begin
          teSendChar('\', true, csKeyboard);                           {!!.04}
          teSendChar(Ch, true, csKeyboard);                            {!!.04}
        end;
        EscChar := false;
      end
      {if the previous character was the x in \xhh, ignore this one:
       we've already interpreted it with the \x}
      else if HexChar1 then begin
        HexChar1 := false;
        HexChar2 := true;
      end
      {if the previous character was the first h in \xhh, ignore this
       one: we've already interpreted it with the \x}
      else if HexChar2 then begin
        HexChar2 := false;
      end
      {if this character is a '\' we're starting an escaped character}
      else if (Ch = '\') then
        EscChar := true
      {otherwise there's nothing special about this character}
      else
        teSendChar(Ch, not IsEscSeq, csKeyboard);                      {!!.04}
    end;
    {we've now fully processed the key, so make sure it doesn't come
     back to bite us}
    Key := 0;
    {if this was the NumLock key, we'd better set it on again}
    if IsNumLock then begin
      vttToggleNumLock;
    end;
  end;
end;
{--------}
procedure TAdVT100Emulator.KeyPress(var Key : Char);
begin
  {on a key press, send the key to the host; for a CR character we
   either send CR (NewLineMode is OFF) or a CR/LF (NewLineMode is on}
  if (Key = #13) then begin
    teSendChar(AnsiChar(Key), true, csKeyboard);                                 {!!.04}
    if NewLineMode then
      teSendChar(#10, true, csKeyboard);                               {!!.04}
  end
  else
    teSendChar(AnsiChar(Key), true, csKeyboard);                                 {!!.04}
end;
{--------}
procedure TAdVT100Emulator.LazyPaint;
var
  DirtyRect : TRect;
  Row       : integer;
begin
  {the LazyPaint method is called by the terminal, if and only if
   either of the lazy timers expired; in other words, either a certain
   amount of data has been received by the terminal, or a certain time
   has elapsed since the last update}

  {if we have to refresh the display, do it, and throw away all the
   'dirty' data}
  if FRefresh then begin
    FRefresh := false;
    for Row := 1 to Buffer.RowCount do
      vttDrawChars(Row, 1, Buffer.ColCount, true, false);
    while Buffer.GetInvalidRect(DirtyRect) do {nothing};
  end
  else begin
    {using the 'dirty' data in the buffer, draw the required
     characters}
    while Buffer.GetInvalidRect(DirtyRect) do begin
      if not Terminal.FreezeScrollBack then begin
        Inc (DirtyRect.Top, Terminal.FScrollVertInfo.nPos);
        Inc (DirtyRect.Bottom, Terminal.FScrollVertInfo.nPos + 1);
      end;
      for Row := DirtyRect.Top to DirtyRect.Bottom do
        vttDrawChars(Row, DirtyRect.Left, DirtyRect.Right, true, false);
    end;
  end;
end;
{--------}
procedure TAdVT100Emulator.Paint;
var
  DirtyRect : TRect;
  Row       : integer;
begin
  {the Paint method is called by the terminal, if and only if the
   terminal component received a WM_PAINT message}

  {repaint the clip region}
  DirtyRect := Terminal.Canvas.ClipRect;
  with Terminal do begin
    DirtyRect.Left :=
       (DirtyRect.Left div GetTotalCharWidth) + ClientOriginCol;         {!!.06}
    DirtyRect.Right :=
       (pred(DirtyRect.Right) div GetTotalCharWidth) + ClientOriginCol;  {!!.06}
    DirtyRect.Top :=
       (DirtyRect.Top div GetTotalCharHeight) + ClientOriginRow;         {!!.06}
    DirtyRect.Bottom :=
       (pred(DirtyRect.Bottom) div GetTotalCharHeight) + ClientOriginRow;{!!.06}
  end;
  if not Terminal.FreezeScrollBack then begin
    Inc (DirtyRect.Top, Terminal.FScrollVertInfo.nPos);
    Inc (DirtyRect.Bottom, Terminal.FScrollVertInfo.nPos + 1);
  end;
  for Row := DirtyRect.Top to DirtyRect.Bottom do
    vttDrawChars(Row, DirtyRect.Left, DirtyRect.Right, true, false);
end;
{--------}
procedure TAdVT100Emulator.ProcessBlock (aData      : pointer;          {!!.04}
                                         aDataLen   : Integer;          {!!.04}
                                         CharSource : TAdCharSource);   {!!.04}
var
  DataAsChar : PAnsiChar absolute aData;
  i          : integer;
  j          : Integer;                                                {!!.04}
  Ch         : AnsiChar;                                                   {!!.04}
  Str        : Ansistring;                                                 {!!.04}
  StrLen     : Integer;                                                {!!.04}

begin
  for i := 0 to pred(aDataLen) do begin

    Ch := DataAsChar[i];                                               {!!.04}
    SetLength (Str, 1);                                                {!!.04}
    Str[1] := Ch;                                                      {!!.04}
    teClearCommandList;                                                {!!.04}
    // needs an x/y for the process char for parms to the command;     {!!.04}
    if Assigned (FOnProcessChar) then                                  {!!.04}
      FOnProcessChar (Self, Ch, Str, FCommandList, CharSource);        {!!.04}
    StrLen := Length (Str);                                            {!!.04}

    teProcessCommandList (FCommandList);                               {!!.04}

    for j := 1 to StrLen do begin                                      {!!.04}
      Ch := Str[j];                                                    {!!.04}
      case Parser.ProcessChar(Ch) of                                   {!!.04}
        pctNone :
          {ignore it};
        pctChar :
          Buffer.WriteChar(Ch);                                        {!!.04}
        pct8BitChar:
          begin
            if DisplayUpperASCII then
              Buffer.WriteChar(Ch)                                     {!!.04}
            else
              vttProcess8bitChar(Ch);                                  {!!.04}
          end;
        pctPending :
          {nothing to do yet};
        pctComplete :
          vttProcessCommand;
      end;
    end;
  end;
  vttCalcBlinkScript;
end;
{--------}
{procedure TAdVT100Emulator.ReadAnswerback (Reader : TReader);         } {!!.06}
{begin                                                                 } {!!.06}
{  Answerback := Reader.ReadString;                                    } {!!.06}
{end;                                                                  } {!!.06}
{--------}
procedure TAdVT100Emulator.teClear;
begin
  Buffer.EraseScreen;
end;
{--------}
procedure TAdVT100Emulator.teClearAll;
begin
  Buffer.EraseAll;
end;
{--------}
function TAdVT100Emulator.teGetNeedsUpdate : boolean;
begin
  Result := Buffer.HasDisplayChanged or FRefresh or
            Buffer.HasCursorMoved;
end;
{--------}
procedure TAdVT100Emulator.teSetTerminal(aValue : TAdCustomTerminal);
begin
  inherited teSetTerminal(aValue);
  if (aValue <> nil) and (aValue.Font <> nil) and
     (FSecondaryFont <> nil) then
    FSecondaryFont.Assign(aValue.Font);
end;

{--------}
procedure TAdVT100Emulator.vttCalcBlinkScript;
var
  RowInx       : integer;
  ColInx       : integer;
  StartColInx  : integer;
  Temp         : PBlinkNode;
  Attrs        : TAdTerminalCharAttrs;
  AttrArray    : PByteArray;
  InBlinkRegion: boolean;
begin
  if Buffer.HasDisplayChanged then begin
    {clear the current script of blink regions}
    vttClearBlinkScript;
    {search for the current blink regions in the buffer}
    InBlinkRegion := false;
    StartColInx := 0;
    with Buffer do
      for RowInx := Terminal.ClientOriginRow to
                    pred(Terminal.ClientOriginRow + RowCount) do begin
        AttrArray := GetLineAttrPtr(RowInx);
        for ColInx := 0 to pred(ColCount) do begin
          Attrs := TAdTerminalCharAttrs(AttrArray^[ColInx]);
          if InBlinkRegion then begin
            if not (tcaBlink in Attrs) then begin
              InBlinkRegion := false;
              Temp := vttNewBlinkNode;
              Temp^.bnRow := RowInx;
              Temp^.bnStartCh := succ(StartColInx);
              Temp^.bnEndCh := ColInx;
              Temp^.bnNext := PBlinkNode(FBlinkers);
              FBlinkers := Temp;
            end;
          end
          else {not tracking blink region} begin
            if (tcaBlink in Attrs) then begin
              InBlinkRegion := true;
              StartColInx := ColInx;
            end;
          end;
        end;
      end;

    {close off the final blink region if there is one}
    if InBlinkRegion then begin
      Temp := vttNewBlinkNode;
      Temp^.bnRow := Buffer.RowCount;
      Temp^.bnStartCh := succ(StartColInx);
      Temp^.bnEndCh := Buffer.ColCount;
      Temp^.bnNext := PBlinkNode(FBlinkers);
      FBlinkers := Temp;
    end;
  end;
end;
{--------}
procedure TAdVT100Emulator.vttClearBlinkScript;
var
  Walker, Temp : PBlinkNode;
begin
  Walker := PBlinkNode(FBlinkers);
  while (Walker <> nil) do begin
    Temp := Walker;
    Walker := Walker^.bnNext;
    vttFreeBlinkNode(Temp);
  end;
  FBlinkers := nil;
end;
{--------}
procedure TAdVT100Emulator.vttDrawBlinkOffCycle(
                                    aRow, aStartCh, aEndCh : integer);
var
  ChNum      : integer;
  BackColor  : TColor;
  BackColors : PadtLongArray;
  WorkRect   : TRect;
  CharWidth  : integer;
  OriginCh   : integer;
begin
  {get the character width}
  if (TAdLineAttrArray(FLineAttrArray).Attr[aRow] = ltNormal) then begin
    CharWidth := Terminal.GetTotalCharWidth;                             {!!.06}
    OriginCh := Terminal.ClientOriginCol;
  end
  else begin
    CharWidth := (Terminal.GetTotalCharWidth) * 2;                       {!!.06}
    OriginCh := ((Terminal.ClientOriginCol - 1) div 2) + 1;
  end;

  {get the pointers to the fore/background colors}
  if RevScreenMode then
    BackColors := Buffer.GetLineForeColorPtr(aRow)
  else
    BackColors := Buffer.GetLineBackColorPtr(aRow);

  {just paint the background}
  with Terminal.Canvas do begin
    {we have to display the background color in separate steps since
     different characters across the display may have different
     background colors; set to the loop variables}
    BackColor := BackColors^[aStartCh-1];
    ChNum := aStartCh;
    WorkRect :=
       Rect((aStartCh - OriginCh) * CharWidth,
            (aRow - Terminal.ClientOriginRow) *                          {!!.06}
             Terminal.GetTotalCharHeight,                                {!!.06}
            0, {to be set in the loop}
            (aRow - Terminal.ClientOriginRow + 1) *                      {!!.06}
             Terminal.GetTotalCharHeight);                               {!!.06}
    while (ChNum < aEndCh) do begin
      inc(ChNum);
      {if the background color changes, draw the rect in the old
       color, and then save the new color and start point}
      if (BackColor <> BackColors^[ChNum-1]) then begin
        WorkRect.Right := (ChNum - OriginCh) * CharWidth;
        Brush.Color := BackColor;
        FillRect(WorkRect);
        BackColor := BackColors^[ChNum-1];
        WorkRect.Left := WorkRect.Right;
      end;
    end;
    {finish off the last rect in the final color}
    WorkRect.Right := (aEndCh - OriginCh + 1) * CharWidth;
    Brush.Color := BackColor;
    FillRect(WorkRect);
  end;
end;
{--------}
procedure TAdVT100Emulator.vttDrawChars(aRow, aStartVal, aEndVal : integer;
                                        aVisible : boolean;
                                        aCharValues : boolean);
var
  ChNum     : integer;
  StartChNum : integer;
  StartChar  : integer;
  EndChar    : integer;
  BackColor  : TColor;
  ForeColor  : TColor;
  Attr       : TAdTerminalCharAttrs;
  CharSet    : byte;
  ForeColors : PadtLongArray;
  BackColors : PadtLongArray;
  Attrs      : PByteArray;
  CharSets   : PByteArray;
  Script     : PPaintNode;
  PaintNode  : PPaintNode;
  LineAttr   : TAdVT100LineAttr;
begin
  {ASSUMPTION: aStartVal <= aEndVal}

  {Notes: The terminal display can be viewed in two ways: either a
          certain number of characters across, or a certain number of
          columns across. When each character is exactly one column
          (or cell) in width it doesn't matter whether we talk about
          characters or columns. If the characters are double width,
          it *does* matter, since 1 character unit is then equivalent
          to two column units. aCharValues true means that aStartVal
          and aEndVal are character values; false means that they are
          column values. In the latter case, if the row consists of
          double-width characters then we'll have to convert the
          column values to character values.}

  {avoid any drawing if the row simply is not visible}
  if (aRow < Terminal.ClientOriginRow) or
     (aRow >= Terminal.ClientOriginRow + Terminal.ClientRows) then
    Exit;

  {get the line attribute}
  LineAttr := TAdLineAttrArray(FlineAttrArray).Attr[aRow];

  {if the start/end parameters are column values, convert to character
   values}
  if not aCharValues then begin
    if (LineAttr <> ltNormal) then begin
      aStartVal := ((aStartVal - 1) div 2) + 1;
      aEndVal := ((aEndVal - 1) div 2) + 1;
    end;
  end;

  {check to see whether the range of characters is visible, force
   values into visible range}
  if (LineAttr = ltNormal) then begin
    StartChar := Terminal.ClientOriginCol;
    EndChar := Terminal.ClientOriginCol + Terminal.ClientCols;
  end
  else {double-width} begin
    StartChar := ((Terminal.ClientOriginCol - 1) div 2) + 1;
    EndChar := ((Terminal.ClientOriginCol + Terminal.ClientCols - 1)
               div 2) + 1;
  end;
  if (aEndVal < StartChar) or (aStartVal >= EndChar) then
    Exit;
  aStartVal := MaxI(aStartVal, StartChar);
  aEndVal := MinI(aEndVal, EndChar);

  {if this point is reached, we have to paint *something*}

  {there will be calls to this method that are just drawing blinking
   characters for the 'off' cycle (aVisible = false), so make this a
   special case}
  if not aVisible then begin
    vttDrawBlinkOffCycle(aRow, aStartVal, aEndVal);
    Exit;
  end;

  {if this row is the bottom half of a double-height row we don't have
   to display any text since it is displayed with the top half}
  if (LineAttr = ltDblHeightBottom) then
    dec(aRow);

  {this is the main processing: in general we'll be displaying text in
   this section; what will happen here, is that we first generate a
   script of drawing commands (which background color, which text
   color, which attributes, which character set, which text), and then
   we execute the script}

  {get the pointers to the colors, the attributes, the charsets}
  BackColors := Buffer.GetLineBackColorPtr(aRow);
  ForeColors := Buffer.GetLineForeColorPtr(aRow);
  Attrs := Buffer.GetLineAttrPtr(aRow);
  CharSets := Buffer.GetLineCharSetPtr(aRow);

  {get the initial values for the display variables}
  BackColor := BackColors^[aStartVal-1];
  ForeColor := ForeColors^[aStartVal-1];
  Attr := TAdTerminalCharAttrs(Attrs^[aStartVal-1]);
  CharSet := CharSets^[aStartVal-1];

  {make a note of the start char number}
  StartChNum := aStartVal;
  ChNum := aStartVal;

  {build the script as a stack of paint commands}
  Script := nil;
  while (ChNum < aEndVal) do begin
    {look at the next char number}
    inc(ChNum);
    {if any info has changed...}
    if (ForeColor <> ForeColors^[ChNum-1]) or
       (BackColor <> BackColors^[ChNum-1]) or
       (Attr <> TAdTerminalCharAttrs(Attrs^[ChNum-1])) or
       (CharSet <> CharSets^[ChNum-1]) then begin
      {get a new node, initialize it}
      PaintNode := vttNewPaintNode;
      PaintNode^.pnStart := StartChNum;
      PaintNode^.pnEnd := pred(ChNum);
      PaintNode^.pnFore := ForeColor;
      PaintNode^.pnBack := BackColor;
      PaintNode^.pnAttr := Attr;
      PaintNode^.pnCSet := CharSet;
      {add it to the script}
      PaintNode^.pnNext := Script;
      Script := PaintNode;
      {save the new values of the variables}
      ForeColor := ForeColors^[ChNum-1];
      BackColor := BackColors^[ChNum-1];
      Attr := TAdTerminalCharAttrs(Attrs^[ChNum-1]);
      CharSet := CharSets^[ChNum-1];
      StartChNum := ChNum;
    end;
  end;
  {create the final paint command}
  PaintNode := vttNewPaintNode;
  PaintNode^.pnStart := StartChNum;
  PaintNode^.pnEnd := aEndVal;
  PaintNode^.pnFore := ForeColor;
  PaintNode^.pnBack := BackColor;
  PaintNode^.pnAttr := Attr;
  PaintNode^.pnCSet := CharSet;
  {add it to the script}
  PaintNode^.pnNext := Script;
  Script := PaintNode;

  {now execute the paint script}
  try                                                                       // SWB
    vttExecutePaintScript(aRow, Script);                                    // SWB
  except                                                                    // SWB
    // We get access violations here when changing emulators.  Don't        // SWB
    // know why but ignoring them doesn't seem to hurt.                     // SWB
    on EAccessViolation do ;                                                // SWB
  end;                                                                      // SWB
end;
{--------}
procedure TAdVT100Emulator.vttExecutePaintScript(aRow    : integer;
                                                 aScript : pointer);
var
  Canvas       : TCanvas;
  Font         : TFont;
  Walker, Temp : PPaintNode;
  ForeColor    : TColor;
  BackColor    : TColor;
  CharWidth    : integer;
  CharHeight   : integer;
  OriginCol    : integer;
  OffsetCol    : integer;
  TextStrLen   : integer;
  TextChars    : PAnsiChar;
  PartTextLen  : integer;
  TextCol      : integer;
  FontName     : TadKeyString;
  WorkRect     : TRect;
  Y            : integer;
  R, G, B      : integer;
  Reversed     : boolean;
  DblHeight    : boolean;
begin
  case TAdLineAttrArray(FLineAttrArray).Attr[aRow] of
    ltNormal          : DblHeight := false;
    ltDblHeightTop    : DblHeight := true;
    ltDblHeightBottom : DblHeight := true;
    ltDblWidth        : DblHeight := false;
  else
    DblHeight := false;
  end;
  {get some values as local variables}
  Canvas := Terminal.Canvas;
  Font := Terminal.Font;
  TextChars := Buffer.GetLineCharPtr(aRow);
  CharHeight := Terminal.GetTotalCharHeight;                             {!!.06}
  WorkRect.Top := (aRow - Terminal.ClientOriginRow) * CharHeight;
  if DblHeight then
    WorkRect.Bottom := WorkRect.Top + (CharHeight * 2)
  else
    WorkRect.Bottom := WorkRect.Top + CharHeight;
  if (TAdLineAttrArray(FLineAttrArray).Attr[aRow] = ltNormal) then begin
    CharWidth := Terminal.GetTotalCharWidth;                             {!!.06}
    OriginCol := Terminal.ClientOriginCol;
    OffsetCol := 0;
  end
  else begin
    CharWidth := (Terminal.GetTotalCharWidth) * 2;                       {!!.06}
    OriginCol := ((Terminal.ClientOriginCol - 1) div 2) + 1;
    if Odd(Terminal.ClientOriginCol) then
      OffsetCol := 0
    else
      OffsetCol := -Terminal.GetTotalCharWidth;                          {!!.06}
  end;
  {set the cell widths}
  for Y := 0 to pred(Buffer.ColCount) do
    FCellWidths^[Y] := CharWidth;
  {process the script}
  Walker := PPaintNode(aScript);
  while (Walker <> nil) do begin
    {check for reverse}
    Reversed := RevScreenMode xor
                (tcaReverse in Walker^.pnAttr) xor
                (tcaSelected in Walker^.pnAttr);
    if Reversed then begin
      ForeColor := Walker^.pnBack;
      BackColor := Walker^.pnFore;
    end
    else begin
      ForeColor := Walker^.pnFore;
      BackColor := Walker^.pnBack;
    end;
    {check for invisible}
    if (tcaInvisible in Walker^.pnAttr) then
      ForeColor := BackColor
    {check for bold}
    else if (tcaBold in Walker^.pnAttr) then begin
      if Reversed then begin
        R := MinI(integer(GetRValue(BackColor)) + $80, $FF);
        G := MinI(integer(GetGValue(BackColor)) + $80, $FF);
        B := MinI(integer(GetBValue(BackColor)) + $80, $FF);
        BackColor := RGB(R, G, B);
      end
      else begin
        R := MinI(integer(GetRValue(ForeColor)) + $80, $FF);
        G := MinI(integer(GetGValue(ForeColor)) + $80, $FF);
        B := MinI(integer(GetBValue(ForeColor)) + $80, $FF);
        ForeColor := RGB(R, G, B);
      end;
    end;

    {get the length of the text to display}
    TextStrLen := succ(Walker^.pnEnd - Walker^.pnStart);

    {move the required text to our display string}
    Move(TextChars[Walker^.pnStart - 1], FDisplayStr^, TextStrLen);
    FDisplayStr[TextStrLen] := #0;

    {set the correct background}
    Canvas.Brush.Color := BackColor;

    {ask the charset mapping to create a draw script for this text}
    FCharSetMapping.GenerateDrawScript(ShortString(
       VT100CharSetNames[Walker^.pnCSet]), FDisplayStr);

    {while the charset mapping passes us back draw commands, draw}
    TextCol := Walker^.pnStart - OriginCol;
    while FCharSetMapping.GetNextDrawCommand(FontName, FDisplayStr) do begin
      {calculate the length of this bit o' text}
      PartTextLen := AnsiStrings.StrLen(FDisplayStr);

      {calculate the left and right values for the rect}
      WorkRect.Left := (TextCol * CharWidth) + OffsetCol;
      WorkRect.Right := WorkRect.Left + (PartTextLen * CharWidth);

      {display the bit o'text}
      if (FontName = DefaultFontName) then
        Canvas.Font := Font
      else begin
        FSecondaryFont.Name := string(FontName);
        Canvas.Font := FSecondaryFont;
      end;
      Canvas.Font.Color := ForeColor;
      if Assigned (Terminal.Font) then                                   {!!.06}
        Canvas.Font.CharSet := Terminal.Font.CharSet                     {!!.06}
      else                                                               {!!.06}
        Canvas.Font.CharSet := DEFAULT_CHARSET;
      if DblHeight then
        Canvas.Font.Size := Canvas.Font.Size * 2;

      ExtTextOut(Canvas.Handle,
                 WorkRect.Left,
                 WorkRect.Top,
                 ETO_OPAQUE,
                 @WorkRect,
                 PChar(FDisplayStr),
                 PartTextLen,
                 @FCellWidths^);

      {finally, draw the underline and/or strike through}
      Canvas.Pen.Color := ForeColor;
      if (tcaUnderline in Walker^.pnAttr) then begin
        Y := WorkRect.Bottom - 2;
        Canvas.MoveTo(WorkRect.Left, Y);
        Canvas.LineTo(WorkRect.Right, Y);
      end;
      if (tcaStrikeThrough in Walker^.pnAttr) then begin
        Y := WorkRect.Top + (WorkRect.Bottom - WorkRect.Top) div 2;
        Canvas.MoveTo(WorkRect.Left, Y);
        Canvas.LineTo(WorkRect.Right, Y);
      end;

      {advance past this bit o'text}
      inc(TextCol, PartTextLen);
    end;

    {walk to the next paint node, free this one}
    Temp := Walker;
    Walker := Walker^.pnNext;
    vttFreePaintNode(Temp);
  end;
end;
{--------}
procedure TAdVT100Emulator.vttFreeAllBlinkNodes;
var
  Walker, Temp : PBlinkNode;
begin
  Walker := FBlinkFreeList;
  while (Walker <> nil) do begin
    Temp := Walker;
    Walker := Walker^.bnNext;
    Dispose(Temp);
  end;
  FBlinkFreeList := nil;
end;
{--------}
procedure TAdVT100Emulator.vttFreeAllPaintNodes;
var
  Walker, Temp : PPaintNode;
begin
  Walker := FPaintFreeList;
  while (Walker <> nil) do begin
    Temp := Walker;
    Walker := Walker^.pnNext;
    Dispose(Temp);
  end;
  FPaintFreeList := nil;
end;
{--------}
procedure TAdVT100Emulator.vttFreeBlinkNode(aNode : pointer);
begin
  PBlinkNode(aNode)^.bnNext := FBlinkFreeList;
  FBlinkFreeList := aNode;
end;
{--------}
procedure TAdVT100Emulator.vttFreePaintNode(aNode : pointer);
begin
  PPaintNode(aNode)^.pnNext := FPaintFreeList;
  FPaintFreeList := aNode;
end;
{--------}
function TAdVT100Emulator.vttGenerateDECREPTPARM(aArg : integer) : string;
var
  par   : integer;
  nbits : integer;
  xspd  : integer;
  rspd  : integer;
begin
  {calculate the parity}
  case Terminal.ComPort.Parity of
    pOdd  : par := 4;
    pEven : par := 5;
  else
    par := 1;
  end;{case}
  {calculate the number of bits}
  if (Terminal.ComPort.DataBits = 8) then
    nbits := 1
  else
    nbits := 2;
  {calculate the speed}
  case Terminal.ComPort.Baud of
     150 : xspd := 32;
     300 : xspd := 48;
     600 : xspd := 56;
    1200 : xspd := 64;
    2400 : xspd := 88;
    4800 : xspd := 104;
    9600 : xspd := 112;
  else
    xspd := 120;
  end;{case}
  rspd := xspd;
  {calculate the reply string}
  Result := Format(VT100ReportParm,
                   [aArg+2, par, nbits, xspd, rspd, 1, 0]);
end;
{--------}
procedure TAdVT100Emulator.vttInvalidateRow(aRow : integer);
var
  InvRect : TRect;
begin
  if Terminal.HandleAllocated and
     (Terminal.ClientOriginRow <= aRow) and
     (aRow < Terminal.ClientOriginRow + Terminal.ClientRows) then begin
    InvRect.Left := 0;
    InvRect.Top := (aRow - Terminal.ClientOriginRow) *                   {!!.06}
                   Terminal.GetTotalCharHeight;                          {!!.06}
    InvRect.Right := Terminal.ClientWidth;
    InvRect.Bottom := InvRect.Top + Terminal.GetTotalCharHeight;         {!!.06}
    InvalidateRect(Terminal.Handle, @InvRect, false);
  end;
end;
{--------}
function TAdVT100Emulator.vttNewBlinkNode : pointer;
begin
  if (FBlinkFreeList = nil) then
    New(PBlinkNode(Result))
  else begin
    Result := FBlinkFreeList;
    FBlinkFreeList := PBlinkNode(Result)^.bnNext;
  end;
end;
{--------}
function TAdVT100Emulator.vttNewPaintNode : pointer;
begin
  if (FPaintFreeList = nil) then
    New(PPaintNode(Result))
  else begin
    Result := FPaintFreeList;
    FPaintFreeList := PPaintNode(Result)^.pnNext;
  end;
end;
{--------}
procedure TAdVT100Emulator.vttProcess8bitChar(aCh : AnsiChar);
const
  FirstChar = #176;
  LastChar = #218;
  CvtChars : array [FirstChar..LastChar] of AnsiChar =
             'aaaxuuukkuxkjjjkmvwtqnttmlvwtqnvvwwmmllnnjl';
var
  OldCharSet : byte;
begin
  {convert the line draw characters from the OEM character set to the
   VT100 linedraw charset}
  if (FirstChar <= aCh) and (aCh <= LastChar) then begin
    OldCharSet := Buffer.CharSet;
    Buffer.CharSet := 2;
    Buffer.WriteChar(CvtChars[aCh]);
    Buffer.CharSet := OldCharSet;
  end;
end;
{--------}
procedure TAdVT100Emulator.vttProcessCommand;
var
  i   : integer;
  Arg : integer;
  Arg2: integer;
  OldDefChar : AnsiChar;
  Attrs      : TAdTerminalCharAttrs;
begin
  {assumption: this method is called immediately Parser.ProcessChar
               returns pctComplete. Hence Parser.ArgumentCount,
               Parser.Argument, Parser.Command, Parser.Sequence
               are all set properly}

  {WARNING: this case statement is in numeric order!}
  case Parser.Command of
    eGotoXY {or eCUP, eHVP} :
      begin
        if (Parser.ArgumentCount = 2) then
          Buffer.SetCursorPosition(Parser.Argument[0], Parser.Argument[1]);
      end;
    eUp {or eCUU} :
      begin
        if (Parser.ArgumentCount = 1) then begin
          Arg := Parser.Argument[0];
          if (Arg = 0) then
            Arg := 1;
          for i := 1 to Arg do
            Buffer.MoveCursorUp(false);
        end;
      end;
    eDown {or eCUD, eIND, eVPR} :
      begin
        if (Parser.ArgumentCount = 1) then begin
          Arg := Parser.Argument[0];
          if (Arg = 0) then
            Arg := 1;
          for i := 1 to Arg do
            Buffer.MoveCursorDown(false);
        end;
      end;
    eRight {or eCUF, eHPR} :
      begin
        if (Parser.ArgumentCount = 1) then begin
          Arg := Parser.Argument[0];
          if (Arg = 0) then
            Arg := 1;
          for i := 1 to Arg do
            Buffer.MoveCursorRight(false, false);
        end;
      end;
    eLeft {or eCUB} :
      begin
        if (Parser.ArgumentCount = 1) then begin
          Arg := Parser.Argument[0];
          if (Arg = 0) then
            Arg := 1;
          for i := 1 to Arg do
            Buffer.MoveCursorLeft(false, false);
        end;
      end;
    eSetMode {or eSM} :
      begin
        if (Parser.ArgumentCount = 1) then begin
          case Parser.Argument[0] of
             4 : begin
                   InsertMode := true;
                   Buffer.UseInsertMode := true;
                 end;
            20 : begin
                   NewLineMode := true;
                   Buffer.UseNewLineMode := true;
                 end;
          end;{case}
        end
        else if (Parser.ArgumentCount = 2) and
                (Parser.Argument[0] = -2) then begin
          case Parser.Argument[1] of
            1 : AppKeyMode := true;
            2 : ANSIMode := true;
            3 : begin
                  Col132Mode := true;
                end;
            4 : SmoothScrollMode := true;
            5 : begin
                  RevScreenMode := true;
                end;
            6 : begin
                  RelOriginMode := true;
                end;
            7 : begin
                  WrapAround := true;
                  Buffer.UseAutoWrap := true;
                end;
            8 : AutoRepeat := true;
            9 : Interlace := true;
            999 {apecial APRO value} : AppKeypadMode := true;
          end;{case}
        end;
      end;
    eSetAttribute {or eSGR} :
      begin
        for i := 0 to pred(Parser.ArgumentCount) do begin
          case Parser.Argument[i] of
             0 : begin
                   Buffer.SetCharAttrs([]);
                   Buffer.ForeColor := Buffer.DefForeColor;
                   Buffer.BackColor := Buffer.DefBackColor;
                 end;
             1 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Include(Attrs, tcaBold);
                   Buffer.SetCharAttrs(Attrs);
                 end;
             4 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Include(Attrs, tcaUnderline);
                   Buffer.SetCharAttrs(Attrs);
                 end;
             5 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Include(Attrs, tcaBlink);
                   Buffer.SetCharAttrs(Attrs);
                 end;
             7 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Include(Attrs, tcaReverse);
                   Buffer.SetCharAttrs(Attrs);
                 end;
             8 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Include(Attrs, tcaInvisible);
                   Buffer.SetCharAttrs(Attrs);
                 end;
            22 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Exclude(Attrs, tcaBold);
                   Buffer.SetCharAttrs(Attrs);
                 end;
            24 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Exclude(Attrs, tcaUnderline);
                   Buffer.SetCharAttrs(Attrs);
                 end;
            25 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Exclude(Attrs, tcaBlink);
                   Buffer.SetCharAttrs(Attrs);
                 end;
            27 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Exclude(Attrs, tcaReverse);
                   Buffer.SetCharAttrs(Attrs);
                 end;
            28 : begin
                   Buffer.GetCharAttrs(Attrs);
                   Exclude(Attrs, tcaInvisible);
                   Buffer.SetCharAttrs(Attrs);
                 end;
            30 : Buffer.ForeColor := clBlack;
            31 : Buffer.ForeColor := clMaroon;
            32 : Buffer.ForeColor := clGreen;
            33 : Buffer.ForeColor := clOlive;
            34 : Buffer.ForeColor := clNavy;
            35 : Buffer.ForeColor := clPurple;
            36 : Buffer.ForeColor := clTeal;
            37 : Buffer.ForeColor := clSilver;
            40 : Buffer.BackColor := clBlack;
            41 : Buffer.BackColor := clMaroon;
            42 : Buffer.BackColor := clGreen;
            43 : Buffer.BackColor := clOlive;
            44 : Buffer.BackColor := clNavy;
            45 : Buffer.BackColor := clPurple;
            46 : Buffer.BackColor := clTeal;
            47 : Buffer.BackColor := clSilver;
          end;{case}
        end;
      end;
    eSaveCursorPos :
      begin
        Buffer.GetCharAttrs(FSavedAttrs);
        FSavedBackColor := Buffer.BackColor;
        FSavedCharSet := Buffer.CharSet;
        FSavedCol := Buffer.Col;
        FSavedForeColor := Buffer.ForeColor;
        FSavedRow := Buffer.Row;
      end;
    eRestoreCursorPos :
      begin
        Buffer.SetCharAttrs(FSavedAttrs);
        Buffer.BackColor := FSavedBackColor;
        Buffer.CharSet := FSavedCharSet;
        Buffer.Col := FSavedCol;
        Buffer.ForeColor := FSavedForeColor;
        Buffer.Row := FSavedRow;
      end;
    eDeviceStatusReport {or eDSR} :
      begin
        {we *only* issue a reply if we are the master terminal,
         otherwise if there were several terminals on a form, all
         attached to the same comport, the host would get several
         responses}
        if (Terminal.ComPort.MasterTerminal = Terminal) then begin
          if (Parser.ArgumentCount = 1) then
            if (Parser.Argument[0] = 5) then
              Terminal.ComPort.PutString(VT100StatusRpt)
            else if (Parser.Argument[0] = 6) then
              Terminal.ComPort.PutString(AnsiString(
                 Format(VT100CursorPos, [Buffer.Row, Buffer.Col])));
        end;
      end;
    eCHT :
      begin
        if (Parser.ArgumentCount = 1) then
          for i := 1 to Parser.Argument[0] do
            Buffer.DoHorzTab;
      end;
    eCVT :
      begin
        if (Parser.ArgumentCount = 1) then
          for i := 1 to Parser.Argument[0] do
            Buffer.DoVertTab;
      end;
    eDA :
      begin
        {we *only* issue a reply if we are the master terminal,
         otherwise if there were several terminals on a form, all
         attached to the same comport, the host would get several
         responses}
        if (Terminal.ComPort.MasterTerminal = Terminal) then begin
          if (Parser.ArgumentCount = 1) then
            if (Parser.Argument[0] = 0) then
              Terminal.ComPort.PutString(VT100DeviceAttrs)
            else if (Parser.Argument[0] = 52) then
              Terminal.ComPort.PutString(VT52DeviceAttrs);
        end;
      end;
    eDCH :
      begin
        if (Parser.ArgumentCount > 0) then
          Buffer.DeleteChars(Parser.Argument[0]);
      end;
    eDL :
      begin
        if (Parser.ArgumentCount > 0) then
          Buffer.DeleteLines(Parser.Argument[0]);
      end;
    eECH :
      begin
        if (Parser.ArgumentCount > 0) then
          Buffer.EraseChars(Parser.Argument[0]);
      end;
    eED :
      begin
        if (Parser.ArgumentCount = 1) then
          case Parser.Argument[0] of
            0 : Buffer.EraseToEOW;
            1 : Buffer.EraseFromBOW;
            2 : Buffer.EraseScreen;
          end;
      end;
    eEL :
      begin
        if (Parser.ArgumentCount = 1) then
          case Parser.Argument[0] of
            0 : Buffer.EraseToEOL;
            1 : Buffer.EraseFromBOL;
            2 : Buffer.EraseLine;
          end;
      end;
    eHTS :
      begin
        Buffer.SetHorzTabStop;
      end;
    eICH :
      begin
        if (Parser.ArgumentCount > 0) then
          Buffer.InsertChars(Parser.Argument[0]);
      end;
    eIL :
      begin
        if (Parser.ArgumentCount > 0) then
          Buffer.InsertLines(Parser.Argument[0]);
      end;
    eNEL :
      begin
        Buffer.DoLineFeed;
        if not NewLineMode then
          Buffer.DoCarriageReturn;
      end;
    eRI :
      begin
        Buffer.MoveCursorUp(true);
      end;
    eRIS :
      begin
        Buffer.Reset; {also clears the screen}

        ANSIMode := adc_VT100ANSIMode;
        AppKeyMode := adc_VT100AppKeyMode;
        AppKeypadMode := adc_VT100AppKeypadMode;
        AutoRepeat := adc_VT100AutoRepeat;
        Col132Mode := adc_VT100Col132Mode;
        GPOMode := adc_VT100GPOMode;
        InsertMode := adc_VT100InsertMode;
        Interlace := adc_VT100Interlace;
        NewLineMode := adc_VT100NewLineMode;
        RelOriginMode := adc_VT100RelOriginMode;
        RevScreenMode := adc_VT100RevScreenMode;
        SmoothScrollMode := adc_VT100SmoothScrollMode;
        WrapAround := adc_VT100WrapAround;

        FUsingG1 := false;
        FG0CharSet := adc_VT100G0CharSet;
        FG1CharSet := adc_VT100G1CharSet;
      end;
    eRM :
      begin
        if (Parser.ArgumentCount = 1) then begin
          case Parser.Argument[0] of
             4 : begin
                   InsertMode := false;
                   Buffer.UseInsertMode := false;
                 end;
            20 : begin
                   NewLineMode := false;
                   Buffer.UseNewLineMode := false;
                 end;
          end;{case}
        end
        else if (Parser.ArgumentCount = 2) and
                (Parser.Argument[0] = -2) then begin
          case Parser.Argument[1] of
            1 : AppKeyMode := false;
            2 : ANSIMode := false;
            3 : begin
                  Col132Mode := false;
                end;
            4 : SmoothScrollMode := false;
            5 : begin
                  RevScreenMode := false;
                end;
            6 : begin
                  RelOriginMode := false;
                end;
            7 : begin
                  WrapAround := false;
                  Buffer.UseAutoWrap := false;
                end;
            8 : AutoRepeat := false;
            9 : Interlace := false;
            999 {secial APRO value} : AppKeypadMode := false;
          end;{case}
        end;
      end;
    eTBC :
      begin
        if (Parser.Argument[0] = 0) then
          Buffer.ClearHorzTabStop
        else if (Parser.Argument[0] = 3) then
          Buffer.ClearAllHorzTabStops;
      end;
    eDECSTBM :
      begin
        Arg := Parser.Argument[0];
        if (Arg = -1) or (Arg = 0) then
          Arg := 1;
        Arg2 := Parser.Argument[1];
        if (Arg2 = -1) or (Arg2 = 0) then
          Arg2 := Buffer.RowCount;
        Buffer.SetScrollRegion(Arg, Arg2);
      end;
    eENQ :
      begin
        {we *only* issue a reply if we are the master terminal,
         otherwise if there were several terminals on a form, all
         attached to the same comport, the host would get several
         responses}
        if (Terminal.ComPort.MasterTerminal = Terminal) then begin
          Terminal.ComPort.PutString(AnsiString(Answerback));
        end;
      end;
    eBel :
      begin
        MessageBeep(MB_ICONASTERISK);
      end;
    eBS :
      begin
        Buffer.DoBackspace;
      end;
    eLF :
      begin
        Buffer.DoLineFeed;
      end;
    eCR :
      begin
        Buffer.DoCarriageReturn;
      end;
    eSO :
      begin
        if not ANSIMode then
          Buffer.CharSet := 2
        else
          Buffer.Charset := FG1CharSet;
        FUsingG1 := true;
      end;
    eSI :
      begin
        if not ANSIMode then
          Buffer.CharSet := 0
        else
          Buffer.Charset := FG0CharSet;
        FUsingG1 := false;
      end;
    eIND2 :
      begin
        Buffer.MoveCursorDown(true);
      end;
    eDECALN :
      begin
        {scroll buffer up, fill screen with character E's}
        OldDefChar := Buffer.DefAnsiChar;
        Buffer.DefAnsiChar := 'E';
        Buffer.EraseScreen;
        Buffer.DefAnsiChar := OldDefChar;
      end;
    eDECDHL :
      begin
        if (Parser.ArgumentCount = 1) then begin
          with TAdLineAttrArray(FLineAttrArray) do
            if (Parser.Argument[0] = 0) then
              Attr[Buffer.Row] := ltDblHeightTop
            else
              Attr[Buffer.Row] := ltDblHeightBottom;
          vttInvalidateRow(Buffer.Row);
        end;
      end;
    eDECDWL :
      begin
        with TAdLineAttrArray(FLineAttrArray) do
          Attr[Buffer.Row] := ltDblWidth;
        vttInvalidateRow(Buffer.Row);
      end;
    eDECLL :
      begin
        for i := 0 to pred(Parser.ArgumentCount) do
          case Parser.Argument[i] of
            0 : LEDs := 0;
            1 : LEDs := LEDs or $1;
            2 : LEDs := LEDs or $2;
            3 : LEDs := LEDs or $4;
            4 : LEDs := LEDs or $8;
          end;{case}
      end;
    eDECREQTPARM :
      begin
        {we *only* issue a reply if we are the master terminal,
         otherwise if there were several terminals on a form, all
         attached to the same comport, the host would get several
         responses}
        if (Terminal.ComPort.MasterTerminal = Terminal) then begin
          Arg := 1;
          if (Parser.ArgumentCount = 1) then begin
            Arg := Parser.Argument[0];
            if (Arg < 0) then
              Arg := 0
            else if (Arg > 1) then
              Arg := 1;
          end;
          Terminal.ComPort.PutString(AnsiString(vttGenerateDECREPTPARM(Arg)));
        end;
      end;
    eDECSWL :
      begin
        with TAdLineAttrArray(FLineAttrArray) do
          Attr[Buffer.Row] := ltNormal;
        vttInvalidateRow(Buffer.Row);
      end;
    eDECTST :
      begin
        {}
      end;
    eDECSCS :
      begin
        if Parser.ArgumentCount = 2 then
          case Parser.Argument[0] of
            0 :
              begin
                case Parser.Argument[1] of
                  0        : FG0CharSet := 2;
                  1        : FG0CharSet := 3;
                  2        : FG0CharSet := 4;
                  ord('A') : FG0CharSet := 1;
                  ord('B') : FG0CharSet := 0;
                end;
                if not FUsingG1 then
                  Buffer.Charset := FG0CharSet;
              end;
            1 :
              begin
                case Parser.Argument[1] of
                  0        : FG1CharSet := 2;
                  1        : FG1CharSet := 3;
                  2        : FG1CharSet := 4;
                  ord('A') : FG1CharSet := 1;
                  ord('B') : FG1CharSet := 0;
                end;
                if FUsingG1 then
                  Buffer.Charset := FG1CharSet;
              end;
          end{case}
      end;
  end;{case}
end;
{--------}
procedure TAdVT100Emulator.vttScrollRowsHandler(aSender : TObject;
                                     aCount, aTop, aBottom : integer);
begin
  TAdLineAttrArray(FLIneAttrArray).Scroll(aCount, aTop, aBottom);
end;
{--------}
procedure TAdVT100Emulator.vttSetCol132Mode(aValue : boolean);
begin
  if (aValue <> Col132Mode) then begin
    FCol132Mode := aValue;
    if Col132Mode then
      Terminal.Columns := 132
    else
      Terminal.Columns := 80;
  end;
end;
{--------}
procedure TAdVT100Emulator.vttSetRelOriginMode(aValue : boolean);
begin
  if (aValue <> RelOriginMode) then begin
    FRelOriginMode := aValue;
    Buffer.UseAbsAddress := not aValue;
  end;
end;
{--------}
procedure TAdVT100Emulator.vttSetRevScreenMode(aValue : boolean);
begin
  if (aValue <> RevScreenMode) then begin
    FRevScreenMode := aValue;
    FRefresh := true;
  end;
end;
{--------}
procedure TAdVT100Emulator.vttToggleNumLock;
var
  NumLockState : TKeyboardState;
begin
  GetKeyboardState(NumLockState);
  if ((NumLockState[VK_NUMLOCK] and $01) = 0) then begin
    NumLockState[VK_NUMLOCK] := NumLockState[VK_NUMLOCK] or $01;
  end
  else begin
    NumLockState[VK_NUMLOCK] := NumLockState[VK_NUMLOCK] and $FE;
  end;
  SetKeyboardState(NumLockState);
end;
{--------}
{procedure TAdVT100Emulator.WriteAnswerback (Writer : TWriter);        } {!!.06}
{begin                                                                 } {!!.06}
{  Writer.WriteString (Answerback);                                    } {!!.06}
{end;                                                                  } {!!.06}
{====================================================================}


{===Initialization/finalization======================================}
procedure ADTrmEmuDone; far;
var
  Node, Temp : PTermEmuLink;
begin
  {dispose of active links}
  Node := TermEmuLink;
  while (Node <> nil) do begin
    Temp := Node;
    Node := Node^.telNext;
    Dispose(Temp);
  end;
  {dispose of inactive links}
  Node := TermEmuLinkFreeList;
  while (Node <> nil) do begin
    Temp := Node;
    Node := Node^.telNext;
    Dispose(Temp);
  end;
end;
{--------}

initialization
  TermEmuLink := nil;
  TermEmuLinkFreeList := nil;
finalization
  ADTrmEmuDone;
end.

