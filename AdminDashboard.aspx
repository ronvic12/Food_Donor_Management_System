<%@ Page Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="Food_Donor_Management_System.AdminDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>User Management</h2>
<asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" OnRowCommand="gvUsers_RowCommand">
    <Columns>
        <asp:BoundField DataField="Name" HeaderText="Name" />
        <asp:BoundField DataField="Email" HeaderText="Email" />
        <asp:BoundField DataField="Role" HeaderText="Role" />
        <asp:ButtonField CommandName="Delete" Text="Delete" ButtonType="Button" />
    </Columns>
</asp:GridView>

<h2>Donation and Request Statistics</h2>
<asp:Label ID="lblStats" runat="server" />

</asp:Content>
