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
    public class ManufacturersController : ApiController
    {
        public void Post(Manufacturers Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה חדש
                Tmp.ManuId = -1;
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

        public void Put(int Id, Manufacturers Tmp)
        {
            // הגדרת מזהה לקוח לפי הקלט
            Tmp.ManuId = Id;
            // שמירת לקוח
            Tmp.Save();
        }

        // אחזור רשימת כל הלקוחות
        public List<Manufacturers> Get()
        {
            return Manufacturers.GetAll();
        }
        // אחזור לקוח לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Manufacturers.GetById(Id));

        }

        // מחיקת לקוח לפי מזהה
        public string Delete(int Id)
        {

            Manufacturers.DeleteById(Id);

            return $"Manufacturers deleted{Id}";
        }
    }
}
