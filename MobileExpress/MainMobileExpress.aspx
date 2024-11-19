<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MainMobileExpress.aspx.cs" Inherits="MobileExpress.MainMobileExpress" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="rtl" lang="he">
<head runat="server">
    <title>MobileExpress</title>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            background-color: rgba(255, 255, 255, 0.9);
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: relative;
            z-index: 2;
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

        /* מיכל ראשי */
        .main-container {
            min-height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            position: relative;
            z-index: 1;
            background: transparent;
        }

        /* רקע מתחלף */
        .background-slideshow {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            background-size: cover;
            background-position: center;
            transition: background-image 1s ease-in-out;
        }

        /* כותרת ראשית */
        .main-title {
            color: white;
            font-size: 88px;
            margin-bottom: 20px;
            text-align: center;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        .sub-title {
            color: white;
            font-size: 24px;
            margin-bottom: 60px;
            text-align: center;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
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
            background-color: rgba(255, 255, 255, 0.9);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.3s;
            text-decoration: none;
            color: #2c1358;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
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
</head>
<body>
    <form id="form1" runat="server">
        <!-- תפריט עליון -->
       <%-- <div class="top-menu">
            <img src="/api/placeholder/120/40" alt="Logo" class="logo">
            <div class="top-nav">
                <a href="#"><i class="fas fa-truck"></i> עקבו אחרינו</a>
                <a href="SingInTechnicians.aspx"><i class="fas fa-user"></i> התחבר לחשבון</a>
            </div>
        </div>--%>

        <div class="background-slideshow"></div>

        <!-- מיכל ראשי -->
        <div class="main-container">
            <h1 class="main-title">
                <asp:Label ID="lblTechnicianName" runat="server" Text="MobileExpress"></asp:Label>
            </h1>
            <h2 class="sub-title"></h2>

            <div class="circles-container">
                
                <a href="/TechniciansFolder/SingUpTechnicians.aspx" class="circle-button">
                    <i class="fas fa-bell"></i>
                    <span>כניסת טכנאים</span>
                </a>
                <a href="/Users/SingIn.aspx" class="circle-button">
                    <i class="fas fa-bell"></i>
                    <span>כניסת לקוחות</span>
                </a>
            </div>
        </div>
    </form>

    <script>
        // מערך של נתיבי תמונות - החלף את הנתיבים באלו של התמונות שלך
        const backgroundImages = [
            '/assets/images/photo-long-2.jpg',
            '/assets/images/photo-long-2.jpg',
            '/assets/images/photo-long-2.jpg'
            
        ];
        
        let currentImageIndex = 0;
        const backgroundElement = document.querySelector('.background-slideshow');
        
        // הגדרת התמונה הראשונה
        if (backgroundElement) {
            // בחירת תמונה רנדומלית בטעינה הראשונית
            currentImageIndex = Math.floor(Math.random() * backgroundImages.length);
            backgroundElement.style.backgroundImage = `url(${backgroundImages[currentImageIndex]})`;
        }
        
        // פונקציה להחלפת התמונות
        function changeBackground() {
            currentImageIndex = (currentImageIndex + 1) % backgroundImages.length;
            backgroundElement.style.backgroundImage = `url(${backgroundImages[currentImageIndex]})`;
        }
        
        // החלפת התמונה בכל טעינת דף
        window.addEventListener('load', () => {
            if (backgroundElement) {
                backgroundElement.style.backgroundImage = `url(${backgroundImages[currentImageIndex]})`;
            }
        });
    </script>
</body>
</html>