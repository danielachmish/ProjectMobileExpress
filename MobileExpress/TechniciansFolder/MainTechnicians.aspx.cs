using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Security.AccessControl;
using System.Security.Principal;
using System.Threading;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.TechniciansFolder
{

	public partial class MainTechnicians : System.Web.UI.Page
	{
		protected ReadabilityStats CurrentStats;

		
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				int tecId = Convert.ToInt32(Session["TecId"]);

				// קבלת שם הטכנאי
				string sql = $"SELECT FulName FROM T_Technicians WHERE TecId = {tecId}";
				DbContext db = new DbContext();
				DataTable dt = db.Execute(sql);
				if (dt.Rows.Count > 0)
				{
					string technicianName = $"{dt.Rows[0]["FulName"]}";
					string greeting = GetTimeBasedGreeting();
					lblTechnicianName.Text = $"{greeting} {technicianName}";
				}
				LoadStats();

			}

		}


		private void LoadStats()
		{
			// בהנחה שאתה שומר את ID הטכנאי בסשן
			int technicianId = Convert.ToInt32(Session["TechnicianId"]);
			CurrentStats = ReadabilityStats.GetTechnicianStats(technicianId);
		}
		private string GetTimeBasedGreeting()
		{
			int currentHour = DateTime.Now.Hour;

			if (currentHour >= 5 && currentHour < 12)
			{
				return "בוקר טוב";
			}
			else if (currentHour >= 12 && currentHour < 17)
			{
				return "צהריים טובים";
			}
			else if (currentHour >= 17 && currentHour < 21)
			{
				return "ערב טוב";
			}
			else
			{
				return "לילה טוב";
			}
		}

	}


}
