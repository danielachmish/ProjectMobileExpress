<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="MobileExpress.Users.Main" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent1" runat="server">
    <link rel="stylesheet" href="assets/css/styles.css">
    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <input type="hidden" id="hdnCusId" runat="server" />
    <div class="background-slideshow"></div>

    <style>
        .background-slideshow {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: -1;
    background-size: cover;
    background-position: center;
    opacity: 1; /* שקיפות הרקע */
    transition: background-image 1s ease-in-out;
}

/* אפקט שכבת כהה על הרקע */
.background-slideshow::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.3); /* שכבה שחורה שקופה */
    z-index: -1;
}
    </style>

    <style>
        /* סגנונות בסיסיים */
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Segoe UI', system-ui, sans-serif;
            
        }

        /* תפריט עליון */
        .top-menu {
            background: rgba(255, 255, 255, 0.95);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 2;
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
                transition: all 0.3s ease;
                padding: 0.5rem 1rem;
                border-radius: 8px;
            }

                .top-nav a:hover {
                    color: #9333ea;
                    background: rgba(147, 51, 234, 0.08);
                }

        /* מיכל ראשי */
        .main-container {
            min-height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 3rem 1.5rem;
            position: relative;
            z-index: 1;
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
            transition: all 1.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* כותרות */
        .main-title {
            color: white;
            font-size: 5.5rem;
            margin-bottom: 1.5rem;
            text-align: center;
            text-shadow: 2px 2px 20px rgba(0,0,0,0.3);
            font-weight: 800;
            letter-spacing: -2px;
        }

        .sub-title {
            color: white;
            font-size: 1.5rem;
            margin-bottom: 3.5rem;
            text-align: center;
            text-shadow: 1px 1px 10px rgba(0,0,0,0.3);
            font-weight: 500;
            max-width: 800px;
            line-height: 1.6;
        }

        /* מיכל כפתורים */
        .circles-container {
            display: flex;
            justify-content: center;
            gap: 2.5rem;
            margin-top: 2.5rem;
            flex-wrap: wrap;
            max-width: 1200px;
        }

        /* כפתורים עגולים */
        .circle-button {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.95);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            color: #2c1358;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }

            .circle-button:hover {
                transform: translateY(-8px);
                box-shadow: 0 20px 40px rgba(147, 51, 234, 0.2);
                background: white;
            }

            .circle-button i {
                font-size: 3rem;
                margin-bottom: 1rem;
                color: #9333ea;
                transition: all 0.3s ease;
            }

            .circle-button span {
                font-size: 1.1rem;
                text-align: center;
                font-weight: 500;
            }

        /* חיפוש */
        .search-box {
            width: 100%;
            max-width: 600px;
            padding: 1.2rem 2rem;
            font-size: 1rem;
            border: none;
            border-radius: 20px;
            margin-bottom: 3.5rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
        }

            .search-box:focus {
                outline: none;
                box-shadow: 0 15px 40px rgba(147, 51, 234, 0.2);
                transform: translateY(-2px);
            }

        /* מודל */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.3);
            backdrop-filter: blur(5px);
            opacity: 0;
            transition: opacity 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

            .modal.show {
                opacity: 1;
            }

        .modal-content {
            background: #ffffff;
            margin: 2% auto;
            max-width: 1200px;
            width: 95%;
            border-radius: 24px;
            position: relative;
            max-height: 95vh;
            overflow-y: auto;
            padding: 2.5rem;
            transform: translateY(-20px);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 25px 50px rgba(0,0,0,0.1);
        }

        .modal.show .modal-content {
            transform: translateY(0);
        }

       
    </style>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- תפריט עליון -->
    <div class="top-menu">
        <%--  <img src="/api/placeholder/120/40" alt="Logo" class="logo">--%>
        <div class="top-nav">
            <a href="../About.aspx"><i class="fas fa-truck"></i>עקבו אחרינו</a>
            <%--  <a href="TechnicianProfile.aspx"><i class="fas fa-user"></i>פרופיל</a>--%>
            <a href="#" onclick="openModal(); return false;"><i class="fas fa-user"></i>פרופיל</a>
        </div>
    </div>
    <!-- מיכל ראשי -->
    <div class="main-container">
        <h1 class="main-title">
            <asp:Label ID="lblCustomersName" runat="server" Text="MobileExpress"></asp:Label>
        </h1>
        <h2 class="sub-title"></h2>

        <div class="circles-container">
            <a href="ServiceCall.aspx" class="circle-button">
                <i class="fas fa-plug"></i>
                <span>פתיחת קריאה</span>
            </a>
            <a href="Bids.aspx" class="circle-button">
                <i class="fas fa-search"></i>
                <span>הצעות מחיר</span>
            </a>
            <a href="Reads.aspx" class="circle-button">
                <i class="fas fa-dollar-sign"></i>
                <span>הקריאות שלי</span>
            </a>
           <%-- <a href="#" class="circle-button">
                <i class="fas fa-bell"></i>
                <span>עקבו אחרינו</span>
            </a>--%>
        </div>
    </div>

    <!-- Profile Modal HTML -->
    <div id="profileModal" class="modal" dir="rtl">
        <div class="modal-content">
            <asp:HiddenField ID="customerHiddenId" runat="server" />
            <!-- Header -->
            <div class="modal-header">
                <div class="header-title">
                    <h1 class="profile-title">הפרופיל שלי</h1>
                  <%--  <span class="version-label"></span>--%>
                </div>
                <div class="header-controls">


                    <a href="CustomerProfile.aspx" class="edit-mode-btn" runat="server" id="editProfileLink">
                        <i class="fas fa-edit"></i>
                        <span class="btn-text">עריכת פרופיל</span>
                    </a>
                    <button class="save-changes-btn" style="display: none;">
                        <i class="fas fa-save"></i>
                        <span class="btn-text">שמור שינויים</span>
                    </button>
                    <button class="close-button">&times;</button>
                </div>
            </div>

            <!-- Stats Grid -->
         <%--   <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>זמינות</h3>
                            <p class="stat-value">זמין</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>דירוג</h3>
                            <p class="stat-value">4.8</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>הכנסה חודשית</h3>
                            <p class="stat-value">₪4,021</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-shekel-sign"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>קריאות שירות</h3>
                            <p class="stat-value">80</p>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                    </div>
                </div>
            </div>--%>

            <!-- Personal Details -->
            <div class="details-card">
                <h2>פרטים אישיים</h2>
                <div class="personal-details">
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">שם מלא:</span>
                            <span class="info-value" runat="server" id="fullNameValue"></span>
                            <input type="text" class="edit-input" runat="server" id="fullNameInput" style="display: none;">
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">טלפון:</span>
                            <span class="info-value" runat="server" id="phoneValue"></span>
                            <input type="tel" class="edit-input" runat="server" id="phoneInput" style="display: none;">
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">כתובת:</span>
                            <span class="info-value" runat="server" id="addressValue"></span>
                            <input type="text" class="edit-input" runat="server" id="addressInput" style="display: none;">
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">מייל:</span>
                            <span class="info-value" runat="server" id="EmailValue"></span>
                            <input type="email" class="edit-input" runat="server" id="EmailInput" style="display: none;">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Modal Styles */
        /*.modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal-content {
            background-color: #fff;
            margin: 2% auto;
            padding: 20px;
            width: 90%;
            max-width: 1000px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }*/

        /* Header Styles */
        /*.modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .profile-title {
            font-size: 24px;
            font-weight: bold;
            margin: 0;
        }

        .version-label {
            background-color: #f3f0ff;
            color: #6b46c1;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 14px;
        }

        .header-controls {
            display: flex;
            gap: 10px;
        }*/

        /* Button Styles */
        /*.edit-mode-btn, .save-changes-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 4px;
            background-color: #6b46c1;
            color: white;
            border: none;
            cursor: pointer;
        }

        .close-button {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            padding: 0 8px;
        }*/

        /* Stats Grid */
        /*.stats-container {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: #f8fafc;
            padding: 20px;
            border-radius: 8px;
        }

        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-value {
            font-size: 24px;
            font-weight: bold;
            margin: 5px 0;
        }

        .stat-icon {
            font-size: 24px;
            color: #6b46c1;
        }*/

        /* Details Card */
        /*.details-card {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

            .details-card h2 {
                margin-bottom: 20px;
                font-size: 18px;
                font-weight: bold;
            }

        .personal-details {
            display: grid;
            gap: 15px;
        }

        .info-row {
            padding: 10px 0;
        }

        .field-content {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .info-label {
            font-weight: bold;
            min-width: 100px;
        }

        .edit-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
        }*/
        /* RTL Support and Base Styles */
