using BLL;
using DAL;
using Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.TechniciansFolder
{
	public partial class Forms : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				LoadBids();
				// הגדרת תאריך התחלתי (חודש אחורה)
				txtDateFrom.Text = DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd");
				txtDateTo.Text = DateTime.Now.ToString("yyyy-MM-dd");

				
			}
		}
		protected void btnSearch_Click(object sender, EventArgs e)
		{
			LoadBids();
		}

		protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
		{
			LoadBids();
		}

		//private void LoadBids()
		//{
		//	var bids = BLL.Bid.GetAll();
		//	gvBids.DataSource = bids;
		//	gvBids.DataBind();
		//}
		private void LoadBids()
		{
			try
			{
				// השגת כל ההצעות מהדאטאבייס
				var query = BLL.Bid.GetAll().AsQueryable();

				// בדיקת טקסט חיפוש
				if (!string.IsNullOrEmpty(txtSearch?.Value))
				{
					string searchTerm = txtSearch.Value.Trim().ToLower();
					query = query.Where(b =>
						(b.ItemDescription != null && b.ItemDescription.ToLower().Contains(searchTerm)) ||
						b.BidId.ToString().Contains(searchTerm)
					);
				}

				// סינון לפי סטטוס
				if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
				{
					bool status = Convert.ToBoolean(ddlStatus.SelectedValue);
					query = query.Where(b => b.Status == status);
				}

				// סינון לפי תאריכים
				DateTime? dateFrom = null;
				DateTime? dateTo = null;

				if (!string.IsNullOrEmpty(txtDateFrom.Text))
				{
					dateFrom = Convert.ToDateTime(txtDateFrom.Text);
					query = query.Where(b => b.Date >= dateFrom);
				}

				if (!string.IsNullOrEmpty(txtDateTo.Text))
				{
					dateTo = Convert.ToDateTime(txtDateTo.Text).AddDays(1).AddSeconds(-1);
					query = query.Where(b => b.Date <= dateTo);
				}

				// ביצוע השאילתה והצגת התוצאות
				var filteredBids = query?.ToList();
				if (filteredBids != null)
				{
					gvBids.DataSource = filteredBids;
					gvBids.DataBind();

					// הצגת הודעה על מספר התוצאות
					ScriptManager.RegisterStartupScript(this, GetType(), "ShowResults",
						$"Swal.fire({{" +
						$"  title: 'נמצאו {filteredBids.Count} תוצאות'," +
						$"  icon: 'info'," +
						$"  timer: 1500," +
						$"  showConfirmButton: false" +
						$"}});", true);
				}
				else
				{
					// במקרה שאין תוצאות
					gvBids.DataSource = new List<BLL.Bid>();
					gvBids.DataBind();

					ScriptManager.RegisterStartupScript(this, GetType(), "ShowNoResults",
						"Swal.fire({" +
						"  title: 'לא נמצאו תוצאות'," +
						"  icon: 'info'," +
						"  timer: 1500," +
						"  showConfirmButton: false" +
						"});", true);
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in LoadBids: {ex.Message}");
				ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
					"Swal.fire({" +
					"  title: 'שגיאה'," +
					"  text: 'אירעה שגיאה בטעינת הנתונים'," +
					"  icon: 'error'" +
					"});", true);
			}
		}



		protected void gvBids_RowCommand(object sender, GridViewCommandEventArgs e)
		{
			if (e.CommandName == "AcceptCall")
			{
				try
				{
					int readId = Convert.ToInt32(e.CommandArgument);
					var call = Readability.GetById(readId);

					if (call != null && Session["TechnicianId"] != null)
					{
						// עדכון הקריאה
						call.AssignedTechnicianId = Convert.ToInt32(Session["TechnicianId"]);
						call.Status = true;
						call.UpdateReadability();

						// רענון הטבלה
						LoadBids();

						// הודעת הצלחה
						ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
							"Swal.fire({" +
							"  title: 'הקריאה נקלטה'," +
							"  text: 'הקריאה התקבלה בהצלחה'," +
							"  icon: 'success'," +
							"  timer: 2000," +
							"  showConfirmButton: false" +
							"});", true);
					}
					else
					{
						ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
							"Swal.fire('שגיאה', 'לא נמצאה הקריאה או שהמשתמש לא מחובר', 'error');", true);
					}
				}
				catch (Exception ex)
				{
					System.Diagnostics.Debug.WriteLine($"Error in AcceptCall: {ex.Message}");
					ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
						"Swal.fire('שגיאה', 'אירעה שגיאה בקבלת הקריאה', 'error');", true);
				}
			}
		}

		protected string GetStatusClass(bool status)
		{
			return status ? "badge badge-success" : "badge badge-danger";
		}

		protected string GetStatusText(bool status)
		{
			return status ? "מאושר" : "ממתין לאישור";
		}


		

		[WebMethod]
		public static string GetBidDetails(int bidId)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine($"GetBidDetails called with bidId: {bidId}");
				var bid = BLL.Bid.GetById(bidId);

				if (bid == null)
				{
					System.Diagnostics.Debug.WriteLine("Bid not found");
					return null;
				}

				var technician = BLL.Technicians.GetById(bid.TecId);
				var readability = BLL.Readability.GetById(bid.ReadId);

				// חישוב המחירים הנכונים
				decimal subtotal = bid.ItemQuantity * bid.ItemUnitPrice; // סה"כ לפני מע"מ
				decimal vat = subtotal * 0.17m; // מע"מ
				decimal total = subtotal + vat; // סה"כ כולל מע"מ

				var response = new BidDetailsResponse
				{
					BidNumber = bid.BidId,

					Date = bid.Date,
					ReadId = bid.ReadId,
					Status = bid.Status,
					TechnicianDetails = technician != null ? new TechnicianDetailsResponse
					{
						TechId = technician.TecId,
						TechNumber = technician.TecNum,
						Name = technician.FulName,
						Phone = technician.Phone
					} : null,
					CustomerDetails = readability != null ? new CustomerDetailsResponse
					{

						Name = readability.FullName,
						Phone = readability.Phone,
						Description = readability.Desc
					} : null,
					// פרטי הפריט והמחירים המעודכנים
					ItemDescription = bid.ItemDescription,
					ItemQuantity = bid.ItemQuantity,
					ItemUnitPrice = bid.ItemUnitPrice,  // מחיר ליחידה לפני מע"מ
					ItemTotal = subtotal,  // סה"כ לשורה לפני מע"מ
					Subtotal = subtotal,  // סה"כ לפני מע"מ
					Vat = vat,  // מע"מ
					Total = total  // סה"כ כולל מע"מ
				};

				var json = JsonConvert.SerializeObject(response);
				System.Diagnostics.Debug.WriteLine($"Response JSON: {json}");
				return json;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in GetBidDetails: {ex.Message}");
				throw;
			}
		}

		// מחלקות תגובה
		public class BidDetailsResponse
		{
			public int BidNumber { get; set; }
			public DateTime Date { get; set; }
			public int ReadId { get; set; }
			public bool Status { get; set; }
			public TechnicianDetailsResponse TechnicianDetails { get; set; }
			public CustomerDetailsResponse CustomerDetails { get; set; }
			public decimal Subtotal { get; set; }
			public decimal Vat { get; set; }
			public decimal Total { get; set; }

			// פרטי הפריט
			public string ItemDescription { get; set; }
			public int ItemQuantity { get; set; }
			public decimal ItemUnitPrice { get; set; }
			public decimal ItemTotal { get; set; }
		}

		public class TechnicianDetailsResponse
		{
			public int TechId { get; set; }
			public string TechNumber { get; set; }
			public string Name { get; set; }
			public string Phone { get; set; }
		}

		public class CustomerDetailsResponse
		{
			public string FullName { get; set; }
			public string Name { get; set; }
			public string Phone { get; set; }
			public string Description { get; set; }
		}
		protected void ApproveBid(object sender, EventArgs e)
		{
			try
			{
				Button btn = (Button)sender;
				int bidId = Convert.ToInt32(btn.CommandArgument);
				var bid = BLL.Bid.GetById(bidId);

				if (bid != null)
				{
					// עדכון סטטוס ההצעה
					bid.Status = true;
					bid.Save();

					// שליחת התראה לטכנאי (אפשר להוסיף לפי הצורך)
					NotifyTechnician(bid.TecId, bid.ReadId);

					// רענון הדף
					LoadBids();

					// הצגת הודעת הצלחה
					ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
						"Swal.fire('ההצעה אושרה', 'ההצעה אושרה בהצלחה והועברה לטכנאי', 'success');", true);
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"Error in ApproveBid: {ex.Message}");
				ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
					"Swal.fire('שגיאה', 'אירעה שגיאה באישור ההצעה', 'error');", true);
			}
		}

		private void NotifyTechnician(int techId, int readId)
		{
			// כאן אפשר להוסיף לוגיקה לשליחת התראה לטכנאי
			// למשל: שליחת מייל, הודעת SMS, או התראה במערכת
		}

		

	}
}



