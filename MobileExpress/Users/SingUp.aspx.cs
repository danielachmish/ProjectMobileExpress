using System;
using System.Web;
using System.Web.UI;
using System.Linq;        // הוספת זה
using System.Data.Linq;   // והוספת זה
using System.Web.UI.WebControls;
using BLL;

namespace MobileExpress.Users
{
	public partial class SingUp : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}
		protected void SaveCustomers(object sender, EventArgs e)
		{
			try
			{
				HiddenField hfCusId = (HiddenField)Page.FindControl("hfCusId");
				string FullName = txtFullName.Text.Trim();
				//string TecNum = txtTecNum.Text.Trim();
				string Phone = txtPhone.Text.Trim();
				string Addres = txtAddres.Text.Trim();
				string Pass = txtPass.Text.Trim();
				string Email = txtEmail.Text.Trim();
				//string Type = txtType.Text.Trim();
				//string Email = txtEmail.Text.Trim();

				// בדיקה אם האימייל כבר קיים במערכת עבור טכנאי חדש
				int cusId = hfCusId != null && !string.IsNullOrEmpty(hfCusId.Value) &&
						   int.TryParse(hfCusId.Value, out int parsedId) ? parsedId : -1;

				if (cusId <= 0 && Customers.IsEmailExists(Email))
				{
					ScriptManager.RegisterStartupScript(this, GetType(), "redirect", @"
                alert('משתמש עם מייל זה כבר קיים במערכת. אנו מעבירים אותך להתחברות.');
                window.location = 'SingIn.aspx';",
						true);
					return;
				}

				ValidateFields(FullName, Phone, Addres, Pass, Email);

				var customers = new Customers
				{
					CusId = cusId,
					//TecNum = TecNum,
					FullName = FullName,
					Phone = Phone,
					Addres = Addres,
					Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
					Email = Email,
					//Type = Type,
					//Email = Email,
					DateAdd = DateTime.Now,
					Status = true
				};

				if (customers.CusId <= 0)
				{
					customers.Save();

					ScriptManager.RegisterStartupScript(this, GetType(), "successScript", @"
                alert('הנתונים נשמרו בהצלחה!');
                window.location = 'Main.aspx';",
						true);
				}
				else
				{
					customers.UpdateCustomers();
					ScriptManager.RegisterStartupScript(this, GetType(), "updateScript", @"
                alert('הנתונים עודכנו בהצלחה!'); 
                window.location.href = 'Main.aspx';",
						true);
				}
			}
			catch (Exception ex)
			{
				ScriptManager.RegisterStartupScript(this, GetType(), "errorScript",
					$"alert('שגיאה בשמירת טכנאי: {ex.Message}');", true);
			}
		}
		private void ValidateFields(params string[] fields)
		{
			string[] fieldNames = { "FullName", "Phone", "Addres", "Pass", "Email" };

			for (int i = 0; i < fields.Length; i++)
			{
				if (string.IsNullOrEmpty(fields[i]))
				{
					throw new Exception($"Field {fieldNames[i]} is missing or invalid");
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

		

	}
}