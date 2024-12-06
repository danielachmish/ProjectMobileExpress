<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="AllBids.aspx.cs" Inherits="MobileExpress.TechniciansFolder.AllBids" %>

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

    <!-- שדות מוסתרים בלבד בראש הדף -->
    <asp:HiddenField ID="hiddenReadId" runat="server" />
    <asp:HiddenField ID="hiddenCustomerId" runat="server" />
    <asp:HiddenField ID="hiddenTechnicianId" runat="server" />


    <div class="invoice-container" dir="rtl">
        <!-- כותרת ופעולות -->
        <div class="invoice-header">
            <div class="quote-info">
                <h2>פרטי טכנאי</h2>
                <div class="info-item">
                    <span class="label">מספר טכנאי:</span>
                    <span id="techNumber"></span>
                </div>
                <div class="info-item">
                    <span class="label">שם:</span>
                    <span id="techName"></span>
                </div>
                <div class="info-item">
                    <span class="label">טלפון:</span>
                    <span id="techPhone"></span>
                </div>
            </div>
            <div class="quote-info">
                <h2>הצעת מחיר</h2>
                <div class="info-item">
                    <span class="label">מספר הצעה:</span>
                    <span id="quoteNumber"></span>
                </div>
                <div class="info-item">
                    <span class="label">תאריך:</span>
                    <span id="currentDate"></span>
                </div>
                <div class="info-item">
                    <span class="label">מספר קריאה:</span>
                    <span id="serviceCallId"></span>
                </div>
            </div>

            <div class="invoice-actions">
                <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-primary" Text="הדפס הצעת מחיר" OnClientClick="window.print(); return false;" />
            </div>
        </div>

        <!-- טופס פרטים -->
        <div class="form-group">
            <label for="txtCustomerName">שם לקוח:</label>
            <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>
        <div class="form-group">
            <label for="txtPhone">טלפון:</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>
        <%-- <div class="form-group">
            <label for="txtTechnicianName">שם טכנאי:</label>
            <asp:TextBox ID="txtTechnicianName" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>--%>
        <div class="form-group">
            <label for="txtDesc">תיאור התקלה:</label>
            <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" ReadOnly="false" />
            <span class="text-danger" id="errorTxtDesc" style="display: none;">השדה חובה</span>
        </div>

        <div class="form-group">
            <label for="txtTotalPrice">סכום כולל:</label>
            <asp:TextBox ID="txtTotalPrice" runat="server" CssClass="form-control" step="0.01" min="0" />
        </div>

        <!-- טבלת פריטים -->
        <table class="items-table">
            <thead>
                <tr>
                    <div class="card-body">
                        <%-- <asp:TextBox ID="txtItemDescription" runat="server" CssClass="form-control" placeholder="תיאור הפריט"></asp:TextBox>
