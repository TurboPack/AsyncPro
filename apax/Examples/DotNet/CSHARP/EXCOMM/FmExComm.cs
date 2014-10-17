using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;


namespace ExComm
{

	#region Header information
	/**********************************************************\
	|*                    ExComm - APAX                       *|
	|*      Copyright (c) TurboPower Software 2002            *|
	|*                 All rights reserved.                   *|
	|**********************************************************|

	|**********************Description*************************|
	|* An example of data being sent/received across a port.  *|
	\**********************************************************/ 
	#endregion
	
	public class Form1 : System.Windows.Forms.Form
	{
		private AxAPAX1.AxApax axApax1;
		public System.Windows.Forms.GroupBox Frame1;
		public System.Windows.Forms.Button cmdClose;
		public System.Windows.Forms.Button cmdOpen;
		public System.Windows.Forms.TextBox txtComNumber;
		public System.Windows.Forms.Label Label1;
		public System.Windows.Forms.GroupBox Frame2;
		public System.Windows.Forms.TextBox txtPut;
		public System.Windows.Forms.Button cmdPutData;
		public System.Windows.Forms.Button cmdPutStringCRLF;
		public System.Windows.Forms.Button cmdPutString;
		public System.Windows.Forms.ListBox lstReceived;
		private System.Windows.Forms.Label Label2;

