using BLL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace MobileExpress.controllers
{
	public class PageContentController : ApiController
    {
        public void Post(PageContent Tmp)
        {
            // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
            if (Tmp != null)
            {
                // הגדרת מזהה משתמש חדש
                Tmp.Id = 0;
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

        public void Put(int Id, PageContent Tmp)
        {
            // הגדרת מזהה משתמש לפי הקלט
            Tmp.Id = Id;
            // שמירת המשתמש
            Tmp.Save();
        }

        // אחזור רשימת כל המשתמשים
        public List<PageContent> Get()
        {
            return PageContent.GetAll();
        }

        // אחזור משתמש לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(PageContent.GetById(Id));

        }

        // מחיקת משתמש לפי מזהה
        public string Delete(int Id)
        {

            PageContent.DeleteById(Id);

            return $"PageContent deleted{Id}";
        }
    }
}