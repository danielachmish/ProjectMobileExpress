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
    public partial class MapOrientation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadServiceCalls();
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
    }
}