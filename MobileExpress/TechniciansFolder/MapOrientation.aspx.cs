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

				//בדיקה אם המשתמש מחובר

				//if (Session["TecId"] == null || !User.Identity.IsAuthenticated)
				//{
				//	Response.Redirect("~/TechniciansFolder/SingInTechnicians.aspx");
				//	return;
				//}
			}
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetServiceCalls()
        {
            try
            {
                // בדיקת התחברות גם בקריאת השירות
                if (HttpContext.Current.Session["TecId"] == null)
                {
                    return new { success = false, message = "משתמש לא מחובר" };
                }

                int technicianId = Convert.ToInt32(HttpContext.Current.Session["TecId"]);

                // כאן תהיה הלוגיקה לשליפת קריאות השירות הרלוונטיות לטכנאי
                // לדוגמה:
                return new
                {
                    success = true,
                    data = new[] {
                        new {
                            id = 1,
                            type = "תיקון מזגן",
                            status = "חדש",
                            address = "רחוב דיזנגוף 123, תל אביב",
                            description = "מזגן לא מקרר",
                            customerName = "ישראל ישראלי",
                            phone = "050-1234567",
                            coordinates = new double[] { 34.7747, 32.0853 },
                            timeCreated = DateTime.Now.ToString("yyyy-MM-dd HH:mm")
                        }
                        // הוסף עוד קריאות שירות לפי הצורך
                    }
                };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object AcceptServiceCall(int callId)
        {
            try
            {
                if (HttpContext.Current.Session["TecId"] == null)
                {
                    return new { success = false, message = "משתמש לא מחובר" };
                }

                int technicianId = Convert.ToInt32(HttpContext.Current.Session["TecId"]);

                // כאן תהיה הלוגיקה לעדכון קריאת השירות
                // לדוגמה:
                // ServiceCallsDAL.UpdateCallStatus(callId, technicianId, "בטיפול");

                return new { success = true, message = "הקריאה התקבלה בהצלחה" };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }
    }
}