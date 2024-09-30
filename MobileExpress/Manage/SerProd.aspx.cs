using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;



namespace MobileExpress.Manage
{
    public partial class SerProd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSerProd();

            }
        }

        private void BindSerProd()
        {
			List<SerProd> SerProdList = SerProd.GetAll();
            Repeater1.DataSource = SerProdList;
            Repeater1.DataBind();
        }

		                            //private static List<SerProd> GetAll()
		                            //{
			                           // throw new NotImplementedException();
		                            //}

		public void Delete(int SerProdId)
        {
            BLL.SerProd.DeleteById(SerProdId);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int SerProdId = Convert.ToInt32(btn.CommandArgument);
            Delete(SerProdId);
            BindSerProd(); // רענון הרשימה לאחר המחיקה
        }

        [WebMethod]
        public static void DeleteSerProd(List<int> ids)
        {
            if (ids == null || !ids.Any())
            {
                throw new ArgumentException("No IDs provided");
            }

            try
            {
                foreach (int id in ids)
                {
                    BLL.SerProd.DeleteById(id);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("An error occurred while deleting SerProd.", ex);
            }
        }




        protected void SaveSerProd(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("Starting SaveSerProd process");

                HiddenField hfTecId = (HiddenField)form1.FindControl("hfTecId");
                string Desc = txtDesc.Text;
                String Price = txtPrice.Text;
                string NameImage = txtNameImage.Text;
                string Nots = txtNots.Text;


                ValidateFields(Desc, Price, NameImage, Nots);

                string History = string.Empty;

                var SerProd = new BLL.SerProd
                {
                    SerProdId = hfTecId != null && !string.IsNullOrEmpty(hfTecId.Value) && int.TryParse(hfTecId.Value, out int SerProdId) ? SerProdId : -1,
                    Desc = Desc,
					Price = Price,
                    NameImage = NameImage,
                    Nots = Nots,
                };

                if (SerProd.SerProdId == -1)
                {
                    System.Diagnostics.Debug.WriteLine("Adding new SerProd");
                    SerProd.SaveNewSerProd();
                    System.Diagnostics.Debug.WriteLine("New SerProd added successfully");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"Editing SerProd with ID: {SerProd.SerProdId}");
                    SerProd.UpdateSerProd();
                    System.Diagnostics.Debug.WriteLine("SerProd data saved");
                }

                BindSerProd();
                ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript", "closeModal();", true);
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
                Response.Write($"<script>alert('Error: {ex.Message}');</script>");
            }
        }

        private void ValidateFields(params string[] fields)
        {
            string[] fieldNames = { "Desc", "Price", "NameImage", "Nots" };
            for (int i = 0; i < fields.Length; i++)
            {
                if (string.IsNullOrEmpty(fields[i]))
                {
                    System.Diagnostics.Debug.WriteLine($"Validation Error: {fieldNames[i]} is missing or invalid");
                    throw new Exception($"{fieldNames[i]} is missing or invalid");
                }
            }
        }







        [WebMethod]
        public static void UpdateSerProdStatus(int SerProdId, bool Status)
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
                    using (SqlCommand cmd = new SqlCommand("UPDATE T_SerProd SET Status = @Status WHERE SerProdId = @SerProdId", conn))
                    {
                        cmd.Parameters.AddWithValue("@SerProdId", SerProdId);
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
