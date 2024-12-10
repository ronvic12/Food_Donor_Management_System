<%@ Page Title ="Recipient" Language="C#" MasterPageFile="~/Dashboards.Master" AutoEventWireup="true" CodeBehind="RecipientDashboard.aspx.cs" Inherits="Food_Donor_Management_System.RecipientDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="DashboardContent" runat="server">

    <h2>Available Food Items</h2>
    <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>
<asp:GridView ID="gvAvailableFood" runat="server" AutoGenerateColumns="False" OnRowCommand="gvAvailableFood_RowCommand" DataKeyNames="FoodItemID">
    <Columns>
        <asp:BoundField DataField="FoodItemID" HeaderText="Food Item ID" Visible="false" />
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
        <asp:BoundField DataField="FoodCategory" HeaderText="Food Category" />
        <asp:BoundField DataField="FoodName" HeaderText="Food Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" />
        <asp:BoundField DataField="ExpirationDate" HeaderText="Expiration Date" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false"/>
        <asp:BoundField DataField="Status" HeaderText="Status" />
        <asp:ButtonField CommandName="Request" Text="Request" ButtonType="Button" />

    </Columns>

</asp:GridView>

    </asp:Content>
