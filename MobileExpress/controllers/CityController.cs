using BLL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace MobileExpress.controllers
{
    public class CityController : ApiController
    {
        [HttpPost]
        [Route("api/city/import")]
        public IHttpActionResult ImportCities(string filePath)
        {
            try
            {
                var result = ExcelImporter.ImportCitiesFromExcel(filePath);

                if (result.IsSuccess)
                {
                    return Ok(new
                    {
                        message = "Cities imported successfully!",
                        successCount = result.SuccessCount
                    });
                }

                return Ok(new
                {
                    message = "Import completed with errors",
                    successCount = result.SuccessCount,
                    failureCount = result.FailureCount,
                    errors = result.Errors
                });
            }
            catch (Exception ex)
            {
                return InternalServerError(new Exception($"Error importing cities: {ex.Message}"));
            }
        }


        [HttpPost]
        [Route("api/city/upload")]
        public IHttpActionResult UploadFile()
        {
            var httpRequest = HttpContext.Current.Request;
            if (httpRequest.Files.Count > 0)
            {
                var postedFile = httpRequest.Files[0];
                string filePath = @"C:\Users\User\OneDrive\שולחן העבודה\ProjectMobileExpress\MobileExpress\Uploads\" + postedFile.FileName;

                postedFile.SaveAs(filePath);

                // העברת הנתיב לפונקציה `ImportCities`
                return ImportCities(filePath);
            }
            return BadRequest("No file uploaded.");
        }



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
