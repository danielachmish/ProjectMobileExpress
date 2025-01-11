using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Manage
{
	public partial class ManuList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				Bindmanufacturers();
			}
		}

		private void Bindmanufacturers()
		{
			List<Manufacturers> ManuList = Manufacturers.GetAll();
			Repeater2.DataSource = ManuList;
			Repeater2.DataBind();
		}

		public void Delete(int ManuId)
		{
			Manufacturers.DeleteById(ManuId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int manuID = Convert.ToInt32(btn.CommandArgument);
			Delete(manuID);
			Bindmanufacturers(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void Deletemanufacturers(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					Manufacturers.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting manufacturers.", ex);
			}
		}




		protected void SaveManufacturers(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת לקוחות -------------");
				HiddenField hfManuId = (HiddenField)form1.FindControl("hfManuId");
				System.Diagnostics.Debug.WriteLine($"hfManuId נמצא: {hfManuId != null}, ערך: {hfManuId?.Value}");

				string ManuName = txtManuName.Text;
				string Desc = txtDesc.Text;
				string NameImage = txtNameImage.Text;
				
			
				
				System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: ManuId={hfManuId?.Value}, ManuName={ManuName}, Desc={Desc}, NameImage={NameImage}");

				System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
				ValidateFields(ManuName, Desc, NameImage);
				System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

				var manufacturers = new Manufacturers
				{
					ManuId = hfManuId != null && !string.IsNullOrEmpty(hfManuId.Value) && int.TryParse(hfManuId.Value, out int ManuId) ? ManuId : 0,
					ManuName = ManuName,
					Desc = Desc,
					NameImage = NameImage,
					Date = DateTime.Now,
				};

				System.Diagnostics.Debug.WriteLine($"אובייקט manufacturers נוצר: ManuId={manufacturers.ManuId}, ManuName={manufacturers.ManuName}, Desc={manufacturers.Desc}, NameImage={manufacturers.NameImage}, Date={manufacturers.Date}");

				if (manufacturers.ManuId == 0||manufacturers.ManuId==-1)
				{
					System.Diagnostics.Debug.WriteLine("מוסיף מנהל חדש");
					manufacturers.SaveNewManufacturers();
					System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"עורך מנהל קיים עם מזהה: {manufacturers.ManuId}");
					manufacturers.UpdateManufacturers();
					System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
				}

				System.Diagnostics.Debug.WriteLine("מתחיל Bindadministrators");
				Bindmanufacturers();
				System.Diagnostics.Debug.WriteLine("Bindadministrators הסתיים");

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
			string[] fieldNames = { "ManuName", "Desc", "NameImage"};
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
		//public static void UpdateadministratorsStatus(int ManuId, bool Status)
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
		//			using (SqlCommand cmd = new SqlCommand("UPDATE T_administrators SET Status = @Status WHERE AdminId = @AdminId", conn))
		//			{
		//				cmd.Parameters.AddWithValue("@AdminId", AdminId);
		//				cmd.Parameters.AddWithValue("@Status", Status);
		//				System.Diagnostics.Debug.WriteLine("Prepared SQL command with parameters.");

		//				// פתיחת חיבור למסד הנתונים
		//				conn.Open();
		//				System.Diagnostics.Debug.WriteLine("Connection to database opened successfully.");

		//				// ביצוע הפקודה ועדכון השורות
		//				int rowsAffected = cmd.ExecuteNonQuery();
		//				System.Diagnostics.Debug.WriteLine("Rows affected: " + rowsAffected);

		//				// סגירת החיבור למסד הנתונים
		//				conn.Close();
		//				System.Diagnostics.Debug.WriteLine("Connection to database closed successfully.");
		//			}
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