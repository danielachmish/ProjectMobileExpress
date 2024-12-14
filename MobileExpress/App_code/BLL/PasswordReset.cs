using DAL;
using SendGrid;
using System;
using System.Configuration;
using System.Net.Mail;
using System.Threading.Tasks;

namespace BLL
{
    public class PasswordReset
    {

        public static string GenerateResetCode()
        {
            Random random = new Random();
            return random.Next(100000, 999999).ToString();
        }

        public class EmailService
        {
            private readonly string _apiKey;
            private readonly string _fromEmail;
            private readonly string _fromName;

            public EmailService()
            {
                _apiKey = ConfigurationManager.AppSettings["SendGridApiKey"];
                _fromEmail = ConfigurationManager.AppSettings["EmailFrom"];
                _fromName = ConfigurationManager.AppSettings["EmailFromName"];
            }

            public async Task<SendGrid.Response> SendResetCodeEmail(string toEmail, string resetCode)
            {
                var client = new SendGridClient(_apiKey);
                var from = new SendGrid.Helpers.Mail.EmailAddress(_fromEmail, _fromName);
                var to = new SendGrid.Helpers.Mail.EmailAddress(toEmail);
                var subject = "קוד לאיפוס סיסמה";

                string plainTextContent = $@"
                קוד האימות שלך הוא: {resetCode}
                הקוד תקף למשך שעה אחת.
                אם לא ביקשת לאפס את הסיסמה, אנא התעלם מהודעה זו.";

                string htmlContent = $@"
                <div style='direction:rtl; font-family:Arial;'>
                    <h2>בקשה לאיפוס סיסמה</h2>
                    <p>קוד האימות שלך הוא: <strong>{resetCode}</strong></p>
                    <p>הקוד תקף למשך שעה אחת.</p>
                    <p>אם לא ביקשת לאפס את הסיסמה, אנא התעלם מהודעה זו.</p>
                </div>";

                var msg = SendGrid.Helpers.Mail.MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
                var response = await client.SendEmailAsync(msg);
                return response;
            }
        }

        // הפיכת הפונקציה לאסינכרונית לשימוש ב-await
        public static async Task CreatePasswordReset(string email)
        {
            var userInfo = PasswordResetServiceDAL.FindUserByEmail(email);
            if (userInfo == null)
            {
                throw new Exception("כתובת המייל לא נמצאה במערכת");
            }

            string resetCode = GenerateResetCode();
            DateTime expiryDate = DateTime.Now.AddHours(1);

            // שמירת קוד האיפוס
            PasswordResetServiceDAL.SaveResetCode(email, resetCode, expiryDate);

            var emailService = new EmailService();
            // כעת משתמשים ב-await במקום GetAwaiter().GetResult()
            var response = await emailService.SendResetCodeEmail(email, resetCode);

            // כאן ניתן לעבד את התגובה, למשל לרשום ללוג את הסטטוס
            // System.Diagnostics.Debug.WriteLine($"סטטוס השליחה: {response.StatusCode}");
        }

        public static void ResetPassword(string email, string code, string newPassword)
        {
            // בדיקת תקינות הקוד
            if (!PasswordResetServiceDAL.ValidateResetCode(email, code))
            {
                throw new Exception("קוד האימות אינו תקף או שפג תוקפו");
            }

            // מציאת המשתמש
            var userInfo = PasswordResetServiceDAL.FindUserByEmail(email);
            if (userInfo == null)
            {
                throw new Exception("משתמש לא נמצא");
            }

            // הצפנת הסיסמה והעדכון
            string hashedPassword = HashPassword(newPassword);
            PasswordResetServiceDAL.UpdatePassword(userInfo, hashedPassword);
            PasswordResetServiceDAL.MarkResetCodeAsUsed(email, code);
        }

        private static string HashPassword(string password)
        {
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                var hashedBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(hashedBytes);
            }
        }

        //private static void SendResetEmail(string email, string resetCode)
        //{
        //    try
        //    {
        //        string subject = "קוד לאיפוס סיסמה";
        //        string body = $@"
        //<div style='direction:rtl; font-family:Arial;'>
        //    <h2>בקשה לאיפוס סיסמה</h2>
        //    <p>קוד האימות שלך הוא: <strong>{resetCode}</strong></p>
        //    <p>הקוד תקף למשך שעה אחת.</p>
        //    <p>אם לא ביקשת לאפס את הסיסמה, אנא התעלם מהודעה זו.</p>
        //</div>";

        //        using (var smtp = new SmtpClient())
        //        {
        //            // הגדרת אימות SSL
        //            smtp.EnableSsl = true;

        //            using (var mail = new MailMessage())
        //            {
        //                mail.From = new MailAddress("your-email@gmail.com", "Mobile Express");
        //                mail.To.Add(email);
        //                mail.Subject = subject;
        //                mail.Body = body;
        //                mail.IsBodyHtml = true;

        //                smtp.Send(mail);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        System.Diagnostics.Debug.WriteLine($"שגיאה בשליחת מייל: {ex.Message}");
        //        throw new Exception("אירעה שגיאה בשליחת המייל. אנא נסה שוב מאוחר יותר.");
        //    }
        //}
    }
}