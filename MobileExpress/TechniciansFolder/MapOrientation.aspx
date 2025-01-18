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

    <%--<header class="main-header">
      

        <div class="header-border"></div>
    </header>--%>

    <style>
        /* הגדרות בסיס */
body, html {
    direction: rtl;
    text-align: right;
}

/* סיידבר */
.sidebar {
    right: 0; /* במקום left */
    box-shadow: 4px 0 20px rgba(124, 58, 237, 0.1); /* שינוי כיוון הצל */
}

/* פריטי מיטא */
.meta-item {
    direction: rtl;
}

/* כותרות וטקסטים */
.location-name, 
.location-info,
.location-meta,
.review-section,
.review-header,
.detail-item {
    text-align: right;
    direction: rtl;
}

/* תיבת חיפוש */
.search-input {
    text-align: right;
    padding-right: 1rem;
    direction: rtl;
}

/* סינון */
.filter-select {
    text-align: right;
    padding-right: 1rem;
    background-position: left 8px center;
    direction: rtl;
}

/* תפריט */
.menu-toggle {
    margin-left: 0;
    margin-right: auto;
}

/* אייקונים */
.meta-item i {
    margin-left: 0.5rem;
    margin-right: 0;
}

/* כותרת ראשית */
.main-header {
    direction: rtl;
}

/* התאמה למפה */
#map {
    right: auto;
    left: 0;
}

/* סידור כפתורים */
.location-links {
    flex-direction: row-reverse;
}

/* סידור פריטי מיקום */
.location-header {
    flex-direction: row-reverse;
}

/* עיצוב נוסף */
.urgency-high,
.urgency-medium,
.urgency-low {
    margin-left: 0;
    margin-right: 0.5rem;
}

.filter-container {
    text-align: right;
}

