using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace MobileExpress.Manage
{
	public partial class PageContentList : System.Web.UI.Page
	{
		

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				BindPageContent();
			}
		}

		private void BindPageContent()
		{
			List<PageContent> PageContentList = PageContent.GetAll();
			RepeaterPageContent.DataSource = PageContentList;
			RepeaterPageContent.DataBind();
		}

			public void Delete(int Id)
		{
			PageContent.DeleteById(Id);
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{
			LinkButton btn = (LinkButton)sender;
			int ID = Convert.ToInt32(btn.CommandArgument);
			Delete(ID);
			BindPageContent(); // רענון הרשימה לאחר המחיקה
		}

		[WebMethod]
		public static void BindPageContentfacturers(List<int> ids)
		{
			if (ids == null || !ids.Any())
			{
				throw new ArgumentException("No IDs provided");
			}

			try
			{
				foreach (int id in ids)
				{
					PageContent.DeleteById(id);
				}
			}
			catch (Exception ex)
			{
				throw new Exception("An error occurred while deleting manufacturers.", ex);
			}
		}




		protected void SavePageContentfacturers(object sender, EventArgs e)
		{
			try
			{
				//System.Diagnostics.Debug.WriteLine("------------- התחלת תהליך שמירת לקוחות -------------");
				//HiddenField hfPageContentId = (HiddenField)form1.FindControl("hfPageContentId");
				//System.Diagnostics.Debug.WriteLine($"hfPageContentId נמצא: {hfPageContentId != null}, ערך: {hfPageContentId?.Value}");

				string SectionName = txtSectionName.Text;
				string Content = txtContent.Text;
				DateTime LastUpdated = DateTime.Now;
				//bool IsActive = txtIsActive;


				//System.Diagnostics.Debug.WriteLine($"נתונים שהתקבלו: Id={hfPageContentId?.Value}, SectionName={SectionName}, Content={Content}, LastUpdated={LastUpdated},IsActive={IsActive}");

				System.Diagnostics.Debug.WriteLine("מתחיל תהליך אימות שדות");
				ValidateFields(SectionName, Content/*LastUpdated*/ /*IsActive*/);
				System.Diagnostics.Debug.WriteLine("אימות שדות הסתיים בהצלחה");

				var PageContent = new PageContent
				{
					Id = hfPageContentId != null && !string.IsNullOrEmpty(hfPageContentId.Value) && int.TryParse(hfPageContentId.Value, out int Id) ? Id : 0,
					SectionName = SectionName,
					Content = Content,
					LastUpdated = DateTime.Now,
					//IsActive = IsActive,
				};

				System.Diagnostics.Debug.WriteLine($"אובייקט PageContent נוצר: Id={PageContent.Id}, SectionName={PageContent.SectionName}, Content={PageContent.Content}, LastUpdated={PageContent.LastUpdated}, IsActive={PageContent.IsActive}");

				if (PageContent.Id == 0 || PageContent.Id == -1)
				{
					System.Diagnostics.Debug.WriteLine("מוסיף מנהל חדש");
					PageContent.SaveNewPageContent();
					System.Diagnostics.Debug.WriteLine("מנהל חדש נוסף בהצלחה");
				}
				else
				{
					System.Diagnostics.Debug.WriteLine($"עורך מנהל קיים עם מזהה: {PageContent.Id}");
					PageContent.UpdatePageContent();
					System.Diagnostics.Debug.WriteLine("נתוני המנהל עודכנו בהצלחה");
				}

				System.Diagnostics.Debug.WriteLine("מתחיל BindPageContent");
				BindPageContent();
				System.Diagnostics.Debug.WriteLine("BindPageContent הסתיים");

				System.Diagnostics.Debug.WriteLine("רושם סקריפט JavaScript לסגירת המודל");
				ScriptManager.RegisterStartupScript(this, GetType(), "closeModalScript", "closeModal(); console.log('Modal closed after save');", true);

				System.Diagnostics.Debug.WriteLine("מבצע Redirect");
				//Response.Redirect(Request.RawUrl);
				if (!Response.IsRequestBeingRedirected)
				{
					Response.Redirect(Request.RawUrl, false);
					Context.ApplicationInstance.CompleteRequest();
				}
				return;
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת לקוח: {ex.Message}");
				System.Diagnostics.Debug.WriteLine($"סוג השגיאה: {ex.GetType().FullName}");
				System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
				Response.Write($"<script>console.error('שגיאה בשמירת לקוח: {ex.Message}'); alert('שגיאה בשמירת לקוח: {ex.Message}');</script>");
			}
			finally
			{
				System.Diagnostics.Debug.WriteLine("------------- סיום תהליך שמירת לקוחות -------------");
			}
		}

		private void ValidateFields(params string[] fields)
		{
			string[] fieldNames = { "ManuName", "Desc", "NameImage" };
			for (int i = 0; i < fields.Length; i++)
			{
				System.Diagnostics.Debug.WriteLine($"בודק שדה: {fieldNames[i]}, ערך: {fields[i]}");
				if (string.IsNullOrEmpty(fields[i]))
				{
					System.Diagnostics.Debug.WriteLine($"Validation Error: {fieldNames[i]} is missing or invalid");
					throw new Exception($"{fieldNames[i]} is missing or invalid");
				}
			}
			System.Diagnostics.Debug.WriteLine("כל השדות עברו אימות בהצלחה");
		}
	}
}
		