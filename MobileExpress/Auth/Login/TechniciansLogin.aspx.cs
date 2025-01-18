using BLL;
using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Auth.Login
{
	public partial class TechniciansLogin : System.Web.UI.Page
	{
        private const string ADMIN_TYPE = "admin";
        private const string TECHNICIAN_TYPE = "technician";

        private const string ADMIN_PAGE = "~/Manage/Default.aspx";
        private const string TECHNICIAN_PAGE = "~/TechniciansFolder/MainTechnicians.aspx";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // בדיקה אם המשתמש כבר מחובר
                if (User.Identity.IsAuthenticated)
                {
                    RedirectBasedOnUserType();
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("נא למלא את כל השדות");
                return;
            }

            try
            {
                // קודם נבדוק אם זה מנהל
                var admin = Administrators.GetAll().FirstOrDefault(a =>
                    a.Email.Equals(email, StringComparison.OrdinalIgnoreCase));

                if (admin != null)
                {
                    // בדיקת סיסמת מנהל
                    string hashedAdminPassword = Administrators.HashPassword(password);
                    if (hashedAdminPassword == admin.Pass)
                    {
                        // התחברות מנהל מוצלחת
                        LoginAdmin(admin);
                        return;
                    }
                }

                // אם זה לא מנהל, נבדוק אם זה טכנאי
                var technician = Technicians.GetAll().FirstOrDefault(t =>
                    t.Email.Equals(email, StringComparison.OrdinalIgnoreCase));

                if (technician != null)
                {
                    string hashedTechPassword = EncryptionUtils.HashPassword(password);
                    if (hashedTechPassword == technician.Pass)
                    {
                        // התחברות טכנאי מוצלחת
                        LoginTechnician(technician);
                        return;
                    }
                }

                // אם הגענו לכאן, או שהמשתמש לא קיים או שהסיסמה שגויה
                ShowError("שם משתמש או סיסמה שגויים");
            }
            catch (Exception ex)
            {
                ShowError("אירעה שגיאה בתהליך ההתחברות. אנא נסה שוב מאוחר יותר.");
                System.Diagnostics.Debug.WriteLine($"שגיאת התחברות: {ex.Message}");
            }
        }

        private void LoginAdmin(Administrators admin)
        {
            FormsAuthentication.SetAuthCookie(admin.Email, false);

            Session["AdminId"] = admin.AdminId;
            Session["Email"] = admin.Email;
            Session["UserName"] = admin.Uname;
            Session["Type"] = ADMIN_TYPE;

            Response.Redirect(ADMIN_PAGE);
        }

        private void LoginTechnician(Technicians technician)
        {
            FormsAuthentication.SetAuthCookie(technician.Email, false);

            Session["TecId"] = technician.TecId;
            Session["FulName"] = technician.FulName;
            Session["UserName"] = technician.UserName;
            Session["Type"] = TECHNICIAN_TYPE;
            Session["Email"] = technician.Email;

            Response.Redirect(TECHNICIAN_PAGE);
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Visible = true;
        }


        private void RedirectBasedOnUserType()
        {
            try
            {
                string userType = Session["Type"]?.ToString().ToLower();
                System.Diagnostics.Debug.WriteLine($"User Type: {userType}"); // לוג לדיבוג

                switch (userType)
                {
                    case ADMIN_TYPE:
                        Response.Redirect(ADMIN_PAGE);
                        break;
                    case TECHNICIAN_TYPE:
                        Response.Redirect(TECHNICIAN_PAGE);
                        break;
                    default:
                        System.Diagnostics.Debug.WriteLine($"Invalid user type: {userType}"); // לוג לדיבוג
                        ShowError("סוג משתמש לא חוקי");
                        FormsAuthentication.SignOut();
                        Session.Clear();
                        break;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Redirect error: {ex.Message}"); // לוג לדיבוג
                ShowError("שגיאה בניתוב המשתמש");
            }
        }
    }
}
