using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.TechniciansFolder
{
	public partial class AllRead : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            if (!IsPostBack)
            {
                LoadCalls();
            }
        }

        private void LoadCalls()
        {
            try
            {
                // וודא שה-Repeater קיים
                if (CallsRepeater != null)
                {
                    var calls = Readability.GetAll().FindAll(c => !c.Status);
                    if (calls != null && calls.Count > 0)
                    {
                        CallsRepeater.DataSource = calls;
                        CallsRepeater.DataBind();
                    }
                    else
                    {
                        // אין קריאות - אפשר להציג הודעה
                        callsContainer.InnerHtml = "<div class='no-calls'>אין קריאות שירות פתוחות</div>";
                    }
                }
                else
                {
                    // לוג או הודעת שגיאה
                    System.Diagnostics.Debug.WriteLine("CallsRepeater is null");
                }
            }
            catch (Exception ex)
            {
                // טיפול בשגיאות
                System.Diagnostics.Debug.WriteLine($"Error in LoadCalls: {ex.Message}");
            }
        }

        protected void CallAction_Command(object sender, CommandEventArgs e)
        {
            try
            {
                int readId = Convert.ToInt32(e.CommandArgument);
                var call = Readability.GetById(readId);

                if (call != null)
                {
                    call.Status = (e.CommandName == "Accept");
                    call.UpdateReadability();
                    LoadCalls();  // טען מחדש את הרשימה
                }
            }
            catch (Exception ex)
            {
                // טיפול בשגיאות
                System.Diagnostics.Debug.WriteLine($"Error in CallAction_Command: {ex.Message}");
            }
        }

        protected void RefreshTimer_Tick(object sender, EventArgs e)
        {
            LoadCalls();
        }
    }
    }