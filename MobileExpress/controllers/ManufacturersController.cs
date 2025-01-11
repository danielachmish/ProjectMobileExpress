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
    public class ManufacturersController : ApiController
    {
        [HttpPost]
        public IHttpActionResult Post([FromBody] Manufacturers manufacturer)
        {
            try
            {
                if (manufacturer == null)
                    return BadRequest("אובייקט ריק");

                manufacturer.ManuId = -1;
                manufacturer.Save();
                return Ok(manufacturer);
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        // עדכון לקוח קיים
        [HttpPut]
        
        public void Put(int Id, Manufacturers Tmp)
        {
            // הגדרת מזהה לקוח לפי הקלט
            Tmp.ManuId = Id;
            // שמירת לקוח
            Tmp.Save();
        }

        // אחזור רשימת כל הלקוחות
        [HttpGet]
        public List<Manufacturers> Get()
        {
            return Manufacturers.GetAll();
        }

        // אחזור לקוח לפי מזהה
        [HttpGet]
        public string Get(int Id)
        {
            return JsonConvert.SerializeObject(Manufacturers.GetById(Id));
        }

        // מחיקת לקוח לפי מזהה
        [HttpDelete]
        public string Delete(int Id)
        {
            Manufacturers.DeleteById(Id);
            return $"Manufacturers deleted {Id}";
        }
    }
}
