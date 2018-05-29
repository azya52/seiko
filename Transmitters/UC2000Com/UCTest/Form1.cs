using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.IO;
using System.IO.Ports;
using System.Windows.Forms;
using System.Globalization;

namespace UC2000Com
{
    public partial class UC2000Com : Form
    {
        //public Realterm.RealtermIntfClass R;
        static System.Windows.Forms.Timer myTimer = new System.Windows.Forms.Timer();
        private SerialPort UCPort = null;
        private byte[] buffer = new byte[2048];
        private String lastFileName = null;

        private void BusyWaitms(int ms)
        {
            DateTime start = DateTime.Now;
            DateTime then = start.AddMilliseconds(ms);
            DateTime now = start;
            //Console.Write("Busywait: start: " + start.ToString("HH:mm:FFF") + " ende: " + then.ToString("HH:mm:FFF"));
            while (then > now) 
            {
                now = DateTime.Now;
            } // busy wait until 'now' has reached 'then'
            //Console.WriteLine(" - Busywait fertig: soll: " + ms + "ms, ist: " + (DateTime.Now - start).Milliseconds + "ms");
        }

        private bool OpenSerial()
        {
            bool result = true;
            try
            {
                UCPort = new SerialPort("COM" + Properties.Settings.Default.COMPort, 9600);
                UCPort.Open();
                UCPort.DtrEnable = true;
                UCPort.RtsEnable = true;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString() + " opening COMPort failed");
                result = false;
            }
            finally
            {
            }
            return result;
        }

        void SendByte(byte b)
        {
            if(b!= 0x15)
            {
                timer1.Stop();
            }
            byte[] buf = new byte[1];
            buf[0] = b;
            if (UCPort != null)
            {
                try
                {
                    UCPort.Write(buf, 0, 1);
                }
                catch (Exception e)
                {
                }
            }
        }
        
        private String BufferToStringDump(Byte[] buffer, UInt32 length)
        {
            Int32 row, col, c;
            StringBuilder sbuild = new StringBuilder();

            for (row = 0; row < (length / 16); row++)
            {
                sbuild.Append((row * 16).ToString("X6"));
                sbuild.Append(":  ");
                for (col = 0; col < 16; col++)
                {
                    sbuild.Append(" ");
                    sbuild.Append(buffer[row * 16 + col].ToString("X2"));
                }

                //Add Asci-Dump
                sbuild.Append(" : ");
                for (col = 0; col < 16; col++)
                {
                    c = buffer[row * 16 + col];
                    if ((c >= 0x20) && (c <= 0x7f))
                    {
                        sbuild.Append((Char)c);
                    }
                    else
                    {
                        sbuild.Append(".");
                    }
                }

                sbuild.Append(Environment.NewLine);
            }


            //Rest of bytes (no complete line)
            Byte rest = (Byte)(length % 16);
            UInt32 lastline = (length / 16);
            if (rest > 0)
            {
                sbuild.Append((lastline * 16).ToString("X6"));
                sbuild.Append(":  ");
                for (col = 0; col < rest; col++)
                {
                    sbuild.Append(" ");
                    sbuild.Append(buffer[lastline * 16 + col].ToString("X2"));
                }
                //Fill unused Bytes with spaces
                for (col = rest; col < 16; col++)
                    sbuild.Append("   ");

                //Add Asci-Dump
                sbuild.Append(" : ");
                for (col = 0; col < rest; col++)
                {
                    c = buffer[lastline * 16 + col];
                    if ((c >= 0x20) && (c <= 0x7f))
                    {
                        sbuild.Append((Char)c);
                    }
                    else
                    {
                        sbuild.Append(".");
                    }
                }

                sbuild.Append(Environment.NewLine);
            }

            return sbuild.ToString();
        }

        public UC2000Com()
        {
            InitializeComponent();
            //R = new Realterm.RealtermIntfClass();
            MemPage.SelectedIndex = 0;
            myTimer.Tick += new EventHandler(TimerTick);
            myTimer.Interval = 100;
        }

