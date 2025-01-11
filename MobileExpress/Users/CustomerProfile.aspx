<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="CustomerProfile.aspx.cs" Inherits="MobileExpress.Users.CustomerProfile" %>

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
  <%--  <meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="edit-page-container">
        <!-- Header -->
        <div class="page-header">
            <div class="header-title">
                <h2 class="profile-title">עריכת פרופיל</h2>
            </div>
            <div class="header-controls">
                <button type="button" class="save-changes-btn" onclick="saveChanges(); return false;">
                    <i class="fas fa-save"></i>
                    <span>שמור שינויים</span>
                </button>
            </div>
        </div>

        <!-- Customer Details Form -->
        <div class="details-card">
            <div class="personal-details">
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">מזהה לקוח:</span>

                        <input type="text" class="edit-input" id="CusId" runat="server" disabled>
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">שם מלא:</span>
                        <input type="text" class="edit-input" id="FullName" runat="server">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">טלפון:</span>
                        <input type="tel" class="edit-input" id="Phone" runat="server">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">כתובת:</span>
                        <input type="text" class="edit-input" id="Addres" runat="server">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">סיסמה:</span>
                        <input type="pass" class="edit-input" id="Pass" runat="server">
                    </div>
                </div>
                <%--<div class="info-row">
                <div class="field-content">
                    <span class="info-label">תאריך הוספה:</span>
                    <input type="date" class="edit-input" id="DateAdd" runat="server" disabled>
                </div>
            </div>--%>
                <%--  <div class="info-row">
                <div class="field-content">
                    <span class="info-label">סטטוס:</span>
                    <select class="edit-input" id="Status" runat="server">
                        <option value="פעיל">פעיל</option>
                        <option value="לא פעיל">לא פעיל</option>
                    </select>
                </div>
            </div>--%>
                <%--<div class="info-row">
                <div class="field-content">
                    <span class="info-label">היסטוריה:</span>
                    <textarea class="edit-input" id="History" runat="server" rows="3"></textarea>
                </div>
            </div>--%>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">הערות:</span>
                        <textarea class="edit-input" id="Nots" runat="server" rows="3"></textarea>
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">מזהה עיר:</span>
                        <input type="text" class="edit-input" id="CityId" runat="server">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">מייל:</span>
                        <input type="email" class="edit-input" id="Email" runat="server">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
       /* .edit-page-container {
            padding: 25px;
            direction: rtl;
            max-width: 800px;
            margin: 0 auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #eef2f7;
        }

        .profile-title {
            font-size: 1.5rem;
            color: #2d3748;
            margin: 0;
        }

        .save-changes-btn {
            background-color: #4299e1;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .save-changes-btn:hover {
                background-color: #3182ce;
            }

        .details-card {
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .info-row {
            margin-bottom: 20px;
        }

        .field-content {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .info-label {
            min-width: 120px;
            font-weight: 600;
            color: #4a5568;
        }

        .edit-input {
            flex: 1;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

            .edit-input:disabled {
                background-color: #f7fafc;
                cursor: not-allowed;
            }

            .edit-input:focus {
                outline: none;
                border-color: #4299e1;
                box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
            }

        select.edit-input {
            background-color: white;
            cursor: pointer;
        }

        textarea.edit-input {
            resize: vertical;
            min-height: 80px;
        }*/
       .edit-page-container {
    padding: 2rem;
    direction: rtl;
    max-width: 900px;
    margin: 0 auto;
    background: #f9fafb;
    border-radius: 24px;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
    padding-bottom: 1.5rem;
    border-bottom: 2px solid #e5e7eb;
}

.profile-title {
    font-size: 1.75rem;
    color: #1f2937;
    margin: 0;
    font-weight: 700;
    letter-spacing: -0.5px;
}

.save-changes-btn {
    background: linear-gradient(135deg, #9333ea 0%, #7928ca 100%);
    color: white;
    padding: 0.875rem 1.5rem;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-weight: 600;
    font-size: 0.95rem;
    box-shadow: 0 4px 12px rgba(147, 51, 234, 0.2);
}

.save-changes-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(147, 51, 234, 0.3);
}

