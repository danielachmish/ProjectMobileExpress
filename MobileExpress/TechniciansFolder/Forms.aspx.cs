using BLL;
using DAL;
using Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Threading.Tasks;
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
			// בדיקה האם הטכנאי מחובר
			if (Session["TecId"] == null)
			{
				// אם הטכנאי לא מחובר, מעבירים לדף התחברות
				Response.Redirect("~/SingInTechnicians.aspx");
				return;
			}
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

		

		private void LoadBids()
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("=== התחלת טעינת הצעות מחיר ===");

				var query = BLL.Bid.GetAll().AsQueryable();

				if (Session["TecId"] != null)
				{
					int techId = Convert.ToInt32(Session["TecId"]);
					System.Diagnostics.Debug.WriteLine($"TechId מהסשן: {techId}");

					// קבלת הצעות המחיר של הטכנאי
					var bids = query.Where(b => b.TecId == techId).ToList();
					System.Diagnostics.Debug.WriteLine($"נמצאו {bids.Count} הצעות מחיר לטכנאי");

					// סינון רק הצעות שהקריאות שלהן לא משוייכות לטכנאי
					var filteredBids = bids
						.Select(b =>
						{
							var read = Readability.GetById(b.ReadId);
							// הוספת לוג שמראה את כל הערכים
							System.Diagnostics.Debug.WriteLine($"הצעה {b.BidId}:");
							System.Diagnostics.Debug.WriteLine($"  ReadId: {b.ReadId}");
							System.Diagnostics.Debug.WriteLine($"  AssignedTechnicianId value: '{read?.AssignedTechnicianId}'");
							System.Diagnostics.Debug.WriteLine($"  AssignedTechnicianId type: {(read?.AssignedTechnicianId == null ? "null" : read.AssignedTechnicianId.GetType().ToString())}");
							System.Diagnostics.Debug.WriteLine($"  Status: {read?.Status}");

							return new { Bid = b, Read = read };
						})
						.Where(x =>
						{
							var isValid = x.Read != null &&
										 //x.Read.AssignedTechnicianId == null &&
										 x.Read.CallStatus == CallStatus.InProgress;
							System.Diagnostics.Debug.WriteLine($"הצעה {x.Bid.BidId} - isValid: {isValid}");
							return isValid;
						})
						.Select(x => x.Bid)
						.ToList();

					System.Diagnostics.Debug.WriteLine($"נשארו {filteredBids.Count} הצעות אחרי סינון ראשוני");
					query = filteredBids.AsQueryable();
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
				if (!string.IsNullOrEmpty(txtDateFrom.Text))
				{
					var dateFrom = Convert.ToDateTime(txtDateFrom.Text);
					query = query.Where(b => b.Date >= dateFrom);
				}

				if (!string.IsNullOrEmpty(txtDateTo.Text))
				{
					var dateTo = Convert.ToDateTime(txtDateTo.Text).AddDays(1).AddSeconds(-1);
					query = query.Where(b => b.Date <= dateTo);
				}

				// הכנת המידע לתצוגה
				var displayData = query.ToList().Select(b =>
				{
					var read = Readability.GetById(b.ReadId);
					return new
					{
						b.BidId,
						b.ReadId,
						b.Status,
						b.Date,
						b.Price,
						b.ItemDescription,
						b.FullName,
						AssignedTechnicianId = read?.AssignedTechnicianId,
						ReadStatus = read?.Status ?? false,
						IsCallTaken = read?.Status ?? false,
						ShowTakeButton = b.Status && read?.Status == true 
					};
				}).ToList();

				System.Diagnostics.Debug.WriteLine($"נשלחים להצגה {displayData.Count} רשומות");

				if (displayData.Any())
				{
					gvBids.DataSource = displayData;
					gvBids.DataBind();
				}
				else
				{
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

				System.Diagnostics.Debug.WriteLine("=== סיום טעינת הצעות מחיר ===");
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
			System.Diagnostics.Debug.WriteLine("=== התחלת gvBids_RowCommand ===");
			System.Diagnostics.Debug.WriteLine($"CommandName: {e.CommandName}");

			if (e.CommandName == "AcceptCall")
			{
				try
				{
					int readId = Convert.ToInt32(e.CommandArgument);
					System.Diagnostics.Debug.WriteLine($"readId: {readId}");

					var call = Readability.GetById(readId);

					if (call != null)
					{
						System.Diagnostics.Debug.WriteLine($"CustomerId from call: {call.CusId}");
						System.Diagnostics.Debug.WriteLine($"TecId from Session: {Session["TecId"]}");

						// בדיקה אם יש טכנאי וגם לקוח
						if (Session["TecId"] != null)
						{
							// בדיקה אם הקריאה כבר נלקחה
							if (call.AssignedTechnicianId != null)
							{
								ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
									"Swal.fire('שגיאה', 'הקריאה כבר נלקחה על ידי טכנאי אחר', 'error');", true);
								return;
							}

							// עדכון הקריאה
							int techId = Convert.ToInt32(Session["TecId"]);
							call.AssignedTechnicianId = techId;
							call.Status = true;  // מעדכן את סטטוס הקריאה לסגור

							// שמירת ID של הלקוח אם צריך
							if (call.CusId != null)
							{
								call.CusId = call.CusId;  // או כל לוגיקה אחרת שצריך
							}

							call.UpdateReadability();

							ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
								"Swal.fire({" +
								"  title: 'הקריאה התקבלה'," +
								"  text: 'הקריאה הוקצתה לך בהצלחה'," +
								"  icon: 'success'," +
								"  timer: 2000," +
								"  showConfirmButton: false" +
								"});", true);

							LoadBids();
						}
						else
						{
							ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
								"Swal.fire('שגיאה', 'המשתמש לא מחובר', 'error');", true);
						}
					}
					else
					{
						ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
							"Swal.fire('שגיאה', 'לא נמצאה הקריאה', 'error');", true);
					}
				}
				catch (Exception ex)
				{
					System.Diagnostics.Debug.WriteLine($"שגיאה: {ex.Message}");
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