        private void Connect_Click(object sender, EventArgs e)
        {
            if (OpenSerial())
            {
                Connect.Enabled = false;
                CntUp.Enabled = true;
                CntDn.Enabled = true;
                MemoA.Enabled = true;
                MemoB.Enabled = true;
                Cal.Enabled = true;
                CalMul.Enabled = true;
                CalDiv.Enabled = true;
                CalAdd.Enabled = true;
                CalSub.Enabled = true;
                CalRes.Enabled = true;
                CalCE.Enabled = true;
                CalAC.Enabled = true;
                CurLeft.Enabled = true;
                CurRight.Enabled = true;
                CurUp.Enabled = true;
                CurDown.Enabled = true;
                Download.Enabled = true;
                Uploaddata.Enabled = true;
                Uploadexe.Enabled = true;
                CharEntry.Enabled = true;
                Sym96.Enabled = true;
                Sym97.Enabled = true;
                Sym98.Enabled = true;
                Sym99.Enabled = true;
                Sym9A.Enabled = true;
                Sym9B.Enabled = true;
                Sym9C.Enabled = true;
                Sym9D.Enabled = true;
                Sym9E.Enabled = true;
                Sym9F.Enabled = true;
                btnStop.Enabled = true;
            }
        }

        private void CntUp_Click(object sender, EventArgs e)
        {
            SendByte(0x12);
        }

        private void CntDn_Click(object sender, EventArgs e)
        {
            SendByte(0x1f);
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            SendByte(0x1c);
            if (UCPort != null) UCPort.Close();
            Properties.Settings.Default.Save();
        }

        private void ReadMem_Click(object sender, EventArgs e)
        {
            if (UCPort != null)
            {
                UCPort.DiscardInBuffer();
                SendByte(0x05);
                BusyWaitms(100);
                SendByte((byte)MemPage.SelectedIndex);
                BusyWaitms(100);
                SendByte(0x00);
                myTimer.Start();
            }
        }

        private void TimerTick(object sender, EventArgs e)
        {
            Recd.Text = UCPort.BytesToRead.ToString() + " Bytes received";
            if (UCPort.BytesToRead >= 260)
            {
                myTimer.Stop();
                byte[] b = new byte[1024];
                UCPort.Read(b, 0, 4);
                UCPort.Read(b, 0, 256);

                textBox1.Text = BufferToStringDump(b, 256);
            }
        }

        private void Test_Click(object sender, EventArgs e)
        {
            string inpath = "e:\\UC2000\\time.trax.img.bin";
            string outpath = "e:\\UC2000\\tt.conv.bin";

            if (!File.Exists(inpath)) 
            {
                MessageBox.Show(this, "input-file " + inpath + " not found", "UC2000Com", MessageBoxButtons.OK);
                return;
            }

            if (File.Exists(outpath))
            {
                MessageBox.Show(this, "output-file " + outpath + " already exists!", "UC2000Com", MessageBoxButtons.OK);
                return;
            }

            FileStream ofs = File.Create(outpath);

            //Open the stream and read it back.
            FileStream fs = File.OpenRead(inpath);
            byte[] b = new byte[1];
            while (fs.Read(b,0,1) > 0)
            {
                ofs.WriteByte(b[0]);
            }
            fs.Close();
            ofs.Close();
            MessageBox.Show(this, "Conversion done", "UC2000Com", MessageBoxButtons.OK);
        }

        private String selectFileDialog() {
            string inpath;
            OpenFileDialog ofdlg = new OpenFileDialog();

            ofdlg.InitialDirectory = TempPath.Text;
            ofdlg.CheckFileExists = true;
            ofdlg.Filter = "bin files (*.bin)|*.bin|All files (*.*)|*.*";
            ofdlg.FilterIndex = 2;

            if (ofdlg.ShowDialog() == DialogResult.OK) {
                inpath = ofdlg.FileName;
                TempPath.Text = Directory.GetCurrentDirectory();

                if (!File.Exists(inpath))
                {
                    MessageBox.Show(this, "input-file " + inpath + " not found", "UC2000Com", MessageBoxButtons.OK);
                    return null;
                }

                return inpath;
            } else
            {
                return null;
            }
        }

