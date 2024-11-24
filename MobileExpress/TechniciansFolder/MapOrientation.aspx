<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="MapOrientation.aspx.cs" Inherits="MobileExpress.TechniciansFolder.MapOrientation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- בראש הדף -->
    <meta http-equiv="Content-Security-Policy" content="geolocation 'self'">
    <!-- סגנונות -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- jQuery ראשון -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Google Maps API - עם callback -->
    <script>
        function initGoogleMaps() {
            console.log("Google Maps script loaded");
            if (typeof initMap === 'function') {
                initMap();
            }
        }
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBTDLC_uiYwIrAB6-7TCxAPg4AfO3-CbAY&libraries=places&callback=initMap">
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <header class="main-header">
        <!-- תפריט המבורגר בצד שמאל -->
        <button class="menu-toggle">
            ☰
   
        </button>

        <!-- כותרת ותת כותרת במרכז -->
        <div class="header-content">
            <h1 class="header-title">מסלול טיול
           
                <span class="header-subtitle">יותר מ-100 הצעות מסביב תל אביב יפו</span>
            </h1>
        </div>

        <!-- לוגו בצד ימין -->
        <div class="logo-container">
            <img src="path-to-logo.png" alt="Easy Logo" class="easy-logo">
        </div>

        <div class="header-border"></div>
    </header>



    <style>
        .map-container {
            display: flex;
            height: 100vh;
            margin-top: 0;
            position: relative;
        }

        #map {
            flex: 1;
            height: 100%;
            position: relative;
        }

        .sidebar {
            width: 450px;
            background: white;
            box-shadow: -2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
            height: 100vh;
            margin: 0;
            padding: 0;
        }

        /* אם יש טולבר, הוא יהיה בתוך הסיידבר */
        .toolbar {
            position: sticky;
            top: 0;
            z-index: 10;
            background: #6B46C1;
            color: white;
            padding: 10px 15px;
            width: 100%;
        }

        /* עדכון לפילטרים כך שיישארו צמודים לטולבר */
        .filter-container {
            position: sticky;
            top: 0; /* אם יש טולבר, שנה ל-top: [גובה הטולבר] */
            z-index: 9;
            background: white;
            margin: 0;
            padding: 10px 15px;
            border-bottom: 1px solid #E9D8FD;
        }

        .main-header {
            background: #6B46C1;
            width: 100%;
            height: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            direction: rtl;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: relative;
        }

        .header-title {
            color: white;
            font-size: 1.2em;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.9em;
            font-weight: normal;
        }

        .logo-container {
            display: flex;
            align-items: center;
        }

        /* המבורגר מניו בצד שמאל */
        .menu-toggle {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            padding: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: auto; /* דוחף לצד שמאל */
        }

        /* לוגו בצד ימין */
        .easy-logo {
            height: 30px;
            margin-left: 20px;
        }

        /* אם יש צורך בקו תחתון */
        .header-border {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: rgba(255, 255, 255, 0.1);
        }

        /* מעטפת לתוכן המרכזי */
        .header-content {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        #map {
            flex: 1;
            height: 100%;
            position: relative;
        }

        .sidebar {
            width: 450px;
            background: white;
            box-shadow: -2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
            margin-top: 0; /* וידוא שאין margin נוסף */
            height: 100%; /* וידוא שהסייבר בר ממלא את כל הגובה */
        }

        /* Ensure no extra spacing from body/html */
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }

        /* If you have a toolbar or navigation */
        .toolbar {
            height: 50px;
            padding: 0 15px;
            display: flex;
            align-items: center;
            background: #6B46C1;
            color: white;
        }

        #map {
            flex: 1;
            height: 100%;
        }

        .sidebar {
            width: 450px;
            background: white;
            box-shadow: -2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
        }

        .search-box {
            padding: 20px;
            background: white;
            border-bottom: 1px solid #eee;
        }

        .main-title {
            color: white;
            background: #6B46C1; /* Changed to purple */
            padding: 15px 20px;
            margin: 0;
            font-size: 1.2em;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .search-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 14px;
        }

        /* Redesigned call item section */
        /* Base call item container */
        .call-item {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin: 15px;
            box-shadow: 0 3px 10px rgba(107, 70, 193, 0.1);
            border: 1px solid #E9D8FD;
            transition: all 0.3s ease;
            max-width: 100%;
            overflow: hidden;
        }

        /* Header section with user info */
        .location-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            border-bottom: 2px solid #E9D8FD;
            padding-bottom: 10px;
            width: 100%;
        }

        /* User name handling */
        .location-info {
            flex: 1;
            min-width: 0; /* Important for text truncation */
        }

        .location-name {
            color: #553C9A;
            font-size: 1.1em;
            font-weight: 600;
            margin-bottom: 5px;
            text-decoration: none;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 100%;
        }

        .location-type {
            color: #6B46C1;
            font-size: 0.9em;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Meta information layout */
        .location-meta {
            display: flex;
            flex-wrap: wrap; /* Allow wrapping for long content */
            gap: 8px;
            color: #553C9A;
            font-size: 0.9em;
            margin-top: 10px;
            align-items: center;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            background: #FAF5FF;
            padding: 5px 8px;
            border-radius: 6px;
            max-width: calc(100% - 16px); /* Account for padding */
            min-width: 0; /* Enable truncation */
        }

            /* Phone number specific styling */
            .meta-item[title] {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

        /* Text content */
        .review-text,
        .status-text {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 100%;
        }

        /* Status section */
        .status-indicator {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9em;
            color: #553C9A;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Description area */
        .description {
            color: #553C9A;
            font-size: 0.9em;
            line-height: 1.4;
            word-wrap: break-word;
            overflow-wrap: break-word;
            max-width: 100%;
        }

        /* Add tooltip for truncated content */
        [data-tooltip] {
            position: relative;
            cursor: help;
        }

            [data-tooltip]:hover::before {
                content: attr(data-tooltip);
                position: absolute;
                bottom: 100%;
                left: 50%;
                transform: translateX(-50%);
                padding: 5px 10px;
                background: #553C9A;
                color: white;
                border-radius: 4px;
                font-size: 0.8em;
                white-space: nowrap;
                z-index: 1000;
            }

        /* Badge/pill for call number */
        .call-number {
            background: #6B46C1;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.85em;
            white-space: nowrap;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Responsive adjustments */
        @media screen and (max-width: 480px) {
            .location-meta {
                flex-direction: column;
                align-items: flex-start;
            }

            .meta-item {
                width: 100%;
            }
        }

        .location-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            border-bottom: 2px solid #E9D8FD;
            padding-bottom: 10px;
        }

        .location-info {
            flex: 1;
        }

        .location-name {
            color: #553C9A; /* Darker purple */
            font-size: 1.1em;
            font-weight: 600;
            margin-bottom: 5px;
            text-decoration: none;
        }

        .location-type {
            color: #6B46C1; /* Main purple */
            font-size: 0.9em;
            margin-bottom: 5px;
        }

        .rating {
            background: #805AD5; /* Light purple */
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .location-meta {
            display: flex;
            gap: 15px;
            color: #553C9A;
            font-size: 0.9em;
            margin-top: 10px;
            align-items: center;
            justify-content: flex-start;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            background: #FAF5FF; /* Very light purple background */
            padding: 5px 10px;
            border-radius: 6px;
        }

            .meta-item i {
                color: #6B46C1;
            }

        /* Filter container styling */
        .filter-container {
            padding: 15px 20px;
            background: white;
            border-bottom: 1px solid #E9D8FD;
            direction: rtl;
        }

        /* Custom select styling */
        .filter-select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            width: 200px;
            padding: 10px 15px 10px 35px; /* Updated padding for RTL */
            font-size: 0.95em;
            color: #553C9A;
            background: #FAF5FF url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%23553C9A' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E") no-repeat;
            background-position: left 8px center;
            background-size: 16px;
            border: 2px solid #E9D8FD;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: right; /* Added for RTL text alignment */
            direction: rtl; /* Added for RTL text direction */
        }

            .filter-select option {
                text-align: right; /* Ensure options are right-aligned */
                direction: rtl; /* Ensure options follow RTL direction */
                padding: 10px 15px;
                background: white;
                color: #553C9A;
            }

            .filter-select:hover {
                border-color: #805AD5;
                background-color: #F3E8FF;
            }

            .filter-select:focus {
                outline: none;
                border-color: #6B46C1;
                box-shadow: 0 0 0 3px rgba(107, 70, 193, 0.2);
            }

            /* הוספת סטיילינג לתפריט הנפתח עצמו */
            .filter-select option:hover,
            .filter-select option:focus,
            .filter-select option:active,
            .filter-select option:checked {
                background: #F3E8FF;
                color: #6B46C1;
            }

        /* Filter group styling */
        .filter-group {
            position: relative;
            margin-right: auto;
            display: flex;
            align-items: center;
            gap: 15px;
            direction: rtl;
        }

        /* Custom dropdown styling */
        select::-ms-expand {
            display: none;
        }

        /* Responsive adjustments */
        @media screen and (max-width: 768px) {
            .filter-select {
                width: 100%;
            }

            .filter-group {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }

        .status-indicators {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9em;
            color: #553C9A;
        }

        .indicator-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }

        .dot-open {
            background: #4CAF50;
        }

        .dot-closed {
            background: #f44336;
        }

        .dot-favorite {
            color: #805AD5;
        }

        .custom-map-control-button {
            background-color: #fff;
            border: 0;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(107, 70, 193, 0.2);
            cursor: pointer;
            margin: 10px;
            padding: 0 0.5em;
            height: 40px;
            font: 400 18px Roboto, Arial, sans-serif;
            overflow: hidden;
            color: #6B46C1;
            transition: all 0.3s ease;
        }

            .custom-map-control-button:hover {
                background: #FAF5FF;
            }

        /* Additional improvements for the calls section */
        .review-section {
            background: #FAF5FF;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }

        .review-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #553C9A;
        }

        .reviewer-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #E9D8FD;
        }

        .review-text {
            color: #553C9A;
            font-size: 0.9em;
            line-height: 1.4;
        }

        .highlight {
            background-color: yellow;
            transition: background-color 1s ease;
        }

        .call-item {
            display: block; /* וודא שהאלמנט גלוי */
        }
    </style>

    <div class="map-container">
        <div id="map"></div>
        <div class="sidebar">
            <h1 class="main-title"><%--מפה והתמצאות--%>
                <span><%--100 תושבים סביב תל אביב-יפו--%></span>
            </h1>

            <div class="search-box">
                <input type="text" class="search-input" placeholder="חיפוש...">
            </div>

            <%-- <div class="filters">
                <button class="filter-btn active">פתוח עכשיו</button>
                <button class="filter-btn">יום ושעה</button>
                <button class="filter-btn">פתוח בשבת</button>
                <button class="filter-btn">פתוח בלילה</button>
            </div>--%>

            <h2 class="mt-4 mb-3"></h2>
            <%-- סינון --%>
            <div class="filter-container">
                <div class="filter-group">
                    <label for="StatusFilter" class="filter-label"></label>
                    <asp:DropDownList ID="StatusFilter" runat="server"
                        CssClass="filter-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="StatusFilter_SelectedIndexChanged">
                        <asp:ListItem Text="כל הקריאות" Value="" />
                        <asp:ListItem Text="קריאות פתוחות" Value="true" />
                        <asp:ListItem Text="קריאות סגורות" Value="false" />
                    </asp:DropDownList>
                </div>
            </div>

            <%-- רשימת הקריאות --%>
            <asp:Repeater ID="ServiceCallsRepeater" runat="server">
                <ItemTemplate>
                    <div class="call-item">
                        <div class="location-header">
                            <div class="location-info">

                                <div id="call-<%# Eval("ReadId") %>">
                                    <a href='AllRead.aspx?readId=<%# Eval("ReadId") %>' class="location-name">קריאת שירות #<%# Eval("ReadId") %>
                                    </a>
                                </div>




                                <div class="location-type <%# Convert.ToBoolean(Eval("Status")) ? "status-open" : "status-closed" %>">
                                    <%# GetStatusText(Convert.ToBoolean(Eval("Status"))) %>
                                </div>
                            </div>
                            <div class="rating">
                                <i class="fas fa-exclamation-circle <%# GetUrgencyClass(Eval("Urgency").ToString()) %>"></i>
                                <span><%# GetUrgencyText(Eval("Urgency").ToString()) %></span>
                            </div>
                        </div>
                        <div class="location-meta">
                            <span class="meta-item">
                                <i class="fas fa-user"></i>
                                <%# Eval("FullName") %>
                            </span>
                            <span class="meta-item">
                                <i class="fas fa-clock"></i>
                                <%# ((DateTime)Eval("DateRead")).ToString("dd/MM/yyyy HH:mm") %>
                            </span>
                            <span class="meta-item">
                                <i class="fas fa-phone"></i>
                                <%# Eval("Phone") %>
                            </span>
                            <%--<span class="meta-item">
                                <i class="fas fa-cog"></i>
                                מודל: <%# GetModelName(Convert.ToInt32(Eval("ModelId"))) %>
                            </span>--%>
                        </div>
                           <div class="detail-item">
                                                <span class="detail-label"></span>
                                                <a href='MapOrientation.aspx?readId=<%# Eval("ReadId") %>' class="location-link">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    הצג מיקום
                                                                 </a>
                                            </div>
                        <div class="review-section">
                            <div class="review-header">
                               <%-- <div class="reviewer-avatar"></div>--%>
                               <span style="font-weight: bold; color: #553C9A">:תיאור התקלה</span>


                            </div>

                            <p class="review-text"><%# Eval("Desc") %></p>
                         <%--   <%# !string.IsNullOrEmpty(Eval("Nots").ToString()) ? $"<p class='review-text'><strong>הערות:</strong> {Eval("Nots")}</p>" : "" %>--%>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <%-- <div class="search-box">
        <input type="text" class="search-input" placeholder="חיפוש...">
        <button id="getCurrentLocationBtn" class="filter-btn">
            <i class="fas fa-location-arrow"></i>מצא את מיקומי
   
        </button>
    </div>--%>

    <div id="directionsPanel" style="width: 100%; height: 100%; overflow: auto; padding: 10px;"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <script>
        // החלפת סקריפט קיים עם זה:
        $(document).ready(function () {
            // אתחול המפה



            let markers = []; // מערך לשמירת הסמנים במפה

            // פונקציה לטעינת הקריאות מהשרת
            function loadServiceCalls() {
                $.ajax({
                    url: 'MapOrientation.aspx/GetServiceCalls',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (response) {
                        if (response.d && response.d.length > 0) {  // שינוי בבדיקה
                            // ניקוי סמנים קיימים
                            clearMarkers();

                            // יצירת רשימת הקריאות
                            createCallsList(response.d);

                            // הוספת סמנים למפה
                            response.d.forEach(call => {
                                if (call.Latitude && call.Longitude) {  // וודא שיש נתוני מיקום
                                    const position = {
                                        lat: parseFloat(call.Latitude),
                                        lng: parseFloat(call.Longitude)
                                    };

                                    const marker = new google.maps.Marker({  // שימוש ב-Google Maps במקום Mapbox
                                        position: position,
                                        map: map,
                                        title: `קריאה #${call.ReadId}`
                                    });
                                    markers.push(marker);
                                }
                            });
                        } else {
                            console.log('No service calls found');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error loading service calls:', error);
                        alert('אירעה שגיאה בטעינת הנתונים');
                    }
                });
            }

            // פונקציה ליצירת רשימת הקריאות
            function createCallsList(calls) {
                const callsList = document.querySelector('.calls-list');
                callsList.innerHTML = '';

                calls.forEach(call => {
                    const callElement = document.createElement('div');
                    callElement.className = 'call-item';
                    callElement.innerHTML = `
                <div class="call-header">
                    <span class="call-type">${call.type}</span>
                    <span class="call-status status-${call.status.toLowerCase()}">${call.status}</span>
                </div>
                <div class="call-details">
                    <div class="call-address">${call.address}</div>
                    <div class="call-time">${call.timeCreated}</div>
                </div>
                <div class="call-actions">
                    <button class="accept-btn" onclick="acceptCall(${call.id})">קבל קריאה</button>
                </div>
            `;

                    callElement.onclick = () => showCallDetails(call);
                    callsList.appendChild(callElement);
                });
            }

            // פונקציה לקבלת קריאה
            window.acceptCall = function (callId) {
                $.ajax({
                    url: 'MapOrientation.aspx/AcceptServiceCall',
                    type: 'POST',
                    data: JSON.stringify({ callId: callId }),
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (response) {
                        if (response.d.success) {
                            alert(response.d.message);
                            loadServiceCalls(); // טעינה מחדש של הקריאות
                        } else {
                            alert(response.d.message);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error accepting call:', error);
                        alert('אירעה שגיאה בקבלת הקריאה');
                    }
                });
            };

            // פונקציה להצגת פרטי קריאה במודאל
            window.showCallDetails = function (call) {
                const modal = document.getElementById('callModal');
                const details = document.getElementById('callDetails');
                details.innerHTML = `
            <p><strong>סוג קריאה:</strong> ${call.type}</p>
            <p><strong>סטטוס:</strong> ${call.status}</p>
            <p><strong>כתובת:</strong> ${call.address}</p>
            <p><strong>תיאור:</strong> ${call.description}</p>
            <p><strong>שם לקוח:</strong> ${call.customerName}</p>
            <p><strong>טלפון:</strong> ${call.phone}</p>
            <p><strong>זמן יצירה:</strong> ${call.timeCreated}</p>
        `;
                modal.style.display = 'block';
            };

            // טעינה ראשונית של הנתונים
            loadServiceCalls();

            // רענון נתונים כל דקה
            setInterval(loadServiceCalls, 60000);

            // הגדרת מאזיני אירועים לסינון
            $('.filter-btn').click(function () {
                $('.filter-btn').removeClass('active');
                $(this).addClass('active');
                // כאן תוכל להוסיף לוגיקת סינון
            });

            // חיפוש
            $('.search-input').on('input', function () {
                const searchTerm = $(this).val().toLowerCase();
                $('.call-item').each(function () {
                    const text = $(this).text().toLowerCase();
                    $(this).toggle(text.includes(searchTerm));
                });
            });
        });

        function createCallItem(call) {
            return `
        <div class="call-item">
            <div class="location-header">
                <div class="location-info">
                    <a href="#" class="location-name">קריאת שירות #${call.id}</a>
                    <div class="location-type">${call.type} - ${call.status}</div>
                </div>
                <div class="rating">
                    <i class="fas fa-star"></i>
                    <span>${call.rating || '4.8'}</span>
                </div>
            </div>
            
            <div class="location-meta">
                <span class="meta-item">
                    <i class="fas fa-map-marker-alt"></i>
                    ${call.address}
                </span>
                <span class="meta-item">
                    <i class="fas fa-clock"></i>
                    ${call.estimatedTime || '15 דקות'}
                </span>
                <span class="meta-item">
                    <i class="fas fa-eye"></i>
                    ${call.views || '0'}
                </span>
            </div>

            <div class="review-section">
                <div class="review-header">
                    <div class="reviewer-avatar"></div>
                    <span>תיאור הבעיה</span>
                </div>
                <p class="review-text">${call.description}</p>
            </div>
        </div>
    `;
        }

        // עדכון פונקציית יצירת הרשימה
        function createCallsList(calls) {
            const callsList = document.querySelector('.calls-list');
            callsList.innerHTML = '';
            calls.forEach(call => {
                callsList.innerHTML += createCallItem(call);
            });
        }
        // Global variables
        // Global variables
        let map;
        let markers = [];
        let placesService;
        let autocomplete;
        const israelCenter = { lat: 32.0853, lng: 34.7818 };

        function initMap() {
            try {
                map = new google.maps.Map(document.getElementById('map'), {
                    center: israelCenter,
                    zoom: 13,
                    streetViewControl: false,
                    mapTypeControl: false,
                    language: 'he'
                });

                initializeHebrewSearch();
                loadDemoData();
                console.log("Map initialized successfully");
            } catch (error) {
                console.error("Error initializing map:", error);
            }
        }

        function initializeHebrewSearch() {
            const input = document.querySelector('.search-input');
            const options = {
                componentRestrictions: { country: 'il' },
                fields: ['address_components', 'geometry', 'name', 'formatted_address'],
                language: 'he',
                types: ['geocode', 'establishment']
            };

            autocomplete = new google.maps.places.Autocomplete(input, options);
            placesService = new google.maps.places.PlacesService(map);

            map.addListener('bounds_changed', () => {
                autocomplete.setBounds(map.getBounds());
            });

            autocomplete.addListener('place_changed', () => {
                const place = autocomplete.getPlace();
                if (!place.geometry) return;

                if (place.geometry.viewport) {
                    map.fitBounds(place.geometry.viewport);
                } else {
                    map.setCenter(place.geometry.location);
                    map.setZoom(17);
                }

                const marker = new google.maps.Marker({
                    map: map,
                    position: place.geometry.location,
                    animation: google.maps.Animation.DROP,
                    title: place.name
                });

                const infowindow = new google.maps.InfoWindow({
                    content: `
                <div style="direction: rtl; padding: 10px;">
                    <h3>${place.name}</h3>
                    <p>${place.formatted_address}</p>
                    ${place.formatted_phone_number ? `<p>טלפון: ${place.formatted_phone_number}</p>` : ''}
                    ${place.website ? `<p><a href="${place.website}" target="_blank">אתר אינטרנט</a></p>` : ''}
                </div>
            `
                });

                marker.addListener('click', () => {
                    infowindow.open(map, marker);
                });

                searchNearbyPlaces(place.geometry.location);
            });
        }

        function searchNearbyPlaces(location) {
            const request = {
                location: location,
                radius: '1000',
                type: ['business']
            };

            placesService.nearbySearch(request, (results, status) => {
                if (status === google.maps.places.PlacesServiceStatus.OK) {
                    results.forEach(place => createPlaceMarker(place));
                }
            });
        }

        function createPlaceMarker(place) {
            const marker = new google.maps.Marker({
                map: map,
                position: place.geometry.location,
                title: place.name,
                icon: {
                    url: place.icon,
                    scaledSize: new google.maps.Size(25, 25)
                }
            });

            const infowindow = new google.maps.InfoWindow({
                content: `
            <div style="direction: rtl; padding: 10px;">
                <h3>${place.name}</h3>
                <p>${place.vicinity}</p>
                ${place.rating ? `<p>דירוג: ${place.rating} ⭐</p>` : ''}
            </div>
        `
            });

            marker.addListener('click', () => {
                infowindow.open(map, marker);
            });
        }

        function addMarker(location, title, call) {
            const marker = new google.maps.Marker({
                position: location,
                map: map,
                title: title,
                animation: google.maps.Animation.DROP,
                icon: {
                    url: 'https://maps.google.com/mapfiles/ms/icons/blue-dot.png'
                }
            });

            const infoWindow = new google.maps.InfoWindow({
                content: `
            <div style="direction: rtl; padding: 10px;">
                <h3 style="margin: 0 0 5px;">${title}</h3>
                <p style="margin: 5px 0;">${call.address}</p>
                <button onclick="showCallDetails(${JSON.stringify(call).replace(/"/g, '&quot;')})" 
                        style="background: #007bff; color: white; border: none; 
                               padding: 5px 10px; border-radius: 4px; cursor: pointer;">
                    הצג פרטים
                </button>
            </div>`
            });

            marker.addListener('click', () => {
                infoWindow.open(map, marker);
            });

            markers.push(marker);
            return marker;
        }

        function clearMarkers() {
            markers.forEach(marker => marker.setMap(null));
            markers = [];
        }

        function loadDemoData() {
            const demoData = [{
                id: 1234,
                type: "תיקון מזגן",
                status: "חדש",
                address: "רחוב דיזנגוף 123, תל אביב",
                description: "מזגן לא מקרר",
                customerName: "ישראל ישראלי",
                phone: "050-1234567",
                coordinates: { lat: 32.0853, lng: 34.7818 },
                rating: "4.8",
                views: "18667",
                estimatedTime: "15 דקות"
            }];

            clearMarkers();
            createCallsList(demoData);
            demoData.forEach(call => addMarker(call.coordinates, `קריאה #${call.id}`, call));
        }

        function createCallsList(calls) {
            const callsList = document.querySelector('.calls-list');
            callsList.innerHTML = '';
            calls.forEach(call => {
                callsList.innerHTML += createCallItem(call);
            });
        }

        function createCallItem(call) {
            return `
        <div class="call-item">
            <div class="location-header">
                <div class="location-info">
                    <a href="#" class="location-name">קריאת שירות #${call.id}</a>
                    <div class="location-type">${call.type} - ${call.status}</div>
                </div>
                <div class="rating">
                    <i class="fas fa-star"></i>
                    <span>${call.rating}</span>
                </div>
            </div>
            
            <div class="location-meta">
                <span class="meta-item">
                    <i class="fas fa-map-marker-alt"></i>
                    ${call.address}
                </span>
                <span class="meta-item">
                    <i class="fas fa-clock"></i>
                    ${call.estimatedTime}
                </span>
                <span class="meta-item">
                    <i class="fas fa-eye"></i>
                    ${call.views}
                </span>
            </div>

            <div class="review-section">
                <div class="review-header">
                    <span>תיאור הבעיה</span>
                </div>
                <p class="review-text">${call.description}</p>
            </div>
        </div>`;
        }

        function showCallDetails(call) {
            const modal = document.getElementById('callModal');
            const details = document.getElementById('callDetails');
            details.innerHTML = `
        <div class="call-details">
            <p><strong>סוג קריאה:</strong> ${call.type}</p>
            <p><strong>סטטוס:</strong> ${call.status}</p>
            <p><strong>כתובת:</strong> ${call.address}</p>
            <p><strong>תיאור:</strong> ${call.description}</p>
            <p><strong>שם לקוח:</strong> ${call.customerName}</p>
            <p><strong>טלפון:</strong> ${call.phone}</p>
            <p><strong>זמן משוער:</strong> ${call.estimatedTime}</p>
        </div>`;
            modal.style.display = 'block';
        }

        // Event Listeners
        document.addEventListener('DOMContentLoaded', () => {
            if (typeof google === 'undefined') {
                console.log("Waiting for Google Maps to load...");
            } else {
                console.log("Google Maps already loaded");
                initMap();
            }
        });

        document.querySelector('.close-modal')?.addEventListener('click', () => {
            document.getElementById('callModal').style.display = 'none';
        });

        document.querySelectorAll('.filter-btn').forEach(button => {
            button.addEventListener('click', function () {
                document.querySelectorAll('.filter-btn').forEach(btn =>
                    btn.classList.remove('active'));
                this.classList.add('active');
            });
        });
        // פונקציה משופרת לקבלת מיקום המשתמש
        function getUserLocation() {
            // בדיקת תמיכה בשירותי מיקום
            if (!navigator.geolocation) {
                alert("הדפדפן שלך לא תומך בשירותי מיקום");
                return;
            }

            // הגדרות מיקום מותאמות
            const options = {
                enableHighAccuracy: true,  // דיוק גבוה
                timeout: 10000,           // זמן המתנה מקסימלי (10 שניות)
                maximumAge: 0            // לא להשתמש במיקום מהמטמון
            };

            // בקשת מיקום עם טיפול מפורט בשגיאות
            navigator.geolocation.getCurrentPosition(
                // הצלחה
                (position) => {
                    userLocation = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };

                    // הוספת סמן למיקום המשתמש
                    const userMarker = new google.maps.Marker({
                        position: userLocation,
                        map: map,
                        icon: {
                            url: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png'
                        },
                        title: 'מיקומך הנוכחי',
                        zIndex: 999 // להציג מעל סמנים אחרים
                    });

                    // מרכוז המפה למיקום המשתמש
                    map.setCenter(userLocation);
                    map.setZoom(15);

                    console.log("מיקום המשתמש נמצא בהצלחה:", userLocation);
                },
                // טיפול בשגיאות
                (error) => {
                    let errorMessage;
                    switch (error.code) {
                        case error.PERMISSION_DENIED:
                            errorMessage = "נדחתה הגישה למיקום. אנא אפשר גישה למיקום בהגדרות הדפדפן";
                            break;
                        case error.POSITION_UNAVAILABLE:
                            errorMessage = "מידע המיקום אינו זמין";
                            break;
                        case error.TIMEOUT:
                            errorMessage = "פג הזמן המוקצב לבקשת המיקום";
                            break;
                        case error.UNKNOWN_ERROR:
                            errorMessage = "אירעה שגיאה לא ידועה";
                            break;
                    }
                    console.error("שגיאת מיקום:", errorMessage);
                    alert(errorMessage);
                },
                options
            );
        }

        // להוסיף כפתור מיקום לממשק
        function addLocationButton() {
            const locationButton = document.createElement('button');
            locationButton.classList.add('custom-map-control-button');
            locationButton.innerHTML = '<i class="fas fa-location-arrow"></i>';
            locationButton.title = 'מצא את מיקומי';

            locationButton.style.cssText = `
        background-color: #fff;
        border: none;
        border-radius: 2px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.3);
        cursor: pointer;
        margin: 10px;
        padding: 10px;
        text-align: center;
        width: 40px;
        height: 40px;
    `;

            locationButton.addEventListener('click', () => {
                getUserLocation();
            });

            map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(locationButton);
        }

        // עדכון פונקציית האתחול
        function initMap() {
            try {
                map = new google.maps.Map(document.getElementById('map'), {
                    center: israelCenter,
                    zoom: 13,
                    streetViewControl: false,
                    mapTypeControl: false,
                    language: 'he'
                });

                addLocationButton(); // הוספת כפתור מיקום
                initializeHebrewSearch();
                loadDemoData();

                // בקשת מיקום ראשונית
                getUserLocation();

            } catch (error) {
                console.error("שגיאה באתחול המפה:", error);
            }
        }

        // פונקציה לניווט ליעד
        function navigateTo(destination) {
            if (!userLocation) {
                alert("אנא אפשר גישה למיקומך כדי להתחיל בניווט");
                return;
            }

            const directionsService = new google.maps.DirectionsService();
            const directionsRenderer = new google.maps.DirectionsRenderer({
                map: map,
                panel: document.getElementById('directionsPanel')
            });

            // בקשת מסלול
            directionsService.route({
                origin: userLocation,
                destination: destination,
                travelMode: google.maps.TravelMode.DRIVING,
                language: 'he'
            }, (response, status) => {
                if (status === 'OK') {
                    directionsRenderer.setDirections(response);

                    // הצגת פאנל ההוראות
                    document.getElementById('directionsPanel').style.display = 'block';
                } else {
                    alert("לא הצלחנו לחשב מסלול ליעד המבוקש");
                }
            });
        }

        // עדכון פונקציית יצירת חלון המידע
        function updateInfoWindowContent(place) {
            return `
        <div style="direction: rtl; padding: 10px;">
            <h3>${place.name}</h3>
            <p>${place.formatted_address || place.vicinity}</p>
            ${place.formatted_phone_number ? `<p>טלפון: ${place.formatted_phone_number}</p>` : ''}
            ${place.website ? `<p><a href="${place.website}" target="_blank">אתר אינטרנט</a></p>` : ''}
            ${place.rating ? `<p>דירוג: ${place.rating} ⭐</p>` : ''}
            <button onclick="navigateTo('${place.formatted_address || place.vicinity}')" 
                    style="background: #4CAF50; color: white; border: none; 
                           padding: 8px 16px; border-radius: 4px; cursor: pointer; 
                           margin-top: 10px; width: 100%;">
                <i class="fas fa-directions"></i> נווט לכאן
            </button>
        </div>
    `;
        }

        // עדכון פונקציית האתחול
        function initMap() {
            try {
                map = new google.maps.Map(document.getElementById('map'), {
                    center: israelCenter,
                    zoom: 13,
                    streetViewControl: false,
                    mapTypeControl: false,
                    language: 'he'
                });

                // קבלת מיקום המשתמש
                getUserLocation();

                initializeHebrewSearch();
                loadDemoData();

                console.log("המפה אותחלה בהצלחה");
            } catch (error) {
                console.error("שגיאה באתחול המפה:", error);
            }
        }
        // הוספת HTML לתצוגת ההוראות
        document.querySelector('.sidebar').innerHTML += `
    <div id="directionsPanel" style="display: none; padding: 15px; background: white; height: 100%; overflow-y: auto;">
        <button onclick="closeDirections()" 
                style="background: none; border: none; float: left; cursor: pointer;">
            <i class="fas fa-times"></i>
        </button>
        <h3 style="margin: 0 0 15px 0;">הוראות ניווט</h3>
    </div>
`;

        // פונקציה לסגירת פאנל ההוראות
        function closeDirections() {
            document.getElementById('directionsPanel').style.display = 'none';
        }
    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
