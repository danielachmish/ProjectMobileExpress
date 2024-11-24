using BLL;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Calendar.v3;
using Google.Apis.Services;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.ComponentModel;
using System.Net.Http;
using System.Configuration;
using System.Web.Script.Services;

namespace MobileExpress.TechniciansFolder
{
	public partial class AllRead : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				LoadCalls();

				string readId = Request.QueryString["readId"];
				if (!string.IsNullOrEmpty(readId))
				{
					// בצע פעולות בהתאם למזהה הקריאה
					GetCallInfoJson(readId);
				}

			}

		}
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
					ModelId = readability.ModelId,
					SerProdId = readability.SerProdId,
					Status = readability.Status
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

		private void LoadCalls()
		{
			try
			{
				// וודא שה-Repeater קיים
				if (CallsRepeater != null)
				{
					var calls = Readability.GetAll().FindAll(c => !c.Status);
					if (calls != null && calls.Count > 0)
					{
						CallsRepeater.DataSource = calls;
						CallsRepeater.DataBind();
					}
					else
					{
						// אין קריאות - אפשר להציג הודעה
						callsContainer.InnerHtml = "<div class='no-calls'>אין קריאות שירות פתוחות</div>";
					}
				}
				else
				{
					// לוג או הודעת שגיאה
					System.Diagnostics.Debug.WriteLine("CallsRepeater is null");
				}
			}
			catch (Exception ex)
			{
				// טיפול בשגיאות
				System.Diagnostics.Debug.WriteLine($"Error in LoadCalls: {ex.Message}");
			}
		}
		protected void RedirectToPriceQuote(object sender, EventArgs e)
		{
			Button btn = (Button)sender;
			string readId = btn.CommandArgument;
			Response.Redirect($"AllBids.aspx?readId={readId}");
		}
		//protected void CallAction_Command(object sender, CommandEventArgs e)
		//{
		//	try
		//	{
		//		int readId = Convert.ToInt32(e.CommandArgument);

		//		// קבלת הקריאה מהדאטהבייס
		//		var call = Readability.GetById(readId);

		//		if (call != null)
		//		{
		//			// עדכון סטטוס הקריאה
		//			call.Status = (e.CommandName == "Accept");
		//			call.UpdateReadability();

		//			// הוספת האירוע ליומן Google
		//			if (call.Status)
		//			{
		//				AddEventToGoogleCalendar(call);
		//			}

		//			// טען מחדש את הרשימה
		//			LoadCalls();
		//		}
		//	}
		//	catch (Exception ex)
		//	{
		//		// טיפול בשגיאות
		//		System.Diagnostics.Debug.WriteLine($"Error in CallAction_Command: {ex.Message}");
		//	}
		//}


		protected void RefreshTimer_Tick(object sender, EventArgs e)
		{
			LoadCalls();
		}
		//[WebMethod]
		//public static string GetCallInfoJson(string readId)
		//{
		//	try
		//	{
		//		int id = Convert.ToInt32(readId);
		//		var readability = Readability.GetById(id);
		//		if (readability == null)
		//		{
		//			return "null";
		//		}

		//		var callInfo = new
		//		{
		//			ReadId = readability.ReadId,
		//			FullName = readability.FullName,
		//			Phone = readability.Phone,
		//			Desc = readability.Desc,
		//			DateRead = readability.DateRead.ToString("yyyy-MM-ddTHH:mm:ss"),
		//			Urgency = readability.Urgency,
		//			ModelId = readability.ModelId,
		//			SerProdId = readability.SerProdId,
		//			Nots = readability.Nots ?? "",
		//			Status = readability.Status
		//		};

		//		return JsonConvert.SerializeObject(callInfo);
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"Error in GetCallInfoJson: {ex.Message}");
		//		return "null";
		//	}
		//}

		//private CalendarService GetCalendarService()
		//{
		//    try
		//    {
		//        // מיקום קובץ ה-credentials.json
		//        string credentialsPath = Server.MapPath("~/App_Data/credentials.json");

		//        GoogleCredential credential;
		//        using (var stream = new FileStream(credentialsPath, FileMode.Open, FileAccess.Read))
		//        {
		//            credential = GoogleCredential.FromStream(stream).CreateScoped(CalendarService.Scope.CalendarEvents);
		//        }

		//        return new CalendarService(new BaseClientService.Initializer()
		//        {
		//            HttpClientInitializer = credential,
		//            ApplicationName = "MobileExpress",
		//        });
		//    }
		//    catch (Exception ex)
		//    {
		//        System.Diagnostics.Debug.WriteLine($"Error in GetCalendarService: {ex.Message}");
		//        throw;
		//    }
		//}
		//private void AddEventToGoogleCalendar(Readability call)
		//{
		//	try
		//	{
		//		// יצירת חיבור לשירות Google Calendar
		//		var service = GetCalendarService();

		//		// הגדרת אירוע חדש
		//		var newEvent = new Google.Apis.Calendar.v3.Data.Event
		//		{
		//			Summary = $"קריאת שירות: {call.FullName}",
		//			Description = call.Desc,
		//			Location = "מיקום הלקוח", // תוכל לעדכן לשדה מתאים
		//			Start = new Google.Apis.Calendar.v3.Data.EventDateTime
		//			{
		//				DateTime = call.DateRead,
		//				TimeZone = "Asia/Jerusalem"
		//			},
		//			End = new Google.Apis.Calendar.v3.Data.EventDateTime
		//			{
		//				DateTime = call.DateRead.AddHours(1), // הוספת שעה לסיום האירוע
		//				TimeZone = "Asia/Jerusalem"
		//			},
		//			Reminders = new Google.Apis.Calendar.v3.Data.Event.RemindersData
		//			{
		//				UseDefault = false,
		//				Overrides = new List<Google.Apis.Calendar.v3.Data.EventReminder>
		//		{
		//			new Google.Apis.Calendar.v3.Data.EventReminder { Method = "email", Minutes = 30 },
		//			new Google.Apis.Calendar.v3.Data.EventReminder { Method = "popup", Minutes = 10 }
		//		}
		//			}
		//		};

		//		// הוספת האירוע ליומן Google
		//		var createdEvent = service.Events.Insert(newEvent, "primary").Execute();
		//		System.Diagnostics.Debug.WriteLine($"Event created: {createdEvent.HtmlLink}");
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"Error in AddEventToGoogleCalendar: {ex.Message}");
		//	}
		//}
		//private Google.Apis.Calendar.v3.CalendarService GetCalendarService()
		//{
		//	try
		//	{
		//		// נתיב לקובץ ה-credentials.json
		//		string credentialsPath = Server.MapPath("~/App_Data/credentials.json");

		//		GoogleCredential credential;
		//		using (var stream = new FileStream(credentialsPath, FileMode.Open, FileAccess.Read))
		//		{
		//			credential = GoogleCredential.FromStream(stream).CreateScoped(CalendarService.Scope.CalendarEvents);
		//		}

		//		return new Google.Apis.Calendar.v3.CalendarService(new BaseClientService.Initializer()
		//		{
		//			HttpClientInitializer = credential,
		//			ApplicationName = "MobileExpress",
		//		});
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"Error in GetCalendarService: {ex.Message}");
		//		throw;
		//	}
		//}
		//protected void RedirectToPriceQuote(object sender, EventArgs e)
		//{
		//	Button btn = (Button)sender;
		//	string readId = btn.CommandArgument;

		//	Response.Redirect("AllBids.aspx?readId=" + readId);
		//}

	}
}



