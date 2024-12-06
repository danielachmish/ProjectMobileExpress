
using Amazon.SQS.Model;
using BLL;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using SendMessageRequest = BLL.SendMessageRequest;

namespace MobileExpress.Controllers
{
	[ApiController]
	[Route("api/[controller]")]
	public class ChatController : ControllerBase
	{
		private readonly IChatService _chatService;
		private readonly ILogger<ChatController> _logger;

		public ChatController(IChatService chatService, ILogger<ChatController> logger)
		{
			_chatService = chatService ?? throw new ArgumentNullException(nameof(chatService));
			_logger = logger ?? throw new ArgumentNullException(nameof(logger));
		}

		[HttpGet("customer/{customerId}/technician/{technicianId}")]
		public async Task<IActionResult> GetCustomerChatHistory([Range(1, int.MaxValue)] int customerId, [Range(1, int.MaxValue)] int technicianId)
		{
			try
			{
				var history = await _chatService.GetChatHistoryForCustomer(customerId, technicianId);
				return Ok(history);
			}
			catch (Exception ex)
			{
				_logger.LogError(ex, "Error retrieving customer chat history. CustomerId: {CustomerId}, TechnicianId: {TechnicianId}",
					customerId, technicianId);
				return StatusCode(500, "An error occurred while retrieving chat history");
			}
		}

		[HttpPost("send")]
		public async Task<IActionResult> SendMessage([FromBody] SendMessageRequest request)
		{
			if (request == null)
			{
				return BadRequest("Message request cannot be null");
			}

			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			try
			{
				var messageId = await _chatService.SendMessage(request);
				return Ok(new { ChatId = messageId });
			}
			catch (ValidationException ex)
			{
				return BadRequest(ex.Message);
			}
			catch (Exception ex)
			{
				_logger.LogError(ex, "Error sending message: {Request}", request);
				return StatusCode(500, "An error occurred while sending the message");
			}
		}
	}
}
