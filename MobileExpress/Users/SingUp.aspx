<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="SingUp.aspx.cs" Inherits="MobileExpress.Users.SingUp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent1" runat="server">
    <!-- קישורים ל-CSS של Bootstrap ול-Font Awesome לצורך עיצוב מתקדם ואייקונים -->
    <link rel="stylesheet" href="assets/css/styles.css">
    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">


    <%-- <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: url('/api/placeholder/1920/1080');
            background-size: cover;
            background-position: center;
            padding: 1rem;
        }

        .modal-card {
            background: white;
            border-radius: 16px;
            width: 100%;
            max-width: 800px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .image-side {
            background-image: url('/api/placeholder/400/600');
            background-size: cover;
            background-position: center;
        }

        .form-side {
            padding: 2.5rem;
            background: white;
        }

        .logo {
            width: 48px;
            height: 48px;
            background: #7C3AED;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 2rem;
        }

        h2 {
            font-size: 1.5rem;
            color: #111827;
            margin: 0 0 1.5rem;
            text-align: right;
        }

        .form-group {
            margin-bottom: 1rem;
            direction: rtl;
        }

            /* עיצוב תוויות השדות */
            .form-group label {
                display: block;
                font-size: 0.875rem;
                color: #6B7280;
                margin-bottom: 0.375rem;
            }

        /* עיצוב שדות הקלט */
        .form-control-rounded {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            font-size: 0.875rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

            .form-control-rounded:focus {
                outline: none;
                border-color: #7C3AED;
                box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1);
            }

        /* כפתור שמירה */
        .btn-primary {
            width: 100%;
            padding: 0.75rem;
            background: #7C3AED;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 1rem;
        }

            .btn-primary:hover {
                background: #6D28D9;
            }

        /* סגירת המודאל */
        .close {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            cursor: pointer;
            color: #6B7280;
        }

        @media (max-width: 768px) {
            .modal-card {
                grid-template-columns: 1fr;
            }

            .image-side {
                display: none;
            }

            .form-side {
                padding: 1.5rem;
            }
        }

        .social-buttons {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-bottom: 2rem;
            direction: ltr; /* שומר על הכיוון משמאל לימין עבור טקסט באנגלית */
        }

        .social-button {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            background: white;
            color: #6B7280;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: background-color 0.2s;
        }

            .social-button:hover {
                background: #F9FAFB;
            }

            .social-button svg {
                width: 20px;
                height: 20px;
            }

        /* קו מפריד בין כפתורי הרשתות החברתיות לטופס */
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
            color: #6B7280;
            direction: rtl;
        }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid #E5E7EB;
            }

            .divider span {
                padding: 0 1rem;
                color: #6B7280;
                font-size: 0.875rem;
            }
    </style>--%>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
            padding: 1rem;
        }

        .modal-card {
            background: white;
            border-radius: 8px;
            width: 100%;
            max-width: 800px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-side {
            padding: 2.5rem;
            background: white;
        }



        h2 {
            font-size: 1.5rem;
            color: #2d3748;
            margin: 0 0 1.5rem;
            text-align: right;
        }

        .form-group {
            margin-bottom: 1.25rem;
            direction: rtl;
        }

            .form-group label {
                display: block;
                font-size: 0.875rem;
                color: #4a5568;
                margin-bottom: 0.5rem;
                font-weight: 500;
            }

        .form-control-rounded {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 0.875rem;
            transition: all 0.2s;
            background-color: #fff;
        }

            .form-control-rounded:focus {
                outline: none;
                border-color: #6b46c1;
                box-shadow: 0 0 0 3px rgba(107, 70, 193, 0.1);
            }

        .btn-primary {
            width: 100%;
            padding: 0.75rem;
            background: #6b46c1;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 1.5rem;
            font-size: 1rem;
        }

            .btn-primary:hover {
                background: #553c9a;
            }

        /* כפתורי התחברות חברתית */
        .social-buttons {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin: 2rem 0;
            width: 100%;
        }

        .social-button {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.875rem 1.5rem;
            border-radius: 25px;
            border: none;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            width: 100%;
            gap: 0.75rem;
            color: white;
            position: relative;
        }

            /* אפקט hover משותף */
            .social-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

        /* Google */
        /* Google */
        .google-container {
            width: 100%;
            position: relative;
            transition: all 0.2s; /* הוספת transition */
        }

            .google-container:hover {
                transform: translateY(-2px); /* הוספת אפקט hover */
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

        .social-button.google {
            background: #4285F4;
            background: linear-gradient(135deg, #4285F4, #34A853);
            pointer-events: none; /* מונע את האפקט המקורי */
        }

            .social-button.google:hover {
                background: linear-gradient(135deg, #3367D6, #2E8B47);
                transform: none; /* ביטול התזוזה */
                box-shadow: none; /* ביטול הצל */
            }

        .g-signin2 {
            position: absolute !important;
            top: 0 !important;
            left: 0 !important;
            width: 100% !important;
            height: 100% !important;
            cursor: pointer !important; /* הוספת סמן יד */
        }

            .g-signin2 > div,
            .g-signin2 iframe {
                width: 100% !important;
                height: 100% !important;
                opacity: 0 !important;
            }
        /* Email */
        .social-button.email {
            background: linear-gradient(135deg, #EA4335, #FBBC05);
        }

            .social-button.email:hover {
                background: linear-gradient(135deg, #D33828, #E0A800);
            }

        /* Facebook */
        .social-button.facebook {
            background: linear-gradient(135deg, #1877F2, #3b5998);
        }

            .social-button.facebook:hover {
                background: linear-gradient(135deg, #166FE5, #344e86);
            }

        /* אייקונים */
        .social-button i {
            font-size: 1.2rem;
        }

        /* מפריד */
        .divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
            color: #718096;
            direction: rtl;
        }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid #e2e8f0;
            }

            .divider span {
                padding: 0 1rem;
                font-size: 0.875rem;
                color: #718096;
            }

        /* רספונסיביות */
        @media (max-width: 768px) {
            .modal-card {
                grid-template-columns: 1fr;
                margin: 1rem;
            }

            .image-side {
                display: none;
            }

            .form-side {
                padding: 1.5rem;
            }
        }
    </style>


    <form id="form1" runat="server">
        <div class="modal-card" id="customersModal">
            <div class="image-side"></div>
            <div class="form-side">



                <h2 id="modalTitle">הרשמה</h2>

                <asp:HiddenField ID="hfCusId" runat="server" />

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtFullName" runat="server"></asp:Label>
                    <asp:TextBox ID="txtFullName" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="שם מלא"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtPhone" runat="server"></asp:Label>
                    <asp:TextBox ID="txtPhone" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="טלפון"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtAddres" runat="server"></asp:Label>
                    <asp:TextBox ID="txtAddres" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="כתובת"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtUname" runat="server"></asp:Label>
                    <asp:TextBox ID="txtUname" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="אימייל"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtPass" runat="server"></asp:Label>
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password" required="required" CssClass="form-control form-control-rounded" placeholder="סיסמה"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtNots" runat="server"></asp:Label>
                    <asp:TextBox ID="txtNots" runat="server" CssClass="form-control form-control-rounded" placeholder="הערות"></asp:TextBox>
                </div>

                <%-- <div class="form-group">
                <asp:Label AssociatedControlID="txtCityId" runat="server"> עיר:</asp:Label>
                <asp:TextBox ID="txtCityId" runat="server" required="required" CssClass="form-control form-control-rounded"></asp:TextBox>
            </div>--%>

                <asp:Button ID="btnSave" runat="server" OnClick="SaveCustomers" Text="שמירה" CssClass="btn btn-primary" />
            </div>
        </div>
        <div class="social-buttons">
            <!-- כפתור אימייל -->
            <button class="social-button email">
                <i class="fas fa-envelope"></i>
                התחברות באמצעות אימייל
            </button>


            <!-- כפתור גוגל -->
            <div class="google-container">
                <button class="social-button google">
                    <i class="fab fa-google"></i>
                    התחברות באמצעות Google
       
                </button>
                <div class="g-signin2" data-onsuccess="onSignIn"></div>
            </div>


            <!-- כפתור פייסבוק -->
            <button class="social-button facebook">
                <i class="fab fa-facebook"></i>
                התחברות באמצעות Facebook
            </button>
        </div>



    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
    <!-- סקריפטים שנדרשים לעמוד -->
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
    <!-- הוספת Firebase -->
    <script src="https://www.gstatic.com/firebasejs/9.x.x/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.x.x/firebase-auth.js"></script>

    <!-- Google Sign In -->
    <meta name="google-signin-client_id" content="AIzaSyAKp-Y7v2FtSV7yOS8ACVQnmag6Z5nAc4U.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>


    <!-- Facebook SDK -->
    <script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js"></script>

    <script>
        function saveCustomer() {
            console.log("פונקציית saveCustomer התחילה");
            var data = {
                CusId: $('#<%= hfCusId.ClientID %>').val(),
                FullName: $('#<%= txtFullName.ClientID %>').val(),
                Phone: $('#<%= txtPhone.ClientID %>').val(),
                Addres: $('#<%= txtAddres.ClientID %>').val(),
                Uname: $('#<%= txtUname.ClientID %>').val(),
                Pass: $('#<%= txtPass.ClientID %>').val(),
     <%--   DateAdd: $('#<%= txtDateAdd.ClientID %>').val(),--%>

                Nots: $('#<%= txtNots.ClientID %>').val(),
               <%-- CityId: parseInt($('#<%= txtCityId.ClientID %>').val())--%>
            };

            console.log("נתונים שנאספו:", JSON.stringify(data));

            var method = data.CusId === "" ? "POST" : "PUT";
            var url = method === "POST" ? "/api/Customers" : "/api/Customers/" + data.CusId;

            console.log(`שולח בקשת ${method} ל-${url}`);

            $.ajax({
                type: "POST",
                url: "/api/CustomersController/Post",
                data: JSON.stringify({ customerData: data }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("תגובה התקבלה בהצלחה:", response);
                    alert("הלקוח נשמר בהצלחה");
                    closeModal();
                    refreshCustomersTable();
                },
                error: function (xhr, status, error) {
                    console.error("שגיאה בשמירת הלקוח:", status, error);
                    console.log("תגובת השרת:", xhr.responseText);
                    alert("אירעה שגיאה בשמירת הלקוח: " + error);
                }
            });

        }


        function onGoogleSignUp(googleUser) {
            console.log('Google Sign-Up successful');

            var id_token = googleUser.getAuthResponse().id_token;
            console.log('Got ID Token:', id_token);

            // שינוי הנתיב ל-signup
            fetch('/api/customers/google-signup', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ idToken: id_token })
            })
                .then(response => {
                    console.log('Server Response:', response);
                    return response.json();
                })
                .then(data => {
                    console.log('Server Data:', data);
                    if (data.success) {
                        // אפשר להוסיף הודעת הצלחה
                        alert('ההרשמה בוצעה בהצלחה!');
                        window.location.href = '/Main.aspx';
                    } else {
                        alert('שגיאה בהרשמה: ' + (data.message || 'אירעה שגיאה לא ידועה'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('שגיאה בהרשמה עם גוגל');
                });
        }


    </script>
</asp:Content>
