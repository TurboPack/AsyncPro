using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ExTapi
{
	#region Header Information
	/**********************************************************\
	|*                    ExTapi - APAX                       *|
	|*      Copyright (c) TurboPower Software 2002            *|
	|*                 All rights reserved.                   *|
	|**********************************************************|

	|**********************Description*************************|
	|* An example of testing TAPI and the events generated.   *|
	\**********************************************************/

	#endregion
	
	public class Form1 : System.Windows.Forms.Form
	{
		public System.Windows.Forms.GroupBox Frame1;
		public System.Windows.Forms.CheckBox chkTapiStatusDisplay;
		public System.Windows.Forms.Button cmdCancel;
		public System.Windows.Forms.Button cmdDial;
		public System.Windows.Forms.Button cmdAnswer;
		public System.Windows.Forms.Button cmdConfig;
		public System.Windows.Forms.Button cmdSelect;
		public System.Windows.Forms.GroupBox Frame2;
		public System.Windows.Forms.TextBox txtSilenceThreshold;
		public System.Windows.Forms.TextBox txtTrimSeconds;
		public System.Windows.Forms.TextBox txtMaxMessageLength;
		public System.Windows.Forms.TextBox txtRetryWait;
		public System.Windows.Forms.TextBox txtMaxAttempts;
		public System.Windows.Forms.TextBox txtAnswerOnRing;
		public System.Windows.Forms.CheckBox chkUseSoundCard;
		public System.Windows.Forms.CheckBox chkInterruptWave;
		public System.Windows.Forms.CheckBox chkEnableVoice;
		public System.Windows.Forms.Label Label6;
		public System.Windows.Forms.Label Label5;
		public System.Windows.Forms.Label Label4;
		public System.Windows.Forms.Label Label3;
		public System.Windows.Forms.Label Label2;
		public System.Windows.Forms.Label Label1;
		public System.Windows.Forms.GroupBox Frame3;
		public System.Windows.Forms.CheckBox chkOverwrite;
		public System.Windows.Forms.Button cmdStop;
		public System.Windows.Forms.Button cmdRecord;
		public System.Windows.Forms.Button cmdDTMF;
		public System.Windows.Forms.Button cmdPlay;
		public System.Windows.Forms.TextBox txtWavDirectory;
		public System.Windows.Forms.Label Label7;
		public System.Windows.Forms.ListBox lstTapiStatus;
		private System.Windows.Forms.Label label8;
		private AxMSComDlg.AxCommonDialog cdCommonDialog;
		private System.Windows.Forms.HelpProvider helpProvider1;
		private System.Windows.Forms.Label label9;
		private System.Windows.Forms.TextBox txtDTMF;
		private AxAPAX1.AxApax axApax1;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}
		private System.ComponentModel.Container components = null;

		public Form1()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(Form1));
			this.Frame1 = new System.Windows.Forms.GroupBox();
			this.axApax1 = new AxAPAX1.AxApax();
			this.chkTapiStatusDisplay = new System.Windows.Forms.CheckBox();
			this.cmdCancel = new System.Windows.Forms.Button();
			this.cmdAnswer = new System.Windows.Forms.Button();
			this.cmdConfig = new System.Windows.Forms.Button();
			this.cmdSelect = new System.Windows.Forms.Button();
			this.cmdDial = new System.Windows.Forms.Button();
			this.Frame2 = new System.Windows.Forms.GroupBox();
			this.txtSilenceThreshold = new System.Windows.Forms.TextBox();
			this.txtTrimSeconds = new System.Windows.Forms.TextBox();
			this.txtMaxMessageLength = new System.Windows.Forms.TextBox();
			this.txtRetryWait = new System.Windows.Forms.TextBox();
			this.txtMaxAttempts = new System.Windows.Forms.TextBox();
			this.txtAnswerOnRing = new System.Windows.Forms.TextBox();
			this.chkUseSoundCard = new System.Windows.Forms.CheckBox();
			this.chkInterruptWave = new System.Windows.Forms.CheckBox();
			this.chkEnableVoice = new System.Windows.Forms.CheckBox();
			this.Label6 = new System.Windows.Forms.Label();
			this.Label5 = new System.Windows.Forms.Label();
			this.Label4 = new System.Windows.Forms.Label();
			this.Label3 = new System.Windows.Forms.Label();
			this.Label2 = new System.Windows.Forms.Label();
			this.Label1 = new System.Windows.Forms.Label();
			this.Frame3 = new System.Windows.Forms.GroupBox();
			this.cdCommonDialog = new AxMSComDlg.AxCommonDialog();
			this.chkOverwrite = new System.Windows.Forms.CheckBox();
			this.cmdStop = new System.Windows.Forms.Button();
			this.cmdRecord = new System.Windows.Forms.Button();
			this.cmdDTMF = new System.Windows.Forms.Button();
			this.cmdPlay = new System.Windows.Forms.Button();
			this.txtWavDirectory = new System.Windows.Forms.TextBox();
			this.Label7 = new System.Windows.Forms.Label();
			this.lstTapiStatus = new System.Windows.Forms.ListBox();
			this.label8 = new System.Windows.Forms.Label();
			this.helpProvider1 = new System.Windows.Forms.HelpProvider();
			this.label9 = new System.Windows.Forms.Label();
			this.txtDTMF = new System.Windows.Forms.TextBox();
			this.Frame1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).BeginInit();
			this.Frame2.SuspendLayout();
			this.Frame3.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.cdCommonDialog)).BeginInit();
			this.SuspendLayout();
			// 
			// Frame1
			// 
			this.Frame1.BackColor = System.Drawing.SystemColors.Control;
			this.Frame1.Controls.AddRange(new System.Windows.Forms.Control[] {
																				 this.axApax1,
																				 this.chkTapiStatusDisplay,
																				 this.cmdCancel,
																				 this.cmdAnswer,
																				 this.cmdConfig,
																				 this.cmdSelect,
																				 this.cmdDial});
			this.Frame1.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Frame1.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Frame1.Location = new System.Drawing.Point(8, 8);
			this.Frame1.Name = "Frame1";
			this.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Frame1.Size = new System.Drawing.Size(321, 97);
			this.Frame1.TabIndex = 1;
			this.Frame1.TabStop = false;
			this.Frame1.Text = " Tapi device connection ";
			this.Frame1.Enter += new System.EventHandler(this.Frame1_Enter);
			// 
			// axApax1
			// 
			this.axApax1.ContainingControl = this;
			this.axApax1.Location = new System.Drawing.Point(264, 16);
			this.axApax1.Name = "axApax1";
			this.axApax1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axApax1.OcxState")));
			this.axApax1.Size = new System.Drawing.Size(48, 32);
			this.axApax1.TabIndex = 7;
			this.axApax1.OnTapiDTMF += new AxAPAX1.IApaxEvents_OnTapiDTMFEventHandler(this.axApax1_OnTapiDTMF);
			this.axApax1.OnTapiConnect += new System.EventHandler(this.axApax1_OnTapiConnect);
			this.axApax1.OnTapiCallerID += new AxAPAX1.IApaxEvents_OnTapiCallerIDEventHandler(this.axApax1_OnTapiCallerID);
			// 
			// chkTapiStatusDisplay
			// 
			this.chkTapiStatusDisplay.BackColor = System.Drawing.SystemColors.Control;
			this.chkTapiStatusDisplay.Cursor = System.Windows.Forms.Cursors.Default;
			this.chkTapiStatusDisplay.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.chkTapiStatusDisplay.ForeColor = System.Drawing.SystemColors.ControlText;
			this.chkTapiStatusDisplay.Location = new System.Drawing.Point(192, 56);
			this.chkTapiStatusDisplay.Name = "chkTapiStatusDisplay";
			this.chkTapiStatusDisplay.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.chkTapiStatusDisplay.Size = new System.Drawing.Size(113, 33);
			this.chkTapiStatusDisplay.TabIndex = 6;
			this.chkTapiStatusDisplay.Text = "Show status dialog";
			// 
			// cmdCancel
			// 
			this.cmdCancel.BackColor = System.Drawing.SystemColors.Control;
			this.cmdCancel.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdCancel.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdCancel.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdCancel.Location = new System.Drawing.Point(184, 24);
			this.cmdCancel.Name = "cmdCancel";
			this.cmdCancel.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdCancel.Size = new System.Drawing.Size(76, 29);
			this.cmdCancel.TabIndex = 5;
			this.cmdCancel.Text = "Cancel";
			this.cmdCancel.Click += new System.EventHandler(this.cmdCancel_Click);
			// 
			// cmdAnswer
			// 
			this.cmdAnswer.BackColor = System.Drawing.SystemColors.Control;
			this.cmdAnswer.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdAnswer.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdAnswer.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdAnswer.Location = new System.Drawing.Point(24, 24);
			this.cmdAnswer.Name = "cmdAnswer";
			this.cmdAnswer.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdAnswer.Size = new System.Drawing.Size(76, 29);
			this.cmdAnswer.TabIndex = 3;
			this.cmdAnswer.Text = "Answer";
			this.cmdAnswer.Click += new System.EventHandler(this.cmdAnswer_Click);
			// 
			// cmdConfig
			// 
			this.cmdConfig.BackColor = System.Drawing.SystemColors.Control;
			this.cmdConfig.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdConfig.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdConfig.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdConfig.Location = new System.Drawing.Point(104, 56);
			this.cmdConfig.Name = "cmdConfig";
			this.cmdConfig.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdConfig.Size = new System.Drawing.Size(76, 29);
			this.cmdConfig.TabIndex = 2;
			this.cmdConfig.Text = "Config...";
			this.cmdConfig.Click += new System.EventHandler(this.cmdConfig_Click);
			// 
			// cmdSelect
			// 
			this.cmdSelect.BackColor = System.Drawing.SystemColors.Control;
			this.cmdSelect.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdSelect.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdSelect.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdSelect.Location = new System.Drawing.Point(24, 56);
			this.cmdSelect.Name = "cmdSelect";
			this.cmdSelect.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdSelect.Size = new System.Drawing.Size(76, 29);
			this.cmdSelect.TabIndex = 1;
			this.cmdSelect.Text = "Select...";
			this.cmdSelect.Click += new System.EventHandler(this.cmdSelect_Click);
			// 
			// cmdDial
			// 
			this.cmdDial.BackColor = System.Drawing.SystemColors.Control;
			this.cmdDial.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdDial.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdDial.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdDial.Location = new System.Drawing.Point(104, 24);
			this.cmdDial.Name = "cmdDial";
			this.cmdDial.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdDial.Size = new System.Drawing.Size(76, 29);
			this.cmdDial.TabIndex = 4;
			this.cmdDial.Text = "Dial...";
			this.cmdDial.Click += new System.EventHandler(this.cmdDial_Click);
			// 
			// Frame2
			// 
			this.Frame2.BackColor = System.Drawing.SystemColors.Control;
			this.Frame2.Controls.AddRange(new System.Windows.Forms.Control[] {
																				 this.txtSilenceThreshold,
																				 this.txtTrimSeconds,
																				 this.txtMaxMessageLength,
																				 this.txtRetryWait,
																				 this.txtMaxAttempts,
																				 this.txtAnswerOnRing,
																				 this.chkUseSoundCard,
																				 this.chkInterruptWave,
																				 this.chkEnableVoice,
																				 this.Label6,
																				 this.Label5,
																				 this.Label4,
																				 this.Label3,
																				 this.Label2,
																				 this.Label1});
			this.Frame2.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Frame2.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Frame2.Location = new System.Drawing.Point(8, 104);
			this.Frame2.Name = "Frame2";
			this.Frame2.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Frame2.Size = new System.Drawing.Size(321, 153);
			this.Frame2.TabIndex = 8;
			this.Frame2.TabStop = false;
			this.Frame2.Text = " Tapi device properties ";
			// 
			// txtSilenceThreshold
			// 
			this.txtSilenceThreshold.AcceptsReturn = true;
			this.txtSilenceThreshold.AutoSize = false;
			this.txtSilenceThreshold.BackColor = System.Drawing.SystemColors.Window;
			this.txtSilenceThreshold.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtSilenceThreshold.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtSilenceThreshold.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtSilenceThreshold.Location = new System.Drawing.Point(272, 72);
			this.txtSilenceThreshold.MaxLength = 0;
			this.txtSilenceThreshold.Name = "txtSilenceThreshold";
			this.txtSilenceThreshold.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtSilenceThreshold.Size = new System.Drawing.Size(33, 19);
			this.txtSilenceThreshold.TabIndex = 32;
			this.txtSilenceThreshold.Text = "0";
			// 
			// txtTrimSeconds
			// 
			this.txtTrimSeconds.AcceptsReturn = true;
			this.txtTrimSeconds.AutoSize = false;
			this.txtTrimSeconds.BackColor = System.Drawing.SystemColors.Window;
			this.txtTrimSeconds.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtTrimSeconds.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtTrimSeconds.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtTrimSeconds.Location = new System.Drawing.Point(272, 48);
			this.txtTrimSeconds.MaxLength = 0;
			this.txtTrimSeconds.Name = "txtTrimSeconds";
			this.txtTrimSeconds.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtTrimSeconds.Size = new System.Drawing.Size(33, 19);
			this.txtTrimSeconds.TabIndex = 31;
			this.txtTrimSeconds.Text = "0";
			// 
			// txtMaxMessageLength
			// 
			this.txtMaxMessageLength.AcceptsReturn = true;
			this.txtMaxMessageLength.AutoSize = false;
			this.txtMaxMessageLength.BackColor = System.Drawing.SystemColors.Window;
			this.txtMaxMessageLength.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtMaxMessageLength.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtMaxMessageLength.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtMaxMessageLength.Location = new System.Drawing.Point(272, 24);
			this.txtMaxMessageLength.MaxLength = 0;
			this.txtMaxMessageLength.Name = "txtMaxMessageLength";
			this.txtMaxMessageLength.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtMaxMessageLength.Size = new System.Drawing.Size(33, 19);
			this.txtMaxMessageLength.TabIndex = 30;
			this.txtMaxMessageLength.Text = "0";
			// 
			// txtRetryWait
			// 
			this.txtRetryWait.AcceptsReturn = true;
			this.txtRetryWait.AutoSize = false;
			this.txtRetryWait.BackColor = System.Drawing.SystemColors.Window;
			this.txtRetryWait.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtRetryWait.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtRetryWait.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtRetryWait.Location = new System.Drawing.Point(104, 72);
			this.txtRetryWait.MaxLength = 0;
			this.txtRetryWait.Name = "txtRetryWait";
			this.txtRetryWait.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtRetryWait.Size = new System.Drawing.Size(33, 19);
			this.txtRetryWait.TabIndex = 29;
			this.txtRetryWait.Text = "0";
			// 
			// txtMaxAttempts
			// 
			this.txtMaxAttempts.AcceptsReturn = true;
			this.txtMaxAttempts.AutoSize = false;
			this.txtMaxAttempts.BackColor = System.Drawing.SystemColors.Window;
			this.txtMaxAttempts.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtMaxAttempts.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtMaxAttempts.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtMaxAttempts.Location = new System.Drawing.Point(104, 48);
			this.txtMaxAttempts.MaxLength = 0;
			this.txtMaxAttempts.Name = "txtMaxAttempts";
			this.txtMaxAttempts.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtMaxAttempts.Size = new System.Drawing.Size(33, 19);
			this.txtMaxAttempts.TabIndex = 28;
			this.txtMaxAttempts.Text = "0";
			// 
			// txtAnswerOnRing
			// 
			this.txtAnswerOnRing.AcceptsReturn = true;
			this.txtAnswerOnRing.AutoSize = false;
			this.txtAnswerOnRing.BackColor = System.Drawing.SystemColors.Window;
			this.txtAnswerOnRing.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtAnswerOnRing.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtAnswerOnRing.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtAnswerOnRing.Location = new System.Drawing.Point(104, 24);
			this.txtAnswerOnRing.MaxLength = 0;
			this.txtAnswerOnRing.Name = "txtAnswerOnRing";
			this.txtAnswerOnRing.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtAnswerOnRing.Size = new System.Drawing.Size(33, 19);
			this.txtAnswerOnRing.TabIndex = 27;
			this.txtAnswerOnRing.Text = "0";
			this.txtAnswerOnRing.TextChanged += new System.EventHandler(this.txtAnswerOnRing_TextChanged);
			// 
			// chkUseSoundCard
			// 
			this.chkUseSoundCard.BackColor = System.Drawing.SystemColors.Control;
			this.chkUseSoundCard.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.chkUseSoundCard.Cursor = System.Windows.Forms.Cursors.Default;
			this.chkUseSoundCard.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.chkUseSoundCard.ForeColor = System.Drawing.SystemColors.ControlText;
			this.chkUseSoundCard.Location = new System.Drawing.Point(152, 96);
			this.chkUseSoundCard.Name = "chkUseSoundCard";
			this.chkUseSoundCard.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.chkUseSoundCard.Size = new System.Drawing.Size(97, 33);
			this.chkUseSoundCard.TabIndex = 16;
			this.chkUseSoundCard.Text = "UseSoundCard";
			// 
			// chkInterruptWave
			// 
			this.chkInterruptWave.BackColor = System.Drawing.SystemColors.Control;
			this.chkInterruptWave.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.chkInterruptWave.Cursor = System.Windows.Forms.Cursors.Default;
			this.chkInterruptWave.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.chkInterruptWave.ForeColor = System.Drawing.SystemColors.ControlText;
			this.chkInterruptWave.Location = new System.Drawing.Point(40, 120);
			this.chkInterruptWave.Name = "chkInterruptWave";
			this.chkInterruptWave.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.chkInterruptWave.Size = new System.Drawing.Size(97, 27);
			this.chkInterruptWave.TabIndex = 15;
			this.chkInterruptWave.Text = "InterruptWave";
			// 
			// chkEnableVoice
			// 
			this.chkEnableVoice.BackColor = System.Drawing.SystemColors.Control;
			this.chkEnableVoice.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.chkEnableVoice.Cursor = System.Windows.Forms.Cursors.Default;
			this.chkEnableVoice.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.chkEnableVoice.ForeColor = System.Drawing.SystemColors.ControlText;
			this.chkEnableVoice.Location = new System.Drawing.Point(40, 96);
			this.chkEnableVoice.Name = "chkEnableVoice";
			this.chkEnableVoice.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.chkEnableVoice.Size = new System.Drawing.Size(97, 33);
			this.chkEnableVoice.TabIndex = 14;
			this.chkEnableVoice.Text = "EnableVoice";
			// 
			// Label6
			// 
			this.Label6.AutoSize = true;
			this.Label6.BackColor = System.Drawing.SystemColors.Control;
			this.Label6.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label6.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label6.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label6.Location = new System.Drawing.Point(160, 72);
			this.Label6.Name = "Label6";
			this.Label6.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label6.Size = new System.Drawing.Size(89, 13);
			this.Label6.TabIndex = 13;
			this.Label6.Text = "SilenceThreshold";
			// 
			// Label5
			// 
			this.Label5.AutoSize = true;
			this.Label5.BackColor = System.Drawing.SystemColors.Control;
			this.Label5.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label5.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label5.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label5.Location = new System.Drawing.Point(160, 48);
			this.Label5.Name = "Label5";
			this.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label5.Size = new System.Drawing.Size(69, 13);
			this.Label5.TabIndex = 12;
			this.Label5.Text = "TrimSeconds";
			// 
			// Label4
			// 
			this.Label4.AutoSize = true;
			this.Label4.BackColor = System.Drawing.SystemColors.Control;
			this.Label4.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label4.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label4.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label4.Location = new System.Drawing.Point(160, 24);
			this.Label4.Name = "Label4";
			this.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label4.Size = new System.Drawing.Size(103, 13);
			this.Label4.TabIndex = 11;
			this.Label4.Text = "MaxMessageLength";
			// 
			// Label3
			// 
			this.Label3.AutoSize = true;
			this.Label3.BackColor = System.Drawing.SystemColors.Control;
			this.Label3.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label3.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label3.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label3.Location = new System.Drawing.Point(24, 72);
			this.Label3.Name = "Label3";
			this.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label3.Size = new System.Drawing.Size(52, 13);
			this.Label3.TabIndex = 10;
			this.Label3.Text = "RetryWait";
			// 
			// Label2
			// 
			this.Label2.AutoSize = true;
			this.Label2.BackColor = System.Drawing.SystemColors.Control;
			this.Label2.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label2.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label2.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label2.Location = new System.Drawing.Point(24, 48);
			this.Label2.Name = "Label2";
			this.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label2.Size = new System.Drawing.Size(68, 13);
			this.Label2.TabIndex = 9;
			this.Label2.Text = "MaxAttempts";
			// 
			// Label1
			// 
			this.Label1.AutoSize = true;
			this.Label1.BackColor = System.Drawing.SystemColors.Control;
			this.Label1.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label1.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label1.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label1.Location = new System.Drawing.Point(24, 24);
			this.Label1.Name = "Label1";
			this.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label1.Size = new System.Drawing.Size(78, 13);
			this.Label1.TabIndex = 8;
			this.Label1.Text = "AnswerOnRing";
			// 
			// Frame3
			// 
			this.Frame3.BackColor = System.Drawing.SystemColors.Control;
			this.Frame3.Controls.AddRange(new System.Windows.Forms.Control[] {
																				 this.txtDTMF,
																				 this.label9,
																				 this.cdCommonDialog,
																				 this.chkOverwrite,
																				 this.cmdStop,
																				 this.cmdRecord,
																				 this.cmdDTMF,
																				 this.cmdPlay,
																				 this.txtWavDirectory,
																				 this.Label7});
			this.Frame3.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Frame3.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Frame3.Location = new System.Drawing.Point(8, 264);
			this.Frame3.Name = "Frame3";
			this.Frame3.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Frame3.Size = new System.Drawing.Size(321, 152);
			this.Frame3.TabIndex = 18;
			this.Frame3.TabStop = false;
			this.Frame3.Text = " Wav Files ";
			// 
			// cdCommonDialog
			// 
			this.cdCommonDialog.ContainingControl = this;
			this.cdCommonDialog.Enabled = true;
			this.cdCommonDialog.Location = new System.Drawing.Point(280, 56);
			this.cdCommonDialog.Name = "cdCommonDialog";
			this.cdCommonDialog.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("cdCommonDialog.OcxState")));
			this.cdCommonDialog.Size = new System.Drawing.Size(32, 32);
			this.cdCommonDialog.TabIndex = 25;
			// 
			// chkOverwrite
			// 
			this.chkOverwrite.BackColor = System.Drawing.SystemColors.Control;
			this.chkOverwrite.Cursor = System.Windows.Forms.Cursors.Default;
			this.chkOverwrite.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.chkOverwrite.ForeColor = System.Drawing.SystemColors.ControlText;
			this.chkOverwrite.Location = new System.Drawing.Point(200, 64);
			this.chkOverwrite.Name = "chkOverwrite";
			this.chkOverwrite.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.chkOverwrite.Size = new System.Drawing.Size(81, 33);
			this.chkOverwrite.TabIndex = 24;
			this.chkOverwrite.Text = "Overwrite";
			// 
			// cmdStop
			// 
			this.cmdStop.BackColor = System.Drawing.SystemColors.Control;
			this.cmdStop.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdStop.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdStop.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdStop.Location = new System.Drawing.Point(112, 96);
			this.cmdStop.Name = "cmdStop";
			this.cmdStop.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdStop.Size = new System.Drawing.Size(76, 29);
			this.cmdStop.TabIndex = 23;
			this.cmdStop.Text = "Stop";
			this.cmdStop.Click += new System.EventHandler(this.cmdStop_Click);
			// 
			// cmdRecord
			// 
			this.cmdRecord.BackColor = System.Drawing.SystemColors.Control;
			this.cmdRecord.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdRecord.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdRecord.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdRecord.Location = new System.Drawing.Point(112, 64);
			this.cmdRecord.Name = "cmdRecord";
			this.cmdRecord.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdRecord.Size = new System.Drawing.Size(76, 29);
			this.cmdRecord.TabIndex = 22;
			this.cmdRecord.Text = "Record...";
			this.cmdRecord.Click += new System.EventHandler(this.cmdRecord_Click);
			// 
			// cmdDTMF
			// 
			this.cmdDTMF.BackColor = System.Drawing.SystemColors.Control;
			this.cmdDTMF.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdDTMF.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdDTMF.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdDTMF.Location = new System.Drawing.Point(24, 96);
			this.cmdDTMF.Name = "cmdDTMF";
			this.cmdDTMF.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdDTMF.Size = new System.Drawing.Size(76, 29);
			this.cmdDTMF.TabIndex = 21;
			this.cmdDTMF.Text = "DTMF...";
			this.cmdDTMF.Click += new System.EventHandler(this.cmdDTMF_Click);
			// 
			// cmdPlay
			// 
			this.cmdPlay.BackColor = System.Drawing.SystemColors.Control;
			this.cmdPlay.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdPlay.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdPlay.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdPlay.Location = new System.Drawing.Point(24, 64);
			this.cmdPlay.Name = "cmdPlay";
			this.cmdPlay.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdPlay.Size = new System.Drawing.Size(76, 29);
			this.cmdPlay.TabIndex = 20;
			this.cmdPlay.Text = "Play...";
			this.cmdPlay.Click += new System.EventHandler(this.cmdPlay_Click);
			// 
			// txtWavDirectory
			// 
			this.txtWavDirectory.AcceptsReturn = true;
			this.txtWavDirectory.AutoSize = false;
			this.txtWavDirectory.BackColor = System.Drawing.SystemColors.Window;
			this.txtWavDirectory.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtWavDirectory.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtWavDirectory.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtWavDirectory.Location = new System.Drawing.Point(104, 24);
			this.txtWavDirectory.MaxLength = 0;
			this.txtWavDirectory.Name = "txtWavDirectory";
			this.txtWavDirectory.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtWavDirectory.Size = new System.Drawing.Size(193, 25);
			this.txtWavDirectory.TabIndex = 19;
			this.txtWavDirectory.Text = "\\apax\\examples";
			// 
			// Label7
			// 
			this.Label7.AutoSize = true;
			this.Label7.BackColor = System.Drawing.SystemColors.Control;
			this.Label7.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label7.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label7.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label7.Location = new System.Drawing.Point(24, 28);
			this.Label7.Name = "Label7";
			this.Label7.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label7.Size = new System.Drawing.Size(73, 13);
			this.Label7.TabIndex = 18;
			this.Label7.Text = "Wav Directory";
			// 
			// lstTapiStatus
			// 
			this.lstTapiStatus.BackColor = System.Drawing.SystemColors.Window;
			this.lstTapiStatus.Cursor = System.Windows.Forms.Cursors.Default;
			this.lstTapiStatus.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.lstTapiStatus.ForeColor = System.Drawing.SystemColors.WindowText;
			this.lstTapiStatus.ItemHeight = 14;
			this.lstTapiStatus.Location = new System.Drawing.Point(336, 16);
			this.lstTapiStatus.Name = "lstTapiStatus";
			this.lstTapiStatus.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.lstTapiStatus.Size = new System.Drawing.Size(265, 382);
			this.lstTapiStatus.TabIndex = 26;
			// 
			// label8
			// 
			this.label8.Location = new System.Drawing.Point(336, 0);
			this.label8.Name = "label8";
			this.label8.Size = new System.Drawing.Size(120, 16);
			this.label8.TabIndex = 27;
			this.label8.Text = "Tapi Status";
			// 
			// label9
			// 
			this.label9.Location = new System.Drawing.Point(8, 128);
			this.label9.Name = "label9";
			this.label9.Size = new System.Drawing.Size(72, 16);
			this.label9.TabIndex = 26;
			this.label9.Text = "Send Tones";
			// 
			// txtDTMF
			// 
			this.txtDTMF.Location = new System.Drawing.Point(80, 128);
			this.txtDTMF.Name = "txtDTMF";
			this.txtDTMF.Size = new System.Drawing.Size(160, 20);
			this.txtDTMF.TabIndex = 27;
			this.txtDTMF.Text = "";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(608, 422);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.label8,
																		  this.lstTapiStatus,
																		  this.Frame3,
																		  this.Frame2,
																		  this.Frame1});
			this.Name = "Form1";
			this.Text = "Form1";
			this.Activated += new System.EventHandler(this.Form1_Activated);
			this.Frame1.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).EndInit();
			this.Frame2.ResumeLayout(false);
			this.Frame3.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.cdCommonDialog)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		private void cmdAnswer_Click(object sender, System.EventArgs e)
		{
			lstTapiStatus.Items.Add(axApax1.TapiState.ToString());
			axApax1.TapiAutoAnswer();
			lstTapiStatus.Items.Add(axApax1.TapiState.ToString());
		}

		private void Frame1_Enter(object sender, System.EventArgs e)
		{
		
		}

		private void cmdDial_Click(object sender, System.EventArgs e)
		{
			axApax1.TapiDial();
			lstTapiStatus.Items.Add(axApax1.TapiState.ToString());
		}

		private void cmdCancel_Click(object sender, System.EventArgs e)
		{
			axApax1.TapiCancelCall();
			lstTapiStatus.Items.Add(axApax1.TapiState.ToString());
		}

		private void cmdSelect_Click(object sender, System.EventArgs e)
		{
			axApax1.Select();
			//axApax1.SelectedDevice();
		}

		private void cmdConfig_Click(object sender, System.EventArgs e)
		{
			axApax1.TapiShowConfigDialog(true);
		}

		private void cmdPlay_Click(object sender, System.EventArgs e)
		{
			cdCommonDialog.FileName = txtWavDirectory.Text;
			if (cdCommonDialog.FileName != "")
			{
				lstTapiStatus.Items.Add("Playing wave file");
				axApax1.TapiPlayWaveFile(cdCommonDialog.FileName);
			}		
		}

		private void cmdRecord_Click(object sender, System.EventArgs e)
		{
			bool OverWriteBool;
			cdCommonDialog.DialogTitle = "Record Wav File";
			cdCommonDialog.InitDir = txtWavDirectory.Text;
			cdCommonDialog.ShowSave();
			OverWriteBool = chkOverwrite.Checked;
			lstTapiStatus.Items.Add("Recording wave file )" + cdCommonDialog.FileName + ")");
			axApax1.TapiRecordWaveFile(cdCommonDialog.FileName, true);

		}

		private void cmdStop_Click(object sender, System.EventArgs e)
		{
			axApax1.TapiStopWaveFile();
			lstTapiStatus.Items.Add("Stop wave file");
		}

		private void cmdDTMF_Click(object sender, System.EventArgs e)
		{
			string S;
			S = txtDTMF.Text;
			if (S != "")
			{
				lstTapiStatus.Items.Add("SendTone (" + S + ")");
				axApax1.TapiSendTone(S);
			}
			else
				lstTapiStatus.Items.Add("No tones to send");
		}

		private void Form1_Activated(object sender, System.EventArgs e)
		{
			axApax1.Visible = false;
			txtAnswerOnRing.Text = axApax1.AnswerOnRing.ToString();
			txtMaxAttempts.Text = axApax1.MaxAttempts.ToString();
			txtRetryWait.Text = axApax1.TapiRetryWait.ToString();
			txtMaxMessageLength.Text = axApax1.MaxMessageLength.ToString();
			txtTrimSeconds.Text = axApax1.TrimSeconds.ToString();
			txtSilenceThreshold.Text = axApax1.SilenceThreshold.ToString();
			chkEnableVoice.Checked = axApax1.EnableVoice;
            chkInterruptWave.Checked = axApax1.InterruptWave;
            chkUseSoundCard.Checked = axApax1.UseSoundCard;
            chkTapiStatusDisplay.Checked = axApax1.TapiStatusDisplay;
		}

		private void txtAnswerOnRing_TextChanged(object sender, System.EventArgs e)
		{
			axApax1.AnswerOnRing = Int32.Parse(txtAnswerOnRing.Text);
		}

		private void axApax1_OnTapiConnect(object sender, System.EventArgs e)
		{
			lstTapiStatus.Items.Add("OnTapiConnect fired");
			lstTapiStatus.Items.Add(axApax1.TapiState.ToString());
			if (axApax1.EnableVoice)
				axApax1.TapiPlayWaveFile(txtWavDirectory.Text);
		}

		private void axApax1_OnTapiCallerID(object sender, AxAPAX1.IApaxEvents_OnTapiCallerIDEvent e)
		{
			lstTapiStatus.Items.Add("Caller ID = " + e.iD);
			lstTapiStatus.Items.Add("Name = " + e.iDName);
		}

		private void axApax1_OnTapiDTMF(object sender, AxAPAX1.IApaxEvents_OnTapiDTMFEvent e)
		{
			lstTapiStatus.Items.Add("OnTapiDTMF:" + e.digit);
			lstTapiStatus.Items.Add(axApax1.TapiState.ToString());
		}

	}
}
