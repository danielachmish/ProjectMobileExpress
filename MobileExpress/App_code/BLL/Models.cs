using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BLL
{
	public class Models
	{
		public int ModelId { get; set; }
		public string ModelName { get; set; }
		public int manuId { get; set; }
		public string Image { get; set; }
		public DateTime Date { get; set; }

        public void SaveNewModels()
        {
            try
            {
                ModelsDAL.Save(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת מנהל חדש: {ex.Message}");
                throw;
            }
        }

        public void UpdateModels()
        {
            try
            {
                ModelsDAL.UpdateModels(this);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון מנהל: {ex.Message}");
                throw;
            }
        }

        public void Save()
        {
            if (this.ModelId <= 0)
            {
                SaveNewModels();
            }
            else
            {
                UpdateModels();
            }
        }
        // אחזור כל המשתמשים
        public static List<Models> GetAll()
		{
			return ModelsDAL.GetAll();
		}
		// אחזור לפי זיהוי
		public static Models GetById(int Id)
		{
			return ModelsDAL.GetById(Id);
		}
		// מחיקה לפי זיהוי
		public static int DeleteById(int Id)
		{
			return ModelsDAL.DeleteById(Id);
		}
	}	
}