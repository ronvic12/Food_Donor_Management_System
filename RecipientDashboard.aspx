<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecipientDashboard.aspx.cs" Inherits="Food_Donor_Management_System.RecipientDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Available Food Items</h2>
<asp:GridView ID="gvAvailableFood" runat="server" AutoGenerateColumns="False" OnRowCommand="gvAvailableFood_RowCommand">
    <Columns>
        <asp:BoundField DataField="Name" HeaderText="Food Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" />
        <asp:BoundField DataField="ExpiryDate" HeaderText="Expiry Date" />
        <asp:ButtonField CommandName="Request" Text="Request" ButtonType="Button" />
    </Columns>
</asp:GridView>

    </asp:Content>
