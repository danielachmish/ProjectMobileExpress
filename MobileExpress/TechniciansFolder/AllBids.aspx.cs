using Betfair_API_NG.TO;
using BLL;
using DAL;
using Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Exception = System.Exception;

namespace MobileExpress.TechniciansFolder
{
	public partial class AllBids : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{

				string readId = Request.QueryString["readId"];
				if (!string.IsNullOrEmpty(readId))
				{
					// בצע פעולות בהתאם למזהה הקריאה
					//GetCallInfoJson(readId);

					if (Session["TecId"] != null)

						hiddenTechnicianId.Value = Session["TecId"].ToString();

					// הוספת סקריפט שיפעיל את הפונקציה עם טעינת הדף
					string script = $"document.addEventListener('DOMContentLoaded', function() {{ loadQuoteFromRead({readId}); }});";
					ScriptManager.RegisterStartupScript(this, GetType(), "LoadQuote", script, true);

				}

			}
		}

		private bool ValidateAuthentication()
		{
			return Session["TecId"] != null;
		}


		[WebMethod]
		public static string GetCallInfoJson(int readId)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine($"GetCallInfoJson called with readId: {readId}");
				using (var db = new DbContext())
				{
					string sql = @"SELECT r.*, m.ModelName 
                          FROM T_Readability r 
                          LEFT JOIN T_Models m ON r.ModelCode = m.ModelCode 
                          WHERE r.ReadId = @ReadId";

					var parameters = new SqlParameter[]
					{
				new SqlParameter("@ReadId", readId)
					};

					System.Diagnostics.Debug.WriteLine($"Executing SQL: {sql}");
					DataTable dt = db.Execute(sql, parameters);
					System.Diagnostics.Debug.WriteLine($"Rows returned: {dt.Rows.Count}");

					if (dt.Rows.Count > 0)
					{
						var row = dt.Rows[0];
						var data = new
						{
							ReadId = Convert.ToInt32(row["ReadId"]),
							FullName = row["FullName"]?.ToString(),
							Phone = row["Phone"]?.ToString(),
							Desc = row["Desc"]?.ToString(),
							ModelCode = row["ModelCode"]?.ToString(),
							ModelName = row["ModelName"]?.ToString()
						};

						var json = JsonConvert.SerializeObject(data);
						System.Diagnostics.Debug.WriteLine($"Returning JSON: {json}");
						return json;
					}
					System.Diagnostics.Debug.WriteLine("No rows found");
					return null;
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in GetCallInfoJson: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack trace: {ex.StackTrace}");
				return JsonConvert.SerializeObject(new { error = ex.Message });
			}
		}

		protected void btnSave_Click(object sender, EventArgs e)
		{
			try
			{
				if (!ValidateAuthentication())
				{
					throw new Exception("משתמש לא מחובר");
				}

				// המרת ערכים עם בדיקת תקינות
				if (!int.TryParse(hiddenReadId.Value, out int readId))
				{
					throw new Exception("מזהה קריאה לא תקין");
				}

				if (!int.TryParse(hiddenTechnicianId.Value, out int tecId))
				{
					throw new Exception("מזהה טכנאי לא תקין");
				}

				// קבלת הנתונים מהטופס

				string description = txtDesc.Text?.Trim() ?? "הצעת מחיר";
				decimal totalPrice;
				if (!decimal.TryParse(txtTotalPrice.Text, out totalPrice))
				{
					throw new Exception("סכום לא תקין");
				}

				// קבלת פרטי הפריט מהשדות הנסתרים או מהטופס
				string itemDesc = Request.Form["itemDescription"]?.Trim();
				int itemQuantity;
				if (!int.TryParse(Request.Form["itemQuantity"], out itemQuantity))
				{
					itemQuantity = 1; // ברירת מחדל
				}

				decimal itemUnitPrice;
				if (!decimal.TryParse(Request.Form["itemUnitPrice"], out itemUnitPrice))
				{
					itemUnitPrice = totalPrice; // אם לא צוין מחיר ליחידה, נשתמש במחיר הכולל
				}
				string fullname = txtCustomerName.Text?.Trim() ?? "שם לקוח";
				System.Diagnostics.Debug.WriteLine($"FullName from TextBox: {fullname}");
				var bid = new Bid
				{
					FullName = fullname,
					ReadId = readId,
					TecId = tecId,
					Price = totalPrice,
					Desc = description,
					Date = DateTime.Now,
					Status = false,
					ItemDescription = itemDesc,
					ItemQuantity = itemQuantity,
					ItemUnitPrice = itemUnitPrice

				};
				// חישוב המחירים
				decimal vatAmount = bid.VatAmount;      // מע"מ
				decimal totalWithVat = bid.TotalWithVat; // סה"כ כולל מע"מ

				// עדכון ה-JavaScript עם הערכים החדשים
				string updateScript = $@"
            document.getElementById('subtotal').innerText = '₪{bid.Price:N2}';
            document.getElementById('vat').innerText = '₪{vatAmount:N2}';
            document.getElementById('total').innerText = '₪{totalWithVat:N2}';
        ";
				ScriptManager.RegisterStartupScript(this, GetType(), "UpdateTotals", updateScript, true);



				// חישוב המחיר הכולל לפי הכמות והמחיר ליחידה
				bid.CalculateTotalPrice();

				// שמירת ההצעה
				bid.SaveNewBid();

				// עדכון סטטוס הקריאה
				var readability = Readability.GetById(readId);
				if (readability != null)
				{
					readability.Status = true;
					readability.UpdateReadability();
				}

				// הודעה על הצלחה וניתוב חזרה לדף הקריאות
				ScriptManager.RegisterStartupScript(this, GetType(), "SaveSuccess",
					"alert('הצעת המחיר נשמרה בהצלחה'); window.location.href='Forms.aspx';", true);
			}
			catch (Exception ex)
			{
				// הצגת שגיאה למשתמש
				ScriptManager.RegisterStartupScript(this, GetType(), "SaveError",
					$"alert('שגיאה בשמירת הצעת מחיר: {ex.Message}');", true);
			}
		}
		[WebMethod]
		public static string GetTechnicianInfoJson()
		{
			try
			{
				int techId = Convert.ToInt32(HttpContext.Current.Session["TecId"]);

				// בדיקה שה-ID תקין
				if (techId <= 0)
				{
					throw new Exception("מזהה טכנאי לא תקין");
				}

				var technician = TechniciansDAL.GetById(techId);
				if (technician == null)
				{
					throw new Exception("לא נמצא טכנאי במערכת");
				}

				return JsonConvert.SerializeObject(new
				{
					TecId = technician.TecId,
					FulName = technician.FulName,
					Phone = technician.Phone

				});
			}
			catch (Exception ex)
			{
				// לוגינג של השגיאה
				System.Diagnostics.Debug.WriteLine($"שגיאה בקבלת פרטי טכנאי: {ex.Message}");
				return JsonConvert.SerializeObject(new { error = ex.Message });
			}
		}

	}
}