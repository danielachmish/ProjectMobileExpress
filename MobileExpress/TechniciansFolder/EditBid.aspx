<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="EditBid.aspx.cs" Inherits="MobileExpress.TechniciansFolder.EditBid" %>

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
    <div class="invoice-container" dir="rtl">
        <!-- פרטי טכנאי -->
        <div class="invoice-header">
            <div class="quote-info">
                <h2>פרטי טכנאי</h2>
                <div class="info-item">
                    <span class="label">מספר טכנאי:</span>
                    <asp:Label ID="lblTechNumber" runat="server" />
                </div>
                <div class="info-item">
                    <span class="label">שם:</span>
                    <asp:Label ID="lblTechName" runat="server" />
                </div>
                <div class="info-item">
                    <span class="label">טלפון:</span>
                    <asp:Label ID="lblTechPhone" runat="server" />
                </div>
            </div>

            <!-- פרטי הצעת מחיר -->
            <div class="quote-info">
                <h2>הצעת מחיר</h2>
                <div class="info-item">
                    <span class="label">מספר הצעה:</span>
                    <asp:Label ID="lblBidNumber" runat="server" />
                </div>
                <div class="info-item">
                    <span class="label">תאריך:</span>
                    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="info-item">
                    <span class="label">מספר קריאה:</span>
                    <asp:Label ID="lblReadId" runat="server" />
                </div>
            </div>
        </div>

        <!-- פרטי לקוח -->
        <div class="form-section">
            <h3>פרטי לקוח</h3>
            <div class="form-group">
                <label>שם לקוח:</label>
                <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" ReadOnly="true" />
            </div>
            <div class="form-group">
                <label>טלפון:</label>
                <asp:TextBox ID="txtCustomerPhone" runat="server" CssClass="form-control" ReadOnly="true" />
            </div>
            <div class="form-group">
                <label>תיאור התקלה:</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>
        </div>

        <!-- פרטי פריט -->
        <div class="form-section">
            <h3>פרטי פריט</h3>
            <div class="form-group">
                <label>תיאור פריט:</label>
                <asp:TextBox ID="txtItemDescription" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label>כמות:</label>
                <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control" TextMode="Number" />
            </div>
            <div class="form-group">
                <label>מחיר ליחידה:</label>
                <asp:TextBox ID="txtUnitPrice" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <label>סה"כ לפני מע"מ:</label>
                <asp:Label ID="lblSubTotal" runat="server" CssClass="form-control-static" />
            </div>
            <div class="form-group">
                <label>מע"מ (17%):</label>
                <asp:Label ID="lblVat" runat="server" CssClass="form-control-static" />
            </div>
            <div class="form-group">
                <label>סה"כ כולל מע"מ:</label>
                <asp:Label ID="lblTotal" runat="server" CssClass="form-control-static" />
            </div>
            <div class="form-group">
                <label>סטטוס:</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Text="פעיל" Value="true" />
                    <asp:ListItem Text="לא פעיל" Value="false" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnSave" runat="server" Text="שמור שינויים" CssClass="btn btn-primary" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="חזור" CssClass="btn btn-secondary" OnClick="btnCancel_Click" />
        </div>
    </div>
    <style>
        .invoice-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(128, 0, 128, 0.1);
            direction: rtl;
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            gap: 30px;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e1bee7;
        }

        .quote-info {
            flex: 1;
        }

            .quote-info h2 {
                color: #6a1b9a;
                margin-bottom: 20px;
                font-weight: bold;
                font-size: 1.5rem;
            }

        .info-item {
            margin-bottom: 15px;
        }

            .info-item .label {
                font-weight: 500;
                color: #6a1b9a;
                margin-left: 8px;
            }

        .form-section {
            margin-bottom: 40px;
            padding: 20px;
            background: #faf5ff;
            border-radius: 10px;
        }

            .form-section h3 {
                color: #6a1b9a;
                margin-bottom: 20px;
                font-size: 1.3rem;
                font-weight: 600;
            }

        .form-group {
            margin-bottom: 20px;
        }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #6a1b9a;
                font-weight: 500;
            }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1bee7;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

            .form-control:focus {
                border-color: #9c27b0;
                box-shadow: 0 0 0 0.2rem rgba(156, 39, 176, 0.25);
                outline: none;
            }

            .form-control[readonly] {
                background-color: #f3e5f5;
                cursor: not-allowed;
            }

        .form-control-static {
            padding: 12px;
            background: #fff;
            border: 1px solid #e1bee7;
            border-radius: 8px;
            display: block;
        }

        .form-actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: flex-start;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #9c27b0;
            border: none;
            color: white;
        }

            .btn-primary:hover {
                background-color: #6a1b9a;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(156, 39, 176, 0.2);
            }

        .btn-secondary {
            background-color: #e1bee7;
            border: none;
            color: #6a1b9a;
        }

            .btn-secondary:hover {
                background-color: #ce93d8;
                color: #4a148c;
                transform: translateY(-2px);
            }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%236a1b9a' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: left 1rem center;
            background-size: 1em;
            padding-left: 40px;
        }

        @media (max-width: 768px) {
            .invoice-container {
                margin: 20px;
                padding: 20px;
            }

            .invoice-header {
                flex-direction: column;
                gap: 20px;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }

        .form-control:focus {
            transform: translateY(-2px);
        }

        .form-section {
            transition: transform 0.3s ease;
        }

            .form-section:hover {
                transform: translateY(-2px);
            }

        input[type="number"] {
            text-align: left;
            direction: ltr;
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
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

    <script type="text/javascript">
        function calculateTotals() {
            var quantity = parseFloat(document.getElementById('<%= txtQuantity.ClientID %>').value) || 0;
        var unitPrice = parseFloat(document.getElementById('<%= txtUnitPrice.ClientID %>').value) || 0;

        var subtotal = quantity * unitPrice;
        var vat = subtotal * 0.17;
        var total = subtotal + vat;

        document.getElementById('<%= lblSubTotal.ClientID %>').innerText = subtotal.toFixed(2) + ' ₪';
        document.getElementById('<%= lblVat.ClientID %>').innerText = vat.toFixed(2) + ' ₪';
        document.getElementById('<%= lblTotal.ClientID %>').innerText = total.toFixed(2) + ' ₪';
        }

        document.getElementById('<%= txtQuantity.ClientID %>').addEventListener('input', calculateTotals);
        document.getElementById('<%= txtUnitPrice.ClientID %>').addEventListener('input', calculateTotals);
    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
