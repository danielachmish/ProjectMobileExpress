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
    <%--  <meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
                                            <span class="call-id">#<%# Eval("ReadId") %></span>
                                            <span class="id-label">מספר קריאה</span>
                                        </div>
                                    </div>

                                    <!-- פרטי הקריאה -->
                                    <div class="details-section">
                                        <div class="detail-group">
                                            <!-- מידע אישי -->
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
                                    <div class="media-section">
                                        <div class="image-container">
                                            <%# Eval("NameImage").ToString() != "" ? 
                                           "<img src='Images/" + Eval("NameImage") + "' alt='תמונת קריאה' class='service-image' />" : 
                                           "<div class='no-image'>אין תמונה</div>" %>
                                        </div>
                                        <div class="image-container">
                                            <%# Eval("NameImage").ToString() != "" ? 
                                           "<img src='Images/" + Eval("NameImage") + "' alt='תמונת קריאה' class='service-image' />" : 
                                           "<div class='no-image'>אין תמונה</div>" %>
                                        </div>
                                        <div class="image-container">
                                            <%# Eval("NameImage").ToString() != "" ? 
                                           "<img src='Images/" + Eval("NameImage") + "' alt='תמונת קריאה' class='service-image' />" : 
                                           "<div class='no-image'>אין תמונה</div>" %>
                                        </div>
                                        <div class="image-container">
                                            <%# Eval("NameImage").ToString() != "" ? 
                                           "<img src='Images/" + Eval("NameImage") + "' alt='תמונת קריאה' class='service-image' />" : 
                                           "<div class='no-image'>אין תמונה</div>" %>
                                        </div>
                                        <div class="description-container">
                                            <span class="detail-label">תיאור הקריאה</span>
                                            <p class="description-text"><%# Eval("Desc") %></p>
                                        </div>
                                    </div>


                                    <!-- כפתורי פעולה -->
                                    <div class="action-buttons">
                                        <asp:Button runat="server"
                                            CssClass="btn btn-primary"
                                            Text="קבל קריאה"
                                            CommandName="Accept"
                                            CommandArgument='<%# Eval("ReadId") %>'
                                            OnCommand="CallAction_Command" />
                                        <asp:Button runat="server"
                                            CssClass="btn btn-secondary"
                                            Text="דחה קריאה"
                                            CommandName="Reject"
                                            CommandArgument='<%# Eval("ReadId") %>'
                                            OnCommand="CallAction_Command" />
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:Timer ID="RefreshTimer" runat="server" Interval="30000" OnTick="RefreshTimer_Tick" />
    </div>
    <!-- הוספת סגנונות חדשים -->
    <style>
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
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <!-- סקריפטים שנדרשים לעמוד -->
    <!-- טעינת סקריפטים חיצוניים -->
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

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
