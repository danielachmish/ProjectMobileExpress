<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/MainMaster.Master" AutoEventWireup="true" CodeBehind="PageContentList.aspx.cs" Inherits="MobileExpress.Manage.PageContentList" %>
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
     <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .action-buttons button {
            margin: 0 5px;
        }
    </style>

      <div class="breadcrumb" style="direction: rtl;">
        <h1>ניהול תוכן עמוד</h1>
    </div>
    <div class="separator-breadcrumb border-top"></div>

    <!-- Add Content Button -->
    <button class="btn btn-primary mb-3" onclick="openModalAdd()">+ הוספת תוכן</button>

    <!-- DataTable -->
    <div class="table-responsive">
        <table id="pageContentTable" class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Section Name</th>
                    <th>Content</th>
                    <th>Last Updated</th>
                    <th>Active</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%-- Data to be populated dynamically using Repeater or AJAX --%>
                <asp:Repeater ID="RepeaterPageContent" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("Id") %></td>
                            <td><%# Eval("SectionName") %></td>
                            <td><%# Eval("Content") %></td>
                            <td><%# Eval("LastUpdated", "{0:yyyy-MM-dd}") %></td>
                            <%--<td><%# Eval("IsActive") ? "Yes" : "No" %></td>--%>
                            <td>
                                <button class="btn btn-warning btn-sm" onclick="openModalEdit('<%# Eval("Id") %>', '<%# Eval("SectionName") %>', '<%# Eval("Content") %>', '<%# Eval("IsActive") %>')">עריכה</button>
                                <button class="btn btn-danger btn-sm" onclick="deletePageContent('<%# Eval("Id") %>')">מחיקה</button>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>

    <!-- Modal for Adding/Editing Content -->
    <div id="pageContentModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modalTitle">הוספת/עריכת תוכן</h2>

            <asp:HiddenField ID="hfPageContentId" runat="server" />
            <div class="form-group">
                <asp:Label AssociatedControlID="txtSectionName" runat="server">שם המקטע:</asp:Label>
                <asp:TextBox ID="txtSectionName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Label AssociatedControlID="txtContent" runat="server">תוכן:</asp:Label>
                <asp:TextBox ID="txtContent" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Label AssociatedControlID="chkIsActive" runat="server">פעיל:</asp:Label>
                <asp:CheckBox ID="chkIsActive" runat="server" />
            </div>

            <button class="btn btn-success" onclick="savePageContent()">שמור</button>
            <button class="btn btn-secondary" onclick="closeModal()">ביטול</button>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="UnderFooter" runat="server">
     <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.3/js/dataTables.bootstrap4.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#pageContentTable').DataTable();
        });

        function openModalAdd() {
            $('#hfPageContentId').val('');
            $('#txtSectionName').val('');
            $('#txtContent').val('');
            $('#chkIsActive').prop('checked', false);
            $('#modalTitle').text('הוספת תוכן');
            $('#pageContentModal').show();
        }

        function openModalEdit(id, sectionName, content, isActive) {
            $('#hfPageContentId').val(id);
            $('#txtSectionName').val(sectionName);
            $('#txtContent').val(content);
            $('#chkIsActive').prop('checked', isActive === 'True');
            $('#modalTitle').text('עריכת תוכן');
            $('#pageContentModal').show();
        }

        function closeModal() {
            $('#pageContentModal').hide();
        }

        function savePageContent() {
            // Logic to save data using AJAX or server-side code
            alert('תוכן נשמר בהצלחה!');
            closeModal();
        }

        function deletePageContent(id) {
            if (confirm('האם אתה בטוח שברצונך למחוק את התוכן?')) {
                // Logic to delete content
                alert('תוכן נמחק בהצלחה!');
            }
        }
    </script>
</asp:Content>
