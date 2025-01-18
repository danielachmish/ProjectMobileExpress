<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="TechnicianProfile.aspx.cs" Inherits="MobileExpress.TechniciansFolder.TechnicianProfile1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="assets/css/styles.css">

    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
    <style>
        .container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .header-title h1 {
            margin: 0;
            color: #333;
        }

        .header-controls {
            display: flex;
            gap: 1rem;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
        }

        .details-card {
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .personal-details .info-row {
            margin-bottom: 1.5rem;
        }

        .field-content {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .info-label {
            min-width: 120px;
            font-weight: 600;
        }

        .edit-input {
            display: none;
            flex: 1;
        }

        .info-value {
            flex: 1;
        }

        /* מצב עריכה */
        .edit-mode .info-value {
            display: none;
        }

        .edit-mode .edit-input {
            display: block;
        }

        /* שעות פעילות */
        .days-grid {
            display: grid;
            gap: 1rem;
        }

        .day-row {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .hours-input {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .time-input {
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        /* סגנונות נוספים מהקוד המקורי */
        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-icon {
            width: 2.5rem;
            height: 2.5rem;
            background: rgba(107, 70, 193, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .stat-value {
            color: #6B46C1;
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .page-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .field-content {
                flex-direction: column;
                align-items: flex-start;
            }

            .info-label {
                min-width: auto;
            }
        }

        /* כללי: סגנון אחיד לפרויקט */
body {
    font-family: 'Assistant', Arial, sans-serif; /* גופן מודרני בעברית */
    background-color: #f4f4f8; /* צבע רקע בהיר */
    color: #333; /* צבע טקסט כהה */
    margin: 0;
    padding: 0;
    line-height: 1.6;
    direction: rtl; /* יישור לימין */
}

h3 {
    font-size: 1.8rem;
    color: #6B46C1; /* צבע סגול לתאימות עם הפרויקט */
    text-align: center;
    margin-bottom: 1rem;
}

button {
    background-color: #6B46C1; /* סגול מודרני */
    color: #fff;
    border: none;
    padding: 10px 20px;
    border-radius: 25px;
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s ease;
}

button:hover {
    background-color: #54329C; /* כהה יותר */
}

/* קונטיינר לניהול שעות פעילות */
#availability-management {
    max-width: 800px;
    margin: 30px auto;
    padding: 20px;
    background: #ffffff; /* לבן */
    border-radius: 15px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* ימים */
#availability-days {
    display: grid;
    grid-template-columns: 1fr 1fr; /* שני עמודות */
    gap: 20px; /* רווח בין הימים */
}

.availability-day {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px;
    background-color: #f9f9fc; /* רקע רך */
    border: 1px solid #ddd; /* גבול קל */
    border-radius: 10px;
    transition: box-shadow 0.3s ease;
}

.availability-day:hover {
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* תוויות */
label {
    font-size: 1.1rem;
    color: #333;
    margin-right: 10px;
}

/* שדות הזמן */
input[type="time"] {
    padding: 8px;
    font-size: 1rem;
    border: 1px solid #ddd;
    border-radius: 10px;
    background-color: #fff;
    color: #333;
    width: 120px; /* רוחב קבוע */
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

input[type="time"]:focus {
    border-color: #6B46C1; /* סגול מותאם */
    box-shadow: 0 0 5px rgba(107, 70, 193, 0.4);
    outline: none;
}

/* כפתור שמירה */
button {
    display: block;
    margin: 20px auto;
    width: 50%;
}

/* התאמה למובייל */
@media (max-width: 768px) {
    #availability-days {
        grid-template-columns: 1fr; /* עמודה אחת */
    }

    button {
        width: 100%; /* התאמת כפתור למובייל */
    }
}

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="hdnTecId" runat="server" />

    <div class="container" dir="rtl">
        <div class="page-header">
            <div class="header-title">
                <h1 class="profile-title">פרופיל טכנאי</h1>
            </div>
            <div class="header-controls">
                <button class="edit-mode-btn btn btn-primary">
                    <i class="fas fa-edit"></i>
                    <span class="btn-text">עריכת פרופיל</span>
                </button>
                <button class="save-changes-btn btn btn-success" style="display: none;">
                    <i class="fas fa-save"></i>
                    <span class="btn-text">שמור שינויים</span>
                </button>
            </div>
        </div>

        <!-- Stats Grid -->
        <%-- <div class="stats-container">
            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>סך הצעות מחיר</h3>
                        <p class="stat-value">
                            <asp:Label ID="lblTotalBids" runat="server"></asp:Label>
                        </p>
                    </div>
                    <div class="stat-icon money-icon">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm.31-8.86c-1.77-.45-2.34-.94-2.34-1.67 0-.84.79-1.43 2.1-1.43 1.38 0 1.9.66 1.94 1.64h1.71c-.05-1.34-.87-2.57-2.49-2.97V5H10.9v1.69c-1.51.32-2.72 1.3-2.72 2.81 0 1.79 1.49 2.69 3.66 3.21 1.95.46 2.34 1.15 2.34 1.87 0 .53-.39 1.39-2.1 1.39-1.6 0-2.23-.72-2.32-1.64H8.04c.1 1.7 1.36 2.66 2.86 2.97V19h2.34v-1.67c1.52-.29 2.72-1.16 2.73-2.77-.01-2.2-1.9-2.96-3.66-3.42z"></path>
                        </svg>
                    </div>
                </div>
                <div class="stat-progress">
                    <div class="progress-bar" style="width: 50%"></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>הכנסה חודשית</h3>
                        <p class="stat-value">₪4,021</p>
                    </div>
                    <div class="stat-icon money-icon">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2"></path>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>דירוג</h3>
                        <p class="stat-value">4.8</p>
                    </div>
                    <div class="stat-icon rating-icon">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                        </svg>
                    </div>
                </div>
            </div>
        </div>--%>

        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>סך קריאות</h3>
                        <p class="stat-value" id="totalCallsValue">0</p>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>קריאות פתוחות</h3>
                        <p class="stat-value" id="openCallsValue">0</p>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>קריאות סגורות</h3>
                        <p class="stat-value" id="closedCallsValue">0</p>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>סך הצעות מחיר</h3>
                        <p class="stat-value" id="lblTotalBids">₪0</p>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>הכנסה חודשית</h3>
                        <p class="stat-value" id="monthlyIncomeValue">₪0</p>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>דירוג ממוצע</h3>
                        <p class="stat-value" id="averageRatingValue">0.0</p>
                    </div>
                </div>
            </div>
        </div>

        
        <!-- Personal Details -->
        <div class="details-card">
            <h2>פרטים אישיים</h2>
            <div class="personal-details">
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">שם מלא:</span>
                        <span class="info-value" runat="server" id="fullNameValue"></span>
                        <input type="text" runat="server" class="edit-input form-control" id="fullNameInput">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">טלפון:</span>
                        <span class="info-value" runat="server" id="phoneValue"></span>
                        <input type="tel" runat="server" class="edit-input form-control" id="phoneInput">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">כתובת:</span>
                        <span class="info-value" runat="server" id="addressValue"></span>
                        <input type="text" runat="server" class="edit-input form-control" id="addressInput">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">התמחות:</span>
                        <span class="info-value" runat="server" id="specializationValue"></span>
                        <input type="text" runat="server" class="edit-input form-control" id="specializationInput">
                    </div>
                </div>
                <div class="info-row">
                    <div class="field-content">
                        <span class="info-label">מייל:</span>
                        <span class="info-value" runat="server" id="EmailValue"></span>
                        <input type="text" runat="server" class="edit-input form-control" id="EmailInpot">
                    </div>
                </div>
            </div>
        </div>

        <div id="availability-management">
            <h3>ניהול שעות פעילות</h3>
            <div id="availability-days">
                <div class="availability-day">
                    <label>ראשון:</label>
                    <input type="time" id="start-time-1">
                    <input type="time" id="end-time-1">
                </div>
                <div class="availability-day">
                    <label>שני:</label>
                    <input type="time" id="start-time-2">
                    <input type="time" id="end-time-2">
                </div>
                <div class="availability-day">
                    <label>שלישי:</label>
                    <input type="time" id="start-time-3">
                    <input type="time" id="end-time-3">
                </div>
                <div class="availability-day">
                    <label>רביעי:</label>
                    <input type="time" id="start-time-4">
                    <input type="time" id="end-time-4">
                </div>
                <div class="availability-day">
                    <label>חמישי:</label>
                    <input type="time" id="start-time-5">
                    <input type="time" id="end-time-5">
                </div>
                <div class="availability-day">
                    <label>שישי:</label>
                    <input type="time" id="start-time-6">
                    <input type="time" id="end-time-6">
                </div>

            </div>
            <div class="availability-day">
                <label>שבת:</label>
                <input type="time" id="start-time-7">
                <input type="time" id="end-time-7">
            </div>

            <!-- ימים נוספים -->
        </div>
        <button onclick="saveAvailability()">שמור שעות פעילות</button>
       
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <script>
        let isEditMode = false;

        document.addEventListener('DOMContentLoaded', function () {
            // אתחול מאזיני אירועים לכפתורים
            document.querySelector('.edit-mode-btn').addEventListener('click', function (e) {
                e.preventDefault();
                toggleEditMode();
            });

            document.querySelector('.save-changes-btn').addEventListener('click', function (e) {
                e.preventDefault();
                saveAllChanges();
            });
        });

        function toggleEditMode() {
            isEditMode = !isEditMode;
            const container = document.querySelector('.container');
            const editBtn = document.querySelector('.edit-mode-btn');
            const saveBtn = document.querySelector('.save-changes-btn');

            if (isEditMode) {
                // עובר למצב עריכה
                container.classList.add('edit-mode');
                editBtn.style.display = 'none';
                saveBtn.style.display = 'flex';

                // מציג את שדות הקלט ומעתיק אליהם את הערכים הנוכחיים
                const infoRows = document.querySelectorAll('.info-row');
                infoRows.forEach(row => {
                    const valueElement = row.querySelector('.info-value');
                    const inputElement = row.querySelector('.edit-input');

                    if (valueElement && inputElement) {
                        const currentValue = valueElement.textContent || '';
                        inputElement.value = currentValue.trim();
                        inputElement.style.display = 'block';
                    }
                });
            } else {
                // חוזר למצב תצוגה
                container.classList.remove('edit-mode');
                editBtn.style.display = 'flex';
                saveBtn.style.display = 'none';

                document.querySelectorAll('.edit-input').forEach(input => {
                    input.style.display = 'none';
                });
            }
        }

        async function saveAllChanges() {
            const saveBtn = document.querySelector('.save-changes-btn');
            try {
                saveBtn.disabled = true;
                saveBtn.innerHTML = 'שומר...';

                // בדיקת תקינות השדות
                const fullName = document.getElementById('<%= fullNameInput.ClientID %>').value;
                const phone = document.getElementById('<%= phoneInput.ClientID %>').value;
                const email = document.getElementById('<%= EmailInpot.ClientID %>').value;

                if (!fullName || !phone || !email) {
                    throw new Error('יש למלא את כל השדות החובה');
                }

                var data = {
                    technicianData: {
                        TecId: parseInt(document.getElementById('<%= hdnTecId.ClientID %>').value),
                        FulName: fullName,
                        Phone: phone,
                        Address: document.getElementById('<%= addressInput.ClientID %>').value,
                        Type: document.getElementById('<%= specializationInput.ClientID %>').value,
                        Email: email
                    }
                };

                // שינוי הנתיב לדף הנוכחי
                const response = await fetch('TechnicianProfile.aspx/UpdateProfile', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                if (!response.ok) {
                    throw new Error('שגיאה בשרת: ' + response.statusText);
                }

                const result = await response.json();

                if (result.d && result.d.success) {
                    // עדכון ממשק המשתמש
                    document.querySelectorAll('.info-row').forEach(row => {
                        const input = row.querySelector('.edit-input');
                        const valueSpan = row.querySelector('.info-value');
                        if (input && valueSpan) {
                            valueSpan.textContent = input.value;
                        }
                    });

                    toggleEditMode();
                    alert('הפרטים נשמרו בהצלחה!');
                    location.reload();
                } else {
                    throw new Error(result.d?.message || 'שגיאה בעדכון הפרטים');
                }
            } catch (error) {
                console.error('Error in saveAllChanges:', error);
                alert(error.message || 'שגיאה בשמירת הנתונים');
            } finally {
                saveBtn.disabled = false;
                saveBtn.innerHTML = '<i class="fas fa-save"></i><span class="btn-text">שמור שינויים</span>';
            }
        }



        document.addEventListener("DOMContentLoaded", async function () {
            const technicianId = document.getElementById("<%= hdnTecId.ClientID %>").value;

            try {
                const response = await fetch("TechnicianProfile.aspx/GetTechnicianDashboardData", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ technicianId: parseInt(technicianId) })
                });

                const result = await response.json();

                if (result.d && result.d.success) {
                    const data = result.d.data;

                    // עדכון דינמי של הנתונים בדף
                    document.getElementById("lblTotalBids").textContent = `₪${data.TotalBids}`;
                    document.querySelector("#monthlyIncomeValue").textContent = `₪${data.MonthlyIncome}`;
                    document.querySelector("#averageRatingValue").textContent = data.AverageRating.toFixed(1);
                    document.querySelector("#totalCallsValue").textContent = data.TotalCalls;
                    document.querySelector("#openCallsValue").textContent = data.OpenCalls;
                    document.querySelector("#closedCallsValue").textContent = data.ClosedCalls;
                } else {
                    console.error(result.d?.message || "שגיאה בטעינת הנתונים");
                }
            } catch (error) {
                console.error("Error fetching dashboard data:", error);
            }
        });

        async function saveAvailability() {
            const technicianId = parseInt(document.getElementById("<%= hdnTecId.ClientID %>").value);
            const availabilities = [];

            for (let i = 1; i <= 7; i++) { // ימים 1-7
                const startTime = document.getElementById(`start-time-${i}`).value;
                const endTime = document.getElementById(`end-time-${i}`).value;

                if (startTime && endTime) {
                    availabilities.push({
                        DayOfWeek: i,
                        StartTime: startTime,
                        EndTime: endTime
                    });
                }
            }

            if (availabilities.length === 0) {
                alert("לא הוזנו שעות פעילות.");
                return;
            }

            try {
                const response = await fetch("TechnicianProfile.aspx/SaveAvailability", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ technicianId, availabilities })
                });

                const result = await response.json();
                if (result.success) {
                    alert("שעות הפעילות נשמרו בהצלחה!");
                } else {
                    alert(result.message || "אירעה שגיאה בשמירת שעות הפעילות.");
                }
            } catch (error) {
                console.error("Error saving availability:", error);
            }
        }


    </script>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
