<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="SingInTechnicians.aspx.cs" Inherits="MobileExpress.TechniciansFolder.SingInTechnicians" %>


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
    <meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">
    
   

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <style>
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

        .error-message {
            color: #dc2626;
            font-size: 14px;
            margin: 8px 0;
            display: block;
        }

        .field-error {
            color: #dc2626;
            font-size: 12px;
            margin-top: 4px;
        }

        .divider {
            margin: 24px 0;
            position: relative;
            text-align: center;
        }

        .divider::before,
        .divider::after {
            content: "";
            position: absolute;
            top: 50%;
            width: 45%;
            height: 1px;
            background: #e0e0e0;
        }

        .divider::before { right: 0; }
        .divider::after { left: 0; }

        .divider span {
            background: white;
            padding: 0 12px;
            color: #666;
            font-size: 14px;
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
    padding: 12px;
    background: linear-gradient(135deg, #4a3b8f 0%, #7e57c2 100%);
    border: none;
    border-radius: 8px;
    color: white;
    text-decoration: none;
    font-size: 14px;
    transition: all 0.3s ease;
    cursor: pointer;
}

.btn-google:hover {
    background: linear-gradient(135deg, #5c4aad 0%, #8f69d5 100%);
    transform: translateY(-1px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

.btn-google i {
    margin-right: 8px;
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

            <div class="google-container">
                <asp:LinkButton ID="googleButton" runat="server" CssClass="btn-google">
                    <i class="fab fa-google"></i>
                    התחבר עם Google
                </asp:LinkButton>
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

             fetch('/api/Technicians/google-signin', {
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
                         window.location.href = 'MainTechnicians.aspx';
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

