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

    }
}