/* התאמה למובייל */
@media screen and (max-width: 768px) {
    .location-links,
    .filter-group {
        align-items: flex-start;
    }
}
        :root {
            --purple-50: rgba(124, 58, 237, 0.05);
            --purple-100: rgba(124, 58, 237, 0.1);
            --purple-500: #7c3aed;
            --purple-600: #6d28d9;
            --purple-700: #5b21b6;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
        }

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
            box-shadow: -4px 0 20px rgba(124, 58, 237, 0.1);
            overflow-y: auto;
            height: 100vh;
            margin: 0;
            padding: 0;
        }

        .toolbar {
            position: sticky;
            top: 0;
            z-index: 10;
            background: var(--purple-600);
            color: white;
            padding: 1rem 1.5rem;
            width: 100%;
            box-shadow: 0 4px 12px rgba(124, 58, 237, 0.15);
        }

        .filter-container {
            position: sticky;
            top: 0;
            z-index: 9;
            background: white;
            margin: 0;
            padding: 1rem 1.5rem;
            border-bottom: 2px solid var(--purple-50);
        }

        .main-header {
            background: var(--purple-600);
            width: 100%;
            height: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 1.5rem;
            direction: rtl;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.15);
            position: relative;
        }

        .header-title {
            color: white;
            font-size: 1.2rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .header-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.95rem;
            font-weight: normal;
        }

        .call-item {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin: 1rem;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.08);
            border: 2px solid var(--purple-50);
            transition: all 0.3s ease;
        }

            .call-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 30px rgba(124, 58, 237, 0.12);
            }

        .location-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
            border-bottom: 2px solid var(--purple-50);
            padding-bottom: 1rem;
        }

        .location-name {
            color: var(--purple-700);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            transition: color 0.3s ease;
        }

            .location-name:hover {
                color: var(--purple-500);
            }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--purple-50);
            padding: 0.5rem 1rem;
            border-radius: 10px;
            color: var(--purple-600);
            transition: all 0.3s ease;
        }

            .meta-item:hover {
                background: var(--purple-100);
                transform: translateY(-1px);
            }
        /* Filter styles */
        .filter-select {
            /* appearance: none;*/
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            color: var(--purple-700);
            background: var(--purple-50) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%237c3aed' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E") no-repeat;
            background-position: left 8px center;
            background-size: 16px;
            border: 2px solid var(--purple-100);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 200px;
        }

            .filter-select:hover {
                border-color: var(--purple-500);
                background-color: var(--purple-100);
            }

            .filter-select:focus {
                outline: none;
                border-color: var(--purple-500);
                box-shadow: 0 0 0 3px var(--purple-50);
            }

        /* Status indicators */
        .status-indicators {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.95rem;
            color: var(--purple-700);
            padding: 0.5rem 1rem;
            background: var(--purple-50);
            border-radius: 10px;
            transition: all 0.3s ease;
        }

            .status-indicator:hover {
                transform: translateY(-1px);
                background: var(--purple-100);
            }

        .indicator-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            transition: transform 0.3s ease;
        }

        .status-indicator:hover .indicator-dot {
            transform: scale(1.2);
        }

        .dot-open {
            background: #10b981;
            box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
        }

        .dot-closed {
            background: #ef4444;
            box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.2);
        }

        .dot-favorite {
            color: var(--purple-500);
            box-shadow: 0 0 0 2px var(--purple-100);
        }

        /* Map controls */
        .custom-map-control-button {
            background: white;
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.15);
            cursor: pointer;
            margin: 1rem;
            padding: 0.75rem 1.5rem;
            height: auto;
            font-weight: 500;
            color: var(--purple-600);
            transition: all 0.3s ease;
        }

            .custom-map-control-button:hover {
                background: var(--purple-50);
                transform: translateY(-2px);
                box-shadow: 0 6px 25px rgba(124, 58, 237, 0.2);
            }

        /* Review section */
        .review-section {
            background: var(--purple-50);
            padding: 1.5rem;
            border-radius: 12px;
            margin-top: 1.5rem;
            transition: all 0.3s ease;
        }

            .review-section:hover {
                background: var(--purple-100);
            }

        .review-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
            color: var(--purple-700);
        }

        .reviewer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 2px solid var(--purple-500);
            box-shadow: 0 2px 8px rgba(124, 58, 237, 0.2);
        }

        /* Location links */
        .location-links {
            display: flex;
            gap: 1rem;
            align-items: center;
            margin-top: 1rem;
        }

        .waze-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            background: #40c4ff;
            color: white;
            border-radius: 10px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(64, 196, 255, 0.2);
        }

            .waze-link:hover {
                background: #00b0ff;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(64, 196, 255, 0.3);
            }

        /* Highlighting */
        .highlight {
            background: linear-gradient(120deg, var(--purple-100) 0%, var(--purple-50) 100%);
            border-radius: 4px;
            padding: 0.2rem 0.4rem;
            transition: background 0.3s ease;
        }

        /* Responsive design */
        @media screen and (max-width: 768px) {
            .sidebar {
                width: 100%;
            }

            .filter-group {
                flex-direction: column;
            }

            .filter-select {
                width: 100%;
            }

            .status-indicators {
                flex-wrap: wrap;
            }

            .location-links {
                flex-direction: column;
            }

            .waze-link {
                width: 100%;
                justify-content: center;
            }
        }

        /* Search functionality */
        .search-box {
            padding: 1.5rem;
            background: white;
            border-bottom: 2px solid var(--purple-50);
        }

        .search-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--purple-100);
            border-radius: 12px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

            .search-input:focus {
                outline: none;
                border-color: var(--purple-500);
                box-shadow: 0 0 0 3px var(--purple-50);
            }

        /* Menu icon */
        .menu-toggle {
            background: none;
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0.5rem;
            transition: all 0.3s ease;
        }

            .menu-toggle:hover {
                transform: scale(1.1);
            }
    </style>

   <%-- //להציג קריאות ברדיוס מסויים--%>
  <%-- <style>
       .radius-filter {
    padding: 15px;
    background: var(--purple-50);
    border-radius: 12px;
    margin-bottom: 1rem;
}

.radius-slider {
    width: 100%;
    height: 8px;
    background: var(--purple-100);
    border-radius: 5px;
    outline: none;
    -webkit-appearance: none;
}

.radius-slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 20px;
    height: 20px;
    background: var(--purple-500);
    border-radius: 50%;
    cursor: pointer;
    transition: all 0.3s ease;
}

