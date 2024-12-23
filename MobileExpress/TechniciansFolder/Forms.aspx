<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="Forms.aspx.cs" Inherits="MobileExpress.TechniciansFolder.Forms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="assets/css/styles.css">
    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager runat="server" EnablePageMethods="true"></asp:ScriptManager>
   

    <div class="container" dir="rtl">
        <h2 class="mt-4 mb-4">ניהול הצעות מחיר</h2>

        <div class="card">
            <div class="card-header bg-white">
                <!-- חיפוש וסינון -->
                <div class="row g-3 align-items-center p-2">
                    <div class="col-md-4">
                        <div class="input-group">
                            <input type="text" id="txtSearch" runat="server" class="form-control" placeholder="חיפוש חופשי..." />
                            <div class="input-group-append">
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="חפש" OnClick="btnSearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                            <asp:ListItem Text="כל הסטטוסים" Value="" />
                            <asp:ListItem Text="מאושר" Value="true" />
                            <asp:ListItem Text="ממתין לאישור" Value="false" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group">
                            <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date" />
                            <span class="input-group-text">עד</span>
                            <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-body p-0">
                <asp:GridView ID="gvBids" runat="server" CssClass="table table-hover"
                    AutoGenerateColumns="False" OnRowCommand="gvBids_RowCommand" DataKeyNames="BidId">
                    <Columns>
                        <asp:BoundField DataField="BidId" HeaderText="מספר הצעה" />
                        <asp:BoundField DataField="FullName" HeaderText="שם לקוח" />
                        <asp:BoundField DataField="Date" HeaderText="תאריך" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="Price" HeaderText="סכום" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="ItemDescription" HeaderText="תיאור" />
                        <asp:TemplateField HeaderText="סטטוס">
                            <ItemTemplate>
                                <span class='<%# GetStatusClass(Convert.ToBoolean(Eval("Status"))) %>'>
                                    <%# GetStatusText(Convert.ToBoolean(Eval("Status"))) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="פעולות">
                            <ItemTemplate>
                                <div class="btn-group">

                                    <button type="button" class="btn btn-info btn-sm ms-1 view-bid-btn"
                                        data-bid-id='<%# Eval("BidId") %>'
                                        onclick="viewBid(<%# Eval("BidId") %>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <%--  <button type="button" class="btn btn-primary btn-sm"
                                        onclick="editBid(<%# Eval("BidId") %>)">
                                        <i class="fas fa-edit"></i>
                                    </button>--%>
                                    <button type="button" class="btn btn-primary btn-sm"
                                        onclick="editBid(<%# Eval("BidId") %>, <%# Eval("Status").ToString().ToLower() %>)"
                                        <%# Convert.ToBoolean(Eval("Status")) ? "disabled" : "" %>>
                                        <i class="fas fa-edit"></i>
                                    </button>
                                   <div class="btn-group">
             <asp:Button runat="server" 
                CommandName="AcceptCall"
                CommandArgument='<%# Eval("ReadId") %>'
                CssClass="btn btn-success btn-sm"
                Text="קח קריאה"
                Visible='<%# (bool)Eval("Status") %>'
                OnClientClick="return confirm('האם אתה בטוח שברצונך לקחת את הקריאה?');" />

                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>


    <!-- מודל פרטי הצעת מחיר -->
    <div class="modal fade" id="bidModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close me-auto" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                    <h5 class="modal-title">פרטי הצעת מחיר</h5>
                </div>
                <div class="modal-body" id="bidDetails">
                    <!-- תוכן דינמי -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="printCurrentBid()">
                        <i class="fas fa-print"></i>הדפס
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">סגור</button>
                </div>
            </div>
        </div>
    </div>
   

    <style>
        :root {
            --purple-50: rgba(124, 58, 237, 0.05);
            --purple-100: rgba(124, 58, 237, 0.1);
            --purple-500: #7c3aed;
            --purple-600: #6d28d9;
            --purple-700: #5b21b6;
        }

        .container {
            max-width: 1400px;
            padding: 2rem;
            margin: 0 auto;
        }

        /* כללי */
        body {
            direction: rtl;
            text-align: right;
            color: var(--text-dark);
        }

        /* כרטיס ראשי */
        .card {
            border: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border-radius: 16px;
            overflow: hidden;
            background: white;
        }

        .card-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--purple-50);
            background: white;
        }

        /* טפסים ושדות קלט */
        .form-control, .form-select {
            padding: 0.75rem 1rem;
            border-radius: 12px;
            border: 2px solid var(--border-light);
            transition: all 0.3s ease;
        }

            .form-control:focus, .form-select:focus {
                border-color: var(--purple-500);
                box-shadow: 0 0 0 3px var(--purple-50);
            }

        .input-group {
            gap: 0.5rem;
        }

        .input-group-text {
            background: var(--purple-50);
            border: 2px solid var(--border-light);
            border-radius: 12px;
            color: var(--purple-700);
        }

        /* כפתורים */
        :root {
            --purple-50: rgba(124, 58, 237, 0.05);
            --purple-100: rgba(124, 58, 237, 0.1);
            --purple-500: #7c3aed;
            --purple-600: #6d28d9;
            --purple-700: #5b21b6;
        }

        /* Base Styles */
        .btn,
        .form-control,
        .input-group-text,
        .form-select,
        .badge {
            border-radius: 9999px !important;
        }

        /* Input Fields */
        .form-control, .form-select {
            padding: 0.75rem 1.5rem;
            border: 2px solid #e5e7eb;
            transition: all 0.3s ease;
        }

            .form-control:focus, .form-select:focus {
                border-color: var(--purple-500);
                box-shadow: 0 0 0 3px var(--purple-50);
            }

        /* Buttons */
        .btn-primary {
            background-color: var(--purple-500);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
        }

            .btn-primary:hover {
                background-color: var(--purple-600);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(124, 58, 237, 0.25);
            }

        /* Info Button */
        .btn-info {
            background-color: var(--purple-50);
            color: var(--purple-500);
            border: none;
        }

            .btn-info:hover {
                background-color: var(--purple-500);
                color: white;
            }

        /* Badge Styles */
        .badge-success {
            background-color: #dcfce7;
            color: #16a34a;
            padding: 0.5rem 1rem;
        }

        .badge-danger {
            background-color: #fee2e2;
            color: #dc2626;
            padding: 0.5rem 1rem;
        }

        /* Table Styles */
        .table {
            width: 100%;
            font-size: 1rem;
            margin-bottom: 2rem;
        }

            .table th {
                background-color: var(--purple-50);
                color: var(--purple-700);
                font-size: 1.1rem;
                font-weight: 600;
                padding: 1.25rem 1rem;
                white-space: nowrap;
            }

            .table td {
                padding: 1.25rem 1rem;
                vertical-align: middle;
                font-size: 1rem;
                min-width: 120px; /* מינימום רוחב לכל תא */
            }

        /* Text Field Styles */
        .form-control, .form-select {
            font-size: 1rem;
            padding: 1rem 1.5rem;
            min-height: 50px;
            border-radius: 9999px !important;
            border: 2px solid #e5e7eb;
        }
        /* Buttons */
        .btn {
            font-size: 1rem;
            padding: 1rem 1.5rem;
            min-height: 50px;
            border-radius: 9999px !important;
            white-space: nowrap;
        }

        /* Status Badges */
        .badge {
            font-size: 0.95rem;
            padding: 0.75rem 1.5rem;
            border-radius: 9999px;
            white-space: nowrap;
        }

        /* Search and Filter Section */
        .filters-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* Header Text */
        h2 {
            font-size: 1.75rem;
            margin-bottom: 2rem;
            color: var(--purple-700);
        }

        /* Action Buttons in Table */
        .btn-group {
            display: flex;
            gap: 0.5rem;
        }

            .btn-group .btn {
                padding: 0.75rem 1rem;
                min-height: 40px;
            }

        /* Responsive Table */
        @media (max-width: 1200px) {
            .table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }

        /* Input Fields */
        .input-group {
            min-height: 50px;
        }

        .input-group-text {
            font-size: 1rem;
            padding: 0.75rem 1.5rem;
            border-radius: 9999px !important;
        }

        /* Description Cell */
        .description-cell {
            min-width: 250px; /* רוחב מינימלי לתא התיאור */
            max-width: 400px; /* רוחב מקסימלי לתא התיאור */
            white-space: normal; /* מאפשר שבירת שורות */
            line-height: 1.5;
        }

        /* Date Fields */
        input[type="date"].form-control {
            min-width: 150px;
        }

        /* Dropdown */
        select.form-select {
            min-width: 200px;
        }
        /* Action Buttons in Table */
        .btn-group .btn {
            padding: 0.5rem 1rem;
            margin: 0 0.2rem;
        }

        /* Input Groups */
        .input-group {
            gap: 0.5rem;
        }

        .input-group-text {
            background-color: #f8fafc;
            border: 1px solid #e5e7eb;
            padding: 0.75rem 1.5rem;
        }

        /* Hover and Active States */
        .btn:active {
            transform: scale(0.98);
        }

        .form-control:hover {
            border-color: var(--purple-100);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .btn, .form-control, .input-group-text {
                width: 100%;
                margin: 0.25rem 0;
            }

            .input-group {
                flex-direction: column;
            }
        }
        /* טבלה */
        .table {
            margin: 0;
            border-radius: 16px;
            overflow: hidden;
        }

            .table th {
                background: var(--purple-50);
                color: var(--purple-700);
                font-weight: 600;
                padding: 1.2rem 1rem;
                border: none;
            }

            .table td {
                padding: 1.2rem 1rem;
                border-color: var(--purple-50);
                vertical-align: middle;
            }

            .table tbody tr {
                transition: background-color 0.3s ease;
            }

                .table tbody tr:hover {
                    background: var(--purple-50);
                }

        /* תגיות סטטוס */
        .badge {
            padding: 0.6rem 1.2rem;
            border-radius: 999px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .badge-success {
            background: #dcfce7;
            color: #15803d;
        }

        .badge-danger {
            background: #fee2e2;
            color: var(--danger);
        }

        /* מודאל */
        .modal-content {
            border-radius: 24px;
            border: none;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .modal-header {
            background: var(--purple-500);
            color: white;
            border-radius: 24px 24px 0 0;
            padding: 1.5rem;
        }

        .modal-body {
            padding: 2rem;
        }

        .modal-footer {
            border-top: 1px solid var(--purple-50);
            padding: 1.5rem;
        }

        /* רספונסיביות */
        @media (max-width: 768px) {
            .input-group {
                flex-direction: column;
            }

            .form-control, .btn {
                width: 100%;
            }

            .card-header {
                padding: 1rem;
            }

            .table {
                display: block;
                overflow-x: auto;
            }
        }

        /* אנימציות נוספות */
        .btn, .badge, .form-control {
            will-change: transform;
        }

            .btn:active {
                transform: scale(0.98);
            }

            .form-control:hover {
                border-color: var(--purple-100);
            }

        .table tbody tr:active {
            background: var(--purple-100);
            transform: scale(0.99);
        }

        button[disabled] {
            opacity: 0.6;
            cursor: not-allowed;
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
    <script>
        function filterTable() {
            // קבלת ערך החיפוש
            let input = document.getElementById("searchInput");
            let filter = input.value.toLowerCase();

            // קבלת הטבלה וכל השורות שלה
            let table = document.getElementById("gvBids");
            let rows = table.getElementsByTagName("tr");

            // לולאה על כל השורות בטבלה (מדלגים על שורת הכותרת)
            for (let i = 1; i < rows.length; i++) {
                let showRow = false;
                // קבלת כל התאים בשורה
                let cells = rows[i].getElementsByTagName("td");

                // בדיקה בכל התאים (חוץ מעמודת הפעולות)
                for (let j = 0; j < cells.length - 1; j++) {
                    let cell = cells[j];
                    if (cell) {
                        let textValue = cell.textContent || cell.innerText;
                        if (textValue.toLowerCase().indexOf(filter) > -1) {
                            showRow = true;
                            break;
                        }
                    }
                }

                // הצגה או הסתרה של השורה בהתאם לתוצאות החיפוש
                rows[i].style.display = showRow ? "" : "none";
            }
        }

        // פונקציה לניקוי החיפוש
        function clearSearch() {
            document.getElementById("searchInput").value = "";
            filterTable();
        }


        // פונקציה נוספת לניקוי החיפוש
        function clearSearch() {
            document.getElementById("txtGridSearch").value = "";
            filterGrid();
        }

        function viewBid(bidId) {
            if (!bidId) {
                console.error('No bidId provided');
                return;
            }

            console.log('Viewing bid:', bidId);

            $.ajax({
                url: 'Forms.aspx/GetBidDetails',
                type: 'POST',
                data: JSON.stringify({ bidId: bidId }),
                contentType: 'application/json',
                dataType: 'json',
                success: function (response) {
                    console.log('Server response:', response);
                    if (response && response.d) {
                        try {
                            const bidData = response.d;
                            displayBidDetails(JSON.parse(bidData));
                        } catch (e) {
                            console.error('Error parsing bid data:', e);
                            alert('אירעה שגיאה בעיבוד הנתונים');
                        }
                    } else {
                        alert('לא נמצאו פרטים להצעת המחיר המבוקשת');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Ajax error:', { xhr, status, error });
                    alert('אירעה שגיאה בטעינת פרטי ההצעה');
                }
            });
        }
        // חיבור Event Listener אלטרנטיבי
        $(document).ready(function () {
            // אתחול DatePicker בעברית (אם יש צורך)
            $.datepicker.setDefaults($.datepicker.regional["he"]);

            // הגדרת ולידציה לתאריכים
            $("#<%= txtDateFrom.ClientID %>").change(function () {
                var fromDate = $(this).val();
                $("#<%= txtDateTo.ClientID %>").attr('min', fromDate);
            });

            $("#<%= txtDateTo.ClientID %>").change(function () {
                var toDate = $(this).val();
                $("#<%= txtDateFrom.ClientID %>").attr('max', toDate);
            });

            // חיפוש אוטומטי אחרי הקלדה (אופציונלי)
            let typingTimer;
            const doneTypingInterval = 500;

            $("#<%= txtSearch.ClientID %>").on('keyup', function () {
                clearTimeout(typingTimer);
                typingTimer = setTimeout(function () {
                    $("#<%= btnSearch.ClientID %>").click();
                }, doneTypingInterval);
            });
        });



        function displayBidDetails(bid) {
            if (!bid) {
                console.error('No bid data received');
                return;
            }

            console.log('Displaying bid:', bid);

            // המרת תאריך לפורמט מתאים
            const date = new Date(bid.Date);
            const formattedDate = date.toLocaleDateString('he-IL');

            let html = `
    <div class="bid-details p-3" dir="rtl">
        <!-- כותרת ופרטים בסיסיים -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">הצעת מחיר מספר: ${bid.BidNumber}</h5>
                    <div>
                        <span>תאריך: ${formattedDate}</span>
                        <span class="mr-3">מספר קריאה: ${bid.ReadId}</span>
                    </div>
                </div>
            </div>
        </div>
 <!-- פרטי טכנאי -->
        <div class="card mb-4">
            <div class="card-header">
                <h6 class="mb-0">פרטי טכנאי</h6>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <strong>שם:</strong> ${bid.TechnicianDetails?.Name || 'לא צוין'}
                    </div>
                    <div class="col-md-6">
                        <strong>טלפון:</strong> ${bid.TechnicianDetails?.Phone || 'לא צוין'}
                    </div>
                </div>
                
            </div>
        </div>
        <!-- פרטי לקוח -->
        <div class="card mb-4">
            <div class="card-header">
                <h6 class="mb-0">פרטי לקוח</h6>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <strong>שם:</strong> ${bid.CustomerDetails?.Name || 'לא צוין'}
                    </div>
                    <div class="col-md-6">
                        <strong>טלפון:</strong> ${bid.CustomerDetails?.Phone || 'לא צוין'}
                    </div>
                </div>
                <div class="mt-3">
                    <strong>תיאור התקלה:</strong>
                    <p>${bid.CustomerDetails?.Description || 'אין תיאור'}</p>
                </div>
            </div>
        </div>

        <!-- פרטי ההצעה -->
        <div class="card mb-4">
            <div class="card-header">
                <h6 class="mb-0">פרטי ההצעה</h6>
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>תיאור</th>
                            <th>כמות</th>
                            <th>מחיר ליחידה</th>
                            <th>סה"כ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${bid.ItemDescription || 'לא צוין'}</td>
                            <td>${bid.ItemQuantity}</td>
                            <td>₪${bid.ItemUnitPrice.toFixed(2)}</td>
                            <td>₪${bid.ItemTotal.toFixed(2)}</td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="text-left"><strong>סה"כ לפני מע"מ:</strong></td>
                            <td>₪${bid.Subtotal.toFixed(2)}</td>
                        </tr>
                        <tr>
                            <td colspan="3" class="text-left"><strong>מע"מ:</strong></td>
                            <td>₪${bid.Vat.toFixed(2)}</td>
                        </tr>
                        <tr>
                            <td colspan="3" class="text-left"><strong>סה"כ כולל מע"מ:</strong></td>
                            <td>₪${bid.Total.toFixed(2)}</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>`;

            // עדכון תוכן המודל
            $('#bidDetails').html(html);

            // הצגת המודל
            $('#bidModal').modal('show');
        }
        //function editBid(bidId) {
        //    window.location.href = `EditBid.aspx?id=${bidId}`;
        //}

        function editBid(bidId, status) {
            if (status === true) {
                alert('לא ניתן לערוך הצעת מחיר מאושרת');
                return;
            }
            window.location.href = `EditBid.aspx?id=${bidId}`;
        }

        function printCurrentBid() {
            const content = document.getElementById('bidDetails').innerHTML;
            const printWindow = window.open('', '', 'height=600,width=800');

            printWindow.document.write(`
    <!DOCTYPE html>
    <html dir="rtl" lang="he">
    <head>
        <title>הדפסת הצעת מחיר</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body { 
                padding: 20px; 
                direction: rtl; 
                text-align: right; 
                font-family: Arial, sans-serif; 
            }
            .container {
                direction: rtl;
                text-align: right;
            }
            .bid-details {
                margin: 20px;
            }
            @media print {
                .no-print { display: none !important; }
            }
        </style>
    </head>
    <body>
        <div class="container">
            ${content}
        </div>
    </body>
    </html>
    `);

            printWindow.document.close();
            setTimeout(() => {
                printWindow.print();
                printWindow.close();
            }, 250);
        }



    </script>
</asp:Content>

