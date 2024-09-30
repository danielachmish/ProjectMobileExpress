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
    public class CustomersController : ApiController
    {



		[HttpPost]
		public IHttpActionResult Post([FromBody] Customers customer)
		{
			if (customer == null)
			{
				return BadRequest("אובייקט הלקוח הוא null");
			}
			customer.CusId = 0; // שונה מ -1 ל 0
			customer.Save();
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
