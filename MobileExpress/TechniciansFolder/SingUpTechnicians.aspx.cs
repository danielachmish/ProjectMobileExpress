using BLL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Http;
using Facebook.NET.SDK.Client;
using Facebook;

namespace MobileExpress.TechniciansFolder
{
	public partial class SingUpTechnicians : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}
        protected void SaveTechnicians(object sender, EventArgs e)
        {
            try
            {
                HiddenField hfTecId = (HiddenField)Page.FindControl("hfTecId");

                string FulName = txtFulName.Text;
                string TecNum = txtTecNum.Text;
                string Phone = txtPhone.Text;
                string Address = txtAddress.Text;
                string Pass = txtPass.Text;
                string UserName = txtUserName.Text;
                string Type = txtType.Text;
                String Email = txtEmail.Text;
                //if (!int.TryParse(txtCityId.Text, out int CityId))
                //{
                //    throw new Exception("ערך לא תקין עבור שדה מספר עיר");
                //}

                ValidateFields(FulName, TecNum, Phone, Address, Pass, UserName, Type, Email);

                var technicians = new Technicians
                {
                    TecId = hfTecId != null && !string.IsNullOrEmpty(hfTecId.Value) && int.TryParse(hfTecId.Value, out int TecId) ? TecId : -1,
                    TecNum = TecNum,
                    FulName = FulName,
                    Phone = Phone,
                    Address = Address,
                    Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
                    UserName = UserName,
                    Type = Type,
                    Email = Email,
                    DateAddition = DateTime.Now,
                    
                };

                if (technicians.TecId <=0)
                {
                    technicians.Save();
                }
                else
                {
                    technicians.UpdateTechnician();
                }


                ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript", "closeModal();", true);

                if (!Response.IsRequestBeingRedirected)
                {
                    Response.Redirect(Request.RawUrl, false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                return;
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('שגיאה בשמירת לקוח: {ex.Message}');</script>");
            }
        }

        private void ValidateFields(params string[] fields)
        {
            string[] fieldNames = { "FullName","TecNum", "Phone", "Address", "Pass", "UserName","Type","Email","DateAddition" };
            for (int i = 0; i < fields.Length; i++)
            {
                if (string.IsNullOrEmpty(fields[i]))
                {
                    throw new Exception($"{fieldNames[i]} is missing or invalid");
                }
            }
        }

        private string HashPassword(string password)
        {
            System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
            var hashedPassword = Convert.ToBase64String(System.Security.Cryptography.SHA256.Create().ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
            System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
            return hashedPassword;
        }


        public class EmailSignUpResult
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public string Token { get; set; }
        }

        protected void EmailSignUp(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPass.Text;

            var result = ValidateAndSignUp(email, password);

            if (result.Success)
            {
                Session["UserToken"] = result.Token;
                ScriptManager.RegisterStartupScript(this, GetType(), "Success",
                    $"alert('{result.Message}'); window.location = 'MainTechnicians.aspx';", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Error",
                    $"alert('{result.Message}');", true);
            }
        }

        private EmailSignUpResult ValidateAndSignUp(string email, string password)
        {
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                return new EmailSignUpResult
                {
                    Success = false,
                    Message = "נא למלא את כל השדות הנדרשים"
                };
            }

            if (!IsValidEmail(email))
            {
                return new EmailSignUpResult
                {
                    Success = false,
                    Message = "כתובת המייל אינה תקינה"
                };
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["YourConnectionString"].ConnectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO Technicians (Email, Password, CreatedDate) VALUES (@Email, @Password, @CreatedDate)", conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password); // השתמש בסיסמה כמו שהיא בינתיים
                        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                        cmd.ExecuteNonQuery();
                    }
                }

                string token = GenerateToken(email);

                return new EmailSignUpResult
                {
                    Success = true,
                    Message = "ההרשמה בוצעה בהצלחה",
                    Token = token
                };
            }
            catch (Exception ex)
            {
                return new EmailSignUpResult
                {
                    Success = false,
                    Message = "אירעה שגיאה בתהליך ההרשמה"
                };
            }
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private string GenerateToken(string email)
        {
            return Convert.ToBase64String(Guid.NewGuid().ToByteArray());
        }

        //protected void FacebookSignUp(object sender, EventArgs e)
        //{
        //    // קריאה לפונקציית הרשמה דרך פייסבוק
        //    var result = ValidateAndSignUpWithFacebook();

        //    if (result.Success)
        //    {
        //        Session["UserToken"] = result.Token;
        //        ScriptManager.RegisterStartupScript(this, GetType(), "Success",
        //            $"alert('{result.Message}'); window.location = 'MainTechnicians.aspx';", true);
        //    }
        //    else
        //    {
        //        ScriptManager.RegisterStartupScript(this, GetType(), "Error",
        //            $"alert('{result.Message}');", true);
        //    }
        //}

        //private EmailSignUpResult ValidateAndSignUpWithFacebook()
        //{
        //    try
        //    {
        //        // קבלת הטוקן מפייסבוק
        //        var fbToken = Request.Form["fbToken"];
        //        if (string.IsNullOrEmpty(fbToken))
        //        {
        //            return new EmailSignUpResult { Success = false, Message = "לא התקבל טוקן מפייסבוק" };
        //        }

        //        // קריאה ל-API של פייסבוק לקבלת פרטי המשתמש
        //        var fb = new Facebook.NET.SDK.Client.FacebookClient(fbToken);
        //        dynamic result = fb.Get("me", new { fields = "email,name" });

        //        string fbEmail = result.email;
        //        string fbName = result.name;

        //        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["YourConnectionString"].ConnectionString))
        //        {
        //            conn.Open();
        //            // בדיקה אם המשתמש כבר קיים
        //            using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Technicians WHERE Email = @Email", conn))
        //            {
        //                checkCmd.Parameters.AddWithValue("@Email", fbEmail);
        //                int exists = (int)checkCmd.ExecuteScalar();

        //                if (exists > 0)
        //                {
        //                    return new EmailSignUpResult { Success = false, Message = "משתמש כבר קיים במערכת" };
        //                }
        //            }

        //            // הוספת משתמש חדש
        //            using (SqlCommand cmd = new SqlCommand(@"
        //            INSERT INTO Technicians (Email, FullName, CreatedDate, IsFacebookUser) 
        //            VALUES (@Email, @FullName, @CreatedDate, 1)", conn))
        //            {
        //                cmd.Parameters.AddWithValue("@Email", fbEmail);
        //                cmd.Parameters.AddWithValue("@FullName", fbName);
        //                cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
        //                cmd.ExecuteNonQuery();
        //            }
        //        }

        //        string token = GenerateToken(fbEmail);

        //        return new EmailSignUpResult
        //        {
        //            Success = true,
        //            Message = "ההרשמה בוצעה בהצלחה",
        //            Token = token
        //        };
        //    }
        //    catch (Exception ex)
        //    {
        //        return new EmailSignUpResult { Success = false, Message = "אירעה שגיאה בתהליך ההרשמה" };
        //    }
        //}
    }
}


