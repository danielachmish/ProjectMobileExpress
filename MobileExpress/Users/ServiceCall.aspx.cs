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
			// ddlModelId.DataSource = models;
			// ddlModelId.DataTextField = "ModelName";
			// ddlModelId.DataValueField = "ModelId";
			// ddlModelId.DataBind();
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
					//ModelId = int.Parse(ddlModelId.SelectedValue),
					Status = false, // קריאה חדשה
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
				Response.Redirect("~/Users/ServiceHistory.aspx");
			}
			catch (Exception ex)
			{
				// טיפול בשגיאה
				ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
					$"alert('אירעה שגיאה: {ex.Message}');", true);
			}
		}

		//private string SaveUploadedFile()
		//{
		//	try
		//	{
		//		string fileName = $"{Guid.NewGuid()}_{fuImage.FileName}";
		//		string path = Path.Combine(Server.MapPath("~/Uploads"), fileName);

		//		// וודא שהתיקייה קיימת
		//		Directory.CreateDirectory(Path.GetDirectoryName(path));

		//		fuImage.SaveAs(path);
		//		return fileName;
		//	}
		//	catch (Exception ex)
		//	{
		//		throw new Exception("שגיאה בשמירת הקובץ: " + ex.Message);
		//	}
		//}
		//protected void btnDetectDevice_Click(object sender, EventArgs e)
		//{
		//try
		//{
		//	var systemInfo = SystemInfoService.GetSystemInfo();
		//	if (systemInfo != null)
		//	{
		//		string deviceDetails = $"{systemInfo.Manufacturer} {systemInfo.Model}";
		//		ddlModelId.Text = deviceDetails;

		//		// שמירת המידע המלא ב-Session למקרה שנצטרך אותו
		//		Session["DeviceSystemInfo"] = systemInfo;  // עדכון שם המשתנה בסשן
		//	}
		//	else
		//	{
		//		ddlModelId.Text = "לא ניתן לזהות את פרטי המכשיר";
		//	}
		//}
		//catch (Exception ex)
		//{
		//	System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
		//	ddlModelId.Text = "אירעה שגיאה בזיהוי המכשיר";
		//}
		//}
		//protected void btnDetectDevice_Click(object sender, EventArgs e)
		//{
		//    try
		//    {
		//        string modelId = "";

		//        // ניסיון ראשון - מידע על המוצר
		//        using (var searcher = new ManagementObjectSearcher("root\\CIMV2", "SELECT * FROM Win32_ComputerSystemProduct"))
		//        {
		//            foreach (ManagementObject obj in searcher.Get())
		//            {
		//                if (obj["Name"] != null)
		//                {
		//                    modelId = obj["Name"].ToString().Trim();
		//                    break;
		//                }
		//            }
		//        }

		//        // ניסיון שני - בדיקת BIOS
		//        if (string.IsNullOrEmpty(modelId))
		//        {
		//            using (var searcher = new ManagementObjectSearcher("root\\CIMV2", "SELECT * FROM Win32_BIOS"))
		//            {
		//                foreach (ManagementObject obj in searcher.Get())
		//                {
		//                    if (obj["Version"] != null)
		//                    {
		//                        modelId = obj["Version"].ToString().Trim();
		//                        break;
		//                    }
		//                }
		//            }
		//        }

		//        // ניסיון שלישי - מידע על המארז
		//        if (string.IsNullOrEmpty(modelId))
		//        {
		//            using (var searcher = new ManagementObjectSearcher("root\\CIMV2", "SELECT * FROM Win32_SystemEnclosure"))
		//            {
		//                foreach (ManagementObject obj in searcher.Get())
		//                {
		//                    if (obj["Model"] != null)
		//                    {
		//                        modelId = obj["Model"].ToString().Trim();
		//                        break;
		//                    }
		//                }
		//            }
		//        }

		//        // הדפסת כל המאפיינים לדיבוג
		//        using (var searcher = new ManagementObjectSearcher("root\\CIMV2", "SELECT * FROM Win32_ComputerSystem"))
		//        {
		//            foreach (ManagementObject obj in searcher.Get())
		//            {
		//                foreach (PropertyData property in obj.Properties)
		//                {
		//                    System.Diagnostics.Debug.WriteLine($"{property.Name}: {property.Value}");
		//                }
		//            }
		//        }

		//        TextBox1.Text = modelId;
		//        System.Diagnostics.Debug.WriteLine($"Found Model ID: {modelId}");
		//    }
		//    catch (Exception ex)
		//    {
		//        TextBox1.Text = "לא ניתן לזהות את מספר הדגם";
		//        System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
		//    }
		//}
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

				TextBox1.Text = output.ToString().Trim();

			}
			catch (Exception ex)
			{
				TextBox1.Text = "לא ניתן לזהות את מזהה המחשב";
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