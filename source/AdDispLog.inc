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
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                  ADDISPLOG.INC 4.06                   *}
{*********************************************************}
{* String resources for the dispatcher log               *}
{*********************************************************}


  { Logging - It is unlikely that these should change, these strings are }
  { used in the dispatcher log.  Translating them into another language  }
  { could make it difficult for TurboPower Tech Support to decipher it.  }
  { Dispatch type }
  sdtNone                           {15001} = 'No event';
  sdtDispatch                       {15002} = 'Dispatch';
  sdtTrigger                        {15003} = 'Trigger';
  sdtError                          {15004} = 'Error';
  sdtThread                         {15005} = 'Thread';
  sdtTriggerAlloc                   {15006} = 'TrigAllc';
  sdtTriggerDispose                 {15007} = 'TrigDisp';
  sdtTriggerHandlerAlloc            {15008} = 'TrgHdAlc';
  sdtTriggerHandlerDispose          {15009} = 'TrgHdDsp';
  sdtTriggerDataChange              {15010} = 'TrDatChg';
  sdtTelnet                         {15011} = 'Telnet';
  sdtFax                            {15012} = 'Fax';
  sdtXModem                         {15013} = 'XModem';
  sdtYModem                         {15014} = 'YModem';
  sdtZModem                         {15015} = 'ZModem';
  sdtKermit                         {15016} = 'Kermit';
  sdtAscii                          {15017} = 'Ascii';
  sdtBPlus                          {15018} = 'BPlus';
  sdtPacket                         {15019} = 'Packet';
  sdtUser                           {15020} = 'User';
  sdtScript                         {15021} = 'Script';
  { Dispatch subtype }
  sdstNone                          {15100} = '';
  sdstReadCom                       {15101} = 'ReadCom';
  sdstWriteCom                      {15102} = 'WriteCom';
  sdstLineStatus                    {15103} = 'Line status';
  sdstModemStatus                   {15104} = 'Modem status';
  sdstAvail                         {15105} = 'Avail';
  sdstTimer                         {15106} = 'Timer';
  sdstData                          {15107} = 'Data';
  sdstStatus                        {15108} = 'Status';
  sdstThreadStart                   {15109} = 'Start';
  sdstThreadExit                    {15110} = 'Exit';
  sdstThreadSleep                   {15111} = 'Sleep';
  sdstThreadWake                    {15112} = 'Wake';
  sdstDataTrigger                   {15113} = 'Data';
  sdstTimerTrigger                  {15114} = 'Timer';
  sdstStatusTrigger                 {15115} = 'Status';
  sdstAvailTrigger                  {15116} = 'Avail';
  sdstWndHandler                    {15117} = 'Window';
  sdstProcHandler                   {15118} = 'Procedure';
  sdstEventHandler                  {15119} = 'Method';
  sdstSWill                         {15120} = 'Sent WILL';
  sdstSWont                         {15121} = 'Sent WON''T';
  sdstSDo                           {15122} = 'Sent DO';
  sdstSDont                         {15123} = 'Sent DON''T';
  sdstRWill                         {15124} = 'Recv WILL';
  sdstRWont                         {15125} = 'Recv WON''T';
  sdstRDo                           {15126} = 'Recv DO';
  sdstRDont                         {15127} = 'Recv DON''T';
  sdstCommand                       {15128} = 'Command';
  sdstSTerm                         {15129} = 'Sent Term';
  sdsttfNone                        {15130} = 'tfNone';
  sdsttfGetEntry                    {15131} = 'tfGetEntry';
  sdsttfInit                        {15132} = 'tfInit';
  sdsttf1Init1                      {15133} = 'tf1Init1';
  sdsttf2Init1                      {15134} = 'tf2Init1';
  sdsttf2Init1A                     {15135} = 'tf2Init1A';
  sdsttf2Init1B                     {15136} = 'tf2Init1B';
  sdsttf2Init2                      {15137} = 'tf2Init2';
  sdsttf2Init3                      {15138} = 'tf2Init3';
  sdsttfDial                        {15139} = 'tfDial';
  sdsttfRetryWait                   {15140} = 'tfRetryWait';
  sdsttf1Connect                    {15141} = 'tf1Connect';
  sdsttf1SendTSI                    {15142} = 'tf1SendTSI';
  sdsttf1TSIResponse                {15143} = 'tf1TSIRespns';
  sdsttf1DCSResponse                {15144} = 'tf1DCSRspns';
  sdsttf1TrainStart                 {15145} = 'tf1TrainStrt';
  sdsttf1TrainFinish                {15146} = 'tf1TrainFnsh';
  sdsttf1WaitCFR                    {15147} = 'tf1WaitCFR';
  sdsttf1WaitPageConnect            {15148} = 'tf1WaitPgCn';
  sdsttf2Connect                    {15149} = 'tf2Connect';
  sdsttf2GetParams                  {15150} = 'tf2GetParams';
  sdsttfWaitXon                     {15151} = 'tfWaitXon';
  sdsttfWaitFreeHeader              {15152} = 'tfWaitFrHead';
  sdsttfSendPageHeader              {15153} = 'tfSndPgeHdr';
  sdsttfOpenCover                   {15154} = 'tfOpenCover';
  sdsttfSendCover                   {15155} = 'tfSendCover';
  sdsttfPrepPage                    {15156} = 'tfPrepPage';
  sdsttfSendPage                    {15157} = 'tfSendPage';
  sdsttfDrainPage                   {15158} = 'tfDrainPage';
  sdsttf1PageEnd                    {15159} = 'tf1PageEnd';
  sdsttf1PrepareEOP                 {15160} = 'tf1PrepEOP';
  sdsttf1SendEOP                    {15161} = 'tf1SendEOP';
  sdsttf1WaitMPS                    {15162} = 'tf1WaitMPS';
  sdsttf1WaitEOP                    {15163} = 'tf1WaitEOP';
  sdsttf1WaitMCF                    {15164} = 'tf1WaitMCF';
  sdsttf1SendDCN                    {15165} = 'tf1SendDCN';
  sdsttf1Hangup                     {15166} = 'tf1Hangup';
  sdsttf1WaitHangup                 {15167} = 'tf1WaitHngp';
  sdsttf2SendEOP                    {15168} = 'tf2SendEOP';
  sdsttf2WaitFPTS                   {15169} = 'tf2WaitFPTS';
  sdsttf2WaitFET                    {15170} = 'tf2WaitFET';
  sdsttf2WaitPageOK                 {15171} = 'tf2WaitPgOK';
  sdsttf2SendNewParams              {15172} = 'tf2SndNwPrm';
  sdsttf2NextPage                   {15173} = 'tf2NextPage';
  sdsttf20CheckPage                 {15174} = 'tf20ChckPg';
  sdsttfClose                       {15175} = 'tfClose';
  sdsttfCompleteOK                  {15176} = 'tfCompleteOK';
  sdsttfAbort                       {15177} = 'tfAbort';
  sdsttfDone                        {15178} = 'tfDone';
  sdstrfNone                        {15179} = 'rfNone';
  sdstrfInit                        {15180} = 'rfInit';
  sdstrf1Init1                      {15181} = 'rf1Init1';
  sdstrf2Init1                      {15182} = 'rf2Init1';
  sdstrf2Init1A                     {15183} = 'rf2Init1A';
  sdstrf2Init1B                     {15184} = 'rf2Init1B';
  sdstrf2Init2                      {15185} = 'rf2Init2';
  sdstrf2Init3                      {15186} = 'rf2Init3';
  sdstrfWaiting                     {15187} = 'rfWaiting';
  sdstrfAnswer                      {15188} = 'rfAnswer';
  sdstrf1SendCSI                    {15189} = 'rf1SendCSI';
  sdstrf1SendDIS                    {15190} = 'rf1SendDIS';
  sdstrf1CollectFrames              {15191} = 'rf1CollFrms';
  sdstrf1CollectRetry1              {15192} = 'rf1CollRtry1';
  sdstrf1CollectRetry2              {15193} = 'rf1CollRtry2';
  sdstrf1StartTrain                 {15194} = 'rf1StrtTrn';
  sdstrf1CollectTrain               {15195} = 'rf1CollTrn';
  sdstrf1Timeout                    {15196} = 'rf1Timeout';
  sdstrf1Retrain                    {15197} = 'rf1Retrain';
  sdstrf1FinishTrain                {15198} = 'rf1FinTrn';
  sdstrf1SendCFR                    {15199} = 'rf1SendCFR';
  sdstrf1WaitPageConnect            {15200} = 'rf1WtPgCnnct';
  sdstrf2ValidConnect               {15201} = 'rf2ValCnnct';
  sdstrf2GetSenderID                {15202} = 'rf2GtSndID';
  sdstrf2GetConnect                 {15203} = 'rf2GtCnnct';
  sdstrfStartPage                   {15204} = 'rfStartPage';
  sdstrfGetPageData                 {15205} = 'rfGtPgDta';
  sdstrf1FinishPage                 {15206} = 'rf1FinPage';
  sdstrf1WaitEOP                    {15207} = 'rf1WaitEOP';
  sdstrf1WritePage                  {15208} = 'rf1WritePage';
  sdstrf1SendMCF                    {15209} = 'rf1SendMCF';
  sdstrf1WaitDCN                    {15210} = 'rf1WaitDCN';
  sdstrf1WaitHangup                 {15211} = 'rf1WtHngp';
  sdstrf2GetPageResult              {15212} = 'rf2GtPgRslt';
  sdstrf2GetFHNG                    {15213} = 'rf2GetFHNG';
  sdstrfComplete                    {15214} = 'rfComplete';
  sdstrfAbort                       {15215} = 'rfAbort';
  sdstrfDone                        {15216} = 'rfDone';
  sdsttxInitial                     {15217} = 'txInitial';
  sdsttxHandshake                   {15218} = 'txHandshake';
  sdsttxGetBlock                    {15219} = 'txGetBlock';
  sdsttxWaitFreeSpace               {15220} = 'txWtFreeSpc';
  sdsttxSendBlock                   {15221} = 'txSendBlock';
  sdsttxDraining                    {15222} = 'txDraining';
  sdsttxReplyPending                {15223} = 'txRplyPnding';
  sdsttxEndDrain                    {15224} = 'txEndDrain';
  sdsttxFirstEndOfTransmit          {15225} = 'txFirstEOT';
  sdsttxRestEndOfTransmit           {15226} = 'txRestEOT';
  sdsttxEotReply                    {15227} = 'txEotReply';
  sdsttxFinished                    {15228} = 'txFinished';
  sdsttxDone                        {15229} = 'txDone';
  sdstrxInitial                     {15230} = 'rxInitial';
  sdstrxWaitForHSReply              {15231} = 'rxWtFrHSRply';
  sdstrxWaitForBlockStart           {15232} = 'rxWtFrBlStrt';
  sdstrxCollectBlock                {15233} = 'rxCollBlock';
  sdstrxProcessBlock                {15234} = 'rxProcBlck';
  sdstrxFinishedSkip                {15235} = 'rxFinSkip';
  sdstrxFinished                    {15236} = 'rxFinished';
  sdstrxDone                        {15237} = 'rxDone';
  sdsttyInitial                     {15238} = 'tyInitial';
  sdsttyHandshake                   {15239} = 'tyHandshake';
  sdsttyGetFileName                 {15240} = 'tyGetFlName';
  sdsttySendFileName                {15241} = 'tySndFlName';
  sdsttyDraining                    {15242} = 'tyDraining';
  sdsttyReplyPending                {15243} = 'tyRplyPndng';
  sdsttyPrepXmodem                  {15244} = 'tyPrpXmdm';
  sdsttySendXmodem                  {15245} = 'tySndXmdm';
  sdsttyFinished                    {15246} = 'tyFinishd';
  sdsttyFinishDrain                 {15247} = 'tyFinDrain';
  sdsttyDone                        {15248} = 'tyDone';
  sdstryInitial                     {15249} = 'ryInitial';
  sdstryDelay                       {15250} = 'ryDelay';
  sdstryWaitForHSReply              {15251} = 'ryWtFrHSRply';
  sdstryWaitForBlockStart           {15252} = 'ryWtFBlkStrt';
  sdstryCollectBlock                {15253} = 'ryCollBlck';
  sdstryProcessBlock                {15254} = 'ryProcBlck';
  sdstryOpenFile                    {15255} = 'ryOpenFile';
  sdstryPrepXmodem                  {15256} = 'ryPrepXmdm';
  sdstryReceiveXmodem               {15257} = 'ryRcvXmodem';
  sdstryFinished                    {15258} = 'ryFinished';
  sdstryDone                        {15259} = 'ryDone';
  sdsttzInitial                     {15260} = 'tzInitial';
  sdsttzHandshake                   {15261} = 'tzHandshake';
  sdsttzGetFile                     {15262} = 'tzGetFile';
  sdsttzSendFile                    {15263} = 'tzSendFile';
  sdsttzCheckFile                   {15264} = 'tzCheckFile';
  sdsttzStartData                   {15265} = 'tzStartData';
  sdsttzEscapeData                  {15266} = 'tzEscapeData';
  sdsttzSendData                    {15267} = 'tzSendData';
  sdsttzWaitAck                     {15268} = 'tzWaitAck';
  sdsttzSendEof                     {15269} = 'tzSendEof';
  sdsttzDrainEof                    {15270} = 'tzDrainEof';
  sdsttzCheckEof                    {15271} = 'tzCheckEof';
  sdsttzSendFinish                  {15272} = 'tzSendFinish';
  sdsttzCheckFinish                 {15273} = 'tzChkFinish';
  sdsttzError                       {15274} = 'tzError';
  sdsttzCleanup                     {15275} = 'tzCleanup';
  sdsttzDone                        {15276} = 'tzDone';
  sdstrzRqstFile                    {15277} = 'rzRqstFile';
  sdstrzDelay                       {15278} = 'rzDelay';
  sdstrzWaitFile                    {15279} = 'rzWaitFile';
  sdstrzCollectFile                 {15280} = 'rzCollFile';
  sdstrzSendInit                    {15281} = 'rzSendInit';
  sdstrzSendBlockPrep               {15282} = 'rzSndBlkPrp';
  sdstrzSendBlock                   {15283} = 'rzSendBlock';
  sdstrzSync                        {15284} = 'rzSync';
  sdstrzStartFile                   {15285} = 'rzStartFile';
  sdstrzStartData                   {15286} = 'rzStartData';
  sdstrzCollectData                 {15287} = 'rzCollData';
  sdstrzGotData                     {15288} = 'rzGotData';
  sdstrzWaitEof                     {15289} = 'rzWaitEof';
  sdstrzEndOfFile                   {15290} = 'rzEndOfFile';
  sdstrzSendFinish                  {15291} = 'rzSendFinish';
  sdstrzCollectFinish               {15292} = 'rzCollFin';
  sdstrzError                       {15293} = 'rzError';
  sdstrzWaitCancel                  {15294} = 'rzWaitCancel';
  sdstrzCleanup                     {15295} = 'rzCleanup';
  sdstrzDone                        {15296} = 'rzDone';
  sdsttkInit                        {15297} = 'tkInit';
  sdsttkInitReply                   {15298} = 'tkInitReply';
  sdsttkCollectInit                 {15299} = 'tkCollInit';
  sdsttkOpenFile                    {15300} = 'tkOpenFile';
  sdsttkSendFile                    {15301} = 'tkSendFile';
  sdsttkFileReply                   {15302} = 'tkFileReply';
  sdsttkCollectFile                 {15303} = 'tkCollFile';
  sdsttkCheckTable                  {15304} = 'tkCheckTable';
  sdsttkSendData                    {15305} = 'tkSendData';
  sdsttkBlockReply                  {15306} = 'tkBlockReply';
  sdsttkCollectBlock                {15307} = 'tkCollBlock';
  sdsttkSendEof                     {15308} = 'tkSendEof';
  sdsttkEofReply                    {15309} = 'tkEofReply';
  sdsttkCollectEof                  {15310} = 'tkCollectEof';
  sdsttkSendBreak                   {15311} = 'tkSendBreak';
  sdsttkBreakReply                  {15312} = 'tkBreakReply';
  sdsttkCollectBreak                {15313} = 'tkCollBreak';
  sdsttkComplete                    {15314} = 'tkComplete';
  sdsttkWaitCancel                  {15315} = 'tkWaitCancel';
  sdsttkError                       {15316} = 'tkError';
  sdsttkDone                        {15317} = 'tkDone';
  sdstrkInit                        {15318} = 'rkInit';
  sdstrkGetInit                     {15319} = 'rkGetInit';
  sdstrkCollectInit                 {15320} = 'rkCollInit';
  sdstrkGetFile                     {15321} = 'rkGetFile';
  sdstrkCollectFile                 {15322} = 'rkCollFile';
  sdstrkGetData                     {15323} = 'rkGetData';
  sdstrkCollectData                 {15324} = 'rkCollData';
  sdstrkComplete                    {15325} = 'rkComplete';
  sdstrkWaitCancel                  {15326} = 'rkWaitCancel';
  sdstrkError                       {15327} = 'rkError';
  sdstrkDone                        {15328} = 'rkDone';
  sdsttaInitial                     {15329} = 'taInitial';
  sdsttaGetBlock                    {15330} = 'taGetBlock';
  sdsttaWaitFreeSpace               {15331} = 'taWaitFrSpc';
  sdsttaSendBlock                   {15332} = 'taSendBlock';
  sdsttaSendDelay                   {15333} = 'taSendDelay';
  sdsttaFinishDrain                 {15334} = 'taFinDrain';
  sdsttaFinished                    {15335} = 'taFinished';
  sdsttaDone                        {15336} = 'taDone';
  sdstraInitial                     {15337} = 'raInitial';
  sdstraCollectBlock                {15338} = 'raCollBlock';
  sdstraProcessBlock                {15339} = 'raProcBlock';
  sdstraFinished                    {15340} = 'raFinished';
  sdstraDone                        {15341} = 'raDone';
  sdstEnable                        {15342} = 'Enable';
  sdstDisable                       {15343} = 'Disable';
  sdstStringPacket                  {15344} = 'StringPacket';
  sdstSizePacket                    {15345} = 'SizePacket';
  sdstPacketTimeout                 {15346} = 'PcktTimeout';
  sdstStartStr                      {15347} = 'StartStr';
  sdstEndStr                        {15348} = 'EndStr';
  sdstIdle                          {15349} = 'Idle';
  sdstWaiting                       {15350} = 'Waiting';
  sdstCollecting                    {15351} = 'Collecting';
  sdstThreadStatusQueued            {15352} = 'Status Queued';              // SWB
  sdstThreadDataQueued              {15353} = 'Data Queued';                // SWB
  sdstThreadDataWritten             {15354} = 'Data Written';               // SWB
  sdsttzSInit                       {15355} = 'ZSInit';                     // SWB
  sdsttzCheckSInit                  {15356} = 'CheckSInit';                 // SWB
  {log headers}
  sdispHeader                       {15501} = 'Time      Type      SubType       Data      OtherData';
  sdispHeaderLine                   {15502} = '--------  --------  ------------  --------  ---------';
  {modem tags}
  sdispmdmtagDCTS                   {15601} = 'DCTS ';
  sdispmdmtagDDSR                   {15602} = 'DDSR ';
  sdispmdmtagTERI                   {15603} = 'TERI ';
  sdispmdmtagDDCD                   {15604} = 'DDCD ';
  sdispmdmtagCTS                    {15605} = 'CTS ';
  sdispmdmtagDSR                    {15606} = 'DSR ';
  sdispmdmtagRI                     {15607} = 'RI ';
  sdispmdmtagDCD                    {15608} = 'DCD ';
  {Telnet tags}
  sdispTelnetBinary                 {15700} = 'Binary';
  sdispTelnetEcho                   {15701} = 'Echo';
  sdispTelnetReconnection           {15702} = 'Reconnection';
  sdispTelnetSupressGoAhead         {15703} = 'Supress Go Ahead';
  sdispTelnetApproxMsgSize          {15704} = 'Approx Msg Size';
  sdispTelnetStatus                 {15705} = 'Status';
  sdispTelnetTimingMark             {15706} = 'Timing Mark';
  sdispTelnetRemoteTransEcho        {15707} = 'Remote Trans & Echo';
  sdispTelnetOutputLineWidth        {15708} = 'Output Line Width';
  sdispTelnetOutputPageSize         {15709} = 'Output Page Size';
  sdispTelnetOutputCRDisp           {15710} = 'Output C/R Disp';
  sdispTelnetOutputHorzTabs         {15711} = 'Output Horz Tabs';
  sdispTelnetOutputHorzTabDisp      {15712} = 'Output Horz Tab Disp';
  sdispTelnetOutputFFDisp           {15713} = 'Output FF Disp';
  sdispTelnetOutputVertTabs         {15714} = 'Output Vert Tabs';
  sdispTelnetOutputVertTabDisp      {15715} = 'Output Vert Tab Disp';
  sdispTelnetOutputLinefeedDisp     {15716} = 'Output Linefeed Disp';
  sdispTelnetExtendedASCII          {15717} = 'Extended ASCII';
  sdispTelnetLogout                 {15718} = 'Logout';
  sdispTelnetByteMacro              {15719} = 'Byte Macro';
  sdispTelnetDataEntryTerminal      {15720} = 'Data Entry Terminal';
  sdispTelnetSUPDUP                 {15721} = 'SUPDUP';
  sdispTelnetSUPDUPOutput           {15722} = 'SUPDUP Output';
  sdispTelnetSendLocation           {15723} = 'Send Location';
  sdispTelnetTerminalType           {15724} = 'Terminal Type';
  sdispTelnetEndofRecord            {15725} = 'End of Record';
  sdispTelnetTACACSUserID           {15726} = 'TACACS User ID';
  sdispTelnetOutputMarking          {15727} = 'Output Marking';
  sdispTelnetTerminalLocNum         {15728} = 'Terminal Loc Num';
  sdispTelnetTelnet3270Regime       {15729} = 'Telnet3270 Regime';
  sdispTelnetX3PAD                  {15730} = 'X.3 PAD';
  sdispTelnetNegWindowSize          {15731} = 'Neg Window Size';
  sdispTelnetTerminalSpeed          {15732} = 'Terminal Speed';
  sdispTelnetFlowControl            {15733} = 'Flow Control';
  sdispTelnetLineMode               {15734} = 'LineMode';
  sdispTelnetXDisplayLocation       {15735} = 'X Display Location';
  sdispTelnetEnvironment            {15736} = 'Environment';
  sdispTelnetAuthentication         {15737} = 'Authentication';
  sdispTelnetTelnetcode38           {15738} = 'Telnet code 38';
  sdispTelnetNewEnvironment         {15739} = 'New Environment';
  sdispTelnetTelnetcode40           {15740} = 'Telnet code 40';
  sdispTelnetTelnetcode41           {15741} = 'Telnet code 41';
  sdispTelnetCharacterSet           {15742} = 'Character Set';
