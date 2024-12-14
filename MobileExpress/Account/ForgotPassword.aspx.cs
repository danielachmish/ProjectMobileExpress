using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Account
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        //private EmailService _emailService;

        //public ForgotPassword()
        //{
        //    _emailService = new EmailService();
        //}

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendCode_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim();

                // קורא לפונקציה מה-BLL
                BLL.PasswordReset.CreatePasswordReset(email);

                // הצגת הודעת הצלחה למשתמש
                ShowMessage("קוד אימות נשלח לכתובת המייל שלך", true);

                // הפניה לדף הבא עם המייל בתור פרמטר
                Response.Redirect($"ResetPassword.aspx?email={Server.UrlEncode(email)}");
            }
            catch (Exception ex)
            {
                // הצגת שגיאה למשתמש
                ShowMessage(ex.Message, false);

                // רישום השגיאה ללוג
                System.Diagnostics.Debug.WriteLine($"שגיאה בשליחת קוד אימות: {ex.Message}");
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "success-message" : "error-message";
            lblMessage.Visible = true;
        }
    }
}