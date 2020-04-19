using SAP.Middleware.Connector;
using SAPIntegrationWebAPI.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;

namespace SAPIntegrationWebAPI
{
    public sealed class SAPData : ISAPData
    {
        private static readonly Lazy<SAPData> instance = new Lazy<SAPData>(() => new SAPData());
        string conn = GenericFunctions.Conn;
        private Logs _logs;
        private SQLHelperClass _helper;
        RfcDestination dest = null;
        Stopwatch timePerParse;
        private SAPData()
        {

        }
        public static SAPData GetInstance
        {
            get
            {
                return instance.Value;
            }
        }

        public int GetSAPData(Logs logs, SQLHelperClass helper)
        {
            _logs = logs;
            _helper = helper;
            try
            {
                if (dest == null)
                {
                    ECCDestinationConfig cfg = new ECCDestinationConfig();

                    RfcDestinationManager.RegisterDestinationConfiguration(cfg);
                    _logs.WriteLogs("Configuration Success");

                }

                dest = RfcDestinationManager.GetDestination("mySAPdestination");



                RfcRepository repo = dest.Repository;
                _logs.WriteLogs("RFC Connected Successfully");
                IRfcFunction testfn = repo.CreateFunction(GenericFunctions.CreateFunctionName);
                _logs.WriteLogs("Function Execution");
                IRfcStructure structureData = null;
                DataTable dataTable = new DataTable();
                bool colCreated = false;
                timePerParse = Stopwatch.StartNew();
                int z = 1;
                int y = 0;

                int minEmployeeCode = 0;
                int maxEmployeeCode = 0;

                for (int m = 0; m < 3; m++)
                {
                    _logs.WriteLogs("Fetching range " + (m + 1) + ".");

                    if (m == 0)
                    {
                        minEmployeeCode = GenericFunctions.MinEmployeeCode;
                        maxEmployeeCode = GenericFunctions.MaxEmployeeCode;
                    }

                    if (m == 1)
                    {
                        minEmployeeCode = GenericFunctions.MinEmployeeCode2;
                        maxEmployeeCode = GenericFunctions.MaxEmployeeCode2;
                    }

                    if (m == 2)
                    {
                        minEmployeeCode = GenericFunctions.MinEmployeeCode3;
                        maxEmployeeCode = GenericFunctions.MaxEmployeeCode3;
                    }

                    for (int i = minEmployeeCode; i <= maxEmployeeCode; i++)
                    {
                        try
                        {
                            testfn.SetValue("PERNR", i);
                            testfn.Invoke(dest);
                            if (testfn.GetStructure("LS_EMP_DETAILS").GetString("EMNAM").Length > 0)
                            {
                                structureData = testfn.GetStructure("LS_EMP_DETAILS");

                                int j = 1;

                                foreach (var item in structureData)
                                {
                                    j++;
                                    if (!colCreated)
                                    {
                                        dataTable.Columns.Add("col" + j);
                                    }
                                  //  _logs.WriteLogs("Index = " + j + " [NAME]" + structureData.Metadata[j].Name.ToString());
                                }
                                colCreated = true;
                                int k = 1;
                                DataRow dr = dataTable.NewRow();
                                foreach (var item in structureData)
                                {
                                    k++;
                                    string[] dataitem = item.ToString().Split('=');
                                    dr["col" + k] = dataitem[1];
                                    //_logs.WriteLogs("Index = " + k + " [NAME]" + dataitem[1]);
                                }
                                dataTable.Rows.Add(dr);
                                if (z % 1000 == 0)
                                {
                                    _logs.WriteLogs(z + " records successfully fetched");
                                }
                                z++;
                            }

                        }
                        catch (Exception ex)
                        {
                            y++;
                            _logs.WriteLogs(i + " Failed");
                            _logs.ExceptionCaught(ex.Message.ToString(), "For Loop SAP");
                        }
                    }
                }
                _logs.WriteLogs(y + " record failed");
                timePerParse.Stop();
                _logs.WriteLogs("Data Fetching Complete");
                _logs.WriteLogs("Time Taken: " + timePerParse.Elapsed.TotalSeconds.ToString() + " seconds.");
                return SendDataTable(dataTable, logs, helper);
                //_logs.WriteLogs(name);
                //IRfcStructure structureData = testfn.GetStructure("LS_EMP_DETAILS");
                //IRfcTable dataListFetched = dest.Repository.GetTableMetadata("EMNAM").CreateTable();
                //dataListFetched = testfn.GetTable("LS_EMP_DETAILS");
                //        IRfcTable dataListFetched = null; 
                //        _logs.WriteLogs("Data Fetching");
                //        if (dataListFetched == null)
                //        {
                //            _logs.WriteLogs("No Data Fetched");
                //        }
                //        else
                //        {
                //            //var dataTable = dataListFetched.ToDataTable("tblData");
                //            if (GenericFunctions.GetDummyData == "true")
                //            {
                //                string query = "select distinct EPD_EMPID as SAP_ID,isnull(EPD_PREVIOUS_ID,'') as Legacy_ID,EPD_FIRST_NAME as Name,EOD_DESIGNATION_ID as Designation " +
                //",EOD_DEPARTMENT_ID as Department,EOD_GRADE_ID as Class,EPD_GENDER as Sex,isnull(EAD_PHONE_ONE,'') as Mobile_No,isnull(EPD_DOCTOR,'') as Place_of_posting_Org_Unit " +
                //",EOD_LOCATION_ID as Place_of_posting_Cost_Center,EOD_JOINING_DATE as Date_of_joining_at_current_office" +
                //",EOD_CONFIRM_DATE as Date_of_release_from_last_office,Hier_Mgr_ID as Controlling_officer_SAP_ID,0 as Controlling_officer_designation" +
                //",EOD_RETIREMENT_DATE as Date_of_superannuation" +
                //",'Y' as Shift_Status,'M' Shift_Day_1,'M' Shift_Day_2,'M' Shift_Day_3,'M' Shift_Day_4" +
                //",'M'Shift_Day_5,'M'Shift_Day_6,'M'Shift_Day_7,'M'Shift_Day_8,'M'Shift_Day_9,'M'Shift_Day_10" +
                //",'M'Shift_Day_11,'M'Shift_Day_12,'M'Shift_Day_13,'M'Shift_Day_14,'M'Shift_Day_15" +
                //",'M'Shift_Day_16,'M'Shift_Day_17,'M'Shift_Day_18,'M'Shift_Day_19,'M'Shift_Day_20" +
                //",'M'Shift_Day_21,'M'Shift_Day_22,'M'Shift_Day_23,'M'Shift_Day_24,'M'Shift_Day_25" +
                //",'M'Shift_Day_26,'M'Shift_Day_27,'M'Shift_Day_28,'M'Shift_Day_29,'M'Shift_Day_30,'M'Shift_Day_31" +
                //" from ENT_EMPLOYEE_OFFICIAL_DTLS join ENT_EMPLOYEE_PERSONAL_DTLS on EPD_EMPID=EOD_EMPID join " +
                //" ENT_EMPLOYEE_ADDRESS on EPD_EMPID=EAD_EMPID and EAD_ADDRESS_TYPE='p' join ENT_HierarchyDef on EPD_EMPID=Hier_Emp_ID";

                //                dataTable = _helper.ExecuteDatatable(conn, CommandType.Text, query);
                //            }


                //            return SendDataTable(dataTable, logs, helper);
                //        }
                //        return 0;
            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.ToString(), "GetSAPData");
                return 0;
            }
        }

        private int SendDataTable(DataTable dataTable, Logs logs, SQLHelperClass helper)
        {
            _logs = logs;
            _helper = helper;
            try
            {
                string query = "uspInsertSAPIntegrationData";
                List<SqlParameter> parameters = new List<SqlParameter>();
                parameters.Add(new SqlParameter("@DetailsTable", dataTable));
                var ds = _helper.ExecuteProcedure(conn, query, parameters.ToArray());
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        _logs.WriteLogs("Data Inserted Successfully");
                        string processquery = "uspProcessSAPIntegrationData";
                        var ds2 = _helper.ExecuteDatatable(conn, CommandType.StoredProcedure, processquery);
                        _logs.WriteLogs("Data Processed Successfully");
                        return 1;
                    }
                    else
                    {
                        _logs.WriteLogs("No Data Found");
                        return 0;
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


                }
                else
                {
                    return 0;
                }
            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.ToString(), "SendDataTable");
                return 0;
            }
        }
    }
}