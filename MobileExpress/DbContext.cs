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
			// קביעת מחרוזת החיבור מהקונפיגורציה
			ConnStr = ConfigurationManager.ConnectionStrings["ConnStr"].ToString();
			// יצירת חיבור והגדרת מחרוזת החיבור
			Conn = new SqlConnection();
			Conn.ConnectionString = ConnStr;
		
			Cmd = new SqlCommand();
			Cmd.Connection = Conn;
		}

		// הגדרת וביצוע פקודות SQL / טיפול בפרמטרים שהתקבלו / החזרת מספר השורות שהושפעו
		public int ExecuteNonQuery(string sql, List<SqlParameter> lst = null)
		{
			int RecCount = 0;
			Open(); // פתיחת החיבור למסד הנתונים

			Cmd.CommandText = sql;

			if (lst != null)
			{
				for (int i = 0; i < lst.Count; i++)
				{
					Cmd.Parameters.Add(lst[i]);
				}
			}

			RecCount = Cmd.ExecuteNonQuery();
			Cmd.Dispose();

			Close(); // סגירת החיבור למסד הנתונים
			return RecCount;
		}

		public DataTable Execute(string sql, int CmdType = 1)
		{
			Open();// פתיחת החיבור
			Cmd.CommandText = sql;
			DataTable Dt = new DataTable();
			SqlDataAdapter Da = new SqlDataAdapter();
			if (CmdType == 2)
				Cmd.CommandType = CommandType.StoredProcedure;

			Da.SelectCommand = Cmd;
			Da.Fill(Dt);
			Cmd.Dispose();
			Close();//סגירת החיבור
			return Dt;
		}
		// יצירת פרמטרים לפי עצם מסוים
		public static List<SqlParameter> CreateParameters(object ParametersObject)
		{
			DbContext Db = new DbContext();
			Db.Open();// פתיחת החיבור
			var Parameters = new List<SqlParameter>();

			var arr = ParametersObject.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);

			for (int i = 0; i<arr.Length; i++)
			{
				Parameters.Add(new SqlParameter(arr[i].Name, arr[i].GetValue(ParametersObject, null)));
			}
			Db.Close();//סגירת החיבור
			return Parameters;
		}
		// ביצוע פקודת Scalar והחזרת הערך היחיד
		public Object ExecuteScalar(string sql)
		{
		
			Open();// פתיחת החיבור
			Cmd.CommandText = sql;
			Close();//סגירת החיבור
			return Cmd.ExecuteScalar();
		}











		// פתיחת החיבור
		public void Open()
		{
			Conn.Open();
		}
		public void Close()
		{
			Conn.Close();
		}
	}
}