<asp:TextBox ID="txtItemQuantity" runat="server" CssClass="form-control" placeholder="כמות"></asp:TextBox>
<asp:TextBox ID="txtItemUnitPrice" runat="server" CssClass="form-control" placeholder="מחיר ליחידה"></asp:TextBox>--%>

                        <p>
                            <strong>סה"כ:</strong>
                            <asp:Label ID="lblTotal" runat="server"></asp:Label>
                        </p>
                    </div>
                    <th class="no-print">פעולות</th>
                </tr>
            </thead>
            <tbody id="itemsTableBody">
                <!-- שורות הפריטים יתווספו דינמית -->
            </tbody>
            <tfoot>
                <tr class="summary-row">
                    <td colspan="3" class="text-left">סה"כ לפני מע"מ:</td>
                    <td id="subtotal">₪0.00</td>
                    <td class="no-print"></td>
                </tr>
                <tr class="summary-row">
                    <td colspan="3" class="text-left">מע"מ (17%):</td>
                    <td id="vat">₪0.00</td>
                    <td class="no-print"></td>
                </tr>
                <tr class="total">
                    <td colspan="3" class="text-left">סה"כ כולל מע"מ:</td>
                    <td id="total">₪0.00</td>
                    <td class="no-print"></td>
                </tr>
            </tfoot>
        </table>

        <!-- כפתורים להוספת פריטים ושמירה -->
        <div class="form-actions no-print">
            <asp:Button ID="btnAddItem" runat="server" CssClass="btn btn-secondary" Text="הוסף פריט" OnClientClick="addNewItem(); return false;" />
            <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="שמור הצעת מחיר" OnClick="btnSave_Click" />
        </div>
    </div>

    <!-- תבנית שורת פריט -->
    <template id="itemRowTemplate">
        <tr>
            <td>
                <input id="txtItemDescription" type="text" class="form-control item-description" required /></td>
            <td>
                <input id="txtItemQuantity" type="number" class="form-control item-quantity" min="1" value="1" required /></td>
            <td>
                <input id="txtItemUnitPrice" type="number" class="form-control item-price" min="0" step="0.01" required /></td>
            <td class="item-total">₪0.00</td>
            <td class="no-print">
                <button type="button" class="btn btn-danger btn-sm delete-item" onclick="deleteItem(this)">מחק</button>
            </td>
        </tr>
    </template>
  <%--  <style>
        /* מיכל הצעת המחיר */
        .invoice-container {
            background: white;
            padding: 30px;
            margin: 20px auto;
            max-width: 1000px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            direction: rtl;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        /* כותרת והפעולות */
        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .quote-info h2 {
            margin: 0 0 15px 0;
            color: #2c3e50;
            font-size: 24px;
        }

        .info-item {
            margin-bottom: 8px;
            color: #555;
        }

            .info-item .label {
                font-weight: 600;
                margin-left: 8px;
                color: #666;
            }

        /* אזור הכתובות */
        .billing-section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            gap: 30px;
        }

        .bill-to, .bill-from {
            flex: 1;
        }

            .bill-to h3, .bill-from h3 {
                margin: 0 0 10px 0;
                color: #2c3e50;
                font-size: 18px;
            }

        .contact-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            border: 1px solid #e9ecef;
        }

            .contact-info p {
                margin: 5px 0;
                color: #495057;
            }

        .company-name {
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        /* פרטי המכשיר */
        .device-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
            margin: 20px 0;
            border: 1px solid #e9ecef;
        }

            .device-info h3 {
                margin: 0 0 15px 0;
                color: #2c3e50;
                font-size: 18px;
            }

        /* טבלת פריטים */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

            .items-table th {
                background: #f8f9fa;
                padding: 12px;
                text-align: right;
                font-weight: 600;
                color: #495057;
                border-bottom: 2px solid #dee2e6;
            }

            .items-table td {
                padding: 12px;
                border-bottom: 1px solid #dee2e6;
                vertical-align: middle;
            }

            .items-table input {
                width: 100%;
                padding: 6px 8px;
                border: 1px solid #ced4da;
                border-radius: 4px;
                font-size: 14px;
            }

                .items-table input:focus {
                    outline: none;
                    border-color: #80bdff;
                    box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
                }

        .item-total {
            font-weight: 600;
            color: #495057;
        }

        /* שורות סיכום */
        .summary-row td {
            padding: 8px 12px;
            color: #495057;
        }

        .total td {
            font-weight: bold;
            font-size: 16px;
            border-top: 2px solid #dee2e6;
            color: #2c3e50;
        }

        /* כפתורים */
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            border: 1px solid transparent;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
            border-color: #0056b3;
        }

            .btn-primary:hover {
                background-color: #0056b3;
            }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            border-color: #545b62;
        }

            .btn-secondary:hover {
                background-color: #545b62;
            }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border-color: #bd2130;
        }

            .btn-danger:hover {
                background-color: #bd2130;
            }

        .delete-item {
            padding: 4px 8px;
            font-size: 12px;
        }

        .form-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        /* מצב הדפסה */
        @media print {
            .invoice-container {
                box-shadow: none;
                margin: 0;
                padding: 20px;
            }

            .no-print {
                display: none !important;
            }

            .btn {
                display: none;
            }

            body {
                background: white;
            }

            @page {
                margin: 0.5cm;
            }

            .items-table th {
                background-color: #f8f9fa !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
        }

        /* תגובתיות */
        @media screen and (max-width: 768px) {
            .invoice-container {
                padding: 15px;
                margin: 10px;
            }

            .billing-section {
                flex-direction: column;
                gap: 15px;
            }

            .items-table {
                display: block;
                overflow-x: auto;
            }

            .invoice-header {
                flex-direction: column;
                gap: 15px;
            }

            .invoice-actions {
                width: 100%;
            }
        }

        /* אנימציות */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .items-table tr {
            animation: fadeIn 0.3s ease-out;
        }

        /* תוספות שימושיות */
        .text-danger {
            color: #dc3545;
        }

        .text-success {
            color: #28a745;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-control {
            display: block;
            width: 100%;
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

            .form-control:focus {
                color: #495057;
                background-color: #fff;
                border-color: #80bdff;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
            }

        /* מצבי שגיאה בטופס */
        .is-invalid {
            border-color: #dc3545;
        }

            .is-invalid:focus {
                border-color: #dc3545;
                box-shadow: 0 0 0 0.2rem rgba(220,53,69,.25);
            }

        .invalid-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 80%;
            color: #dc3545;
        }

        .is-invalid ~ .invalid-feedback {
            display: block;
        }
    </style>--%>

    <style>
        :root {
    --purple-50: rgba(124, 58, 237, 0.05);
    --purple-100: rgba(124, 58, 237, 0.1);
    --purple-500: #7c3aed;
    --purple-600: #6d28d9;
    --purple-700: #5b21b6;
    --text-primary: #1f2937;
    --text-secondary: #6b7280;
}

.invoice-container {
    background: white;
    padding: 2rem;
    margin: 1.5rem auto;
    max-width: 1000px;
    box-shadow: 0 4px 20px rgba(124, 58, 237, 0.08);
    border-radius: 16px;
    direction: rtl;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    transition: all 0.3s ease;
}

.invoice-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 2rem;
    padding-bottom: 1.5rem;
    border-bottom: 2px solid var(--purple-50);
}

