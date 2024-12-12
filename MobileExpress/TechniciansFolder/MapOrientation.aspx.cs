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

		protected string GetStatusText(bool status)
		{
			return status ? "קריאה פתוחה" : "קריאה סגורה";
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
		protected string GetFullAddress(object street, object houseNumber, object city)
		{
			return $"{street} {houseNumber}, {city}, ישראל";
		}

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