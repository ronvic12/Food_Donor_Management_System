<%@ Page Title ="Recipient" Language="C#" MasterPageFile="~/Dashboards.Master" AutoEventWireup="true" CodeBehind="RecipientDashboard.aspx.cs" Inherits="Food_Donor_Management_System.RecipientDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="DashboardContent" runat="server">

    <style>
     .gridview-style th, .gridview-style td {
        border: 2px solid black;
        padding: 5px;
    }
    .gridview-style {
        border-collapse: collapse;
    }

      .request-button {
        background-color: #4CAF50;  /* Green background */
        color: white;               /* White text */
        padding: 8px 20px;         /* Padding around the button */
        border: 1px solid black;    /* Border around the button */
        border-radius: 5px;         /* Rounded corners */
        cursor: pointer;           /* Change cursor to pointer */
        text-align: center;         /* Center text */
        font-size: 16px;            /* Font size */
    }

    .request-button:hover {
        background-color: #45a049;  /* Darker green on hover */
    }
</style>

    <h2>Available Food Items</h2>
    <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>
<asp:GridView ID="gvAvailableFood" runat="server" AutoGenerateColumns="False" 
    OnRowCommand="gvAvailableFood_RowCommand" DataKeyNames="FoodItemID" 
    CssClass="gridview-style"> 
    <Columns>
        <asp:BoundField DataField="FoodItemID" HeaderText="Food Item ID" Visible="false" />
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
        <asp:BoundField DataField="FoodCategory" HeaderText="Food Category" />
        <asp:BoundField DataField="FoodName" HeaderText="Food Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" />
        <asp:BoundField DataField="ExpirationDate" HeaderText="Expiration Date" 
            DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false"/>
        <asp:BoundField DataField="Status" HeaderText="Status" />
        <asp:ButtonField CommandName="Request" HeaderText="Request Food Item" Text="Request" ButtonType="Button" ControlStyle-CssClass="request-button"/>
    </Columns>
</asp:GridView>



    </asp:Content>