.details-card {
    background-color: white;
    padding: 2rem;
    border-radius: 16px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
    border: 1px solid rgba(147, 51, 234, 0.1);
    backdrop-filter: blur(10px);
}

.info-row {
    margin-bottom: 1.5rem;
    padding: 0.5rem 0;
    transition: all 0.3s ease;
}

.info-row:hover {
    background: rgba(147, 51, 234, 0.02);
    border-radius: 12px;
}

.field-content {
    display: flex;
    align-items: center;
    gap: 1.5rem;
}

.info-label {
    min-width: 140px;
    font-weight: 600;
    color: #4b5563;
    font-size: 0.95rem;
}

.edit-input {
    flex: 1;
    padding: 0.875rem 1rem;
    border: 2px solid #e5e7eb;
    border-radius: 12px;
    font-size: 0.95rem;
    transition: all 0.3s ease;
    background: #f9fafb;
}

.edit-input:disabled {
    background-color: #f3f4f6;
    cursor: not-allowed;
    opacity: 0.7;
}

.edit-input:focus {
    outline: none;
    border-color: #9333ea;
    box-shadow: 0 0 0 4px rgba(147, 51, 234, 0.1);
    background: white;
}

select.edit-input {
    background-color: #f9fafb;
    cursor: pointer;
    padding-right: 2rem;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%236b7280'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
    background-position: left 0.75rem center;
    background-repeat: no-repeat;
    background-size: 1rem;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
}

select.edit-input:hover {
    border-color: #9333ea;
}

textarea.edit-input {
    resize: vertical;
    min-height: 100px;
    line-height: 1.5;
    font-family: inherit;
}

textarea.edit-input::-webkit-scrollbar {
    width: 8px;
}

textarea.edit-input::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 4px;
}

textarea.edit-input::-webkit-scrollbar-thumb {
    background: #9333ea;
    border-radius: 4px;
}

