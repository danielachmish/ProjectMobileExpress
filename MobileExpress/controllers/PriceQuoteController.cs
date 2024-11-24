// PriceQuoteController.cs
using BLL;
using System;
using System.Web.Http;  // שים לב לשינוי

public class PriceQuoteController : ApiController  // שים לב לשינוי
{
    [HttpGet]
    [Route("api/Readability/GetReadDetails/{readId}")]  // שינוי הנתיב
    public IHttpActionResult GetReadDetails(int readId)
    {
        try
        {
            var readability = Readability.GetById(readId);
            if (readability == null)
                return Ok(new { success = false, message = "קריאה לא נמצאה" });

            var customer = Customers.GetById(readability.CusId);

            var response = new
            {
                ReadId = readability.ReadId,
                DateRead = readability.DateRead,
                Desc = readability.Desc,
                CusId = readability.CusId,
                FullName = customer?.FullName ?? "",
                Phone = customer?.Phone ?? "",
                Address = customer?.Addres ?? "",
                Email = customer?.Email ?? "",
                TecId = readability.SerProdId,
                ModelId = readability.ModelId,
                Urgency = readability.Urgency,
                success = true
            };

            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(new { success = false, message = ex.Message });
        }
    }
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{action}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}