<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="MobileExpress.Users.Main" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent1" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
     <style>
        /* סגנונות בסיסיים */
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: Arial, sans-serif;
        }

        /* תפריט עליון */
        .top-menu {
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
        }

        /* מיכל ראשי עם תמונת רקע */
        .main-container {
            min-height: calc(100vh - 70px);
            background: linear-gradient(rgba(44, 19, 88, 0.9), rgba(44, 19, 88, 0.9)),
                        url('/api/placeholder/1920/1080');
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
        }

        /* כותרת ראשית */
        .main-title {
            color: white;
            font-size: 88px;
            margin-bottom: 20px;
            text-align: center;
        }

        .sub-title {
            color: white;
            font-size: 24px;
            margin-bottom: 60px;
            text-align: center;
        }

        /* מיכל לכפתורים העגולים */
        .circles-container {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-top: 40px;
            flex-wrap: wrap;
            max-width: 1200px;
        }

        /* כפתורים עגולים */
        .circle-button {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background-color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.3s;
            text-decoration: none;
            color: #2c1358;
        }

        .circle-button:hover {
            transform: scale(1.05);
        }

        .circle-button i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #2c1358;
        }

        .circle-button span {
            font-size: 18px;
            text-align: center;
        }

        /* סרגל חיפוש */
        .search-box {
            width: 100%;
            max-width: 600px;
            padding: 15px 25px;
            font-size: 16px;
            border: none;
            border-radius: 30px;
            margin-bottom: 60px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
        
        <input type="search" class="search-box" placeholder="חיפוש...">

        <div class="circles-container">
            <a href="#" class="circle-button">
                <i class="fas fa-plug"></i>
                <span>BASELINE</span>
            </a>
            <a href="#" class="circle-button">
                <i class="fas fa-search"></i>
                <span>חדש באתר</span>
            </a>
            <a href="#" class="circle-button">
                <i class="fas fa-dollar-sign"></i>
                <span>מבצעים</span>
            </a>
            <a href="#" class="circle-button">
                <i class="fas fa-bell"></i>
                <span>עקבו אחרינו</span>
            </a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
