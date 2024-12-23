using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Data.SqlClient;
using BLL;
using System.Diagnostics;
using Data;


namespace DAL
{
	//public class BidDAL
	//{
	//public static int Save(Bid bid)
	//{
	//	DbContext db = new DbContext();
	//	try
	//	{
	//		string bidSql;
	//		List<SqlParameter> bidParams = new List<SqlParameter>();

	//		// הוספת כל הפרמטרים הנדרשים
	//		bidParams.Add(new SqlParameter("@Desc", bid.Desc));
	//		bidParams.Add(new SqlParameter("@Price", bid.Price));
	//		bidParams.Add(new SqlParameter("@Status", bid.Status));
	//		bidParams.Add(new SqlParameter("@TecId", bid.TecId));
	//		bidParams.Add(new SqlParameter("@ReadId", bid.ReadId));
	//		bidParams.Add(new SqlParameter("@Date", bid.Date));

	//		if (bid.BidId <= 0)
	//		{
	//			bidSql = @"INSERT INTO T_Bid ([Desc], [Price], [Status], [TecId], [ReadId], [Date])
	//                            OUTPUT INSERTED.BidId
	//                            VALUES (@Desc, @Price, @Status, @TecId, @ReadId, @Date)";
	//		}
	//		else
	//		{
	//			bidSql = @"UPDATE T_Bid 
	//                            SET [Desc]=@Desc, [Price]=@Price, [Status]=@Status, 
	//                                [TecId]=@TecId, [ReadId]=@ReadId, [Date]=@Date 
	//                            WHERE [BidId]=@BidId;
	//                            SELECT @BidId;";
	//			bidParams.Add(new SqlParameter("@BidId", bid.BidId));
	//		}

	//		// שמירת ההצעה וקבלת ה-ID
	//		int bidId = Convert.ToInt32(db.ExecuteScalar(bidSql, bidParams));

	//		// טיפול בפריטים
	//		if (bid.Items != null && bid.Items.Count > 0)
	//		{
	//			if (bid.BidId > 0)
	//			{
	//				// מחיקת פריטים קיימים
	//				string deleteItemsSql = "DELETE FROM T_BidItem WHERE BidId = @BidId";
	//				var deleteParam = new List<SqlParameter>
	//				{
	//					new SqlParameter("@BidId", bidId)
	//				};
	//				db.ExecuteNonQuery(deleteItemsSql, deleteParam);
	//			}

	//			// הוספת פריטים חדשים
	//			string itemSql = @"INSERT INTO T_BidItem (BidId, [Description], Quantity, UnitPrice, Total)
	//                                   VALUES (@BidId, @Description, @Quantity, @UnitPrice, @Total)";

	//			foreach (var item in bid.Items)
	//			{
	//				var itemParams = new List<SqlParameter>
	//				{
	//					new SqlParameter("@BidId", bidId),
	//					new SqlParameter("@Description", item.Description),
	//					new SqlParameter("@Quantity", item.Quantity),
	//					new SqlParameter("@UnitPrice", item.UnitPrice),
	//					new SqlParameter("@Total", item.Total)
	//				};
	//				db.ExecuteNonQuery(itemSql, itemParams);
	//			}
	//		}

	//		return bidId;
	//	}
	//	finally
	//	{
	//		db.Close();
	//	}
	//}



	//public static List<Bid> GetAll()
	//{
	//	List<Bid> bidList = new List<Bid>();
	//	DbContext db = new DbContext();
	//	try
	//	{
	//		string sql = "SELECT * FROM T_Bid";
	//		DataTable dt = db.Execute(sql);

	//		foreach (DataRow row in dt.Rows)
	//		{
	//			var bid = new Bid
	//			{
	//				BidId = Convert.ToInt32(row["BidId"]),
	//				Desc = row["Desc"].ToString(),
	//				Price = Convert.ToInt32(row["Price"]),
	//				Status = Convert.ToBoolean(row["Status"]),
	//				TecId = Convert.ToInt32(row["TecId"]),
	//				ReadId = Convert.ToInt32(row["ReadId"]),
	//				Date = Convert.ToDateTime(row["Date"]),
	//				Items = GetBidItems(Convert.ToInt32(row["BidId"]))
	//			};
	//			bidList.Add(bid);
	//		}
	//	}
	//	finally
	//	{
	//		db.Close();
	//	}
	//	return bidList;
	//}

	//public static Bid GetById(int id)
	//{
	//	DbContext db = new DbContext();
	//	try
	//	{
	//		string sql = $"SELECT * FROM T_Bid WHERE BidId = {id}";
	//		DataTable dt = db.Execute(sql);

