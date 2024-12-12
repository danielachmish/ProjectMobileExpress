<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="Bids.aspx.cs" Inherits="MobileExpress.Users.Bids" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent1" runat="server">

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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="dashboard-container">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="RefreshTimer" />
            </Triggers>
            <ContentTemplate>
                <div id="bidsContainer" runat="server" class="cards-list">
                    <asp:Repeater ID="BidsRepeater" runat="server">
                        <ItemTemplate>
                            <div class="card">
                                <div class="card-content">
                                    <!-- כותרת וזיהוי -->
                                    <div class="header-section">
                                        <div class="title-wrapper">
                                            <h3 class="card-title">הצעת מחיר</h3>
                                        </div>
                                        <div class="id-wrapper">
                                            <span id="bid-<%# Eval("BidId") %>" class="bid-id">הצעה #<%# Eval("BidId") %></span>
                                        </div>
                                    </div>

                                    <!-- פרטי ההצעה -->
                                    <div class="details-section">
                                        <div class="detail-group">
                                            <!-- מידע אישי -->
                                            <div class="detail-item">
                                                <span class="detail-label">שם לקוח</span>
                                                <span class="detail-value"><%# Eval("FullName") %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">תאריך הצעה</span>
                                                <span class="detail-value"><%# ((DateTime)Eval("Date")).ToString("dd/MM/yyyy HH:mm") %></span>
                                            </div>
                                        </div>

                                        <div class="detail-group">
                                            <!-- פרטי המוצר -->
                                            <div class="detail-item">
                                                <span class="detail-label">תיאור פריט</span>
                                                <span class="detail-value"><%# Eval("ItemDescription") %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">כמות</span>
                                                <span class="detail-value"><%# Eval("ItemQuantity") %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">מחיר ליחידה</span>
                                                <span class="detail-value">₪<%# Eval("ItemUnitPrice", "{0:N2}") %></span>
                                            </div>
                                        </div>

                                        <div class="detail-group">
                                            <!-- מחיר ומצב -->
                                            <div class="detail-item">
                                                <span class="detail-label">סה"כ מחיר</span>
                                                <span class="detail-value price">₪<%# Eval("ItemTotal", "{0:N2}") %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">סטטוס</span>
                                                <span class="detail-value status"><%# (bool)Eval("Status") ? "אושר" : "בהמתנה" %></span>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">מספר קריאה</span>
                                                <span class="detail-value"><%# Eval("ReadId") %></span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- תיאור ההצעה -->
                                    <div class="description-container">
                                        <span class="detail-label">הערות להצעה</span>
                                        <p class="description-text"><%# Eval("Desc") %></p>
                                    </div>

                                    <!-- כפתורי פעולה -->
                                    <div class="action-buttons">
                                        <%--<asp:Button runat="server"
                                        CssClass="btn btn-primary"
                                        Text="עדכן הצעה"
                                        OnClick="UpdateBid"
                                        CommandArgument='<%# Eval("BidId") %>'
                                        Visible='<%# !(bool)Eval("Status") %>' />--%>

                                        <asp:Button runat="server"
                                            CssClass="btn btn-success"
                                            Text="אשר הצעה"
                                            OnClick="ApproveBid"
                                            CommandArgument='<%# Eval("BidId") %>'
                                            Visible='<%# !(bool)Eval("Status") %>' />
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



    <!-- שדות מוסתרים לשמירת מזהים -->
    <input type="hidden" id="hiddenReadId" runat="server" />
    <input type="hidden" id="hiddenCustomerId" runat="server" />
    <input type="hidden" id="hiddenTechnicianId" runat="server" />
    <!-- הוספת סגנונות חדשים -->
    <style>
        /* צבעים מוגדרים */
        :root {
            --purple-50: #F7F4FF;
            --purple-100: #EDE8FF;
            --purple-500: #7C3AED;
            --purple-600: #6B46C1;
            --purple-700: #553C9A;
            --purple-800: #44337A;
        }

        /* מיכל ראשי */
        .dashboard-container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            box-shadow: 0 4px 20px rgba(107, 70, 193, 0.1);
        }

        /* כרטיס הצעת מחיר */
        .card {
            background: white;
            padding: 30px;
            margin-bottom: 20px;
        }

        /* כותרת עליונה */
        .header-section {
            background: var(--purple-600);
            color: white;
            padding: 20px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 24px;
            margin: 0;
        }

        .bid-id {
            font-size: 16px;
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 10px;
            border-radius: 4px;
        }

        /* טבלת פרטים */
        .details-section {
            border: 2px solid var(--purple-100);
            border-radius: 0 0 8px 8px;
            overflow: hidden;
        }

        .detail-group {
            display: flex;
            border-bottom: 1px solid var(--purple-100);
        }

            .detail-group:last-child {
                border-bottom: none;
            }

        .detail-item {
            display: flex;
            padding: 15px 20px;
            align-items: center;
            flex: 1;
            border-right: 1px solid var(--purple-100);
        }

            .detail-item:last-child {
                border-right: none;
            }

        .detail-label {
            color: var(--purple-700);
            font-weight: 500;
            margin-left: 10px;
            min-width: 120px;
        }

        .detail-value {
            color: var(--purple-800);
        }

        /* מחיר */
        .price {
            font-size: 20px;
            font-weight: 700;
            color: var(--purple-600);
        }

        /* סטטוס */
        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 4px;
            font-weight: 500;
        }

            .status:contains("אושר") {
                background: #48BB78;
                color: white;
            }

            .status:contains("בהמתנה") {
                background: var(--purple-500);
                color: white;
            }

        /* הערות */
        .description-container {
            margin-top: 20px;
            padding: 20px;
            background: var(--purple-50);
            border-radius: 8px;
            border-right: 4px solid var(--purple-500);
        }

        .description-text {
            margin: 10px 0 0;
            color: var(--purple-700);
            line-height: 1.5;
        }

        /* כפתור אישור */
        .action-buttons {
            margin-top: 20px;
            text-align: center;
        }

        .btn-success {
            background: var(--purple-600);
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .btn-success:hover {
                background: var(--purple-700);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 70, 193, 0.2);
            }

        /* טבלת פריטים */
        .detail-group:nth-child(2) {
            background: var(--purple-50);
        }

            .detail-group:nth-child(2) .detail-item {
                border-color: rgba(107, 70, 193, 0.1);
            }

        /* התאמה למסכים קטנים */
        @media (max-width: 768px) {
            .detail-group {
                flex-direction: column;
            }

            .detail-item {
                border-right: none;
                border-bottom: 1px solid var(--purple-100);
            }

                .detail-item:last-child {
                    border-bottom: none;
                }
        }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
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

        // bids.js
        $(document).ready(function () {
            // פונקציית ריענון אוטומטי
            function refreshBids() {
                __doPostBack('<%= RefreshTimer.ClientID %>', '');
            }

            // הוספת class להדגשת הצעת מחיר ספציפית
            const bidId = new URLSearchParams(window.location.search).get('bidId');
            if (bidId) {
                $(`#bid-${bidId}`).addClass('highlighted-bid');
            }

            // טיפול בשגיאות AJAX
            $(document).ajaxError(function (event, jqXHR, settings, error) {
                Swal.fire('שגיאה', 'אירעה שגיאה בתקשורת עם השרת', 'error');
            });
        });

        // פונקציית לוג
        function logEvent(stage, message, data = null) {
            const timestamp = new Date().toISOString();
            console.log(`[${timestamp}] ${stage}: ${message}`);
            if (data) {
                console.log('Data:', data);
            }
        }

        // פונקציית לוג שגיאות
        function logError(stage, error) {
            const timestamp = new Date().toISOString();
            console.error(`[${timestamp}] Error in ${stage}:`);
            console.error('Error message:', error.message);
            console.error('Stack trace:', error.stack);
            if (error.response) {
                console.error('API Response:', error.response);
            }
        }

        // פונקציה לעדכון סטטוס הצעת מחיר
        async function updateBidStatus(bidId, isApproved) {
            try {
                logEvent('Status Update', `Updating bid status. BidId: ${bidId}, Approved: ${isApproved}`);

                const response = await fetch('/api/Bid/UpdateStatus', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        bidId: bidId,
                        status: isApproved
                    })
                });

                logEvent('Status Update', `Response status: ${response.status}`);

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                // הצגת הודעת הצלחה
                await Swal.fire({
                    title: 'הצלחה!',
                    text: isApproved ? 'הצעת המחיר אושרה בהצלחה' : 'הצעת המחיר עודכנה בהצלחה',
                    icon: 'success',
                    timer: 2000,
                    showConfirmButton: false
                });

                // ריענון הדף
                location.reload();

                logEvent('Status Update', 'Status updated successfully');
            } catch (error) {
                logError('Status Update', error);
                await Swal.fire('שגיאה', 'אירעה שגיאה בעדכון הסטטוס', 'error');
            }
        }

        // טיפול בהדגשת הצעת מחיר נבחרת
        document.addEventListener("DOMContentLoaded", function () {
            const params = new URLSearchParams(window.location.search);
            const bidId = params.get("bidId");
            if (bidId) {
                const target = document.getElementById(`bid-${bidId}`);
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
