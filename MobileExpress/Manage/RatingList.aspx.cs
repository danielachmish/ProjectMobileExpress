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
	public partial class RatingList : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

			if (!IsPostBack)
			{
				Bindrating();
			}
		}

		private void Bindrating()
		{
			List<Rating> RatingList = Rating.GetAll();
			Repeater2.DataSource = RatingList;
			Repeater2.DataBind();
		}

		public void Delete(int RatingId)
		{
			Rating.DeleteById(RatingId);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int ratingID = Convert.ToInt32(btn.CommandArgument);
			Delete(ratingID);
			Bindrating(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void Deleterating(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					Rating.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting administrators.", ex);
			}
		}


		protected void Saverating(object sender, EventArgs e)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת מנהל -------------");

				// קריאת הנתונים מהטופס
				
				string Grade = txtGrade.Text;
				string Description = txtDescription.Text;
				int TecId = int.Parse(txtTecId.Text);
				int CusId = int.Parse(txtCusId.Text);
				string Comment = txtComment.Text;



				// בדיקת תקינות השדות
				ValidateFields( Grade, Description, TecId.ToString(), CusId.ToString(), Comment);

				HiddenField hfRatingId = (HiddenField)form1.FindControl("hfRatingId");

				var rating = new Rating
				{
					RatingId = hfRatingId != null && !string.IsNullOrEmpty(hfRatingId.Value) &&
							 int.TryParse(hfRatingId.Value, out int RatingId) ? RatingId : 0,
					Date = DateTime.Now,
					Grade = Grade,
					Description = Description,
					TecId = TecId,
					CusId = CusId,
					Comment = Comment
				};

				if (rating.RatingId == 0)
				{
					rating.SaveNewRating();
					System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
				}
				else
				{
					rating.UpdateRating();
					System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
				}

				// רענון הטבלה
				Bindrating();

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
			string[] fieldNames = {  "Grade", "Description", "TecId", "CusId", "Comment" };
			for (int i = 0; i < fields.Length; i++)
			{
				if (string.IsNullOrEmpty(fields[i]))
				{
					throw new ArgumentException($"השדה {fieldNames[i]} הוא חובה");
				}
			}
		}

		[WebMethod]
		public static void UpdateratingStatus(int RatingId, bool Status)
		{
			try
			{
				System.Diagnostics.Debug.WriteLine("מתחיל עדכון סטטוס מנהל...");

				string sql = "UPDATE T_Rating SET Status = @Status WHERE RatingId = @RatingId";
				System.Diagnostics.Debug.WriteLine($"SQL Query: {sql}");

				DbContext Db = new DbContext();
				try
				{
					var Obj = new
					{
						RatingId = RatingId,
						Status = Convert.ToInt32(Status)  // המרה ל-TINYINT
					};

					var LstParma = DbContext.CreateParameters(Obj);
					int rowsAffected = Db.ExecuteNonQuery(sql, LstParma);

					System.Diagnostics.Debug.WriteLine($"מספר שורות שהושפעו: {rowsAffected}");

					if (rowsAffected > 0)
					{
						System.Diagnostics.Debug.WriteLine($"הסטטוס של מנהל {RatingId} עודכן בהצלחה ל-{Status}");
					}
					else
					{
						System.Diagnostics.Debug.WriteLine($"לא נמצא מנהל עם מזהה {RatingId}");
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
	
