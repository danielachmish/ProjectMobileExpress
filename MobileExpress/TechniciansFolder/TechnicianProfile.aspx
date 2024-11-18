<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="TechnicianProfile.aspx.cs" Inherits="MobileExpress.TechniciansFolder.TechnicianProfile" %>
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
    <meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="page-container" dir="rtl">
    <!-- Back Button -->
  <div class="back-button-container">
    <button onclick="window.location.href='MainTechnicians.aspx'" class="back-button">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M19 12H5M12 19l-7-7 7-7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        חזרה
    </button>
</div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header Section -->
        <header class="profile-header">
            <h1 class="profile-title">פרופיל טכנאי</h1>
            <div class="header-controls">
                <span class="version-label">גרסה 1</span>
                <button class="edit-button">עריכת פרופיל</button>
            </div>
        </header>

        <!-- Stats Grid -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>קריאות שירות</h3>
                        <p class="stat-value">80</p>
                    </div>
                    <div class="stat-icon">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M4 6h16M4 12h16m-7 6h7"></path>
                        </svg>
                    </div>
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

            <div class="stat-card">
                <div class="stat-content">
                    <div>
                        <h3>זמינות</h3>
                        <p class="stat-value available">זמין</p>
                    </div>
                    <div class="stat-icon available-icon">
                        <svg class="icon" viewBox="0 0 24 24">
                            <path d="M5 13l4 4L19 7"></path>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- Details Section -->
        <div class="details-section">
            <div class="details-card">
                <h2>פרטים אישיים</h2>
                <div class="personal-details">
                    <div class="detail-row">
                        <span class="detail-label">שם מלא:</span>
                        <span>ישראל ישראלי</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">טלפון:</span>
                        <span>050-1234567</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">התמחות:</span>
                        <span>מזגנים, מקררים, מכונות כביסה</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">אזורי שירות:</span>
                        <span>תל אביב והמרכז</span>
                    </div>
                </div>
            </div>

            <div class="details-card">
                <h2>שעות פעילות</h2>
                <div class="working-hours">
                    <div class="hours-row">
                        <span>ראשון - חמישי</span>
                        <span>08:00 - 17:00</span>
                    </div>
                    <div class="hours-row">
                        <span>שישי</span>
                        <span>08:00 - 13:00</span>
                    </div>
                    <div class="hours-row">
                        <span>שבת</span>
                        <span class="unavailable">לא זמין</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    <style>
    /* Page Container */
.page-container {
    min-height: 100vh;
    width: 100%;
    background-color: #f3f4f6;
    padding: 2rem;
}

/* Back Button */
.back-button-container {
    margin-bottom: 2rem;
}

.back-button {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background-color: white;
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
    color: #374151;
    cursor: pointer;
    transition: all 0.2s ease;
}

.back-button:hover {
    background-color: #f9fafb;
}

.back-button svg {
    width: 1.25rem;
    height: 1.25rem;
}

/* Main Content */
.main-content {
    max-width: 1400px;
    margin: 0 auto;
}

/* Header */
.profile-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
    background-color: white;
    padding: 1.5rem;
    border-radius: 0.75rem;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.profile-title {
    font-size: 1.875rem;
    font-weight: bold;
    color: #7C3AED;
}

.header-controls {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.version-label {
    font-size: 0.875rem;
    color: #6B7280;
}

.edit-button {
    background-color: #7C3AED;
    color: white;
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 500;
    border: none;
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.edit-button:hover {
    background-color: #6D28D9;
}

/* Stats Container */
.stats-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

/* Stat Cards */
.stat-card {
    background-color: white;
    padding: 1.5rem;
    border-radius: 0.75rem;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.stat-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.stat-card h3 {
    font-size: 0.875rem;
    color: #6B7280;
    margin-bottom: 0.5rem;
}

.stat-value {
    font-size: 1.5rem;
    font-weight: bold;
    color: #7C3AED;
}

.stat-icon {
    padding: 0.75rem;
    background-color: #F3E8FF;
    border-radius: 0.75rem;
}

.icon {
    width: 1.5rem;
    height: 1.5rem;
    stroke: #7C3AED;
    fill: none;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
}

/* Available Status */
.available {
    color: #059669;
}

.available-icon {
    background-color: #D1FAE5;
}

.available-icon .icon {
    stroke: #059669;
}

/* Details Section */
.details-section {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: 1.5rem;
}

.details-card {
    background-color: white;
    padding: 1.5rem;
    border-radius: 0.75rem;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.details-card h2 {
    font-size: 1.25rem;
    font-weight: bold;
    color: #1F2937;
    margin-bottom: 1.5rem;
}

/* Personal Details */
.personal-details {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.detail-row {
    display: flex;
    align-items: center;
}

.detail-label {
    color: #6B7280;
    width: 8rem;
    font-weight: 500;
}

/* Working Hours */
.working-hours {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.hours-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem 0;
    border-bottom: 1px solid #E5E7EB;
}

.hours-row:last-child {
    border-bottom: none;
}

.unavailable {
    color: #DC2626;
}

/* Responsive Design */
@media (max-width: 768px) {
    .page-container {
        padding: 1rem;
    }

    .profile-header {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }

    .details-section {
        grid-template-columns: 1fr;
    }

    .stats-container {
        grid-template-columns: 1fr;
    }

    .detail-row {
        flex-direction: column;
        align-items: flex-start;
        gap: 0.5rem;
    }

    .detail-label {
        width: auto;
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
