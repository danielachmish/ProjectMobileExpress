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

				if (Session["TechnicianId"] != null)
				{
					int techId = Convert.ToInt32(Session["TechnicianId"]);
					query = query.Where(b => b.TecId == techId); // מציג רק הצעות של הטכנאי המחובר
				}

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
				var filteredBids = query?.ToList().Select(b =>
				{
					var read = Readability.GetById(b.ReadId);
					return new
					{
						b.BidId,
						b.ReadId,
						b.Status,          // סטטוס ההצעה (האם אושרה)
						b.Date,
						b.Price,
						b.ItemDescription,
						b.FullName,
						ReadStatus = read?.Status ?? false,  // סטטוס הקריאה
						IsCallTaken = read?.Status ?? false, // האם הקריאה נלקחה
						ShowTakeButton = b.Status && !(read?.Status ?? false) // להציג כפתור רק אם ההצעה אושרה והקריאה לא נלקחה
					};
				});

				if (filteredBids != null)
				{
					gvBids.DataSource = filteredBids;
					gvBids.DataBind();
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
						// בדיקה שהקריאה לא סגורה
						if (call.Status == true)
						{
							ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
								"Swal.fire('שגיאה', 'הקריאה כבר סגורה', 'error');", true);
							return;
						}

						// עדכון הקריאה
						call.Status = true; // true = סגור/בטיפול
						call.AssignedTechnicianId = Convert.ToInt32(Session["TechnicianId"]);
						call.UpdateReadability();

						// רענון הטבלה
						LoadBids();

						ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
							"Swal.fire({" +
							"  title: 'הקריאה נקלטה'," +
							"  text: 'הקריאה התקבלה בהצלחה והועברה לטיפול'," +
							"  icon: 'success'," +
							"  timer: 2000," +
							"  showConfirmButton: false" +
							"});", true);
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
		
	}
}



