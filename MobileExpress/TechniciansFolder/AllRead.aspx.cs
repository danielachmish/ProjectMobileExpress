using BLL;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Calendar.v3;
using Google.Apis.Services;
using Newtonsoft.Json;
using System;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Linq;

namespace MobileExpress.TechniciansFolder
{
	public partial class AllRead : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				LoadCalls();
				//LoadApprovedCalls();
			

				string readId = Request.QueryString["readId"];
				if (!string.IsNullOrEmpty(readId))
				{
					GetCallInfoJson(readId);
				}

			}

		}
		
		//private void LoadApprovedCalls()
		//{
		//	if (Session["TechnicianId"] != null)
		//	{
		//		int techId = Convert.ToInt32(Session["TechnicianId"]);
		//		var calls = Readability.GetAll()
		//			.Where(c => c.AssignedTechnicianId == techId)
		//			.ToList();

				
		//		CallsRepeater.DataSource = calls;
		//		CallsRepeater.DataBind();
		//	}
		//}
		[WebMethod]
		[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
		public static string GetCallInfoJson(string readId)
		{
			System.Diagnostics.Debug.WriteLine($"GetCallInfoJson called with readId: {readId}");

			try
			{
				int id = Convert.ToInt32(readId);
				var readability = Readability.GetById(id);

				if (readability == null)
				{
					System.Diagnostics.Debug.WriteLine("No readability found");
					return null;
				}

				var callInfo = new
				{
					ReadId = readability.ReadId,
					FullName = readability.FullName,
					Phone = readability.Phone,
					Desc = readability.Desc,
					DateRead = readability.DateRead.ToString("yyyy-MM-ddTHH:mm:ss"),
					Urgency = readability.Urgency,
					ModelCode = readability.ModelCode,
					SerProdId = readability.SerProdId,
					Status = readability.Status,
					CallStatus = readability.CallStatus
				};

				var json = JsonConvert.SerializeObject(callInfo);
				System.Diagnostics.Debug.WriteLine($"Returning JSON: {json}");
				return json;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in GetCallInfoJson: {ex.Message}");
				return null;
			}
		}
		protected void PriceQuote_Command(object sender, CommandEventArgs e)
		{
			if (e.CommandName == "PriceQuote")
			{
				int readId = Convert.ToInt32(e.CommandArgument);
				// כאן אפשר להוסיף לוגיקה נוספת בצד שרת אם נדרש
				// לדוגמה: לוג של פתיחת הצעת מחיר, בדיקת הרשאות וכו'
			}
		}

		//private void LoadCalls()
		//{
		//	try
		//	{

		//		if (CallsRepeater != null)
		//		{
		//			var calls = Readability.GetAll().FindAll(c => !c.Status);
		//			if (calls != null && calls.Count > 0)
		//			{
		//				CallsRepeater.DataSource = calls;
		//				CallsRepeater.DataBind();
		//			}
		//			else
		//			{
		//				// אין קריאות - אפשר להציג הודעה
		//				callsContainer.InnerHtml = "<div class='no-calls'>אין קריאות שירות פתוחות</div>";
		//			}
		//		}
		//		else
		//		{
		//			// לוג או הודעת שגיאה
		//			System.Diagnostics.Debug.WriteLine("CallsRepeater is null");
		//		}
		//	}
		//	catch (Exception ex)
		//	{
		//		// טיפול בשגיאות
		//		System.Diagnostics.Debug.WriteLine($"Error in LoadCalls: {ex.Message}");
		//	}
		//}
		private void LoadCalls()
		{
			try
			{
				if (CallsRepeater != null)
				{
					var allCalls = Readability.GetAll();
					System.Diagnostics.Debug.WriteLine($"סך הכל קריאות: {allCalls.Count}");
					foreach (var call in allCalls)
					{
						System.Diagnostics.Debug.WriteLine($"קריאה {call.ReadId}: סטטוס = {call.Status}");
					}

					var calls = allCalls.FindAll(c => c.Status);
					System.Diagnostics.Debug.WriteLine($"קריאות פתוחות: {calls.Count}");

					if (calls != null && calls.Count > 0)
					{
						CallsRepeater.DataSource = calls;
						CallsRepeater.DataBind();
					}
					else
					{
						callsContainer.InnerHtml = "<div class='no-calls'>אין קריאות שירות פתוחות</div>";
					}
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in LoadCalls: {ex.Message}");
			}
		}
		protected void RedirectToPriceQuote(object sender, EventArgs e)
		{
			Button btn = (Button)sender;
			string readId = btn.CommandArgument;
			Response.Redirect($"AllBids.aspx?readId={readId}");
		}



		protected void RefreshTimer_Tick(object sender, EventArgs e)
		{
			LoadCalls();
			
		}

		protected void AcceptCall(object sender, EventArgs e)
		{
			try
			{
				Button btn = (Button)sender;
				int readId = Convert.ToInt32(btn.CommandArgument);
				var call = Readability.GetById(readId);

				if (call != null && Session["TechnicianId"] != null)
				{
					// עדכון הקריאה
					call.AssignedTechnicianId = Convert.ToInt32(Session["TechnicianId"]);
					call.Status = true;
					call.UpdateReadability();



					// רענון הדף
					LoadCalls();
					//LoadApprovedCalls();

					// הודעת הצלחה
					ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
						"Swal.fire({" +
						"  title: 'הקריאה נקלטה'," +
						"  text: 'הקריאה התקבלה בהצלחה'," +
						"  icon: 'success'," +
						"  timer: 2000," +
						"  showConfirmButton: false" +
						"});", true);
				}
				else
				{
					ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
						"Swal.fire('שגיאה', 'לא נמצאה הקריאה או שהמשתמש לא מחובר', 'error');", true);
				}
			}
		
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in AcceptCall: {ex.Message}");
				ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
					"Swal.fire('שגיאה', 'אירעה שגיאה בקבלת הקריאה', 'error');", true);
			}
		}


		protected string GetStatusText(CallStatus status)
		{
			switch (status)
			{
				case CallStatus.Open:
					return "קריאה פתוחה";
				case CallStatus.InProgress:
					return "בטיפול";
				case CallStatus.Closed:
					return "קריאה סגורה";
				default:
					return "";
			}
		}
	}
}