:root {
    --primary-color: #6b46c1;
    --primary-light: #f3f0ff;
    --background-light: #f8fafc;
    --border-color: #eee;
    --text-dark: #1a202c;
    --text-light: #4a5568;
    --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
    --shadow-md: 0 2px 10px rgba(0, 0, 0, 0.1);
    --transition-speed: 0.3s;
}

body {
    direction: rtl;
    font-family: system-ui, -apple-system, sans-serif;
    color: var(--text-dark);
    line-height: 1.5;
}

/* Modal Styles with Animation */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    opacity: 0;
    transition: opacity var(--transition-speed);
}

.modal.show {
    opacity: 1;
}

.modal-content {
    background-color: #fff;
    margin: 2% auto;
    padding: 24px;
    width: 90%;
    max-width: 1000px;
    border-radius: 12px;
    box-shadow: var(--shadow-md);
    transform: translateY(-20px);
    opacity: 0;
    transition: all var(--transition-speed);
}

.modal.show .modal-content {
    transform: translateY(0);
    opacity: 1;
}

/* Header Styles */
.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--border-color);
}

.header-title {
    display: flex;
    align-items: center;
    gap: 12px;
}

.profile-title {
    font-size: 24px;
    font-weight: 700;
    margin: 0;
    color: var(--text-dark);
}

