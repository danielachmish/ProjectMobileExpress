using System;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Linq;
using Google.Apis.Auth;
using System.Web.Services;
using System.Web;

namespace MobileExpress.TechniciansFolder
{
    public partial class SingInTechnicians : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // בדיקה אם המשתמש כבר מחובר
                if (User.Identity.IsAuthenticated)
                {
                    Response.Redirect("MainTechnicians.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            // וידוא שהשדות לא ריקים
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("נא למלא את כל השדות");
                return;
            }

            try
            {
                // קבלת כל הטכנאים ומציאת התאמה למייל
                var technicians = Technicians.GetAll();
                var technician = technicians.FirstOrDefault(t =>
                    t.Email.Equals(email, StringComparison.OrdinalIgnoreCase));

                if (technician == null)
                {
                    ShowError("כתובת האימייל אינה רשומה במערכת");
                    return;
                }

                // בדיקת הסיסמה
                string hashedInputPassword = Technicians.HashPassword(password);
                if (hashedInputPassword != technician.Pass)
                {
                    ShowError("סיסמה שגויה");
                    return;
                }

                // התחברות מוצלחת
                LoginUser(technician);
            }
            catch (Exception ex)
            {
                ShowError("אירעה שגיאה בתהליך ההתחברות. אנא נסה שוב מאוחר יותר.");
                System.Diagnostics.Debug.WriteLine($"שגיאת התחברות: {ex.Message}");
            }
        }

        private void LoginUser(Technicians technician)
        {
            // יצירת עוגיית אימות
            FormsAuthentication.SetAuthCookie(technician.Email, false);

            // שמירת פרטי המשתמש בסשן
            Session["TecId"] = technician.TecId;
            Session["FulName"] = technician.FulName;
            Session["UserName"] = technician.UserName;
            Session["Type"] = technician.Type;
            Session["Email"] = technician.Email;

            // הפניה לדף הבית
            Response.Redirect("MainTechnicians.aspx");
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Visible = true;
        }

        [WebMethod]
        public static object VerifyGoogleToken(string idToken)
        {
            try
            {
                var settings = new GoogleJsonWebSignature.ValidationSettings()
                {
                    Audience = new[] { "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com" }
                };

                var payload = GoogleJsonWebSignature.ValidateAsync(idToken, settings).Result;

                // בדיקה אם המשתמש קיים במערכת
                var technicians = Technicians.GetAll();
                var existingTechnician = technicians.FirstOrDefault(t =>
                    t.Email.Equals(payload.Email, StringComparison.OrdinalIgnoreCase));

                if (existingTechnician != null)
                {
                    // יצירת חיבור למשתמש קיים
                    FormsAuthentication.SetAuthCookie(payload.Email, false);

                    HttpContext.Current.Session["TecId"] = existingTechnician.TecId;
                    HttpContext.Current.Session["FulName"] = existingTechnician.FulName;
                    HttpContext.Current.Session["UserName"] = existingTechnician.UserName;
                    HttpContext.Current.Session["Type"] = existingTechnician.Type;
                    HttpContext.Current.Session["Email"] = existingTechnician.Email;

                    return new { success = true };
                }

                return new
                {
                    success = false,
                    message = "משתמש לא קיים במערכת. אנא הירשם תחילה."
                };
            }
            catch (Exception ex)
            {
                return new { success = false, error = ex.Message };
            }
        }
    }
}