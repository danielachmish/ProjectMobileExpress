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
    public class BidController : ApiController
    {
        public void Post(Bid Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה חדש
                Tmp.BidId = -1;
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
        // עדכון Bid קיים

        public void Put(int Id, Bid Tmp)
        {

            // הגדרת מזהה משתמש לפי הקלט
            Tmp.BidId = Id;
            // שמירת המשתמש
            Tmp.Save();
        }

        // אחזור רשימת כל המשתמשים
        public List<Bid> Get()
        {
            return Bid.GetAll();
        }
        // אחזור משתמש לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Bid.GetById(Id));

        }

        // מחיקת משתמש לפי מזהה
        public string Delete(int Id)
        {

            Bid.DeleteById(Id);

            return $"Bid deleted{Id}";
        }
    }


}

