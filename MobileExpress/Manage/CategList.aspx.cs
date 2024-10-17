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
	public partial class CategList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				Bindcategories();
			}
		}

		private void Bindcategories()
		{
			List<Categories> CategList = Categories.GetAll();
			Repeater2.DataSource = CategList;
			Repeater2.DataBind();
		}

		public void Delete(int CatId)
		{
			Categories.DeleteById(CatId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int catID = Convert.ToInt32(btn.CommandArgument);
			Delete(catID);
			Bindcategories(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void Deletecategories(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					Categories.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting categories.", ex);
			}
		}




		protected void SaveCategories(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת קטגוריות -------------");
				HiddenField hfCatId = (HiddenField)form1.FindControl("hfCatId");
				System.Diagnostics.Debug.WriteLine($"hfCatId נמצא: {hfCatId != null}, ערך: {hfCatId?.Value}");

				string CatName = txtCatName.Text;
				
				bool Status;
				


				System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: CatId={hfCatId?.Value}, CatName={CatName}");

				System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
				ValidateFields(CatName);
				System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

				var categories = new Categories
				{
					CatId = hfCatId != null && !string.IsNullOrEmpty(hfCatId.Value) && int.TryParse(hfCatId.Value, out int CatId) ? CatId : 0,
					CatName = CatName,
					DateAdd = DateTime.Now,

				};

				System.Diagnostics.Debug.WriteLine($"אובייקט categories נוצר: CatId={categories.CatId}, CatName={categories.CatName},  DateAdd={categories.DateAdd}, Status={categories.Status}");

				if (categories.CatId == 0)
				{
					System.Diagnostics.Debug.WriteLine("מוסיף קטגוריה חדשה");
					categories.SaveNewCategories();
					System.Diagnostics.Debug.WriteLine("קטגוריה חדשה נוסף בהצלחה");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"עורך קטגוריה קיים עם מזהה: {categories.CatId}");
					categories.UpdateCategories();
					System.Diagnostics.Debug.WriteLine("נתוני הקטגוריה עודכנו בהצלחה");
				}

				System.Diagnostics.Debug.WriteLine("מתחיל Bindcategories");
				Bindcategories();
				System.Diagnostics.Debug.WriteLine("Bindcategories הסתיים");

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
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת קטגוריה: {ex.Message}");
				System.Diagnostics.Debug.WriteLine( $"סוג השגיאה: {ex.GetType().Name}");
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
			string[] fieldNames = { "CatName", "DateAdd", "Status" };
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

	



		[WebMethod]
		public static void UpdatecategoriesStatus(int CatId, bool Status)
		{
			try
			{
				// מקבל את מחרוזת החיבור מקובץ web.config
				string connectionString = ConfigurationManager.ConnectionStrings["ConnStr"].ConnectionString;
				System.Diagnostics.Debug.WriteLine("Connection string: " + connectionString);

				// יצירת חיבור למסד הנתונים
				using (SqlConnection conn = new SqlConnection(connectionString))
				{
					System.Diagnostics.Debug.WriteLine("Attempting to open connection to database.");

					// יצירת פקודת SQL
					using (SqlCommand cmd = new SqlCommand("UPDATE T_Categories SET Status = @Status WHERE CatId = @CatId", conn))
					{
						cmd.Parameters.AddWithValue("@CatId", CatId);
						cmd.Parameters.AddWithValue("@Status", Status);
						System.Diagnostics.Debug.WriteLine("Prepared SQL command with parameters.");

						// פתיחת חיבור למסד הנתונים
						conn.Open();
						System.Diagnostics.Debug.WriteLine("Connection to database opened successfully.");

						// ביצוע הפקודה ועדכון השורות
						int rowsAffected = cmd.ExecuteNonQuery();
						System.Diagnostics.Debug.WriteLine("Rows affected: " + rowsAffected);

						// סגירת החיבור למסד הנתונים
						conn.Close();
						System.Diagnostics.Debug.WriteLine("Connection to database closed successfully.");
					}
				}
			}
			catch (Exception ex)
			{
				// טיפול בשגיאה והדפסתה לצורכי דיבוג
				System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
				throw;
			}
		}
	}
}