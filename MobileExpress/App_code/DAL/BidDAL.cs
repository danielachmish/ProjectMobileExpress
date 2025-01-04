using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Data.SqlClient;
using BLL;
using System.Diagnostics;
using Data;
using System.Configuration;

namespace DAL
{





	public class BidDAL
	{
		public static int Save(Bid bid)
		{
			DbContext db = new DbContext();
			try
			{
				string sql;
				var parameters = new List<SqlParameter>
		{       new SqlParameter("@Desc", SqlDbType.NVarChar){Value = string.IsNullOrWhiteSpace(bid.Desc) ? "תיאור ברירת מחדל" : (object)bid.Desc},

			//new SqlParameter("@Desc", SqlDbType.NVarChar) { Value = string.IsNullOrEmpty(bid.Desc) ? DBNull.Value : (object)bid.Desc },
			new SqlParameter("@Price", SqlDbType.Decimal) { Value = bid.Price, Precision = 18, Scale = 2 },
			new SqlParameter("@Status", SqlDbType.Bit) { Value = bid.Status },
			new SqlParameter("@TecId", SqlDbType.Int) { Value = bid.TecId },
			new SqlParameter("@ReadId", SqlDbType.Int) { Value = bid.ReadId },
				new SqlParameter("@FullName", SqlDbType.NVarChar) { Value = string.IsNullOrEmpty(bid.FullName) ? DBNull.Value : (object)bid.FullName },
			new SqlParameter("@Date", SqlDbType.DateTime) { Value = bid.Date },
			new SqlParameter("@ItemDescription", SqlDbType.NVarChar) { Value = string.IsNullOrEmpty(bid.ItemDescription) ? DBNull.Value : (object)bid.ItemDescription },
			new SqlParameter("@ItemQuantity", SqlDbType.Int) { Value = bid.ItemQuantity },
			new SqlParameter("@ItemUnitPrice", SqlDbType.Decimal) { Value = bid.ItemUnitPrice, Precision = 18, Scale = 2 }
		};

				if (bid.BidId <= 0)
				{
					sql = @"INSERT INTO T_Bid (
                    [Desc], Price, Status, TecId, ReadId, Date,FullName,
                    ItemDescription, ItemQuantity, ItemUnitPrice)
                OUTPUT INSERTED.BidId
                VALUES (
                    @Desc, @Price, @Status, @TecId, @ReadId, @Date,@FullName,
                    @ItemDescription, @ItemQuantity, @ItemUnitPrice)";
				}
				else
				{
					sql = @"UPDATE T_Bid 
                    SET [Desc]=@Desc, Price=@Price, Status=@Status,
                        TecId=@TecId, ReadId=@ReadId, Date=@Date,FullName=@FullName,
                        ItemDescription=@ItemDescription, 
                        ItemQuantity=@ItemQuantity,
                        ItemUnitPrice=@ItemUnitPrice
                    WHERE BidId=@BidId;
                    SELECT @BidId";
					parameters.Add(new SqlParameter("@BidId", SqlDbType.Int) { Value = bid.BidId });
				}
				System.Diagnostics.Debug.WriteLine($"FullName value before save: {bid.FullName}");
				return Convert.ToInt32(db.ExecuteScalar(sql, parameters));
			}
			catch (Exception ex)
			{
				System.Diagnostics.Debug.WriteLine($"שגיאה בשמירת הצעת מחיר: {ex.Message}");
				throw;
			}
			finally
			{
				db.Close();
			}
		}

		public static Bid GetById(int id)
		{
			DbContext db = new DbContext();
			try
			{
				//string sql = "SELECT * FROM T_Bid WHERE BidId = @BidId";
				string sql = @"SELECT b.*, r.FullName 
                      FROM T_Bid b 
                      LEFT JOIN T_Readability r ON b.ReadId = r.ReadId 
                      WHERE b.BidId = @BidId";
				var parameters = new List<SqlParameter>
		{
			new SqlParameter("@BidId", id)
		};

				DataTable dt = db.Execute(sql, parameters.ToArray());

				if (dt.Rows.Count > 0)
				{
					var row = dt.Rows[0];
					return new Bid
					{
						BidId = Convert.ToInt32(row["BidId"]),
						Desc = row["Desc"]?.ToString(),
						Price = row["Price"] != DBNull.Value ? Convert.ToDecimal(row["Price"]) : 0m,
						Status = row["Status"] != DBNull.Value ? Convert.ToBoolean(row["Status"]) : false,
						TecId = Convert.ToInt32(row["TecId"]),
						ReadId = Convert.ToInt32(row["ReadId"]),
						Date = Convert.ToDateTime(row["Date"]),
						FullName = row["FullName"]?.ToString() ?? "לא צוין",

						// בדיקת NULL לשדות החדשים
						ItemDescription = row["ItemDescription"] != DBNull.Value ? row["ItemDescription"].ToString() : null,
						ItemQuantity = row["ItemQuantity"] != DBNull.Value ? Convert.ToInt32(row["ItemQuantity"]) : 0,
						ItemUnitPrice = row["ItemUnitPrice"] != DBNull.Value ? Convert.ToDecimal(row["ItemUnitPrice"]) : 0m
					};
				}
				return null;
			}
			finally
			{
				db.Close();
			}

		}