.quote-info h2 {
    margin: 0 0 1rem 0;
    color: var(--purple-700);
    font-size: 1.5rem;
    font-weight: 600;
}

.info-item {
    margin-bottom: 0.75rem;
    color: var(--text-secondary);
}

.info-item .label {
    font-weight: 500;
    margin-left: 0.5rem;
    color: var(--text-primary);
}

.items-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    margin: 1.5rem 0;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(124, 58, 237, 0.06);
}

.items-table th {
    background: var(--purple-50);
    padding: 1rem;
    text-align: right;
    font-weight: 600;
    color: var(--purple-700);
    border: none;
}

.items-table td {
    padding: 1rem;
    border-bottom: 1px solid var(--purple-50);
    vertical-align: middle;
}

.items-table input {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 0.95rem;
    transition: all 0.3s ease;
}

.items-table input:focus {
    outline: none;
    border-color: var(--purple-500);
    box-shadow: 0 0 0 3px var(--purple-50);
}

.btn {
    padding: 0.75rem 1.5rem;
    border-radius: 10px;
    border: none;
    font-size: 0.95rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-primary {
    background: var(--purple-500);
    color: white;
}

.btn-primary:hover {
    background: var(--purple-600);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(124, 58, 237, 0.2);
}

.btn-secondary {
    background: var(--purple-50);
    color: var(--purple-500);
}

.btn-secondary:hover {
    background: var(--purple-100);
    transform: translateY(-2px);
}

.btn-danger {
    background: #fee2e2;
    color: #dc2626;
}

.btn-danger:hover {
    background: #fecaca;
    transform: translateY(-2px);
}

.form-control {
    display: block;
    width: 100%;
    padding: 0.75rem 1rem;
    font-size: 0.95rem;
    line-height: 1.5;
    color: var(--text-primary);
    background: white;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    transition: all 0.3s ease;
}

.form-control:focus {
    border-color: var(--purple-500);
    box-shadow: 0 0 0 3px var(--purple-50);
    outline: none;
}

.summary-row td {
    padding: 1rem;
    color: var(--text-primary);
}

.total td {
    font-weight: 600;
    font-size: 1.1rem;
    border-top: 2px solid var(--purple-50);
    color: var(--purple-700);
}

/* אנימציות */
.items-table tr {
    animation: slideIn 0.3s ease-out forwards;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* מצבי שגיאה */
.is-invalid {
    border-color: #ef4444;
}

.is-invalid:focus {
    border-color: #ef4444;
    box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

.invalid-feedback {
    color: #ef4444;
    font-size: 0.875rem;
    margin-top: 0.5rem;
}

@media screen and (max-width: 768px) {
    .invoice-container {
        margin: 0.5rem;
        padding: 1rem;
        border-radius: 12px;
    }
    
    .invoice-header {
        flex-direction: column;
        gap: 1rem;
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
    <script>
        function collectItems() {
            const items = [];
            document.querySelectorAll("#itemsTableBody tr").forEach(row => {
                const description = row.querySelector(".item-description").value.trim();
                const quantity = parseInt(row.querySelector(".item-quantity").value, 10);
                const unitPrice = parseFloat(row.querySelector(".item-price").value);
                if (description && quantity > 0 && unitPrice >= 0) {
                    items.push({ description, quantity, unitPrice });
                }
            });
            return items;
        }
        function saveBid() {
            const items = collectItems();
            const bidData = {
                readId: document.getElementById("hiddenReadId").value,
                technicianId: document.getElementById("hiddenTechnicianId").value,
                description: document.getElementById("txtDesc").value.trim(),
                totalPrice: parseFloat(document.getElementById("txtTotalPrice").value),
                items: items
            };

            fetch("AllBids.aspx/SaveBid", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(bidData)
            })
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        alert("הצעת המחיר נשמרה בהצלחה!");
                        window.location.reload();
                    } else {
                        alert("שגיאה בשמירת הצעת המחיר: " + result.error);
                    }
                })
                .catch(error => console.error("Error:", error));
        }


        // מערך לשמירת הפריטים
        let items = [];

        // פונקציה להוספת פריט חדש
        function addNewItem() {
            const template = document.getElementById('itemRowTemplate');
            const tbody = document.getElementById('itemsTableBody');
            const clone = document.importNode(template.content, true);

            // הוספת מאזינים לאירועים
            const inputs = clone.querySelectorAll('input');
            inputs.forEach(input => {
                input.addEventListener('input', () => {
                    calculateRowTotal(input.closest('tr'));
                    updateTotals();
                });
            });

            tbody.appendChild(clone);
            updateTotals();
        }

       <%-- // חישוב סכום שורה
        function calculateRowTotal(row) {
            const quantity = parseFloat(row.querySelector('.item-quantity').value) || 0;
            const price = parseFloat(row.querySelector('.item-price').value) || 0;
            const subtotal = quantity * price;  // סכום לפני מע"מ
            row.querySelector('.item-total').textContent = `₪${subtotal.toFixed(2)}`;
            return subtotal;
        }

        // עדכון סיכומים
        function updateTotals() {
            const rows = document.querySelectorAll('#itemsTableBody tr');
            let subtotal = 0;

            // חישוב סה"כ לפני מע"מ
            rows.forEach(row => {
                subtotal += calculateRowTotal(row);
            });

            // חישוב מע"מ וסה"כ
            const vat = subtotal * 0.17;  // 17% מע"מ
            const total = subtotal + vat;  // סה"כ כולל מע"מ

            // עדכון התצוגה עם שתי ספרות אחרי הנקודה
            document.getElementById('subtotal').textContent = `₪${subtotal.toFixed(2)}`;
            document.getElementById('vat').textContent = `₪${vat.toFixed(2)}`;
            document.getElementById('total').textContent = `₪${total.toFixed(2)}`;

            // שמירת הסכום הכולל בשדה המחיר
            $(`#<%= txtTotalPrice.ClientID %>`).val(Math.round(total));
            console.log('Total price set to txtTotalPrice:', total.toFixed(2));

            // החזרת כל הערכים למקרה שנצטרך אותם
            return {
                subtotal: subtotal,
                vat: vat,
                total: total
            };
        }--%>

        // חישוב סכום שורה
        function calculateRowTotal(row) {
            const quantity = parseFloat(row.querySelector('.item-quantity').value) || 0;
            const priceBeforeVat = parseFloat(row.querySelector('.item-price').value) || 0;  // מחיר ליחידה לפני מע"מ
            const rowTotalBeforeVat = quantity * priceBeforeVat;  // סה"כ לשורה לפני מע"מ
            row.querySelector('.item-total').textContent = `₪${rowTotalBeforeVat.toFixed(2)}`;
            return rowTotalBeforeVat;
        }

        // עדכון סיכומים
        function updateTotals() {
            const rows = document.querySelectorAll('#itemsTableBody tr');
            let subtotalBeforeVat = 0;

            // חישוב סה"כ לפני מע"מ
            rows.forEach(row => {
                subtotalBeforeVat += calculateRowTotal(row);
            });

            // חישובי המע"מ והסה"כ
            const vat = subtotalBeforeVat * 0.17;  // 17% מע"מ
            const totalWithVat = subtotalBeforeVat + vat;  // סה"כ כולל מע"מ

            // עדכון התצוגה עם שתי ספרות אחרי הנקודה
            document.getElementById('subtotal').textContent = `₪${subtotalBeforeVat.toFixed(2)}`;  // לפני מע"מ
            document.getElementById('vat').textContent = `₪${vat.toFixed(2)}`;  // המע"מ עצמו
            document.getElementById('total').textContent = `₪${totalWithVat.toFixed(2)}`;  // סה"כ כולל מע"מ

            // שמירת הסכום הכולל בשדה המחיר
            $(`#<%= txtTotalPrice.ClientID %>`).val(Math.round(totalWithVat));

    console.log('Price details:', {
        subtotalBeforeVat: subtotalBeforeVat.toFixed(2),
        vat: vat.toFixed(2),
        totalWithVat: totalWithVat.toFixed(2)
    });
}

        // מחיקת פריט
        function deleteItem(button) {
            const row = button.closest('tr');
            row.remove();
            updateTotals();
        }

        <%--function loadQuoteFromRead(readId) {
            console.log('Loading quote for ReadId:', readId);

            $.ajax({
                type: "POST",
                url: "AllRead.aspx/GetCallInfoJson",
                data: JSON.stringify({ readId: readId.toString() }), // חשוב: המרה למחרוזת
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('Server response:', response);

                    if (!response.d || response.d === "null") {
                        console.error('No data found for readId:', readId);
                        alert("לא נמצאו נתונים עבור קריאה זו");
                        return;
                    }

                    try {
                        // המרה ל-JSON
                        const data = JSON.parse(response.d);
                        console.log('Parsed data:', data);

                        // מילוי הטופס
                        $('#<%= txtCustomerName.ClientID %>').val(data.FullName);
                $('#<%= txtPhone.ClientID %>').val(data.Phone);
                $('#<%= txtDescription.ClientID %>').val(data.Desc);
                $('#<%= hiddenReadId.ClientID %>').val(data.ReadId);

                // עדכון כותרות
                $('#quoteNumber').text(`Q-${data.ReadId}-${new Date().getTime().toString().slice(-4)}`);
                $('#currentDate').text(new Date().toLocaleDateString('he-IL'));
                $('#serviceCallId').text(data.ReadId);

                // הוספת שורת פריט ראשונה
                addNewItem();

                console.log('Form filled successfully');
            } catch (error) {
                console.error('Error parsing or filling data:', error);
                alert("אירעה שגיאה בעיבוד הנתונים");
            }
        },
        error: function (xhr, status, error) {
            console.error('AJAX Error:', error);
            console.error('Status:', status);
            console.error('Response Text:', xhr.responseText);
            alert("אירעה שגיאה בטעינת הנתונים");
        }
    });
        }--%>

        // הגדרת משתנים גלובליים עם ה-ClientID של השדות
        var txtCustomerName = { clientID: '<%= txtCustomerName.ClientID %>' };
        var txtPhone = { clientID: '<%= txtPhone.ClientID %>' };
        var txtDesc = { clientID: '<%= txtDesc.ClientID %>' };
        var hiddenReadId = { clientID: '<%= hiddenReadId.ClientID %>' };

        // Debug log
        console.log('Form field IDs:', {
            customerName: txtCustomerName.clientID,
            phone: txtPhone.clientID,
            desc: txtDesc.clientID,
            hiddenReadId: hiddenReadId.clientID
        });

        function loadQuoteFromRead(readId) {
            console.log('loadQuoteFromRead called with readId:', readId);

            if (!readId) {
                console.error('readId is required');
                return;
            }

            // בדיקת זיהויי השדות
            console.log('Form control IDs:', formControls);

            // טעינת פרטי הטכנאי
            loadTechnicianInfo();

            $.ajax({
                type: "POST",
                url: "AllRead.aspx/GetCallInfoJson",
                data: JSON.stringify({ readId: readId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('Server response:', response);

                    if (!response || !response.d) {
                        console.error('Invalid response:', response);
                        return;
                    }

                    try {
                        const data = JSON.parse(response.d);
                        console.log('Parsed data:', data);

                        // מילוי הטופס עם בדיקות מפורטות
                        if (document.getElementById(formControls.customerName)) {
                            document.getElementById(formControls.customerName).value = data.FullName;
                            console.log('Set customer name:', data.FullName);
                        } else {
                            console.error('Customer name control not found');
                        }

                        if (document.getElementById(formControls.phone)) {
                            document.getElementById(formControls.phone).value = data.Phone;
                            console.log('Set phone:', data.Phone);
                        } else {
                            console.error('Phone control not found');
                        }

                        if (document.getElementById(formControls.desc)) {
                            document.getElementById(formControls.desc).value = data.Desc;
                            console.log('Set desc:', data.Desc);
                        } else {
                            console.error('Desc control not found');
                        }

                        if (document.getElementById(formControls.hiddenReadId)) {
                            document.getElementById(formControls.hiddenReadId).value = data.ReadId;
                            console.log('Set hidden ReadId:', data.ReadId);
                        } else {
                            console.error('Hidden ReadId control not found');
                        }

                        // עדכון המספרים וכותרות
                        document.getElementById('quoteNumber').textContent = `Q-${data.ReadId}-${new Date().getTime().toString().slice(-4)}`;
                        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('he-IL');
                        document.getElementById('serviceCallId').textContent = data.ReadId;


                        // הוספת שורת פריט ראשונה
                        addNewItem();

                        console.log('Form filled successfully');

                    } catch (error) {
                        console.error('Error parsing or filling form:', error);
                        console.error('Error details:', error.message);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX call failed');
                    console.error('Status:', status);
                    console.error('Error:', error);
                    console.error('Response:', xhr.responseText);
                }
            });
        }
        function loadTechnicianInfo() {
            $.ajax({
                type: "POST",
                url: "AllBids.aspx/GetTechnicianInfoJson",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (!response || !response.d) {
                        console.error('Invalid response:', response);
                        alert('שגיאה בטעינת פרטי טכנאי');
                        return;
                    }

                    try {
                        const data = JSON.parse(response.d);

                        if (data.error) {
                            console.error('Server error:', data.error);
                            alert('שגיאה: ' + data.error);
                            return;
                        }

                        // עדכון פרטי הטכנאי בטופס
                        document.getElementById('techNumber').textContent = data.TecId;
                        document.getElementById('techName').textContent = data.FulName;
                        document.getElementById('techPhone').textContent = data.Phone;

                    } catch (error) {
                        console.error('Error parsing technician data:', error);
                        alert('שגיאה בעיבוד פרטי הטכנאי');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX error:', error);
                    alert('שגיאה בטעינת פרטי הטכנאי');
                }
            });
        }

        //// הפעלת הקוד כשהדף נטען
        //$(document).ready(function () {
        //    console.log('Document ready');
        //    const urlParams = new URLSearchParams(window.location.search);
        //    const readId = urlParams.get('readId');

        //    if (readId) {
        //        console.log('Found readId in URL:', readId);
        //        loadQuoteFromRead(readId);
        //    } else {
        //        console.log('No readId found in URL');
        //    }
        //});

        // חשוב: וודא שהקוד רץ אחרי טעינת הדף
        //$(document).ready(function () {
        //    console.log('Document ready');
        //    const urlParams = new URLSearchParams(window.location.search);
        //    const readId = urlParams.get('readId');

        //    if (readId) {
        //        console.log('Found readId in URL:', readId);
        //        loadQuoteFromRead(readId);
        //    } else {
        //        console.log('No readId found in URL');
        //    }
        //});

        // להוסיף את זה בתחתית הקובץ או ב-document.ready
        //$(document).ready(function () {
        //    const urlParams = new URLSearchParams(window.location.search);
        //    const readId = urlParams.get('readId');

        //    if (readId) {
        //        console.log('Found readId in URL:', readId);
        //        loadQuoteFromRead(readId);
        //    }
        //});

        // הוספת האזנה לטעינת העמוד
        //$(document).ready(function () {
        //    const urlParams = new URLSearchParams(window.location.search);
        //    const readId = urlParams.get('readId');

        //    if (readId) {
        //        loadQuoteFromRead(readId);
        //    }
        //});

        // פונקציה לקבלת מזהה הטכנאי מה-Session
        function getTechnicianId() {
            // נוסיף נקודת קצה ב-Web API שתחזיר את מזהה הטכנאי מה-Session
            return $.ajax({
                type: "GET",
                url: "/api/Technician/GetCurrentTechnicianId",
                async: false
            }).responseText;
        }
        // פונקציה לאיסוף נתוני ההצעה
        function collectQuoteData() {
            const rows = document.querySelectorAll('#itemsTableBody tr');
            const items = [];

            rows.forEach(row => {
                items.push({
                    desc: row.querySelector('.item-desc').value,
                    quantity: parseFloat(row.querySelector('.item-quantity').value),
                    price: parseFloat(row.querySelector('.item-price').value),
                    total: parseFloat(row.querySelector('.item-total').textContent.replace('₪', ''))
                });
            });

            return {
                quoteNumber: document.getElementById('quoteNumber').textContent,
                date: document.getElementById('currentDate').textContent,
                serviceCallId: document.getElementById('serviceCallId').textContent,
                items: items,
                subtotal: parseFloat(document.getElementById('subtotal').textContent.replace('₪', '')),
                vat: parseFloat(document.getElementById('vat').textContent.replace('₪', '')),
                total: parseFloat(document.getElementById('total').textContent.replace('₪', ''))
            };
        }

        // האזנה לטעינת העמוד
        document.addEventListener('DOMContentLoaded', () => {
            // כאן תוכל להוסיף קריאה לשרת לקבלת הנתונים הראשוניים
            // לדוגמה:
            // fetch('/api/quote-data').then(response => response.json()).then(data => initializeQuote(data));
        });
        // פונקציה לאיסוף פריטי ההצעה לפני שליחה
        //function collectBidItem() {
        //    try {
        //        const items = [];
        //        const rows = document.querySelectorAll('#itemsTableBody tr');

        //        rows.forEach(row => {
        //            const itemdescription = row.querySelector('.item-description').value;
        //            const itemquantity = parseFloat(row.querySelector('.item-quantity').value) || 0;
        //            const itemPrice = parseFloat(row.querySelector('.item-price').value) || 0;
        //            const itemTotal = parseFloat(row.querySelector('.item-total').textContent.replace('₪', '')) || 0;

        //            items.push({
        //                description: itemDesc,
        //                quantity: itemQuantity,
        //                price: itemPrice,
        //                total: itemTotal
        //            });
        //        });

        //        // מוסיף את הפריטים כשדה נסתר לטופס
        //        const bidItemJson = JSON.stringify(items);
        //        let hiddenInput = document.getElementById('hiddenBidItems');
        //        if (!hiddenInput) {
        //            hiddenInput = document.createElement('input');
        //            hiddenInput.type = 'hidden';
        //            hiddenInput.id = 'hiddenBidItems';
        //            hiddenInput.name = 'bidItem';
        //            document.forms[0].appendChild(hiddenInput);
        //        }
        //        hiddenInput.value = bidItemJson;

        //        console.log('Collected bid items:', items);
        //        console.log('JSON string:', bidItemJson);

        //        return true;
        //    } catch (e) {
        //        console.error('Error collecting bid items:', e);
        //        alert('אירעה שגיאה באיסוף פרטי ההצעה');
        //        return false;
        //    }
        //}

        function collectBidItem() {
            try {
                const form = document.forms[0];
                const firstRow = document.querySelector('#itemsTableBody tr');

                if (firstRow) {
                    const description = firstRow.querySelector('.item-description').value;
                    const quantity = firstRow.querySelector('.item-quantity').value;
                    const unitPrice = firstRow.querySelector('.item-price').value;

                    // הוספת שדות נסתרים לטופס
                    addHiddenInput('itemDescription', description);
                    addHiddenInput('itemQuantity', quantity);
                    addHiddenInput('itemUnitPrice', unitPrice);
                }
                return true;
            } catch (e) {
                console.error('Error collecting bid items:', e);
                alert('אירעה שגיאה באיסוף פרטי ההצעה');
                return false;
            }
        }

        function addHiddenInput(name, value) {
            let input = document.querySelector(`input[name="${name}"]`);
            if (!input) {
                input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                document.forms[0].appendChild(input);
            }
            input.value = value;
        }

        // עדכון אירוע הלחיצה על כפתור השמירה
        document.querySelector('#<%= btnSave.ClientID %>').addEventListener('click', function (e) {
            if (!validateForm()) {
                e.preventDefault();
                return;
            }

            if (!collectBidItem()) {
                e.preventDefault();
                return;
            }
        });

        function validateForm() {
            const desc = document.getElementById('<%= txtDesc.ClientID %>').value.trim();
            if (!desc) {
                alert('נא להזין תיאור');
                return false;
            }

            const totalPrice = parseFloat(document.getElementById('<%= txtTotalPrice.ClientID %>').value);
            if (isNaN(totalPrice) || totalPrice <= 0) {
                alert('נא להזין סכום כולל תקין');
                return false;
            }

            return true;
        }


        // עדכון כפתור השמירה
        document.querySelector('#<%= btnSave.ClientID %>').addEventListener('click', function (e) {
            if (!collectBidItem()) {
                e.preventDefault();  // מונע את שליחת הטופס אם יש שגיאה
                return;
            }

            // מוודא שיש מחיר כולל
            const totalPrice = document.querySelector('#<%= txtTotalPrice.ClientID %>').value;
            if (!totalPrice || totalPrice <= 0) {
                alert('נא להזין סכום כולל תקין');
                e.preventDefault();
                return;
            }

            // אם הכל בסדר, הטופס יישלח
        });

        // עדכון כפתור השמירה כך שיאסוף את הפריטים לפני השליחה
        document.querySelector('#<%= btnSave.ClientID %>').addEventListener('click', function (e) {

            collectBidItem();
            __doPostBack('<%= btnSave.UniqueID %>', '');
        });


    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        // הגדר משתנים גלובליים לשימוש בקוד JavaScript
        var formControls = {
            customerName: '<%= txtCustomerName.ClientID %>',
            phone: '<%= txtPhone.ClientID %>',
            desc: '<%= txtDesc.ClientID %>',
            hiddenReadId: '<%= hiddenReadId.ClientID %>'
        };
        document.getElementById('<%= btnSave.ClientID %>').addEventListener('click', function (e) {
            const txtDesc = document.getElementById('<%= txtDesc.ClientID %>');
            const errorSpan = document.getElementById('errorTxtDesc');

            if (!txtDesc.value.trim()) {
                e.preventDefault(); // עצירת השליחה
                errorSpan.style.display = 'block'; // הצגת שגיאה
            } else {
                errorSpan.style.display = 'none'; // הסתרת שגיאה
            }
        });

    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
