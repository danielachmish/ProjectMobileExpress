<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="SingUpTechnicians.aspx.cs" Inherits="MobileExpress.TechniciansFolder.SingUpTechnicians" %>

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
            grid-template-columns: 1fr;
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
            background: linear-gradient(to right, #6b46c1, #8662d9); /* gradient מימין לשמאל */
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 1.5rem;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(107, 70, 193, 0.2); /* צל עדין */
        }

            .btn-primary:hover {
                opacity: 0.9; /* אפקט hover עדין */
                box-shadow: 0 4px 8px rgba(107, 70, 193, 0.3);
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


        /* CSS מעודכן */
        .google-container {
            width: 100%;
            position: relative;
            margin: 10px 0;
        }

        .social-button.google {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px 20px;
            background: #4285F4;
            background: linear-gradient(135deg, #4285F4, #34A853);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }

            .social-button.google i {
                margin-right: 10px;
                font-size: 18px;
            }

        /* אפקט Hover */
        .google-container:hover .social-button.google {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(66, 133, 244, 0.3);
            background: linear-gradient(135deg, #3367D6, #2E8B47);
        }

        /* הכפתור המקורי של Google */
        .google-overlay {
            position: absolute !important;
            top: 0 !important;
            left: 0 !important;
            width: 100% !important;
            height: 100% !important;
            opacity: 0 !important; /* שקיפות מלאה */
            z-index: 2; /* מעל הכפתור המעוצב */
            cursor: pointer !important;
        }

            /* הסתרת הסגנון המקורי של Google */
            .google-overlay > div,
            .google-overlay iframe {
                width: 100% !important;
                height: 100% !important;
                opacity: 0 !important;
            }

        /* אפקט לחיצה */
        .google-container:active .social-button.google {
            transform: translateY(1px);
            box-shadow: 0 2px 6px rgba(66, 133, 244, 0.2);
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
                padding: 100%;
            }
        }
    </style>



        <div class="modal-card" id="techniciansModal">
            <div class="image-side"></div>
            <div class="form-side">
                <h2 id="modalTitle">הרשמה</h2>

                <asp:HiddenField ID="hfTecId" runat="server" />

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtFulName" runat="server"></asp:Label>
                    <asp:TextBox ID="txtFulName" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="שם מלא"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtTecNum" runat="server"></asp:Label>
                    <asp:TextBox ID="txtTecNum" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="ח.פ/ת.ז"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtPhone" runat="server"></asp:Label>
                    <asp:TextBox ID="txtPhone" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="טלפון"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtAddress" runat="server"></asp:Label>
                    <asp:TextBox ID="txtAddress" runat="server" required="required" CssClass="form-control form-control-rounded" placeholder="כתובת"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtPass" runat="server"></asp:Label>
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password" required="required" CssClass="form-control form-control-rounded" placeholder="סיסמה"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Label AssociatedControlID="txtUserName" runat="server"></asp:Label>
                    <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control form-control-rounded" placeholder="שם משתמש"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtType" runat="server"></asp:Label>
                    <asp:TextBox ID="txtType" runat="server" CssClass="form-control form-control-rounded" placeholder="סוג טכנאי"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtEmail" runat="server"></asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-rounded" placeholder="כתובת מייל"></asp:TextBox>
                </div>
                <asp:Button ID="btnSave" runat="server" OnClick="SaveTechnicians" Text="שמירה" CssClass="btn btn-primary" />



                <!-- כפתורי ההתחברות החברתית -->
                <div class="social-buttons">
                    <%-- <asp:LinkButton ID="emailButton" runat="server" CssClass="social-button email" OnClick="EmailSignUp">
                            <i class="fas fa-envelope"></i>
                            התחברות באמצעות אימייל
                    </asp:LinkButton>--%>

                    <div class="google-container">
                        <!-- הכפתור המעוצב -->
                        <asp:LinkButton ID="googleButton" runat="server" CssClass="social-button google">
            <i class="fab fa-google"></i>
            התחברות באמצעות Google
        </asp:LinkButton>
                        <!-- הכפתור המקורי של Google מעל הכפתור המעוצב -->
                        <div class="g-signin2 google-overlay" data-onsuccess="onGoogleSignUp"></div>
                    </div>

                    <%-- <asp:LinkButton ID="facebookButton" runat="server" CssClass="social-button facebook" OnClick="FacebookSignUp">
                            <i class="fab fa-facebook"></i>
                            התחברות באמצעות Facebook
                        </asp:LinkButton>--%>
                    <div class="login-link" style="text-align: center; margin-top: 15px;">
        <a href="SingInTechnicians.aspx" style="color: #666; text-decoration: none;">יש לך חשבון? היכנס</a>
    </div>
                </div>
            </div>
        </div>



</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
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
    <meta name="google-signUn-client_id" content="AIzaSyAKp-Y7v2FtSV7yOS8ACVQnmag6Z5nAc4U.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>


    <%-- <!-- Facebook SDK -->
    <script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js"></script>--%>

    <script>
        function SaveTechnicians() {
            console.log("פונקציית SaveTechnicians התחילה");
            var data = {
                TecId: $('#<%= hfTecId.ClientID %>').val(),
                FulName: $('#<%= txtFulName.ClientID %>').val(),
                TecNum: $('#<%= txtTecNum.ClientID %>').val(),
                Phone: $('#<%= txtPhone.ClientID %>').val(),
                Address: $('#<%= txtAddress.ClientID %>').val(),
                UserName: $('#<%= txtUserName.ClientID %>').val(),
                Type: $('#<%= txtType.ClientID %>').val(),
                Email: $('#<%= txtEmail.ClientID %>').val(),

            };

            console.log("נתונים שנאספו:", JSON.stringify(data));

            var method = data.TecId === "" ? "POST" : "PUT";
            var url = method === "POST" ? "/api/Technicians" : "/api/Technicians/" + data.TecId;

            console.log(`שולח בקשת ${method} ל-${url}`);

            $.ajax({
                type: "POST",
                url: "/api/TechniciansController/Post",
                data: JSON.stringify({ techniciansData: data }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("תגובה התקבלה בהצלחה:", response);
                    alert("ההרשמה בוצעה בהצלחה!");
                    window.location.href = 'MainTechnicians.aspx';
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
            var profile = googleUser.getBasicProfile();

            const googleContainer = document.querySelector('.google-container');
            googleContainer.classList.add('success');


            // מילוי השדות המידיים מ-Google
            $('#<%= txtEmail.ClientID %>').val(profile.getEmail());
            $('#<%= txtFulName.ClientID %>').val(profile.getName());
            $('#<%= txtUserName.ClientID %>').val(profile.getEmail().split('@')[0]);

            // קבלת הטוקן
            var id_token = googleUser.getAuthResponse().id_token;

            // שליחה לשרת
            fetch('/api/Technicians/google-signup', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    idToken: id_token,
                    TecId: $('#<%= hfTecId.ClientID %>').val(),
                    FulName: profile.getName(),
                    Email: profile.getEmail(),
                    UserName: profile.getEmail().split('@')[0],
                    Phone: $('#<%= txtPhone.ClientID %>').val(),
                    Address: $('#<%= txtAddress.ClientID %>').val(),
                    TecNum: $('#<%= txtTecNum.ClientID %>').val(),
                    Type: $('#<%= txtType.ClientID %>').val()
                })
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        // עדכון שאר השדות אם קיבלנו מידע נוסף מהשרת
                        if (data.technician) {
                            $('#<%= txtPhone.ClientID %>').val(data.technician.Phone || '');
                            $('#<%= txtAddress.ClientID %>').val(data.technician.Address || '');
                            $('#<%= txtType.ClientID %>').val(data.technician.Type || '');
                            $('#<%= txtTecNum.ClientID %>').val(data.technician.TecNum || '');
                            $('#<%= hfTecId.ClientID %>').val(data.technician.TecId || '');
                        }

                        alert('הפרטים נטענו בהצלחה!');
                    } else {
                        throw new Error(data.message || 'אירעה שגיאה לא ידועה');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('שגיאה בטעינת הפרטים: ' + error.message);
                });
        }

        //function onGoogleSignUp(googleUser) {
        //    console.log('Google Sign-Up successful');
        //    var id_token = googleUser.getAuthResponse().id_token;

        //    fetch('/api/Technicians/google-signup', {
        //        method: 'POST',
        //        headers: {
        //            'Content-Type': 'application/json'
        //        },
        //        body: JSON.stringify({ idToken: id_token })
        //    })
        //        .then(response => {
        //            console.log('Server Response:', response);
        //            // בדיקה אם התגובה תקינה
        //            if (!response.ok) {
        //                throw new Error(`HTTP error! status: ${response.status}`);
        //            }
        //            return response.json();
        //        })
        //        .then(data => {
        //            console.log('Server Data:', data);
        //            if (data.success) {
        //                alert('ההרשמה בוצעה בהצלחה!');
        //                window.location.href = 'MainTechnicians.aspx';
        //            } else {
        //                throw new Error(data.message || 'אירעה שגיאה לא ידועה');
        //            }
        //        })
        //        .catch(error => {
        //            console.error('Error:', error);
        //            alert('שגיאה בהרשמה עם גוגל: ' + error.message);
        //        });
        //}

      <%--  // פונקציה להתחברות
        function initFacebookLogin() {
            FB.login(function (response) {
                if (response.authResponse) {
                    // שליחת הטוקן לשרת
                    document.getElementById('<%= facebookButton.ClientID %>').click();
                    // הוספת שדה נסתר עם הטוקן
                    var form = document.forms[0];
                    var input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'fbToken';
                    input.value = response.authResponse.accessToken;
                    form.appendChild(input);
                }
            }, { scope: 'email' });
        }

        // קישור הפונקציה לכפתור
        document.querySelector('.facebook').addEventListener('click', function (e) {
            e.preventDefault();
            initFacebookLogin();
        });--%>


    </script>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
