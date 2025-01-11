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
    public class RatingController : ApiController
    {
        public void Post(Rating Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה חדש
                Tmp.RatingId = -1;
                // שמירה
                Tmp.SaveNewRating();
            }
            else
            {
                // טיפול במקרה בו `Tmp` הוא `null`
                // ניתן לזרוק חריגה, לרשום שגיאה או לטפל בזה לפי הלוגיקה של היישום שלך
                // לדוגמה: throw new ArgumentNullException("Tmp", "אובייקט Tmp הוא null");
            }
        }
        // עדכון לקוח קיים

        public void Put(int Id, Rating Tmp)
        {
            // הגדרת מזהה לקוח לפי הקלט
            Tmp.RatingId = Id;
            // שמירת לקוח
            Tmp.SaveNewRating();
        }

        // אחזור רשימת כל הלקוחות
        public List<Rating> Get()
        {
            return Rating.GetAll();
        }
        // אחזור לקוח לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Rating.GetById(Id));

        }

        // מחיקת לקוח לפי מזהה
        public string Delete(int Id)
        {

            Rating.DeleteById(Id);

            return $"Rating deleted{Id}";
        }
    }
}
