using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Services;
using System.Web.UI.WebControls;
using BLL;

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




        protected void UpdateTechnician(object sender, EventArgs e)
        {
            try
            {
                // לוג לדיווח על תחילת התהליך
                System.Diagnostics.Debug.WriteLine("Starting UpdateTechnician process");

                HiddenField hfTecId = (HiddenField)form1.FindControl("hfTecId");
                string FullName = txtFullName.Text;
                string Phone = txtPhone.Text;
                string Address = txtAddress.Text;
                string Pass = txtPassword.Text;
                string UserName = txtUsername.Text;
                string Email = txtEmail.Text;
                string TecNum = txtTecNum.Text;
                string Type = txtType.Text;

                // ולידציה על השדות החובה עם לוגים
                System.Diagnostics.Debug.WriteLine($"FullName: {FullName}");
                System.Diagnostics.Debug.WriteLine($"Phone: {Phone}");
                System.Diagnostics.Debug.WriteLine($"Address: {Address}");
                System.Diagnostics.Debug.WriteLine($"Pass: {Pass}");
                System.Diagnostics.Debug.WriteLine($"UserName: {UserName}");
                System.Diagnostics.Debug.WriteLine($"Email: {Email}");
                System.Diagnostics.Debug.WriteLine($"TecNum: {TecNum}");
                System.Diagnostics.Debug.WriteLine($"Type: {Type}");

                if (string.IsNullOrEmpty(FullName))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: FullName is missing or invalid");
                    throw new Exception("FullName is missing or invalid");
                }
                if (string.IsNullOrEmpty(Phone))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: Phone is missing or invalid");
                    throw new Exception("Phone is missing or invalid");
                }
                if (string.IsNullOrEmpty(Address))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: Address is missing or invalid");
                    throw new Exception("Address is missing or invalid");
                }
                if (string.IsNullOrEmpty(Pass))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: Pass is missing or invalid");
                    throw new Exception("Pass is missing or invalid");
                }
                if (string.IsNullOrEmpty(UserName))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: UserName is missing or invalid");
                    throw new Exception("UserName is missing or invalid");
                }
                if (string.IsNullOrEmpty(Email))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: Email is missing or invalid");
                    throw new Exception("Email is missing or invalid");
                }
                if (string.IsNullOrEmpty(TecNum))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: TecNum is missing or invalid");
                    throw new Exception("TecNum is missing or invalid");
                }
                if (string.IsNullOrEmpty(Type))
                {
                    System.Diagnostics.Debug.WriteLine("Validation Error: Type is missing or invalid");
                    throw new Exception("Type is missing or invalid");
                }

                string History = string.Empty; // ברירת מחדל לערך ריק עבור השדה History

                if (hfTecId != null && int.TryParse(hfTecId.Value, out int tecId))
                {
                    System.Diagnostics.Debug.WriteLine($"Editing Technician with ID: {tecId}");

                    // עריכת טכנאי קיים
                    Technicians technician = Technicians.GetById(tecId);
                    if (technician != null)
                    {
                        System.Diagnostics.Debug.WriteLine("Technician found. Updating details.");

                        technician.FulName = FullName;
                        technician.Phone = Phone;
                        technician.Address = Address;
                        technician.Email = Email;
                        technician.UserName = UserName;
                        technician.TecNum = TecNum;
                        technician.Type = Type;

                        if (Pass != "****" && !string.IsNullOrEmpty(Pass))
                        {
                            System.Diagnostics.Debug.WriteLine("Updating password.");
                            technician.Pass = Pass;
                        }

                        technician.History = History; // הוספת שדה History
                        technician.DateAddition = DateTime.Now; // שמירת התאריך הנוכחי

                        // לוג לפני השמירה
                        System.Diagnostics.Debug.WriteLine("Saving technician data");
                        technician.Save();
                        // לוג לאחר השמירה
                        System.Diagnostics.Debug.WriteLine("Technician data saved");

                        BindTechnicians();

                        System.Diagnostics.Debug.WriteLine("Technician data bound to Repeater");

                        Response.Write("<script>alert('Updated Successfully');location.href='teclist.aspx';</script>");
                        System.Diagnostics.Debug.WriteLine("Update process completed successfully");
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("Technician not found");
                        Response.Write("<script>alert('Technician not found');</script>");
                    }
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("Invalid Technician ID");
                    Response.Write("<script>alert('Invalid Technician ID');</script>");
                }
            }
            catch (Exception ex)
            {
                // לוג לשגיאה
                System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
                Response.Write($"<script>alert('Error: {ex.Message}');</script>");
            }
        }


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




