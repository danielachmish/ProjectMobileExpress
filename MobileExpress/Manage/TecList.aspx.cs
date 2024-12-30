using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Services;

namespace MobileExpress.Manage
{
    public partial class TecList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTechnicians();
            }
        }

        private void BindTechnicians()
        {
            List<Technicians> techniciansList = Technicians.GetAll();
            Repeater1.DataSource = techniciansList;
            Repeater1.DataBind();
        }

        public void Delete(int TecId)
        {
            Technicians.DeleteById(TecId);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int tecID = Convert.ToInt32(btn.CommandArgument);
            Delete(tecID);
            BindTechnicians(); // רענון הרשימה לאחר המחיקה
        }

        [WebMethod]
        public static void DeleteTechnicians(List<int> ids)
        {
            if (ids == null || !ids.Any())
            {
                throw new ArgumentException("No IDs provided");
            }

            try
            {
                foreach (int id in ids)
                {
                    Technicians.DeleteById(id);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("An error occurred while deleting technicians.", ex);
            }
        }




        protected void SaveTechnician(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("Starting SaveTechnician process");

                HiddenField hfTecId = (HiddenField)form1.FindControl("hfTecId");
                string FullName = txtFullName.Text;
                string Phone = txtPhone.Text;
                string Address = txtAddress.Text;
                string Pass = txtPassword.Text;
                string UserName = txtUsername.Text;
                string Email = txtEmail.Text;
                string TecNum = txtTecNum.Text;
                string Type = txtType.Text;

                ValidateFields(FullName, Phone, Address, Pass, UserName, Email, TecNum, Type);

                string History = string.Empty;

                var technician = new Technicians
                {
                    TecId = hfTecId != null && !string.IsNullOrEmpty(hfTecId.Value) && int.TryParse(hfTecId.Value, out int tecId) ? tecId : -1,
                    FulName = FullName,
                    Phone = Phone,
                    Address = Address,
                    Email = Email,
                    UserName = UserName,
                    Pass = Pass != "****" && !string.IsNullOrEmpty(Pass) ?
                  EncryptionUtils.HashPassword(Pass) : null,
                    TecNum = TecNum,
                    Type = Type,
                    History = History,
                    DateAddition = DateTime.Now
                };

                if (technician.TecId == -1)
                {
                    System.Diagnostics.Debug.WriteLine("Adding new technician");
                    technician.SaveNewTechnician();
                    System.Diagnostics.Debug.WriteLine("New technician added successfully");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"Editing Technician with ID: {technician.TecId}");
                    technician.UpdateTechnician();
                    System.Diagnostics.Debug.WriteLine("Technician data saved");
                }

                BindTechnicians();
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
            string[] fieldNames = { "FullName", "Phone", "Address", "Pass", "UserName", "Email", "TecNum", "Type" };
            for (int i = 0; i < fields.Length; i++)
            {
                if (string.IsNullOrEmpty(fields[i]))
                {
                    System.Diagnostics.Debug.WriteLine($"Validation Error: {fieldNames[i]} is missing or invalid");
                    throw new Exception($"{fieldNames[i]} is missing or invalid");
                }
            }
        }

        //private string HashPassword(string password)
        //{
        //    return Convert.ToBase64String(System.Security.Cryptography.SHA256.Create().ComputeHash(System.Text.Encoding.UTF8.GetBytes(password)));
        //}


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
        public static void UpdateTechnicianStatus(int TecId, bool Status)
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
                    using (SqlCommand cmd = new SqlCommand("UPDATE T_Technicians SET Status = @Status WHERE TecId = @TecId", conn))
                    {
                        cmd.Parameters.AddWithValue("@TecId", TecId);
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