.radius-slider::-webkit-slider-thumb:hover {
    background: var(--purple-600);
    transform: scale(1.1);
}
   </style>--%>

    <div class="map-container" dir="rtl">

        <div class="sidebar">
            <h1 class="main-title"><%--מפה והתמצאות--%>
                <span><%--100 תושבים סביב תל אביב-יפו--%></span>
            </h1>

            <div class="search-box">
                <input type="text" class="search-input" placeholder="חיפוש...">
            </div>

            <%-- //להציג קריאות ברגיוס מסויים--%>
           <%--  <div class="radius-filter">
    <label for="radiusSlider">רדיוס חיפוש (ק"מ): <span id="radiusValue">10</span></label>
    <input type="range" id="radiusSlider" min="1" max="50" value="10" class="radius-slider">
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
                 <%--   <asp:DropDownList ID="StatusFilter" runat="server"
    CssClass="filter-select"
    AutoPostBack="true" 
    OnSelectedIndexChanged="StatusFilter_SelectedIndexChanged">
    <asp:ListItem Text="קריאות פתוחות" Value="true" Selected="True" />
    <asp:ListItem Text="קריאות סגורות" Value="false" />
</asp:DropDownList>--%>
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
                               <div class="detail-item">
                            <span class="detail-label"></span>
                            <a href='MapOrientation.aspx?readId=<%# Eval("ReadId") %>' class="location-link">
                                <i class="fas fa-map-marker-alt"></i>
                                הצג מיקום
                                                                 </a>
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
                        </div>
                     
                        <div class="review-section">
                            <div class="review-header">

                                <span style="font-weight: bold; color: #553C9A">:תיאור התקלה</span>


                            </div>

                            <p class="review-text"><%# Eval("Desc") %></p>

                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
                <div id="map"></div>
    </div>


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

        function showCustomerLocation(lat, lng) {
            // בדיקה שיש נתוני מיקום תקינים
            console.log(`Received coordinates: ${lat}, ${lng}`); // לדיבאג

            if (!lat || !lng) {
                console.error('No valid coordinates provided');
                return;
            }

            const location = { lat: parseFloat(lat), lng: parseFloat(lng) };
            map.setCenter(location);
            map.setZoom(15);

            // הוספת סמן למיקום הלקוח
            const marker = new google.maps.Marker({
                position: location,
                map: map,
                title: 'מיקום הלקוח',
                icon: 'https://maps.google.com/mapfiles/ms/icons/red-dot.png'
            });

            const infowindow = new google.maps.InfoWindow({
                content: '<div style="direction: rtl">מיקום הלקוח</div>'
            });
            marker.addListener('click', () => {
                infowindow.open(map, marker);
            });
        }

        function findLocationByAddress(address) {
            const geocoder = new google.maps.Geocoder();
            geocoder.geocode({ address: address }, (results, status) => {
                if (status === 'OK') {
                    const location = results[0].geometry.location;
                    map.setCenter(location);
                    map.setZoom(15);
                    new google.maps.Marker({
                        map: map,
                        position: location,
                        title: 'מיקום הלקוח'
                    });
                } else {
                    console.error('Geocoding failed:', status);
                }
            });
        }


        function initTechnicianTracking() {
            // בדיקה האם המעקב מופעל עבור הטכנאי
            $.ajax({
                url: 'MainTechnicians.aspx/CheckLocationTracking',
                type: 'POST',
                contentType: 'application/json',
                success: function (response) {
                    if (response.d.isEnabled) {
                        startTracking();
                    }
                }
            });
        }

        function startTracking() {
            if (!navigator.geolocation) {
                console.error("הדפדפן לא תומך בשירותי מיקום");
                return;
            }
            // המשך הקוד כפי שהיה...
        }


        // משתנים גלובליים למעקב אחר מיקום
        let technicianMarker = null;     // מייצג את הסמן של הטכנאי על המפה
        let watchPositionId = null;      // מזהה ייחודי למעקב המיקום
        let lastReportedPosition = null; // המיקום האחרון שדווח לשרת

        // פונקציה ראשית לאתחול מערכת המעקב
        function initTechnicianTracking() {
            // בדיקת תמיכה בשירותי מיקום
            if (!navigator.geolocation) {
                console.error("הדפדפן לא תומך בשירותי מיקום");
                return;
            }

            // הגדרות למעקב מיקום
            const options = {
                enableHighAccuracy: true,  // דיוק גבוה (GPS)
                maximumAge: 0,            // לא להשתמש במיקום מהמטמון
                timeout: 5000             // זמן מקסימלי לקבלת מיקום (5 שניות)
            };

            // התחלת מעקב רציף אחר המיקום
            watchPositionId = navigator.geolocation.watchPosition(
                updateTechnicianPosition, // פונקציה שתקרא בכל עדכון מיקום
                handleTrackingError,      // פונקציה לטיפול בשגיאות
                options
            );

            // יצירת סמן הטכנאי על המפה
            technicianMarker = new google.maps.Marker({
                map: map,
                icon: {
                    url: 'https://maps.google.com/mapfiles/ms/icons/blue-dot.png',
                    scaledSize: new google.maps.Size(32, 32),
                    anchor: new google.maps.Point(16, 16)
                },
                title: 'מיקום הטכנאי'
            });
        }

        // פונקציה לעדכון מיקום הטכנאי
        function updateTechnicianPosition(position) {
            const currentPosition = {
                lat: position.coords.latitude,
                lng: position.coords.longitude,
                accuracy: position.coords.accuracy,
                timestamp: new Date().toISOString()
            };

            // עדכון מיקום הסמן על המפה
            if (technicianMarker) {
                technicianMarker.setPosition({
                    lat: currentPosition.lat,
                    lng: currentPosition.lng
                });
            }

            // בדיקה האם צריך לדווח לשרת
            if (shouldReportPosition(currentPosition)) {
                reportPositionToServer(currentPosition);
                lastReportedPosition = currentPosition;
            }
        }

        // פונקציה לבדיקה האם צריך לדווח על המיקום החדש
        function shouldReportPosition(newPosition) {
            if (!lastReportedPosition) return true;

            const minDistanceThreshold = 10;  // מרחק מינימלי במטרים
            const minTimeThreshold = 10000;   // זמן מינימלי במילישניות (10 שניות)

            // חישוב המרחק בין המיקומים
            const distance = google.maps.geometry.spherical.computeDistanceBetween(
                new google.maps.LatLng(lastReportedPosition.lat, lastReportedPosition.lng),
                new google.maps.LatLng(newPosition.lat, newPosition.lng)
            );

            // חישוב הזמן שעבר
            const timeDiff = new Date(newPosition.timestamp) - new Date(lastReportedPosition.timestamp);

            // מחזיר true אם המרחק או הזמן עברו את הסף
            return distance > minDistanceThreshold || timeDiff > minTimeThreshold;
        }

        // פונקציה לדיווח המיקום לשרת
        function reportPositionToServer(position) {
            const data = {
                latitude: position.lat,
                longitude: position.lng,
                accuracy: position.accuracy,
                timestamp: position.timestamp
            };

            $.ajax({
                url: 'MapOrientation.aspx/UpdateTechnicianLocation',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ locationData: data }),
                success: function (response) {
                    console.log('המיקום עודכן בהצלחה');
                },
                error: function (xhr, status, error) {
                    console.error('שגיאה בעדכון המיקום:', error);
                }
            });
        }

        // פונקציה לטיפול בשגיאות מעקב
        function handleTrackingError(error) {
            let errorMessage;
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    errorMessage = "המשתמש לא אישר גישה למיקום";
                    break;
                case error.POSITION_UNAVAILABLE:
                    errorMessage = "מידע המיקום אינו זמין";
                    break;
                case error.TIMEOUT:
                    errorMessage = "פג הזמן לבקשת המיקום";
                    break;
                default:
                    errorMessage = "שגיאה לא ידועה במעקב המיקום";
            }
            console.error('שגיאת מעקב:', errorMessage);
        }

        // פונקציה לניקוי משאבים כשהמעקב מסתיים
        function stopTechnicianTracking() {
            if (watchPositionId) {
                navigator.geolocation.clearWatch(watchPositionId);
                watchPositionId = null;
            }
            if (technicianMarker) {
                technicianMarker.setMap(null);
                technicianMarker = null;
            }
        }

        // הוספת מאזיני אירועים
        document.addEventListener('DOMContentLoaded', () => {
            initTechnicianTracking();
        });

        // ניקוי בסגירת הדף
        window.addEventListener('beforeunload', () => {
            stopTechnicianTracking();
        });



        //להציג קריאות ברגיוס מסויים
        //let currentRadius = 10;
        //const slider = document.getElementById('radiusSlider');
        //const radiusValue = document.getElementById('radiusValue');

        //slider.addEventListener('input', function () {
        //    currentRadius = this.value;
        //    radiusValue.textContent = currentRadius;
        //    updateServiceCalls();
        //});

        //function updateServiceCalls() {
        //    if (navigator.geolocation) {
        //        navigator.geolocation.getCurrentPosition(position => {
        //            const currentLocation = {
        //                lat: position.coords.latitude,
        //                lng: position.coords.longitude
        //            };

        //            $.ajax({
        //                url: 'MapOrientation.aspx/GetServiceCalls',
        //                type: 'POST',
        //                data: JSON.stringify({
        //                    currentLat: currentLocation.lat,
        //                    currentLng: currentLocation.lng,
        //                    radius: currentRadius
        //                }),
        //                contentType: 'application/json',
        //                dataType: 'json',
        //                success: function (response) {
        //                    // עדכון המפה והרשימה
        //                    updateMap(response.d);
        //                    updateList(response.d);
        //                },
        //                error: function (error) {
        //                    console.error('Error:', error);
        //                }
        //            });
        //        });
        //    }
        //}

        //function updateMap(calls) {
        //    // נקה סימונים קיימים
        //    clearMarkers();

        //    // הוסף סימונים חדשים
        //    calls.forEach(call => {
        //        if (call.Nots) {
        //            const coordinates = call.Nots.split(',');
        //            const position = {
        //                lat: parseFloat(coordinates[0]),
        //                lng: parseFloat(coordinates[1])
        //            };
        //            addMarker(position, call);
        //        }
        //    });
        //}

        //function updateList(calls) {
        //    // עדכון הרשימה בסיידבר
        //    const container = document.querySelector('.calls-list');
        //    container.innerHTML = '';
        //    calls.forEach(call => {
        //        // הוסף את הקריאה לרשימה
        //        addCallToList(call);
        //    });
        //}
    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
