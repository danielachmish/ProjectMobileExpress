using BLL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Manage
{
	public partial class CusList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

            if (!IsPostBack)
            {
                BindCustomers();
            }
        }

        private void BindCustomers()
        {
            List<Customers> customersList = Customers.GetAll();
            Repeater2.DataSource = customersList;
            Repeater2.DataBind();
        }

        public void Delete(int CusId)
        {
            Customers.DeleteById(CusId);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int cusID = Convert.ToInt32(btn.CommandArgument);
            Delete(cusID);
            BindCustomers(); // רענון הרשימה לאחר המחיקה
        }

        [WebMethod]
        public static void DeleteCustomers(List<int> ids)
        {
            if (ids == null || !ids.Any())
            {
                throw new ArgumentException("No IDs provided");
            }

            try
            {
                foreach (int id in ids)
                {
                    Customers.DeleteById(id);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("An error occurred while deleting customers.", ex);
            }
        }




		protected void SaveCustomers(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת לקוחות -------------");
				HiddenField hfCusId = (HiddenField)form1.FindControl("hfCusId");
				System.Diagnostics.Debug.WriteLine($"hfCusId נמצא: {hfCusId != null}, ערך: {hfCusId?.Value}");

				string FullName = txtFullName.Text;
				string Phone = txtPhone.Text;
				string Addres = txtAddres.Text;
				string Uname = txtUname.Text;
				string Pass = txtPass.Text;
				//string DateAdd = txtDateAdd.Text;
				bool Status;
				
				string Nots = txtNots.Text;
				int CityId;
				if (!int.TryParse(txtCityId.Text, out CityId))
				{
					System.Diagnostics.Debug.WriteLine($"שגיאה בהמרת מספר עיר: {txtCityId.Text}");
					throw new Exception("ערך לא תקין עבור שדה מספר עיר");
				}

				System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: CusId={hfCusId?.Value}, FullName={FullName}, Phone={Phone}, Addres={Addres}, Uname={Uname},   CityId={CityId}, Nots={Nots}");

				System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
				ValidateFields(FullName, Phone, Addres, Uname, Pass,  Nots, CityId.ToString());
				System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

				var customers = new Customers
				{
					CusId = hfCusId != null && !string.IsNullOrEmpty(hfCusId.Value) && int.TryParse(hfCusId.Value, out int cusId) ? cusId : 0,
					FullName = FullName,
					Phone = Phone,
					Addres = Addres,
					Uname = Uname,
					Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ? HashPassword(Pass) : null,
					DateAdd = DateTime.Now,
					
					Nots = Nots,
					CityId = CityId
				};

				System.Diagnostics.Debug.WriteLine($"אובייקט Customers נוצר: CusId={customers.CusId}, FullName={customers.FullName}, Phone={customers.Phone}, Addres={customers.Addres}, Uname={customers.Uname}, DateAdd={customers.DateAdd}, Status={customers.Status}, CityId={customers.CityId}, Nots={customers.Nots}");

				if (customers.CusId == 0)
				{
					System.Diagnostics.Debug.WriteLine("מוסיף לקוח חדש");
					customers.SaveNewCustomers();
					System.Diagnostics.Debug.WriteLine("לקוח חדש נוסף בהצלחה");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"עורך לקוח קיים עם מזהה: {customers.CusId}");
					customers.UpdateCustomers();
					System.Diagnostics.Debug.WriteLine("נתוני הלקוח עודכנו בהצלחה");
				}

				System.Diagnostics.Debug.WriteLine("מתחיל BindCustomers");
				BindCustomers();
				System.Diagnostics.Debug.WriteLine("BindCustomers הסתיים");

				System.Diagnostics.Debug.WriteLine("רושם סקריפט JavaScript לסגירת המודל");
				ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript", "closeModal(); console.log('Modal closed after save');", true);

				System.Diagnostics.Debug.WriteLine("מבצע Redirect");
				//Response.Redirect(Request.RawUrl);
				if (!Response.IsRequestBeingRedirected)
				{
					Response.Redirect(Request.RawUrl, false);
					Context.ApplicationInstance.CompleteRequest();
				}
				return;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת לקוח: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"סוג השגיאה: {ex.GetType().FullName}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				Response.Write($"<script>console.error('שגיאה בשמירת לקוח: {ex.Message}'); alert('שגיאה בשמירת לקוח: {ex.Message}');</script>");
			}
			finally
			{
				System.Diagnostics.Debug.WriteLine("------------- סיום תהליך שמירת לקוחות -------------");
			}
		}

		private void ValidateFields(params string[] fields)
		{
			string[] fieldNames = { "FullName", "Phone", "Addres", "Uname", "Pass", "DateAdd", "Status", "Nots", "CityId" };
			for (int i = 0; i < fields.Length; i++)
			{
				System.Diagnostics.Debug.WriteLine($"בודק שדה: {fieldNames[i]}, ערך: {fields[i]}");
				if (string.IsNullOrEmpty(fields[i]))
				{
					System.Diagnostics.Debug.WriteLine($"Validation Error: {fieldNames[i]} is missing or invalid");
					throw new Exception($"{fieldNames[i]} is missing or invalid");
				}
			}
			System.Diagnostics.Debug.WriteLine("כל השדות עברו אימות בהצלחה");
		}

		private string HashPassword(string password)
		{
			System.Diagnostics.Debug.WriteLine("מתחיל תהליך הצפנת סיסמה");
			var hashedPassword = Convert.ToBase64String(System.Security.Cryptography.SHA256.Create().ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
			System.Diagnostics.Debug.WriteLine("סיסמה הוצפנה בהצלחה");
			return hashedPassword;
		}
		//private void LogError(Exception ex)
		//{
		//    // רישום שגיאות
		//    System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
		//}

		//private void ShowErrorMessage(string message)
		//{
		//    // הצגת הודעת שגיאה למשתמש
		//    ScriptManager.RegisterStartupScript(this, GetType(), "errorScript", $"alert('{message}');", true);
		//}

		//private void BindTechnicians()
		//{
		//    // קוד לקישור נתוני הטכנאים ל-Repeater או אלמנט אחר ב-UI
		//}



		[WebMethod]
        public static void UpdateCustomersStatus(int CusId, bool Status)
        {
            try
            {
                // מקבל את מחרוזת החיבור מקובץ web.config
                string connectionString = ConfigurationManager.ConnectionStrings["ConnStr"].ConnectionString;
                System.Diagnostics.Debug.WriteLine("Connection string: " + connectionString);

                // יצירת חיבור למסד הנתונים
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    System.Diagnostics.Debug.WriteLine("Attempting to open connection to database.");

                    // יצירת פקודת SQL
                    using (SqlCommand cmd = new SqlCommand("UPDATE T_Customers SET Status = @Status WHERE CusId = @CusId", conn))
                    {
                        cmd.Parameters.AddWithValue("@CusId", CusId);
                        cmd.Parameters.AddWithValue("@Status", Status);
                        System.Diagnostics.Debug.WriteLine("Prepared SQL command with parameters.");

                        // פתיחת חיבור למסד הנתונים
                        conn.Open();
                        System.Diagnostics.Debug.WriteLine("Connection to database opened successfully.");

                        // ביצוע הפקודה ועדכון השורות
                        int rowsAffected = cmd.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine("Rows affected: " + rowsAffected);

                        // סגירת החיבור למסד הנתונים
                        conn.Close();
                        System.Diagnostics.Debug.WriteLine("Connection to database closed successfully.");
                    }
                }
            }
            catch (Exception ex)
            {
                // טיפול בשגיאה והדפסתה לצורכי דיבוג
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
                throw;
            }
        }

    }
	
}