using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace sap_integration_service.Common
{
    public class GenericFunctions
    {
        public static string AuditLogPath { get; set; }        
        public static string Conn { get; set; }
        public static string Interval { get; set; }
        public static string AppServerHost { get; set; }
        public static string SystemNumber { get; set; }
        public static string SystemID { get; set; }
        public static string SapUser { get; set; }
        public static string SapPassword { get; set; }
        public static string Client { get; set; }
        public static string CreateFunctionName { get; set; }
        public static string GetTableName { get; set; }       
        static GenericFunctions()
        {            
            AuditLogPath = Convert.ToString(ConfigurationManager.AppSettings["AuditLogPath"]);
            Conn = Convert.ToString(ConfigurationManager.AppSettings["SqlConnectionString"]);
            Interval = Convert.ToString(ConfigurationManager.AppSettings["interval"]);
            AppServerHost = Convert.ToString(ConfigurationManager.AppSettings["AppServerHost"]);
            SystemNumber = Convert.ToString(ConfigurationManager.AppSettings["SystemNumber"]);
            SystemID = Convert.ToString(ConfigurationManager.AppSettings["SystemID"]);
            SapUser = Convert.ToString(ConfigurationManager.AppSettings["SapUser"]);
            SapPassword = Convert.ToString(ConfigurationManager.AppSettings["SapPassword"]);
            Client = Convert.ToString(ConfigurationManager.AppSettings["Client"]);
            CreateFunctionName = Convert.ToString(ConfigurationManager.AppSettings["CreateFunctionName"]);
            GetTableName = Convert.ToString(ConfigurationManager.AppSettings["GetTableName"]);

        }
    }
}
