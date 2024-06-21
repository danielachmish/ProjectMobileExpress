using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Web.Http;

namespace MobileExpress
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // הגדרת נתיב ברירת מחדל
            config.MapHttpAttributeRoutes();

            // הגדרת נתיב מותאם לגרסה
            config.Routes.MapHttpRoute(
                name: "APIv1",
                routeTemplate: "api/v1/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            // הגדרת פורמט JSON
            config.Formatters.JsonFormatter.SupportedMediaTypes.Add(new MediaTypeHeaderValue("text/html"));
        }
    }
}
