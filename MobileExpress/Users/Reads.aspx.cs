using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace MobileExpress.Users
{
	public partial class Reads : System.Web.UI.Page
	{
        public List<Readability> reads { get; set; } = new List<Readability>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
			{
				if (Session["CusId"] == null)
				{
					Response.Redirect("~/Users/SingIn.aspx");
					return;
				}
				LoadReads();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // יישום חיפוש
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            // יישום סינון לפי סטטוס
        }

        private void LoadReads()
        {
            try
            {
                int cusId = Convert.ToInt32(Session["CusId"]);
                var reads = Readability.GetAllByCustomerId(cusId);
                gvReads.DataSource = reads;
                gvReads.DataBind();
            }
            catch (Exception ex)
            {
                // טיפול בשגיאה
            }
        }

        protected string GetStatusClass(bool status)
        {
            return status ? "badge-success" : "badge-pending";
        }

        public string GetStatusText(bool status)
        {
            return status ? "מאושר" : "ממתין לאישור";
        }

        public string GetUrgencyClass(string urgency)
        {
            if (string.IsNullOrEmpty(urgency))
                return "badge-secondary";

            switch (urgency.ToLower())
            {
                case "גבוהה":
                    return "badge-danger";
                case "בינונית":
                    return "badge-warning";
                case "נמוכה":
                    return "badge-success";
                default:
                    return "badge-secondary";
            }
        }
    }
}