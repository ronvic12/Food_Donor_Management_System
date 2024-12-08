<%@ Page Title="DonorDashboard" Language="C#" AutoEventWireup="true" MasterPageFile="~/Dashboards.Master"  CodeBehind="DonorDashboard.aspx.cs" Inherits="Food_Donor_Management_System.DonorDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="DashboardContent" runat="server">
  <h2 style="text-align: center;">Donate Food</h2>
<form style="max-width: 600px; margin: 0 auto; background-color: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">

     <div style="margin-bottom: 15px;">
         <asp:Label runat="server" AssociatedControlID="ddlCategories" style="display: block; font-weight: bold; margin-bottom: 5px;">Food Category</asp:Label>
            <asp:DropDownList ID="ddlCategories" runat="server" CssClass="form-control"></asp:DropDownList>
     </div>

    <div style="margin-bottom: 15px;">
        <asp:Label runat="server" AssociatedControlID="txtFoodName" style="display: block; font-weight: bold; margin-bottom: 5px;">Food Name</asp:Label>
        <asp:TextBox ID="txtFoodName" runat="server" Placeholder="Enter food name" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
    </div>

    <div style="margin-bottom: 15px;">
        <asp:Label runat="server" AssociatedControlID="txtQuantity" style="display: block; font-weight: bold; margin-bottom: 5px;">Quantity</asp:Label>
        <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" min="1" max="100" step="1" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
    </div>

    <div style="margin-bottom: 15px;">
        <asp:Label runat="server" AssociatedControlID="txtDescription" style="display: block; font-weight: bold; margin-bottom: 5px;">Description(Optional)</asp:Label>
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Placeholder="Describe the food item" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; height: 100px;"></asp:TextBox>
    </div>

    <div style="margin-bottom: 15px;">
        <asp:Label runat="server" AssociatedControlID="txtExpiryDate" style="display: block; font-weight: bold; margin-bottom: 5px;">Expired Date</asp:Label>
        <asp:TextBox ID="txtExpiryDate" runat="server" TextMode="Date" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
    </div>

    <div style="margin-bottom: 15px;">
        <asp:Label runat="server" AssociatedControlID="txtdropoffDateTime" style="display: block; font-weight: bold; margin-bottom: 5px;">Date and Time to Drop Off</asp:Label>
        <asp:TextBox ID="txtdropoffDateTime" runat="server" TextMode="DateTimeLocal" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
    </div>

    <div style="text-align: center;">
        <asp:Button ID="btnAddFood" runat="server" Text="Add Food" OnClick="btnAddFood_Click" style="background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px;" />
          <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>
    </div>

</form>



    </asp:Content>
