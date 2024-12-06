using BLL;
using Google.Apis.Auth;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace MobileExpress.controllers
{
    public class CustomersController : ApiController
    {
		[HttpPost]
		[Route("api/customers/google-signup")]
		public async Task<IHttpActionResult> GoogleSignUp([FromBody] GooglesignUpRequest request)
		{
			try
			{
				Debug.WriteLine("התחלת תהליך הרשמה עם גוגל");
				Debug.WriteLine($"Token received: {request?.IdToken?.Substring(0, 20)}...");

				if (string.IsNullOrEmpty(request?.IdToken))
				{
					Debug.WriteLine("לא התקבל טוקן");
					return BadRequest("לא התקבל טוקן זיהוי");
				}

				var validationSettings = new GoogleJsonWebSignature.ValidationSettings
				{
					Audience = new[] { "AIzaSyAKp-Y7v2FtSV7yOS8ACVQnmag6Z5nAc4U.apps.googleusercontent.com" }
				};

				Debug.WriteLine("מתחיל אימות טוקן מול גוגל");
				var payload = await GoogleJsonWebSignature.ValidateAsync(request.IdToken, validationSettings);
				Debug.WriteLine($"טוקן אומת בהצלחה. אימייל: {payload.Email}");

				// בדיקה אם המשתמש כבר קיים
				var existingCustomer = Customers.GetByEmail(payload.Email);
				if (existingCustomer != null)
				{
					Debug.WriteLine($"משתמש כבר קיים במערכת: {payload.Email}");
					return BadRequest("משתמש זה כבר קיים במערכת. אנא התחבר.");
				}

				// יצירת משתמש חדש
				var newCustomer = new Customers
				{
					CusId = 0,
					FullName = payload.Name,
					//Email = payload.Email,
					Phone = "",
					Addres = "",
					Email = payload.Email,
					Pass = "",  // אין צורך בסיסמה עבור משתמש גוגל
					DateAdd = DateTime.Now,
					Status = true,
					//GoogleId = payload.Subject,
					CityId = 1  // ברירת מחדל
				};

				newCustomer.Save();
				Debug.WriteLine($"משתמש חדש נרשם בהצלחה: {newCustomer.Email}");
				return Ok(new { success = true, customer = newCustomer, message = "ההרשמה בוצעה בהצלחה!" });
			}
			catch (Exception ex)
			{
				Debug.WriteLine($"שגיאה בתהליך ההרשמה: {ex.Message}");
				Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				return InternalServerError(new Exception("שגיאה בתהליך ההרשמה עם גוגל"));
			}
		}

		public class GooglesignUpRequest
		{
			public string IdToken { get; set; }
		}


		[HttpPost]
		public IHttpActionResult Post([FromBody] Customers customer)
		{
			Debug.WriteLine("נכנס לפונקציית Post");

			if (customer == null)
			{
				Debug.WriteLine("שגיאה: אובייקט הלקוח הוא null");
				return BadRequest("אובייקט הלקוח הוא null");
			}

			Debug.WriteLine($"התקבל לקוח: {customer.FullName}, טלפון: {customer.Phone}");

			customer.CusId = 0; // שונה מ -1 ל 0
			Debug.WriteLine($"הוגדר CusId = {customer.CusId}");

			try
			{
				customer.Save();
				Debug.WriteLine($"הלקוח נשמר בהצלחה. CusId חדש: {customer.CusId}");
			}
			catch (Exception ex)
			{
				Debug.WriteLine($"שגיאה בשמירת הלקוח: {ex.Message}");
				return InternalServerError(ex);
			}

			Debug.WriteLine("מסיים פונקציית Post בהצלחה");
			return CreatedAtRoute("DefaultApi", new { id = customer.CusId }, customer);
		}

		[HttpPut]
		public IHttpActionResult Put(int id, [FromBody] Customers customer)
		{
			if (customer == null)
			{
				return BadRequest("אובייקט הלקוח הוא null");
			}
			var existingCustomer = Customers.GetById(id);
			if (existingCustomer == null)
			{
				return NotFound();
			}
			customer.CusId = id;
			customer.Save();
			return StatusCode(HttpStatusCode.NoContent);
		}



		//public void Post(Customers Tmp)
		// {
		//     // בדוק ש-`Tmp` אינו `null` לפני גישה לפרופרטים שלו
		//     if (Tmp != null)
		//     {
		//         // הגדרת מזהה חדש
		//         Tmp.CusId = -1;
		//         // שמירה
		//         Tmp.Save();
		//     }
		//     else
		//     {
		//         // טיפול במקרה בו `Tmp` הוא `null`
		//         // ניתן לזרוק חריגה, לרשום שגיאה או לטפל בזה לפי הלוגיקה של היישום שלך
		//         // לדוגמה: throw new ArgumentNullException("Tmp", "אובייקט Tmp הוא null");
		//     }
		// }
		// // עדכון לקוח קיים

		// public void Put(int Id, Customers Tmp)
		// {
		//     // הגדרת מזהה לקוח לפי הקלט
		//     Tmp.CusId = Id;
		//     // שמירת לקוח
		//     Tmp.Save();
		// }

		// אחזור רשימת כל הלקוחות
		public List<Customers> Get()
        {
            return Customers.GetAll();
        }
        // אחזור לקוח לפי מזהה
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Customers.GetById(Id));

        }

        // מחיקת לקוח לפי מזהה
        public string Delete(int Id)
        {

            Customers.DeleteById(Id);

            return $"Customers deleted{Id}";
        }

    }
}
