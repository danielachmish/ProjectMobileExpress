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
                Tmp.ReadId = -1;
                // שמירה
                Tmp.SaveNewRead();
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
            Tmp.ReadId = Id;
            // שמירת לקוח
            Tmp.SaveNewRead();
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

        [HttpPost]
        [Route("api/Readability/UpdateStatus")]
        public IHttpActionResult UpdateStatus([FromBody] UpdateStatusModel model)
        {
            try
            {
                var readability = Readability.GetById(model.ReadId);
                if (readability == null)
                {
                    return NotFound();
                }
                readability.Status = model.Status;
                readability.UpdateReadability();
                return Ok();
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        public class UpdateStatusModel
        {
            public int ReadId { get; set; }
            public bool Status { get; set; }
        }

        public string GetREAD(int id)
        {
            try
            {
                var readability = Readability.GetById(id);
                if (readability == null)
                    return null;

                var result = new
                {
                    readability.ReadId,
                    readability.CusId,
                    readability.FullName,
                    readability.Phone,
                    readability.Desc,
                    readability.ModelId,
                    readability.SerProdId,
                    readability.DateRead,
                    readability.Status
                };

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in Get(id): {ex.Message}");
                throw;
            }
        }
    }
}
