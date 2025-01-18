using BLL;
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
	public partial class TechnicianProfile1 : System.Web.UI.Page
	{
		protected Technicians technician;
		protected void Page_Load(object sender, EventArgs e)
		{
			if (Session["TecId"] == null)
			{
				Response.Redirect("~/Auth/Login/TechnicianLogin.aspx");
				return;
			}
			if (!IsPostBack)
			{

			}
			int tecId = Convert.ToInt32(Session["TecId"]);
			if (hdnTecId != null)  // בדיקת null חשובה
			{
				hdnTecId.Value = tecId.ToString();
			}
			else
			{
				// לוג לדיבאג
				System.Diagnostics.Debug.WriteLine("hdnTecId is null");
			}
			technician = Technicians.GetById(tecId);
			//int tecId = Convert.ToInt32(Session["TecId"]);
			//technician = Technicians.GetById(tecId);
			if (technician != null)
			{
				// עדכון ערכי התצוגה
				fullNameValue.InnerText = technician.FulName;
				phoneValue.InnerText = technician.Phone;
				addressValue.InnerText = technician.Address;
				specializationValue.InnerText = technician.Type;
				EmailValue.InnerText = technician.Email;
				// עדכון ערכי השדות
				fullNameInput.Value = technician.FulName;
				phoneInput.Value = technician.Phone;
				addressInput.Value = technician.Address;
				specializationInput.Value = technician.Type;
				EmailInpot.Value = technician.Email;

			}
			//LoadDashboardData(tecId);
		}
		//private void LoadDashboardData(int tecId)
		//{
		//	try
		//	{


		//		decimal technicianBids = Bid.GetTechnicianTotalBids(tecId);
		//		lblTotalBids.Text = string.Format("{0:C}", technicianBids);
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"Error loading dashboard data: {ex.Message}");
		//	}
		//}
		[WebMethod]
		[ScriptMethod(UseHttpGet = false)]
		public static object UpdateProfile(TechnicianData technicianData)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine($"קיבלתי עדכון עבור טכנאי {technicianData.TecId}");
				System.Diagnostics.Debug.WriteLine($"שם חדש: {technicianData.FulName}");

				if (HttpContext.Current.Session["TecId"] == null)
				{
					return new { success = false, message = "המשתמש לא מחובר" };
				}

				var existingTechnician = Technicians.GetById(technicianData.TecId);
				if (existingTechnician == null)
				{
					return new { success = false, message = "לא נמצא טכנאי" };
				}

				// עדכון הערכים
				existingTechnician.FulName = technicianData.FulName;
				existingTechnician.Phone = technicianData.Phone;
				existingTechnician.Address = technicianData.Address;
				existingTechnician.Type = technicianData.Type;
				existingTechnician.Email = technicianData.Email;

				// הוספת בדיקה שהערכים אכן השתנו
				System.Diagnostics.Debug.WriteLine($"ערכים לעדכון - שם: {existingTechnician.FulName}, טלפון: {existingTechnician.Phone}");

				existingTechnician.Save();

				return new { success = true };
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון פרטי טכנאי: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				return new { success = false, message = ex.Message };
			}
		}
		public class TechnicianData
		{
			public int TecId { get; set; }
			public string FulName { get; set; }
			public string Phone { get; set; }
			public string Address { get; set; }
			public string Type { get; set; }
			public string Email { get; set; }
		}


		[WebMethod]
		public static object CheckLocationTracking()
		{
			try
			{
				if (HttpContext.Current.Session["TechnicianId"] != null)
				{
					int technicianId = Convert.ToInt32(HttpContext.Current.Session["TechnicianId"]);
					var technician = Technicians.GetById(technicianId);
					return new { isEnabled = technician?.ShowLocation ?? false };
				}
				return new { isEnabled = false };
			}
			catch
			{
				return new { isEnabled = false };
			}
		}
		[WebMethod]

		public static object GetTechnicianDashboardData(int technicianId)
		{
			try
			{
				// שליפת וספירת קריאות
				var totalCalls = Readability.GetAllByTechnicianId(technicianId).Count;
				var openCalls = Readability.CountCallsByTechnicianIdAndStatus(technicianId, CallStatus.Open);
				var closedCalls = Readability.CountCallsByTechnicianIdAndStatus(technicianId, CallStatus.Closed);

				// נתונים נוספים (כגון הצעות מחיר, הכנסות וכו')
				var totalBids = Bid.GetTechnicianTotalBids(technicianId);
				var pendingBids = Bid.GetAll()
									 .Where(b => b.TecId == technicianId && !b.Status)
									 .Count();

				var monthlyIncome = Bid.GetAll()
									   .Where(b => b.TecId == technicianId && b.Status && b.Date.Month == DateTime.Now.Month)
									   .Sum(b => b.Price);

				var averageRating = ReadabilityStats.GetTechnicianStats(technicianId).CompletionRate;

				return new
				{
					success = true,
					data = new
					{
						TotalCalls = totalCalls,
						OpenCalls = openCalls,
						ClosedCalls = closedCalls,
						TotalBids = totalBids,
						PendingBids = pendingBids,
						MonthlyIncome = monthlyIncome,
						AverageRating = averageRating
					}
				};
			}
			catch (Exception ex)
			{
				return new { success = false, message = ex.Message };
			}
		}


	}
}