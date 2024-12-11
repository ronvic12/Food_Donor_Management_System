<%@ Page Title="DonorDashboard" Language="C#" AutoEventWireup="true" MasterPageFile="~/Dashboards.Master"  CodeBehind="DonorDashboard.aspx.cs" Inherits="Food_Donor_Management_System.DonorDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="DashboardContent" runat="server">

    
   
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
     

    <div>
            <h2>Food Donation List</h2>
        <asp:GridView ID="gvFoodItems" runat="server" AutoGenerateColumns="False">
    <Columns>
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
        <asp:BoundField DataField="FoodCategory" HeaderText="Food Category" />
        <asp:BoundField DataField="FoodName" HeaderText="Food Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" />
        <asp:BoundField DataField="ExpirationDate" HeaderText="Expiration Date" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false"/>
    </Columns>

</asp:GridView>

    </div>
    
    <div class ="fooddonationContainer">
        <!-- Button to trigger the modal -->
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#donateFoodModal">
          Donate Food
        </button>

                <!-- Modal -->
                <div class="modal fade" id="donateFoodModal" tabindex="-1" aria-labelledby="donateFoodModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title" id="donateFoodModalLabel">Donate Food</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <div class="modal-body">
                        <form style="background-color: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">

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

                        </form>
                      </div>
                      <div class="modal-footer">
                        <asp:Button ID="btnAddFood" runat="server" Text="Add Food" OnClick="btnAddFood_Click" style="background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px;" />
                        <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>
                      </div>
                    </div>
                  </div>
                </div>

                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAppointmentModal">
                    Setup Drop off Time
                  </button>

                <div class="modal fade" id="addAppointmentModal" tabindex="-1" aria-labelledby="addAppointmentModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addAppointmentModalLabel">Setup Drop Off Time</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <asp:GridView ID="gvModalFoodItem" runat="server" AutoGenerateColumns="False">
                                <Columns>
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                    <asp:BoundField DataField="FoodCategory" HeaderText="Food Category" />
                                    <asp:BoundField DataField="FoodName" HeaderText="Food Name" />
                                    <asp:BoundField DataField="Description" HeaderText="Description" />
                                    <asp:BoundField DataField="ExpirationDate" HeaderText="Expiration Date" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false" />
                                </Columns>
                            </asp:GridView>
                            <hr />
                                <div class="mb-3">
                                    <label for="txtAppointmentTime" class="form-label">Drop Off Time</label>
                                    <asp:TextBox ID="txtdropoffDateTime" runat="server" TextMode="DateTimeLocal" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
                                     <asp:Label ID=sucessMsg runat="server" CssClass="text-success"></asp:Label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <asp:Button ID="btnSaveDropOffTime" runat="server" CssClass="btn btn-primary" Text="Save Drop-Off Time" OnClick="SaveAppointment_Click" />
                            </div>
                        </div>
                    </div>
                </div>
        </div>
    </asp:Content>
