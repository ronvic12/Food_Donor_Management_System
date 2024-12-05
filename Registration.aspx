<%@ Page Title="Registration" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="Food_Donor_Management_System.Registration" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:TextBox ID="txtName" runat="server" Placeholder="Name"></asp:TextBox>
<asp:TextBox ID="txtEmail" runat="server" Placeholder="Email"></asp:TextBox>
<asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>
<asp:DropDownList ID="ddlRole" runat="server">
    <asp:ListItem Text="Donor" Value="Donor" />
    <asp:ListItem Text="Recipient" Value="Recipient" />
</asp:DropDownList>

    <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" />
    <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
    </asp:Content>
