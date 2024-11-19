<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="MapOrientation.aspx.cs" Inherits="MobileExpress.TechniciansFolder.MapOrientation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
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
    
  <%--  <style>
        .map-container {
            display: flex;
            height: calc(100vh - 70px); /* מחסיר את גובה התפריט העליון */
            margin-top: 70px; /* מרווח מהתפריט העליון */
        }

        #map {
            flex: 1;
            height: 100%;
        }

        .sidebar {
            width: 400px;
            background: white;
            box-shadow: -2px 0 10px rgba(0,0,0,0.1);
            overflow-y: auto;
        }

        .search-box {
            padding: 15px;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }

        .search-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .filters {
            display: flex;
            gap: 10px;
            padding: 10px;
        }

        .filter-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 20px;
            background: #e9ecef;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .filter-btn:hover {
            background: #dee2e6;
        }

        .filter-btn.active {
            background: #007bff;
            color: white;
        }

        .calls-list {
            padding: 15px;
        }

        .call-item {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: transform 0.2s;
        }

        .call-item:hover {
            transform: translateY(-2px);
        }

        .call-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .call-type {
            font-weight: bold;
            color: #007bff;
        }

        .call-status {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.9em;
        }

        .status-new {
            background: #e3f2fd;
            color: #1976d2;
        }

        .status-in-progress {
            background: #fff3e0;
            color: #f57c00;
        }

        .call-details {
            margin: 10px 0;
        }

        .call-address {
            color: #666;
            margin: 5px 0;
        }

        .call-time {
            color: #888;
            font-size: 0.9em;
        }

        .call-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }

        .accept-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            background: #28a745;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .accept-btn:hover {
            background: #218838;
        }

        /* סטיילינג למודאל של פרטי קריאה */
        .call-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
        }

        .modal-content {
            background: white;
            width: 90%;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            border-radius: 8px;
            position: relative;
        }

        .close-modal {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 24px;
            cursor: pointer;
        }
    </style>

     <div class="map-container">
        <div id="map"></div>
        <div class="sidebar">
            <div class="search-box">
                <input type="text" class="search-input" placeholder="חפש כתובת או קריאת שירות...">
                <div class="filters">
                    <button class="filter-btn active">הכל</button>
                    <button class="filter-btn">קריאות חדשות</button>
                    <button class="filter-btn">בטיפול</button>
                    <button class="filter-btn">הושלמו</button>
                </div>
            </div>
            <div class="calls-list">
                <!-- רשימת הקריאות תיווצר דינמית -->
            </div>
        </div>
    </div>

    <!-- מודאל לפרטי קריאה -->
    <div id="callModal" class="call-modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2>פרטי קריאת שירות</h2>
            <div id="callDetails">
                <!-- תוכן המודאל ייטען דינמית -->
            </div>
        </div>
    </div>--%>
     <style>
        .map-container {
            display: flex;
            height: calc(100vh - 70px);
            margin-top: 70px;
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
            background: #00a3d3;
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

        .call-item {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid #eee;
        }

        .location-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .location-info {
            flex: 1;
        }

        .location-name {
            color: #00a3d3;
            font-size: 1.1em;
            font-weight: 600;
            margin-bottom: 5px;
            text-decoration: none;
        }

        .location-type {
            color: #666;
            font-size: 0.9em;
            margin-bottom: 5px;
        }

        .rating {
            background: #00a3d3;
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
            color: #666;
            font-size: 0.9em;
            margin-top: 10px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .meta-item i {
            color: #00a3d3;
        }

        .review-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }

        .review-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .reviewer-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #ddd;
        }

        .review-text {
            color: #666;
            font-size: 0.9em;
            line-height: 1.4;
        }

        .filters {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            padding: 0 20px 15px;
        }

        .filter-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 20px;
            background: #f0f0f0;
            color: #666;
            cursor: pointer;
            font-size: 0.9em;
            transition: all 0.2s;
        }

        .filter-btn:hover, .filter-btn.active {
            background: #00a3d3;
            color: white;
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
            color: #666;
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
            color: #FFD700;
        }
    </style>

    <div class="map-container">
        <div id="map"></div>
        <div class="sidebar">
            <h1 class="main-title">
                מפה והתמצאות
                <span>100 תושבים סביב תל אביב-יפו</span>
            </h1>
            
            <div class="search-box">
                <input type="text" class="search-input" placeholder="חיפוש...">
            </div>

            <div class="filters">
                <button class="filter-btn active">פתוח עכשיו</button>
                <button class="filter-btn">יום ושעה</button>
                <button class="filter-btn">פתוח בשבת</button>
                <button class="filter-btn">פתוח בלילה</button>
            </div>

            <div class="calls-list">
                <!-- דוגמה לכרטיסיית מיקום -->
                <div class="call-item">
                    <div class="location-header">
                        <div class="location-info">
                            <a href="#" class="location-name">קריאת שירות #1234</a>
                            <div class="location-type">תיקון מזגן - פתוח</div>
                        </div>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <span>4.8</span>
                        </div>
                    </div>
                    
                    <div class="location-meta">
                        <span class="meta-item">
                            <i class="fas fa-map-marker-alt"></i>
                            שדרות רוטשילד 40, תל אביב
                        </span>
                        <span class="meta-item">
                            <i class="fas fa-clock"></i>
                            דקות 15
                        </span>
                        <span class="meta-item">
                            <i class="fas fa-eye"></i>
                            18667
                        </span>
                    </div>

                    <div class="review-section">
                        <div class="review-header">
                            <div class="reviewer-avatar"></div>
                            <span>תיאור הבעיה</span>
                        </div>
                        <p class="review-text">המזגן מפסיק לעבוד כל כמה דקות וצריך הרבה זמן עד שמתקרר</p>
                    </div>
                </div>

                <!-- אפשר להוסיף עוד כרטיסיות כאלה -->
            </div>
        </div>
    </div>

    <!-- מודאל לפרטי קריאה -->
    <div id="callModal" class="call-modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2>פרטי קריאת שירות</h2>
            <div id="callDetails"></div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
     <script>
         // החלפת סקריפט קיים עם זה:
         $(document).ready(function () {
             // אתחול המפה
             //mapboxgl.accessToken = 'YOUR_MAPBOX_TOKEN';
             //const map = new mapboxgl.Map({
             //    container: 'map',
             //    style: 'mapbox://styles/mapbox/streets-v11',
             //    center: [34.7818, 32.0853], // מרכז תל אביב
             //    zoom: 12
             //});

             let markers = []; // מערך לשמירת הסמנים במפה

             // פונקציה לטעינת הקריאות מהשרת
             function loadServiceCalls() {
                 $.ajax({
                     url: 'MapOrientation.aspx/GetServiceCalls',
                     type: 'POST',
                     contentType: 'application/json',
                     dataType: 'json',
                     success: function (response) {
                         if (response.d.success) {
                             // ניקוי סמנים קיימים
                             markers.forEach(marker => marker.remove());
                             markers = [];

                             // יצירת רשימת הקריאות
                             createCallsList(response.d.data);

                             // הוספת סמנים למפה
                             response.d.data.forEach(call => {
                                 const marker = new mapboxgl.Marker()
                                     .setLngLat(call.coordinates)
                                     .addTo(map);
                                 markers.push(marker);
                             });
                         } else {
                             alert(response.d.message);
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

         // בראש הדף - הגדרת משתנים גלובליים
         let map;
         let markers = [];
         const israelCenter = { lat: 32.0853, lng: 34.7818 };

         // פונקציית האתחול הראשית - מופעלת על ידי callback של Google Maps
         function initMap() {
             console.log("Initializing map...");

             try {
                 // יצירת המפה
                 map = new google.maps.Map(document.getElementById('map'), {
                     center: israelCenter,
                     zoom: 13,
                     streetViewControl: false,
                     mapTypeControl: false
                 });

                 // אתחול תיבת החיפוש
                 const input = document.querySelector('.search-input');
                 const searchBox = new google.maps.places.SearchBox(input);

                 // הגדרת גבולות החיפוש למפה הנוכחית
                 map.addListener('bounds_changed', () => {
                     searchBox.setBounds(map.getBounds());
                 });

                 // טיפול באירוע של בחירת מיקום
                 searchBox.addListener('places_changed', () => {
                     const places = searchBox.getPlaces();
                     if (places.length === 0) return;

                     const bounds = new google.maps.LatLngBounds();
                     places.forEach(place => {
                         if (place.geometry && place.geometry.location) {
                             bounds.extend(place.geometry.location);
                         }
                     });
                     map.fitBounds(bounds);
                 });

                 // טעינת נתוני דוגמה למפה
                 loadDemoData();

                 console.log("Map initialized successfully");
             } catch (error) {
                 console.error("Error initializing map:", error);
             }
         }

         // וודא שהסקריפט נטען
         document.addEventListener('DOMContentLoaded', function () {
             // בדוק אם Google Maps כבר זמין
             if (typeof google === 'undefined') {
                 console.log("Waiting for Google Maps to load...");
             } else {
                 console.log("Google Maps already loaded");
                 initMap();
             }
         });
         // פונקציה להוספת סמן למפה
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

             // הוספת חלון מידע
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

         // פונקציה לניקוי סמנים
         function clearMarkers() {
             markers.forEach(marker => marker.setMap(null));
             markers = [];
         }

         // פונקציה לטעינת נתוני דוגמה
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

             // ניקוי סמנים קיימים
             clearMarkers();

             // יצירת הרשימה
             createCallsList(demoData);

             // הוספת סמנים למפה
             demoData.forEach(call => {
                 addMarker(call.coordinates, `קריאה #${call.id}`, call);
             });
         }

         // פונקציה ליצירת פריט ברשימה
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

         // פונקציה ליצירת הרשימה
         function createCallsList(calls) {
             const callsList = document.querySelector('.calls-list');
             callsList.innerHTML = '';
             calls.forEach(call => {
                 callsList.innerHTML += createCallItem(call);
             });
         }

         // פונקציה להצגת פרטי קריאה
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

         // אתחול בטעינת העמוד
       /*  window.onload = initMap;*/

         // סגירת מודאל
         document.querySelector('.close-modal')?.addEventListener('click', () => {
             document.getElementById('callModal').style.display = 'none';
         });

         // טיפול בלחיצות על כפתורי סינון
         document.querySelectorAll('.filter-btn').forEach(button => {
             button.addEventListener('click', function () {
                 document.querySelectorAll('.filter-btn').forEach(btn =>
                     btn.classList.remove('active'));
                 this.classList.add('active');
                 // כאן תוכל להוסיף לוגיקת סינון
             });
         });
  
     </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
