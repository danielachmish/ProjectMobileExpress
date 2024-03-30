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
    public class ReadabilityController : ApiController
    {
        public void Post(Readability Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה חדש
                Tmp.ReadiId = -1;
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
        // עדכון לקוח קיים

        public void Put(int Id, Readability Tmp)
        {
            // הגדרת מזהה לקוח לפי הקלט
            Tmp.ReadiId = Id;
            // שמירת לקוח
            Tmp.Save();
        }

        // אחזור רשימת כל הלקוחות
        public List<Readability> Get()
        {
            return Readability.GetAll();
        }
        // אחזור לקוח לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Readability.GetById(Id));

        }

        // מחיקת לקוח לפי מזהה
        public string Delete(int Id)
        {

            Readability.DeleteById(Id);

            return $"Readability deleted{Id}";
        }
    }
}
