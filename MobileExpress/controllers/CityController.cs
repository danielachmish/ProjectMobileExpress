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
    public class CityController : ApiController
    {
        public void Post(City Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה חדש
                Tmp.CityId = -1;
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
        // עדכון עיר קיימת

        public void Put(int Id, City Tmp)
        {
            // הגדרת מזהה עיר לפי הקלט
            Tmp.CityId = Id;
            // שמירת העיר
            Tmp.Save();
        }

        // אחזור רשימת כל הערים
        public List<City> Get()
        {
            return City.GetAll();
        }
        // אחזור עיר לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(City.GetById(Id));

        }

        // מחיקת עיר לפי מזהה
        public string Delete(int Id)
        {

            City.DeleteById(Id);

            return $"City deleted{Id}";
        }
    }
}