	//		if (dt.Rows.Count > 0)
	//		{
	//			var row = dt.Rows[0];
	//			return new Bid
	//			{
	//				BidId = Convert.ToInt32(row["BidId"]),
	//				Desc = row["Desc"].ToString(),
	//				Price = Convert.ToInt32(row["Price"]),
	//				Status = Convert.ToBoolean(row["Status"]),
	//				TecId = Convert.ToInt32(row["TecId"]),
	//				ReadId = Convert.ToInt32(row["ReadId"]),
	//				Date = Convert.ToDateTime(row["Date"]),
	//				Items = GetBidItems(Convert.ToInt32(row["BidId"]))
	//			};
	//		}
	//		return null;
	//	}
	//	finally
	//	{
	//		db.Close();
	//	}
	//}

	//public static List<BidItem> GetBidItems(int bidId)
	//{
	//	try
	//	{
	//		using (var conn = new SqlConnection(ConnectionString))
	//		{
	//			conn.Open();
	//			var query = @"SELECT ItemId, BidId, Description, Quantity, UnitPrice, Total 
	//                          FROM BidItems WHERE BidId = @BidId";

	//			using (var cmd = new SqlCommand(query, conn))
	//			{
	//				cmd.Parameters.AddWithValue("@BidId", bidId);
	//				var items = new List<BidItem>();

	//				using (var reader = cmd.ExecuteReader())
	//				{
	//					while (reader.Read())
	//					{
	//						items.Add(new BidItem
	//						{
	//							ItemId = reader.GetInt32(0),
	//							BidId = reader.GetInt32(1),
	//							Description = reader.GetString(2),
	//							Quantity = reader.GetInt32(3),
	//							UnitPrice = reader.GetDecimal(4),
	//							Total = reader.GetDecimal(5)
	//						});
	//					}
	//				}
	//				return items;
	//			}
	//		}
	//	}
	//	catch (Exception ex)
	//	{
	//		System.Diagnostics.Debug.WriteLine($"Error getting bid items: {ex.Message}");
	//		throw;
	//	}
	//}

	//public static void SaveBidItem(BidItem item)
	//{
	//	using (var conn = new SqlConnection(ConnectionString))
	//	{
	//		conn.Open();
	//		var query = @"INSERT INTO BidItems (BidId, Description, Quantity, UnitPrice) 
	//                       VALUES (@BidId, @Description, @Quantity, @UnitPrice)";

	//		using (var cmd = new SqlCommand(query, conn))
	//		{
	//			cmd.Parameters.AddWithValue("@BidId", item.BidId);
	//			cmd.Parameters.AddWithValue("@Description", item.Description);
	//			cmd.Parameters.AddWithValue("@Quantity", item.Quantity);
	//			cmd.Parameters.AddWithValue("@UnitPrice", item.UnitPrice);
	//			cmd.ExecuteNonQuery();
	//		}
	//	}
	//}

	//public static void DeleteBidItems(int bidId)
	//{
	//	using (var conn = new SqlConnection(ConnectionString))
	//	{
	//		conn.Open();
	//		var query = "DELETE FROM BidItems WHERE BidId = @BidId";

	//		using (var cmd = new SqlCommand(query, conn))
	//		{
	//			cmd.Parameters.AddWithValue("@BidId", bidId);
	//			cmd.ExecuteNonQuery();
	//		}
	//	}
	//}
}

//private static List<BidItem> GetBidItems(int bidId)
//{
//    List<BidItem> items = new List<BidItem>();
//    DbContext db = new DbContext();
//    try
//    {
//        string sql = "SELECT * FROM T_BidItems WHERE BidId = @BidId";
//        var parameters = new List<SqlParameter>
//        {
//            new SqlParameter("@BidId", bidId)
//        };
//        DataTable dt = db.Execute(sql, parameters);

//        foreach (DataRow row in dt.Rows)
//        {
//            items.Add(new BidItem
//            {
//                ItemId = Convert.ToInt32(row["ItemId"]),
//                BidId = bidId,
//                Description = row["Description"].ToString(),
//                Quantity = Convert.ToInt32(row["Quantity"]),
//                UnitPrice = Convert.ToDecimal(row["UnitPrice"]),
//                Total = Convert.ToDecimal(row["Total"])
//            });
//        }
//    }
//    finally
//    {
//        db.Close();
//    }
//    return items;
//}

//public static int DeleteById(int id)
//{
//	DbContext db = new DbContext();
//	try
//	{
//		// מחיקת פריטי ההצעה קודם (בגלל ה-Foreign Key)
//		string deleteItemsSql = "DELETE FROM T_BidItem WHERE BidId = @BidId";
//		var parameters = new List<SqlParameter>
//			{
//				new SqlParameter("@BidId", id)
//			};
//		db.ExecuteNonQuery(deleteItemsSql, parameters);

