<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="MobileExpress.Chat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="chat-container">
    <!-- Header -->
    <div class="chat-header">
        <div class="user-info">
            <div class="avatar">
                <img src="/api/placeholder/40/40" alt="user avatar">
                <span class="status-dot online"></span>
            </div>
            <div class="user-details">
                <h3 class="user-name">שם המשתמש</h3>
                <span class="user-status">מחובר</span>
            </div>
        </div>
        <div class="header-actions">
            <button class="action-btn"><i class="fas fa-phone"></i></button>
            <button class="action-btn"><i class="fas fa-video"></i></button>
            <button class="action-btn"><i class="fas fa-ellipsis-v"></i></button>
        </div>
    </div>

    <!-- Messages Area -->
    <div class="messages-container" id="messages">
        <!-- Messages will be added here dynamically -->
    </div>

    <!-- Input Area -->
    <div class="chat-input-container">
        <button class="attachment-btn">
            <i class="fas fa-paperclip"></i>
        </button>
        <div class="input-wrapper">
            <textarea 
                class="chat-input" 
                placeholder="הקלד הודעה..."
                rows="1"
            ></textarea>
            <button class="emoji-btn">
                <i class="far fa-smile"></i>
            </button>
        </div>
        <button class="send-btn">
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>
</div>
    <style>
        :root {
    --purple-50: rgba(124, 58, 237, 0.05);
    --purple-100: rgba(124, 58, 237, 0.1);
    --purple-500: #7c3aed;
    --purple-600: #6d28d9;
    --purple-700: #5b21b6;
    --text-primary: #1f2937;
    --text-secondary: #6b7280;
}

.chat-container {
    width: 100%;
    max-width: 800px;
    height: 600px;
    background: white;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(124, 58, 237, 0.08);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    margin: 2rem auto;
}

