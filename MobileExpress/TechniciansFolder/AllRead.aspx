<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="AllRead.aspx.cs" Inherits="MobileExpress.TechniciansFolder.AllRead" %>

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
    <!-- הוספת קישורים חיוניים בלבד -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="dashboard-container">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="RefreshTimer" />
            </Triggers>
            <ContentTemplate>
                <div id="callsContainer" runat="server" class="cards-list">
                    <asp:Repeater ID="CallsRepeater" runat="server">
                        <ItemTemplate>
                            <div class="card">
                                <div class="card-content">
                                    <!-- כותרת וזיהוי -->
                                    <div class="header-section">
                                        <div class="title-wrapper">
                                            <h3 class="card-title">קריאת שירות</h3>
                                            <span class="subtitle">פרטי הקריאה</span>
                                        </div>
                                        <div class="id-wrapper">
                                            <span id="call-<%# Eval("ReadId") %>" class="call-id">קריאה #<%# Eval("ReadId") %></span>

                                            <%-- <span id="call-<%# Eval("ReadId") %> class="call-id="call-<%# Eval("ReadId") %></span>    
                                            <span class="id-label">מספר קריאה</span>--%>
                                        </div>
                                    </div>

                                   <div class="details-section">
    <div class="detail-group">
        <div class="detail-item">
            <span class="detail-label">שם לקוח</span>
            <span class="detail-value"><%# Eval("FullName") %></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">טלפון</span>
            <span class="detail-value"><%# Eval("Phone") %></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">תאריך קריאה</span>
            <span class="detail-value"><%# ((DateTime)Eval("DateRead")).ToString("dd/MM/yyyy HH:mm") %></span>
        </div>
    </div>
   <ItemTemplate>
    <div class="call-status">
        <%# Eval("AssignedTechnicianId") != null ? 
               "<div class=\"status-badge approved\">הקריאה אושרה</div>" : 
               "" %>
        <asp:Button runat="server"
            CssClass="btn btn-accept-call"
            Text="התחל טיפול"
            OnClick="AcceptCall"
            CommandArgument='<%# Eval("ReadId") %>'
            Visible='<%# !Convert.ToBoolean(Eval("Status")) %>' />
    </div>
