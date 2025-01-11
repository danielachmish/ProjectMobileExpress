<%@ Page Title="" Language="C#" MasterPageFile="~/Account/MainAccount.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="MobileExpress.Account.CreatePasswordReset" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
      <div class="login-container">
        <div class="login-card">
            <h1 class="login-title">איפוס סיסמה</h1>
            <h2 class="login-subtitle">הזן את הקוד שנשלח למייל שלך</h2>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtCode" runat="server">קוד אימות</asp:Label>
                <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" 
                    placeholder="הזן את הקוד בן 6 הספרות" MaxLength="6"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCode" runat="server"
                    ControlToValidate="txtCode"
                    ErrorMessage="שדה חובה"
                    CssClass="field-error"
                    Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revCode" runat="server"
                    ControlToValidate="txtCode"
                    ErrorMessage="קוד לא תקין (6 ספרות)"
                    ValidationExpression="^\d{6}$"
                    CssClass="field-error"
                    Display="Dynamic" />
            </div>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtNewPassword" runat="server">סיסמה חדשה</asp:Label>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" 
                    CssClass="form-control" placeholder="הזן סיסמה חדשה"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server"
                    ControlToValidate="txtNewPassword"
                    ErrorMessage="שדה חובה"
                    CssClass="field-error"
                    Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                    ControlToValidate="txtNewPassword"
                    ErrorMessage="הסיסמה חייבת להכיל לפחות 6 תווים"
                    ValidationExpression=".{6,}"
                    CssClass="field-error"
                    Display="Dynamic" />
            </div>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtConfirmPassword" runat="server">אימות סיסמה</asp:Label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" 
                    CssClass="form-control" placeholder="הזן שוב את הסיסמה החדשה"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ErrorMessage="שדה חובה"
                    CssClass="field-error"
                    Display="Dynamic" />
                <asp:CompareValidator ID="cvPassword" runat="server"
                    ControlToCompare="txtNewPassword"
                    ControlToValidate="txtConfirmPassword"
                    ErrorMessage="הסיסמאות אינן תואמות"
                    CssClass="field-error"
                    Display="Dynamic" />
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

            <asp:Button ID="btnResetPassword" runat="server" Text="אפס סיסמה"
                OnClick="btnResetPassword_Click" CssClass="btn-login" />

            <div class="login-link" style="text-align: center; margin-top: 15px;">
                <a href="ForgotPassword.aspx" style="color: #666; text-decoration: none;">שלח קוד חדש</a>
            </div>
        </div>
    </div>

    <style>
      /* סגנונות בסיסיים */
/* סגנונות בסיסיים */
body, html {
    margin: 0;
    padding: 0;
    height: 100%;
    font-family: Arial, sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    background: url('your-image-url.jpg') no-repeat center center fixed;
    background-size: cover;
}

/* מיכל עיקרי */
.login-container {
    width: 100%;
    max-width: 500px;
    background: rgba(255, 255, 255, 0.9);
    padding: 40px;
    border-radius: 15px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
    text-align: center;
    backdrop-filter: blur(10px);
}

/* כותרות */
.login-title {
    font-size: 30px;
    margin-bottom: 15px;
    color: #333;
    font-weight: bold;
}

.login-subtitle {
    font-size: 18px;
    margin-bottom: 25px;
    color: #666;
}

/* תיבת טופס */
.form-group {
    margin-bottom: 25px;
    text-align: left;
}

.form-group label {
    display: block;
    font-size: 16px;
    color: #555;
    margin-bottom: 8px;
}

.form-control {
    width: 100%;
    padding: 12px 15px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) inset;
    transition: border-color 0.3s ease;
}

.form-control:focus {
    border-color: #6a11cb;
    outline: none;
}

/* הודעות */
.message {
    font-size: 14px;
    padding: 12px;
    border-radius: 8px;
    margin-top: 15px;
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
    color: #dc3545;
    font-size: 12px;
    margin-top: 5px;
}

/* כפתורים */
.btn-login {
    width: 100%;
    padding: 12px 15px;
    font-size: 18px;
    background-color: #6a11cb;
    color: #fff;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
}

.btn-login:hover {
    background-color: #2575fc;
    transform: scale(1.02);
}

.btn-login:active {
    transform: scale(0.98);
}

/* קישורים */
.login-link a {
    color: #666;
    text-decoration: none;
    font-size: 14px;
}

.login-link a:hover {
    text-decoration: underline;
}



    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
      
</asp:Content>
