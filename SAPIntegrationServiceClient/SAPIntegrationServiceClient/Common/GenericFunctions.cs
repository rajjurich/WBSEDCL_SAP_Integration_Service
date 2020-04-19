using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;

namespace SAPIntegrationServiceClient.Common
{
    public class GenericFunctions
    {
        public static string AuditLogPath { get; set; }
        public static string Interval { get; set; }
        public static string URL { get; set; }
        public static string compareTime { get; set; }

        static GenericFunctions()
        {
            AuditLogPath = Convert.ToString(ConfigurationManager.AppSettings["AuditLogPath"]);

            Interval = Convert.ToString(ConfigurationManager.AppSettings["Interval"]);

            URL = Convert.ToString(ConfigurationManager.AppSettings["URL"]);

            compareTime = Convert.ToString(ConfigurationManager.AppSettings["compareTime"]);
        }
    }
}
