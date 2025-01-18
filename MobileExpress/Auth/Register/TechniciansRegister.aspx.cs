using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Auth.Register
{
	public partial class TechniciansRegister : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}
		protected void SaveTechnicians(object sender, EventArgs e)
		{
			try
			{
				HiddenField hfTecId = (HiddenField)Page.FindControl("hfTecId");
				string FulName = txtFulName.Text.Trim();
				string TecNum = txtTecNum.Text.Trim();
				string Phone = txtPhone.Text.Trim();
				string Address = txtAddress.Text.Trim();
				string Pass = txtPass.Text.Trim();
				string UserName = txtUserName.Text.Trim();
				string Type = txtType.Text.Trim();
				string Email = txtEmail.Text.Trim();

				// בדיקה אם האימייל כבר קיים במערכת עבור טכנאי חדש
				int tecId = hfTecId != null && !string.IsNullOrEmpty(hfTecId.Value) &&
						   int.TryParse(hfTecId.Value, out int parsedId) ? parsedId : -1;

				if (tecId <= 0 && Technicians.IsEmailExists(Email))
				{
					ScriptManager.RegisterStartupScript(this, GetType(), "redirect", @"
                alert('משתמש עם מייל זה כבר קיים במערכת. אנו מעבירים אותך להתחברות.');
                window.location = '/Auth/Login/TechniciansLogin.aspx';",
						true);
					return;
				}

				ValidateFields(FulName, TecNum, Phone, Address, Pass, UserName, Type, Email);

				var technicians = new Technicians
				{
					TecId = tecId,
					TecNum = TecNum,
					FulName = FulName,
					Phone = Phone,
					Address = Address,
					Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
					UserName = UserName,
					Type = Type,
					Email = Email,
					DateAddition = DateTime.Now,
					Status = true
				};

				if (technicians.TecId <= 0)
				{
					technicians.Save();

					ScriptManager.RegisterStartupScript(this, GetType(), "successScript", @"
                alert('הנתונים נשמרו בהצלחה!');
                window.location = '../../TechniciansFolder/MainTechnicians.aspx';",
						true);
				}
				else
				{
					technicians.UpdateTechnician();
					ScriptManager.RegisterStartupScript(this, GetType(), "updateScript", @"
                alert('הנתונים עודכנו בהצלחה!'); 
                window.location.href = '../../TechniciansFolder/MainTechnicians.aspx';",
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
			string[] fieldNames = { "FullName", "TechNumber", "Phone", "Address", "Password", "Username", "Type", "Email" };

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
