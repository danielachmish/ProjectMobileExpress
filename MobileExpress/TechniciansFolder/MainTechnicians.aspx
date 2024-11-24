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
    <input type="hidden" id="hdnTecId" runat="server" />
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

    <style>
        /* Basic Styles */
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: Arial, sans-serif;
        }

        /* Modal Base Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

            .modal.show {
                opacity: 1;
            }

        .modal-content {
            background-color: #f8f9fe;
            margin: 2% auto;
            max-width: 1200px;
            width: 95%;
            border-radius: 1rem;
            position: relative;
            max-height: 95vh;
            overflow-y: auto;
            padding: 2rem;
            transform: translateY(-20px);
            transition: transform 0.3s ease;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .modal.show .modal-content {
            transform: translateY(0);
        }

        /* Header Styles */
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

            .header-title h1 {
                font-size: 1.5rem;
                color: #333;
                margin: 0;
            }

        .header-controls {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        /* Button Styles */
        .edit-mode-btn, .save-changes-btn {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
            font-size: 0.875rem;
        }

        .edit-mode-btn {
            background-color: #6b46c1;
            color: white;
            display: flex;
        }

            .edit-mode-btn:hover {
                background-color: #553c9a;
            }

        .save-changes-btn {
            background-color: #059669;
            color: white;
            display: none;
        }

            .save-changes-btn:hover {
                background-color: #047857;
            }

        .close-button {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #6B7280;
            padding: 0.5rem;
            border-radius: 0.5rem;
            transition: all 0.2s;
        }

            .close-button:hover {
                background-color: #f0f0ff;
                color: #6b46c1;
            }

        /* Stats Grid */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background-color: white;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-card h3 {
            font-size: 0.875rem;
            color: #6B7280;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #6b46c1;
        }

        .stat-icon {
            width: 3rem;
            height: 3rem;
            background-color: #f0f0ff;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .icon {
            width: 1.5rem;
            height: 1.5rem;
            stroke: #6b46c1;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        /* Details Section */
        .details-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 1.5rem;
        }

        .details-card {
            background-color: white;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

            .details-card h2 {
                color: #333;
                font-size: 1.25rem;
                margin-bottom: 1.5rem;
            }

        /* Info Rows */
        .info-row {
            display: flex;
            flex-direction: column;
            margin-bottom: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0ff;
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
            color: #6B7280;
            margin-bottom: 0.5rem;
            width: 100%;
        }

        .info-value {
            color: #374151;
        }

        .edit-input {
            display: none;
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #e5e7eb;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            color: #374151;
            margin-top: 0.5rem;
        }

        /* Edit Mode Styles */
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

        /* Working Hours */
        .working-hours {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .hours-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f0f0ff;
        }

            .hours-row:last-child {
                border-bottom: none;
            }

        .available {
            color: #059669;
        }

        .unavailable {
            color: #DC2626;
        }

        /* Version Label */
        .version-label {
            font-size: 0.875rem;
            color: #6B7280;
        }

        /* Top Menu Styles */
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

        /* Responsive Styles */
        @media (max-width: 768px) {
            .modal-content {
                padding: 1rem;
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
        }
    </style>
    <%--ניהול זמינות--%>
    <style>
        .availability-management {
            margin-top: 20px;
        }

        .availability-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .working-hours, .breaks-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }

        .days-grid {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .day-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px;
            background: white;
            border-radius: 6px;
        }

        .hours-input {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .time-input {
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 110px;
        }

        .day-toggle {
            position: relative;
            display: inline-block;
            width: 48px;
            height: 24px;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 24px;
        }

            .toggle-slider:before {
                position: absolute;
                content: "";
                height: 18px;
                width: 18px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

        input:checked + .toggle-slider {
            background-color: #2196F3;
        }

            input:checked + .toggle-slider:before {
                transform: translateX(24px);
            }

        .breaks-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .break-item {
            display: flex;
            align-items: center;
            gap: 10px;
            background: white;
            padding: 8px;
            border-radius: 6px;
        }

        .add-break-btn {
            background: #2196F3;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 10px;
        }

        .remove-break {
            background: #ff4444;
            color: white;
            border: none;
            padding: 6px;
            border-radius: 4px;
            cursor: pointer;
        }

        .break-time-input {
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 110px;
        }

        .break-duration {
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
    <%--היסטוריית עבודות--%>
    <style>
        .work-history {
            margin-top: 20px;
        }

        .monthly-summary {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .summary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .summary-controls {
            display: flex;
            gap: 10px;
        }

        .month-nav {
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px 10px;
            cursor: pointer;
        }

        .summary-stats {
            display: flex;
            justify-content: space-around;
            gap: 20px;
        }

        .summary-stat {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .stat-label {
            color: #666;
            font-size: 0.9em;
        }

        .stat-value {
            font-size: 1.2em;
            font-weight: bold;
            margin-top: 5px;
        }

        .list-filters {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .search-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 200px;
        }

        .work-items {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .work-item {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
        }

        .work-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .work-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .work-date {
            color: #666;
            font-size: 0.9em;
        }

        .work-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.9em;
        }

            .work-status.completed {
                background: #e8f5e9;
                color: #2e7d32;
            }

        .work-details {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .work-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .work-location {
            color: #666;
            font-size: 0.9em;
        }

        .work-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }

        .price-rating {
            display: flex;
            gap: 15px;
        }

        .work-price {
            font-weight: bold;
            color: #2196F3;
        }

        .work-rating {
            color: #ffc107;
        }

        .view-details-btn {
            background: transparent;
            border: 1px solid #2196F3;
            color: #2196F3;
            padding: 5px 15px;
            border-radius: 4px;
            cursor: pointer;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
        }

        .page-numbers {
            display: flex;
            gap: 5px;
        }

        .page-number {
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
        }

            .page-number.active {
                background: #2196F3;
                color: white;
                border-color: #2196F3;
            }

        .page-nav {
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px 10px;
            cursor: pointer;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- תפריט עליון -->
    <div class="top-menu">
        <%--  <img src="/api/placeholder/120/40" alt="Logo" class="logo">--%>
        <div class="top-nav">
            <a href="#"><i class="fas fa-truck"></i>עקבו אחרינו</a>
            <%--  <a href="TechnicianProfile.aspx"><i class="fas fa-user"></i>פרופיל</a>--%>
            <a href="#" onclick="openModal(); return false;"><i class="fas fa-user"></i>פרופיל</a>
        </div>
    </div>
    <div class="background-slideshow"></div>
    <!-- מיכל ראשי -->
    <div class="main-container">
        <h1 class="main-title">
            <asp:Label ID="lblTechnicianName" runat="server" Text="MobileExpress"></asp:Label>
        </h1>
        <h2 class="sub-title"></h2>

        <%--      <input type="search" class="search-box" placeholder="חיפוש...">--%>

        <div class="circles-container">
            <a href="AllRead.aspx" class="circle-button">
                <i class="fas fa-plug"></i>
                <span>קריאות</span>
            </a>
            <a href="MapOrientation.aspx" class="circle-button">
                <i class="fas fa-search"></i>
                <span>מפה והתמצאות</span>
            </a>
            <a href="#" class="circle-button">
                <i class="fas fa-dollar-sign"></i>
                <span>התראות ועדכונים</span>
            </a>
           <%-- <a href="#" class="circle-button">
                <i class="fas fa-bell"></i>
                <span>ניהול משימות</span>
            </a>--%>
            <a href="#" class="circle-button">
                <i class="fas fa-bell"></i>
                <span>מעקב ביצועים</span>
            </a>
              <a href="Tasks.aspx" class="circle-button">
                <i class="fas fa-bell"></i>
                <span>יומן ומשימות</span>
            </a>
        </div>
    </div>


    <!-- מודל פרופיל -->
    <div id="profileModal" class="modal" dir="rtl">
        <div class="modal-content">
            <div class="modal-header">
                <div class="header-title">
                    <h1 class="profile-title">פרופיל טכנאי</h1>
                    <span class="version-label">גרסה 1</span>
                </div>
                <div class="header-controls">
                    <button class="edit-mode-btn">
                        <i class="fas fa-edit"></i>
                        <span class="btn-text">עריכת פרופיל</span>
                    </button>
                    <button class="save-changes-btn" style="display: none;">
                        <i class="fas fa-save"></i>
                        <span class="btn-text">שמור שינויים</span>
                    </button>
                    <button class="close-button">&times;</button>
                </div>
            </div>

            <!-- Stats Grid -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>קריאות שירות</h3>
                            <p class="stat-value">80</p>
                        </div>
                        <div class="stat-icon">
                            <svg class="icon" viewBox="0 0 24 24">
                                <path d="M4 6h16M4 12h16m-7 6h7"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>הכנסה חודשית</h3>
                            <p class="stat-value">₪4,021</p>
                        </div>
                        <div class="stat-icon money-icon">
                            <svg class="icon" viewBox="0 0 24 24">
                                <path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>דירוג</h3>
                            <p class="stat-value">4.8</p>
                        </div>
                        <div class="stat-icon rating-icon">
                            <svg class="icon" viewBox="0 0 24 24">
                                <path d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-content">
                        <div>
                            <h3>זמינות</h3>
                            <p class="stat-value available">זמין</p>
                        </div>
                        <div class="stat-icon available-icon">
                            <svg class="icon" viewBox="0 0 24 24">
                                <path d="M5 13l4 4L19 7"></path>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>


            <div class="details-card">
                <h2>פרטים אישיים</h2>
                <div class="personal-details">
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">שם מלא:</span>
                            <span class="info-value" runat="server" id="fullNameValue"></span>
                            <input type="text" runat="server" class="edit-input" id="fullNameInput">
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">טלפון:</span>
                            <span class="info-value" runat="server" id="phoneValue"></span>
                            <input type="tel" runat="server" class="edit-input" id="phoneInput">
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">כתובת:</span>
                            <span class="info-value" runat="server" id="addressValue"></span>
                            <input type="text" runat="server" class="edit-input" id="addressInput">
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">התמחות:</span>
                            <span class="info-value" runat="server" id="specializationValue"></span>
                            <input type="text" runat="server" class="edit-input" id="specializationInput">
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="field-content">
                            <span class="info-label">מייל:</span>
                            <span class="info-value" runat="server" id="EmailValue"></span>
                            <input type="text" runat="server" class="edit-input" id="EmailInpot">
                        </div>
                    </div>

                </div>
            </div>
            <div class="details-card availability-management">
                <h2>ניהול זמינות</h2>
                <div class="availability-container">
                    <!-- שעות פעילות -->
                    <div class="working-hours">
                        <h3>שעות פעילות</h3>
                        <div class="days-grid">
                            <div class="day-row">
                                <div class="day-label">ראשון</div>
                                <div class="hours-input">
                                    <input type="time" class="time-input" id="SundayStart">
                                    <span>עד</span>
                                    <input type="time" class="time-input" id="SundayEnd">
                                    <label class="day-toggle">
                                        <input type="checkbox" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="day-row">
                                <div class="day-label">שני</div>
                                <div class="hours-input">
                                    <input type="time" class="time-input" id="MondayStart">
                                    <span>עד</span>
                                    <input type="time" class="time-input" id="MondayEnd">
                                    <label class="day-toggle">
                                        <input type="checkbox" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="day-row">
                                <div class="day-label">שלישי</div>
                                <div class="hours-input">
                                    <input type="time" class="time-input" id="TuesdayStart">
                                    <span>עד</span>
                                    <input type="time" class="time-input" id="TuesdayEnd">
                                    <label class="day-toggle">
                                        <input type="checkbox" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="day-row">
                                <div class="day-label">רביעי</div>
                                <div class="hours-input">
                                    <input type="time" class="time-input" id="WednesdayStart">
                                    <span>עד</span>
                                    <input type="time" class="time-input" id="WednesdayEnd">
                                    <label class="day-toggle">
                                        <input type="checkbox" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="day-row">
                                <div class="day-label">חמישי</div>
                                <div class="hours-input">
                                    <input type="time" class="time-input" id="ThursdayStart">
                                    <span>עד</span>
                                    <input type="time" class="time-input" id="ThursdayEnd">
                                    <label class="day-toggle">
                                        <input type="checkbox" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="day-row">
                                <div class="day-label">שישי</div>
                                <div class="hours-input">
                                    <input type="time" class="time-input" id="FridayStart">
                                    <span>עד</span>
                                    <input type="time" class="time-input" id="FridayEnd">
                                    <label class="day-toggle">
                                        <input type="checkbox" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="day-row">
                                <div class="day-label">שבת</div>
                                <div class="hours-input">
                                    <input type="time" class="time-input" id="SaturdayStart">
                                    <span>עד</span>
                                    <input type="time" class="time-input" id="SaturdayEnd">
                                    <label class="day-toggle">
                                        <input type="checkbox" checked>
                                        <span class="toggle-slider"></span>
                                    </label>
                                </div>
                            </div>
                            <!-- שאר הימים באותו פורמט -->
                        </div>
                    </div>

                    <!-- הפסקות -->
                    <div class="breaks-section">
                        <h3>הפסקות קבועות</h3>
                        <div class="breaks-container">
                            <button class="add-break-btn">
                                <i class="fas fa-plus"></i>
                                הוסף הפסקה
                            </button>
                            <div class="break-item">
                                <input type="time" class="break-time-input">
                                <span>למשך</span>
                                <select class="break-duration">
                                    <option value="30">30 דקות</option>
                                    <option value="60">שעה</option>
                                    <option value="90">שעה וחצי</option>
                                </select>
                                <button class="remove-break">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- היסטוריית עבודות -->
            <div class="details-card work-history">
                <h2>היסטוריית עבודות</h2>

                <!-- סיכום חודשי -->
                <%-- <div class="monthly-summary">
        <div class="summary-header">
            <h3>סיכום חודשי - מרץ 2024</h3>
            <div class="summary-controls">
                <button class="month-nav prev-month">
                    <i class="fas fa-chevron-right"></i>
                </button>
                <button class="month-nav next-month">
                    <i class="fas fa-chevron-left"></i>
                </button>
            </div>
        </div>
        <div class="summary-stats">
            <div class="summary-stat">
                <span class="stat-label">סה"כ עבודות</span>
                <span class="stat-value">24</span>
            </div>
            <div class="summary-stat">
                <span class="stat-label">הכנסות</span>
                <span class="stat-value">₪4,850</span>
            </div>
            <div class="summary-stat">
                <span class="stat-label">דירוג ממוצע</span>
                <span class="stat-value">4.8 <i class="fas fa-star"></i></span>
            </div>
        </div>
    </div>--%>

                <!-- רשימת העבודות -->
                <div class="work-list">
                    <div class="list-filters">
                        <div class="filter-group">
                            <label>סינון לפי:</label>
                            <select class="filter-select">
                                <option value="all">הכל</option>
                                <option value="completed">הושלמו</option>
                                <option value="pending">בתהליך</option>
                                <option value="cancelled">בוטלו</option>
                            </select>
                            <select class="filter-select">
                                <option value="all">כל הסוגים</option>
                                <option value="ac">מזגנים</option>
                                <option value="plumbing">אינסטלציה</option>
                                <option value="electricity">חשמל</option>
                            </select>
                        </div>
                        <div class="search-group">
                            <input type="search" placeholder="חיפוש..." class="search-input">
                        </div>
                    </div>

                    <div class="work-items">
                        <div class="work-item">
                            <div class="work-header">
                                <div class="work-title">
                                    <h4>תיקון מזגן תדיראן</h4>
                                    <span class="work-date">15.03.2024</span>
                                </div>
                                <span class="work-status completed">הושלם</span>
                            </div>
                            <div class="work-details">
                                <div class="work-info">
                                    <p class="work-description">החלפת קבל והשלמת גז</p>
                                    <span class="work-location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        תל אביב, דיזנגוף 123
                                    </span>
                                </div>
                                <div class="work-meta">
                                    <div class="price-rating">
                                        <span class="work-price">₪450</span>
                                        <span class="work-rating">
                                            <i class="fas fa-star"></i>
                                            4.8
                                        </span>
                                    </div>
                                    <button class="view-details-btn">פרטים נוספים</button>
                                </div>
                            </div>
                        </div>

                        <div class="work-item">
                            <div class="work-header">
                                <div class="work-title">
                                    <h4>התקנת מזגן אלקטרה</h4>
                                    <span class="work-date">10.03.2024</span>
                                </div>
                                <span class="work-status completed">הושלם</span>
                            </div>
                            <div class="work-details">
                                <div class="work-info">
                                    <p class="work-description">התקנה מלאה כולל תשתיות</p>
                                    <span class="work-location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        רמת גן, ביאליק 45
                                    </span>
                                </div>
                                <div class="work-meta">
                                    <div class="price-rating">
                                        <span class="work-price">₪1,200</span>
                                        <span class="work-rating">
                                            <i class="fas fa-star"></i>
                                            5.0
                                        </span>
                                    </div>
                                    <button class="view-details-btn">פרטים נוספים</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="pagination">
                        <button class="page-nav prev-page">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                        <div class="page-numbers">
                            <span class="page-number active">1</span>
                            <span class="page-number">2</span>
                            <span class="page-number">3</span>
                        </div>
                        <button class="page-nav next-page">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>



</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <script>
        // מערך של נתיבי תמונות - החלף את הנתיבים באלו של התמונות שלך
        const backgroundImages = [
            '/assets/images/photo-long-2.jpg',
            '/assets/images/photo-long-2.jpg ',
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


        let isEditMode = false;

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

        // פונקציית העריכה
        function toggleEditMode() {
            isEditMode = !isEditMode;
            const modalContent = document.querySelector('.modal-content');
            const editBtn = document.querySelector('.edit-mode-btn');
            const saveBtn = document.querySelector('.save-changes-btn');

            if (isEditMode) {
                // עובר למצב עריכה
                modalContent.classList.add('edit-mode');
                editBtn.style.display = 'none';
                saveBtn.style.display = 'flex';

                // מציג את שדות הקלט ומעתיק אליהם את הערכים הנוכחיים
                const infoRows = document.querySelectorAll('.info-row');
                infoRows.forEach(row => {
                    const value = row.querySelector('.info-value')?.textContent || '';
                    const input = row.querySelector('.edit-input');
                    if (input) {
                        input.value = value.trim();
                        input.style.display = 'block';
                    }
                });
            } else {
                // חוזר למצב תצוגה
                modalContent.classList.remove('edit-mode');
                editBtn.style.display = 'flex';
                saveBtn.style.display = 'none';

                // מסתיר את שדות הקלט
                document.querySelectorAll('.edit-input').forEach(input => {
                    input.style.display = 'none';
                });
            }
        }

        // הוספת פונקציה לטעינת נתוני הטכנאי
        function loadTechnicianData() {
            if (typeof technicianData !== 'undefined') {
                // טעינת הנתונים לשדות הקלט
                document.querySelector('#fullNameInput').value = technicianData.fullName;
                document.querySelector('#phoneInput').value = technicianData.phone;
                document.querySelector('#addressInput').value = technicianData.address;
                document.querySelector('#specializationInput').value = technicianData.type;
                document.querySelector('#EmailInput').value = technicianData.email;

                // עדכון ערכי התצוגה
                document.querySelectorAll('.info-value').forEach(element => {
                    const input = element.nextElementSibling;
                    if (input && input.value) {
                        element.textContent = input.value;
                    }
                });
            }
        }

        // עדכון פונקציית השמירה
        async function saveAllChanges() {
            const saveBtn = document.querySelector('.save-changes-btn');
            try {
                saveBtn.disabled = true;
                saveBtn.innerHTML = 'שומר...';

                var data = {
                    technicianData: {
                        TecId: parseInt(document.getElementById('<%= hdnTecId.ClientID %>').value),
                        FulName: document.getElementById('<%= fullNameInput.ClientID %>').value,
                        Phone: document.getElementById('<%= phoneInput.ClientID %>').value,
                        Address: document.getElementById('<%= addressInput.ClientID %>').value,
                        Type: document.getElementById('<%= specializationInput.ClientID %>').value,
                        Email: document.getElementById('<%= EmailInpot.ClientID %>').value
                    }
                };

                const response = await fetch('MainTechnicians.aspx/UpdateProfile', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                const result = await response.json();

                if (result.d && result.d.success) {
                    // עדכון ממשק המשתמש
                    document.querySelectorAll('.info-row').forEach(row => {
                        const input = row.querySelector('.edit-input');
                        const valueSpan = row.querySelector('.info-value');
                        if (input && valueSpan) {
                            valueSpan.textContent = input.value;
                        }
                    });

                    toggleEditMode();
                    alert('הפרטים נשמרו בהצלחה!');
                    location.reload();
                } else {
                    throw new Error(result.d.message || 'שגיאה בעדכון הפרטים');
                }
            } catch (error) {
                console.error('שגיאה:', error);
                alert('שגיאה בשמירת הנתונים: ' + error.message);
            } finally {
                saveBtn.disabled = false;
                saveBtn.innerHTML = '<i class="fas fa-save"></i><span class="btn-text">שמור שינויים</span>';
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            // טעינת נתוני הטכנאי
            loadTechnicianData();

            // אתחול מאזיני אירועים לכפתורים
            document.querySelector('.edit-mode-btn').addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                toggleEditMode();
            });

            document.querySelector('.save-changes-btn').addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                saveAllChanges();
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
