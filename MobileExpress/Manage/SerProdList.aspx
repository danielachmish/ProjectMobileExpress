<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/MainMaster.Master" AutoEventWireup="true" CodeBehind="SerProdList.aspx.cs" Inherits="MobileExpress.Manage.SerProdList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- קישורים ל-CSS של Bootstrap ול-Font Awesome לצורך עיצוב מתקדם ואייקונים -->
    <link rel="stylesheet" href="assets/css/styles.css">
    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <!-- כותרת העמוד ופירורי לחם -->

    <div class="breadcrumb" style="direction: rtl;">
        <h1>רשימת מוצרי שירות</h1>
    </div>
    <div class="separator-breadcrumb border-top"></div>

    <!-- תוכן העמוד -->
    <div class="row" style="height: 100%; direction: rtl;">
        <div class="col-md-12" style="height: 100%;">
            <div class="card" style="height: 100%;">
                <div class="card-header gradient-purple-indigo 0-hidden pb-80">
                    <div class="pt-4">
                        <div class="container-flex">
                            <!-- שדה חיפוש -->
                            <input class="form-control form-control-rounded col-md-4 ml-3 mr-3" id="searchInput" type="text" placeholder="חיפוש" onkeyup="filterContacts()" style="text-align: right;" />

                            <div class="columns-button-container">
                                <!-- כפתור יצוא ל-Excel -->
                                <button class="export-button" onclick="exportTableToExcel('contact_list_table')">
                                    <i class="fas fa-file-excel"></i>
                                </button>
                                <!-- כפתור הוספת מנהל -->
                                <button class="add-button" type="button" onclick="openModalAdd()">+</button>

                                <!-- תפריט להסתיר/להציג עמודות -->
                                <button class="columns-button" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <div class="columns-icon">
                                        <span></span>
                                        <span></span>
                                        <span></span>
                                    </div>
                                </button>
                                <div class="dropdown-menu p-3" aria-labelledby="dropdownMenuButton" dir="rtl">
                                    <div class="form-check">
                                        <label class="switch">
                                            <input type="checkbox" class="toggle-vis" data-column="1" checked>
                                            <span class="slider round"></span>
                                        </label>
                                        <label class="form-check-label ml-3">SerProdId</label>
                                    </div>
                                    <div class="form-check">
                                        <label class="switch">
                                            <input type="checkbox" class="toggle-vis" data-column="2" checked>
                                            <span class="slider round"></span>
                                        </label>
                                        <label class="form-check-label ml-3">Desc</label>
                                    </div>
                                    <div class="form-check">
                                        <label class="switch">
                                            <input type="checkbox" class="toggle-vis" data-column="3" checked>
                                            <span class="slider round"></span>
                                        </label>
                                        <label class="form-check-label ml-3">Price</label>
                                    </div>
                                    <div class="form-check">
                                        <label class="switch">
                                            <input type="checkbox" class="toggle-vis" data-column="4" checked>
                                            <span class="slider round"></span>
                                        </label>
                                        <label class="form-check-label ml-3">NameImage</label>
                                    </div>
                                    <div class="form-check">
                                        <label class="switch">
                                            <input type="checkbox" class="toggle-vis" data-column="5" checked>
                                            <span class="slider round"></span>
                                        </label>
                                        <label class="form-check-label ml-3">Nots</label>
                                    </div>
                                   
                                    <div class="form-check">
                                        <label class="switch">
                                            <input type="checkbox" class="toggle-vis" data-column="6" checked>
                                            <span class="slider round"></span>
                                        </label>
                                        <label class="form-check-label ml-3">Status</label>
                                    </div>
                                   
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card-body" style="height: calc(100% - 80px); direction: rtl;">
        <div class="table-responsive" style="height: 100%;">
            <form id="form1" runat="server">
                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <!-- טבלה של רשימת המנהלים -->
                <div class="ontainer-fluid">
                    <table class="display table table-borderless ul-contact-list-table" id="contact_list_table" style="width: 100%; direction: rtl;">
                        <thead>
                            <tr class="border-bottom">
                                <th>
                                    <input type="checkbox" id="selectAll"></th>
                                <th>SerProdId</th>
                                <th>Desc</th>
                                <th>Price</th>
                                <th>NameImage</th>
                                <th>Nots</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="SerProdList">
                            <asp:Repeater ID="Repeater2" runat="server">
                                <ItemTemplate>
                                    <tr class="row-status" data-status='<%# Eval("Status") %>' data-SerProd-id='<%# Eval("SerProdId") %>'>
                                        <td>
                                            <input type="checkbox" class="selectRow" value='<%# Eval("SerProdId") %>'></td>
                                        <td><%# Eval("SerProdId") %></td>
                                        <td><%# Eval("Desc") %></td>
                                        <td><%# Eval("Price") %></td>
                                        <td><%# Eval("NameImage") %></td>
                                        <td><%# Eval("Nots") %></td>
                                        <td>
                                            <button class="status-button"><%# Convert.ToBoolean(Eval("Status")) ? "פעיל" : "לא פעיל" %></button>
                                        </td>

                                        <td class="action-buttons">
                                            <button type="button" class="edit-button edit-contact" onclick="openModalEdit({
                                                                SerProdId: '<%# Eval("SerProdId") %>',
                                                                Desc: '<%# Eval("Desc") %>',
                                                                Price: '<%# Eval("Price") %>',
                                                                NameImage: '<%# Eval("NameImage") %>',
                                                                Nots: '<%# Eval("Nots") %>',                                                 
                                                            })">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <asp:LinkButton class="delete-button" ID="LinkButton1" runat="server" CommandArgument='<%# Eval("SerProdId") %>' OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this item?');">
                                                <i class="fas fa-trash-alt"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <!-- כפתור מחיקה שמופיע בתחתית הטבלה -->
                <div id="deleteContainer" style="display: none; text-align: center; margin-top: 20px;">
                    <button id="deleteSelected" class="delete-button-Multiple" onclick="deleteSelectedRows()" title="מחיקת רשומות נבחרות">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
                <%-- מודל הוספת מנהל--%>
                <div id="SerProdModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal()">&times;</span>
                        <h2 id="modalTitle">הוספת מנהל</h2>
                        <asp:HiddenField ID="hfSerProdId" runat="server" />
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtDesc" runat="server">תיאור:</asp:Label>
                            <asp:TextBox ID="txtDesc" runat="server" required="required" CssClass="form-control form-control-rounded"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtPrice" runat="server">מחיר:</asp:Label>
                            <asp:TextBox ID="txtPrice" runat="server" required="required" CssClass="form-control form-control-rounded"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtNameImage" runat="server">שם תמונה:</asp:Label>
                            <asp:TextBox ID="txtNameImage" runat="server" required="required" CssClass="form-control form-control-rounded"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtNots" runat="server">הערות</asp:Label>
                            <asp:TextBox ID="txtNots" runat="server" required="required" CssClass="form-control form-control-rounded"></asp:TextBox>
                        </div>
                        <%--  <div class="form-group">
            <asp:Label AssociatedControlID="txtDateAdd" runat="server">תאריך הוספה:</asp:Label>
            <asp:TextBox ID="txtDateAdd" runat="server" required="required" CssClass="form-control form-control-rounded"></asp:TextBox>
        </div>--%>
                        
                        <asp:Button ID="btnSave" runat="server" OnClick=" SaveSerProd" Text="שמירה" CssClass="btn btn-primary" />
                    </div>
                </div>

            </form>
        </div>
    </div>

    <style>
        body {
            margin: 0;
            padding: 0;
            direction: rtl;
        }

        /*תצוגת עמוד*/
        .header {
            display: flex; /* הגדרת תצוגת Flexbox */
            align-items: center; /* יישור אנכי למרכז */
            justify-content: space-between; /* מרווח בין האלמנטים */
            background-color: #6c757d; /* צבע רקע אפור כהה */
            padding: 10px 20px; /* ריווח פנימי */
            height: 60px; /* גובה ההדר */
        }

        .container {
            width: 100%;
            padding: 0;
            margin: 0;
            box-sizing: border-box;
        }
        /*טבלה*/
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        th, td {
            border: 1px solid #dddddd;
            text-align: center;
            padding: 8px;
        }

        th {
            background-color: #f2f2f2;
        }

        .card, .card-body {
            padding: 0;
        }

        .row, [class*="col-"] {
            margin: 0;
            padding: 0;
        }

        /* כפתורי פעולה */
        .action-buttons {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 25px;
        }

            .delete-button, .edit-button, .status-button, .action-buttons a.delete-button {
                border: none;
                border-radius: 20px;
                padding: 8px 16px;
                font-size: 14px;
                font-weight: 600;
                color: white;
                cursor: pointer;
                transition: all 0.3s ease;
                height: 36px;
                width: 60px;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                text-decoration: none; /* מסיר את קו התחתון מה-LinkButton */
            }

            .delete-button, .action-buttons a.delete-button {
                background-color: #dc3545;
            }

        .edit-button {
            background-color: #3f2169;
        }

        .status-button.status-active {
            background-color: #28a745;
        }

        .status-button.status-inactive {
            background-color: #dc3545;
        }

        .delete-button:hover, .edit-button:hover, .status-button:hover, .action-buttons a.delete-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .delete-button:hover, .action-buttons a.delete-button:hover {
            background-color: #c82333;
        }

        .edit-button:hover {
            background-color: #2c1749;
        }

        .status-button.status-active:hover {
            background-color: #218838;
        }

        .status-button.status-inactive:hover {
            background-color: #c82333;
        }



        /*מודאל עריכה*/
        .modal {
            display: block;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
            justify-content: center;
            align-items: flex-start;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 100px auto;
            padding: 20px;
            border: 1px solid #888;
            width: 30%;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .close {
            color: #aaa;
            float: left;
            font-size: 28px;
            font-weight: bold;
        }

            .close:hover,
            .close:focus {
                color: black;
                text-decoration: none;
                cursor: pointer;
            }
        /*שדות עריכת לקוח*/
        .form-group {
            margin-bottom: 15px;
        }

            .form-group label {
                font-weight: bold;
            }

        .form-control {
            border: 1px solid #ddd;
            border-radius: 0.25rem;
            padding: 0.5rem 0.75rem;
            width: 100%;
        }

        .form-control-rounded {
            border-radius: 50px;
        }

        .btn-primary {
            background-color: #3f2169;
            border-color: #3f2169;
            color: white;
            padding: 10px 20px;
            border-radius: 50px;
            cursor: pointer;
        }

            .btn-primary:hover {
                background-color: white;
                color: #3f2169;
                border-color: #3f2169;
            }



        .container-flex {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            direction: rtl;
            gap: 8px;
        }
        /* עיצוב חלון המודאל */
        .modal {
            display:none; /* המודאל מוסתר כברירת מחדל */
            position: fixed; /* מיקום קבוע בחלון הדפדפן */
            z-index: 1; /* סדר גובה גבוה */
            left: 0; /* מיקום משמאל */
            top: 0; /* מיקום מלמעלה */
            width: 100%; /* רוחב מלא */
            height: 100%; /* גובה מלא */
            overflow: auto; /* גלילה במקרה שהתוכן עולה על הגובה */
            background-color: rgba(0, 0, 0, 0.4); /* צבע רקע שחור שקוף */
            justify-content: center; /* יישור אופקי */
            align-items: flex-start; /* יישור אנכי לתחילת הציר */
        }

        .modal-content {
            background-color: #fefefe; /* צבע רקע לבן */
            margin: 100px auto; /* מרווח עליון ותחתון של 100 פיקסלים, מרכז אופקית */
            padding: 20px; /* ריווח פנימי */
            border: 1px solid #888; /* גבול אפור בהיר */
            width: 30%; /* רוחב 30% מהחלון */
            border-radius: 8px; /* פינות מעוגלות */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* צל עדין */
        }

        .close {
            color: #aaa; /* צבע אפור לכפתור הסגירה */
            float: left; /* מיקום לשמאל */
            font-size: 28px; /* גודל פונט */
            font-weight: bold; /* טקסט מודגש */
        }

            .close:hover,
            .close:focus {
                color: black; /* שינוי צבע לשחור במצב ריחוף או פוקוס */
                text-decoration: none; /* הסרת קו תחתון */
                cursor: pointer; /* שינוי סמן העכבר לידית */
            }

        .form-group {
            margin-bottom: 15px; /* ריווח תחתון */
        }

            .form-group label {
                font-weight: bold; /* טקסט מודגש */
            }
        /*שדה חיפוש*/
        .form-control {
            border: 1px solid #ddd; /* גבול אפור בהיר */
            border-radius: 0.25rem; /* פינות מעוגלות */
            padding: 0.5rem 0.75rem; /* ריווח פנימי */
            width: 100%; /* רוחב מלא */
        }

        .form-control-rounded {
            border-radius: 50px; /* פינות מעוגלות במיוחד */
        }


        /*שמירת עדכון טכנאי*/
        .btn-primary {
            background-color: #3f2169; /* צבע רקע סגול כהה לכפתור */
            border-color: #3f2169; /* צבע גבול סגול כהה */
            color: white; /* צבע טקסט לבן */
            padding: 10px 20px; /* ריווח פנימי */
            border-radius: 50px; /* פינות מעוגלות מאוד */
            cursor: pointer; /* שינוי סמן העכבר לידית */
        }

            .btn-primary:hover {
                background-color: white; /* צבע רקע לבן במצב ריחוף */
                color: #3f2169; /* צבע טקסט סגול כהה במצב ריחוף */
                border-color: #3f2169; /* צבע גבול סגול כהה במצב ריחוף */
            }

        /*כפתורים בראש העמוד*/
        .columns-button-container {
            display: flex; /* הגדרת תצוגת Flexbox */
            align-items: center; /* יישור אנכי למרכז */
            margin-right: auto; /* ריווח אוטומטי מימין כדי ליישר לשמאל */
        }

        .columns-button, .export-button {
            width: 40px; /* רוחב הכפתורים */
            height: 40px; /* גובה הכפתורים */
            border-radius: 50%; /* פינות מעוגלות */
            border: none; /* הסרת גבול */
            background-color: #33214b00; /* צבע רקע אפור כהה */
            color: white; /* צבע טקסט לבן */
            cursor: pointer; /* שינוי סמן העכבר לידית */
            display: flex; /* תצוגת Flexbox */
            align-items: center; /* יישור אנכי למרכז */
            justify-content: center; /* יישור אופקי למרכז */
            transition: background-color 0.3s, color 0.3s; /* מעבר חלק של 0.3 שניות לשינוי הצבע */
            margin-right: 10px; /* ריווח ימני */
        }

            .columns-button:hover, .export-button:hover {
                background-color: white; /* צבע רקע לבן במצב ריחוף */
                color: #6c757d; /* צבע טקסט אפור כהה במצב ריחוף */
            }
        /*כפתור הצגת עמודות*/
        .columns-icon {
            display: flex; /* תצוגת Flexbox */
            flex-direction: column; /* סידור אנכי */
            align-items: center; /* יישור אופקי למרכז */
            justify-content: center; /* יישור אנכי למרכז */
        }

            .columns-icon span {
                display: block; /* תצוגת בלוק */
                width: 4px; /* רוחב הנקודה */
                height: 4px; /* גובה הנקודה */
                background-color: white; /* צבע רקע לבן */
                border-radius: 50%; /* פינות מעוגלות */
                margin: 2px 0; /* ריווח אנכי בין הנקודות */
                transition: background-color 0.3s; /* מעבר חלק של 0.3 שניות לשינוי הצבע */
            }

        .columns-button:hover .columns-icon span {
            background-color: #6c757d; /* צבע הנקודות אפור כהה במצב ריחוף */
        }


        .switch {
            position: relative;
            display: inline-block;
            width: 34px;
            height: 20px;
        }

            .switch input {
                display: none;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 12px;
                width: 12px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                transition: .4s;
            }

        input:checked + .slider {
            background-color: #33214b00;
        }

            input:checked + .slider:before {
                transform: translateX(14px);
            }

        .slider.round {
            border-radius: 20px;
        }

            .slider.round:before {
                border-radius: 50%;
            }

        .dropdown-menu {
            max-height: 400px;
            overflow-y: auto;
        }

        .columns-icon {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background-color: #33214b00;
        }

            .columns-icon span {
                display: block;
                width: 5px;
                height: 5px;
                margin: 2px;
                background-color: white;
                border-radius: 50%;
            }

        .columns-button {
            background: none;
            border: none;
            padding: 0;
        }

        .form-check {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .form-check-label {
            order: 2;
            margin-right: 10px;
        }

        .switch {
            order: 1;
        }

        .dropdown-menu {
            left: 10PX !important;
        }


        /*הוספת טכנאי*/
        .add-button {
            width: 40px; /* רוחב הכפתור */
            height: 40px; /* גובה הכפתור */
            border-radius: 50%; /* פינות מעוגלות */
            border: none; /* הסרת גבול */
            background-color: #33214b00; /* צבע רקע סגול */
            color: white; /* צבע טקסט לבן */
            font-size: 32px; /* גודל פונט */
            cursor: pointer; /* שינוי סמן העכבר לידית */
            display: flex; /* תצוגת Flexbox */
            align-items: center; /* יישור אנכי למרכז */
            justify-content: center; /* יישור אופקי למרכז */
            margin-right: 10px; /* ריווח ימני */

            transition: background-color 0.3s, color 0.3s; /* מעבר חלק של 0.3 שניות לשינוי הצבע */
        }

            .add-button i {
                color: white; /* צבע האייקון */
                font-size: 20px; /* גודל האייקון */
                line-height: 1; /* התאמה כדי למנוע ריווח מיותר */
            }

            .add-button:hover {
                background-color: white; /* צבע רקע לבן במצב ריחוף */
                color: #6f42c1; /* צבע טקסט סגול במצב ריחוף */
            }




        .export-button {
            width: 40px; /* רוחב הכפתור */
            height: 40px; /* גובה הכפתור */
            border-radius: 50%; /* פינות מעוגלות */
            border: none; /* הסרת גבול */
            background-color: #33214b00; /* צבע רקע אפור כהה */
            color: white; /* צבע טקסט לבן */
            font-size: 32px; /* גודל פונט */
            cursor: pointer; /* שינוי סמן העכבר לידית */
            display: flex; /* תצוגת Flexbox */
            align-items: center; /* יישור אנכי למרכז */
            justify-content: center; /* יישור אופקי למרכז */
            transition: background-color 0.3s, color 0.3s; /* מעבר חלק של 0.3 שניות לשינוי הצבע */
            margin-right: 10px; /* ריווח ימני */
        }

            .export-button i {
                color: white; /* צבע האייקון */
                font-size: 20px; /* גודל האייקון */
            }

            .export-button:hover {
                background-color: white; /* צבע רקע לבן במצב ריחוף */
                color: #6f42c1; /* צבע טקסט סגול במצב ריחוף */
            }

                .export-button:hover i {
                    color: #6f42c1; /* צבע האייקון סגול במצב ריחוף */
                }

        .delete-button-Multiple {
            border: none;
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 600;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 36px;
            width: 80px; /* שינוי לרוחב קבוע */
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .delete-button-Multiple {
            background-color: #dc3545;
        }

            .delete-button-Multiple:hover {
                background-color: #c82333;
                transform: translateY(-2px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .delete-button-Multiple i {
                font-size: 18px; /* גודל האייקון */
            }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="UnderFooter" runat="server">
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

    <script>
        // פונקציית חיפוש - סינון לקוחות לפי טקסט בשדה החיפוש
        function filterContacts() {
            var input, filter, table, tr, td, i, j, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toLowerCase();
            table = document.getElementById("contact_list_table");
            tr = table.getElementsByTagName("tr");

            for (i = 1; i < tr.length; i++) { // התחל מ-1 כדי לדלג על הכותרת
                tr[i].style.display = "none"; // הסתר את כל השורות תחילה
                td = tr[i].getElementsByTagName("td");
                for (j = 0; j < td.length; j++) {
                    if (td[j]) {
                        txtValue = td[j].textContent || td[j].innerText;
                        if (txtValue.toLowerCase().indexOf(filter) > -1) {
                            tr[i].style.display = ""; // הצג את השורה אם נמצא טקסט תואם
                            break;
                        }
                    }
                }
            }
        }

        // פונקציה לפתיחת מודאל הוספת מנהל
        function openModalAdd() {
            var modal = document.getElementById('SerProdModal');
            var title = document.getElementById('modalTitle');
            var btnSave = document.getElementById('<%= btnSave.ClientID %>');
            title.innerText = 'הוספת מנהל';
            btnSave.value = 'הוסף מנהל';
            // ניקוי שדות הטופס
            document.getElementById('<%= hfSerProdId.ClientID %>').value = '';
            document.getElementById('<%= txtDesc.ClientID %>').value = '';
            document.getElementById('<%= txtPrice.ClientID %>').value = '';
            document.getElementById('<%= txtNameImage.ClientID %>').value = '';
            document.getElementById('<%= txtNots.ClientID %>').value = '';
            modal.style.display='block'
        }

        // פונקציה לפתיחת מודאל עריכת לקוח
        function openModalEdit(serprod) {
            var modal = document.getElementById('SerProdModal');
            var title = document.getElementById('modalTitle');
            var btnSave = document.getElementById('<%= btnSave.ClientID %>');
            title.innerText = 'עריכת מנהל';
            btnSave.value = 'שמור שינויים';
            // מילוי שדות הטופס בנתוני הלקוח
            document.getElementById('<%= hfSerProdId.ClientID %>').value = serprod.SerProdId;
            document.getElementById('<%= txtDesc.ClientID %>').value = serprod.Desc;
            document.getElementById('<%= txtPrice.ClientID %>').value = serprod.Price;
            document.getElementById('<%= txtNameImage.ClientID %>').value = serprod.NameImage;
            document.getElementById('<%= txtNots.ClientID %>').value = serprod.Nots;
            modal.style.display = 'block';
        }

        function closeModal() {
            var modal = document.getElementById('SerProdModal');
            modal.style.display = 'none';
        }

        function SaveSerProd() {
            console.log("פונקציית SaveSerProd התחילה");
            var data = {
                SerProdId: $('#<%= hfSerProdId.ClientID %>').val(),
                Desc: $('#<%= txtDesc.ClientID %>').val(),
                Price: $('#<%= txtPrice.ClientID %>').val(),
                NameImage: $('#<%= txtNameImage.ClientID %>').val(),
                Nots: $('#<%= txtNots.ClientID %>').val(),               
            };

            console.log("נתונים שנאספו:", JSON.stringify(data));

            var method = data.SerProdId === "" ? "POST" : "PUT";
            var url = method === "POST" ? "/api/SerProd" : "/api/SerProd/" + data.SerProdId;

            console.log(`שולח בקשת ${method} ל-${url}`);

            $.ajax({
                type: "POST",
                url: "/api/SerProdController/Post",
                data: JSON.stringify({ serprodData: data }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("תגובה התקבלה בהצלחה:", response);
                    alert("הלקוח נשמר בהצלחה");
                    closeModal();
                    refreshserprodTable();
                },
                error: function (xhr, status, error) {
                    console.error("שגיאה בשמירת הלקוח:", status, error);
                    console.log("תגובת השרת:", xhr.responseText);
                    alert("אירעה שגיאה בשמירת הלקוח: " + error);
                }
            });
        }

        function refreshserprodTable() {
            $.ajax({
                type: "GET",
                url: "/api/SerProd",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (serprod) {
                    var tableBody = $("#serprodTable tbody");
                    tableBody.empty();
                    for (var i = 0; i < serprod.length; i++) {
                        var serprod = serprod[i];
                        var row = "<tr>" +
                            "<td>" + serprod.Desc + "</td>" +
                            "<td>" + serprod.Price + "</td>" +
                            "<td>" + serprod.NameImage + "</td>" +
                            "<td>" + serprod.Nots + "</td>" +
                            "<td>" + (serprod.Status ? "פעיל" : "לא פעיל") + "</td>" +

                            "<td><button onclick='editserprod(" + serprod.SerProdId + ")'>עריכה</button>" +
                            "<button onclick='deleteserprod(" + serprod.SerProdId + ")'>מחיקה</button></td>" +
                            "</tr>";
                        tableBody.append(row);
                    }
                },
                error: function (error) {
                    console.log(error);
                    alert("אירעה שגיאה בטעינת הנתונים");
                }
            });
        }

        function editserprod(serprodId) {
            console.log('נכנס לפונקציית editserprod');
            console.log('מזהה לקוח:', serprodId);

            $.ajax({
                type: "GET",
                url: "/api/SerProdController/Put" + serprodId,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (serprod) {
                    console.log('נתוני הלקוח התקבלו בהצלחה:', serprod);

                    $('#<%= hfSerProdId.ClientID %>').val(serprod.SerProdId);
                    console.log('SerProdId הוגדר:', serprod.SerProdId);

                    $('#<%= txtDesc.ClientID %>').val(serprod.Desc);
                    console.log('Desc הוגדר:', serprod.Desc);

                    $('#<%= txtPrice.ClientID %>').val(serprod.Price);
                    console.log('Price הוגדר:', serprod.Price);

                    $('#<%= txtNameImage.ClientID %>').val(serprod.NameImage);
                    console.log('NameImage הוגדר:', serprod.NameImage);

                    $('#<%= txtNots.ClientID %>').val(serprod.Nots);
                    console.log('Nots הוגדר:', serprod.Nots);

                    // DateAdd נמחק או הוסתר
                    // console.log('DateAdd הוגדר:', customer.DateAdd);


                    $('#SerProdModal').show();
                    console.log('מודל המנהלים נפתח');
                },
                error: function (xhr, status, error) {
                    console.error('שגיאה בטעינת פרטי המנהל:', status, error);
                    console.log('תגובת השרת:', xhr.responseText);
                    alert("אירעה שגיאה בטעינת פרטי המנהל");
                }
            });

            console.log('סיום פונקציית editserprod');
        }



        // פונקציית מחיקה
        function deleteserprod(SerProdId) {
            if (confirm('Are you sure you want to delete this serprod?')) {
                // קריאה לשרת למחיקת הלקוח (AJAX או POSTBACK)
                console.log('Deleting serprod with ID:', SerProdId);
            }
        }

        $(document).ready(function () {
            console.log("Document is ready");

            var table = $('#contact_list_table').DataTable({
                "dom": '<"top">rt<"bottom"><"clear">', // הסרת "search" ו-"length"
                "paging": false, // ביטול פאגינציה
                "info": false // הסרת המידע בתחתית הטבלה
            });
            console.log("DataTable initialized");

            $('.toggle-vis').on('change', function (e) {
                console.log("Checkbox changed");
                var column = table.column($(this).attr('data-column'));
                console.log("Toggling visibility for column: " + $(this).attr('data-column'));
                column.visible(!column.visible());
                e.stopPropagation(); // מניעת התפשטות האירוע כדי למנוע סגירת הדרופדאון
            });

            // מניעת סגירת הדרופדאון כאשר לוחצים על הסליידר
            $('.dropdown-menu').on('click', function (e) {
                console.log("Dropdown menu clicked");
                e.stopPropagation();
            });

            $('#dropdownMenuButton').on('click', function () {
                console.log("Dropdown button clicked");
            });

            $('.dropdown-toggle').on('click', function () {
                console.log("Dropdown toggle clicked");
            });

            // וודא שהתפריט נסגר כאשר לוחצים מחוץ לו
            $(document).on('click', function (e) {
                if (!$(e.target).closest('.dropdown').length) {
                    $('.dropdown-menu').removeClass('show');
                }
            });

            // הוסף לוג כדי לבדוק אם התפריט נפתח
            $('#dropdownMenuButton').on('click', function () {
                console.log("Dropdown button clicked");
                $('.dropdown-menu').toggleClass('show');
            });
        });



        // פונקציה ליצוא הנתונים לטבלת Excel
        function exportTableToExcel(tableID, filename = '') {
            var table = document.getElementById(tableID);
            var workbook = XLSX.utils.table_to_book(table, { sheet: "Sheet1" });
            filename = filename ? filename + '.xlsx' : 'excel_data.xlsx';
            XLSX.writeFile(workbook, filename);
        }
        // פונקציה לסימון כל השורות כאשר לוחצים על תיבת הסימון הכללית
        $(document).ready(function () {

            $('#selectAll').on('click', function () {
                $('.selectRow').prop('checked', this.checked);
                toggleDeleteButton();
            });

            // פונקציה לבדיקת תיבת הסימון הכללית כאשר כל השורות מסומנות או לא
            $('.selectRow').on('click', function () {
                if ($('.selectRow:checked').length === $('.selectRow').length) {
                    $('#selectAll').prop('checked', true);
                } else {
                    $('#selectAll').prop('checked', false);
                }
                toggleDeleteButton();
            });
        });

        // פונקציה להציג או להסתיר את כפתור המחיקה
        function toggleDeleteButton() {
            if ($('.selectRow:checked').length > 1) {
                $('#deleteContainer').show();
            } else {
                $('#deleteContainer').hide();
            }
        }

        // פונקציה למחיקת כל השורות הנבחרות
        function deleteSelectedRows() {
            var selectedIds = [];
            $('.selectRow:checked').each(function () {
                selectedIds.push(parseInt($(this).val()));
            });

            if (selectedIds.length > 0) {
                if (confirm('Are you sure you want to delete the selected items?')) {
                    // קריאה לשרת למחיקת הרשומות (AJAX)
                    $.ajax({
                        type: "POST",
                        url: "SerProdList.aspx/Deleteserprod",
                        data: JSON.stringify({ ids: selectedIds }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            alert('serprod deleted successfully');
                            location.reload(); // רענון הדף לאחר המחיקה
                        },
                        error: function (response) {
                            alert('Error deleting serprod');
                            console.error('Error response:', response); // הודעת שגיאה
                            console.error('JSON data sent:', JSON.stringify({ ids: selectedIds })); // JSON שנשלח

                            // הדפסת תוכן התגובה מהשרת
                            if (response.responseText) {
                                console.error('Server response text:', response.responseText);
                            }
                        }
                    });
                }
            } else {
                alert('Please select at least one item to delete.');
            }
        }




        // זהו קוד שמנהל את הייצוג החזותי של מעמד הטכנאי (פעיל/לא פעיל) ומסנכרן אותו עם מסד הנתונים דרך שיחות AJAX כאשר מתבצעת החלפת המעמד.
        document.addEventListener('DOMContentLoaded', function () {
            const rows = document.querySelectorAll('.row-status');

            rows.forEach(row => {
                const status = row.getAttribute('data-status');
                const SerProdId = row.getAttribute('data-SerProd-id');
                const button = row.querySelector('.status-button');

                if (status === 'True' || status === 'true') {
                    button.classList.add('status-active');
                    button.textContent = 'פעיל';
                } else {
                    button.classList.add('status-inactive');
                    button.textContent = 'לא פעיל';
                    row.classList.add('row-inactive');
                }

                button.addEventListener('click', function () {
                    const newStatus = !button.classList.contains('status-active');

                    if (newStatus) {
                        button.classList.remove('status-inactive');
                        button.classList.add('status-active');
                        button.textContent = 'פעיל';
                        row.classList.remove('row-inactive');
                    } else {
                        button.classList.remove('status-active');
                        button.classList.add('status-inactive');
                        button.textContent = 'לא פעיל';
                        row.classList.add('row-inactive');
                    }

                    updateStatusInDatabase(serprodId, newStatus);
                });
            });

            function updateStatusInDatabase(SerProdId, Status) {
                console.log("Updating status for SerProdId: " + SerProdId + " to Status: " + Status); // הדפסה לצורכי דיבוג

                $.ajax({
                    type: "POST",
                    url: "SerProdList.aspx/UpdateserprodStatus",
                    data: JSON.stringify({ SerProdId: SerProdId, Status: Status }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log('Success:', response);
                    },
                    error: function (error) {
                        console.error('Error:', error);
                    }
                });
            }
        });


    </script>
</asp:Content>