//		// מחיקת ההצעה עצמה
//		string deleteBidSql = "DELETE FROM T_Bid WHERE BidId = @BidId";
//		return db.ExecuteNonQuery(deleteBidSql, parameters);
//	}
//	finally
//	{
//		db.Close();
//	}
//}

//public static List<Bid> GetAllByCustomerId(int customerId, string searchTerm = null)
//{
//	List<Bid> bidList = new List<Bid>();
//	DbContext db = new DbContext();
//	try
//	{
//		string sql = @"SELECT b.* 
//                    FROM T_Bid b
//                    INNER JOIN T_Readability r ON b.ReadId = r.ReadId
//                    WHERE r.CusId = @CustomerId";

//		var parameters = new List<SqlParameter>
//{
//	new SqlParameter("@CustomerId", customerId)
//};

//		// הוספת תנאי חיפוש אם קיים
//		if (!string.IsNullOrEmpty(searchTerm))
//		{
//			sql += @" AND (b.[Desc] LIKE @SearchTerm 
//                        OR CAST(b.BidId AS NVARCHAR) LIKE @SearchTerm)";
//			parameters.Add(new SqlParameter("@SearchTerm", $"%{searchTerm}%"));
//		}

//		sql += " ORDER BY b.Date DESC";

//		DataTable dt = db.Execute(sql);

//		foreach (DataRow row in dt.Rows)
//		{
//			var bid = new Bid
//			{
//				BidId = Convert.ToInt32(row["BidId"]),
//				Desc = row["Desc"].ToString(),
//				Price = Convert.ToDecimal(row["Price"]),
//				Status = Convert.ToBoolean(row["Status"]),
//				TecId = Convert.ToInt32(row["TecId"]),
//				ReadId = Convert.ToInt32(row["ReadId"]),
//				Date = Convert.ToDateTime(row["Date"]),
//				Items = GetBidItem(Convert.ToInt32(row["BidId"]))
//			};
//			bidList.Add(bid);
//		}

//	}
//	finally
//	{
//		db.Close();
//	}
//	return bidList;
//}
//public static List<Bid> GetAllByCustomerId(int customerId, string searchTerm = null)
//{
//	List<Bid> bidList = new List<Bid>();
//	DbContext db = new DbContext();
//	try
//	{
//		// שאילתת JOIN
//		string sql = $@"SELECT b.* 
//                     FROM T_Bid b
//                     INNER JOIN T_Readability r ON b.ReadId = r.ReadId
//                     WHERE r.CusId = {customerId}";

//		System.Diagnostics.Debug.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] SQL Query: {sql}");
//		System.Diagnostics.Debug.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] Customer ID: {customerId}");

//		// בדיקת טבלת T_Readability
//		string readabilityCheck = $"SELECT COUNT(*) FROM T_Readability WHERE CusId = {customerId}";
//		DataTable dtReadability = db.Execute(readabilityCheck);
//		int readabilityCount = dtReadability.Rows.Count > 0 ? Convert.ToInt32(dtReadability.Rows[0][0]) : 0;
//		System.Diagnostics.Debug.WriteLine($"Readability records for customer: {readabilityCount}");

//		// בדיקת טבלת T_Bid
//		string bidCheck = "SELECT COUNT(*) FROM T_Bid";
//		DataTable dtBids = db.Execute(bidCheck);
//		int bidCount = dtBids.Rows.Count > 0 ? Convert.ToInt32(dtBids.Rows[0][0]) : 0;
//		System.Diagnostics.Debug.WriteLine($"Total bids in system: {bidCount}");

//		// שאילתה ראשית
//		DataTable dt = db.Execute(sql);
//		System.Diagnostics.Debug.WriteLine($"Main query returned {dt.Rows.Count} rows");

//		foreach (DataRow row in dt.Rows)
//		{
//			try
//			{
//				var bid = new Bid
//				{
//					BidId = Convert.ToInt32(row["BidId"]),
//					Desc = row["Desc"].ToString(),
//					Price = Convert.ToDecimal(row["Price"]),
//					Status = Convert.ToBoolean(row["Status"]),
//					TecId = Convert.ToInt32(row["TecId"]),
//					ReadId = Convert.ToInt32(row["ReadId"]),
//					Date = Convert.ToDateTime(row["Date"])
//				};
//				bidList.Add(bid);
//			}
//			catch (Exception ex)
//			{
//				System.Diagnostics.Debug.WriteLine($"Error processing row: {ex.Message}");
//			}
//		}
//	}
//	catch (Exception ex)
//	{
//		System.Diagnostics.Debug.WriteLine($"Error in GetAllByCustomerId: {ex.Message}");
//		throw;
//	}
//	finally
//	{
//		db.Close();
//	}
//	return bidList;
//}
//}

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
}
