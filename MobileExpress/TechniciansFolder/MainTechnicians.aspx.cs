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
        public static List<string> GetImagesFromDirectory(string path)
        {
            try
            {
                // נתיב מלא לתיקייה
                string fullPath = HttpContext.Current.Server.MapPath("~/assets/images/");
                System.Diagnostics.Debug.WriteLine($"Checking directory path: {fullPath}");

                // בדיקת קיום התיקייה
                if (!Directory.Exists(fullPath))
                {
                    System.Diagnostics.Debug.WriteLine("Directory doesn't exist - creating it");
                    Directory.CreateDirectory(fullPath);
                }

                // הוספת הרשאות גישה לתיקייה
                DirectoryInfo dirInfo = new DirectoryInfo(fullPath);
                DirectorySecurity dirSecurity = dirInfo.GetAccessControl();

                // הוספת הרשאות לקבוצת ASPNET
                SecurityIdentifier aspnetSid = new SecurityIdentifier(WellKnownSidType.WorldSid, null);
                FileSystemAccessRule aspnetRule = new FileSystemAccessRule(
                    aspnetSid,
                    FileSystemRights.ReadAndExecute | FileSystemRights.ListDirectory,
                    InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit,
                    PropagationFlags.None,
                    AccessControlType.Allow);

                dirSecurity.AddAccessRule(aspnetRule);
                dirInfo.SetAccessControl(dirSecurity);

                // קבלת רשימת הקבצים
                var imageFiles = Directory.GetFiles(fullPath)
                    .Where(file => new[] { ".jpg", ".jpeg", ".png", ".gif" }
                        .Contains(Path.GetExtension(file).ToLower()))
                    .ToList();

                System.Diagnostics.Debug.WriteLine($"Found {imageFiles.Count} images");
                foreach (var file in imageFiles)
                {
                    System.Diagnostics.Debug.WriteLine($"Image found: {file}");
                }

                // יצירת נתיבים יחסיים
                var relativeUrls = imageFiles
                    .Select(file => $"/assets/images/{Path.GetFileName(file)}")
                    .ToList();

                return relativeUrls;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetImagesFromDirectory: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack trace: {ex.StackTrace}");
                return new List<string>();
            }
        }
    }
}