using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Users
{
    public partial class Main : System.Web.UI.Page
    {
        protected Customers customers;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CusId"] != null)
                {
                    int cusId = Convert.ToInt32(Session["CusId"]);
                    // שמירת המזהה בשדה הנסתר והגדרת הקישור
                    hdnCusId.Value = cusId.ToString();
                    editProfileLink.HRef = $"CustomerProfile.aspx?id={cusId}";

                    // קבלת פרטי הלקוח
                    customers = Customers.GetById(cusId);
                    if (customers != null)
                    {
                        // עדכון ערכי התצוגה
                        fullNameValue.InnerText = customers.FullName;
                        phoneValue.InnerText = customers.Phone;
                        addressValue.InnerText = customers.Addres;
                        EmailValue.InnerText = customers.Email;

                        // עדכון ערכי השדות
                        fullNameInput.Value = customers.FullName;
                        phoneInput.Value = customers.Phone;
                        addressInput.Value = customers.Addres;
                        EmailInput.Value = customers.Email;

                        // הצגת ברכה עם שם הלקוח
                        string greeting = GetTimeBasedGreeting();
                        lblCustomersName.Text = $"{greeting} {customers.FullName}";
                    }
                }
            }
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

        //    [WebMethod]
        //    [ScriptMethod(UseHttpGet = false)]
        //    public static object UpdateProfile(TechnicianData technicianData)
        //    {
        //        try
        //        {
        //            System.Diagnostics.Debug.WriteLine($"קיבלתי עדכון עבור טכנאי {technicianData.TecId}");
        //            System.Diagnostics.Debug.WriteLine($"שם חדש: {technicianData.FulName}");

        //            if (HttpContext.Current.Session["TecId"] == null)
        //            {
        //                return new { success = false, message = "המשתמש לא מחובר" };
        //            }

        //            var existingTechnician = Technicians.GetById(technicianData.TecId);
        //            if (existingTechnician == null)
        //            {
        //                return new { success = false, message = "לא נמצא טכנאי" };
        //            }

        //            // עדכון הערכים
        //            existingTechnician.FulName = technicianData.FulName;
        //            existingTechnician.Phone = technicianData.Phone;
        //            existingTechnician.Address = technicianData.Address;
        //            existingTechnician.Type = technicianData.Type;
        //            existingTechnician.Email = technicianData.Email;

        //            // הוספת בדיקה שהערכים אכן השתנו
        //            System.Diagnostics.Debug.WriteLine($"ערכים לעדכון - שם: {existingTechnician.FulName}, טלפון: {existingTechnician.Phone}");

        //            existingTechnician.Save();

        //            return new { success = true };
        //        }
        //        catch (Exception ex)
        //        {
        //            System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון פרטי טכנאי: {ex.Message}");
        //            System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
        //            return new { success = false, message = ex.Message };
        //        }
        //    }
        //    public class TechnicianData
        //    {
        //        public int TecId { get; set; }
        //        public string FulName { get; set; }
        //        public string Phone { get; set; }
        //        public string Address { get; set; }
        //        public string Type { get; set; }
        //        public string Email { get; set; }
        //    }
        //}
    }
}