		/// <summary>
		/// Main.
		/// </Main - Run Application.>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}
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
			this.Frame1 = new System.Windows.Forms.GroupBox();
			this.cmdClose = new System.Windows.Forms.Button();
			this.cmdOpen = new System.Windows.Forms.Button();
			this.txtComNumber = new System.Windows.Forms.TextBox();
			this.Label1 = new System.Windows.Forms.Label();
			this.Frame2 = new System.Windows.Forms.GroupBox();
			this.txtPut = new System.Windows.Forms.TextBox();
			this.cmdPutData = new System.Windows.Forms.Button();
			this.cmdPutString = new System.Windows.Forms.Button();
			this.cmdPutStringCRLF = new System.Windows.Forms.Button();
			this.lstReceived = new System.Windows.Forms.ListBox();
			this.Label2 = new System.Windows.Forms.Label();
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).BeginInit();
			this.Frame1.SuspendLayout();
			this.Frame2.SuspendLayout();
			this.SuspendLayout();
			// 
			// axApax1
			// 
			this.axApax1.Location = new System.Drawing.Point(8, 8);
			this.axApax1.Name = "axApax1";
			this.axApax1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axApax1.OcxState")));
			this.axApax1.Size = new System.Drawing.Size(488, 224);
			this.axApax1.TabIndex = 0;
			this.axApax1.OnRXD += new AxAPAX1.IApaxEvents_OnRXDEventHandler(this.axApax1_OnRXD);
			// 
			// Frame1
			// 
			this.Frame1.BackColor = System.Drawing.SystemColors.Control;
			this.Frame1.Controls.AddRange(new System.Windows.Forms.Control[] {
																				 this.cmdClose,
																				 this.cmdOpen,
																				 this.txtComNumber,
																				 this.Label1});
			this.Frame1.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Frame1.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Frame1.Location = new System.Drawing.Point(16, 240);
			this.Frame1.Name = "Frame1";
			this.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Frame1.Size = new System.Drawing.Size(144, 96);
			this.Frame1.TabIndex = 1;
			this.Frame1.TabStop = false;
			// 
			// cmdClose
			// 
			this.cmdClose.BackColor = System.Drawing.SystemColors.Control;
			this.cmdClose.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdClose.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdClose.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdClose.Location = new System.Drawing.Point(72, 56);
			this.cmdClose.Name = "cmdClose";
			this.cmdClose.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdClose.Size = new System.Drawing.Size(48, 25);
			this.cmdClose.TabIndex = 4;
			this.cmdClose.Text = "Close";
			this.cmdClose.Click += new System.EventHandler(this.cmdClose_Click);
			// 
			// cmdOpen
			// 
			this.cmdOpen.BackColor = System.Drawing.SystemColors.Control;
			this.cmdOpen.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdOpen.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdOpen.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdOpen.Location = new System.Drawing.Point(16, 56);
			this.cmdOpen.Name = "cmdOpen";
			this.cmdOpen.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdOpen.Size = new System.Drawing.Size(48, 25);
			this.cmdOpen.TabIndex = 3;
			this.cmdOpen.Text = "Open";
			this.cmdOpen.Click += new System.EventHandler(this.cmdOpen_Click);
			// 
			// txtComNumber
			// 
			this.txtComNumber.AcceptsReturn = true;
			this.txtComNumber.AutoSize = false;
			this.txtComNumber.BackColor = System.Drawing.SystemColors.Window;
			this.txtComNumber.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtComNumber.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtComNumber.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtComNumber.Location = new System.Drawing.Point(80, 16);
			this.txtComNumber.MaxLength = 0;
			this.txtComNumber.Name = "txtComNumber";
			this.txtComNumber.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtComNumber.Size = new System.Drawing.Size(41, 24);
			this.txtComNumber.TabIndex = 1;
			this.txtComNumber.Text = "0";
			// 
			// Label1
			// 
			this.Label1.AutoSize = true;
			this.Label1.BackColor = System.Drawing.SystemColors.Control;
			this.Label1.Cursor = System.Windows.Forms.Cursors.Default;
			this.Label1.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Label1.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Label1.Location = new System.Drawing.Point(8, 24);
			this.Label1.Name = "Label1";
			this.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Label1.Size = new System.Drawing.Size(66, 13);
			this.Label1.TabIndex = 2;
			this.Label1.Text = "ComNumber";
			// 
			// Frame2
			// 
			this.Frame2.BackColor = System.Drawing.SystemColors.Control;
			this.Frame2.Controls.AddRange(new System.Windows.Forms.Control[] {
																				 this.txtPut,
																				 this.cmdPutData,
																				 this.cmdPutString,
																				 this.cmdPutStringCRLF});
			this.Frame2.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Frame2.ForeColor = System.Drawing.SystemColors.ControlText;
			this.Frame2.Location = new System.Drawing.Point(168, 240);
			this.Frame2.Name = "Frame2";
			this.Frame2.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.Frame2.Size = new System.Drawing.Size(304, 105);
			this.Frame2.TabIndex = 6;
			this.Frame2.TabStop = false;
			// 
			// txtPut
			// 
			this.txtPut.AcceptsReturn = true;
			this.txtPut.AutoSize = false;
			this.txtPut.BackColor = System.Drawing.SystemColors.Window;
			this.txtPut.Cursor = System.Windows.Forms.Cursors.IBeam;
			this.txtPut.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.txtPut.ForeColor = System.Drawing.SystemColors.WindowText;
			this.txtPut.Location = new System.Drawing.Point(8, 24);
			this.txtPut.MaxLength = 0;
			this.txtPut.Name = "txtPut";
			this.txtPut.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.txtPut.Size = new System.Drawing.Size(289, 19);
			this.txtPut.TabIndex = 9;
			this.txtPut.Text = "1234567890123456789012345678901234567890";
			// 
			// cmdPutData
			// 
			this.cmdPutData.BackColor = System.Drawing.SystemColors.Control;
			this.cmdPutData.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdPutData.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdPutData.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdPutData.Location = new System.Drawing.Point(200, 64);
			this.cmdPutData.Name = "cmdPutData";
			this.cmdPutData.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdPutData.Size = new System.Drawing.Size(89, 25);
			this.cmdPutData.TabIndex = 8;
			this.cmdPutData.Text = "PutData";
			this.cmdPutData.Click += new System.EventHandler(this.cmdPutData_Click);
			// 
			// cmdPutString
			// 
			this.cmdPutString.BackColor = System.Drawing.SystemColors.Control;
			this.cmdPutString.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdPutString.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdPutString.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdPutString.Location = new System.Drawing.Point(8, 64);
			this.cmdPutString.Name = "cmdPutString";
			this.cmdPutString.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdPutString.Size = new System.Drawing.Size(89, 25);
			this.cmdPutString.TabIndex = 6;
			this.cmdPutString.Text = "PutString";
			this.cmdPutString.Click += new System.EventHandler(this.cmdPutString_Click);
			// 
			// cmdPutStringCRLF
			// 
			this.cmdPutStringCRLF.BackColor = System.Drawing.SystemColors.Control;
			this.cmdPutStringCRLF.Cursor = System.Windows.Forms.Cursors.Default;
			this.cmdPutStringCRLF.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.cmdPutStringCRLF.ForeColor = System.Drawing.SystemColors.ControlText;
			this.cmdPutStringCRLF.Location = new System.Drawing.Point(104, 64);
			this.cmdPutStringCRLF.Name = "cmdPutStringCRLF";
			this.cmdPutStringCRLF.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.cmdPutStringCRLF.Size = new System.Drawing.Size(89, 25);
			this.cmdPutStringCRLF.TabIndex = 7;
			this.cmdPutStringCRLF.Text = "PutStringCRLF";
			this.cmdPutStringCRLF.Click += new System.EventHandler(this.cmdPutStringCRLF_Click);
			// 
			// lstReceived
			// 
			this.lstReceived.BackColor = System.Drawing.SystemColors.Window;
			this.lstReceived.Cursor = System.Windows.Forms.Cursors.Default;
			this.lstReceived.Font = new System.Drawing.Font("Arial", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.lstReceived.ForeColor = System.Drawing.SystemColors.WindowText;
			this.lstReceived.ItemHeight = 14;
			this.lstReceived.Location = new System.Drawing.Point(0, 360);
			this.lstReceived.Name = "lstReceived";
			this.lstReceived.RightToLeft = System.Windows.Forms.RightToLeft.No;
			this.lstReceived.Size = new System.Drawing.Size(497, 116);
			this.lstReceived.TabIndex = 11;
			// 
			// Label2
			// 
			this.Label2.Location = new System.Drawing.Point(8, 344);
			this.Label2.Name = "Label2";
			this.Label2.Size = new System.Drawing.Size(136, 16);
			this.Label2.TabIndex = 12;
			this.Label2.Text = "OnRXD Event Data";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(512, 486);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.Label2,
																		  this.lstReceived,
																		  this.Frame2,
																		  this.Frame1,
																		  this.axApax1});
			this.Name = "Form1";
			this.Text = "Form1";
			((System.ComponentModel.ISupportInitialize)(this.axApax1)).EndInit();
			this.Frame1.ResumeLayout(false);
			this.Frame2.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void cmdOpen_Click(object sender, System.EventArgs e)
		{
			axApax1.ComNumber = Int32.Parse(txtComNumber.Text);
			axApax1.PortOpen();
			txtComNumber.Text = axApax1.ComNumber.ToString();
		}

		private void cmdClose_Click(object sender, System.EventArgs e)
		{
			axApax1.Close();
		}

		private void cmdPutString_Click(object sender, System.EventArgs e)
		{
			axApax1.PutString(txtPut.Text);
		}

		private void cmdPutStringCRLF_Click(object sender, System.EventArgs e)
		{
			axApax1.PutStringCRLF(txtPut.Text);
		}

		private void cmdPutData_Click(object sender, System.EventArgs e)
		{
			int i,Count;
			Count = txtPut.TextLength;
			object [] S = new Object[Count];
			for (i = 0; i < Count; i++)
			{
				S[i] = txtPut.Text[i];
			}
			axApax1.PutData(S);
		}

		private void axApax1_OnRXD(object sender, AxAPAX1.IApaxEvents_OnRXDEvent e)
		{
			int L;
			string S;
			S = e.data.ToString();
			L = S.Length;
			S = "";
			for (int i = 0; i <= L; i++)
			{
				//S = S + " &H" & Hex(S[i]);
				S = S + S[i];
				lstReceived.Items.Add((S));
			}
		}
	}
}
