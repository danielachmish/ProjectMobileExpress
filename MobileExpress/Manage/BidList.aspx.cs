using BLL;
using DAL;
using Data;
using Newtonsoft.Json;
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
	public partial class BidList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				Bindbid();
			}
		}

		private void Bindbid()
		{
			List<Bid> BidList = Bid.GetAll();
			Repeater2.DataSource = BidList;
			Repeater2.DataBind();
		}

		public void Delete(int BidId)
		{
			Bid.DeleteById(BidId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int bidID = Convert.ToInt32(btn.CommandArgument);
			Delete(bidID);
			Bindbid(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void Deletebid(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					Bid.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting bid.", ex);
			}
		}


		protected void Savebid(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת מנהל -------------");

				// קריאת הנתונים מהטופס
				string Desc = txtDesc.Text;
				int Price = int.Parse(txtPrice.Text);
				int TecId = int.Parse(txtTecId.Text);
				int ReadId = int.Parse(txtReadId.Text);
				
				// אתחול Status לברירת מחדל true
				bool Status = true;  // או false, תלוי בלוגיקה העסקית שלך

				// בדיקת תקינות השדות
				ValidateFields(Desc, Price.ToString(), TecId.ToString(), ReadId.ToString());

				HiddenField hfBidId= (HiddenField)form1.FindControl("hfBidId");

				var bid = new Bid
				{
					BidId = hfBidId!= null && !string.IsNullOrEmpty(hfBidId.Value) &&
							 int.TryParse(hfBidId.Value, out int BidId) ? BidId : 0,
					Desc = Desc,
					Price = Price,
					TecId = TecId,
					ReadId = ReadId,
				
					Date = DateTime.Now,
					Status = Status  // הוספת השדה Status
				
				};

				if (bid.BidId == 0)
				{
					bid.SaveNewBid();
					System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
				}
				else
				{
					bid.UpdateBid();
					System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
				}

				// רענון הטבלה
				Bindbid();

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
			string[] fieldNames = { "Desc", "Price", "TecId", "ReadId" };
			for (int i = 0; i < fields.Length; i++)
			{
				if (string.IsNullOrEmpty(fields[i]))
				{
					throw new ArgumentException($"השדה {fieldNames[i]} הוא חובה");
				}
			}
		}

		//private string HashPassword(string password)
		//{
		//	System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
		//	var hashedPassword = Convert.ToBase64String(System.Security.Cryptography.SHA256.Create()
		//		.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
		//	System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
		//	return hashedPassword;
		//}

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
		//		string Email = txtEmail.Text;
		//		string Pass = txtPass.Text;

		//		//string DateAdd = txtDateAdd.Text;
		//		bool Status = true;

		//		string Email = txtEmail.Text;


		//		System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: AdminId={hfAdminId?.Value}, FullName={FullName}, Phone={Phone}, Addres={Addres}, Email={Email},    Email={Email}");

		//		System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
		//		ValidateFields(FullName, Phone, Addres, Email, Pass, Email);
		//		System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

		//		var administrators = new Administrators
		//		{
		//			AdminId = hfAdminId != null && !string.IsNullOrEmpty(hfAdminId.Value) && int.TryParse(hfAdminId.Value, out int AdminId) ? AdminId : 0,
		//			FullName = FullName,
		//			Phone = Phone,
		//			Addres = Addres,
		//			Email = Email,
		//			Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
		//			DateAdd = DateTime.Now,

		//			Email = Email,

		//		};

		//		System.Diagnostics.Debug.WriteLine($"אובייקט administrators נוצר: AdminId={administrators.AdminId}, FullName={administrators.FullName}, Phone={administrators.Phone}, Addres={administrators.Addres}, Email={administrators.Email}, DateAdd={administrators.DateAdd}, Status={administrators.Status},Email={administrators.Email}");

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
		//	string[] fieldNames = { "FullName", "Phone", "Addres", "Email", "Pass", "DateAdd", "Status", "Email" };
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
		public static void UpdatebidStatus(int bidId, bool Status)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("מתחיל עדכון סטטוס מנהל...");

				string sql = "UPDATE T_Bid SET Status = @Status WHERE BidId = @BidId";
				System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						BidId = bidId,
						Status = Convert.ToInt32(Status)  // המרה ל-TINYINT
					};

					var LstParma = DbContext.CreateParameters(Obj);
					int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);

					System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {rowsAffected}");

					if (rowsAffected > 0)
					{
						System.Diagnostics.Debug.WriteLine($"הסטטוס של מנהל {bidId} עודכן בהצלחה ל-{Status}");
					}
					else
					{
						System.Diagnostics.Debug.WriteLine($"לא נמצא מנהל עם מזהה {bidId}");
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