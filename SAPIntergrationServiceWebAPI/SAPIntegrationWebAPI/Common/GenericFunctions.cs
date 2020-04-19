using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace SAPIntegrationWebAPI.Common
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
        public static string GetDummyData { get; set; }
        public static int MinEmployeeCode { get; set; }
        public static int MaxEmployeeCode { get; set; }
        public static int MinEmployeeCode2 { get; set; }
        public static int MaxEmployeeCode2 { get; set; }
        public static int MinEmployeeCode3 { get; set; }
        public static int MaxEmployeeCode3 { get; set; }
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
            GetDummyData = Convert.ToString(ConfigurationManager.AppSettings["GetDummyData"]);

            MinEmployeeCode = Convert.ToInt32(Convert.ToString(ConfigurationManager.AppSettings["MinEmployeeCode"]));
            MaxEmployeeCode =  Convert.ToInt32(Convert.ToString(ConfigurationManager.AppSettings["MaxEmployeeCode"]));

            MinEmployeeCode2 = Convert.ToInt32(Convert.ToString(ConfigurationManager.AppSettings["MinEmployeeCode2"]));
            MaxEmployeeCode2 = Convert.ToInt32(Convert.ToString(ConfigurationManager.AppSettings["MaxEmployeeCode2"]));

            MinEmployeeCode3 = Convert.ToInt32(Convert.ToString(ConfigurationManager.AppSettings["MinEmployeeCode3"]));
            MaxEmployeeCode3 = Convert.ToInt32(Convert.ToString(ConfigurationManager.AppSettings["MaxEmployeeCode3"]));

        }
    }
}