using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Reflection;

namespace Data
{
    public class DbContext
    {

        public string ConnStr { get; set; }
        public SqlConnection Conn { get; set; }
        public SqlCommand Cmd { get; set; }


        public DbContext()
        {

            try
            {
                System.Diagnostics.Debug.WriteLine("=== מתחיל אתחול DbContext ===");

                string dataDirectory = AppDomain.CurrentDomain.GetData("DataDirectory").ToString();
                System.Diagnostics.Debug.WriteLine($"DataDirectory Path: {dataDirectory}");

                // קביעת מחרוזת החיבור מהקונפיגורציה
                ConnStr = ConfigurationManager.ConnectionStrings["ConnStr"].ToString();
                System.Diagnostics.Debug.WriteLine($"Connection String: {ConnStr}");

                // יצירת חיבור והגדרת מחרוזת החיבור
                Conn = new SqlConnection();
                Conn.ConnectionString = ConnStr;
                System.Diagnostics.Debug.WriteLine("נוצר חיבור חדש לדאטאבייס");

                Cmd = new SqlCommand();
                Cmd.Connection = Conn;
                System.Diagnostics.Debug.WriteLine("נוצרה פקודת SQL חדשה");

                System.Diagnostics.Debug.WriteLine("=== סיום אתחול DbContext ===");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"!!! שגיאה באתחול DbContext !!!\nשגיאה: {ex.Message}");
                throw;
            }
        }

        
        public int ExecuteNonQuery(string sql, List<SqlParameter> lst = null)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== מתחיל ביצוע ExecuteNonQuery ===");
                System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

                int RecCount = 0;
                Open();
                System.Diagnostics.Debug.WriteLine("החיבור נפתח בהצלחה");

                Cmd.CommandText = sql;

                if (lst != null)
                {
                    System.Diagnostics.Debug.WriteLine($"מוסיף {lst.Count} פרמטרים:");
                    for (int i = 0; i < lst.Count; i++)
                    {
                        Cmd.Parameters.Add(lst[i]);
                        System.Diagnostics.Debug.WriteLine($"פרמטר {i + 1}: {lst[i].ParameterName} = {lst[i].Value}");
                    }
                }

                RecCount = Cmd.ExecuteNonQuery();
                System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {RecCount}");

                Cmd.Parameters.Clear();
                Cmd.Dispose();
                Close();

                System.Diagnostics.Debug.WriteLine("=== סיום ביצוע ExecuteNonQuery ===");
                return RecCount;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    $"!!! שגיאה בביצוע ExecuteNonQuery !!!\n" +
                    $"שגיאה: {ex.Message}\n" +
                    $"SQL: {sql}\n" +
                    $"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }

        public DataTable Execute(string sql, int CmdType = 1)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== מתחיל ביצוע Execute ===");
                System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");
                System.Diagnostics.Debug.WriteLine($"Command Type: {(CmdType == 2 ? "StoredProcedure" : "Text")}");

                Open();
                Cmd.CommandText = sql;

                DataTable Dt = new DataTable();
                SqlDataAdapter Da = new SqlDataAdapter();

                if (CmdType == 2)
                {
                    Cmd.CommandType = CommandType.StoredProcedure;
                    System.Diagnostics.Debug.WriteLine("הוגדר כ-Stored Procedure");
                }

                Da.SelectCommand = Cmd;
                Da.Fill(Dt);

                System.Diagnostics.Debug.WriteLine($"מספר שורות שהוחזרו: {Dt.Rows.Count}");
                System.Diagnostics.Debug.WriteLine($"מספר עמודות: {Dt.Columns.Count}");

                Cmd.Dispose();
                Close();

                System.Diagnostics.Debug.WriteLine("=== סיום ביצוע Execute ===");
                return Dt;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    $"!!! שגיאה בביצוע ExecuteNonQuery !!!\n" +
                    $"שגיאה: {ex.Message}\n" +
                    $"SQL: {sql}\n" +
                    $"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }
        // הוספת פונקציה חדשה ל-DbContext
        public DataTable Execute(string sql, SqlParameter[] parameters, int CmdType = 1)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== מתחיל ביצוע Execute ===");
                System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");
                System.Diagnostics.Debug.WriteLine($"Command Type: {(CmdType == 2 ? "StoredProcedure" : "Text")}");
                Open();
                Cmd.CommandText = sql;
                Cmd.Parameters.Clear(); // נקה פרמטרים קודמים
                if (parameters != null)
                {
                    Cmd.Parameters.AddRange(parameters); // הוסף את הפרמטרים החדשים
                }
                DataTable Dt = new DataTable();
                SqlDataAdapter Da = new SqlDataAdapter();
                if (CmdType == 2)
                {
                    Cmd.CommandType = CommandType.StoredProcedure;
                    System.Diagnostics.Debug.WriteLine("הוגדר כ-Stored Procedure");
                }
                Da.SelectCommand = Cmd;
                Da.Fill(Dt);
                System.Diagnostics.Debug.WriteLine($"מספר שורות שהוחזרו: {Dt.Rows.Count}");
                System.Diagnostics.Debug.WriteLine($"מספר עמודות: {Dt.Columns.Count}");
                Cmd.Dispose();
                Close();
                System.Diagnostics.Debug.WriteLine("=== סיום ביצוע Execute ===");
                return Dt;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    $"!!! שגיאה בביצוע Execute !!!\n" +
                    $"שגיאה: {ex.Message}\n" +
                    $"SQL: {sql}\n" +
                    $"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }

