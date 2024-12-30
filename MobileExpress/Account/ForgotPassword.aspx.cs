using BLL;
using System;
using System.Threading.Tasks;
using System.Web.UI;

namespace MobileExpress.Account
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected async void btnSendCode_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim();

                if (string.IsNullOrEmpty(email))
                {
                    ShowMessage("נא להזין כתובת אימייל", false);
                    return;
                }

                await BLL.PasswordResetService.SendResetCodeEmail(email);

                ShowMessage("קוד אימות נשלח לכתובת המייל שלך", true);
                Response.Redirect($"ResetPassword.aspx?email={Server.UrlEncode(email)}");
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, false);
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