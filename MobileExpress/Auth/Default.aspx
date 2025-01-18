<%@ Page Title="" Language="C#" MasterPageFile="~/Auth/AuthMaster.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MobileExpress.Auth.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <div class="auth-choice">
        <h1>ברוכים הבאים</h1>
        <div class="buttons">
            <a href="Login/CustomerLogin.aspx" class="btn">כניסת לקוחות</a>
            <a href="Login/TechnicianLogin.aspx" class="btn">כניסת טכנאים</a>
            <a href="Login/AdminLogin.aspx" class="btn">כניסת מנהלים</a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
</asp:Content>
