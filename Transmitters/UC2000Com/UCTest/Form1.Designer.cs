namespace UC2000Com
{
    partial class UC2000Com
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.Connect = new System.Windows.Forms.Button();
            this.CntUp = new System.Windows.Forms.Button();
            this.CntDn = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.ReadMem = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.MemPage = new System.Windows.Forms.ComboBox();
            this.TempPath = new System.Windows.Forms.TextBox();
            this.Test = new System.Windows.Forms.Button();
            this.Writefile = new System.Windows.Forms.Button();
            this.Download = new System.Windows.Forms.Button();
            this.Uploaddata = new System.Windows.Forms.Button();
            this.Uploadexe = new System.Windows.Forms.Button();
            this.COMPortNum = new System.Windows.Forms.TextBox();
            this.MemoA = new System.Windows.Forms.Button();
            this.MemoB = new System.Windows.Forms.Button();
            this.Cal = new System.Windows.Forms.Button();
            this.CurLeft = new System.Windows.Forms.Button();
            this.CurRight = new System.Windows.Forms.Button();
            this.CurUp = new System.Windows.Forms.Button();
            this.CurDown = new System.Windows.Forms.Button();
            this.CharEntry = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.CalMul = new System.Windows.Forms.Button();
            this.CalDiv = new System.Windows.Forms.Button();
            this.CalRes = new System.Windows.Forms.Button();
            this.CalAdd = new System.Windows.Forms.Button();
            this.CalSub = new System.Windows.Forms.Button();
            this.CalCE = new System.Windows.Forms.Button();
            this.CalAC = new System.Windows.Forms.Button();
            this.Sym98 = new System.Windows.Forms.Button();
            this.Sym99 = new System.Windows.Forms.Button();
            this.Sym9A = new System.Windows.Forms.Button();
            this.Sym96 = new System.Windows.Forms.Button();
            this.Sym9F = new System.Windows.Forms.Button();
            this.Sym9E = new System.Windows.Forms.Button();
            this.Sym9D = new System.Windows.Forms.Button();
            this.Sym9C = new System.Windows.Forms.Button();
            this.Sym9B = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.Sym97 = new System.Windows.Forms.Button();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.Recd = new System.Windows.Forms.Label();
            this.btnStop = new System.Windows.Forms.Button();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.SuspendLayout();
            // 
            // Connect
            // 
            this.Connect.Location = new System.Drawing.Point(35, 40);
            this.Connect.Name = "Connect";
            this.Connect.Size = new System.Drawing.Size(75, 23);
            this.Connect.TabIndex = 0;
            this.Connect.Text = "Connect";
            this.Connect.UseVisualStyleBackColor = true;
            this.Connect.Click += new System.EventHandler(this.Connect_Click);
            // 
            // CntUp
            // 
            this.CntUp.Enabled = false;
            this.CntUp.Location = new System.Drawing.Point(116, 12);
            this.CntUp.Name = "CntUp";
            this.CntUp.Size = new System.Drawing.Size(66, 23);
            this.CntUp.TabIndex = 1;
            this.CntUp.Text = "Contrast +";
            this.CntUp.UseVisualStyleBackColor = true;
            this.CntUp.Click += new System.EventHandler(this.CntUp_Click);
            // 
            // CntDn
            // 
            this.CntDn.Enabled = false;
            this.CntDn.Location = new System.Drawing.Point(116, 40);
            this.CntDn.Name = "CntDn";
            this.CntDn.Size = new System.Drawing.Size(66, 23);
            this.CntDn.TabIndex = 2;
            this.CntDn.Text = "Contrast -";
            this.CntDn.UseVisualStyleBackColor = true;
            this.CntDn.Click += new System.EventHandler(this.CntDn_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 17);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "COMPort:";
            // 
            // textBox1
            // 
            this.textBox1.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox1.Location = new System.Drawing.Point(16, 174);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ReadOnly = true;
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBox1.Size = new System.Drawing.Size(663, 136);
            this.textBox1.TabIndex = 5;
            // 
            // ReadMem
            // 
            this.ReadMem.Location = new System.Drawing.Point(116, 147);
            this.ReadMem.Name = "ReadMem";
            this.ReadMem.Size = new System.Drawing.Size(103, 23);
            this.ReadMem.TabIndex = 7;
            this.ReadMem.Text = "Read Mempage";
            this.ReadMem.UseVisualStyleBackColor = true;
            this.ReadMem.Visible = false;
            this.ReadMem.Click += new System.EventHandler(this.ReadMem_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 152);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(57, 13);
            this.label2.TabIndex = 8;
            this.label2.Text = "Mempage:";
            this.label2.Visible = false;
            // 
            // MemPage
            // 
            this.MemPage.AllowDrop = true;
            this.MemPage.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.MemPage.FormattingEnabled = true;
            this.MemPage.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7"});
            this.MemPage.Location = new System.Drawing.Point(72, 147);
            this.MemPage.Name = "MemPage";
            this.MemPage.Size = new System.Drawing.Size(38, 21);
            this.MemPage.TabIndex = 9;
            this.MemPage.Visible = false;
            // 
            // TempPath
            // 
            this.TempPath.DataBindings.Add(new System.Windows.Forms.Binding("Text", global::UC2000Com.Properties.Settings.Default, "Path", true, System.Windows.Forms.DataSourceUpdateMode.OnPropertyChanged));
            this.TempPath.Location = new System.Drawing.Point(551, 316);
            this.TempPath.Name = "TempPath";
            this.TempPath.Size = new System.Drawing.Size(128, 20);
            this.TempPath.TabIndex = 10;
            this.TempPath.Text = global::UC2000Com.Properties.Settings.Default.Path;
            this.TempPath.Visible = false;
            // 
            // Test
            // 
            this.Test.Location = new System.Drawing.Point(178, 314);
            this.Test.Name = "Test";
            this.Test.Size = new System.Drawing.Size(75, 23);
            this.Test.TabIndex = 13;
            this.Test.Text = "Test";
            this.Test.UseVisualStyleBackColor = true;
            this.Test.Visible = false;
            this.Test.Click += new System.EventHandler(this.Test_Click);
            // 
            // Writefile
            // 
            this.Writefile.Location = new System.Drawing.Point(16, 314);
            this.Writefile.Name = "Writefile";
            this.Writefile.Size = new System.Drawing.Size(156, 23);
            this.Writefile.TabIndex = 15;
            this.Writefile.Text = "Write buffer to file";
            this.Writefile.UseVisualStyleBackColor = true;
            this.Writefile.Click += new System.EventHandler(this.Writefile_Click);
            // 
            // Download
            // 
            this.Download.Enabled = false;
            this.Download.Location = new System.Drawing.Point(16, 118);
            this.Download.Name = "Download";
            this.Download.Size = new System.Drawing.Size(203, 23);
            this.Download.TabIndex = 16;
            this.Download.Text = "Download UC2000 memory to buffer";
            this.Download.UseVisualStyleBackColor = true;
            this.Download.Click += new System.EventHandler(this.Download_Click);
            // 
            // Uploaddata
            // 
            this.Uploaddata.Enabled = false;
            this.Uploaddata.Location = new System.Drawing.Point(351, 118);
            this.Uploaddata.Name = "Uploaddata";
            this.Uploaddata.Size = new System.Drawing.Size(112, 52);
            this.Uploaddata.TabIndex = 17;
            this.Uploaddata.Text = "Upload data to UC2000";
            this.Uploaddata.UseVisualStyleBackColor = true;
            this.Uploaddata.Click += new System.EventHandler(this.Uploaddata_Click);
            // 
            // Uploadexe
            // 
            this.Uploadexe.Enabled = false;
            this.Uploadexe.Location = new System.Drawing.Point(477, 118);
            this.Uploadexe.Name = "Uploadexe";
            this.Uploadexe.Size = new System.Drawing.Size(112, 52);
            this.Uploadexe.TabIndex = 18;
            this.Uploadexe.Text = "Upload program to UC2000";
            this.Uploadexe.UseVisualStyleBackColor = true;
            this.Uploadexe.Click += new System.EventHandler(this.Uploadexe_Click);
            // 
            // COMPortNum
            // 
            this.COMPortNum.DataBindings.Add(new System.Windows.Forms.Binding("Text", global::UC2000Com.Properties.Settings.Default, "COMPort", true, System.Windows.Forms.DataSourceUpdateMode.OnPropertyChanged));
            this.COMPortNum.Location = new System.Drawing.Point(72, 14);
            this.COMPortNum.Name = "COMPortNum";
            this.COMPortNum.Size = new System.Drawing.Size(38, 20);
            this.COMPortNum.TabIndex = 3;
            this.COMPortNum.Text = global::UC2000Com.Properties.Settings.Default.COMPort;
            // 
            // MemoA
            // 
            this.MemoA.Enabled = false;
            this.MemoA.Location = new System.Drawing.Point(188, 11);
            this.MemoA.Name = "MemoA";
            this.MemoA.Size = new System.Drawing.Size(65, 23);
            this.MemoA.TabIndex = 19;
            this.MemoA.Text = "Memo A";
            this.MemoA.UseVisualStyleBackColor = true;
            this.MemoA.Click += new System.EventHandler(this.MemoA_Click);
            // 
            // MemoB
            // 
            this.MemoB.Enabled = false;
            this.MemoB.Location = new System.Drawing.Point(188, 40);
            this.MemoB.Name = "MemoB";
            this.MemoB.Size = new System.Drawing.Size(65, 23);
            this.MemoB.TabIndex = 20;
            this.MemoB.Text = "Memo B";
            this.MemoB.UseVisualStyleBackColor = true;
            this.MemoB.Click += new System.EventHandler(this.MemoB_Click);
            // 
            // Cal
            // 
            this.Cal.Enabled = false;
            this.Cal.Location = new System.Drawing.Point(403, 12);
            this.Cal.Name = "Cal";
            this.Cal.Size = new System.Drawing.Size(60, 23);
            this.Cal.TabIndex = 21;
            this.Cal.Text = "CAL";
            this.Cal.UseVisualStyleBackColor = true;
            this.Cal.Click += new System.EventHandler(this.Cal_Click);
            // 
            // CurLeft
            // 
            this.CurLeft.Enabled = false;
            this.CurLeft.Font = new System.Drawing.Font("Wingdings", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.CurLeft.Location = new System.Drawing.Point(273, 41);
            this.CurLeft.Name = "CurLeft";
            this.CurLeft.Size = new System.Drawing.Size(33, 23);
            this.CurLeft.TabIndex = 22;
            this.CurLeft.Text = "ï";
            this.CurLeft.UseVisualStyleBackColor = true;
            this.CurLeft.Click += new System.EventHandler(this.CurLeft_Click);
            // 
            // CurRight
            // 
            this.CurRight.Enabled = false;
            this.CurRight.Font = new System.Drawing.Font("Wingdings", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.CurRight.Location = new System.Drawing.Point(353, 41);
            this.CurRight.Name = "CurRight";
            this.CurRight.Size = new System.Drawing.Size(33, 23);
            this.CurRight.TabIndex = 23;
            this.CurRight.Text = "ð";
            this.CurRight.UseVisualStyleBackColor = true;
            this.CurRight.Click += new System.EventHandler(this.CurRight_Click);
            // 
            // CurUp
            // 
            this.CurUp.Enabled = false;
            this.CurUp.Font = new System.Drawing.Font("Wingdings", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.CurUp.Location = new System.Drawing.Point(314, 11);
            this.CurUp.Name = "CurUp";
            this.CurUp.Size = new System.Drawing.Size(33, 23);
            this.CurUp.TabIndex = 24;
            this.CurUp.Text = "ñ";
            this.CurUp.UseVisualStyleBackColor = true;
            this.CurUp.Click += new System.EventHandler(this.CurUp_Click);
            // 
            // CurDown
            // 
            this.CurDown.Enabled = false;
            this.CurDown.Font = new System.Drawing.Font("Wingdings", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.CurDown.Location = new System.Drawing.Point(314, 42);
            this.CurDown.Name = "CurDown";
            this.CurDown.Size = new System.Drawing.Size(33, 23);
            this.CurDown.TabIndex = 25;
            this.CurDown.Text = "ò";
            this.CurDown.UseVisualStyleBackColor = true;
            this.CurDown.Click += new System.EventHandler(this.CurDown_Click);
            // 
            // CharEntry
            // 
            this.CharEntry.Enabled = false;
            this.CharEntry.Location = new System.Drawing.Point(315, 71);
            this.CharEntry.Name = "CharEntry";
            this.CharEntry.Size = new System.Drawing.Size(71, 20);
            this.CharEntry.TabIndex = 26;
            this.CharEntry.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.CharEntry_KeyPress);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(229, 74);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(80, 13);
            this.label3.TabIndex = 27;
            this.label3.Text = "Key Entry Field:";
            // 
            // CalMul
            // 
            this.CalMul.Enabled = false;
            this.CalMul.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CalMul.Location = new System.Drawing.Point(403, 70);
            this.CalMul.Name = "CalMul";
            this.CalMul.Size = new System.Drawing.Size(27, 23);
            this.CalMul.TabIndex = 28;
            this.CalMul.Text = "x";
            this.CalMul.UseVisualStyleBackColor = true;
            this.CalMul.Click += new System.EventHandler(this.CalMul_Click);
            // 
            // CalDiv
            // 
            this.CalDiv.Enabled = false;
            this.CalDiv.Font = new System.Drawing.Font("Symbol", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.CalDiv.Location = new System.Drawing.Point(436, 70);
            this.CalDiv.Name = "CalDiv";
            this.CalDiv.Size = new System.Drawing.Size(27, 23);
            this.CalDiv.TabIndex = 29;
            this.CalDiv.Text = "¸";
            this.CalDiv.UseVisualStyleBackColor = true;
            this.CalDiv.Click += new System.EventHandler(this.CalDiv_Click);
            // 
            // CalRes
            // 
            this.CalRes.Enabled = false;
            this.CalRes.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CalRes.Location = new System.Drawing.Point(469, 70);
            this.CalRes.Name = "CalRes";
            this.CalRes.Size = new System.Drawing.Size(34, 23);
            this.CalRes.TabIndex = 30;
            this.CalRes.Text = "=";
            this.CalRes.UseVisualStyleBackColor = true;
            this.CalRes.Click += new System.EventHandler(this.CalRes_Click);
            // 
            // CalAdd
            // 
            this.CalAdd.Enabled = false;
            this.CalAdd.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CalAdd.Location = new System.Drawing.Point(403, 41);
            this.CalAdd.Name = "CalAdd";
            this.CalAdd.Size = new System.Drawing.Size(27, 23);
            this.CalAdd.TabIndex = 31;
            this.CalAdd.Text = "+";
            this.CalAdd.UseVisualStyleBackColor = true;
            this.CalAdd.Click += new System.EventHandler(this.CalAdd_Click);
            // 
            // CalSub
            // 
            this.CalSub.Enabled = false;
            this.CalSub.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CalSub.Location = new System.Drawing.Point(436, 42);
            this.CalSub.Name = "CalSub";
            this.CalSub.Size = new System.Drawing.Size(27, 23);
            this.CalSub.TabIndex = 32;
            this.CalSub.Text = "-";
            this.CalSub.UseVisualStyleBackColor = true;
            this.CalSub.Click += new System.EventHandler(this.CalSub_Click);
            // 
            // CalCE
            // 
            this.CalCE.Enabled = false;
            this.CalCE.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CalCE.Location = new System.Drawing.Point(469, 13);
            this.CalCE.Name = "CalCE";
            this.CalCE.Size = new System.Drawing.Size(34, 23);
            this.CalCE.TabIndex = 33;
            this.CalCE.Text = "CE";
            this.CalCE.UseVisualStyleBackColor = true;
            this.CalCE.Click += new System.EventHandler(this.CalCE_Click);
            // 
            // CalAC
            // 
            this.CalAC.Enabled = false;
            this.CalAC.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CalAC.Location = new System.Drawing.Point(469, 42);
            this.CalAC.Name = "CalAC";
            this.CalAC.Size = new System.Drawing.Size(34, 23);
            this.CalAC.TabIndex = 34;
            this.CalAC.Text = "AC";
            this.CalAC.UseVisualStyleBackColor = true;
            this.CalAC.Click += new System.EventHandler(this.CalAC_Click);
            // 
            // Sym98
            // 
            this.Sym98.Enabled = false;
            this.Sym98.Font = new System.Drawing.Font("Symbol", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym98.Image = global::UC2000Com.Resource1.Image98;
            this.Sym98.Location = new System.Drawing.Point(554, 42);
            this.Sym98.Name = "Sym98";
            this.Sym98.Size = new System.Drawing.Size(27, 23);
            this.Sym98.TabIndex = 36;
            this.Sym98.UseVisualStyleBackColor = true;
            this.Sym98.Click += new System.EventHandler(this.Sym98_Click);
            // 
            // Sym99
            // 
            this.Sym99.Enabled = false;
            this.Sym99.Font = new System.Drawing.Font("Symbol", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym99.Image = global::UC2000Com.Resource1.Image99;
            this.Sym99.Location = new System.Drawing.Point(587, 42);
            this.Sym99.Name = "Sym99";
            this.Sym99.Size = new System.Drawing.Size(27, 23);
            this.Sym99.TabIndex = 37;
            this.Sym99.UseVisualStyleBackColor = true;
            this.Sym99.Click += new System.EventHandler(this.Sym99_Click);
            // 
            // Sym9A
            // 
            this.Sym9A.Enabled = false;
            this.Sym9A.Font = new System.Drawing.Font("Symbol", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym9A.Image = global::UC2000Com.Resource1.Image9A;
            this.Sym9A.Location = new System.Drawing.Point(620, 42);
            this.Sym9A.Name = "Sym9A";
            this.Sym9A.Size = new System.Drawing.Size(27, 23);
            this.Sym9A.TabIndex = 38;
            this.Sym9A.UseVisualStyleBackColor = true;
            this.Sym9A.Click += new System.EventHandler(this.Sym9A_Click);
            // 
            // Sym96
            // 
            this.Sym96.Enabled = false;
            this.Sym96.Font = new System.Drawing.Font("Wingdings", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym96.Image = global::UC2000Com.Resource1.Image96;
            this.Sym96.Location = new System.Drawing.Point(652, 42);
            this.Sym96.Name = "Sym96";
            this.Sym96.Size = new System.Drawing.Size(27, 23);
            this.Sym96.TabIndex = 39;
            this.Sym96.UseVisualStyleBackColor = true;
            this.Sym96.Click += new System.EventHandler(this.Sym96_Click);
            // 
            // Sym9F
            // 
            this.Sym9F.Enabled = false;
            this.Sym9F.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Sym9F.Image = global::UC2000Com.Resource1.Image9F;
            this.Sym9F.Location = new System.Drawing.Point(652, 71);
            this.Sym9F.Name = "Sym9F";
            this.Sym9F.Size = new System.Drawing.Size(27, 23);
            this.Sym9F.TabIndex = 44;
            this.Sym9F.UseVisualStyleBackColor = true;
            this.Sym9F.Click += new System.EventHandler(this.Sym9F_Click);
            // 
            // Sym9E
            // 
            this.Sym9E.Enabled = false;
            this.Sym9E.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Sym9E.Image = global::UC2000Com.Resource1.Image9E;
            this.Sym9E.Location = new System.Drawing.Point(620, 71);
            this.Sym9E.Name = "Sym9E";
            this.Sym9E.Size = new System.Drawing.Size(27, 23);
            this.Sym9E.TabIndex = 43;
            this.Sym9E.UseVisualStyleBackColor = true;
            this.Sym9E.Click += new System.EventHandler(this.Sym9E_Click);
            // 
            // Sym9D
            // 
            this.Sym9D.Enabled = false;
            this.Sym9D.Font = new System.Drawing.Font("Webdings", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym9D.Image = global::UC2000Com.Resource1.Image9D;
            this.Sym9D.Location = new System.Drawing.Point(587, 71);
            this.Sym9D.Name = "Sym9D";
            this.Sym9D.Size = new System.Drawing.Size(27, 23);
            this.Sym9D.TabIndex = 42;
            this.Sym9D.UseVisualStyleBackColor = true;
            this.Sym9D.Click += new System.EventHandler(this.Sym9D_Click);
            // 
            // Sym9C
            // 
            this.Sym9C.Enabled = false;
            this.Sym9C.Font = new System.Drawing.Font("Webdings", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym9C.Image = global::UC2000Com.Resource1.Image9C;
            this.Sym9C.Location = new System.Drawing.Point(554, 71);
            this.Sym9C.Name = "Sym9C";
            this.Sym9C.Size = new System.Drawing.Size(27, 23);
            this.Sym9C.TabIndex = 41;
            this.Sym9C.UseVisualStyleBackColor = true;
            this.Sym9C.Click += new System.EventHandler(this.Sym9C_Click);
            // 
            // Sym9B
            // 
            this.Sym9B.Enabled = false;
            this.Sym9B.Font = new System.Drawing.Font("Wingdings 2", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym9B.Image = global::UC2000Com.Resource1.Image9B;
            this.Sym9B.Location = new System.Drawing.Point(521, 71);
            this.Sym9B.Name = "Sym9B";
            this.Sym9B.Size = new System.Drawing.Size(27, 23);
            this.Sym9B.TabIndex = 40;
            this.Sym9B.UseVisualStyleBackColor = true;
            this.Sym9B.Click += new System.EventHandler(this.Sym9B_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(518, 18);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(105, 13);
            this.label4.TabIndex = 45;
            this.label4.Text = "Special symbol keys:";
            // 
            // Sym97
            // 
            this.Sym97.Enabled = false;
            this.Sym97.Font = new System.Drawing.Font("Symbol", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(2)));
            this.Sym97.Image = global::UC2000Com.Resource1.Image97;
            this.Sym97.Location = new System.Drawing.Point(521, 42);
            this.Sym97.Name = "Sym97";
            this.Sym97.Size = new System.Drawing.Size(27, 23);
            this.Sym97.TabIndex = 35;
            this.Sym97.UseVisualStyleBackColor = true;
            this.Sym97.Click += new System.EventHandler(this.Sym97_Click);
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new System.Drawing.Point(602, 137);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(80, 17);
            this.checkBox1.TabIndex = 46;
            this.checkBox1.Text = "Use last file";
            this.checkBox1.UseVisualStyleBackColor = true;
            // 
            // Recd
            // 
            this.Recd.AutoSize = true;
            this.Recd.Location = new System.Drawing.Point(225, 123);
            this.Recd.Name = "Recd";
            this.Recd.Size = new System.Drawing.Size(16, 13);
            this.Recd.TabIndex = 12;
            this.Recd.Text = "   ";
            // 
            // btnStop
            // 
            this.btnStop.Enabled = false;
            this.btnStop.Location = new System.Drawing.Point(117, 69);
            this.btnStop.Name = "btnStop";
            this.btnStop.Size = new System.Drawing.Size(65, 23);
            this.btnStop.TabIndex = 47;
            this.btnStop.Text = "STOP";
            this.btnStop.UseVisualStyleBackColor = true;
            this.btnStop.Click += new System.EventHandler(this.SymStop_Click);
            // 
            // timer1
            // 
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // UC2000Com
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(694, 346);
            this.Controls.Add(this.btnStop);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.Sym9F);
            this.Controls.Add(this.Sym9E);
            this.Controls.Add(this.Sym9D);
            this.Controls.Add(this.Sym9C);
            this.Controls.Add(this.Sym9B);
            this.Controls.Add(this.Sym96);
            this.Controls.Add(this.Sym9A);
            this.Controls.Add(this.Sym99);
            this.Controls.Add(this.Sym98);
            this.Controls.Add(this.Sym97);
            this.Controls.Add(this.CalAC);
            this.Controls.Add(this.CalCE);
            this.Controls.Add(this.CalSub);
            this.Controls.Add(this.CalAdd);
            this.Controls.Add(this.CalRes);
            this.Controls.Add(this.CalDiv);
            this.Controls.Add(this.CalMul);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.CharEntry);
            this.Controls.Add(this.CurDown);
            this.Controls.Add(this.CurUp);
            this.Controls.Add(this.CurRight);
            this.Controls.Add(this.CurLeft);
            this.Controls.Add(this.Cal);
            this.Controls.Add(this.MemoB);
            this.Controls.Add(this.MemoA);
            this.Controls.Add(this.Uploadexe);
            this.Controls.Add(this.Uploaddata);
            this.Controls.Add(this.Download);
            this.Controls.Add(this.Writefile);
            this.Controls.Add(this.Test);
            this.Controls.Add(this.Recd);
            this.Controls.Add(this.TempPath);
            this.Controls.Add(this.MemPage);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.ReadMem);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.COMPortNum);
            this.Controls.Add(this.CntDn);
            this.Controls.Add(this.CntUp);
            this.Controls.Add(this.Connect);
            this.Name = "UC2000Com";
            this.Text = "UC2000Com";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Connect;
        private System.Windows.Forms.Button CntUp;
        private System.Windows.Forms.Button CntDn;
        private System.Windows.Forms.TextBox COMPortNum;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Button ReadMem;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox MemPage;
        private System.Windows.Forms.TextBox TempPath;
        private System.Windows.Forms.Button Test;
        private System.Windows.Forms.Button Writefile;
        private System.Windows.Forms.Button Download;
        private System.Windows.Forms.Button Uploaddata;
        private System.Windows.Forms.Button Uploadexe;
        private System.Windows.Forms.Button MemoA;
        private System.Windows.Forms.Button MemoB;
        private System.Windows.Forms.Button Cal;
        private System.Windows.Forms.Button CurLeft;
        private System.Windows.Forms.Button CurRight;
        private System.Windows.Forms.Button CurUp;
        private System.Windows.Forms.Button CurDown;
        private System.Windows.Forms.TextBox CharEntry;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button CalMul;
        private System.Windows.Forms.Button CalDiv;
        private System.Windows.Forms.Button CalRes;
        private System.Windows.Forms.Button CalAdd;
        private System.Windows.Forms.Button CalSub;
        private System.Windows.Forms.Button CalCE;
        private System.Windows.Forms.Button CalAC;
        private System.Windows.Forms.Button Sym97;
        private System.Windows.Forms.Button Sym98;
        private System.Windows.Forms.Button Sym99;
        private System.Windows.Forms.Button Sym9A;
        private System.Windows.Forms.Button Sym96;
        private System.Windows.Forms.Button Sym9F;
        private System.Windows.Forms.Button Sym9E;
        private System.Windows.Forms.Button Sym9D;
        private System.Windows.Forms.Button Sym9C;
        private System.Windows.Forms.Button Sym9B;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.Label Recd;
        private System.Windows.Forms.Button btnStop;
        private System.Windows.Forms.Timer timer1;
    }
}