        private void Writefile_Click(object sender, EventArgs e)
        {
            string outpath;
            SaveFileDialog sfdlg = new SaveFileDialog();

            sfdlg.InitialDirectory = TempPath.Text;
            sfdlg.Filter = "bin files (*.bin)|*.bin|All files (*.*)|*.*";
            sfdlg.FilterIndex = 2;

            if (sfdlg.ShowDialog() == DialogResult.OK)
            {
                outpath = sfdlg.FileName;
                TempPath.Text = Directory.GetCurrentDirectory();

                try
                {
                    FileStream fs = File.Create(outpath);
                    fs.Write(buffer, 0, 2048);
                    fs.Close();
                    MessageBox.Show(this, "Output file successfully written", "UC2000Com", MessageBoxButtons.OK);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(this, "Error writing output file: " + ex.ToString(), "UC2000Com", MessageBoxButtons.OK);
                }
            }
        }

        private void Download_Click(object sender, EventArgs e)
        {
            int offset = 0;
            DateTime start;
            byte page = 0;
            if (UCPort != null)
            {
                SendByte(0x0C);
                BusyWaitms(100);
                try
                {
                    for (page = 0; page < 8; page++)
                    {
                        UCPort.DiscardInBuffer();
                        BusyWaitms(100);
                        SendByte(0x05);
                        BusyWaitms(100);
                        SendByte(page);
                        BusyWaitms(100);
                        SendByte(0x00);
                        start = DateTime.Now;

                        while (UCPort.BytesToRead < 4)
                        {
                            if ((DateTime.Now - start).TotalMilliseconds > 500)
                            {
                                throw(new TimeoutException());
                            }
                        }
                        UCPort.Read(buffer, offset, 4);

                        while (UCPort.BytesToRead < 256)
                        {
                            Recd.Text = (offset + UCPort.BytesToRead) + " Bytes received";
                            Recd.Update();
                            if ((DateTime.Now - start).TotalMilliseconds > 3500)
                            {
                                throw (new TimeoutException());
                            }
                        }

                        Recd.Text = (offset + UCPort.BytesToRead) + " Bytes received";
                        Recd.Update();
                        
                        UCPort.Read(buffer, offset, 256);
                        offset += 256;
                        textBox1.Text = BufferToStringDump(buffer, (uint)offset);

                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(this, "Receive timeout occured, please check if UC2000 is in transmit mode!", "UC2000Com", MessageBoxButtons.OK);
                }
            }
        }

        public byte[] ReadAllBytes(string fileName){
            byte[] buffer = null;
            using (FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read)) {
                buffer = new byte[fs.Length];
                fs.Read(buffer, 0, (int)fs.Length);
            }
            return buffer;
        }

        private void Upload(byte[] data) {
            int pos = 0;
            DateTime start;
            byte page = 0;
            byte state = 0;
            int i = 0;
            if (UCPort != null) {
                try {
                    UCPort.DiscardInBuffer();
                    SendByte(0x1A);
                    BusyWaitms(100);
                    SendByte(0x18);
                    BusyWaitms(100);
                    SendByte(0x01);
                    start = DateTime.Now;
                    while (UCPort.BytesToRead < 3) {
                        if ((DateTime.Now - start).TotalMilliseconds > 300) {
                            throw (new TimeoutException());
                        }
                    }

                    for (page = 0; page < 8; page++) {
                        BusyWaitms(180);
                        UCPort.DiscardInBuffer();
                        SendByte(0x04);
                        BusyWaitms(90);
                        start = DateTime.Now;
                        while (UCPort.BytesToRead < 2) {
                            if ((DateTime.Now - start).TotalMilliseconds > 300) {
                                throw (new TimeoutException());
                            }
                        }

                        state = (byte)UCPort.ReadByte(); // discard echo
                        state = (byte)UCPort.ReadByte();
                        if (state != 0x13) {
                            Console.WriteLine("State 0x" + state.ToString("X2"));
                            throw (new Exception());
                        }

                        SendByte(page);
                        BusyWaitms(90);
                        SendByte(0x00);
                        BusyWaitms(90);
                        
                        for (i = 0; i < 256; i++) {
                            pos = page * 256 + i;
                            if (pos < data.Length) {
                                SendByte(data[pos]);
                            } else {
                                SendByte(0x00);
                            }
                            BusyWaitms(10);
                            textBox1.Text = ((pos + 1) + " Bytes sent");
                            textBox1.Update();
                        }
                        if (pos > data.Length - 1)
                        {
                            return;
                        }
                        
                    }
                }
                catch (Exception ex) {
                    MessageBox.Show(this, "Transmission error, please check if UC2000 is in transmit mode!", "UC2000Com", MessageBoxButtons.OK);
                }
            }
        }

