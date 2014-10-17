using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace WindowsApplication5
{
	/**********************************************************\
	|*                     ExDial 1.12                        *|
	|*      Copyright (c) TurboPower Software 2002            *|
	|*                 All rights reserved.                   *|
	|**********************************************************|

	|**********************Description*************************|
	|* An example of how to dial with a modem using TAPI or   *|
	|* DirectToCom.                                           *|
	\**********************************************************/ 
	public class Form1 : System.Windows.Forms.Form
	{
		private AxAPAX1.AxApax axApax1;
		private System.Windows.Forms.Button btDirect;
		private System.Windows.Forms.Button btTAPI;
		private System.Windows.Forms.Button btCancel;
		private System.Windows.Forms.Label lbPhoneNumber;
		private System.Windows.Forms.TextBox tbPhoneNumber;
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
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
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
			this.btDirect = new System.Windows.Forms.Button();
			this.btTAPI = new System.Windows.Forms.Button();
			this.btCancel = new System.Windows.Forms.Button();
			this.lbPhoneNumber = new System.Windows.Forms.Label();
			this.tbPhoneNumber = new System.Windows.Forms.TextBox();
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).BeginInit();
			this.SuspendLayout();
			// 
			// axApax1
			// 
			this.axApax1.Location = new System.Drawing.Point(8, 64);
			this.axApax1.Name = "axApax1";
			this.axApax1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axApax1.OcxState")));
			this.axApax1.Size = new System.Drawing.Size(336, 176);
			this.axApax1.TabIndex = 0;
			// 
			// btDirect
			// 
			this.btDirect.Location = new System.Drawing.Point(8, 8);
			this.btDirect.Name = "btDirect";
			this.btDirect.Size = new System.Drawing.Size(88, 24);
			this.btDirect.TabIndex = 1;
			this.btDirect.Text = "Direct to COM";
			this.btDirect.Click += new System.EventHandler(this.btDirect_Click);
			// 
			// btTAPI
			// 
			this.btTAPI.Location = new System.Drawing.Point(120, 8);
			this.btTAPI.Name = "btTAPI";
			this.btTAPI.Size = new System.Drawing.Size(88, 24);
			this.btTAPI.TabIndex = 2;
			this.btTAPI.Text = "TAPI";
			this.btTAPI.Click += new System.EventHandler(this.btTAPI_Click);
			// 
			// btCancel
			// 
			this.btCancel.Location = new System.Drawing.Point(232, 8);
			this.btCancel.Name = "btCancel";
			this.btCancel.Size = new System.Drawing.Size(96, 24);
			this.btCancel.TabIndex = 3;
			this.btCancel.Text = "Cancel Call";
			this.btCancel.Click += new System.EventHandler(this.btCancel_Click);
			// 
			// lbPhoneNumber
			// 
			this.lbPhoneNumber.Location = new System.Drawing.Point(16, 40);
			this.lbPhoneNumber.Name = "lbPhoneNumber";
			this.lbPhoneNumber.Size = new System.Drawing.Size(80, 16);
			this.lbPhoneNumber.TabIndex = 4;
			this.lbPhoneNumber.Text = "Phone Number";
			// 
			// tbPhoneNumber
			// 
			this.tbPhoneNumber.Location = new System.Drawing.Point(96, 40);
			this.tbPhoneNumber.Name = "tbPhoneNumber";
			this.tbPhoneNumber.Size = new System.Drawing.Size(152, 20);
			this.tbPhoneNumber.TabIndex = 5;
			this.tbPhoneNumber.Text = "";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(360, 266);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.tbPhoneNumber,
																		  this.lbPhoneNumber,
																		  this.btCancel,
																		  this.btTAPI,
																		  this.btDirect,
																		  this.axApax1});
			this.Name = "Form1";
			this.Text = "Form1";
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void btTAPI_Click(object sender, System.EventArgs e)
		{
			axApax1.TapiNumber = tbPhoneNumber.Text;
			axApax1.TerminalSetFocus();
			axApax1.TapiDial();
		}

		private void btDirect_Click(object sender, System.EventArgs e)
		{
			// setting up cr character for a carriage return
			char cr = '\u000D';
			axApax1.PortOpen();
			axApax1.TerminalSetFocus();
			// Replace "ATX3DT" with "ATX3DP" for pulse dialing
			// X3 requires no dialtone
			axApax1.PutString("ATX3DT" + tbPhoneNumber.Text + cr);
		}

		private void btCancel_Click(object sender, System.EventArgs e)
		{
			axApax1.Close();
		}


	}
}
