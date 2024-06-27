<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/MainMaster.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="MobileExpress.Manage.Registration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>@ViewBag.Title</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet" />
        <style>
            .modal-header {
                background-color: #6a0dad; /* צבע סגול */
                color: white;
            }
            .modal-footer {
                background-color: #f1f1f1;
            }
            .btn-custom {
                background-color: #6a0dad; /* צבע סגול */
                color: white;
            }
            .form-control:invalid {
                border-color: red;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="text-center">רשימת טכנאים</h2>
            <button type="button" class="btn btn-custom mb-3" data-toggle="modal" data-target="#addTechnicianModal">
                הוסף טכנאי חדש
            </button>

            <!-- מודאל להוספת טכנאי חדש -->
            <div class="modal fade" id="addTechnicianModal" tabindex="-1" aria-labelledby="addTechnicianModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addTechnicianModalLabel">הוסף טכנאי חדש</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form id="addTechnicianForm">
                                <div class="form-group">
                                    <label for="tecNum">מספר טכנאי</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        </div>
                                        <input type="text" class="form-control" id="tecNum" name="TecNum">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="fullName">שם מלא</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        </div>
                                        <input type="text" class="form-control" id="fullName" name="FulName" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="phone">טלפון</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                        </div>
                                        <input type="tel" class="form-control" id="phone" name="Phone" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="address">כתובת</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                                        </div>
                                        <input type="text" class="form-control" id="address" name="Address" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="password">סיסמה</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                        </div>
                                        <input type="password" class="form-control" id="password" name="Pass" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="username">שם משתמש</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                        </div>
                                        <input type="text" class="form-control" id="username" name="UserName" required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="type">סוג</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-tools"></i></span>
                                        </div>
                                        <input type="text" class="form-control" id="type" name="Type" required>
                                    </div>
                                </div>
                               
                                <div class="form-group">
                                    <label for="notes">הערות</label>
                                    <textarea class="form-control" id="notes" name="Nots"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="email">אימייל</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                        </div>
                                        <input type="email" class="form-control" id="email" name="Email" required>
                                    </div>
                                </div>
                              
                                <div id="formFeedback" class="alert d-none" role="alert"></div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">סגור</button>
                            <button type="button" class="btn btn-custom" id="saveTechnicianBtn">שמור</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function () {
        // פונקציה לטעינת רשימת הטכנאים
        function loadTechnicians() {
            console.log("Loading technicians...");
            $.ajax({
                type: "GET",
                url: "http://localhost:20210/api/v1/Technicians/", // כתובת ה-API המתאימה לטעינת הטכנאים
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("Technicians loaded successfully", response);
                    // עדכון ה-HTML עם רשימת הטכנאים החדשה
                    var html = '';
                    response.forEach(function (technician) {
                        html += '<div>' +
                            'מספר טכנאי: ' + technician.TecNum + '<br>' +
                            'שם מלא: ' + technician.FulName + '<br>' +
                            'טלפון: ' + technician.Phone + '<br>' +
                            'כתובת: ' + technician.Address + '<br>' +
                            'אימייל: ' + technician.Email + '<br>' +
                            '</div><hr>';
                    });
                    $('#techniciansList').html(html);
                },
                error: function (error) {
                    console.error("Error loading technicians:", error);
                    alert("אירעה שגיאה בטעינת רשימת הטכנאים.");
                }
            });
        }

        // קריאה ראשונית לטעינת רשימת הטכנאים כאשר העמוד נטען
        loadTechnicians();

        // קוד שיבוצע כשהמסמך מוכן
        $('#saveTechnicianBtn').click(function () {
            // קוד שיבוצע כאשר כפתור שמירה נלחץ
            if ($('#addTechnicianForm')[0].checkValidity()) {
                // בדיקה אם הטופס תקין
                var formData = $('#addTechnicianForm').serialize();
                // המרה של נתוני הטופס לפורמט שמיש
                console.log("Form data to be sent:", formData); // בדוק את הנתונים שנשלחים
                $.ajax({
                    url: '/api/v1/Technicians', // כתובת ה-API הנכונה
                    method: 'POST',
                    data: formData,
                    success: function (response) {
                        console.log("Technician saved successfully", response);
                        $('#formFeedback').removeClass('d-none alert-danger').addClass('alert-success').text('הטכנאי נוסף בהצלחה!');
                        // הודעת הצלחה
                        loadTechnicians(); // קריאה לפונקציה לטעינת הטכנאים לאחר שמירה
                        setTimeout(function () {
                            $('#addTechnicianModal').modal('hide');
                            // הסתרת המודאל אחרי 0.5 שניות
                            location.reload(); // רענון הדף
                            $('#formFeedback').addClass('d-none').text('');
                            // איפוס הודעת הפידבק
                            $('#addTechnicianForm')[0].reset();
                            // איפוס הטופס
                        }, 500);
                    },
                    error: function (error) {
                        console.error("Error saving technician:", error);
                        $('#formFeedback').removeClass('d-none alert-success').addClass('alert-danger').text('שגיאה בהוספת הטכנאי.');
                        // הודעת שגיאה
                    }
                });
            } else {
                $('#addTechnicianForm')[0].reportValidity();
                // אם הטופס לא תקין, הצגת הודעות שגיאה
            }
        });
    });

</script>




    </body>
    </html>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="UnderFooter" runat="server">
</asp:Content>