        public static List<SqlParameter> CreateParameters(object ParametersObject)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== מתחיל יצירת פרמטרים ===");

                DbContext Db = new DbContext();
                Db.Open();

                var Parameters = new List<SqlParameter>();
                var arr = ParametersObject.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);

                System.Diagnostics.Debug.WriteLine($"נמצאו {arr.Length} מאפיינים לעיבוד");

                for (int i = 0; i < arr.Length; i++)
                {
                    var value = arr[i].GetValue(ParametersObject, null);
          
                    Parameters.Add(new SqlParameter(arr[i].Name, value));
                    System.Diagnostics.Debug.WriteLine($"נוסף פרמטר: {arr[i].Name} = {value}");
                }      

                Db.Close();

                System.Diagnostics.Debug.WriteLine("=== סיום יצירת פרמטרים ===");
                return Parameters;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    $"!!! שגיאה ביצירת פרמטרים !!!\n" +
                    $"שגיאה: {ex.Message}\n" +
                    $"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }

        public Object ExecuteScalar(string sql, List<SqlParameter> lstParma)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== מתחיל ביצוע ExecuteScalar ===");
                System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

                Open();
                Cmd.CommandText = sql;

                if (lstParma != null)
                {
                    System.Diagnostics.Debug.WriteLine($"מוסיף {lstParma.Count} פרמטרים");
                    foreach (var param in lstParma)
                    {
                        Cmd.Parameters.Add(param);
                        System.Diagnostics.Debug.WriteLine($"פרמטר: {param.ParameterName} = {param.Value}");
                    }
                }

                var result = Cmd.ExecuteScalar();
                System.Diagnostics.Debug.WriteLine($"ערך שהוחזר: {result}");

                Close();

                System.Diagnostics.Debug.WriteLine("=== סיום ביצוע ExecuteScalar ===");
                return result;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    $"!!! שגיאה בביצוע ExecuteNonQuery !!!\n" +
                    $"שגיאה: {ex.Message}\n" +
                    $"SQL: {sql}\n" +
                    $"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }

		internal object ExecuteScalar(string readabilityCheck)
		{
			throw new NotImplementedException();
		}

		public void Open()
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("מנסה לפתוח חיבור לדאטאבייס...");
                Conn.Open();
                System.Diagnostics.Debug.WriteLine("החיבור נפתח בהצלחה");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    $"!!! שגיאה בפתיחת החיבור !!!\n" +
                    $"שגיאה: {ex.Message}\n" +
                    $"Connection String: {ConnStr}\n" +
                    $"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }

        public void Close()
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("סוגר חיבור לדאטאבייס...");
                Conn.Close();
                System.Diagnostics.Debug.WriteLine("החיבור נסגר בהצלחה");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"!!! שגיאה בסגירת החיבור !!!\nשגיאה: {ex.Message}");
                throw;
            }
        }

        public DataTable Execute(string sql, List<SqlParameter> parameters, int CmdType = 1)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== מתחיל ביצוע Execute עם פרמטרים ===");
                System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

                Open();
                Cmd.CommandText = sql;
                Cmd.Parameters.Clear(); // נקה פרמטרים קודמים

                if (parameters != null)
                {
                    foreach (var param in parameters)
                    {
                        Cmd.Parameters.Add(param);
                        System.Diagnostics.Debug.WriteLine($"הוסף פרמטר: {param.ParameterName} = {param.Value}");
                    }
                }

                DataTable Dt = new DataTable();
                SqlDataAdapter Da = new SqlDataAdapter();

                if (CmdType == 2)
                {
                    Cmd.CommandType = CommandType.StoredProcedure;
                    System.Diagnostics.Debug.WriteLine("הוגדר כ-Stored Procedure");
                }

                Da.SelectCommand = Cmd;
                Da.Fill(Dt);

                System.Diagnostics.Debug.WriteLine($"מספר שורות שהוחזרו: {Dt.Rows.Count}");
                System.Diagnostics.Debug.WriteLine($"מספר עמודות: {Dt.Columns.Count}");

                Cmd.Dispose();
                Close();

                System.Diagnostics.Debug.WriteLine("=== סיום ביצוע Execute ===");
                return Dt;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    $"!!! שגיאה בביצוע Execute !!!\n" +
                    $"שגיאה: {ex.Message}\n" +
                    $"SQL: {sql}\n" +
                    $"Stack Trace: {ex.StackTrace}");
                throw;
            }
        }
    }
}