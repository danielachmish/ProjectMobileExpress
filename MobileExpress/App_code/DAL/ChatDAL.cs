using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Dapper;

namespace DAL
{
	public class ChatDAL
	{
		public int ChatId { get; set; }
		public int? FromCustomerId { get; set; }
		public int? FromTechnicianId { get; set; }
		public int? ToCustomerId { get; set; }
		public int? ToTechnicianId { get; set; }
		public string MessageContent { get; set; }
		public DateTime SentTime { get; set; }
		public bool IsRead { get; set; }
		public byte Status { get; set; }
	}
	public interface ICustomerRepository
	{
		Task<dynamic> GetByIdAsync(int id);
	}

	public interface ITechnicianRepository
	{
		Task<dynamic> GetByIdAsync(int id);
	}
	public interface IChatRepository
	{
		Task<List<ChatDAL>> GetChatHistoryForCustomer(int customerId, int technicianId);
		Task<List<ChatDAL>> GetChatHistoryForTechnician(int technicianId, int customerId);
		Task<int> SaveMessage(ChatDAL message);
		Task MarkMessageAsRead(int chatId);
		Task<List<ChatDAL>> GetUnreadMessagesForCustomer(int customerId);
		Task<List<ChatDAL>> GetUnreadMessagesForTechnician(int technicianId);
	}

	public class ChatRepository : IChatRepository
	{
		private readonly string _connectionString;

		public ChatRepository(IConfiguration configuration)
		{
			_connectionString = configuration.GetConnectionString("DefaultConnection");
		}

		public async Task<List<ChatDAL>> GetChatHistoryForCustomer(int customerId, int technicianId)
		{
			using (var connection = new SqlConnection(_connectionString))
			{
				var query = @"
                    SELECT * FROM T_Chat 
                    WHERE (FromCustomerId = @CustomerId AND ToTechnicianId = @TechnicianId)
                    OR (FromTechnicianId = @TechnicianId AND ToCustomerId = @CustomerId)
                    AND Status = 1
                    ORDER BY SentTime DESC";

				return (await connection.QueryAsync<ChatDAL>(query,
					new { CustomerId = customerId, TechnicianId = technicianId })).ToList();
			}
		}

		public async Task<List<ChatDAL>> GetChatHistoryForTechnician(int technicianId, int customerId)
		{
			using (var connection = new SqlConnection(_connectionString))
			{
				var query = @"
                    SELECT * FROM T_Chat 
                    WHERE (FromTechnicianId = @TechnicianId AND ToCustomerId = @CustomerId)
                    OR (FromCustomerId = @CustomerId AND ToTechnicianId = @TechnicianId)
                    AND Status = 1
                    ORDER BY SentTime DESC";

				return (await connection.QueryAsync<ChatDAL>(query,
					new { TechnicianId = technicianId, CustomerId = customerId })).ToList();
			}
		}

		public async Task<int> SaveMessage(ChatDAL message)
		{
			using (var connection = new SqlConnection(_connectionString))
			{
				var query = @"
                    INSERT INTO T_Chat (
                        FromCustomerId, FromTechnicianId, ToCustomerId, ToTechnicianId,
                        MessageContent, SentTime, IsRead, Status)
                    VALUES (
                        @FromCustomerId, @FromTechnicianId, @ToCustomerId, @ToTechnicianId,
                        @MessageContent, @SentTime, @IsRead, @Status);
                    SELECT CAST(SCOPE_IDENTITY() as int)";

				return await connection.QuerySingleAsync<int>(query, message);
			}
		}

		public async Task MarkMessageAsRead(int chatId)
		{
			using (var connection = new SqlConnection(_connectionString))
			{
				var query = "UPDATE T_Chat SET IsRead = 1 WHERE ChatId = @ChatId";
				await connection.ExecuteAsync(query, new { ChatId = chatId });
			}
		}

		public async Task<List<ChatDAL>> GetUnreadMessagesForCustomer(int customerId)
		{
			using (var connection = new SqlConnection(_connectionString))
			{
				var query = @"
                    SELECT * FROM T_Chat 
                    WHERE ToCustomerId = @CustomerId 
                    AND IsRead = 0 
                    AND Status = 1
                    ORDER BY SentTime DESC";

				return (await connection.QueryAsync<ChatDAL>(query,
					new { CustomerId = customerId })).ToList();
			}
		}

		public async Task<List<ChatDAL>> GetUnreadMessagesForTechnician(int technicianId)
		{
			using (var connection = new SqlConnection(_connectionString))
			{
				var query = @"
                    SELECT * FROM T_Chat 
                    WHERE ToTechnicianId = @TechnicianId 
                    AND IsRead = 0 
                    AND Status = 1
                    ORDER BY SentTime DESC";

				return (await connection.QueryAsync<ChatDAL>(query,
					new { TechnicianId = technicianId })).ToList();
			}
		}
	}
}
