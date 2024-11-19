using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
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
        protected Technicians technician;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int tecId = Convert.ToInt32(Session["TecId"]);
                hdnTecId.Value = tecId.ToString(); // שמירת המזהה בשדה הנסתר
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
            }
        }
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
    }
}