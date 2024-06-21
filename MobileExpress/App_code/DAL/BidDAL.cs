using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using System.Diagnostics;
using Data;

namespace DAL
{
    public class BidDAL
    {
        // שמירת ביד חדש או עדכון ביד קיים
        public static void Save(Bid Tmp)
        {
            string Sql;
            if (Tmp.BidId == -1) // במקרה של יצירת ביד חדש
            {
                // שאילתת INSERT עם סוגריים מרובעים סביב השדות
                Sql = "INSERT INTO T_Bid ([Desc], [Price], [Status], [TecId], [ReadId], [Date])" +
                      " VALUES (@Desc, @Price, @Status, @TecId, @ReadId, @Date)";
            }
            else // במקרה של עדכון ביד קיים
            {
                // שאילתת UPDATE עם סוגריים מרובעים סביב השדות
                Sql = "UPDATE T_Bid SET [Desc]=@Desc, [Price]=@Price, [Status]=@Status, [TecId]=@TecId, [ReadId]=@ReadId, [Date]=@Date WHERE [BidId]=@BidId";
            }

            // יצירת אובייקט DbContext לביצוע פעולות על בסיס הנתונים
            DbContext Db = new DbContext();

            // יצירת אובייקט עם הפרמטרים לשאילתה
            var Obj = new
            {
                BidId = Tmp.BidId,
                Desc = Tmp.Desc,
                Price = Tmp.Price,
                Status = Tmp.Status,
                TecId = Tmp.TecId,
                ReadId = Tmp.ReadId,
                Date = Tmp.Date
            };

            // יצירת פרמטרים לשאילתה
            var LstParma = DbContext.CreateParameters(Obj);

            // ביצוע השאילתה
            Db.ExecuteNonQuery(Sql, LstParma);

            // סגירת חיבור לבסיס הנתונים
            Db.Close();
        }

        // אחזור כל הבידים
        public static List<Bid> GetAll()
        {
            List<Bid> BidList = new List<Bid>();
            string sql = "SELECT * FROM T_Bid"; // שאילתת SELECT
            DbContext Db = new DbContext();
            DataTable Dt = Db.Execute(sql);

            try
            {
                // לולאה לעבור על כל השורות שהוחזרו מהשאילתה וליצור אובייקטים של Bid
                for (int i = 0; i < Dt.Rows.Count; i++)
                {
                    Bid Tmp = new Bid()
                    {
                        BidId = int.Parse(Dt.Rows[i]["BidId"].ToString()),
                        Desc = Dt.Rows[i]["Desc"].ToString(),
                        Price = int.Parse(Dt.Rows[i]["Price"].ToString()),
                        TecId = int.Parse(Dt.Rows[i]["TecId"].ToString()),
                        ReadId = int.Parse(Dt.Rows[i]["ReadId"].ToString()),
                        Date = DateTime.Parse(Dt.Rows[i]["Date"].ToString()),
                        Status = Convert.ToBoolean(Dt.Rows[i]["Status"])
                    };

                    // הוספת האובייקט לרשימה
                    BidList.Add(Tmp);
                }
            }
            catch (Exception ex)
            {
                // טיפול בשגיאה - רישום השגיאה לקונסול
                Console.WriteLine("Exception: " + ex.Message);
            }
            finally
            {
                // סגירת חיבור לבסיס הנתונים
                Db.Close();
            }

            // החזרת הרשימה
            return BidList;
        }

        // אחזור ביד לפי מזהה
        public static Bid GetById(int Id)
        {
            Bid Tmp = null;
            string sql = $"SELECT * FROM T_Bid WHERE [BidId] = {Id}"; // שאילתת SELECT עם תנאי
            DbContext Db = new DbContext();
            DataTable Dt = Db.Execute(sql);

            if (Dt.Rows.Count > 0)
            {
                // יצירת אובייקט Bid מהשורה הראשונה שהוחזרה
                Tmp = new Bid()
                {
                    BidId = int.Parse(Dt.Rows[0]["BidId"].ToString()),
                    Desc = Dt.Rows[0]["Desc"].ToString(),
                    Price = int.Parse(Dt.Rows[0]["Price"].ToString()),
                    TecId = int.Parse(Dt.Rows[0]["TecId"].ToString()),
                    ReadId = int.Parse(Dt.Rows[0]["ReadId"].ToString()),
                    Date = DateTime.Parse(Dt.Rows[0]["Date"].ToString()),
                    Status = Convert.ToBoolean(Dt.Rows[0]["Status"])
                };
            }

            // סגירת חיבור לבסיס הנתונים
            Db.Close();
            return Tmp;
        }

        // מחיקת ביד לפי מזהה
        public static int DeleteById(int Id)
        {
            string Sql = $"DELETE FROM T_Bid WHERE [BidId] = {Id}"; // שאילתת DELETE
            DbContext Db = new DbContext();
            int Total = Db.ExecuteNonQuery(Sql);
            Db.Close();

            // החזרת תוצאה בהתאם למספר השורות שנמחקו
            return Total > 0 ? 1 : -1;
        }
    }
}
