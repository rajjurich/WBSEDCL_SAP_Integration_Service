using SAPIntegrationServiceClient.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.ServiceProcess;
using System.Text;
using System.Timers;

namespace SAPIntegrationServiceClient
{
    public partial class Service : ServiceBase
    {
        private Timer TimerProcessing = null;
        private Logs _logs;
        public Service()
        {
            InitializeComponent();
        }
        public void OnDebug()
        {
            OnStart(null);
        }
        protected override void OnStart(string[] args)
        {
            TimerProcessing = new Timer();
            _logs = new Logs();
            _logs.WriteLogs("connecting");
            this.TimerProcessing.Interval = Convert.ToDouble(GenericFunctions.Interval);
            this.TimerProcessing.Elapsed += new System.Timers.ElapsedEventHandler(this.TimerProcessing_Elapsed);
            TimerProcessing.Start();
        }

        private void TimerProcessing_Elapsed(object sender, ElapsedEventArgs e)
        {
            TimerProcessing.Stop();            
            try
            {
                //while (true)
                //{                    
                CallClient(_logs);
                TimerProcessing.Start();
                //}
            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.Message, "Service.TimerProcessing_Elapsed");
                TimerProcessing.Start();
            }

        }

        protected override void OnStop()
        {
            _logs.WriteLogs("disconnected");
            TimerProcessing.Stop();
        }

        public void CallClient(Logs logs)
        {
            DateTime dt = DateTime.Now;
            
            string[] ct = GenericFunctions.compareTime.Split(':');

            DateTime fromCheckTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, Convert.ToInt32(ct[0]), Convert.ToInt32(ct[1]), 0, 0);
            DateTime toCheckTime = fromCheckTime.AddMinutes(1);
            if (dt > fromCheckTime && dt < toCheckTime)
            {
                _logs.WriteLogs("connected");
                AccessClient accessClient = AccessClient.GetInstance;
                WebClient webClient = accessClient.GetClient();
                string s = webClient.DownloadString(GenericFunctions.URL);
                logs.WriteLogs(s);
            }
            else
            {
                //logs.WriteLogs(".");
            }
        }
    }
}
