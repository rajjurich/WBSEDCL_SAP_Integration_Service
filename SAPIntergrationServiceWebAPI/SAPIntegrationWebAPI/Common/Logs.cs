using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace SAPIntegrationWebAPI.Common
{
    public sealed class Logs
    {
        private static readonly Lazy<Logs> instance = new Lazy<Logs>(() => new Logs());
        private Logs()
        {

        }
        public static Logs GetInstance
        {
            get
            {
                return instance.Value;
            }
        }
        public void WriteLogs(string message)
        {
            string date = DateTime.Now.ToString("ddMMMyyyy");
            string path = GenericFunctions.AuditLogPath;
            path = path + @"\" + date + @"\";
            try
            {
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                StringBuilder sb = new StringBuilder();
                sb.AppendLine("[ " + DateTime.Now.ToString() + " ] [ " + message + " ] ");
                using (StreamWriter writer = new StreamWriter(path + "Log_" + DateTime.Now.ToString("ddMMMyyyy") + ".log", true))
                {
                    writer.Write(sb.ToString());
                    writer.Flush();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message, "AuditLog");
            }
        }
        public void ExceptionCaught(string message, string functionName)
        {
            WriteLogs(functionName + " ]\r\n[ " + message);
        }
    }
}