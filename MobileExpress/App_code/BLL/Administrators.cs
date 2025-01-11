using DAL;
using Services;
using System;
using System.Collections.Generic;


namespace BLL
{
	public class Administrators
	{

		public int AdminId { get; set; }
		public string FullName { get; set; }
		public string Phone { get; set; }
		public string Addres { get; set; }
		public string Uname { get; set; }
		public string Pass { get; set; }
		public DateTime DateAdd { get; set; }
		public bool Status { get; set; }
		public string Email { get; set; }

        // בדיקה אם המשתמש קיים - עדכון, אחרת הוספת משתמש חדש
        public void SaveNewAdministrators()
        {
            try
            {
                AdministratorsDAL.Save(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת מנהל חדש: {ex.Message}");
                throw;
            }
        }
        public static string HashPassword(string password)
        {
            System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
            var hashedPassword = Convert.ToBase64String(
                System.Security.Cryptography.SHA256.Create()
                .ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
            System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
            return hashedPassword;
        }

        public void UpdateAdministrators()
        {
            try
            {
                AdministratorsDAL.UpdateAdministrators(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון מנהל: {ex.Message}");
                throw;
            }
        }

        public void Save()
        {
            if (this.AdminId <= 0)
            {
                SaveNewAdministrators();
            }
            else
            {
                UpdateAdministrators();
            }
        }

        // אחזור כל המשתמשים
        public static List<Administrators> GetAll()
		{
			return AdministratorsDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Administrators GetById(int Id)
		{
			return AdministratorsDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return AdministratorsDAL.DeleteById(Id);
		}

        public void SetPassword(string password)
        {
            Pass = EncryptionUtils.HashPassword(password);
        }

        public bool VerifyPassword(string inputPassword)
        {
            return EncryptionUtils.VerifyPassword(inputPassword, Pass);
        }
    }


}