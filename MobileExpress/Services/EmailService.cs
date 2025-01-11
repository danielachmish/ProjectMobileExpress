using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

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

    public async Task SendResetCodeEmail(string toEmail, string resetCode)
    {
        try
        {
            var client = new SendGridClient(_apiKey);
            var from = new EmailAddress(_fromEmail, _fromName);
            var to = new EmailAddress(toEmail);
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

            var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
            var response = await client.SendEmailAsync(msg);

          
            System.Diagnostics.Debug.WriteLine("SendGrid Response Status: " + response.StatusCode);
            string responseBody = await response.Body.ReadAsStringAsync();
            System.Diagnostics.Debug.WriteLine("SendGrid Response Body: " + responseBody);


            if (response.StatusCode != System.Net.HttpStatusCode.Accepted &&
                response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                throw new Exception("שגיאה בשליחת המייל");
            }
        }
        catch (Exception ex)
        {
            // רישום השגיאה
            System.Diagnostics.Debug.WriteLine($"שגיאה בשליחת מייל: {ex.Message}");
            throw new Exception("אירעה שגיאה בשליחת המייל. אנא נסה שוב מאוחר יותר.");
        }

    }


    //public static void Send(string toEmail, string subject, string body)
    //{
    //    // קריאת הפרטים מ-Web.config
    //    string fromEmail = ConfigurationManager.AppSettings["EmailFrom"];
    //    string fromPassword = ConfigurationManager.AppSettings["EmailPassword"];
    //    string smtpHost = ConfigurationManager.AppSettings["SmtpHost"];
    //    int smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"]);

    //    // הגדרת SMTP
    //    SmtpClient smtpClient = new SmtpClient(smtpHost, smtpPort)
    //    {
    //        Credentials = new NetworkCredential(fromEmail, fromPassword),
    //        EnableSsl = true
    //    };

    //    // יצירת הודעה
    //    MailMessage mailMessage = new MailMessage(fromEmail, toEmail, subject, body);

    //    // שליחת ההודעה
    //    smtpClient.Send(mailMessage);
    //}
    //public  async Task SendEmail(string toEmail, string subject, string body)
    //{
    //    try
    //    {
    //        var client = new SendGridClient(_apiKey); // השתמש ב-API key הקיים
    //        var from = new EmailAddress(_fromEmail, _fromName);
    //        var to = new EmailAddress(toEmail);

    //        // צור את ההודעה
    //        var msg = MailHelper.CreateSingleEmail(from, to, subject, body, body); // אותו תוכן גם כ-Plain Text וגם כ-HTML
    //        var response = await client.SendEmailAsync(msg);

    //        // בדיקת תגובת SendGrid
    //        System.Diagnostics.Debug.WriteLine("SendGrid Response Status: " + response.StatusCode);
    //        if (response.StatusCode != HttpStatusCode.Accepted && response.StatusCode != HttpStatusCode.OK)
    //        {
    //            throw new Exception($"שגיאה בשליחת מייל: {response.StatusCode}");
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        // טיפול בשגיאה
    //        System.Diagnostics.Debug.WriteLine($"שגיאה בשליחת מייל: {ex.Message}");
    //        throw new Exception("אירעה שגיאה בשליחת המייל. אנא נסה שוב מאוחר יותר.");
    //    }
    //}

}

