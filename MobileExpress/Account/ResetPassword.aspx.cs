using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Account
{
	public partial class CreatePasswordReset : System.Web.UI.Page
	{
		
        private string Email
        {
            get { return Request.QueryString["email"]; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // בדיקה שיש מייל ב-URL
            if (string.IsNullOrEmpty(Email))
            {
                Response.Redirect("ForgotPassword.aspx");
                return;
            }
        }
        

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            try
            {
                string email = Email;
                string code = txtCode.Text.Trim();
                string newPassword = txtNewPassword.Text;

                // וידוא שהסיסמאות זהות
                if (newPassword != txtConfirmPassword.Text)
                {
                    ShowMessage("הסיסמאות אינן תואמות", false);
                    return;
                }

                // איפוס הסיסמה
                //BLL.PasswordResetService.ResetPassword(email, code, newPassword);
                BLL.PasswordResetService.ResetPassword(email, code, newPassword);

                // הצגת הודעת הצלחה
                ShowMessage("הסיסמה אופסה בהצלחה", true);

                // המתנה קצרה כדי שהמשתמש יראה את ההודעה
                System.Threading.Thread.Sleep(2000);

                // הפניה לדף ההתחברות
                Response.Redirect(ReturnUrl);
            }
            catch (Exception ex)
            {
                // הצגת שגיאה למשתמש
                ShowMessage(ex.Message, false);
                // רישום השגיאה ללוג
                System.Diagnostics.Debug.WriteLine($"שגיאה באיפוס סיסמה: {ex.Message}");
            }
        }
		

		private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "success-message" : "error-message";
            lblMessage.Visible = true;
        }

        private string ReturnUrl
        {
            get
            {
                string url = Request.QueryString["returnUrl"];
                // וידוא שמדובר בURL פנימי למניעת Open Redirect
                if (string.IsNullOrEmpty(url) || url.Contains("://"))
                    return "~/MainMobileExpress.aspx";
                return "~/" + url;
            }
        }

    }
}
