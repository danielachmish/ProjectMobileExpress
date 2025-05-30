﻿using BLL;
using Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Auth.Login
{
	public partial class CustomersLogin : System.Web.UI.Page
	{
	
            private const string ADMIN_TYPE = "admin";
        private const string CUSTOMERS_TYPE = "customers";

        private const string ADMIN_PAGE = "~/Manage/Default.aspx";
        private const string CUSTOMERS_PAGE = "~/Users/Main.aspx";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // בדיקה אם המשתמש כבר מחובר
                if (User.Identity.IsAuthenticated)
                {
                    RedirectBasedOnUserType();
                }

            }
        }

      
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            System.Diagnostics.Debug.WriteLine($"=== תחילת תהליך התחברות ===");
            System.Diagnostics.Debug.WriteLine($"ניסיון התחברות עם מייל: {email}");

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                System.Diagnostics.Debug.WriteLine("שגיאה: שדות ריקים");
                ShowError("נא למלא את כל השדות");
                return;
            }

            try
            {
                System.Diagnostics.Debug.WriteLine("בודק אם משתמש הוא מנהל...");
                var admin = Administrators.GetAll().FirstOrDefault(a =>
                    a.Email.Equals(email, StringComparison.OrdinalIgnoreCase));

                if (admin != null)
                {
                    System.Diagnostics.Debug.WriteLine($"נמצא מנהל עם ID: {admin.AdminId}");
                    string hashedAdminPassword = Administrators.HashPassword(password);
                    System.Diagnostics.Debug.WriteLine($"סיסמה מוצפנת של מנהל: {hashedAdminPassword}");
                    System.Diagnostics.Debug.WriteLine($"סיסמה שמורה של מנהל: {admin.Pass}");

                    if (hashedAdminPassword == admin.Pass)
                    {
                        System.Diagnostics.Debug.WriteLine("אימות מנהל הצליח - מתחבר...");
                        LoginAdmin(admin);
                        return;
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("סיסמת מנהל שגויה");
                    }
                }

                System.Diagnostics.Debug.WriteLine("בודק אם משתמש הוא לקוח...");
                var customers = Customers.GetAll();
                System.Diagnostics.Debug.WriteLine($"נמצאו {customers.Count} לקוחות");

                foreach (var c in customers)
                {
                    System.Diagnostics.Debug.WriteLine($"בודק לקוח - ID: {c.CusId}, Email: {c.Email}");
                }

                var customer = customers.FirstOrDefault(t =>
                    t.Email != null && t.Email.Equals(email, StringComparison.OrdinalIgnoreCase));

                if (customer != null)
                {
                    System.Diagnostics.Debug.WriteLine($"נמצא לקוח - ID: {customer.CusId}, Email: {customer.Email}");
                    System.Diagnostics.Debug.WriteLine($"נמצא לקוח עם ID: {customer.CusId}");
                    System.Diagnostics.Debug.WriteLine($"סיסמה שמורה: {customer.Pass}");
                    string hashedPassword = EncryptionUtils.HashPassword(password);
                    System.Diagnostics.Debug.WriteLine($"סיסמה שהוזנה (מוצפנת): {hashedPassword}");

                
                    if (customer != null)
                    {
                        string hashedTechPassword = EncryptionUtils.HashPassword(password);
                        if (hashedTechPassword == customer.Pass)
                        {
                            // התחברות טכנאי מוצלחת
                            LoginCustomers(customer);
                            return;
                        }
                    }
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"לא נמצא לקוח עם המייל: {email}");
                }

                System.Diagnostics.Debug.WriteLine("התחברות נכשלה - מציג שגיאה");
                ShowError("שם משתמש או סיסמה שגויים");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"=== שגיאה בתהליך ההתחברות ===");
                System.Diagnostics.Debug.WriteLine($"סוג השגיאה: {ex.GetType().Name}");
                System.Diagnostics.Debug.WriteLine($"הודעת שגיאה: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                ShowError("אירעה שגיאה בתהליך ההתחברות. אנא נסה שוב מאוחר יותר.");
            }
            finally
            {
                System.Diagnostics.Debug.WriteLine("=== סיום תהליך התחברות ===");
            }
        }

        private void LoginAdmin(Administrators admin)
        {
            FormsAuthentication.SetAuthCookie(admin.Email, false);

            Session["AdminId"] = admin.AdminId;
            Session["Email"] = admin.Email;
            Session["UserName"] = admin.Email;
            Session["Type"] = ADMIN_TYPE;

            Response.Redirect(ADMIN_PAGE);
        }

        private void LoginCustomers(Customers customers)
        {
            FormsAuthentication.SetAuthCookie(customers.Email, false);

            Session["CusId"] = customers.CusId;
            Session["FullName"] = customers.FullName;
            Session["Email"] = customers.Email;

            //Session["Email"] = technician.Email;

            Response.Redirect(CUSTOMERS_PAGE);
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Visible = true;
        }

     
        private void RedirectBasedOnUserType()
        {
            try
            {
                string userType = Session["Email"]?.ToString().ToLower();
                System.Diagnostics.Debug.WriteLine($"User Type: {userType}"); // לוג לדיבוג

                switch (userType)
                {
                    case ADMIN_TYPE:
                        Response.Redirect(ADMIN_PAGE);
                        break;
                    case CUSTOMERS_TYPE:
                        Response.Redirect(CUSTOMERS_PAGE);
                        break;
                    default:
                        System.Diagnostics.Debug.WriteLine($"Invalid user type: {userType}"); // לוג לדיבוג
                        ShowError("סוג משתמש לא חוקי");
                        FormsAuthentication.SignOut();
                        Session.Clear();
                        break;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Redirect error: {ex.Message}"); // לוג לדיבוג
                ShowError("שגיאה בניתוב המשתמש");
            }
        }
    }
}