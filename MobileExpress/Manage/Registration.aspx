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
                                    <label for="history">היסטוריה</label>
                                    <textarea class="form-control" id="history" name="History"></textarea>
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
                                <div class="form-group">
                                    <label for="status">סטטוס</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-toggle-on"></i></span>
                                        </div>
                                        <select class="form-control" id="status" name="Status" required>
                                            <option value="1">פעיל</option>
                                            <option value="0">לא פעיל</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="serProdId">מספר מוצר שירות</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-cogs"></i></span>
                                        </div>
                                        <input type="number" class="form-control" id="serProdId" name="SerProdId">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="dateAddition">תאריך הוספה</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                                        </div>
                                        <input type="datetime-local" class="form-control" id="dateAddition" name="DateAddition" required>
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
                $('#saveTechnicianBtn').click(function () {
                    if ($('#addTechnicianForm')[0].checkValidity()) {
                        var formData = $('#addTechnicianForm').serialize();
                        console.log(formData); // בדוק את הנתונים שנשלחים
                        $.ajax({
                            url: '/api/v1/Technicians', // כתובת ה-API הנכונה
                            method: 'POST',
                            data: formData,
                            success: function (response) {
                                $('#formFeedback').removeClass('d-none alert-danger').addClass('alert-success').text('הטכנאי נוסף בהצלחה!');
                                setTimeout(function () {
                                    $('#addTechnicianModal').modal('hide');
                                    $('#formFeedback').addClass('d-none').text('');
                                    $('#addTechnicianForm')[0].reset();
                                }, 2000);
                            },
                            error: function () {
                                $('#formFeedback').removeClass('d-none alert-success').addClass('alert-danger').text('שגיאה בהוספת הטכנאי.');
                            }
                        });
                    } else {
                        $('#addTechnicianForm')[0].reportValidity();
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