.version-label {
    background-color: var(--primary-light);
    color: var(--primary-color);
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 500;
    transition: background-color var(--transition-speed);
}

/* Button Styles with Hover Effects */
.edit-mode-btn, 
.save-changes-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    border-radius: 8px;
    background-color: var(--primary-color);
    color: white;
    border: none;
    cursor: pointer;
    font-weight: 500;
    transition: all var(--transition-speed);
}

.edit-mode-btn:hover, 
.save-changes-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(107, 70, 193, 0.2);
}

.close-button {
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
    padding: 8px;
    color: var(--text-light);
    transition: all var(--transition-speed);
    border-radius: 50%;
}

.close-button:hover {
    background-color: var(--background-light);
    color: var(--text-dark);
}

/* Details Card with Hover Effects */
.details-card {
    background-color: white;
    padding: 24px;
    border-radius: 12px;
    box-shadow: var(--shadow-sm);
    margin-bottom: 24px;
    transition: all var(--transition-speed);
}

.details-card:hover {
    box-shadow: var(--shadow-md);
}

.details-card h2 {
    margin-bottom: 24px;
    font-size: 18px;
    font-weight: 600;
    color: var(--text-dark);
}

/* Form Fields with Animation */
.personal-details {
    display: grid;
    gap: 20px;
}

.info-row {
    padding: 12px 0;
    transition: background-color var(--transition-speed);
}

.info-row:hover {
    background-color: var(--background-light);
}

.field-content {
    display: flex;
    gap: 16px;
    align-items: center;
}

.info-label {
    font-weight: 600;
    min-width: 120px;
    color: var(--text-light);
}

.edit-input {
    padding: 10px 12px;
    border: 2px solid var(--border-color);
    border-radius: 8px;
    width: 100%;
    transition: all var(--transition-speed);
}

.edit-input:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px var(--primary-light);
    outline: none;
}

