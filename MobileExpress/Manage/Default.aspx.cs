using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Manage
{
	public partial class Default : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			LoadDashboardData();
		}
        private void LoadDashboardData()
		{
			try
			{
				int totalTechnicians = Technicians.GetTotalTechnicians();
				lblTotalTechnicians.Text = totalTechnicians.ToString();

				int totalCustomers = Customers.GetTotalCustomers();
				lblTotalCustomers.Text = totalCustomers.ToString();

				int totalReadability = Readability.GetTotalReadability();
				lblTotalReadability.Text = totalReadability.ToString();

				decimal totalBids = Bid.GetTotalBids();
				lblTotalBids.Text = string.Format("{0:C}", totalBids); // יציג כ-₪1,200.00
			}
			catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading dashboard data: {ex.Message}");
            }
        }
    }
}