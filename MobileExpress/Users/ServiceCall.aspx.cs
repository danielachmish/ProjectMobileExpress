using BLL;
using DAL;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Management;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Users
{
	public partial class ServiceCall : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				// טען את רשימת הדגמים לדרופדאון
				LoadModels();
				LoadCustomerData(); // טעינת פרטי הלקוח
				ddlUrgency.SelectedValue = "רגילה";
			}
		}
		private void LoadCustomerData()
		{
			try
			{
				// נניח שאנחנו מקבלים את ID הלקוח מהסשן
				if (Session["CusId"] != null)
				{
					int customerId = Convert.ToInt32(Session["CusId"]);

					// נניח שיש לך מחלקה Customer עם פונקציה GetById
					Customers customer = CustomersDAL.GetById(customerId);

					if (customer != null)
					{
						txtFullName.Text = customer.FullName;
						txtFullName.Enabled = false;  // נעילת השדה לעריכה

						txtCusId.Text = customer.CusId.ToString();
						txtCusId.Enabled = false;

						txtPhone.Text = customer.Phone;
						txtPhone.Enabled = false;
					}
				}
				else
				{
					// אם המשתמש לא מחובר, הפנה אותו לדף ההתחברות
					Response.Redirect("~/Singin.aspx");
				}
			}
			catch (Exception ex)
			{
				lblError.Text = "אירעה שגיאה בטעינת פרטי הלקוח";
				lblError.Visible = true;
				// כדאי גם לרשום את השגיאה ללוג
				System.Diagnostics.Debug.WriteLine($"שגיאה בטעינת פרטי לקוח: {ex.Message}");
			}
		}
		private void LoadModels()
		{
			// הנח שיש לך פונקציה שמביאה את רשימת הדגמים
			// var models = ModelDAL.GetAll();
			// ddlmodelcode.DataSource = models;
			// ddlmodelcode.DataTextField = "ModelName";
			// ddlmodelcode.DataValueField = "modelcode";
			// ddlmodelcode.DataBind();
		}

		protected void btnSubmit_Click(object sender, EventArgs e)
		{
			try
			{
				//string fileName = null;
				//if (fuImage.HasFile)
				//{
				//	fileName = SaveUploadedFile();
				//}

				var newTicket = new Readability
				{

					DateRead = DateTime.Now,
					Desc = txtDesc.Text.Trim(),
					FullName = txtFullName.Text.Trim(),
					Phone = txtPhone.Text.Trim(),
					Nots = txtNotes.Text.Trim(),
					CusId = int.Parse(txtCusId.Text),
					ModelCode = txtmodelcode.Text.Trim(),
					Status = true, // קריאה חדשה
					//NameImage = fileName,
					Urgency = ddlUrgency.SelectedValue,
					SerProdId = 1 // ברירת מחדל או לפי הצורך
				};
				if (chkManualLocation.Checked && !string.IsNullOrEmpty(hdnSelectedLat.Value))
				{
					newTicket.Nots = $"{hdnSelectedLat.Value},{hdnSelectedLng.Value}";
				}
				if (chkShowLocation.Checked)
				{
					newTicket.Nots = GetUserLocation();
				}

				string GetUserLocation()
				{
					try
					{
						return Session["UserLocation"]?.ToString() ?? "";
					}
					catch
					{
						return "";
					}
				}

				newTicket.SaveNewRead();
				
				// הודעת הצלחה
				ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
					"alert('הקריאה נפתחה בהצלחה!');window.location='TicketsList.aspx';", true);
				Response.Redirect("~/Users/Main.aspx");
			}
			catch (Exception ex)
			{
				// טיפול בשגיאה
				ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
					$"alert('אירעה שגיאה: {ex.Message}');", true);
			}
		}

		
		protected void btnDetectDevice_Click(object sender, EventArgs e)
		{
			try
			{
				// הפעלת PowerShell command לקבלת מזהה המחשב
				Process process = new Process();
				ProcessStartInfo startInfo = new ProcessStartInfo();
				startInfo.FileName = "powershell.exe";
				startInfo.Arguments = "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty Model";
				startInfo.RedirectStandardOutput = true;
				startInfo.RedirectStandardError = true;
				startInfo.UseShellExecute = false;
				startInfo.CreateNoWindow = true;
				process.StartInfo = startInfo;
				process.Start();

				StringBuilder output = new StringBuilder();
				while (!process.StandardOutput.EndOfStream)
				{
					output.Append(process.StandardOutput.ReadLine());
				}

				txtmodelcode.Text = output.ToString().Trim();

			}
			catch (Exception ex)
			{
				txtmodelcode.Text = "לא ניתן לזהות את מזהה המחשב";
				System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
			}
		}
		[WebMethod]
		public static void SaveUserLocation(string Nots)
		{
			HttpContext.Current.Session["UserLocation"] = Nots;
		}

		protected void chkManualLocation_CheckedChanged(object sender, EventArgs e)
		{
			mapDiv.Visible = chkManualLocation.Checked;
		}
	}

}