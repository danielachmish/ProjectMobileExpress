<%@ Page Title="" Language="C#" MasterPageFile="~/TechniciansFolder/MainMaster.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="MobileExpress.TechniciansFolder.TechnicianNotifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <h2>התראות חדשות</h2>
        <asp:GridView ID="gvNotifications" runat="server" 
            AutoGenerateColumns="False"
            DataKeyNames="NotificationId,ReadId"
            CssClass="notifications-grid"
            OnRowCommand="gvNotifications_RowCommand">
            <Columns>
                <asp:BoundField DataField="DateCreated" HeaderText="תאריך" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:BoundField DataField="FullName" HeaderText="שם לקוח" />
                <asp:BoundField DataField="Phone" HeaderText="טלפון" />
                <asp:BoundField DataField="Desc" HeaderText="תיאור התקלה" />
                <asp:ButtonField ButtonType="Button" CommandName="ViewCall" Text="צפה בקריאה" />
            </Columns>
        </asp:GridView>
    </div>

     <style>
        .notifications-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .notifications-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .notifications-grid th {
            background-color: #f3f4f6;
            padding: 12px;
            text-align: right;
            border: 1px solid #e5e7eb;
        }

        .notifications-grid td {
            padding: 12px;
            border: 1px solid #e5e7eb;
        }

        .notifications-grid tr:hover {
            background-color: #f9fafb;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
