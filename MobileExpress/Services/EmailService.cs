using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Configuration;
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
}