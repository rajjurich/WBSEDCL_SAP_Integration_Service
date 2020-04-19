using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace sap_integration_service.Common
{
    public class SQLHelperClass
    {
        private Logs _logs;        

        public SQLHelperClass(Logs logs)
        {
            _logs = logs;            
        }
        //public SQLHelperClass()
        //{

        //}
        public SqlDataReader ExecuteReader(string connectionString, CommandType commandType, string commandText)
        {
            SqlConnection conn = new SqlConnection(connectionString);
            try
            {
                //  conn = new DB2Connection(connectionString);
                conn.Open();
                SqlCommand cmd = new SqlCommand(commandText, conn);
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = 0;
                return cmd.ExecuteReader();

            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.Message + "SQL Query " + commandText, "SQLHelperClass.ExecuteReader");
                return null;
            }
            finally
            {
                //if (conn.State == ConnectionState.Open)
                //{
                //    conn.Close();
                //    conn = null;
                //  //  conn.ClearUSRLIBLCache();
                //}
            }


        }

        public int ExecuteScalar(string connectionString, CommandType commandType, string commandText)
        {
            SqlConnection conn = new SqlConnection(connectionString);
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(commandText, conn);
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = 0;
                return Convert.ToInt32(cmd.ExecuteScalar());

            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.Message + "SQL Query " + commandText, "SQLHelperClass.ExecuteScalar");
                return 0;
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                    conn = null;
                }
            }
        }

        public int ExecuteNonQuery(string connectionString, CommandType commandType, string commandText)
        {
            SqlConnection conn = new SqlConnection(connectionString);
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(commandText, conn);
                cmd.CommandTimeout = 0;
                return cmd.ExecuteNonQuery();

            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.Message + "SQL Query " + commandText,  "SQLHelperClass.ExecuteNonQuery");
                return 0;
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                    conn = null;
                }
            }

        }

        public DataTable ExecuteDatatable(string connectionString, CommandType commandType, string commandText)
        {

            DataTable Data = new DataTable();
            SqlConnection conn = new SqlConnection(connectionString);

            try
            {
                using (conn)
                {
                    SqlCommand cmd = new SqlCommand(commandText, conn);
                    cmd.CommandType = commandType;
                    //cmd.CommandTimeout = GenericFunctions.CommandTimeOut;
                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(Data);
                }
            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.Message + "SQL Query " + commandText, "SQLHelperClass.ExecuteDatatable");
                return null;
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            return Data;

        }

        public DataSet ExecuteProcedure(string connectionString, string commandText, params SqlParameter[] sqlparams)
        {
            try
            {
                using (SqlConnection con1 = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand();
                    command.Parameters.Clear();
                    command.Parameters.AddRange(sqlparams);
                    command.Connection = con1;
                    command.CommandText = commandText;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter(command);
                    DataSet ds = new DataSet();
                    da.Fill(ds);
                    return ds;
                }
            }
            catch (Exception ex)
            {
                _logs.ExceptionCaught(ex.Message + "SQL Query " + commandText,  "SQLHelperClass.ExecuteProcedure");
                return null;
            }
        }

    }
}
