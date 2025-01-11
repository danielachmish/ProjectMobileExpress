using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Manage
{
	public partial class VatRateManagement : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            LoadDashboardData();
        }
        private void LoadDashboardData()
        {
            decimal currentVat = BLL.VatRate.GetCurrentRate();
            lblCurrentVat.Text = $"{currentVat:P0}";
        }
        protected void btnUpdateVat_Click(object sender, EventArgs e)
        {
            try
            {
                if (decimal.TryParse(txtNewVatRate.Text, out decimal newRate))
                {
                    newRate = newRate / 100;
                    BLL.VatRate.UpdateRate(newRate);  // הוספת BLL.
                    LoadDashboardData();
                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateSuccess",
                        "alert('אחוז המע\"מ עודכן בהצלחה');", true);
                }
                else
                {
                    throw new Exception("אנא הכנס ערך מספרי תקין");
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UpdateError",
                    $"alert('שגיאה בעדכון המע\"מ: {ex.Message}');", true);
            }
        }
    }
}