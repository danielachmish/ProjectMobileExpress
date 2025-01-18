<%@ Page Title="" Language="C#" MasterPageFile="~/Auth/AuthMaster.Master" AutoEventWireup="true" CodeBehind="CustomersLogin.aspx.cs" Inherits="MobileExpress.Auth.Login.CustomersLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       <link rel="stylesheet" href="assets/css/styles.css">
    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
    <!-- Google Sign In API -->
    <script src="https://apis.google.com/js/platform.js" async defer></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <style>
     
          .login-container {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
        padding: 20px;
    }

    .login-card {
        background: white;
        padding: 48px;
        border-radius: 24px;
        box-shadow: 0 10px 25px rgba(147, 51, 234, 0.1);
        width: 100%;
        max-width: 440px;
        text-align: center;
        backdrop-filter: blur(10px);
        border: 1px solid rgba(147, 51, 234, 0.1);
    }

    .login-title {
        color: #9333ea;
        font-size: 32px;
        margin-bottom: 12px;
        font-weight: 700;
        letter-spacing: -0.5px;
    }

    .login-subtitle {
        color: #6b7280;
        font-size: 16px;
        margin-bottom: 40px;
        line-height: 1.5;
    }

    .form-group {
        margin-bottom: 24px;
        text-align: right;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #4b5563;
        font-weight: 500;
    }

    .form-control {
        width: 100%;
        padding: 14px 18px;
        border: 2px solid #e5e7eb;
        border-radius: 12px;
        font-size: 15px;
        transition: all 0.3s ease;
        background: #f9fafb;
    }

    .form-control:focus {
        outline: none;
        border-color: #9333ea;
        box-shadow: 0 0 0 4px rgba(147, 51, 234, 0.1);
        background: white;
    }

    .btn-login {
        width: 100%;
        padding: 14px;
        background: linear-gradient(135deg, #9333ea 0%, #7928ca 100%);
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(147, 51, 234, 0.2);
    }

    .error-message {
        color: #ef4444;
        font-size: 14px;
        margin: 8px 0;
        display: block;
        font-weight: 500;
    }

    .field-error {
        color: #ef4444;
        font-size: 13px;
        margin-top: 6px;
        font-weight: 500;
    }

    .divider {
        margin: 32px 0;
        position: relative;
        text-align: center;
    }

    .divider::before,
    .divider::after {
        content: "";
        position: absolute;
        top: 50%;
        width: 45%;
        height: 2px;
        background: #e5e7eb;
        border-radius: 2px;
    }

    .divider::before {
        right: 0;
    }

    .divider::after {
        left: 0;
    }

    .divider span {
        background: white;
        padding: 0 16px;
        color: #6b7280;
        font-size: 14px;
        font-weight: 500;
    }

    .google-container {
        position: relative;
        width: 100%;
    }

    .btn-google {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        padding: 14px;
        background: white;
        border: 2px solid #e5e7eb;
        border-radius: 12px;
        color: #4b5563;
        text-decoration: none;
        font-size: 15px;
        font-weight: 600;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .btn-google:hover {
        border-color: #9333ea;
        background: #f9fafb;
        transform: translateY(-2px);
    }

    .btn-google i {
        margin-right: 12px;
        font-size: 18px;
        color: #9333ea;
    }

    .g-signin2 {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        cursor: pointer;
}
    </style>




    <div class="login-container">
        <div class="login-card">
            <h1 class="login-title">התחברות</h1>
            <h2 class="login-subtitle">התחבר למערכת באמצעות המייל או חשבון Google</h2>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtEmail" runat="server">כתובת מייל</asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="your@email.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="שדה חובה"
                    CssClass="field-error"
                    Display="Dynamic" />
            </div>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtPassword" runat="server">סיסמה</asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                    CssClass="form-control" placeholder="הזן סיסמה"></asp:TextBox>
                <a href="../../Account/ForgotPassword.aspx?returnUrl=CustomersFolder/SignIn.aspx" style="color: #666; text-decoration: none;">שכחת סיסמה?</a>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="שדה חובה"
                    CssClass="field-error"
                    Display="Dynamic" />
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>

            <asp:Button ID="btnLogin" runat="server" Text="התחבר"
                OnClick="btnLogin_Click" CssClass="btn-login" />

            <div class="divider">
                <span>או</span>
            </div>
             <div class="login-link" style="text-align: center; margin-top: 15px;">
                    <a href="../Register/CustomersRegister.aspx" style="color: #666; text-decoration: none;">אין לך חשבון? הירשם</a>
                </div>

            <div class="google-container">
               <%-- <asp:LinkButton ID="googleButton" runat="server" CssClass="btn-google">
                    <i class="fab fa-google"></i>
                    התחבר עם Google
                </asp:LinkButton>--%>
                <div class="g-signin2" data-onsuccess="onGoogleSignIn"></div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
      <script>
          function onGoogleSignIn(googleUser) {
              console.log('Google Sign-In successful');
              var id_token = googleUser.getAuthResponse().id_token;

              fetch('/api/Customers/google-signin', {
                  method: 'POST',
                  headers: {
                      'Content-Type': 'application/json'
                  },
                  body: JSON.stringify({ idToken: id_token })
              })
                  .then(response => {
                      if (!response.ok) {
                          throw new Error(`HTTP error! status: ${response.status}`);
                      }
                      return response.json();
                  })
                  .then(data => {
                      if (data.success) {
                          window.location.href = response.redirectUrl;
                      } else {
                          throw new Error(data.message || 'אירעה שגיאה בהתחברות');
                      }
                  })
                  .catch(error => {
                      console.error('Error:', error);
                      alert('שגיאה בהתחברות: ' + error.message);
                  });
          }
      </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
