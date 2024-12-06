using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Users
{
    public partial class CustomerProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CusId"] != null)
                {
                    int customerId = Convert.ToInt32(Session["CusId"]);
                    var customer = Customers.GetById(customerId);
                    if (customer != null)
                    {
                        CusId.Value = customer.CusId.ToString();
                        FullName.Value = customer.FullName;
                        Phone.Value = customer.Phone;
                        Addres.Value = customer.Addres;
                        Email.Value = customer.Email;
                        Pass.Value = customer.Pass;
                        Nots.Value = customer.Nots;
                        // CityId.Value = customer.CityId.ToString();
                    }
                }
                else
                {
                    Response.Redirect("~/Users/SignIn.aspx");
                }
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public static object UpdateCustomerProfile(CustomerData customerData)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"קיבלתי עדכון עבור לקוח {customerData.CusId}");

                if (HttpContext.Current.Session["CusId"] == null)
                {
                    return new { success = false, message = "המשתמש לא מחובר" };
                }

                var existingCustomer = Customers.GetById(customerData.CusId);
                if (existingCustomer == null)
                {
                    return new { success = false, message = "לא נמצא לקוח" };
                }

                existingCustomer.FullName = customerData.FullName;
                existingCustomer.Phone = customerData.Phone;
                existingCustomer.Addres = customerData.Addres;
                existingCustomer.Email = customerData.Email;
                existingCustomer.Pass = customerData.Pass;
                existingCustomer.Nots = customerData.Nots;
                existingCustomer.CityId = customerData.CityId;

                existingCustomer.Save();
                return new { success = true };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון פרטי לקוח: {ex.Message}");
                return new { success = false, message = ex.Message };
            }
        }

        public class CustomerData
        {
            public int CusId { get; set; }
            public string FullName { get; set; }
            public string Phone { get; set; }
            public string Addres { get; set; }
            public string Email { get; set; }
            public string Pass { get; set; }
            public string Nots { get; set; }
            public int CityId { get; set; }
        }
    }
}