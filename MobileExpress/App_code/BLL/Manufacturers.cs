using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
    public class Manufacturers
    {
        public int ManuId { get; set; }
        public string ManuName { get; set; }
        public string Desc { get; set; }
        public string NameImage { get; set; }
        public DateTime Date { get; set; }

        public void SaveNewManufacturers()
        {
            ManufacturersDAL.Save(this);
        }
        // פונקציה לעדכון מנהל קיים
        public void UpdateManufacturers()
        {
            try
            {
                ManufacturersDAL.UpdateManufacturers(this); // העברת האובייקט הנוכחי ל-DAL
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
            if (this.ManuId == -1||this.ManuId == 0)
            {
                SaveNewManufacturers();
            }
            else
            {
                UpdateManufacturers();
            }
        }

        // אחזור כל המשתמשים
        public static List<Manufacturers> GetAll()
        {
            return ManufacturersDAL.GetAll();
        }

        // אחזור לפי זיהוי
        public static Manufacturers GetById(int Id)
        {
            return ManufacturersDAL.GetById(Id);
        }

        // מחיקה לפי זיהוי
        public static int DeleteById(int Id)
        {
            return ManufacturersDAL.DeleteById(Id);
        }
    }
}
