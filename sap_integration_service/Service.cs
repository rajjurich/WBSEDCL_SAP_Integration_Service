using SAP.Middleware.Connector;
using sap_integration_service.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Timers;

namespace sap_integration_service
{
    public partial class Service : ServiceBase
    {
        string conn = GenericFunctions.Conn;
        private Logs _logs;
        private SQLHelperClass _helper;
        private Timer TimerProcessing = null;
        RfcDestination dest = null;
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
            this.TimerProcessing.Interval = Convert.ToDouble(GenericFunctions.Interval);
            this.TimerProcessing.Elapsed += new System.Timers.ElapsedEventHandler(this.TimerProcessing_Elapsed);
            TimerProcessing.Start();

        }
        private void TimerProcessing_Elapsed(object sender, ElapsedEventArgs e)
        {
            TimerProcessing.Stop();
            Logs logs = new Logs();
            SQLHelperClass helper = new SQLHelperClass(logs);
            try
            {
                //while (true)
                //{                    
                GetSAPData(logs, helper);
                TimerProcessing.Start();
                //}
            }
            catch (Exception ex)
            {
                logs.ExceptionCaught(ex.Message, "Service.TimerProcessing_Elapsed");
                TimerProcessing.Start();
            }

        }
        protected override void OnStop()
        {
            TimerProcessing.Stop();
        }

        public void GetSAPData(Logs logs, SQLHelperClass helper)
        {
            _logs = logs;
            _helper = helper;
            try
            {
                if (dest == null)
                {
                    ECCDestinationConfig cfg = new ECCDestinationConfig();

                    RfcDestinationManager.RegisterDestinationConfiguration(cfg);

                    _logs.WriteLogs("RFC Connected Successfully");
                }

                dest = RfcDestinationManager.GetDestination("mySAPdestination");

                RfcRepository repo = dest.Repository;

                IRfcFunction testfn = repo.CreateFunction(GenericFunctions.CreateFunctionName);

                testfn.Invoke(dest);

                var dataListFetched = testfn.GetTable(GenericFunctions.GetTableName);
                
                var dataTable = dataListFetched.ToDataTable("tblData");
                
                string query = "select distinct EPD_EMPID as SAP_ID,isnull(EPD_PREVIOUS_ID,'') as Legacy_ID,EPD_FIRST_NAME as Name,EOD_DESIGNATION_ID as Designation " +
",EOD_DEPARTMENT_ID as Department,EOD_GRADE_ID as Class,EPD_GENDER as Sex,isnull(EAD_PHONE_ONE,'') as Mobile_No,isnull(EPD_DOCTOR,'') as Place_of_posting_Org_Unit " +
",EOD_LOCATION_ID as Place_of_posting_Cost_Center,EOD_JOINING_DATE as Date_of_joining_at_current_office"+
",EOD_CONFIRM_DATE as Date_of_release_from_last_office,Hier_Mgr_ID as Controlling_officer_SAP_ID,0 as Controlling_officer_designation"+
",EOD_RETIREMENT_DATE as Date_of_superannuation"+
",'Y' as Shift_Status,'M' Shift_Day_1,'M' Shift_Day_2,'M' Shift_Day_3,'M' Shift_Day_4"+
",'M'Shift_Day_5,'M'Shift_Day_6,'M'Shift_Day_7,'M'Shift_Day_8,'M'Shift_Day_9,'M'Shift_Day_10"+
",'M'Shift_Day_11,'M'Shift_Day_12,'M'Shift_Day_13,'M'Shift_Day_14,'M'Shift_Day_15"+
",'M'Shift_Day_16,'M'Shift_Day_17,'M'Shift_Day_18,'M'Shift_Day_19,'M'Shift_Day_20"+
",'M'Shift_Day_21,'M'Shift_Day_22,'M'Shift_Day_23,'M'Shift_Day_24,'M'Shift_Day_25"+
",'M'Shift_Day_26,'M'Shift_Day_27,'M'Shift_Day_28,'M'Shift_Day_29,'M'Shift_Day_30,'M'Shift_Day_31"+
" from ENT_EMPLOYEE_OFFICIAL_DTLS join ENT_EMPLOYEE_PERSONAL_DTLS on EPD_EMPID=EOD_EMPID join "+
" ENT_EMPLOYEE_ADDRESS on EPD_EMPID=EAD_EMPID and EAD_ADDRESS_TYPE='p' join ENT_HierarchyDef on EPD_EMPID=Hier_Emp_ID";

                dataTable = _helper.ExecuteDatatable(conn, CommandType.Text, query);

                SendDataTable(dataTable, logs, helper);
            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.ToString(), "GetSAPData");
            }

        }

        private void SendDataTable(DataTable dataTable, Logs logs, SQLHelperClass helper)
        {
            _logs = logs;
            _helper = helper;
            try
            {
                string query = "uspInsertSAPIntegrationData";
                List<SqlParameter> parameters = new List<SqlParameter>();
                parameters.Add(new SqlParameter("@DetailsTable", dataTable));
                var ds = _helper.ExecuteProcedure(conn, query, parameters.ToArray());
                if (ds.Tables[0].Rows.Count > 0)
                {
                    _logs.WriteLogs("Data Inserted Successfully");
                }
                else
                {
                    _logs.WriteLogs("No Data Found");
                }
                //foreach (DataRow row in dataTable.Rows)
                //{
                //    string query = "uspInsertSAPIntegrationData";
                //    List<SqlParameter> parameters = new List<SqlParameter>();
                //    var companyid = row["COMP_CODE"];
                //    var companyname = row["COMP_NAME"];
                //    parameters.Add(new SqlParameter("@companyId", companyid));
                //    parameters.Add(new SqlParameter("@companyName", companyname));
                //    _helper.ExecuteProcedure(conn, query, parameters.ToArray());
                //}

                string processquery = "uspProcessSAPIntegrationData";
                var ds2 = _helper.ExecuteDatatable(conn, CommandType.StoredProcedure, processquery);
                _logs.WriteLogs("Data Processed Successfully");
            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.ToString(), "SendDataTable");
            }
        }
    }
}
