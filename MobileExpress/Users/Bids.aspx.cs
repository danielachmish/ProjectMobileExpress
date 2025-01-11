
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Newtonsoft.Json;
using JsonConverter = Newtonsoft.Json.JsonConvert;

namespace MobileExpress.Users
{
    public partial class Bids : System.Web.UI.Page
    {
      
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    LoadBids();

            //    string bidId = Request.QueryString["bidId"];
            //    if (!string.IsNullOrEmpty(bidId))
            //    {
            //        GetBidInfoJson(bidId);
            //    }
            //}
            if (!IsPostBack)
            {
                // בדיקה אם יש פרמטר ReadId ב-Query String
                string readIdParam = Request.QueryString["ReadId"];
                if (!string.IsNullOrEmpty(readIdParam) && int.TryParse(readIdParam, out int readId))
                {
                    // טעינת הצעות המחיר לפי ReadId
                    LoadBidsByReadId(readId);
                }
                else
                {
                    // טעינת כל ההצעות אם אין ReadId
                    LoadBids();
                }
            }
        }
        private void LoadBidsByReadId(int readId)
        {
            try
            {
                // קבלת הצעות מחיר לקריאה מבסיס הנתונים
                var bids = BLL.Bid.GetByReadId(readId);
                if (bids != null && bids.Count > 0)
                {
                    BidsRepeater.DataSource = bids;
                    BidsRepeater.DataBind();
                }
                else
                {
                    bidsContainer.InnerHtml = "<div class='no-bids'>אין הצעות מחיר לקריאה זו</div>";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in LoadBidsByReadId: {ex.Message}");
                bidsContainer.InnerHtml = "<div class='error-message'>אירעה שגיאה בטעינת הנתונים</div>";
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetBidInfoJson(string bidId)
        {
            System.Diagnostics.Debug.WriteLine($"GetBidInfoJson called with bidId: {bidId}");

            try
            {
                int id = Convert.ToInt32(bidId);
                var bid = BLL.Bid.GetById(id);

                if (bid == null)
                {
                    System.Diagnostics.Debug.WriteLine("No bid found");
                    return null;
                }

                var bidInfo = new
                {
                    ReadId = bid.ReadId,
                    Date = bid.Date.ToString("yyyy-MM-ddTHH:mm:ss"),
                    ItemDescription = bid.ItemDescription,
                    ItemQuantity = bid.ItemQuantity,
                    ItemUnitPrice = bid.ItemUnitPrice,
                    ItemTotal = bid.ItemTotal
                };

                var json = JsonConvert.SerializeObject(bidInfo);
                System.Diagnostics.Debug.WriteLine($"Returning JSON: {json}");
                return json;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetBidInfoJson: {ex.Message}");
                return null;
            }
        }

        private void LoadBids()
        {
            try
            {
                if (BidsRepeater != null)
                {
                    var bids = BLL.Bid.GetAll();
                    if (bids != null && bids.Count > 0)
                    {
                        BidsRepeater.DataSource = bids;
                        BidsRepeater.DataBind();
                    }
                    else
                    {
                        bidsContainer.InnerHtml = "<div class='no-bids'>אין הצעות מחיר</div>";
                    }
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("BidsRepeater is null");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in LoadBids: {ex.Message}");
            }
        }

        protected void UpdateBid(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string bidId = btn.CommandArgument;
            Response.Redirect($"EditBid.aspx?bidId={bidId}");
        }

        //protected void ApproveBid(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Button btn = (Button)sender;
        //        int bidId = Convert.ToInt32(btn.CommandArgument);
        //        var bid = BLL.Bid.GetById(bidId);

        //        if (bid != null)
        //        {
        //            // עדכון סטטוס ההצעה
        //            bid.Status = true;
        //            bid.Save();

        //            // עדכון הקריאה המקושרת
        //            var readability = Readability.GetById(bid.ReadId);
        //            if (readability != null)
        //            {
        //                readability.AssignedTechnicianId = bid.TecId;
        //                readability.UpdateReadability();
        //            }

        //            // הודעת הצלחה
        //            ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
        //                "Swal.fire({" +
        //                "  title: 'ההצעה אושרה'," +
        //                "  text: 'ההצעה אושרה בהצלחה והקריאה הועברה לטכנאי'," +
        //                "  icon: 'success'," +
        //                "  timer: 2000," +
        //                "  showConfirmButton: false" +
        //                "});", true);

        //            LoadBids();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        System.Diagnostics.Debug.WriteLine($"Error in ApproveBid: {ex.Message}");
        //        ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
        //            "Swal.fire('שגיאה', 'אירעה שגיאה באישור ההצעה', 'error');", true);
        //    }
        //}

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

                    // עדכון הקריאה המקושרת
                    var readability = Readability.GetById(bid.ReadId);
                    if (readability != null)
                    {
                        //readability.AssignedTechnicianId = bid.TecId;
                        readability.CallStatus = CallStatus.InProgress; // מסמן שהקריאה סגורה/נבחרה הצעה
                        readability.UpdateReadability();
                    }

                    // הודעת הצלחה
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
                        "Swal.fire({" +
                        "  title: 'ההצעה אושרה'," +
                        "  text: 'ההצעה אושרה בהצלחה והקריאה הועברה לטכנאי'," +
                        "  icon: 'success'," +
                        "  timer: 2000," +
                        "  showConfirmButton: false" +
                        "});", true);
                    LoadBids();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in ApproveBid: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                    "Swal.fire('שגיאה', 'אירעה שגיאה באישור ההצעה', 'error');", true);
            }
        }

        protected void RefreshTimer_Tick(object sender, EventArgs e)
        {
            LoadBids();
        }
        //protected void ApproveBid(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        Button btn = (Button)sender;
        //        int bidId = Convert.ToInt32(btn.CommandArgument);
        //        var bid = BLL.Bid.GetById(bidId);

        //        if (bid != null)
        //        {
        //            // עדכון סטטוס ההצעה
        //            bid.Status = true;
        //            bid.Save();

        //            // עדכון הקריאה המקושרת
        //            var readability = Readability.GetById(bid.ReadId);
        //            if (readability != null)
        //            {
        //                readability.AssignedTechnicianId = bid.TecId;
        //                readability.Status = false; // false = פתוח לטיפול הטכנאי
        //                readability.UpdateReadability();
        //            }

        //            ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
        //                "Swal.fire({" +
        //                "  title: 'ההצעה אושרה'," +
        //                "  text: 'ההצעה אושרה בהצלחה והקריאה הועברה לטכנאי'," +
        //                "  icon: 'success'," +
        //                "  timer: 2000," +
        //                "  showConfirmButton: false" +
        //                "});", true);

        //            LoadBids();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        System.Diagnostics.Debug.WriteLine($"Error in ApproveBid: {ex.Message}");
        //        ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
        //            "Swal.fire('שגיאה', 'אירעה שגיאה באישור ההצעה', 'error');", true);
        //    }
        //}
    }
}