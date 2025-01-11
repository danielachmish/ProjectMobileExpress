using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Security;
using System.Web.SessionState;
using Unity;
using Unity.AspNet.Mvc;
using Unity.WebApi;
using UnityDependencyResolver = Unity.WebApi.UnityDependencyResolver;

namespace MobileExpress
{
	public class Global : System.Web.HttpApplication
	{

		protected void Application_Start()
		{
			GlobalConfiguration.Configure(WebApiConfig.Register);
			// הגדרת Dependency Injection
			//var container = new UnityContainer();

			//// רישום כל השירותים שלנו
			//container.RegisterType<IChatService, ChatService>();
			//container.RegisterType<IChatRepository, ChatRepository>();
			//container.RegisterType<ICustomerRepository, CustomerRepository>();
			//container.RegisterType<ITechnicianRepository, TechnicianRepository>();

			//// הגדרת Unity כ-DependencyResolver של WebApi
			//GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
		}

		protected void Session_Start(object sender, EventArgs e)
		{

		}

		protected void Application_BeginRequest(object sender, EventArgs e)
		{

		}

		protected void Application_AuthenticateRequest(object sender, EventArgs e)
		{

		}

		protected void Application_Error(object sender, EventArgs e)
		{

		}

		protected void Session_End(object sender, EventArgs e)
		{

		}

		protected void Application_End(object sender, EventArgs e)
		{

		}
	}
}