textarea.edit-input::-webkit-scrollbar-thumb:hover {
    background: #7928ca;
}
    </style>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
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

    <script>

        // פונקציה לטעינת פרטי הלקוח
    
       <%-- function loadCustomerDetails() {
            const customerId = '<%= Session["CusId"] %>';
            if (!customerId) {
                showError("לא נמצא מזהה לקוח");
                return;
            }
            console.log('Loading customer details for ID:', customerId);
            fetch(`api/customers/${customerId}`)
                .then(response => {
                    if (!response.ok) {
                        /*throw new Error('שגיאה בטעינת פרטי לקוח');*/
                    }
                    return response.json();
                })
                .then(customer => {
                    if (!customer) {
                        throw new Error('לא נמצאו פרטי לקוח');
                    }
                    document.querySelector('[id$="CusId"]').value = customer.CusId;
                    document.querySelector('[id$="FullName"]').value = customer.FullName;
                    document.querySelector('[id$="Phone"]').value = customer.Phone;
                    document.querySelector('[id$="Addres"]').value = customer.Addres;
                    document.querySelector('[id$="Email"]').value = customer.Email;
                    document.querySelector('[id$="Pass"]').value = customer.Pass;
                    document.querySelector('[id$="Nots"]').value = customer.Nots || '';
                })
                .catch(error => {
                    console.error('Error:', error);
                    showError(error.message);
                });
        }--%>
        function loadCustomerDetails() {
            const customerId = '<%= Session["CusId"] %>';

            // בדיקת קיום מזהה לקוח
            if (!customerId) {
                console.log('לא נמצא מזהה לקוח במערכת');
                return;
            }

            console.log('טוען פרטי לקוח עבור ID:', customerId);

            fetch(`api/customers/${customerId}`)
                .then(response => {
                    if (!response.ok) {
                        console.log('שגיאה בטעינת פרטי לקוח:', response.status);
                        return null;
                    }
                    return response.json();
                })
                .then(customer => {
                    if (!customer) {
                        console.log('לא נמצאו פרטי לקוח');
                        return;
                    }

                    try {
                        // מילוי פרטי הלקוח בטופס
                        updateFormFields({
                            "CusId": customer.CusId || '',
                            "FullName": customer.FullName || '',
                            "Phone": customer.Phone || '',
                            "Addres": customer.Addres || '',
                            "Email": customer.Email || '',
                            "Pass": customer.Pass || '',
                            "Nots": customer.Nots || ''
                        });
                    } catch (err) {
                        console.log('שגיאה במילוי פרטי הטופס:', err);
                    }
                })
                .catch(error => {
                    console.log('שגיאה בתהליך טעינת פרטי לקוח:', error);
                });
        }

        // פונקציית עזר למילוי שדות הטופס
        function updateFormFields(fields) {
            for (const [key, value] of Object.entries(fields)) {
                try {
                    const element = document.querySelector(`[id$="${key}"]`);
                    if (element) {
                        element.value = value;
                    }
                } catch (err) {
                    console.log(`שגיאה במילוי שדה ${key}:`, err);
                }
            }
        }
        // קריאה לפונקציה כשהדף נטען
        document.addEventListener('DOMContentLoaded', loadCustomerDetails);

        // פונקציה להוצאת פרמטר מה-URL
        function getCustomerIdFromUrl() {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get('id');
        }

        // טעינת פרטי הלקוח כשהדף נטען
        document.addEventListener('DOMContentLoaded', function () {
            const customerId = getCustomerIdFromUrl();
            if (customerId) {
                loadCustomerDetails(customerId);
            } else {
                showError("לא נמצא מזהה לקוח בכתובת URL");
            }
        });

        function saveChanges() {
            const formData = {
                CusId: parseInt(document.querySelector("[id$='CusId']").value),
                FullName: document.querySelector("[id$='FullName']").value,
                Phone: document.querySelector("[id$='Phone']").value,
                Addres: document.querySelector("[id$='Addres']").value,
                Email: document.querySelector("[id$='Email']").value,
                Pass: document.querySelector("[id$='Pass']").value,
                Nots: document.querySelector("[id$='Nots']").value || '',
                CityId: parseInt(document.querySelector("[id$='CityId']").value) || 1
            };

            showLoading("מעדכן פרטים...");

            // שימוש ב-WebMethod
            $.ajax({
                type: "POST",
                url: "CustomerProfile.aspx/UpdateCustomerProfile",
                data: JSON.stringify({ customerData: formData }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    hideLoading();
                    if (response.d.success) {
                        showSuccess("הפרטים עודכנו בהצלחה!");
                        setTimeout(() => {
                            window.location.href = document.referrer || '/';
                        }, 1500);
                    } else {
                        showError(response.d.message || 'שגיאה בעדכון הפרטים');
                    }
                },
                error: function (error) {
                    hideLoading();
                    console.error('Error:', error);
                    showError("שגיאה בעדכון הפרטים");
                }
            });
        }
        // פונקציות עזר להצגת הודעות
        function showLoading(message) {
            const loadingDiv = document.createElement('div');
            loadingDiv.id = 'loadingMessage';
            loadingDiv.className = 'alert-message loading';
            loadingDiv.textContent = message;
            document.body.appendChild(loadingDiv);
        }

        function hideLoading() {
            const loadingDiv = document.getElementById('loadingMessage');
            if (loadingDiv) {
                loadingDiv.remove();
            }
        }

        function showSuccess(message) {
            const successDiv = document.createElement('div');
            successDiv.className = 'alert-message success';
            successDiv.textContent = message;
            document.body.appendChild(successDiv);
            setTimeout(() => successDiv.remove(), 3000);
        }

        function showError(message) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'alert-message error';
            errorDiv.textContent = message;
            document.body.appendChild(errorDiv);
            setTimeout(() => errorDiv.remove(), 5000);
        }
        // CSS להודעות
        const styles = `
.alert-message {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 15px 25px;
    border-radius: 4px;
    color: white;
    z-index: 1000;
    animation: slideIn 0.5s ease;
}

@keyframes slideIn {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

.loading {
    background-color: #3498db;
}

.success {
    background-color: #2ecc71;
}

.error {
    background-color: #e74c3c;
}
`;

        // הוספת ה-CSS לדף
        const styleSheet = document.createElement("style");
        styleSheet.textContent = styles;
        document.head.appendChild(styleSheet);
    </script>
</asp:Content>
