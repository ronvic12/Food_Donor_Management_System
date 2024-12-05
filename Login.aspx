<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Food_Donor_Management_System.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:TextBox ID="txtEmail" runat="server" Placeholder="Email"></asp:TextBox>
<asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>
<asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
      <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
    </asp:Content>