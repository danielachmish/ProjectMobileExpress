<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="MainTechnicians.aspx.cs" Inherits="MobileExpress.TechniciansFolder.MainTechnicians" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="assets/css/styles.css">

    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  

    <style>
        /* רק את החלק הזה משתנה - שאר הקוד נשאר בדיוק אותו דבר */
        .circles-container {
            display: flex;
            justify-content: center;
            gap: 2.5rem;
            margin-top: 2.5rem;
            flex-wrap: wrap;
            max-width: 1200px;
        }

        .circle-button {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.95);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            color: #7c3aed;
            box-shadow: 0 10px 30px rgba(124, 58, 237, 0.2);
        }

            .circle-button:hover {
                transform: translateY(-8px) scale(1.05);
                box-shadow: 0 20px 40px rgba(124, 58, 237, 0.3);
                background: white;
            }

            .circle-button i {
                font-size: 3rem;
                margin-bottom: 1rem;
                color: #7c3aed;
                transition: all 0.3s ease;
            }

            .circle-button span {
                font-size: 1.1rem;
                text-align: center;
                font-weight: 500;
            }

        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f9fafb;
        }

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
            height: 40px;
            transition: transform 0.3s ease;
        }

            .logo:hover {
                transform: scale(1.05);
            }

        .top-nav {
            display: flex;
            gap: 20px;
        }

            .top-nav a {
                color: #4a5568;
                text-decoration: none;
                font-size: 0.95rem;
                transition: color 0.3s ease;
                padding: 0.5rem 1rem;
                border-radius: 8px;
            }

                .top-nav a:hover {
                    color: #7c3aed;
                    background: rgba(124, 58, 237, 0.1);
                }

        .main-container {
            min-height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 3rem 1.5rem;
            position: relative;
            z-index: 1;
            background: transparent;
        }

      .background-slideshow {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 0;  /* במקום -1 */
    background-size: cover;
    background-position: center;
}

.main-container {
    position: relative;
    z-index: 1;
    padding-top: 2rem;
    min-height: calc(100vh - 100px);
    display: flex;
    flex-direction: column;
    align-items: center;
    background: transparent; /* חשוב! */
}

