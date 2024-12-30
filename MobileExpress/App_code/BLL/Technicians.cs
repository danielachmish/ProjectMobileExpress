using DAL;
using Services;
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
   

        public static Technicians CreateFromGoogle(string idToken, string email, string fullName)
        {
            var technician = new Technicians
            {
                TecNum = "",
                FulName = fullName,
                Phone = "",
                Address = "",
                Pass = EncryptionUtils.HashPassword(Guid.NewGuid().ToString()), // השתמש בפונקציית ההצפנה הקיימת שלך
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
        public void SetPassword(string password)
        {
            Pass = EncryptionUtils.HashPassword(password);
        }

        public bool VerifyPassword(string inputPassword)
        {
            return EncryptionUtils.VerifyPassword(inputPassword, Pass);
        }

        public static int GetTotalTechnicians()
        {
            try
            {
                return TechniciansDAL.GetTotalTechnicians();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.Message);
                throw;
            }
        }
    }

    
}
