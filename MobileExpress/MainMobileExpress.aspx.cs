using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Services;
using System.Web.Script.Services;
using System.IO;

namespace MobileExpress
{
	public partial class MainMobileExpress : System.Web.UI.Page
	{
	

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string[] GetImagesList()
        {
            string imagesDir = HttpContext.Current.Server.MapPath("~/assets/images/imagebackground");

            var imageFiles = Directory.EnumerateFiles(imagesDir)
                .Where(file => file.EndsWith(".jpg", StringComparison.OrdinalIgnoreCase)
                            || file.EndsWith(".jpeg", StringComparison.OrdinalIgnoreCase)
                            || file.EndsWith(".png", StringComparison.OrdinalIgnoreCase)
                            || file.EndsWith(".gif", StringComparison.OrdinalIgnoreCase))
                .Select(Path.GetFileName)
                .ToArray();

            return imageFiles; // תחזור כמערך של מחרוזות
        }
    }


}
