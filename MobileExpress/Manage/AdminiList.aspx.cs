using BLL;
using Data;
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
	public partial class AdminiList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				Bindadministrators();
			}
		}

		private void Bindadministrators()
		{
			List<Administrators> AdminiList = Administrators.GetAll();
			Repeater2.DataSource = AdminiList;
			Repeater2.DataBind();
		}

		public void Delete(int AdminId)
		{
			Administrators.DeleteById(AdminId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int adminID = Convert.ToInt32(btn.CommandArgument);
			Delete(adminID);
			Bindadministrators(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void Deleteadministrators(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					Administrators.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting administrators.", ex);
			}
		}


		protected void Saveadministrators(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת מנהל -------------");

				// קריאת הנתונים מהטופס
				string FullName = txtFullName.Text;
				string Phone = txtPhone.Text;
				string Addres = txtAddres.Text;
				string Uname = txtUname.Text;
				string Pass = txtPass.Text;
				string Email = txtEmail.Text;

				// אתחול Status לברירת מחדל true
				bool Status = true;  // או false, תלוי בלוגיקה העסקית שלך

				// בדיקת תקינות השדות
				ValidateFields(FullName, Phone, Addres, Uname, Pass, Email);

				HiddenField hfAdminId = (HiddenField)form1.FindControl("hfAdminId");

				var administrators = new Administrators
				{
					AdminId = hfAdminId != null && !string.IsNullOrEmpty(hfAdminId.Value) &&
							 int.TryParse(hfAdminId.Value, out int AdminId) ? AdminId : 0,
					FullName = FullName,
					Phone = Phone,
					Addres = Addres,
					Uname = Uname,
					Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
					DateAdd = DateTime.Now,
					Status = Status,  // הוספת השדה Status
					Email = Email
				};

				if (administrators.AdminId == 0)
				{
					administrators.SaveNewAdministrators();
					System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
				}
				else
				{
					administrators.UpdateAdministrators();
					System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
				}

				// רענון הטבלה
				Bindadministrators();

				// סגירת המודל ורענון העמוד
				ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript",
					"closeModal(); console.log('Modal closed after save');", true);

				if (!Response.IsRequestBeingRedirected)
				{
					Response.Redirect(Request.RawUrl, false);
					Context.ApplicationInstance.CompleteRequest();
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת מנהל: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				throw;  // חשוב לזרוק את השגיאה כדי שנוכל לראות אותה
			}
		}

		private void ValidateFields(params string[] fields)
		{
			string[] fieldNames = { "FullName", "Phone", "Addres", "Uname", "Pass", "Email" };
			for (int i = 0; i < fields.Length; i++)
			{
				if (string.IsNullOrEmpty(fields[i]))
				{
					throw new ArgumentException($"השדה {fieldNames[i]} הוא חובה");
				}
			}
		}

		private string HashPassword(string password)
		{
			System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
			var hashedPassword = Convert.ToBase64String(System.Security.Cryptography.SHA256.Create()
				.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
			System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
			return hashedPassword;
		}

		//protected void Saveadministrators(object sender, EventArgs e)
		//{
		//	try
		//	{
		//		System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת לקוחות -------------");
		//		HiddenField hfAdminId = (HiddenField)form1.FindControl("hfAdminId");
		//		System.Diagnostics.Debug.WriteLine($"hfAdminId נמצא: {hfAdminId != null}, ערך: {hfAdminId?.Value}");

		//		string FullName = txtFullName.Text;
		//		string Phone = txtPhone.Text;
		//		string Addres = txtAddres.Text;
		//		string Uname = txtUname.Text;
		//		string Pass = txtPass.Text;

		//		//string DateAdd = txtDateAdd.Text;
		//		bool Status = true;

		//		string Email = txtEmail.Text;


		//		System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: AdminId={hfAdminId?.Value}, FullName={FullName}, Phone={Phone}, Addres={Addres}, Uname={Uname},    Email={Email}");

		//		System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
		//		ValidateFields(FullName, Phone, Addres, Uname, Pass, Email);
		//		System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

		//		var administrators = new Administrators
		//		{
		//			AdminId = hfAdminId != null && !string.IsNullOrEmpty(hfAdminId.Value) && int.TryParse(hfAdminId.Value, out int AdminId) ? AdminId : 0,
		//			FullName = FullName,
		//			Phone = Phone,
		//			Addres = Addres,
		//			Uname = Uname,
		//			Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
		//			DateAdd = DateTime.Now,

		//			Email = Email,

		//		};

		//		System.Diagnostics.Debug.WriteLine($"אובייקט administrators נוצר: AdminId={administrators.AdminId}, FullName={administrators.FullName}, Phone={administrators.Phone}, Addres={administrators.Addres}, Uname={administrators.Uname}, DateAdd={administrators.DateAdd}, Status={administrators.Status},Email={administrators.Email}");

		//		if (administrators.AdminId == 0)
		//		{
		//			System.Diagnostics.Debug.WriteLine("מוסיף מנהל חדש");
		//			administrators.SaveNewAdministrators();
		//			System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
		//		}
		//		else
		//		{
		//			System.Diagnostics.Debug.WriteLine($"עורך מנהל קיים עם מזהה: {administrators.AdminId}");
		//			administrators.UpdateAdministrators();
		//			System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
		//		}

		//		System.Diagnostics.Debug.WriteLine("מתחיל Bindadministrators");
		//		Bindadministrators();
		//		System.Diagnostics.Debug.WriteLine("Bindadministrators הסתיים");

		//		System.Diagnostics.Debug.WriteLine("רושם סקריפט JavaScript לסגירת המודל");
		//		ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript", "closeModal(); console.log('Modal closed after save');", true);

		//		System.Diagnostics.Debug.WriteLine("מבצע Redirect");
		//		//Response.Redirect(Request.RawUrl);
		//		if (!Response.IsRequestBeingRedirected)
		//		{
		//			Response.Redirect(Request.RawUrl, false);
		//			Context.ApplicationInstance.CompleteRequest();
		//		}
		//		return;
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת לקוח: {ex.Message}");
		//		System.Diagnostics.Debug.WriteLine($"סוג השגיאה: {ex.GetType().FullName}");
		//		System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
		//		Response.Write($"<script>console.error('שגיאה בשמירת לקוח: {ex.Message}'); alert('שגיאה בשמירת לקוח: {ex.Message}');</script>");
		//	}
		//	finally
		//	{
		//		System.Diagnostics.Debug.WriteLine("------------- סיום תהליך שמירת לקוחות -------------");
		//	}
		//}

		//private void ValidateFields(params string[] fields)
		//{
		//	string[] fieldNames = { "FullName", "Phone", "Addres", "Uname", "Pass", "DateAdd", "Status", "Email" };
		//	for (int i = 0; i < fields.Length; i++)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"בודק שדה: {fieldNames[i]}, ערך: {fields[i]}");
		//		if (string.IsNullOrEmpty(fields[i]))
		//		{
		//			System.Diagnostics.Debug.WriteLine($"Validation Error: {fieldNames[i]} is missing or invalid");
		//			throw new Exception($"{fieldNames[i]} is missing or invalid");
		//		}
		//	}
		//	System.Diagnostics.Debug.WriteLine("כל השדות עברו אימות בהצלחה");
		//}

		//private string HashPassword(string password)
		//{
		//	System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
		//	var hashedPassword = Convert.ToBase64String(System.Security.Cryptography.SHA256.Create().ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
		//	System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
		//	return hashedPassword;
		//}



		[WebMethod]
		public static void UpdateadministratorsStatus(int AdminId, bool Status)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("מתחיל עדכון סטטוס מנהל...");

				string sql = "UPDATE T_Administrators SET Status = @Status WHERE AdminId = @AdminId";
				System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						AdminId = AdminId,
						Status = Convert.ToInt32(Status)  // המרה ל-TINYINT
					};

					var LstParma = DbContext.CreateParameters(Obj);
					int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);

					System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {rowsAffected}");

					if (rowsAffected > 0)
					{
						System.Diagnostics.Debug.WriteLine($"הסטטוס של מנהל {AdminId} עודכן בהצלחה ל-{Status}");
					}
					else
					{
						System.Diagnostics.Debug.WriteLine($"לא נמצא מנהל עם מזהה {AdminId}");
					}
				}
				finally
				{
					Db.Close(); // סגירת החיבור
					System.Diagnostics.Debug.WriteLine("החיבור לדאטאבייס נסגר");
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון סטטוס מנהל: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				throw;
			}
		}
	}
}