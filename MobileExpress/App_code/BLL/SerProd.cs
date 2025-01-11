using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class SerProd
	{
		public int SerProdId { get; set; }
		public string Desc { get; set; }
		public float Price { get; set; }
		public string NameImage { get; set; }
		public bool Status { get; set; }
		public string Nots { get; set; }

        public void SaveNewSerProd()
        {
            try
            {
                SerProdDAL.Save(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת מנהל חדש: {ex.Message}");
                throw;
            }
        }

        public void UpdateSerProd()
        {
            try
            {
                SerProdDAL.UpdateSerProd(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון מנהל: {ex.Message}");
                throw;
            }
        }

        public void Save()
        {
            if (this.SerProdId <= 0)
            {
                SaveNewSerProd();
            }
            else
            {
                UpdateSerProd();
            }
        }
        // אחזור כל המשתמשים
        public static List<SerProd> GetAll()
		{
			return SerProdDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static SerProd GetById(int Id)
		{
			return SerProdDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return SerProdDAL.DeleteById(Id);
		}
	}
}