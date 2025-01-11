using BLL;
using Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MobileExpress.Manage
{
	public partial class SerProdList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				Bindserprod();
			}
		}

		private void Bindserprod()
		{
			List<SerProd> SerProdList = SerProd.GetAll();
			Repeater2.DataSource = SerProdList;
			Repeater2.DataBind();
		}

		public void Delete(int SerProdId)
		{
			SerProd.DeleteById(SerProdId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int serprodID = Convert.ToInt32(btn.CommandArgument);
			Delete(serprodID);
			Bindserprod(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void Deleteserprod(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					SerProd.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting serprod.", ex);
			}
		}


		protected void SaveSerProd(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת מנהל -------------");

				// קריאת הנתונים מהטופס
				string Desc = txtDesc.Text;
				float Price = float.Parse(txtPrice.Text);
				string NameImage = txtNameImage.Text;
				string Nots = txtNots.Text;
				
				// אתחול Status לברירת מחדל true
				bool Status = true;  // או false, תלוי בלוגיקה העסקית שלך

				// בדיקת תקינות השדות
				ValidateFields(Desc, Price.ToString(), NameImage, Nots);

				HiddenField hfSerProdId = (HiddenField)form1.FindControl("hfSerProdId");

				var serprod = new SerProd
				{
					SerProdId = hfSerProdId != null && !string.IsNullOrEmpty(hfSerProdId.Value) &&
							 int.TryParse(hfSerProdId.Value, out int SerProdId) ? SerProdId : 0,
					Desc = Desc,
					Price = Price,
					NameImage = NameImage,
					Status = Status,
					Nots = Nots
				};

				if (serprod.SerProdId == 0)
				{
					serprod.SaveNewSerProd();
					System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
				}
				else
				{
					serprod.UpdateSerProd();
					System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
				}

				// רענון הטבלה
				Bindserprod();

				// סגירת המודל ורענון העמוד
				ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript",
					"closeModal(); console.log('Modal closed after save');", true);

				if (!Response.IsRequestBeingRedirected)
				{
					Response.Redirect(Request.RawUrl, false);
					Context.ApplicationInstance.CompleteRequest();
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת מנהל: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				throw;  // חשוב לזרוק את השגיאה כדי שנוכל לראות אותה
			}
		}

		private void ValidateFields(params string[] fields)
		{
			string[] fieldNames = { "Desc", "Price", "NameImage", "Nots" };
			for (int i = 0; i < fields.Length; i++)
			{
				if (string.IsNullOrEmpty(fields[i]))
				{
					throw new ArgumentException($"השדה {fieldNames[i]} הוא חובה");
				}
			}
		}

		

		[WebMethod]
		public static void UpdateserprodStatus(int SerProdId, bool Status)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("מתחיל עדכון סטטוס מנהל...");

				string sql = "UPDATE T_SerProd SET Status = @Status WHERE SerProdId = @SerProdId";
				System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						SerProdId = SerProdId,
						Status = Convert.ToInt32(Status)  // המרה ל-TINYINT
					};

					var LstParma = DbContext.CreateParameters(Obj);
					int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);

					System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {rowsAffected}");

					if (rowsAffected > 0)
					{
						System.Diagnostics.Debug.WriteLine($"הסטטוס של מנהל {SerProdId} עודכן בהצלחה ל-{Status}");
					}
					else
					{
						System.Diagnostics.Debug.WriteLine($"לא נמצא מנהל עם מזהה {SerProdId}");
					}
				}
				finally
				{
					Db.Close(); // סגירת החיבור
					System.Diagnostics.Debug.WriteLine("החיבור לדאטאבייס נסגר");
				}
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בעדכון סטטוס מנהל: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				throw;
			}
		}
	}
}