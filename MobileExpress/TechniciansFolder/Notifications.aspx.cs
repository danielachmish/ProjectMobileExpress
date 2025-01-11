//using System;
//using System.Web.UI.WebControls;
//using BLL;

//namespace MobileExpress.TechniciansFolder
//{
//    public partial class TechnicianNotifications : System.Web.UI.Page
//    {
//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                LoadNotificationsGrid();  // שם חדש לפונקציה
//            }
//        }

//        private void LoadNotificationsGrid()
//        {
//            gvNotifications.DataSource = BLL.TechnicianNotifications.GetUnviewedNotifications();
//            gvNotifications.DataBind();
//        }
//        protected void gvNotifications_RowCommand(object sender, GridViewCommandEventArgs e)
//        {
//            if (e.CommandName == "ViewCall")
//            {
//                int index = Convert.ToInt32(e.CommandArgument);
//                int readId = Convert.ToInt32(gvNotifications.DataKeys[index].Values["ReadId"]);
//                int notificationId = Convert.ToInt32(gvNotifications.DataKeys[index].Values["NotificationId"]);

//                BLL.TechnicianNotifications.MarkAsViewed(notificationId);
//                Response.Redirect($"~/TechniciansFolder/ViewCall.aspx?id={readId}");
//            }
//        }
//    }
//}