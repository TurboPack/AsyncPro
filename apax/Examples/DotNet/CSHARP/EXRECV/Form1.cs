using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace ExRecv
{
	/**********************************************************\
	|*                  ExRecv - APAX 1.12                    *|
	|*      Copyright (c) TurboPower Software 2002            *|
	|*                 All rights reserved.                   *|
	|**********************************************************|

	|**********************Description*************************|
	|* An example of data being received with protocol.       *|
	\**********************************************************/ 
	public class Form1 : System.Windows.Forms.Form
	{
		private AxAPAX1.AxApax axApax1;
		private System.Windows.Forms.Button btnStart;
		private System.Windows.Forms.Button btnStop;
		private System.Windows.Forms.ComboBox cbxProtocol;
		private System.Windows.Forms.Label label1;
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
			this.btnStart = new System.Windows.Forms.Button();
			this.btnStop = new System.Windows.Forms.Button();
			this.cbxProtocol = new System.Windows.Forms.ComboBox();
			this.label1 = new System.Windows.Forms.Label();
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).BeginInit();
			this.SuspendLayout();
			// 
			// axApax1
			// 
			this.axApax1.Location = new System.Drawing.Point(8, 16);
			this.axApax1.Name = "axApax1";
			this.axApax1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axApax1.OcxState")));
			this.axApax1.Size = new System.Drawing.Size(376, 184);
			this.axApax1.TabIndex = 0;
			// 
			// btnStart
			// 
			this.btnStart.Location = new System.Drawing.Point(192, 216);
			this.btnStart.Name = "btnStart";
			this.btnStart.Size = new System.Drawing.Size(80, 24);
			this.btnStart.TabIndex = 1;
			this.btnStart.Text = "Start";
			this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
			// 
			// btnStop
			// 
			this.btnStop.Location = new System.Drawing.Point(280, 216);
			this.btnStop.Name = "btnStop";
			this.btnStop.Size = new System.Drawing.Size(80, 24);
			this.btnStop.TabIndex = 2;
			this.btnStop.Text = "Stop";
			// 
			// cbxProtocol
			// 
			this.cbxProtocol.Location = new System.Drawing.Point(8, 224);
			this.cbxProtocol.Name = "cbxProtocol";
			this.cbxProtocol.Size = new System.Drawing.Size(136, 21);
			this.cbxProtocol.TabIndex = 3;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 208);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(136, 16);
			this.label1.TabIndex = 4;
			this.label1.Text = "Protocol";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(384, 262);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.label1,
																		  this.cbxProtocol,
																		  this.btnStop,
																		  this.btnStart,
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

		private void btnStart_Click(object sender, System.EventArgs e)
		{
			// change ptZmodem here for other protocol types
			axApax1.Protocol = APAX1.TxProtocolType.ptZmodem; 
			axApax1.TapiAutoAnswer();
			Text = "Ready to Receive";	
		}
	}
}
