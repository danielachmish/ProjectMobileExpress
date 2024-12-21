<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="AllBids.aspx.cs" Inherits="MobileExpress.TechniciansFolder.AllBids" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/2.9.3/umd/popper.min.js"></script>

    <!-- הוסף גם את ה-CSS הנדרש -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- שדות מוסתרים בלבד בראש הדף -->
    <asp:HiddenField ID="hiddenReadId" runat="server" />
    <asp:HiddenField ID="hiddenCustomerId" runat="server" />
    <asp:HiddenField ID="hiddenTechnicianId" runat="server" />


    <div class="invoice-container">
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

            <%-- <div class="invoice-actions">
                <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-primary" Text="הדפס הצעת מחיר" OnClientClick="window.print(); return false;" />
            </div>--%>
            <div class="invoice-actions">
                <asp:Button ID="btnPrint" runat="server" CssClass="btn btn-primary" Text="הדפס הצעת מחיר" OnClientClick="window.print(); return false;" />
            </div>
        </div>

        <!-- טופס פרטים -->
       <%-- <div class="form-group">
            <label for="txtCustomerName">שם לקוח:</label>
            <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>--%>
        <div class="form-group">
    <label for="txtCustomerName">שם לקוח:</label>
    <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" ReadOnly="false" />
</div>
        <div class="form-group">
            <label for="txtPhone">טלפון:</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>

        <div class="form-group">
            <label for="txtmodelcode">דגם:</label>
            <asp:TextBox ID="txtmodelcode" runat="server" CssClass="form-control" ReadOnly="false" />
            <span class="text-danger" id="errorTxtModelCode" style="display: none;">השדה חובה</span>
        </div>
        <div class="form-group">
            <label for="txtDesc">תיאור התקלה:</label>
            <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" ReadOnly="false" />
            <span class="text-danger" id="errorTxtDesc" style="display: none;">השדה חובה</span>
        </div>

        <%--  <div class="form-group">
            <label for="txtTotalPrice">סכום כולל:</label>
            <asp:TextBox ID="txtTotalPrice" runat="server" CssClass="form-control" step="0.01" min="0" />
        </div>--%>
        <div class="form-group d-none">
            <label for="txtTotalPrice">סכום כולל:</label>
            <asp:TextBox ID="txtTotalPrice" runat="server" CssClass="form-control" step="0.01" min="0" />
        </div>

        <!-- טבלת פריטים -->
        <table class="items-table">
            <thead>
                <tr>
                    <div class="card-body">

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


        /* הוספת כיווניות RTL לכל הקונטיינר */
        .invoice-container {
            background: white;
            padding: 2rem;
            margin: 1.5rem auto;
            max-width: 1000px;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.08);
            border-radius: 16px;
            direction: rtl;
            text-align: right;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            transition: all 0.3s ease;
        }

        /* עדכון טבלת פריטים */
        .items-table th {
            text-align: right;
        }

        .items-table td {
            text-align: right;
        }

        /* עדכון תצוגת שדות */
        .form-group {
            text-align: right;
            margin-bottom: 1rem;
        }

            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
            }

        /* עדכון כפתורים */
        .invoice-actions {
            text-align: left;
        }

        /* עדכון סיכומים */
        .summary-row td.text-left,
        .total td.text-left {
            text-align: right;
        }

        /* עדכון פרטי הצעת מחיר */
        .quote-info {
            text-align: right;
        }

        .info-item .label {
            margin-left: 0.5rem;
            margin-right: 0;
        }

        /* התאמה למובייל */
        @media screen and (max-width: 768px) {
            .invoice-header {
                text-align: right;
            }

            .quote-info {
                width: 100%;
            }
        }

        /* עדכון כיוון לאייקונים */
        .btn-danger i,
        .btn i {
            margin-left: 0.5rem;
            margin-right: 0;
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

        .form-actions {
            text-align: left;
            margin-top: 2rem;
        }

            .form-actions .btn {
                margin-left: 1rem;
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

        // הגדר משתנים גלובליים לשימוש בקוד JavaScript
        var formControls = {
            customerName: '<%= txtCustomerName.ClientID %>',
            phone: '<%= txtPhone.ClientID %>',
            desc: '<%= txtDesc.ClientID %>',
            hiddenReadId: '<%= hiddenReadId.ClientID %>',
            modelcode: '<%= txtmodelcode.ClientID %>'
        };

        document.getElementById('<%= btnSave.ClientID %>').addEventListener('click', function (e) {
            const txtDesc = document.getElementById('<%= txtDesc.ClientID %>');
            const errorSpan = document.getElementById('errorTxtDesc');
            const txtCustomerName = document.getElementById('<%= txtCustomerName.ClientID %>');
            const modelcode = document.getElementById('txtmodelcode');
            if (!txtDesc.value.trim()) {
                e.preventDefault(); // עצירת השליחה
                errorSpan.style.display = 'block'; // הצגת שגיאה
            } else {
                errorSpan.style.display = 'none'; // הסתרת שגיאה
            }
        });



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
                FullName: document.getElementById("txtCustomerName").value.trim(),
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
            hiddenReadId: hiddenReadId.clientID,

        });



        $(document).ready(function () {
            const urlParams = new URLSearchParams(window.location.search);
            const readId = urlParams.get('readId');

            if (readId) {
                loadQuoteFromRead(readId);
            }
        });

        function loadQuoteFromRead(readId) {
            console.log('Loading quote for readId:', readId);

            if (!readId) {
                console.error('readId is required');
                return;
            }

            // טעינת פרטי הטכנאי
            loadTechnicianInfo();

            $.ajax({
                type: "POST",
                url: "AllBids.aspx/GetCallInfoJson",
                data: JSON.stringify({ readId: readId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    try {
                        const data = JSON.parse(response.d);
                        console.log('Raw response:', response);
                        console.log('Parsed data:', data);
                        console.log('ModelCode:', data.ModelCode);
                        console.log('formControls:', formControls);

                        // מילוי השדות בטופס
                        $('#' + txtCustomerName.clientID).val(data.FullName);
                        $('#' + txtPhone.clientID).val(data.Phone);
                        $('#' + txtDesc.clientID).val(data.Desc);
                        $('#' + hiddenReadId.clientID).val(data.ReadId);
                        $('#' + formControls.modelcode).val(data.ModelCode);

                        // עדכון כותרות
                        $('#quoteNumber').text(`Q-${data.ReadId}-${new Date().getTime().toString().slice(-4)}`);
                        $('#currentDate').text(new Date().toLocaleDateString('he-IL'));
                        $('#serviceCallId').text(data.ReadId);

                        const tbody = document.getElementById('itemsTableBody');
                        if (tbody.children.length === 0) {
                            addNewItem();
                        }
                        console.log('Form populated successfully');
                    } catch (error) {
                        console.error('Error parsing or filling form:', error);
                        alert('אירעה שגיאה בטעינת הנתונים');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Ajax Error:', error);
                    alert('אירעה שגיאה בטעינת הנתונים');
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


        function collectBidItem() {
            try {
                const form = document.forms[0];
                const firstRow = document.querySelector('#itemsTableBody tr');

                if (firstRow) {
                    const description = firstRow.querySelector('.item-description').value;
                    const quantity = firstRow.querySelector('.item-quantity').value;
                    const unitPrice = firstRow.querySelector('.item-price').value;

                    // הוספת שם הלקוח
                    const customerName = document.getElementById('<%= txtCustomerName.ClientID %>').value;
                    addHiddenInput('FullName', customerName);
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


        document.getElementById('<%= btnSave.ClientID %>').addEventListener('click', function (e) {
            // בדיקת תיאור
            const txtDesc = document.getElementById('<%= txtDesc.ClientID %>');
            const errorSpan = document.getElementById('errorTxtDesc');

            if (!txtDesc.value.trim()) {
                e.preventDefault();
                errorSpan.style.display = 'block';
                return;
            }
            errorSpan.style.display = 'none';

            // בדיקת תקינות הטופס
            if (!validateForm()) {
                e.preventDefault();
                return;
            }

            // איסוף הפריטים
            if (!collectBidItem()) {
                e.preventDefault();
                return;
            }

            __doPostBack('<%= btnSave.UniqueID %>', '');
        });

    


    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
