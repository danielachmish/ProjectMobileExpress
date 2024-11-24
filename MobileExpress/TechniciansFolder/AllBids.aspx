<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="AllBids.aspx.cs" Inherits="MobileExpress.TechniciansFolder.AllBids" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        <div class="form-group">
            <label for="txtTechnicianName">שם טכנאי:</label>
            <asp:TextBox ID="txtTechnicianName" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>
        <div class="form-group">
            <label for="txtDescription">תיאור התקלה:</label>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>
        <div class="form-group">
            <label for="txtTotalPrice">סכום כולל:</label>
            <asp:TextBox ID="txtTotalPrice" runat="server" CssClass="form-control" ReadOnly="true" />
        </div>

        <!-- טבלת פריטים -->
        <table class="items-table">
            <thead>
                <tr>
                    <th>תיאור</th>
                    <th>כמות</th>
                    <th>מחיר ליחידה</th>
                    <th>סה"כ</th>
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
                <input type="text" class="form-control item-description" required /></td>
            <td>
                <input type="number" class="form-control item-quantity" min="1" value="1" required /></td>
            <td>
                <input type="number" class="form-control item-price" min="0" step="0.01" required /></td>
            <td class="item-total">₪0.00</td>
            <td class="no-print">
                <button type="button" class="btn btn-danger btn-sm delete-item" onclick="deleteItem(this)">מחק</button>
            </td>
        </tr>
    </template>
    <style>
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
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <script>
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
            const price = parseFloat(row.querySelector('.item-price').value) || 0;
            const total = quantity * price;
            row.querySelector('.item-total').textContent = `₪${total.toFixed(2)}`;
            return total;
        }

        // עדכון סיכומים
        function updateTotals() {
            const rows = document.querySelectorAll('#itemsTableBody tr');
            let subtotal = 0;

            rows.forEach(row => {
                subtotal += calculateRowTotal(row);
            });

            const vat = subtotal * 0.17;
            const total = subtotal + vat;

            document.getElementById('subtotal').textContent = `₪${subtotal.toFixed(2)}`;
            document.getElementById('vat').textContent = `₪${vat.toFixed(2)}`;
            document.getElementById('total').textContent = `₪${total.toFixed(2)}`;
            $(`#<%= txtTotalPrice.ClientID %>`).val(Math.round(total));
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
        var txtDescription = { clientID: '<%= txtDescription.ClientID %>' };
        var hiddenReadId = { clientID: '<%= hiddenReadId.ClientID %>' };

        // Debug log
        console.log('Form field IDs:', {
            customerName: txtCustomerName.clientID,
            phone: txtPhone.clientID,
            description: txtDescription.clientID,
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

                        if (document.getElementById(formControls.description)) {
                            document.getElementById(formControls.description).value = data.Desc;
                            console.log('Set description:', data.Desc);
                        } else {
                            console.error('Description control not found');
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

        // הפעלת הקוד כשהדף נטען
        $(document).ready(function () {
            console.log('Document ready');
            const urlParams = new URLSearchParams(window.location.search);
            const readId = urlParams.get('readId');

            if (readId) {
                console.log('Found readId in URL:', readId);
                loadQuoteFromRead(readId);
            } else {
                console.log('No readId found in URL');
            }
        });

        // חשוב: וודא שהקוד רץ אחרי טעינת הדף
        $(document).ready(function () {
            console.log('Document ready');
            const urlParams = new URLSearchParams(window.location.search);
            const readId = urlParams.get('readId');

            if (readId) {
                console.log('Found readId in URL:', readId);
                loadQuoteFromRead(readId);
            } else {
                console.log('No readId found in URL');
            }
        });

        // להוסיף את זה בתחתית הקובץ או ב-document.ready
        $(document).ready(function () {
            const urlParams = new URLSearchParams(window.location.search);
            const readId = urlParams.get('readId');

            if (readId) {
                console.log('Found readId in URL:', readId);
                loadQuoteFromRead(readId);
            }
        });

        // הוספת האזנה לטעינת העמוד
        $(document).ready(function () {
            const urlParams = new URLSearchParams(window.location.search);
            const readId = urlParams.get('readId');

            if (readId) {
                loadQuoteFromRead(readId);
            }
        });

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
                    description: row.querySelector('.item-description').value,
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
        function collectBidItems() {
            const items = [];
            const rows = document.querySelectorAll('#itemsTableBody tr');

            rows.forEach(row => {
                const quantity = parseInt(row.querySelector('.item-quantity').value) || 0;
                const price = parseFloat(row.querySelector('.item-price').value) || 0;
                const total = quantity * price;

                items.push({
                    description: row.querySelector('.item-description').value,
                    quantity: quantity,
                    price: price,
                    total: total
                });
            });

            // הוספת שדה נסתר לטופס עם נתוני הפריטים
            const hiddenField = document.createElement('input');
            hiddenField.type = 'hidden';
            hiddenField.name = 'bidItems';
            hiddenField.value = JSON.stringify(items);
            document.forms[0].appendChild(hiddenField);
        }

        // עדכון כפתור השמירה כך שיאסוף את הפריטים לפני השליחה
        document.querySelector('#<%= btnSave.ClientID %>').addEventListener('click', function (e) {
            e.preventDefault();
            collectBidItems();
            __doPostBack('<%= btnSave.UniqueID %>', '');
        });


    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        // הגדר משתנים גלובליים לשימוש בקוד JavaScript
        var formControls = {
            customerName: '<%= txtCustomerName.ClientID %>',
            phone: '<%= txtPhone.ClientID %>',
            description: '<%= txtDescription.ClientID %>',
            hiddenReadId: '<%= hiddenReadId.ClientID %>'
        };
    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
