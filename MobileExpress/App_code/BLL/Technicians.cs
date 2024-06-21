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

        public void Save()
        {
            try
            {
                TechniciansDAL.Save(this);
            }
            catch (Exception ex)
            {
                // טיפול בשגיאות, לדוגמה: רישום ל-Log
                Console.WriteLine("Exception: " + ex.Message);
                throw; // זרוק את החריגה מחדש כדי שתוכל לראותה בשכבה עליונה יותר
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