        private void Uploaddata_Click(object sender, EventArgs e)
        {
            if (lastFileName == null || !checkBox1.Checked)
            {
                lastFileName = selectFileDialog();
            }
            if (lastFileName != null)
            {
                Upload(ReadAllBytes(lastFileName));
            }
        }

        private void Uploadexe_Click(object sender, EventArgs e)
        {
            if (lastFileName == null || !checkBox1.Checked)
            {
                lastFileName = selectFileDialog();
            }
            if (lastFileName != null)
            { 
                Upload(ReadAllBytes(lastFileName));
                BusyWaitms(100);
                SendByte(0x11);
                BusyWaitms(100);
                SendByte(0x18);
                BusyWaitms(100);
                SendByte(0x02);
                textBox1.Text = "Send complete";
            }
        }

        private void MemoA_Click(object sender, EventArgs e)
        {
            SendByte(0x06);
        }

        private void MemoB_Click(object sender, EventArgs e)
        {
            SendByte(0x07);
        }

        private void Cal_Click(object sender, EventArgs e)
        {
            SendByte(0x10);
        }

        private void CurLeft_Click(object sender, EventArgs e)
        {
            SendByte(0x08);
        }

        private void CurRight_Click(object sender, EventArgs e)
        {
            SendByte(0x09);
        }

        private void CurUp_Click(object sender, EventArgs e)
        {
            SendByte(0x0A);
        }

        private void CurDown_Click(object sender, EventArgs e)
        {
            SendByte(0x0B);
        }

        private void CharEntry_KeyPress(object sender, KeyPressEventArgs e)
        {
            SendByte((byte)e.KeyChar);
            e.Handled = true;
        }

        private void CalMul_Click(object sender, EventArgs e)
        {
            SendByte(0x7B);
        }

        private void CalDiv_Click(object sender, EventArgs e)
        {
            SendByte(0x7D);
        }

        private void CalAdd_Click(object sender, EventArgs e)
        {
            SendByte(0x2B);
        }

        private void CalSub_Click(object sender, EventArgs e)
        {
            SendByte(0x2D);
        }

        private void CalCE_Click(object sender, EventArgs e)
        {
            SendByte(0x5B);
        }

        private void CalAC_Click(object sender, EventArgs e)
        {
            SendByte(0x5D);
        }

        private void CalRes_Click(object sender, EventArgs e)
        {
            SendByte(0x3D);
        }

        private void Sym96_Click(object sender, EventArgs e)
        {
            SendByte(0x96);
        }

        private void Sym97_Click(object sender, EventArgs e)
        {
            SendByte(0x97);
        }

        private void Sym98_Click(object sender, EventArgs e)
        {
            SendByte(0x98);
        }

        private void Sym99_Click(object sender, EventArgs e)
        {
            SendByte(0x99);
        }

        private void Sym9A_Click(object sender, EventArgs e)
        {
            SendByte(0x9A);
        }

        private void Sym9B_Click(object sender, EventArgs e)
        {
            SendByte(0x9B);
        }

        private void Sym9C_Click(object sender, EventArgs e)
        {
            SendByte(0x9C);
        }

        private void Sym9D_Click(object sender, EventArgs e)
        {
            SendByte(0x9D);
        }

        private void Sym9E_Click(object sender, EventArgs e)
        {
            SendByte(0x9E);
        }

        private void Sym9F_Click(object sender, EventArgs e)
        {
            SendByte(0x9F);
        }

        private void SymStop_Click(object sender, EventArgs e)
        {
            if (timer1.Enabled)
            {
                timer1.Stop();
            }
            else
            {
                timer1.Start();
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            SendByte(0x15);
        }
    }
}