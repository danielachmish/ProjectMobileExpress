using BLL;
using DAL;
using Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
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
			}
		}

		private void LoadBids()
		{
			var bids = BLL.Bid.GetAll();
			gvBids.DataSource = bids;
			gvBids.DataBind();
		}

		protected void btnSearch_Click(object sender, EventArgs e)
		{
			// יישום חיפוש אם נדרש
		}

		protected void gvBids_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
		{
			// טיפול בפקודות של הטבלה
		}

		protected string GetStatusClass(bool status)
		{
			return status ? "badge badge-success" : "badge badge-danger";
		}

		protected string GetStatusText(bool status)
		{
			return status ? "פעיל" : "לא פעיל";
		}


		//[WebMethod]
		//public static string GetBidDetails(int bidId)
		//{
		//	try
		//	{
		//		System.Diagnostics.Debug.WriteLine($"GetBidDetails called with bidId: {bidId}");

		//		var bid = BLL.Bid.GetById(bidId);
		//		if (bid == null)
		//		{
		//			System.Diagnostics.Debug.WriteLine("Bid not found");
		//			return null;
		//		}

		//		var technician = BLL.Technicians.GetById(bid.TecId);
		//		var readability = BLL.Readability.GetById(bid.ReadId);

		//		var response = new BidDetailsResponse
		//		{
		//			BidNumber = bid.BidId,
		//			Date = bid.Date,
		//			ReadId = bid.ReadId,
		//			Status = bid.Status,
		//			TechnicianDetails = technician != null ? new TechnicianDetailsResponse
		//			{
		//				TechId = technician.TecId,
		//				TechNumber = technician.TecNum,
		//				Name = technician.FulName,
		//				Phone = technician.Phone
		//			} : null,
		//			CustomerDetails = readability != null ? new CustomerDetailsResponse
		//			{
		//				Name = readability.FullName,
		//				Phone = readability.Phone,
		//				Description = readability.Desc
		//			} : null,
		//			ItemDescription = bid.ItemDescription,
		//			ItemQuantity = bid.ItemQuantity,
		//			ItemUnitPrice = bid.ItemUnitPrice,
		//			ItemTotal = bid.ItemTotal,
		//			Subtotal = bid.Price / 1.17m,
		//			Vat = bid.Price - (bid.Price / 1.17m),
		//			Total = bid.Price
		//		};

		//		var json = JsonConvert.SerializeObject(response);
		//		System.Diagnostics.Debug.WriteLine($"Response JSON: {json}");
		//		return json;
		//	}
		//	catch (Exception ex)
		//	{
		//		System.Diagnostics.Debug.WriteLine($"Error in GetBidDetails: {ex.Message}");
		//		throw;
		//	}
		//}

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
			public string Name { get; set; }
			public string Phone { get; set; }
			public string Description { get; set; }
		}
	}
}