</ItemTemplate>
   
                                        <div class="detail-group">
                                            <!-- פרטי מוצר ושירות -->
                                            <div class="detail-item">
                                                <span class="detail-label">מזהה לקוח</span>
                                                <span class="detail-value"><%# Eval("CusId") %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">דגם</span>
                                                <span class="detail-value"><%# Eval("ModelId") %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">מספר סידורי</span>
                                                <span class="detail-value"><%# Eval("SerProdId") %></span>
                                            </div>
                                        </div>

                                        <div class="detail-group">
                                            <!-- סטטוס וקדימות -->
                                            <div class="detail-item">
                                                <span class="detail-label">דחיפות</span>
                                                <span class="detail-value urgent"><%# Eval("Urgency") %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">סטטוס</span>
                                                <span class="detail-value status"><%# (bool)Eval("Status") ? "בטיפול" : "ממתין" %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">מיקום</span>
                                                <a href='MapOrientation.aspx?readId=<%# Eval("ReadId") %>' class="location-link">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    הצג מיקום
                                                </a>
                                            </div>

                                        </div>
                                    </div>

                                    <!-- תמונה ותיאור -->
                                    <%-- <div class="media-section">
                                        <div class="image-container">
                                            <%# Eval("NameImage").ToString() != "" ? 
                                           "<img src='Images/" + Eval("NameImage") + "' alt='תמונת קריאה' class='service-image' />" : 
                                           "<div class='no-image'>אין תמונה</div>" %>
                                        </div>--%>

                                    <div class="description-container">
                                        <span class="detail-label">תיאור התקלה</span>
                                        <p class="description-text"><%# Eval("Desc") %></p>
                                    </div>
                                </div>
                                <!-- כפתורי פעולה -->
                                <div class="action-buttons">
                                    <asp:Button runat="server"
                                        CssClass="btn btn-primary"
                                        Text="הצעת מחיר"
                                        OnClick="RedirectToPriceQuote"
                                        CommandArgument='<%# Eval("ReadId") %>'
                                        Enabled='<%# !(bool)Eval("Status") %>' />

                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:Timer ID="RefreshTimer" runat="server" Interval="30000" OnTick="RefreshTimer_Tick" />
    </div>



    <!-- שדות מוסתרים לשמירת מזהים -->
    <input type="hidden" id="hiddenReadId" runat="server" />
    <input type="hidden" id="hiddenCustomerId" runat="server" />
    <input type="hidden" id="hiddenTechnicianId" runat="server" />
    <!-- הוספת סגנונות חדשים -->

    <%--  <style>
             /* עדכון לסגנונות הקיימים */
        .details-section {
            display: flex;
            flex-wrap: wrap;
            gap: 24px;
            margin: 16px 0;
            padding: 16px 0;
            border-bottom: 1px solid var(--border-color);
            border-top: 1px solid var(--border-color);
        }

        .detail-group {
            flex: 1;
            min-width: 250px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        /* סגנונות חדשים */
        .notes-section {
            display: flex;
            flex-direction: column;
            gap: 16px;
            padding: 16px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .note-item {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .description-text {
            background-color: var(--background-color);
            padding: 12px;
            border-radius: 6px;
            margin: 0;
        }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

            .status::before {
                content: '';
                display: inline-block;
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background-color: var(--primary-color);
            }

        /* התאמה למובייל */
        @media (max-width: 768px) {
            .details-section {
                flex-direction: column;
                gap: 16px;
            }

            .detail-group {
                width: 100%;
            }
        }

        :root {
            --primary-color: #7c5cdb;
            --secondary-color: #a29bfe;
            --background-color: #f8f9fa;
            --text-color: #4a4a4a;
            --border-color: #e1e1e1;
            --shadow-color: rgba(0, 0, 0, 0.05);
        }

        /* מיכל ראשי */
        .dashboard-container {
            padding: 20px;
            background-color: var(--background-color);
            max-width: 1200px;
            margin: 0 auto;
        }

        .cards-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        /* עיצוב הכרטיס */
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px var(--shadow-color);
            width: 100%;
        }

        .card-content {
            padding: 20px;
        }

        /* אזור הכותרת */
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .title-wrapper {
            display: flex;
            flex-direction: column;
        }

        .card-title {
            margin: 0;
            font-size: 1.1rem;
            color: var(--text-color);
        }

        .subtitle {
            font-size: 0.8rem;
            color: #888;
        }

        .id-wrapper {
            text-align: left;
        }

        .call-id {
            font-size: 1.5rem;
            color: var(--primary-color);
            font-weight: 600;
        }

        .id-label {
            display: block;
            font-size: 0.8rem;
            color: #888;
        }

        /* אזור הפרטים */
        .details-section {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 16px;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-color);
            border-top: 1px solid var(--border-color);
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .detail-label {
            font-size: 0.8rem;
            color: #888;
            margin-bottom: 4px;
        }

        .detail-value {
            font-size: 1rem;
            color: var(--text-color);
            font-weight: 500;
        }

        /* אזור המדיה והתיאור */
        .media-section {
            display: flex;
            gap: 20px;
            margin: 16px 0;
            align-items: flex-start;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .image-container {
            flex: 0 0 150px;
            height: 150px;
            border-radius: 8px;
            overflow: hidden;
            background-color: var(--background-color);
        }

        .service-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .no-image {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
            font-size: 0.9rem;
        }

        .description-container {
            flex: 1;
        }

        .description-text {
            margin: 8px 0 0;
            font-size: 0.95rem;
            color: var(--text-color);
            line-height: 1.5;
        }

        /* קישור למיקום */
        .location-link {
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--primary-color);
            text-decoration: none;
            font-size: 0.95rem;
            padding: 4px 0;
        }

            .location-link:hover {
                text-decoration: underline;
                opacity: 0.8;
            }

            .location-link i {
                font-size: 1.1rem;
            }

        /* כפתורי פעולה */
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 16px;
        }

        .btn {
            padding: 8px 20px;
            border-radius: 6px;
            border: none;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-secondary {
            background-color: white;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px var(--shadow-color);
        }

        .urgent {
            color: #e74c3c;
        }

        /* התאמה למובייל */
        @media (max-width: 768px) {
            .details-section {
                flex-direction: column;
                gap: 12px;
            }

            .media-section {
                flex-direction: column;
            }

            .image-container {
                width: 100%;
                max-width: 300px;
                margin: 0 auto;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                margin: 4px 0;
            }
        }

        /* הודעה כשאין קריאות */
        .no-calls {
            text-align: center;
            padding: 40px;
            font-size: 1.1rem;
            color: #888;
        }
        .highlighted-call {
        animation: highlight-pulse 3s;
    }

    @keyframes highlight-pulse {
        0% {
            box-shadow: 0 0 0 0 rgba(124, 92, 219, 0.4);
        }
        70% {
            box-shadow: 0 0 0 10px rgba(124, 92, 219, 0);
        }
        100% {
            box-shadow: 0 0 0 0 rgba(124, 92, 219, 0);
        }
    }

    .card {
        transition: box-shadow 0.3s ease;
    }

    .card:hover {
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
        </style>--%>
    <style>
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 15px;
        }

            .status-badge.approved {
                background-color: #48BB78;
                color: white;
            }

        .btn-accept-call {
            background: var(--purple-600);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

            .btn-accept-call:hover {
                background: var(--purple-700);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 70, 193, 0.2);
            }

        .card.approved {
            border-right: 4px solid #48BB78;
            background-color: rgba(72, 187, 120, 0.05);
        }






        :root {
            --purple-50: rgba(124, 58, 237, 0.05);
            --purple-100: rgba(124, 58, 237, 0.1);
            --purple-500: #7c3aed;
            --purple-600: #6d28d9;
            --purple-700: #5b21b6;
            --border-color: rgba(124, 58, 237, 0.15);
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
        }

        .dashboard-container {
            padding: 2rem;
            background-color: #f9fafb;
            max-width: 1200px;
            margin: 0 auto;
        }

        .cards-list {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.08);
            width: 100%;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

            .card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 30px rgba(124, 58, 237, 0.12);
            }

        .card-content {
            padding: 1.5rem;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--purple-50);
        }

        .card-title {
            font-size: 1.25rem;
            color: var(--text-primary);
            font-weight: 600;
            margin: 0;
        }

        .subtitle {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        .call-id {
            font-size: 1.5rem;
            color: var(--purple-500);
            font-weight: 600;
        }

        .details-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            padding: 1.5rem 0;
            border-bottom: 2px solid var(--purple-50);
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            padding: 1rem;
            background: var(--purple-50);
            border-radius: 12px;
            transition: all 0.3s ease;
        }

            .detail-item:hover {
                background: var(--purple-100);
            }

        .detail-label {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        .detail-value {
            font-size: 1rem;
            color: var(--text-primary);
            font-weight: 500;
        }

        .media-section {
            display: flex;
            gap: 1.5rem;
            margin: 1.5rem 0;
            padding: 1.5rem 0;
            border-bottom: 2px solid var(--purple-50);
        }

        .image-container {
            flex: 0 0 200px;
            height: 200px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(124, 58, 237, 0.1);
        }

        .description-text {
            background: var(--purple-50);
            padding: 1rem;
            border-radius: 12px;
            line-height: 1.6;
            color: var(--text-primary);
        }

        .location-link {
            color: var(--purple-500);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

            .location-link:hover {
                background: var(--purple-50);
                transform: translateX(4px);
            }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: var(--purple-500);
            color: white;
            border: none;
        }

            .btn-primary:hover {
                background: var(--purple-600);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(124, 58, 237, 0.2);
            }

        .btn-secondary {
            background: white;
            color: var(--purple-500);
            border: 2px solid var(--purple-500);
        }

            .btn-secondary:hover {
                background: var(--purple-50);
                transform: translateY(-2px);
            }

        .urgent {
            color: #ef4444;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: #fee2e2;
            border-radius: 20px;
        }

        .highlighted-call {
            animation: highlight-pulse 2s cubic-bezier(0.4, 0, 0.6, 1);
        }

        @keyframes highlight-pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(124, 58, 237, 0.4);
            }

            70% {
                box-shadow: 0 0 0 15px rgba(124, 58, 237, 0);
            }

            100% {
                box-shadow: 0 0 0 0 rgba(124, 58, 237, 0);
            }
        }

        @media (max-width: 768px) {
            .details-section {
                grid-template-columns: 1fr;
            }

            .media-section {
                flex-direction: column;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.9/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.js"></script>
    <script src="/dist-assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="/dist-assets/js/scripts/tooltip.script.min.js"></script>
    <script src="/dist-assets/js/scripts/script.min.js"></script>
    <script src="/dist-assets/js/scripts/script_2.min.js"></script>
    <script src="/dist-assets/js/scripts/sidebar.large.script.min.js"></script>
    <script src="/dist-assets/js/plugins/datatables.min.js"></script>
    <script src="/dist-assets/js/scripts/contact-list-table.min.js"></script>
    <script src="/dist-assets/js/scripts/datatables.script.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>

        $(document).ready(function () {
            // פונקציית ריענון אוטומטי
            function refreshCalls() {
                __doPostBack('<%= RefreshTimer.ClientID %>', '');
            }

            // הוספת class להדגשת קריאה ספציפית
            const readId = new URLSearchParams(window.location.search).get('readId');
            if (readId) {
                $(`#call-${readId}`).addClass('highlighted-call');
            }

            // טיפול בשגיאות AJAX
            $(document).ajaxError(function (event, jqXHR, settings, error) {
                Swal.fire('שגיאה', 'אירעה שגיאה בתקשורת עם השרת', 'error');
            });
        });



        let tokenClient;
        let gapiInited = false;
        let gisInited = false;

        // Logging function
        function logEvent(stage, message, data = null) {
            const timestamp = new Date().toISOString();
            console.log(`[${timestamp}] ${stage}: ${message}`);
            if (data) {
                console.log('Data:', data);
            }
        }

        // Error logging function
        function logError(stage, error) {
            const timestamp = new Date().toISOString();
            console.error(`[${timestamp}] Error in ${stage}:`);
            console.error('Error message:', error.message);
            console.error('Stack trace:', error.stack);
            if (error.response) {
                console.error('API Response:', error.response);
            }
        }




        async function handleGoogleCalendar(readId) {
            try {
                logEvent('Calendar Handler', `Starting calendar handling for ReadId: ${readId}`);

                const result = await Swal.fire({
                    title: 'אישור הוספה ליומן',
                    text: 'האם ברצונך להוסיף את הקריאה ליומן Google?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'כן',
                    cancelButtonText: 'לא',
                    reverseButtons: true
                });

                logEvent('User Response', `User response to confirmation dialog: ${result.isConfirmed}`);

                if (!result.isConfirmed) {
                    logEvent('Calendar Handler', 'User cancelled the operation');
                    return false;
                }

                if (!gapiInited) {
                    logEvent('Calendar Handler', 'GAPI not initialized, showing error');
                    await Swal.fire('שגיאה', 'המערכת עדיין מאתחלת, אנא נסה שוב', 'error');
                    return false;
                }

                logEvent('Auth Check', 'Checking authentication status');
                const token = gapi.client.getToken();
                logEvent('Auth Check', `Token exists: ${!!token}`);

                if (!token) {
                    logEvent('Auth Flow', 'Starting authentication flow');
                    tokenClient.callback = async (resp) => {
                        if (resp.error) {
                            logError('Auth Flow', new Error(resp.error));
                            throw resp;
                        }
                        logEvent('Auth Flow', 'Authentication successful');
                        await addToCalendar(readId); // קריאה ישירה להוספה ליומן
                    };
                    tokenClient.requestAccessToken({ prompt: 'consent' });
                } else {
                    logEvent('Auth Flow', 'Using existing token');
                    await addToCalendar(readId); // קריאה ישירה להוספה ליומן
                }

                await Swal.fire({
                    title: 'הצלחה!',
                    text: 'הקריאה נוספה בהצלחה ליומן Google.',
                    icon: 'success',
                    timer: 2000,
                    showConfirmButton: false
                });

                return true;
            } catch (error) {
                logError('Calendar Handler', error);
                await Swal.fire('שגיאה', 'אירעה שגיאה בתהליך', 'error');
                return false;
            }
        }




        async function addToCalendar(callData) {
            try {
                logEvent('Calendar Event', 'Creating calendar event object');

                const event = {
                    summary: `קריאת שירות - ${callData.FullName}`,
                    description: `
                        תיאור: ${callData.Desc}
                        
                        פרטי התקשרות:
                        שם: ${callData.FullName}
                        טלפון: ${callData.Phone}
                        
                        פרטי המכשיר:
                        דגם: ${callData.ModelId}
                        מספר סידורי: ${callData.SerProdId}
                        
                        מספר קריאה: ${callData.ReadId}
                        דחיפות: ${callData.Urgency}
                    `.trim(),
                    start: {
                        dateTime: new Date(callData.DateRead).toISOString(),
                        timeZone: 'Asia/Jerusalem'
                    },
                    end: {
                        dateTime: new Date(new Date(callData.DateRead).getTime() + 2 * 60 * 60 * 1000).toISOString(),
                        timeZone: 'Asia/Jerusalem'
                    },
                    reminders: {
                        useDefault: false,
                        overrides: [
                            { method: 'popup', minutes: 30 },
                            { method: 'email', minutes: 60 }
                        ]
                    }
                };

                logEvent('Calendar Event', 'Event object created', event);

                const response = await gapi.client.calendar.events.insert({
                    calendarId: 'primary',
                    resource: event
                });

                logEvent('Calendar Event', 'Event inserted successfully', response);
                return response;
            } catch (error) {
                logError('Calendar Event Creation', error);
                throw error;
            }
        }





        async function updateServiceCallStatus(readId) {
            try {
                logEvent('Status Update', `Updating status for ReadId: ${readId}`);

                const response = await fetch('/api/Readability/UpdateStatus', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        readId: readId,
                        status: true
                    })
                });

                logEvent('Status Update', `Response status: ${response.status}`);

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                logEvent('Status Update', 'Status updated successfully');
            } catch (error) {
                logError('Status Update', error);
                throw error;
            }
        }


        document.addEventListener("DOMContentLoaded", function () {
            // בדיקת פרמטר ה-ReadId ב-URL
            const params = new URLSearchParams(window.location.search);
            const readId = params.get("readId");
            if (readId) {
                const target = document.getElementById(`call-${readId}`);
                if (target) {
                    // גלילה לאלמנט
                    target.scrollIntoView({ behavior: "smooth", block: "center" });
                    // הוספת הדגשה זמנית
                    target.classList.add("highlight");
                    setTimeout(() => target.classList.remove("highlight"), 3000);
                }
            }
        });


    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
