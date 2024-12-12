using Betfair_API_NG.TO;
using BLL;
using DAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
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
				//if (Session["TecId"] == null)
				//{
				//	Response.Redirect("~/SingInTechhnicians.aspx");
				//	return;
				//}
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

				var bid = new Bid
				{
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