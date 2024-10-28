using BLL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Manage
{
	public partial class CityList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				BindCity();
			}
		}

		private void BindCity()
		{
			List<City> CityList = City.GetAll();
			Repeater2.DataSource = CityList;
			Repeater2.DataBind();
		}

		public void Delete(int CityId)
		{
			City.DeleteById(CityId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int cityID = Convert.ToInt32(btn.CommandArgument);
			Delete(cityID);
			BindCity(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void Deletecity(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					City.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting city.", ex);
			}
		}




		protected void SaveCity(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת לקוחות -------------");
				HiddenField hfCityId = (HiddenField)form1.FindControl("hfCityId");
				System.Diagnostics.Debug.WriteLine($"hfCityId נמצא: {hfCityId != null}, ערך: {hfCityId?.Value}");

				string CityName = txtCityName.Text;
				
				System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: CityId={hfCityId?.Value}, CityName={CityName}");

				System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
				ValidateFields(CityName);
				System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

				var city = new City
				{
					CityId = hfCityId != null && !string.IsNullOrEmpty(hfCityId.Value) && int.TryParse(hfCityId.Value, out int CityId) ? CityId : 0,
					CityName = CityName,
					
				};

				System.Diagnostics.Debug.WriteLine($"אובייקט city נוצר: CityId={city.CityId}, CityName={city.CityName}");

				if (city.CityId == 0)
				{
					System.Diagnostics.Debug.WriteLine("מוסיף מנהל חדש");
					city.SaveNewCity();
					System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"עורך מנהל קיים עם מזהה: {city.CityId}");
					city.UpdateCity();
					System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
				}

				System.Diagnostics.Debug.WriteLine("מתחיל Bindcity");
				BindCity();
				System.Diagnostics.Debug.WriteLine("Bindcity הסתיים");

				System.Diagnostics.Debug.WriteLine("רושם סקריפט JavaScript לסגירת המודל");
				ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript", "closeModal(); console.log('Modal closed after save');", true);

				System.Diagnostics.Debug.WriteLine("מבצע Redirect");
				//Response.Redirect(Request.RawUrl);
				if (!Response.IsRequestBeingRedirected)
				{
					Response.Redirect(Request.RawUrl, false);
					Context.ApplicationInstance.CompleteRequest();
				}
				return;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת לקוח: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"סוג השגיאה: {ex.GetType().FullName}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				Response.Write($"<script>console.error('שגיאה בשמירת לקוח: {ex.Message}'); alert('שגיאה בשמירת לקוח: {ex.Message}');</script>");
			}
			finally
			{
				System.Diagnostics.Debug.WriteLine("------------- סיום תהליך שמירת לקוחות -------------");
			}
		}

		private void ValidateFields(params string[] fields)
		{
			string[] fieldNames = { "CityName" };
			for (int i = 0; i < fields.Length; i++)
			{
				System.Diagnostics.Debug.WriteLine($"בודק שדה: {fieldNames[i]}, ערך: {fields[i]}");
				if (string.IsNullOrEmpty(fields[i]))
				{
					System.Diagnostics.Debug.WriteLine($"Validation Error: {fieldNames[i]} is missing or invalid");
					throw new Exception($"{fieldNames[i]} is missing or invalid");
				}
			}
			System.Diagnostics.Debug.WriteLine("כל השדות עברו אימות בהצלחה");
		}

		//[WebMethod]
		//public static void UpdateadministratorsStatus(int AdminId, bool Status)
		//{
		//	try
		//	{
		//		// מקבל את מחרוזת החיבור מקובץ web.config
		//		string connectionString = ConfigurationManager.ConnectionStrings["ConnStr"].ConnectionString;
		//		System.Diagnostics.Debug.WriteLine("Connection string: " + connectionString);

		//		// יצירת חיבור למסד הנתונים
		//		using (SqlConnection conn = new SqlConnection(connectionString))
		//		{
		//			System.Diagnostics.Debug.WriteLine("Attempting to open connection to database.");

		//			// יצירת פקודת SQL
		//			//using (SqlCommand cmd = new SqlCommand("UPDATE T_City SET Status = @Status WHERE AdminId = @AdminId", conn))
		//			//{
		//			//	cmd.Parameters.AddWithValue("@AdminId", AdminId);
		//			//	cmd.Parameters.AddWithValue("@Status", Status);
		//			//	System.Diagnostics.Debug.WriteLine("Prepared SQL command with parameters.");

		//			//	// פתיחת חיבור למסד הנתונים
		//			//	conn.Open();
		//			//	System.Diagnostics.Debug.WriteLine("Connection to database opened successfully.");

		//			//	// ביצוע הפקודה ועדכון השורות
		//			//	int rowsAffected = cmd.ExecuteNonQuery();
		//			//	System.Diagnostics.Debug.WriteLine("Rows affected: " + rowsAffected);

		//			//	// סגירת החיבור למסד הנתונים
		//			//	conn.Close();
		//			//	System.Diagnostics.Debug.WriteLine("Connection to database closed successfully.");
		//			//}
		//		}
		//	}
		//	catch (Exception ex)
		//	{
		//		// טיפול בשגיאה והדפסתה לצורכי דיבוג
		//		System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
		//		throw;
		//	}
		//}
	}
}