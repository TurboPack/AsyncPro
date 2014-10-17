using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ExSend
{
	/**********************************************************\
	|*                  ExSend - APAX 1.12                    *|
	|*      Copyright (c) TurboPower Software 2002            *|
	|*                 All rights reserved.                   *|
	|**********************************************************|

	|**********************Description*************************|
	|* An example of data being sent using a protocol.        *|
	\**********************************************************/
	public class Form1 : System.Windows.Forms.Form
	{
		private AxAPAX1.AxApax axApax1;
		private System.Windows.Forms.Button btnSend;
		private System.Windows.Forms.Button btnDial;
		private System.Windows.Forms.Button btnHangup;
		private System.Windows.Forms.Button btnCancel;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.ComboBox cbProtocol;
		private System.Windows.Forms.TextBox txtPhoneNum;
		private AxMSComDlg.AxCommonDialog cdCommonDialog;
		/// <summary>
		/// Required designer variable.
		/// </summary>
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
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}
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
			this.axApax1 = new AxAPAX1.AxApax();
			this.btnSend = new System.Windows.Forms.Button();
			this.btnDial = new System.Windows.Forms.Button();
			this.btnHangup = new System.Windows.Forms.Button();
			this.btnCancel = new System.Windows.Forms.Button();
			this.cbProtocol = new System.Windows.Forms.ComboBox();
			this.txtPhoneNum = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.cdCommonDialog = new AxMSComDlg.AxCommonDialog();
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.cdCommonDialog)).BeginInit();
			this.SuspendLayout();
			// 
			// axApax1
			// 
			this.axApax1.Location = new System.Drawing.Point(8, 8);
			this.axApax1.Name = "axApax1";
			this.axApax1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axApax1.OcxState")));
			this.axApax1.Size = new System.Drawing.Size(472, 264);
			this.axApax1.TabIndex = 0;
			this.axApax1.OnTapiPortClose += new System.EventHandler(this.axApax1_OnTapiPortClose);
			this.axApax1.OnTapiPortOpen += new System.EventHandler(this.axApax1_OnTapiPortOpen);
			// 
			// btnSend
			// 
			this.btnSend.Location = new System.Drawing.Point(264, 336);
			this.btnSend.Name = "btnSend";
			this.btnSend.Size = new System.Drawing.Size(72, 24);
			this.btnSend.TabIndex = 1;
			this.btnSend.Text = "Send";
			this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
			// 
			// btnDial
			// 
			this.btnDial.Location = new System.Drawing.Point(264, 296);
			this.btnDial.Name = "btnDial";
			this.btnDial.Size = new System.Drawing.Size(72, 24);
			this.btnDial.TabIndex = 2;
			this.btnDial.Text = "Dial";
			this.btnDial.Click += new System.EventHandler(this.btnDial_Click);
			// 
			// btnHangup
			// 
			this.btnHangup.Location = new System.Drawing.Point(352, 296);
			this.btnHangup.Name = "btnHangup";
			this.btnHangup.Size = new System.Drawing.Size(64, 24);
			this.btnHangup.TabIndex = 3;
			this.btnHangup.Text = "Hangup";
			this.btnHangup.Click += new System.EventHandler(this.btnHangup_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.Location = new System.Drawing.Point(352, 336);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.Size = new System.Drawing.Size(64, 24);
			this.btnCancel.TabIndex = 4;
			this.btnCancel.Text = "Cancel";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// cbProtocol
			// 
			this.cbProtocol.Location = new System.Drawing.Point(112, 344);
			this.cbProtocol.Name = "cbProtocol";
			this.cbProtocol.Size = new System.Drawing.Size(136, 21);
			this.cbProtocol.TabIndex = 5;
			// 
			// txtPhoneNum
			// 
			this.txtPhoneNum.Location = new System.Drawing.Point(112, 312);
			this.txtPhoneNum.Name = "txtPhoneNum";
			this.txtPhoneNum.Size = new System.Drawing.Size(136, 20);
			this.txtPhoneNum.TabIndex = 6;
			this.txtPhoneNum.Text = "";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(24, 312);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(88, 16);
			this.label1.TabIndex = 7;
			this.label1.Text = "Phone Number";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(48, 352);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(56, 16);
			this.label2.TabIndex = 8;
			this.label2.Text = "Protocol";
			// 
			// cdCommonDialog
			// 
			this.cdCommonDialog.Enabled = true;
			this.cdCommonDialog.Location = new System.Drawing.Point(24, 24);
			this.cdCommonDialog.Name = "cdCommonDialog";
			this.cdCommonDialog.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("cdCommonDialog.OcxState")));
			this.cdCommonDialog.Size = new System.Drawing.Size(32, 32);
			this.cdCommonDialog.TabIndex = 9;
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(480, 398);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.cdCommonDialog,
																		  this.label2,
																		  this.label1,
																		  this.txtPhoneNum,
																		  this.cbProtocol,
																		  this.btnCancel,
																		  this.btnHangup,
																		  this.btnDial,
																		  this.btnSend,
																		  this.axApax1});
			this.Name = "Form1";
			this.Text = "Form1";
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.cdCommonDialog)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		private void openFileDialog2_FileOk(object sender, System.ComponentModel.CancelEventArgs e)
		{
		
		}

		private void btnDial_Click(object sender, System.EventArgs e)
		{
			axApax1.TapiNumber = txtPhoneNum.Text;
			axApax1.TapiDial();
		}

		private void btnSend_Click(object sender, System.EventArgs e)
		{
			cdCommonDialog.FileName = axApax1.SendFileName;
			if (cdCommonDialog.FileName != "") 
			{
				axApax1.SendFileName = cdCommonDialog.FileName;
				Text = "Sending " + cdCommonDialog.FileName;				
				// change ptZmodem here for other protocol types
				axApax1.Protocol = APAX1.TxProtocolType.ptZmodem;
				axApax1.StartTransmit();
			}
		
		}

		private void btnHangup_Click(object sender, System.EventArgs e)
		{
			axApax1.Close();
		}

		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			axApax1.CancelProtocol();
		}

		private void axApax1_OnTapiPortClose(object sender, System.EventArgs e)
		{
			btnSend.Enabled = false;
		}

		private void axApax1_OnTapiPortOpen(object sender, System.EventArgs e)
		{
			btnSend.Enabled = true;
		}
	}
}