.circles-container {
    position: relative;
    z-index: 2;
      display: flex;
            justify-content: center;
            gap: 2.5rem;
            margin-top: 2.5rem;
            flex-wrap: wrap;
            max-width: 1200px;
        }

        .sub-title {
            color: white;
            font-size: 1.5rem;
            margin-bottom: 3.5rem;
            text-align: center;
            text-shadow: 1px 1px 10px rgba(0,0,0,0.3);
            max-width: 800px;
            line-height: 1.6;
        }

          

        .circle-button {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.95);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            color: #7c3aed;
            box-shadow: 0 10px 30px rgba(124, 58, 237, 0.2);
        }

            .circle-button:hover {
                transform: translateY(-8px) scale(1.05);
                box-shadow: 0 20px 40px rgba(124, 58, 237, 0.3);
                background: white;
            }

            .circle-button i {
                font-size: 3rem;
                margin-bottom: 1rem;
                color: #7c3aed;
                transition: all 0.3s ease;
            }

            .circle-button span {
                font-size: 1.1rem;
                text-align: center;
                font-weight: 500;
            }

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
                box-shadow: 0 15px 40px rgba(124, 58, 237, 0.2);
                transform: translateY(-2px);
            }

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

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            border-bottom: 2px solid #f3f4f6;
            padding-bottom: 1rem;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

            .header-title h1 {
                font-size: 1.5rem;
                color: #1f2937;
                margin: 0;
                font-weight: 600;
            }

        .header-controls {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .edit-mode-btn, .save-changes-btn {
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .edit-mode-btn {
            background: #7c3aed;
            color: white;
        }

            .edit-mode-btn:hover {
                background: #6d28d9;
                transform: translateY(-2px);
            }

        .save-changes-btn {
            background: #10b981;
            color: white;
            display: none;
        }

            .save-changes-btn:hover {
                background: #059669;
                transform: translateY(-2px);
            }

        .close-button {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #6b7280;
            padding: 0.5rem;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

            .close-button:hover {
                background: rgba(124, 58, 237, 0.1);
                color: #7c3aed;
            }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
        }

            .stat-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 30px rgba(124, 58, 237, 0.2);
            }

        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-card h3 {
            font-size: 0.875rem;
            color: #6b7280;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #7c3aed;
        }

        .stat-icon {
            width: 3rem;
            height: 3rem;
            background: rgba(124, 58, 237, 0.1);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-icon {
            background: #7c3aed;
        }

        .stat-card:hover .icon {
            stroke: white;
        }

        .icon {
            width: 1.5rem;
            height: 1.5rem;
            stroke: #7c3aed;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
            transition: all 0.3s ease;
        }

        .details-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 1.5rem;
        }

        .details-card {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
        }

            .details-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 30px rgba(124, 58, 237, 0.2);
            }

            .details-card h2 {
                color: #1f2937;
                font-size: 1.25rem;
                margin-bottom: 1.5rem;
                font-weight: 600;
            }

        .info-row {
            display: flex;
            flex-direction: column;
            margin-bottom: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(124, 58, 237, 0.1);
        }

            .info-row:last-child {
                border-bottom: none;
            }

        .field-content {
            display: flex;
            flex-direction: column;
            width: 100%;
        }

        .info-label {
            font-weight: 500;
            color: #6b7280;
            margin-bottom: 0.5rem;
        }

        .info-value {
            color: #1f2937;
        }

        .edit-input {
            display: none;
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 0.95rem;
            color: #1f2937;
            transition: all 0.3s ease;
        }

            .edit-input:focus {
                outline: none;
                border-color: #7c3aed;
                box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1);
            }

        .modal-content.edit-mode .info-value,
        .edit-mode .info-value {
            display: none !important;
        }

        .modal-content.edit-mode .edit-input,
        .edit-mode .edit-input {
            display: block !important;
        }

        .edit-mode .edit-mode-btn {
            display: none !important;
        }

        .edit-mode .save-changes-btn {
            display: flex !important;
        }

        .working-hours {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .hours-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            border-bottom: 1px solid rgba(124, 58, 237, 0.1);
            border-radius: 12px;
            transition: all 0.3s ease;
        }

            .hours-row:hover {
                background: rgba(124, 58, 237, 0.05);
            }

            .hours-row:last-child {
                border-bottom: none;
            }

        .available {
            color: #10b981;
            font-weight: 500;
        }

        .unavailable {
            color: #ef4444;
            font-weight: 500;
        }

        .version-label {
            font-size: 0.875rem;
            color: #6b7280;
            padding: 0.5rem 1rem;
            background: rgba(124, 58, 237, 0.05);
            border-radius: 20px;
            display: inline-block;
        }

        @media (max-width: 768px) {
            .modal-content {
                padding: 1.5rem;
                margin: 0;
                width: 100%;
                height: 100%;
                max-height: 100vh;
                border-radius: 0;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .details-section {
                grid-template-columns: 1fr;
            }

            .info-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .info-label {
                width: 100%;
            }

            .main-title {
                font-size: 3rem;
            }

            .sub-title {
                font-size: 1.25rem;
            }
        }
        /* המשך ה-CSS */

        .availability-management {
            margin-top: 20px;
            background: white;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }

        .availability-container {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .working-hours, .breaks-section {
            background: #f9fafb;
            padding: 1.5rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.1);
        }

        .days-grid {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .day-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            background: white;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

            .day-row:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(124, 58, 237, 0.15);
            }

        .hours-input {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .time-input {
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            width: 120px;
            transition: all 0.3s ease;
        }

            .time-input:focus {
                outline: none;
                border-color: #7c3aed;
                box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1);
            }

        .day-toggle {
            position: relative;
            display: inline-block;
            width: 52px;
            height: 28px;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #e5e7eb;
            transition: .4s;
            border-radius: 28px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }

            .toggle-slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 20px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

        input:checked + .toggle-slider {
            background-color: #7c3aed;
        }

            input:checked + .toggle-slider:before {
                transform: translateX(24px);
            }

        .breaks-container {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .break-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            background: white;
            padding: 1rem;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

            .break-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(124, 58, 237, 0.15);
            }

        .add-break-btn {
            background: #7c3aed;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            font-weight: 500;
        }

            .add-break-btn:hover {
                background: #6d28d9;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(124, 58, 237, 0.2);
            }

        .remove-break {
            background: #ef4444;
            color: white;
            border: none;
            padding: 0.5rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .remove-break:hover {
                background: #dc2626;
                transform: scale(1.05);
            }

        .work-history {
            margin-top: 20px;
            padding: 2rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }

        .monthly-summary {
            background: #f9fafb;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.1);
        }

        .summary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid rgba(124, 58, 237, 0.1);
        }

        .summary-controls {
            display: flex;
            gap: 1rem;
        }

        .month-nav {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            padding: 0.5rem 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .month-nav:hover {
                border-color: #7c3aed;
                color: #7c3aed;
            }

        .work-item {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
        }

            .work-item:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 30px rgba(124, 58, 237, 0.2);
            }

        .work-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }

            .work-status.completed {
                background: rgba(16, 185, 129, 0.1);
                color: #10b981;
            }

        .view-details-btn {
            background: transparent;
            border: 2px solid #7c3aed;
            color: #7c3aed;
            padding: 0.5rem 1rem;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

            .view-details-btn:hover {
                background: #7c3aed;
                color: white;
                transform: translateY(-2px);
            }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }

        .page-number {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .page-number.active {
                background: #7c3aed;
                color: white;
                border-color: #7c3aed;
            }

            .page-number:hover:not(.active) {
                border-color: #7c3aed;
                color: #7c3aed;
            }

        .page-nav {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            padding: 0.5rem 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .page-nav:hover {
                border-color: #7c3aed;
                color: #7c3aed;
            }
    </style>

   


    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  
    <div class="background-slideshow"></div>
    <!-- מיכל ראשי -->
    <div class="main-container">
        <h1 class="main-title">

            <asp:Label ID="lblTechnicianName" runat="server" Text="MobileExpress"></asp:Label>
        </h1>
        <h2 class="sub-title"></h2>



        <div class="circles-container">
            <a href="AllRead.aspx" class="circle-button">
                <i class="fas fa-ticket-alt"></i>
                <span>קריאות</span>
            </a>
            <a href="MapOrientation.aspx" class="circle-button">
                <i class="fas fa-map-marker-alt"></i>
                <span>מפה והתמצאות</span>
            </a>

            <a href="Forms.aspx" class="circle-button">
                <i class="fas fa-file-alt"></i>
                <span>מסמכים</span>
            </a>

            <a href="#" class="circle-button">
                <i class="fas fa-chart-line"></i>
                <span>מעקב ביצועים</span>
            </a>
            <a href="Tasks.aspx" class="circle-button">
                <i class="fas fa-calendar"></i>
                <span>יומן ומשימות</span>
            </a>
        </div>
    </div>


   



</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">


    <script>
        ////// מערך של נתיבי תמונות - החלף את הנתיבים באלו של התמונות שלך
        const backgroundImages = [
            '/assets/images/imagebackground/photo-long-1.jpg',
            '/assets/images/imagebackground/photo-long-4.jpg',
            '/assets/images/photo-long-2.jpg '

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






       

        function showErrorMessage(message) {
            // הוסף את הקוד להצגת הודעת שגיאה בהתאם לעיצוב שלך
            alert(message);
        }
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
</script>



</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
