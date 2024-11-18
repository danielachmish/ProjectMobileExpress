using BLL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Web.Http;

namespace MobileExpress.Controllers
{
    [RoutePrefix("api/v1/Technicians")]
    public class TechniciansController : ApiController
    {
        [HttpPost]
        [Route("")]
        public IHttpActionResult Post(Technicians Tmp)
        {
            if (Tmp != null)
            {
                Tmp.TecId = -1;
                Tmp.Save();
                return Ok(new { success = true, message = "Technician added successfully" });
            }
            else
            {
                Debug.WriteLine("Received null Tmp in POST method.");
                return BadRequest("Received null Tmp");
            }
        }


        [HttpPut]
        [Route("{Id:int}")]
        public IHttpActionResult Put(int Id, Technicians Tmp)
        {
            if (Tmp != null)
            {
                Tmp.TecId = Id;
                Tmp.Save();
                return Ok(new { success = true, message = "Technician updated successfully" });
            }
            else
            {
                Debug.WriteLine("Received null Tmp in PUT method.");
                return BadRequest("Received null Tmp");
            }
        }

        [HttpGet]
        [Route("")]
        public IHttpActionResult Get()
        {
            var technicians = Technicians.GetAll();
            return Ok(technicians);
        }

        [HttpGet]
        [Route("{Id:int}")]
        public IHttpActionResult Get(int Id)
        {
            var technician = Technicians.GetById(Id);
            if (technician == null)
            {
                return NotFound();
            }
            return Ok(technician);
        }

        [HttpDelete]
        [Route("{Id:int}")]
        public IHttpActionResult Delete(int Id)
        {
            try
            {
                Debug.WriteLine($"Received DELETE request for technician ID: {Id}");
                int result = Technicians.DeleteById(Id);
                if (result > 0)
                {
                    Debug.WriteLine($"Technician with ID {Id} deleted successfully.");
                    return Ok(new { success = true, message = $"Technician with ID {Id} deleted" });
                }
                else
                {
                    Debug.WriteLine($"Failed to delete technician with ID: {Id}");
                    return BadRequest("Unable to delete the technician.");
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Exception in DELETE method: {ex.Message}");
                return InternalServerError(ex);
            }
        }
        [HttpPost]
        [Route("google-signup")]
        public IHttpActionResult GoogleSignUp([FromBody] GoogleSignUpModel model)
        {
            try
            {
                // בדיקה אם המייל קיים
                if (Technicians.IsEmailExists(model.Email))
                {
                    return Ok(new
                    {
                        success = false,
                        redirectToSignIn = true,
                        message = "משתמש עם מייל זה כבר קיים במערכת. מועבר לדף התחברות."
                    });
                }

                // אם המייל לא קיים, ממשיכים בתהליך ההרשמה
                var technician = Technicians.CreateFromGoogle(
                    model.IdToken,
                    model.Email,
                    model.FulName
                );

                technician.Save();

                return Ok(new
                {
                    success = true,
                    redirectToSignIn = false,
                    message = "הפרטים נטענו בהצלחה",
                    technician = new
                    {
                        TecId = technician.TecId,
                        TecNum = technician.TecNum,
                        FulName = technician.FulName,
                        Phone = technician.Phone,
                        Address = technician.Address,
                        UserName = technician.UserName,
                        Type = technician.Type,
                        Email = technician.Email
                    }
                });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = ex.Message });
            }
        }
        // הוסף את המודל בסוף הקובץ
        public class GoogleSignUpModel
        {
            public string IdToken { get; set; }
            public string Email { get; set; }
            public string FulName { get; set; }
            public string Phone { get; set; }
            public string Address { get; set; }
            public string TecNum { get; set; }
            public string Type { get; set; }
            public string UserName { get; set; }
        }
    }
}


