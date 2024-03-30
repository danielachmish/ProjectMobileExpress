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
    public class ModelsController : ApiController
    {
        public void Post(Models Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה חדש
                Tmp.ModelId = -1;
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

        public void Put(int Id, Models Tmp)
        {
            // הגדרת מזהה לקוח לפי הקלט
            Tmp.ModelId = Id;
            // שמירת לקוח
            Tmp.Save();
        }

        // אחזור רשימת כל הלקוחות
        public List<Models> Get()
        {
            return Models.GetAll();
        }
        // אחזור לקוח לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Models.GetById(Id));

        }

        // מחיקת לקוח לפי מזהה
        public string Delete(int Id)
        {

            Models.DeleteById(Id);

            return $"Models deleted{Id}";
        }
    }
}
