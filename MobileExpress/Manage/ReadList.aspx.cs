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
	public partial class ReadList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				BindReadability();
			}
		}

		private void BindReadability()
		{
			// נקה את ה-Repeater
			Repeater2.DataSource = null;
			Repeater2.DataBind();

			List<Readability> ReadList = Readability.GetAll();
			Repeater2.DataSource = ReadList;
			Repeater2.DataBind();
		}

		public void Delete(int ReadId)
		{
			Readability.DeleteById(ReadId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int readID = Convert.ToInt32(btn.CommandArgument);
			Delete(readID);
			BindReadability(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void DeleteReadability(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					Readability.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting Readability.", ex);
			}
		}




		protected void SaveReadability(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת לקוחות -------------");
				HiddenField hfReadId = (HiddenField)form1.FindControl("hfReadId");
				System.Diagnostics.Debug.WriteLine($"hfReadId נמצא: {hfReadId != null}, ערך: {hfReadId?.Value}");

				string Desc = txtDesc.Text;
				string FullName = txtFullName.Text;
				string Phone = txtPhone.Text;
				string Nots = txtNots.Text;
				int CusId = int.Parse(txtCusId.Text);
				//string DateAdd = txtDateAdd.Text;
				bool Status;

				int ModelId = int.Parse(txtModelId.Text);
				string NameImage = txtNameImage.Text;
				string Urgency = txtUrgency.Text;
				int SerProdId = int.Parse(txtSerProdId.Text);
				

				System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: " +
					$"ReadId={hfReadId?.Value}, Desc={Desc}, FullName={FullName}, Phone={Phone}, Nots={Nots}, CusId={CusId}, ModaelId={ModelId},NameImage={NameImage},Urgency={Urgency},SerProdId={SerProdId}");

				System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
				ValidateFields(Desc, FullName, Phone, Nots, CusId.ToString(), ModelId.ToString(), NameImage, Urgency, SerProdId.ToString());
				System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

				var readability = new Readability
				{
					ReadId = hfReadId != null && !string.IsNullOrEmpty(hfReadId.Value) && int.TryParse(hfReadId.Value, out int readId) ? readId : 0,
					DateRead = DateTime.Now,
					Desc=Desc,
					FullName = FullName,
					Phone = Phone,
					Nots = Nots,
					CusId = CusId,				
					ModelId = ModelId,
					NameImage = NameImage,
					Urgency=Urgency,
					SerProdId=SerProdId
				};

				System.Diagnostics.Debug.WriteLine($"אובייקט Readability נוצר: ReadId={readability.ReadId},DateRead={readability.DateRead}, Desc={readability.Desc}, FullName={readability.FullName},Phone={readability.Phone}, Nots={readability.Nots}, CusId={readability.CusId},  ModelId={readability.ModelId}, Status={readability.Status}, NameImage={readability.NameImage},Urgency={readability.Urgency},SerProdId={readability.SerProdId}");

				if (readability.ReadId == 0)
				{
					System.Diagnostics.Debug.WriteLine("מוסיף לקוח חדש");
					readability.SaveNewRead();
					System.Diagnostics.Debug.WriteLine("לקוח חדש נוסף בהצלחה");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"עורך לקוח קיים עם מזהה: {readability.ReadId}");
					readability.UpdateReadability();
					System.Diagnostics.Debug.WriteLine("נתוני הלקוח עודכנו בהצלחה");
				}

				System.Diagnostics.Debug.WriteLine("מתחיל BindReadability");
				BindReadability();
				System.Diagnostics.Debug.WriteLine("BindReadability הסתיים");

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
			string[] fieldNames = { "DateAdd", "Desc","FullName", "Phone", "Nots", "CusId", "ModelId","Status","NameImage","Urgency","SerProdId" };
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

		//private string HashPassword(string password)
		//{
		//	System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
		//	var hashedPassword = Convert.ToBase64String(System.Security.Cryptography.SHA256.Create().ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
		//	System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
		//	return hashedPassword;
		//}
		//private void LogError(Exception ex)
		//{
		//    // רישום שגיאות
		//    System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
		//}

		//private void ShowErrorMessage(string message)
		//{
		//    // הצגת הודעת שגיאה למשתמש
		//    ScriptManager.RegisterStartupScript(this, GetType(), "errorScript", $"alert('{message}');", true);
		//}

		//private void BindTechnicians()
		//{
		//    // קוד לקישור נתוני הטכנאים ל-Repeater או אלמנט אחר ב-UI
		//}



		//[WebMethod]
		//public static void UpdateReadabilityStatus(int ReadId, bool Status)
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
		//			using (SqlCommand cmd = new SqlCommand("UPDATE T_Customers SET Status = @Status WHERE CusId = @CusId", conn))
		//			{
		//				cmd.Parameters.AddWithValue("@ReadId", ReadId);
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