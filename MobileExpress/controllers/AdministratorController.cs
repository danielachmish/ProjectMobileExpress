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
    public class AdministratorsController : ApiController
    {   //יצירת משתמש חדש
        public void Post(Administrators Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה משתמש חדש
                Tmp.AdminId = -1;
                // שמירת המשתמש
                Tmp.Save();
            }
            else
            {
                // טיפול במקרה בו `Tmp` הוא `null`
                // ניתן לזרוק חריגה, לרשום שגיאה או לטפל בזה לפי הלוגיקה של היישום שלך
                // לדוגמה: throw new ArgumentNullException("Tmp", "אובייקט Tmp הוא null");
            }
        }
        // עדכון משתמש קיים
 
        public void Put( int Id, Administrators Tmp)
        {
            // הגדרת מזהה משתמש לפי הקלט
            Tmp.AdminId = Id;
            // שמירת המשתמש
            Tmp.Save();
        }

        // אחזור רשימת כל המשתמשים
        public List<Administrators> Get()
        {
            return Administrators.GetAll();
        }

        // אחזור משתמש לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Administrators.GetById(Id));

        }

        // מחיקת משתמש לפי מזהה
        public string Delete(int Id)
        {

            Administrators.DeleteById(Id);

            return $"Administrator deleted{Id}";
        }
    }
}
