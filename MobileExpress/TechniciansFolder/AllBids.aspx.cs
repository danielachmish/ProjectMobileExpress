using BLL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.TechniciansFolder
{
    public partial class AllBids : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string readId = Request.QueryString["readId"];
                if (!string.IsNullOrEmpty(readId))
                {
                    // בצע פעולות בהתאם למזהה הקריאה
                    //GetCallInfoJson(readId);





                    // הוספת סקריפט שיפעיל את הפונקציה עם טעינת הדף
                    string script = $"document.addEventListener('DOMContentLoaded', function() {{ loadQuoteFromRead({readId}); }});";
                    ScriptManager.RegisterStartupScript(this, GetType(), "LoadQuote", script, true);

                }
            }
        }

        private bool ValidateAuthentication()
        {
            return Session["TecId"] != null;
        }

        //private void LoadReadabilityData(int readId)
        //{
        //    try
        //    {
        //        var readability = Readability.GetById(readId);
        //        if (readability == null)
        //        {
        //            throw new Exception("קריאה לא נמצאה");
        //        }

        //        var customer = Customers.GetById(readability.CusId);
        //        if (customer == null)
        //        {
        //            throw new Exception($"לא נמצא לקוח עם מזהה {readability.CusId}");
        //        }

        //        var technician = GetLoggedInTechnician();
        //        if (technician == null)
        //        {
        //            throw new Exception("לא נמצאו פרטי טכנאי");
        //        }

        //        // עדכון בקרי ASP.NET
        //        txtCustomerName.Text = customer.FullName;
        //        txtPhone.Text = customer.Phone;
        //        txtReadId.Text = readId.ToString();
        //        txtTechnicianName.Text = technician.FulName;

        //        // שמירת מזהים בשדות מוסתרים
        //        hiddenReadId.Value = readId.ToString();
        //        hiddenCustomerId.Value = customer.CusId.ToString();
        //        hiddenTechnicianId.Value = technician.TecId.ToString();

        //        // כדי למלא את הכותרות והמידע הנוסף
        //        string script = $@"
        //    // עדכון כותרות
        //    if (document.getElementById('quoteNumber')) {{
        //        document.getElementById('quoteNumber').textContent = '{readId}-{DateTime.Now:yyyyMMdd}';
        //    }}
        //    if (document.getElementById('currentDate')) {{
        //        document.getElementById('currentDate').textContent = '{DateTime.Now:dd/MM/yyyy}';
        //    }}
        //    if (document.getElementById('serviceCallId')) {{
        //        document.getElementById('serviceCallId').textContent = '{readId}';
        //    }}
            
        //    // עדכון פרטי לקוח בחלק התצוגה
        //    if (document.getElementById('customerName')) {{
        //        document.getElementById('customerName').textContent = '{customer.FullName}';
        //    }}
        //    if (document.getElementById('customerPhone')) {{
        //        document.getElementById('customerPhone').textContent = '{customer.Phone}';
        //    }}
        //    if (document.getElementById('customerEmail')) {{
        //        document.getElementById('customerEmail').textContent = '{customer.Email}';
        //    }}

        //    // עדכון פרטי חברה
        //    if (document.querySelector('.company-name')) {{
        //        document.querySelector('.company-name').textContent = 'Mobile Express - {technician.FulName}';
        //    }}

        //    // עדכון פרטי המכשיר
        //    if (document.getElementById('deviceModel')) {{
        //        document.getElementById('deviceModel').textContent = '{readability.ModelId}';
        //    }}
        //    if (document.getElementById('serviceDescription')) {{
        //        document.getElementById('serviceDescription').textContent = '{readability.Desc}';
        //    }}
        //";

        //        ScriptManager.RegisterStartupScript(this, GetType(), "InitializeQuote", script, true);
        //    }
        //    catch (Exception ex)
        //    {
        //        ScriptManager.RegisterStartupScript(this, GetType(), "LoadError",
        //            $"alert('אירעה שגיאה בטעינת הנתונים: {ex.Message}');", true);
        //    }
        //}
        //protected void btnSubmitBid_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        if (!ValidateAuthentication())
        //        {
        //            throw new Exception("משתמש לא מחובר");
        //        }

        //        var bid = new Bid
        //        {
        //            ReadId = Convert.ToInt32(hiddenReadId.Value),
        //            TecId = Convert.ToInt32(hiddenTechnicianId.Value),
        //            Price = Convert.ToInt32(txtPrice.Text),
        //            Desc = txtDescription.Text,
        //            Date = DateTime.Now,
        //            Status = false
        //        };

        //        bid.SaveNewBid();

        //        // עדכון סטטוס הקריאה
        //        var readability = Readability.GetById(bid.ReadId);
        //        if (readability != null)
        //        {
        //            readability.Status = true;
        //            readability.UpdateReadability();
        //        }

        //        ShowSuccess("הצעת המחיר נשמרה בהצלחה");
        //        Response.Redirect($"AllRead.aspx");
        //    }
        //    catch (Exception ex)
        //    {
        //        LogError(ex);
        //        ShowError("שגיאה בשמירת הצעת מחיר", ex.Message);
        //    }
        //}

        private void ShowError(string title, string message)
        {
            var script = $"Swal.fire({{ icon: 'error', title: '{title}', text: '{message.Replace("'", "\\'")}', confirmButtonText: 'אישור' }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowError", script, true);
        }

        private void ShowSuccess(string message)
        {
            var script = $"Swal.fire({{ icon: 'success', title: 'הצלחה', text: '{message.Replace("'", "\\'")}', confirmButtonText: 'אישור' }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess", script, true);
        }

        private void LogError(Exception ex)
        {
            // כאן יש להוסיף לוגיקת logging מתאימה
            System.Diagnostics.Debug.WriteLine($"Error in AllBids: {ex.Message}");
        }
        //private Technicians GetLoggedInTechnician()
        //{
        //    if (Session["TecId"] == null)
        //        throw new Exception("לא נמצא משתמש מחובר");

        //    int tecId = Convert.ToInt32(Session["TecId"]);
        //    var technician = Technicians.GetById(tecId);

        //    if (technician == null)
        //        throw new Exception("לא נמצאו פרטי טכנאי");

        //    return technician;
        //}
      
        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateAuthentication())
                {
                    throw new Exception("משתמש לא מחובר");
                }

                // בדיקת תקינות הקלט
                if (string.IsNullOrEmpty(txtTotalPrice.Text) || string.IsNullOrEmpty(txtDescription.Text))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ValidationError",
                        "alert('נא למלא את כל השדות הנדרשים');", true);
                    return;
                }

                // המרת ערכים עם בדיקת תקינות
                if (!int.TryParse(hiddenReadId.Value, out int readId))
                {
                    throw new Exception("מזהה קריאה לא תקין");
                }
                if (!int.TryParse(hiddenTechnicianId.Value, out int technicianId))
                {
                    throw new Exception("מזהה טכנאי לא תקין");
                }
                if (!int.TryParse(txtTotalPrice.Text, out int price))
                {
                    throw new Exception("המחיר חייב להיות מספר שלם");
                }

                // חישוב הסכום הכולל מהפריטים בטבלה
                var bidItemsJson = Request.Form["bidItems"]; // מקבל את הפריטים מה-JavaScript
                var totalPrice = price; // אם אין פריטים, משתמשים במחיר שהוזן ידנית

                if (!string.IsNullOrEmpty(bidItemsJson))
                {
                    var bidItems = JsonConvert.DeserializeObject<List<dynamic>>(bidItemsJson);
                    totalPrice = bidItems.Sum(item => (int)(item.total));
                }

                // יצירת אובייקט הצעת מחיר
                var bid = new Bid
                {
                    BidId = -1, // חדש
                    ReadId = readId,
                    TecId = technicianId,
                    Price = totalPrice,
                    Desc = txtDescription.Text.Trim(),
                    Date = DateTime.Now,
                    Status = false // ממתין לאישור
                };

                // שמירת ההצעה
                bid.SaveNewBid();

                // עדכון סטטוס הקריאה
                var readability = Readability.GetById(readId);
                if (readability != null)
                {
                    readability.Status = true;
                    readability.UpdateReadability();
                }

                // הודעת הצלחה והפניה לדף הקריאות
                ScriptManager.RegisterStartupScript(this, GetType(), "SaveSuccess",
                    "alert('הצעת המחיר נשמרה בהצלחה');window.location.href='AllRead.aspx';", true);
            }
            catch (FormatException)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "FormatError",
                    "alert('אנא הזן ערכים מספריים תקינים');", true);
            }
            catch (Exception ex)
            {
                // רישום השגיאה
                System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת הצעת מחיר: {ex.Message}");
                // הודעה למשתמש
                ScriptManager.RegisterStartupScript(this, GetType(), "SaveError",
                    $"alert('אירעה שגיאה בשמירת הצעת המחיר: {ex.Message}');", true);
            }
        }
    }
}