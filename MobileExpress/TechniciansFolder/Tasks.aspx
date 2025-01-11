<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="Tasks.aspx.cs" Inherits="MobileExpress.TechniciansFolder.Tasks" %>

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
    <%--  <meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- הוספת הספריות הנדרשות -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.0.19/dist/sweetalert2.min.css" rel="stylesheet">
      <style>
        .calendar-container {
            width: 100%;
            height: calc(100vh - 150px);
            padding: 20px;
        }

        .google-calendar {
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: red;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
        }

        .call-item {
            margin-bottom: 15px;
            padding: 15px;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-right: 4px solid #4CAF50;
        }

        .call-item.urgent {
            border-right-color: #f44336;
        }
    </style>
      <div class="calendar-container">
        <iframe class="google-calendar" 
                src="https://calendar.google.com/calendar/embed?src=primary&ctz=Asia%2FJerusalem&hl=he&showTitle=0&showNav=1&showPrint=0&showTabs=1&showCalendars=0&showTz=1&mode=WEEK"
                frameborder="0" 
                scrolling="no">
        </iframe>
    </div>
  
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">

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
   <script src="https://apis.google.com/js/api.js"></script>
<script src="https://accounts.google.com/gsi/client"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  

 
    <script>
        // Google API Configuration
        const CONFIG = {
            API_KEY: 'AIzaSyBXC6AuzzKpiJUXIh2rZi7un3kGwfBOwMI',
            CLIENT_ID: '231433563253-34qc516ktkch6rt1s35nptvl8ina7b8p.apps.googleusercontent.com',
            DISCOVERY_DOCS: ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"],
            SCOPES: 'https://www.googleapis.com/auth/calendar.events https://www.googleapis.com/auth/gmail.send'
        };

        document.addEventListener('DOMContentLoaded', () => {
            logEvent('Initialization', 'Starting Google API initialization');
            try {
                gapi.load('client', initializeGoogleAPI);
            } catch (err) {
                logError('Initialization', err);
                Swal.fire('שגיאה', 'התרחשה שגיאה באתחול המערכת.', 'error');
            }
        });

        async function initializeGoogleAPI() {
            try {
                console.log('Initializing GAPI client...');
                await gapi.client.init({
                    apiKey: CONFIG.API_KEY,
                    discoveryDocs: CONFIG.DISCOVERY_DOCS,
                });
                console.log('GAPI client initialized successfully');

                tokenClient = google.accounts.oauth2.initTokenClient({
                    client_id: CONFIG.CLIENT_ID,
                    scope: CONFIG.SCOPES,
                    callback: (resp) => {
                        if (resp.error) {
                            console.error('Error in token callback:', resp.error);
                            Swal.fire('שגיאה', 'שגיאה בעת קבלת הטוקן', 'error');
                        } else {
                            console.log('Token received:', resp);
                        }
                    },
                });
            } catch (error) {
                console.error('Error during GAPI initialization:', error);
                Swal.fire('שגיאה', 'התרחשה שגיאה באתחול המערכת.', 'error');
            }

       

    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
