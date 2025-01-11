using System;
using System.Collections.Generic;
using System.Diagnostics;
using DAL;

namespace BLL
{
    public class PageContent
    {
        public int Id { get; set; } // מזהה ייחודי
        public string SectionName { get; set; } // שם המקטע
        public string Content { get; set; } // תוכן המקטע
        public DateTime LastUpdated { get; set; } // תאריך עדכון אחרון
        public bool IsActive { get; set; } // האם המקטע פעיל

        // שמירת תוכן חדש
        public void SaveNewPageContent()
        {
            try
            {
                PageContentDAL.Save(this);
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"שגיאה בשמירת תוכן חדש: {ex.Message}");
                throw;
            }
        }

        // עדכון תוכן קיים
        public void UpdatePageContent()
        {
            try
            {
                PageContentDAL.Save(this);
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"שגיאה בעדכון תוכן: {ex.Message}");
                throw;
            }
        }

        // שמירה (חדש או עדכון)
        public void Save()
        {
            if (this.Id <= 0)
            {
                SaveNewPageContent();
            }
            else
            {
                UpdatePageContent();
            }
        }

        // אחזור כל התכנים
        public static List<PageContent> GetAll()
        {
            try
            {
                return PageContentDAL.GetAll();
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"שגיאה באחזור כל התכנים: {ex.Message}");
                throw;
            }
        }

        // אחזור תוכן לפי מזהה
        public static PageContent GetById(int id)
        {
            try
            {
                if (id <= 0)
                {
                    throw new Exception("Invalid ID provided.");
                }
                return PageContentDAL.GetById(id);
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"שגיאה באחזור תוכן לפי מזהה: {ex.Message}");
                throw;
            }
        }

        // מחיקת תוכן לפי מזהה
        public static int DeleteById(int id)
        {
            try
            {
                if (id <= 0)
                {
                    throw new Exception("Invalid ID provided.");
                }
                return PageContentDAL.DeleteById(id);
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"שגיאה במחיקת תוכן לפי מזהה: {ex.Message}");
                throw;
            }
        }
    }
}
