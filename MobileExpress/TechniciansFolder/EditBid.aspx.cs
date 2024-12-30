using BLL;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.TechniciansFolder
{
	public partial class EditBid : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				//string bidId = Request.QueryString["id"];
				//if (!string.IsNullOrEmpty(bidId))
				//{
				//	LoadBidData(Convert.ToInt32(bidId));
				//}
				//else
				//{
				//	Response.Redirect("Forms.aspx");
				//}
				if (!int.TryParse(Request.QueryString["id"], out int bidId))
				{
					Response.Redirect("Forms.aspx");
					return;
				}

				// טעינת ההצעה
				var bid = BidDAL.GetById(bidId);
				if (bid == null)
				{
					Response.Redirect("Forms.aspx");
					return;
				}

				// בדיקה אם ההצעה מאושרת
				if (bid.Status)
				{
					ScriptManager.RegisterStartupScript(this, GetType(), "AlertAndRedirect",
						"alert('לא ניתן לערוך הצעת מחיר מאושרת'); window.location.href='Forms.aspx';", true);
					return;
				}

				// טעינת הנתונים לטופס
				LoadBidData(bidId);
			}
		}

		private void LoadBidData(int bidId)
		{
			var bid = BLL.Bid.GetById(bidId);
			var technician = BLL.Technicians.GetById(bid.TecId);
			var readability = BLL.Readability.GetById(bid.ReadId);

			if (bid != null)
			{
				// טעינת פרטי טכנאי
				lblTechNumber.Text = technician?.TecNum;
				lblTechName.Text = technician?.FulName;
				lblTechPhone.Text = technician?.Phone;

				// טעינת פרטי הצעת מחיר
				lblBidNumber.Text = bid.BidId.ToString();
				txtDate.Text = bid.Date.ToString("yyyy-MM-dd");
				lblReadId.Text = bid.ReadId.ToString();

				// טעינת פרטי לקוח
				if (readability != null)
				{
					txtCustomerName.Text = readability.FullName;
					txtCustomerPhone.Text = readability.Phone;
					txtDescription.Text = readability.Desc;
				}

				// טעינת פרטי פריט
				txtItemDescription.Text = bid.ItemDescription;
				txtQuantity.Text = bid.ItemQuantity.ToString();
				txtUnitPrice.Text = bid.ItemUnitPrice.ToString();
				//ddlStatus.SelectedValue = bid.Status.ToString().ToLower();

				// חישוב סכומים
				decimal subtotal = bid.ItemQuantity * bid.ItemUnitPrice;
				decimal vat = subtotal * 0.17m;
				decimal total = subtotal + vat;

				lblSubTotal.Text = subtotal.ToString("C");
				lblVat.Text = vat.ToString("C");
				lblTotal.Text = total.ToString("C");
			}
		}

		protected void btnSave_Click(object sender, EventArgs e)
		{
			int bidId = Convert.ToInt32(Request.QueryString["id"]);
			var bid = BLL.Bid.GetById(bidId);

			if (bid != null)
			{
				bid.ItemDescription = txtItemDescription.Text;
				bid.ItemQuantity = Convert.ToInt32(txtQuantity.Text);
				bid.ItemUnitPrice = Convert.ToDecimal(txtUnitPrice.Text);
				//bid.Status = Convert.ToBoolean(ddlStatus.SelectedValue);
				bid.Date = Convert.ToDateTime(txtDate.Text);

				bid.UpdateBid();

				ScriptManager.RegisterStartupScript(this, GetType(), "SaveSuccess",
					"alert('הצעת המחיר עודכנה בהצלחה'); window.location.href='Forms.aspx';", true);
			}
		}

		protected void btnCancel_Click(object sender, EventArgs e)
		{
			Response.Redirect("Forms.aspx");
		}
	}
}
