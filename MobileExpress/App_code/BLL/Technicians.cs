using DAL;
using System;
using System.Collections.Generic;

namespace BLL
{
    public class Technicians
    {
        public int TecId { get; set; }
        public string TecNum { get; set; }
        public string FulName { get; set; }
        public string Phone { get; set; }
        public string Address { get; set; }
        public string Pass { get; set; }
        public string UserName { get; set; }
        public string Type { get; set; }
        public string History { get; set; }
        public string Nots { get; set; }
        public string Email { get; set; }
        public bool Status { get; set; }
        public int SerProdId { get; set; }
        public DateTime DateAddition { get; set; }
        public bool ShowLocation { get; set; }

        // פונקציה לשמירת טכנאי חדש
        public void SaveNewTechnician()
        {
            try
            {
                TechniciansDAL.SaveNewTechnician(this); // העברת האובייקט הנוכחי ל-DAL
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.Message);
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

        public static Technicians CreateFromGoogle(string idToken, string email, string fullName)
        {
            var technician = new Technicians
            {
                TecNum = "",
                FulName = fullName,
                Phone = "",
                Address = "",
                Pass = HashPassword(Guid.NewGuid().ToString()), // השתמש בפונקציית ההצפנה הקיימת שלך
                UserName = email.Split('@')[0],
                Type = "",
                Email = email,
                DateAddition = DateTime.Now,

            };

            return technician;
        }

        public static bool IsEmailExists(string email)
        {
            return TechniciansDAL.IsEmailExists(email);
        }

        // פונקציה לעדכון טכנאי קיים
        public void UpdateTechnician()
        {
            try
            {
                TechniciansDAL.UpdateTechnician(this); // העברת האובייקט הנוכחי ל-DAL
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.Message);
                throw;
            }
        }

        // פונקציה כללית לשמירת טכנאי חדש או קיים
        public void Save()
        {
            if (this.TecId <=0)
            {
                SaveNewTechnician();
            }
            else
            {
                UpdateTechnician();
            }
        }




        // אחזור כל המשתמשים
        public static List<Technicians> GetAll()
        {
            return TechniciansDAL.GetAll();
        }

        // אחזור לפי זיהוי
        public static Technicians GetById(int Id)
        {
            return TechniciansDAL.GetById(Id);
        }

        // מחיקה לפי זיהוי
        public static int DeleteById(int Id)
        {
            return TechniciansDAL.DeleteById(Id);
        }
    }
    
}
