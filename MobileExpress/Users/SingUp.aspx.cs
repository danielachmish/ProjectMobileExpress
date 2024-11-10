using System;
using System.Web;
using System.Web.UI;
using System.Linq;        // הוספת זה
using System.Data.Linq;   // והוספת זה
using System.Web.UI.WebControls;
using BLL;

namespace MobileExpress.Users
{
	public partial class SingUp : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            

        }

        protected void SaveCustomers(object sender, EventArgs e)
        {
            try
            {
                HiddenField hfCusId = (HiddenField)form1.FindControl("hfCusId");

                string FullName = txtFullName.Text;
                string Phone = txtPhone.Text;
                string Addres = txtAddres.Text;
                string Uname = txtUname.Text;
                string Pass = txtPass.Text;
				string Nots = txtNots.Text;

				//if (!int.TryParse(txtCityId.Text, out int CityId))
				//{
				//    throw new Exception("ערך לא תקין עבור שדה מספר עיר");
				//}

				ValidateFields(FullName, Phone, Addres, Uname, Pass/* NotsCityId.ToString()*/);

                var customers = new Customers
                {
                    CusId = hfCusId != null && !string.IsNullOrEmpty(hfCusId.Value) && int.TryParse(hfCusId.Value, out int cusId) ? cusId : 0,
                    FullName = FullName,
                    Phone = Phone,
                    Addres = Addres,
                    Uname = Uname,
                    Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
                    DateAdd = DateTime.Now,
                    Nots = Nots ?? "",
                    //CityId = CityId
                };

                if (customers.CusId == 0)
                {
                    customers.SaveNewCustomers();
                }
                else
                {
                    customers.UpdateCustomers();
                }

            
                ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript", "closeModal();", true);

                if (!Response.IsRequestBeingRedirected)
                {
                    Response.Redirect(Request.RawUrl, false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                return;
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('שגיאה בשמירת לקוח: {ex.Message}');</script>");
            }
        }

        private void ValidateFields(params string[] fields)
        {
            string[] fieldNames = { "FullName", "Phone", "Addres", "Uname", "Pass", "DateAdd","Nots" };
            for (int i = 0; i < fields.Length; i++)
            {
                if (string.IsNullOrEmpty(fields[i]))
                {
                    throw new Exception($"{fieldNames[i]} is missing or invalid");
                }
            }
        }

        private string HashPassword(string password)
		{
			System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
			var hashedPassword = Convert.ToBase64String(System.Security.Cryptography.SHA256.Create().ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
			System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
			return hashedPassword;
		}
	}
}