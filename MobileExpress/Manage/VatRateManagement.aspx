<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/MainMaster.Master" AutoEventWireup="true" CodeBehind="VatRateManagement.aspx.cs" Inherits="MobileExpress.Manage.VatRateManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
      <!-- קישורים ל-CSS של Bootstrap ול-Font Awesome לצורך עיצוב מתקדם ואייקונים -->
    <link rel="stylesheet" href="assets/css/styles.css">
    <!-- קישורים נוספים כמו Bootstrap ו-Font Awesome -->

    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metisMenu/2.7.9/metisMenu.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <form id="form1" runat="server">
        <div class="card card-icon-bg card-icon-bg-primary o-hidden mb-4">
            <div class="card-body">
                <div class="row">
                    <div class="col-8">
                        <h5 class="text-muted mb-2">אחוז מע"מ נוכחי</h5>
                        <asp:Label ID="lblCurrentVat" runat="server" CssClass="text-primary text-24" />
                    </div>
                    <div class="col-4">
                        <div class="form-group">
                            <asp:TextBox ID="txtNewVatRate" runat="server" CssClass="form-control" 
                                        placeholder="הכנס אחוז מע״מ חדש" type="number" step="0.01" />
                            <asp:Button ID="btnUpdateVat" runat="server" Text="עדכן מע״מ" 
                                      CssClass="btn btn-primary mt-2" OnClick="btnUpdateVat_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <%-- אם אתה משתמש ב-ScriptManager, הוסף אותו כאן --%>
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="UnderFooter" runat="server">
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
        function validateVatRate() {
            var vatRate = document.getElementById('<%= txtNewVatRate.ClientID %>').value;
            if (vatRate < 0 || vatRate > 100) {
                alert('אנא הכנס ערך בין 0 ל-100');
                return false;
            }
            return true;
        }
    </script>


</asp:Content>
