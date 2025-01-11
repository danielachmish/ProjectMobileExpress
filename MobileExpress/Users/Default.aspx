<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MobileExpress.Users.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent1" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
     
   
    <style>
        /* סגנונות בסיסיים */
        /*body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: Arial, sans-serif;
        }*/

        /* תפריט עליון */
        /*.top-menu {
            background-color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .logo {
            height: 40px;
        }

        .top-nav {
            display: flex;
            gap: 20px;
        }

        .top-nav a {
            color: #333;
            text-decoration: none;
            font-size: 14px;
        }*/

        /* מיכל ראשי עם תמונת רקע */
        /*.main-container {
            min-height: calc(100vh - 70px);
            background: linear-gradient(rgba(44, 19, 88, 0.9), rgba(44, 19, 88, 0.9)),
                        url('/api/placeholder/1920/1080');
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            justify-content: center;*/ /* ממרכז את כל התוכן אנכית */
        /*}*/

        /* כותרת ראשית - מוגדלת ומודגשת */
        /*.main-title {
            color: white;
            font-size: 72px;*/ /* הגדלת הגופן */
            /*font-weight: 900;*/ /* הדגשה חזקה יותר */
            /*margin-bottom: 20px;
            text-align: center;
            letter-spacing: 2px;*/ /* מרווח בין אותיות */
            /*text-shadow: 2px 2px 4px rgba(0,0,0,0.3);*/ /* צל טקסט */
        /*}

        .sub-title {
            color: white;
            font-size: 24px;
            margin-bottom: 60px;
            text-align: center;
        }*/

        /* מיכל לכפתורים */
        /*.buttons-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 100%;
            max-width: 600px;
            margin-top: 40px;
            padding: 0 20px;*/ /* ריווח בצדדים */
        /*}*/

        /* עיצוב הכפתורים */
        /*.action-button {
            width: 100%;
            padding: 20px;*/ /* הגדלת הריווח הפנימי */
            /*border-radius: 30px;
            font-size: 20px;*/ /* הגדלת גופן */
            /*font-weight: bold;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: transform 0.3s, box-shadow 0.3s;
            border: none;
        }*/

        /* כפתור הרשמה */
        /*.signup-button {
            background-color: #4CAF50;
            color: white;
        }

        .signup-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }*/

        /* כפתור התחברות */
        /*.login-button {
            background-color: white;
            color: #2c1358;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 255, 255, 0.3);
        }*/
        /* סגנונות בסיסיים */
body, html {
    margin: 0;
    padding: 0;
    height: 100%;
    font-family: 'Segoe UI', system-ui, sans-serif;
}

/* תפריט עליון */
.top-menu {
    background: rgba(255, 255, 255, 0.98);
    padding: 1.25rem 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 4px 20px rgba(0,0,0,0.06);
    backdrop-filter: blur(10px);
}

.logo {
    height: 44px;
    transition: transform 0.3s ease;
}

.logo:hover {
    transform: scale(1.05);
}

.top-nav {
    display: flex;
    gap: 2rem;
}

.top-nav a {
    color: #4b5563;
    text-decoration: none;
    font-size: 0.95rem;
    font-weight: 500;
    padding: 0.5rem 1rem;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.top-nav a:hover {
    color: #9333ea;
    background: rgba(147, 51, 234, 0.08);
}

/* מיכל ראשי עם תמונת רקע */
.main-container {
    min-height: calc(100vh - 76px);
    background: linear-gradient(135deg, rgba(147, 51, 234, 0.95), rgba(79, 70, 229, 0.95)),
                url('/api/placeholder/1920/1080');
    background-size: cover;
    background-position: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 4rem 2rem;
    justify-content: center;
}

/* כותרת ראשית */
.main-title {
    color: white;
    font-size: 5rem;
    font-weight: 800;
    margin-bottom: 1.5rem;
    text-align: center;
    letter-spacing: -1px;
    text-shadow: 2px 2px 20px rgba(0,0,0,0.2);
    line-height: 1.1;
}

.sub-title {
    color: rgba(255, 255, 255, 0.9);
    font-size: 1.5rem;
    margin-bottom: 4rem;
    text-align: center;
    font-weight: 500;
    max-width: 800px;
    line-height: 1.6;
}

/* מיכל לכפתורים */
.buttons-container {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
    width: 100%;
    max-width: 500px;
    margin-top: 2.5rem;
    padding: 0 1.5rem;
}

/* עיצוב הכפתורים */
.action-button {
    width: 100%;
    padding: 1.25rem;
    border-radius: 16px;
    font-size: 1.125rem;
    font-weight: 600;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.75rem;
}

/* כפתור הרשמה */
.signup-button {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
    box-shadow: 0 10px 25px rgba(16, 185, 129, 0.2);
}

.signup-button:hover {
    transform: translateY(-3px);
    box-shadow: 0 20px 35px rgba(16, 185, 129, 0.3);
}

/* כפתור התחברות */
.login-button {
    background: rgba(255, 255, 255, 0.9);
    color: #4b5563;
    backdrop-filter: blur(10px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.login-button:hover {
    transform: translateY(-3px);
    background: white;
    box-shadow: 0 20px 35px rgba(0, 0, 0, 0.15);
    color: #9333ea;
}
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- תפריט עליון -->
    <div class="top-menu">
        <img src="/api/placeholder/120/40" alt="Logo" class="logo">
        <div class="top-nav">
      
            <a href="#"><i class="fas fa-truck"></i> עקבו אחרינו</a>
          
            <a href="#"><i class="fas fa-user"></i> התחבר לחשבון</a>
        </div>
    </div>

    <!-- מיכל ראשי -->
    <div class="main-container">
        <h1 class="main-title">MobileExpress</h1>
        <h2 class="sub-title"></h2>
        
        <div class="buttons-container">
            <a href="SingUp.aspx" class="action-button signup-button">
                הרשמה
            </a>
            <a href="SingIn.aspx" class="action-button login-button">
                יש לי חשבון
            </a>
        </div>
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
