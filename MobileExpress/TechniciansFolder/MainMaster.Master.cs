using BLL;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.TechniciansFolder
{
	public partial class MainMaster : System.Web.UI.MasterPage
	{
	
		
		protected void Page_Load(object sender, EventArgs e)
		{
			

			if (!IsPostBack)
			{
			
			}

			
		}
		protected void Logout_Click(object sender, EventArgs e)
		{
			Session.Clear();
			FormsAuthentication.SignOut();
			Response.Redirect("~/Auth/Login/TechniciansLogin.aspx");
		}

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
