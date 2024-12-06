using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class Customers
	{
		public int CusId { get; set; }
		public string FullName { get; set; }
		public string Phone { get; set; }
		public string Addres { get; set; }
		public string Email { get; set; }
		public string Pass { get; set; }
		public DateTime DateAdd { get; set; }
		public bool Status { get; set; }
		public string History { get; set; }
		public string Nots { get; set; }
		public int CityId { get; set; }
		//public string Email { get; set; }
		public string GoogleId { get; set; }


		public void SaveNewCustomers()
		{
			try
			{
				CustomersDAL.SaveNewCustomers(this); // העברת האובייקט הנוכחי ל-DAL
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception: " + ex.Message);
				throw;
			}
		}

		// פונקציה לעדכון לקוח קיים
		public void UpdateCustomers()
		{
			try
			{
				CustomersDAL.UpdateCustomers(this); // העברת האובייקט הנוכחי ל-DAL
			}
			catch (Exception ex)
			{
				Console.WriteLine("Exception: " + ex.Message);
				throw;
			}
		}

		// פונקציה כללית לשמירת לקוח חדש או קיים
		public void Save()
		{
			if (this.CusId <=0)
			{
				SaveNewCustomers();
			}
			else
			{
				UpdateCustomers();
			}
		}

		// אחזור כל המשתמשים
		public static List<Customers> GetAll()
		{
			return CustomersDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Customers GetById(int Id)
		{
			return CustomersDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return CustomersDAL.DeleteById(Id);
		}
		public static Customers GetByEmail(string email)
		{
			return CustomersDAL.GetByEmail(email);
		}
		//public static string HashPassword(string password)
		//{
		//	System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
		//	var hashedPassword = Convert.ToBase64String(
		//		System.Security.Cryptography.SHA256.Create()
		//		.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
		//	System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
		//	return hashedPassword;
		//}
		public static string HashPassword(string password)
		{
			using (var sha256 = System.Security.Cryptography.SHA256.Create())
			{
				var hashedBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
				var hashedPassword = Convert.ToBase64String(hashedBytes);
				System.Diagnostics.Debug.WriteLine($"הצפנת סיסמה: {hashedPassword}");
				return hashedPassword;
			}
		}

		public static bool VerifyPassword(string inputPassword, string storedHash)
		{
			using (var sha256 = System.Security.Cryptography.SHA256.Create())
			{
				string hashedInput = HashPassword(inputPassword);
				System.Diagnostics.Debug.WriteLine($"Input password hash: {hashedInput}");
				System.Diagnostics.Debug.WriteLine($"Stored password hash: {storedHash}");
				return hashedInput.Equals(storedHash, StringComparison.Ordinal);
			}
		}
		public static bool IsEmailExists(string Email)
		{
			return  CustomersDAL.IsEmailExists(Email);
		}
		public static Customers CreateFromGoogle(string idToken, string email, string fullName)
		{
			return new Customers
			{
				FullName = fullName,
				Email = email,
				Pass = HashPassword(Guid.NewGuid().ToString()),
				DateAdd = DateTime.Now,
				Status = true,
				GoogleId = idToken
			};
		}
	}
}