/* Responsive Design */
@media (max-width: 768px) {
    .modal-content {
        margin: 0;
        width: 100%;
        height: 100%;
        border-radius: 0;
    }
    
    .personal-details {
        grid-template-columns: 1fr;
    }
    
    .field-content {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .info-label {
        margin-bottom: 4px;
    }
}

/* Loading State Animation */
@keyframes shimmer {
    0% {
        background-position: -468px 0;
    }
    100% {
        background-position: 468px 0;
    }
}

.loading {
    background: linear-gradient(
        to right,
        var(--background-light) 8%,
        #f0f0f0 18%,
        var(--background-light) 33%
    );
    background-size: 800px 104px;
    animation: shimmer 1.5s linear infinite;
}
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">

    <script>
        //const backgroundImages = [
        //    '/assets/images/photo-long-2.jpg',
        //    '/assets/images/photo-long-2.jpg ',
        //    '/assets/images/photo-long-2.jpg '

        //];

        //let currentImageIndex = 0;
        //const backgroundElement = document.querySelector('.background-slideshow');

        //// הגדרת התמונה הראשונה
        //if (backgroundElement) {
        //    // בחירת תמונה רנדומלית בטעינה הראשונית
        //    currentImageIndex = Math.floor(Math.random() * backgroundImages.length);
        //    backgroundElement.style.backgroundImage = `url(${backgroundImages[currentImageIndex]})`;
        //}

        //// פונקציה להחלפת התמונות
        //function changeBackground() {
        //    currentImageIndex = (currentImageIndex + 1) % backgroundImages.length;
        //    backgroundElement.style.backgroundImage = `url(${backgroundImages[currentImageIndex]})`;
        //}

        //// החלפת התמונה בכל טעינת דף
        //window.addEventListener('load', () => {
        //    if (backgroundElement) {
        //        backgroundElement.style.backgroundImage = `url(${backgroundImages[currentImageIndex]})`;
        //    }
        //});

        fetch('<%= ResolveUrl("~/MainMobileExpress.aspx/GetImagesList") %>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        })
            .then(response => response.json())
            .then(data => {
                // התוצאה תחזור בפורמט ASP.NET AJAX, כלומר data.d הוא המערך שמוחזר
                const images = data.d;

                const backgroundElement = document.querySelector('.background-slideshow');
                if (!backgroundElement || images.length === 0) return;

                let currentImageIndex = Math.floor(Math.random() * images.length);
                backgroundElement.style.backgroundImage = `url('/assets/images/imagebackground/${images[currentImageIndex]}')`;

                function changeBackground() {
                    currentImageIndex = (currentImageIndex + 1) % images.length;
                    backgroundElement.style.backgroundImage = `url('/assets/images/imagebackground/${images[currentImageIndex]}')`;
                }

                // החלפת תמונה כל 5 שניות
                setInterval(changeBackground, 5000);
            })
            .catch(err => console.error('Error fetching images:', err));

        // פונקציה לפתיחת המודאל
        function openModal() {
            const modal = document.getElementById('profileModal');
            modal.style.display = 'block';
            setTimeout(() => {
                modal.classList.add('show');
            }, 10);
            document.body.style.overflow = 'hidden';

            // הוספת מאזיני אירועים
            attachModalEventListeners();
        }

        // פונקציה לסגירת המודאל
        function closeModal() {
            const modal = document.getElementById('profileModal');
            modal.classList.remove('show');
            setTimeout(() => {
                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }, 300);

            // הסרת מאזיני אירועים
            removeModalEventListeners();
        }

        // פונקציה להוספת מאזיני אירועים
        function attachModalEventListeners() {
            const modal = document.getElementById('profileModal');
            const modalContent = modal.querySelector('.modal-content');

            // מניעת סגירה בלחיצה על תוכן המודאל
            modalContent.addEventListener('click', handleModalContentClick);

            // סגירה בלחיצה מחוץ למודאל
            modal.addEventListener('click', handleModalOutsideClick);
        }

        // פונקציה להסרת מאזיני אירועים
        function removeModalEventListeners() {
            const modal = document.getElementById('profileModal');
            const modalContent = modal.querySelector('.modal-content');

            modalContent.removeEventListener('click', handleModalContentClick);
            modal.removeEventListener('click', handleModalOutsideClick);
        }

        // טיפול בלחיצה על תוכן המודאל
        function handleModalContentClick(event) {
            event.stopPropagation();
        }

        // טיפול בלחיצה מחוץ למודאל
        function handleModalOutsideClick(event) {
            if (event.target.id === 'profileModal') {
                closeModal();
            }
        }

   
    </script>
</asp:Content>
