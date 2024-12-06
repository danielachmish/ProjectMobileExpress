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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <div class="container" dir="rtl">
        <h2 class="mt-4 mb-4">ניהול הצעות מחיר</h2>

        <!-- חיפוש והוספה -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="חיפוש..." />
                    <div class="input-group-append">
                        <asp:Button ID="btnSearch" runat="server" Text="חפש" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
            <div class="col-md-6 text-left">
                <button type="button" class="btn btn-success" onclick="openNewBidForm()">
                    <i class="fas fa-plus"></i>הצעת מחיר חדשה
                </button>
            </div>
        </div>

        <!-- טבלת הצעות מחיר -->
        <asp:GridView ID="gvBids" runat="server" CssClass="table table-striped table-bordered"
            AutoGenerateColumns="False" OnRowCommand="gvBids_RowCommand" DataKeyNames="BidId">
            <Columns>
                <asp:BoundField DataField="BidId" HeaderText="מספר הצעה" />

                <%--    <asp:BoundField DataField="FullName" DataFormatString="שם לקוח" />--%>

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
                            <button type="button" class="btn btn-info btn-sm view-bid-btn"
                                data-bid-id='<%# Eval("BidId") %>'
                                onclick="viewBid(<%# Eval("BidId") %>)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button type="button" class="btn btn-primary btn-sm"
                                onclick="editBid(<%# Eval("BidId") %>)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-secondary btn-sm"
                                onclick="printBid(<%# Eval("BidId") %>)">
                                <i class="fas fa-print"></i>
                            </button>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- מודל פרטי הצעת מחיר -->
    <div class="modal fade" id="bidModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">פרטי הצעת מחיר</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="bidDetails">
                    <!-- תוכן דינמי -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">סגור</button>
                    <button type="button" class="btn btn-primary" onclick="printCurrentBid()">הדפס</button>
                </div>
            </div>
        </div>
    </div>
   <style>
/* צבעים קבועים */
:root {
    --purple-50: rgba(124, 58, 237, 0.05);
    --purple-100: rgba(124, 58, 237, 0.1);
    --purple-500: #7c3aed;
    --purple-600: #6d28d9;
    --purple-700: #5b21b6;
}

.container {
    padding: 2rem;
}

h2.mt-4 {
    color: var(--purple-700);
    font-weight: 600;
    font-size: 1.8rem;
    margin-bottom: 2rem;
}

/* עיצוב תיבת החיפוש */
.input-group .form-control {
    border-radius: 12px 0 0 12px;
    border: 2px solid #e5e7eb;
    padding: 0.75rem 1rem;
    transition: all 0.3s ease;
}

.input-group .form-control:focus {
    border-color: var(--purple-500);
    box-shadow: 0 0 0 3px var(--purple-50);
}

.input-group-append .btn-primary {
    border-radius: 0 12px 12px 0;
    background: var(--purple-500);
    border: none;
    padding: 0.75rem 1.5rem;
    transition: all 0.3s ease;
}

.input-group-append .btn-primary:hover {
    background: var(--purple-600);
    transform: translateY(-1px);
}

/* כפתור הוספת הצעת מחיר */
.btn-success {
    background: var(--purple-500);
    border: none;
    border-radius: 12px;
    padding: 0.75rem 1.5rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(124, 58, 237, 0.15);
}

.btn-success:hover {
    background: var(--purple-600);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(124, 58, 237, 0.25);
}

.btn-success i {
    margin-left: 0.5rem;
}

/* עיצוב טבלה */
.table {
    border-radius: 16px;
    overflow: hidden;
    border: none;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.table th {
    background: var(--purple-50);
    color: var(--purple-700);
    font-weight: 600;
    padding: 1rem;
    border: none;
}

.table td {
    padding: 1rem;
    border-color: rgba(124, 58, 237, 0.1);
    vertical-align: middle;
}

.table tbody tr {
    transition: all 0.3s ease;
}

.table tbody tr:hover {
    background: var(--purple-50);
}

/* כפתורי פעולות */
.btn-group {
    gap: 0.5rem;
}

.btn-group .btn {
    border-radius: 8px;
    padding: 0.5rem 0.75rem;
    transition: all 0.3s ease;
}

.btn-info {
    background: var(--purple-50);
    color: var(--purple-500);
    border: none;
}

.btn-info:hover {
    background: var(--purple-500);
    color: white;
    transform: translateY(-2px);
}

.btn-primary {
    background: var(--purple-500);
    border: none;
}

.btn-primary:hover {
    background: var(--purple-600);
    transform: translateY(-2px);
}

.btn-secondary {
    background: #f3f4f6;
    color: #4b5563;
    border: none;
}

.btn-secondary:hover {
    background: #e5e7eb;
    transform: translateY(-2px);
}

/* סטטוס */
.badge {
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-weight: 500;
}

.badge-success {
    background: #dcfce7;
    color: #15803d;
}

.badge-danger {
    background: #fee2e2;
    color: #dc2626;
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

.modal-header .close {
    color: white;
    opacity: 1;
    text-shadow: none;
    transition: transform 0.3s ease;
}

.modal-header .close:hover {
    transform: rotate(90deg);
}

.modal-body {
    padding: 2rem;
}

.modal-footer {
    border-top: 1px solid rgba(124, 58, 237, 0.1);
    padding: 1.5rem;
}

/* כפתורים במודאל */
.modal-footer .btn {
    padding: 0.75rem 1.5rem;
    border-radius: 12px;
    transition: all 0.3s ease;
}

.modal-footer .btn-primary {
    background: var(--purple-500);
    border: none;
}

.modal-footer .btn-primary:hover {
    background: var(--purple-600);
    transform: translateY(-2px);
}

.modal-footer .btn-secondary {
    background: #f3f4f6;
    color: #4b5563;
    border: none;
}

.modal-footer .btn-secondary:hover {
    background: #e5e7eb;
    transform: translateY(-2px);
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
               $(document).on('click', '.view-bid-btn', function () {
                   var bidId = $(this).data('bid-id');
                   viewBid(bidId);
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
           function editBid(bidId) {
               window.location.href = `EditBid.aspx?id=${bidId}`;
           }

           function printCurrentBid() {
               const content = document.getElementById('bidDetails').innerHTML;
               const printWindow = window.open('', '', 'height=600,width=800');

               printWindow.document.write(`
            <!DOCTYPE html>
            <html dir="rtl">
            <head>
                <title>הדפסת הצעת מחיר</title>
                <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
                <style>
                    body { padding: 20px; }
                    .bid-details { margin: 20px; }
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