		public static List<Bid> GetAll()
		{
			DbContext db = new DbContext();
			try
			{
				//string sql = "SELECT * FROM T_Bid";
				string sql = @"SELECT b.*, r.FullName 
               FROM T_Bid b 
               LEFT JOIN T_Readability r ON b.ReadId = r.ReadId";
				DataTable dt = db.Execute(sql);
				List<Bid> bids = new List<Bid>();

				foreach (DataRow row in dt.Rows)
				{
					try
					{
						var bid = new Bid
						{
							BidId = Convert.ToInt32(row["BidId"]),
							Desc = row["Desc"]?.ToString(),
							Price = row["Price"] != DBNull.Value ? Convert.ToDecimal(row["Price"]) : 0m,
							Status = row["Status"] != DBNull.Value ? Convert.ToBoolean(row["Status"]) : false,
							TecId = Convert.ToInt32(row["TecId"]),
							ReadId = Convert.ToInt32(row["ReadId"]),
							FullName = row["FullName"]?.ToString() ?? "לא צוין",
							Date = Convert.ToDateTime(row["Date"])

						};

						// בדיקת קיום העמודות החדשות
						if (dt.Columns.Contains("ItemDescription"))
						{
							bid.ItemDescription = row["ItemDescription"] != DBNull.Value ?
								row["ItemDescription"].ToString() : null;
						}

						if (dt.Columns.Contains("ItemQuantity"))
						{
							bid.ItemQuantity = row["ItemQuantity"] != DBNull.Value ?
								Convert.ToInt32(row["ItemQuantity"]) : 0;
						}

						if (dt.Columns.Contains("ItemUnitPrice"))
						{
							bid.ItemUnitPrice = row["ItemUnitPrice"] != DBNull.Value ?
								Convert.ToDecimal(row["ItemUnitPrice"]) : 0m;
						}

						bids.Add(bid);
					}
					catch (Exception ex)
					{
						System.Diagnostics.Debug.WriteLine($"Error processing bid: {ex.Message}");
						// ממשיך לרשומה הבאה במקרה של שגיאה
						continue;
					}
				}
				return bids;
			}
			finally
			{
				db.Close();
			}
		}
		public static List<Bid> GetByReadId(int readId)
		{
			DbContext db = new DbContext();
			try
			{
				string sql = @"SELECT b.*, r.FullName 
                       FROM T_Bid b
                       LEFT JOIN T_Readability r ON b.ReadId = r.ReadId
                       WHERE b.ReadId = @ReadId";

				var parameters = new List<SqlParameter>
		{
			new SqlParameter("@ReadId", readId)
		};

				DataTable dt = db.Execute(sql, parameters.ToArray());
				List<Bid> bids = new List<Bid>();

				foreach (DataRow row in dt.Rows)
				{
					try
					{
						var bid = new Bid
						{
							BidId = Convert.ToInt32(row["BidId"]),
							Desc = row["Desc"]?.ToString(),
							Price = row["Price"] != DBNull.Value ? Convert.ToDecimal(row["Price"]) : 0m,
							Status = row["Status"] != DBNull.Value ? Convert.ToBoolean(row["Status"]) : false,
							TecId = Convert.ToInt32(row["TecId"]),
							ReadId = Convert.ToInt32(row["ReadId"]),
							FullName = row["FullName"]?.ToString() ?? "לא צוין",
							Date = Convert.ToDateTime(row["Date"]),

							// שדות חדשים
							ItemDescription = row["ItemDescription"] != DBNull.Value ? row["ItemDescription"].ToString() : null,
							ItemQuantity = row["ItemQuantity"] != DBNull.Value ? Convert.ToInt32(row["ItemQuantity"]) : 0,
							ItemUnitPrice = row["ItemUnitPrice"] != DBNull.Value ? Convert.ToDecimal(row["ItemUnitPrice"]) : 0m
						};

						bids.Add(bid);
					}
					catch (Exception ex)
					{
						System.Diagnostics.Debug.WriteLine($"Error processing bid: {ex.Message}");
						continue;
					}
				}

				return bids;
			}
			finally
			{
				db.Close();
			}
		}


		public static int DeleteById(int id)
		{
			DbContext db = new DbContext();
			try
			{
				string sql = "DELETE FROM T_Bid WHERE BidId = @BidId";
				var parameters = new List<SqlParameter>
			{
				new SqlParameter("@BidId", id)
			};
				return db.ExecuteNonQuery(sql, parameters);
			}
			finally
			{
				db.Close();
			}
		}
		public static decimal GetTotalBids()
		{
			string sql = "SELECT SUM(Price) FROM T_Bid";
			DbContext db = new DbContext();

			try
			{
				var parameters = new List<SqlParameter>();
				object result = db.ExecuteScalar(sql, parameters);
				return result != DBNull.Value ? Convert.ToDecimal(result) : 0;
			}
			finally
			{
				db.Close();
			}
		}
		public static decimal GetTechnicianTotalBids(int technicianId)
		{
			string sql = "SELECT SUM(Price) FROM T_Bid WHERE TecId = @TecId";
			DbContext db = new DbContext();
			try
			{
				var parameters = new List<SqlParameter>
		{
			new SqlParameter("@TecId", SqlDbType.Int) { Value = technicianId }
		};
				object result = db.ExecuteScalar(sql, parameters);
				return result != DBNull.Value ? Convert.ToDecimal(result) : 0;
			}
			finally
			{
				db.Close();
			}
		}
	}
}
