using BLL;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.TechniciansFolder
{
	public partial class MapOrientation : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack && Request.QueryString["readId"] != null)
			{
				int readId = Convert.ToInt32(Request.QueryString["readId"]);
				Readability read = ReadabilityDAL.GetById(readId);

				if (read?.Nots != null)
				{
					ClientScript.RegisterStartupScript(GetType(), "ShowLocation",
						$"findLocationByAddress('{read.Nots}');", true);
				}
				LoadServiceCalls();
				LoadTechnicianPreferences();
			}
		}
		protected CheckBox locationToggle;
		private void LoadTechnicianPreferences()
		{
			if (Session["TechnicianId"] != null)
			{
				int technicianId = Convert.ToInt32(Session["TechnicianId"]);
				var technician = Technicians.GetById(technicianId);
				if (technician != null)
				{
					locationToggle.Checked = technician.ShowLocation;
				}
			}
		}
		private void LoadServiceCalls()
		{
			try
			{
				List<Readability> serviceCalls = Readability.GetAll();

				// אם יש פילטר סטטוס
				string statusFilter = StatusFilter.SelectedValue;
				if (!string.IsNullOrEmpty(statusFilter))
				{
					bool statusValue = Convert.ToBoolean(statusFilter);
					serviceCalls = serviceCalls.Where(call => call.Status == statusValue).ToList();
				}

				// מיון לפי תאריך - מהחדש לישן
				serviceCalls = serviceCalls.OrderByDescending(call => call.DateRead).ToList();

				ServiceCallsRepeater.DataSource = serviceCalls;
				ServiceCallsRepeater.DataBind();
			}
			catch (Exception ex)
			{
				// Log the error
				System.Diagnostics.Debug.WriteLine($"Error loading service calls: {ex.Message}");
				// You might want to show an error message to the user
				ScriptManager.RegisterStartupScript(this, GetType(), "alert",
					"alert('אירעה שגיאה בטעינת הנתונים. אנא נסה שנית מאוחר יותר.');", true);
			}
		}

		protected string GetStatusText(bool Status)
		{
			return Status ? "קריאה סגורה" : "קריאה פתוחה";
		}

		protected string GetUrgencyClass(string urgency)
		{
			switch (urgency.ToLower())
			{
				case "high":
				case "גבוה":
					return "urgency-high";
				case "medium":
				case "בינוני":
					return "urgency-medium";
				default:
					return "urgency-low";
			}
		}

		protected string GetUrgencyText(string urgency)
		{
			// התאם את הטקסט לפי הערכים בדאטאבייס שלך
			return urgency;
		}

		protected string GetModelName(int modelId)
		{
			// כאן תוכל להוסיף לוגיקה לשליפת שם המודל מטבלת המודלים
			// לדוגמה:
			// return ModelsDAL.GetModelName(modelId);
			return modelId.ToString();
		}

		protected void StatusFilter_SelectedIndexChanged(object sender, EventArgs e)
		{
			LoadServiceCalls();
		}
		[WebMethod]
		public static List<object> GetServiceCalls()
		{
			try
			{
				List<Readability> serviceCalls = Readability.GetAll();

				// המרה של הנתונים לפורמט המתאים למפה
				var result = serviceCalls.Select(call => new
				{
					call.ReadId,
					call.DateRead,
					call.Desc,
					call.FullName,
					call.Phone,
					call.Nots,
					call.Status,
					call.Urgency,

				}).ToList<object>();

				return result;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in GetServiceCalls: {ex.Message}");
				throw;
			}
		}



		//להציג קריאות רק ברדיוס מסויים
		//[WebMethod]
		//public static List<object> GetServiceCalls(double currentLat, double currentLng, double radius)
		//{
		//	try
		//	{
		//		List<Readability> allCalls = Readability.GetAll();
		//		var filteredCalls = new List<Readability>();

		//		foreach (var call in allCalls)
		//		{
		//			if (string.IsNullOrEmpty(call.Nots)) continue;

		//			// פיצול המיקום לקואורדינטות
		//			var coordinates = call.Nots.Split(',');
		//			if (coordinates.Length != 2) continue;

		//			if (double.TryParse(coordinates[0], out double callLat) &&
		//				double.TryParse(coordinates[1], out double callLng))
		//			{
		//				// חישוב מרחק
		//				double distance = CalculateDistance(currentLat, currentLng, callLat, callLng);
		//				if (distance <= radius)
		//				{
		//					filteredCalls.Add(call);
		//				}
		//			}
		//		}

		//		return filteredCalls.Select(call => new
		//		{
		//			call.ReadId,
		//			call.DateRead,
		//			call.Desc,
		//			call.FullName,
		//			call.Phone,
		//			call.Nots,
		//			call.Status,
		//			call.Urgency
		//		}).ToList<object>();
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"Error in GetServiceCalls: {ex.Message}");
		//		throw;
		//	}
		//}

		//private static double CalculateDistance(double lat1, double lon1, double lat2, double lon2)
		//{
		//	var R = 6371; // רדיוס כדור הארץ בק"מ
		//	var dLat = ToRad(lat2 - lat1);
		//	var dLon = ToRad(lon2 - lon1);
		//	var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
		//			Math.Cos(ToRad(lat1)) * Math.Cos(ToRad(lat2)) *
		//			Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
		//	var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
		//	var d = R * c;
		//	return d;
		//}

		//private static double ToRad(double degrees)
		//{
		//	return degrees * (Math.PI / 180);
		//}
		//protected string GetFullAddress(object street, object houseNumber, object city)
		//{
		//	return $"{street} {houseNumber}, {city}, ישראל";
		//}











		[WebMethod]
		public static object UpdateLocationTracking(bool showLocation)
		{
			try
			{
				// בדיקה שהטכנאי מחובר
				if (HttpContext.Current.Session["TechnicianId"] == null)
				{
					return new { success = false, message = "משתמש לא מחובר" };
				}

				int technicianId = Convert.ToInt32(HttpContext.Current.Session["TechnicianId"]);

				// עדכון בבסיס הנתונים
				var technician = Technicians.GetById(technicianId);
				if (technician != null)
				{
					technician.ShowLocation = showLocation;
					technician.Save();
					return new { success = true };
				}

				return new { success = false, message = "לא נמצא משתמש" };
			}
			catch (Exception ex)
			{
				return new { success = false, message = ex.Message };
			}
		}

		



		public class LocationData
		{
			public double Latitude { get; set; }
			public double Longitude { get; set; }
			public double Accuracy { get; set; }
			public string Timestamp { get; set; }
		}
	}
}