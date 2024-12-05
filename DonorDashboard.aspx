<%@ Page Title="DonorDashboard" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master"  CodeBehind="DonorDashboard.aspx.cs" Inherits="Food_Donor_Management_System.DonorDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Donate Food</h2>

    <asp:TextBox ID="txtFoodName" runat="server" Placeholder="Food Name"></asp:TextBox>
    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Placeholder="Description"></asp:TextBox>
    <asp:TextBox ID="txtExpiryDate" runat="server" TextMode="Date"></asp:TextBox>
    <asp:Button ID="btnAddFood" runat="server" Text="Add Food" OnClick="btnAddFood_Click" />

<h2>Your Donations</h2>
<asp:GridView ID="gvDonatedFood" runat="server" AutoGenerateColumns="False">
    <Columns>
        <asp:BoundField DataField="Name" HeaderText="Food Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" />
        <asp:BoundField DataField="ExpiryDate" HeaderText="Expiry Date" />
        <asp:BoundField DataField="Status" HeaderText="Status" />
    </Columns>
</asp:GridView>
    </asp:Content>
