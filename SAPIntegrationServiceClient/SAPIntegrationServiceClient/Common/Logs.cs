using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace SAPIntegrationServiceClient.Common
{
    public class Logs
    {
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