.chat-header {
    padding: 1rem 1.5rem;
    background: white;
    border-bottom: 2px solid var(--purple-50);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.user-info {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.avatar {
    position: relative;
    width: 40px;
    height: 40px;
}

.avatar img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
}

.status-dot {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    border: 2px solid white;
}

.status-dot.online {
    background: #10b981;
}

.user-details {
    display: flex;
    flex-direction: column;
}

.user-name {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0;
}

.user-status {
    font-size: 0.875rem;
    color: var(--text-secondary);
}

.messages-container {
    flex: 1;
    padding: 1.5rem;
    overflow-y: auto;
    background: #f9fafb;
}

.chat-input-container {
    padding: 1rem;
    background: white;
    border-top: 2px solid var(--purple-50);
    display: flex;
    align-items: center;
    gap: 1rem;
}

.input-wrapper {
    flex: 1;
    display: flex;
    align-items: center;
    background: var(--purple-50);
    border-radius: 12px;
    padding: 0.5rem;
}

.chat-input {
    flex: 1;
    border: none;
    background: transparent;
    padding: 0.5rem;
    font-size: 0.95rem;
    resize: none;
    max-height: 100px;
    min-height: 24px;
}

.chat-input:focus {
    outline: none;
}

.attachment-btn,
.emoji-btn,
.send-btn,
.action-btn {
    background: none;
    border: none;
    padding: 0.5rem;
    color: var(--purple-500);
    cursor: pointer;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.send-btn {
    background: var(--purple-500);
    color: white;
    width: 40px;
    height: 40px;
    border-radius: 10px;
}

.send-btn:hover {
    background: var(--purple-600);
    transform: translateY(-2px);
}

.action-btn:hover,
.attachment-btn:hover,
.emoji-btn:hover {
    background: var(--purple-50);
    transform: translateY(-2px);
}
/* Message Styles */
.message {
    display: flex;
    margin-bottom: 1rem;
    animation: fadeIn 0.3s ease;
}

.message.sent {
    justify-content: flex-end;
}

.message-bubble {
    max-width: 70%;
    padding: 0.75rem 1rem;
    border-radius: 16px;
    position: relative;
}

.message.received .message-bubble {
    background: white;
    border: 1px solid var(--purple-50);
    border-bottom-right-radius: 4px;
}

.message.sent .message-bubble {
    background: var(--purple-500);
    color: white;
    border-bottom-left-radius: 4px;
}

.message-text {
    margin: 0;
    line-height: 1.4;
    font-size: 0.95rem;
}

.message-time {
    font-size: 0.75rem;
    opacity: 0.8;
    margin-top: 0.25rem;
    display: block;
    text-align: left;
}

.message-status {
    display: flex;
    align-items: center;
    gap: 0.25rem;
    font-size: 0.75rem;
    opacity: 0.8;
}

.message.sent .message-status {
    color: white;
}

/* Animations */
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <script>
        // הוספת הודעה חדשה
        function addMessage(content, isFromMe = false) {
            const messagesContainer = document.getElementById('messages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${isFromMe ? 'sent' : 'received'}`;

            messageDiv.innerHTML = `
        <div class="message-bubble">
            <p class="message-text">${content}</p>
            <span class="message-time">${new Date().toLocaleTimeString()}</span>
        </div>
    `;

            messagesContainer.appendChild(messageDiv);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        // התאמת גובה textarea
        const textarea = document.querySelector('.chat-input');
        textarea.addEventListener('input', function () {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });

        // שליחת הודעה
        document.querySelector('.send-btn').addEventListener('click', () => {
            const content = textarea.value.trim();
            if (content) {
                addMessage(content, true);
                textarea.value = '';
                textarea.style.height = 'auto';
            }
        });
        class ChatService {
            constructor() {
                this.messagesContainer = document.getElementById('messages');
                this.textarea = document.querySelector('.chat-input');
                this.sendButton = document.querySelector('.send-btn');

                // החלק מול הבקאנד
                this.customerId = null;  // יש למלא מהסשן
                this.technicianId = null;  // יש למלא מהסשן

                this.initializeEvents();
                this.loadChatHistory();
            }

            initializeEvents() {
                // טיפול בשליחת הודעה
                this.sendButton.addEventListener('click', () => this.sendMessage());

                // טיפול בלחיצה על Enter
                this.textarea.addEventListener('keypress', (e) => {
                    if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault();
                        this.sendMessage();
                    }
                });

                // התאמת גובה הטקסט
                this.textarea.addEventListener('input', () => {
                    this.textarea.style.height = 'auto';
                    this.textarea.style.height = this.textarea.scrollHeight + 'px';
                });
            }

            async loadChatHistory() {
                try {
                    const response = await fetch(`/api/chat/history?customerId=${this.customerId}&technicianId=${this.technicianId}`);
                    const messages = await response.json();

                    // ניקוי ההודעות הקיימות
                    this.messagesContainer.innerHTML = '';

                    // הוספת ההודעות החדשות
                    messages.forEach(msg => {
                        this.addMessageToUI(msg.messageContent, msg.fromCustomerId === this.customerId, {
                            time: new Date(msg.sentTime),
                            isRead: msg.isRead
                        });
                    });

                    this.scrollToBottom();
                } catch (error) {
                    console.error('Error loading chat history:', error);
                }
            }

            async sendMessage() {
                const content = this.textarea.value.trim();
                if (!content) return;

                try {
                    const messageData = {
                        fromCustomerId: this.customerId,
                        toTechnicianId: this.technicianId,
                        messageContent: content
                    };

                    const response = await fetch('/api/chat/send', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(messageData)
                    });

                    if (response.ok) {
                        this.addMessageToUI(content, true);
                        this.textarea.value = '';
                        this.textarea.style.height = 'auto';
                        this.scrollToBottom();
                    }
                } catch (error) {
                    console.error('Error sending message:', error);
                }
            }

            addMessageToUI(content, isFromMe, metadata = {}) {
                const messageDiv = document.createElement('div');
                messageDiv.className = `message ${isFromMe ? 'sent' : 'received'}`;

                const time = metadata.time || new Date();
                const status = metadata.isRead ? '<i class="fas fa-check-double"></i>' : '<i class="fas fa-check"></i>';

                messageDiv.innerHTML = `
            <div class="message-bubble">
                <p class="message-text">${this.escapeHtml(content)}</p>
                <div class="message-metadata">
                    <span class="message-time">${time.toLocaleTimeString()}</span>
                    ${isFromMe ? `<span class="message-status">${status}</span>` : ''}
                </div>
            </div>
        `;

                this.messagesContainer.appendChild(messageDiv);
            }

            scrollToBottom() {
                this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
            }

            escapeHtml(unsafe) {
                return unsafe
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#039;");
            }
        }

        // יצירת האובייקט והפעלתו
        const chatService = new ChatService();
    </script>
</asp:Content>
