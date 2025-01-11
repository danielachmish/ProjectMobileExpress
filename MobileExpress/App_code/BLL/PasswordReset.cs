using DAL;
using Org.BouncyCastle.Crypto.Generators;
using SendGrid;
using Services;
using System;
using System.Configuration;
using System.Text;
using System.Threading.Tasks;

namespace BLL
{
	public class PasswordResetService
	{
		private static readonly EmailService _emailService = new EmailService();

		public static async Task SendResetCodeEmail(string email)
		{
			// בדיקה שהמשתמש קיים
			var user = PasswordResetServiceDAL.FindUserByEmail(email);
			if (user == null)
			{
				throw new Exception("כתובת המייל לא נמצאה במערכת");
			}

			// יצירת קוד אקראי
			string resetCode = GenerateResetCode();
			DateTime expiryDate = DateTime.Now.AddHours(1);

			// שמירת הקוד בדאטהבייס
			PasswordResetServiceDAL.SaveResetCode(email, resetCode, expiryDate);

			// שליחת המייל
			bool emailSent = await _emailService.SendResetCodeEmail(email, resetCode);
			if (!emailSent)
			{
				throw new Exception("שגיאה בשליחת המייל");
			}

			// ניקוי קודים ישנים
			PasswordResetServiceDAL.CleanupOldCodes();
		}

		private static string GenerateResetCode()
		{
			// יצירת קוד אקראי בן 6 ספרות
			Random random = new Random();
			return random.Next(100000, 999999).ToString();
		}
		public static async Task ResetPassword(string email, string code, string newPassword)
		{
			try
			{
				// בדיקת תקינות הקוד
				bool isValidCode = PasswordResetServiceDAL.ValidateResetCode(email, code);
				if (!isValidCode)
				{
					throw new Exception("קוד האימות אינו תקין או שפג תוקפו");
				}

				// מציאת המשתמש
				var user = PasswordResetServiceDAL.FindUserByEmail(email);
				if (user == null)
				{
					throw new Exception("משתמש לא נמצא");
				}

				// עדכון הסיסמה
				Console.WriteLine($"[LOG] New password (plain): {newPassword}");
				string hashedPassword = HashPassword(newPassword);
				Console.WriteLine($"[LOG] Hashed password: {hashedPassword}");
				PasswordResetServiceDAL.UpdatePassword(user, hashedPassword);
				Console.WriteLine($"[LOG] Password updated for user: {user}");

				// סימון הקוד כמשומש
				PasswordResetServiceDAL.MarkResetCodeAsUsed(email, code);
				Console.WriteLine($"[LOG] Reset code marked as used for email: {email}, code: {code}");
			}
			catch (Exception ex)
			{
				throw new Exception($"שגיאה באיפוס הסיסמה: {ex.Message}", ex);
			}
		}

		//private static string HashPassword(string password)
		//{
		//    using (var sha256 = System.Security.Cryptography.SHA256.Create())
		//    {
		//        // Convert the input string to a byte array and compute the hash.
		//        byte[] bytes = System.Text.Encoding.UTF8.GetBytes(password);
		//        byte[] hash = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));

		//        // Convert byte array to a string
		//        StringBuilder builder = new StringBuilder();
		//        for (int i = 0; i < hash.Length; i++)
		//        {
		//            builder.Append(hash[i].ToString("x2"));
		//        }
		//        return Convert.ToBase64String(hash);
		//    }
		//}
		private static string HashPassword(string password)
		{

			return EncryptionUtils.HashPassword(password);
		}

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

			if (string.IsNullOrEmpty(_apiKey))
				throw new ConfigurationErrorsException("SendGrid API key חסר");
			if (string.IsNullOrEmpty(_fromEmail))
				throw new ConfigurationErrorsException("כתובת אימייל השולח חסרה");
		}

		public async Task<bool> SendResetCodeEmail(string toEmail, string resetCode)
		{
			try
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

				var msg = SendGrid.Helpers.Mail.MailHelper.CreateSingleEmail(
					from, to, subject, plainTextContent, htmlContent);

				var response = await client.SendEmailAsync(msg);

				// בדיקת תגובת השרת
				if (response.StatusCode == System.Net.HttpStatusCode.Forbidden)
				{
					var body = await response.Body.ReadAsStringAsync();
					System.Diagnostics.Debug.WriteLine($"SendGrid Forbidden Error: {body}");
					throw new Exception("שגיאת הרשאה בשליחת המייל - יש לוודא שכתובת השולח מאומתת במערכת SendGrid");
				}
				else if (response.StatusCode >= System.Net.HttpStatusCode.BadRequest)
				{
					var body = await response.Body.ReadAsStringAsync();
					System.Diagnostics.Debug.WriteLine($"SendGrid Error: {body}");
					throw new Exception("שגיאה בשליחת המייל");
				}

				return true;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Email sending error: {ex.Message}");
				throw;  // נזרוק את השגיאה המקורית כדי לשמור על פרטי השגיאה
			}
		}
	}
}
