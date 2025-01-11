<%@ Page Title="" Language="C#" MasterPageFile="~/Account/MainAccount.Master" AutoEventWireup="true" Async="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="MobileExpress.Account.ForgotPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="login-container">
        <div class="login-card">
            <h1 class="login-title">שחזור סיסמה</h1>
            <h2 class="login-subtitle">הזן את כתובת המייל שלך לקבלת קוד אימות</h2>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtEmail" runat="server">כתובת מייל</asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="your@email.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="שדה חובה"
                    CssClass="field-error"
                    Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="כתובת מייל לא תקינה"
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    CssClass="field-error"
                    Display="Dynamic" />
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

            <asp:Button ID="btnSendCode" runat="server" Text="שלח קוד אימות"
                OnClick="btnSendCode_Click" CssClass="btn-login" />

            <div class="login-link" style="text-align: center; margin-top: 15px;">
                <a href="../TechniciansFolder/SingInTechnicians.aspx" style="color: #666; text-decoration: none;">חזרה להתחברות</a>
            </div>
        </div>
    </div>
    <style>
        /* עיצוב למסך שכחתי סיסמה */
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #f5f5f5;
    padding: 20px;
}

.login-card {
    background: white;
    padding: 40px;
    border-radius: 16px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    width: 100%;
    max-width: 400px;
    text-align: center;
}

.login-title {
    color: #9333ea;
    font-size: 24px;
    margin-bottom: 8px;
    font-weight: 600;
}

.login-subtitle {
    color: #666;
    font-size: 14px;
    margin-bottom: 32px;
    font-weight: normal;
}

.form-group {
    margin-bottom: 20px;
    text-align: right;
}

.form-control {
    width: 100%;
    padding: 12px 16px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    font-size: 14px;
    transition: border-color 0.2s;
}

.form-control:focus {
    outline: none;
    border-color: #9333ea;
    box-shadow: 0 0 0 3px rgba(147, 51, 234, 0.1);
}

.btn-login {
    width: 100%;
    padding: 12px;
    background: #9333ea;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.2s;
}

.btn-login:hover {
    background: #7928ca;
}

.message {
    margin: 10px 0;
    padding: 10px;
    border-radius: 4px;
    text-align: center;
}

.success-message {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.field-error {
    color: #dc2626;
    font-size: 12px;
    margin-top: 4px;
    display: block;
    text-align: right;
}

.login-link {
    margin-top: 20px;
}

.login-link a {
    color: #666;
    text-decoration: none;
    font-size: 14px;
    transition: color 0.3s ease;
}

.login-link a:hover {
    color: #9333ea;
}

/* מדיה קוורי למסכים קטנים */
@media (max-width: 768px) {
    .login-card {
        padding: 20px;
        margin: 10px;
    }

    .login-title {
        font-size: 20px;
    }

    .login-subtitle {
        font-size: 13px;
    }

    .form-control {
        padding: 10px 14px;
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
