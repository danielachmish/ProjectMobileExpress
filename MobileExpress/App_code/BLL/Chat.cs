using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace BLL
{
	public class Chat
	{
		public int ChatId { get; set; }
		public int? FromCustomerId { get; set; }
		public string FromCustomerName { get; set; }
		public int? FromTechnicianId { get; set; }
		public string FromTechnicianName { get; set; }
		public int? ToCustomerId { get; set; }
		public string ToCustomerName { get; set; }
		public int? ToTechnicianId { get; set; }
		public string ToTechnicianName { get; set; }
		public string MessageContent { get; set; }
		public DateTime SentTime { get; set; }
		public bool IsRead { get; set; }
		public byte Status { get; set; }
	}

	public class SendMessageRequest
	{
		public int? FromCustomerId { get; set; }
		public int? FromTechnicianId { get; set; }
		public int? ToCustomerId { get; set; }
		public int? ToTechnicianId { get; set; }
		public string MessageContent { get; set; }
	}
	public interface IChatService
	{
		Task<List<Chat>> GetChatHistoryForCustomer(int customerId, int technicianId);
		Task<List<Chat>> GetChatHistoryForTechnician(int technicianId, int customerId);
		Task<int> SendMessage(SendMessageRequest request);
		Task MarkMessageAsRead(int chatId);
		Task<List<Chat>> GetUnreadMessagesForCustomer(int customerId);
		Task<List<Chat>> GetUnreadMessagesForTechnician(int technicianId);
	}

	public class ChatService : IChatService
	{
		private readonly IChatRepository _chatRepository;
		private readonly ICustomerRepository _customerRepository;
		private readonly ITechnicianRepository _technicianRepository;

		public ChatService(
			IChatRepository chatRepository,
			ICustomerRepository customerRepository,
			ITechnicianRepository technicianRepository)
		{
			_chatRepository = chatRepository;
			_customerRepository = customerRepository;
			_technicianRepository = technicianRepository;
		}

		public async Task<List<Chat>> GetChatHistoryForCustomer(int customerId, int technicianId)
		{
			var messages = await _chatRepository.GetChatHistoryForCustomer(customerId, technicianId);
			return await EnrichMessagesWithUserData(messages);
		}

		public async Task<List<Chat>> GetChatHistoryForTechnician(int technicianId, int customerId)
		{
			var messages = await _chatRepository.GetChatHistoryForTechnician(technicianId, customerId);
			return await EnrichMessagesWithUserData(messages);
		}

		public async Task<int> SendMessage(SendMessageRequest request)
		{
			var message = new ChatDAL
			{
				FromCustomerId = request.FromCustomerId,
				FromTechnicianId = request.FromTechnicianId,
				ToCustomerId = request.ToCustomerId,
				ToTechnicianId = request.ToTechnicianId,
				MessageContent = request.MessageContent,
				SentTime = DateTime.UtcNow,
				IsRead = false,
				Status = 1
			};

			return await _chatRepository.SaveMessage(message);
		}

		public async Task MarkMessageAsRead(int chatId)
		{
			await _chatRepository.MarkMessageAsRead(chatId);
		}

		public async Task<List<Chat>> GetUnreadMessagesForCustomer(int customerId)
		{
			var messages = await _chatRepository.GetUnreadMessagesForCustomer(customerId);
			return await EnrichMessagesWithUserData(messages);
		}

		public async Task<List<Chat>> GetUnreadMessagesForTechnician(int technicianId)
		{
			var messages = await _chatRepository.GetUnreadMessagesForTechnician(technicianId);
			return await EnrichMessagesWithUserData(messages);
		}

		private async Task<List<Chat>> EnrichMessagesWithUserData(List<ChatDAL> messages)
		{
			var enrichedMessages = new List<Chat>();

			foreach (var message in messages)
			{
				var dto = new Chat
				{
					ChatId = message.ChatId,
					FromCustomerId = message.FromCustomerId,
					FromTechnicianId = message.FromTechnicianId,
					ToCustomerId = message.ToCustomerId,
					ToTechnicianId = message.ToTechnicianId,
					MessageContent = message.MessageContent,
					SentTime = message.SentTime,
					IsRead = message.IsRead,
					Status = message.Status
				};

				if (message.FromCustomerId.HasValue)
				{
					var customer = await _customerRepository.GetByIdAsync(message.FromCustomerId.Value);
					dto.FromCustomerName = customer?.FullName;
				}

				if (message.FromTechnicianId.HasValue)
				{
					var technician = await _technicianRepository.GetByIdAsync(message.FromTechnicianId.Value);
					dto.FromTechnicianName = technician?.FulName;
				}

				if (message.ToCustomerId.HasValue)
				{
					var customer = await _customerRepository.GetByIdAsync(message.ToCustomerId.Value);
					dto.ToCustomerName = customer?.FullName;
				}

				if (message.ToTechnicianId.HasValue)
				{
					var technician = await _technicianRepository.GetByIdAsync(message.ToTechnicianId.Value);
					dto.ToTechnicianName = technician?.FulName;
				}

				enrichedMessages.Add(dto);
			}

			return enrichedMessages;
		}
	}
}
