using BLL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MobileExpress.controllers
{
    public class CategoriesController : ApiController
    {
        public void Post(Categories Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה חדש
                Tmp.CatId = -1;
                // שמירה
                Tmp.Save();
            }
            else
            {
                // טיפול במקרה בו `Tmp` הוא `null`
                // ניתן לזרוק חריגה, לרשום שגיאה או לטפל בזה לפי הלוגיקה של היישום שלך
                // לדוגמה: throw new ArgumentNullException("Tmp", "אובייקט Tmp הוא null");
            }
        }
        // עדכון קטגורייה קיימת

        public void Put(int Id, Categories Tmp)
        {
            // הגדרת מזהה קטגוריה לפי הקלט
            Tmp.CatId = Id;
            // שמירת הקטגוריה
            Tmp.Save();
        }

        // אחזור רשימת כל הקטגוריות
        public List<Categories> Get()
        {
            return Categories.GetAll();
        }
        // אחזור קטגוריה לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Categories.GetById(Id));

        }

        // מחיקת קטגורייה לפי מזהה
        public string Delete(int Id)
        {

            Categories.DeleteById(Id);

            return $"Categories deleted{Id}";
        }
    }        
}
