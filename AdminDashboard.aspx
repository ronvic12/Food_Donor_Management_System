<%@ Page Language="C#"  MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="Food_Donor_Management_System.AdminDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminContent" runat="server">
    <div class="dashboard_container">
            <div class ="dashboard_table">
      
            <asp:Panel ID="pnlDonorDashboard" runat="server" Width="100%">
            <h2 style="text-align: center;">Donor Dashboard: Drop Off Appointments</h2>

            <div id="appointmentsContainer">
                <div class="appointmentGroup">
                    <h3 class="appointmentDate">Today, December 6</h3>
                    <asp:Repeater ID="rptTodayAppointments" runat="server">
                        <ItemTemplate>
                            <div class="appointment">
                                <span class="donorName"><%# Eval("DonorName") %></span>
                                <span class="appointmentTime"><%# Eval("AppointmentTime") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
                </asp:Panel>

            </div>
       
            <div class ="dashboard_table">
                    <asp:Panel ID="pnlRecipientDashboard" runat="server" Width="100%">
                    <h2 style="text-align: center;">Recipient  Dashboard: Food Requests</h2>

                          <div id="recipientContainer">
                              <div class="recipientGroup">
                                  <h3 class="recipientRequests">Pending Requests</h3>
                                  <asp:Repeater ID="rptPendingRequests" runat="server">
                                      <ItemTemplate>
                                          <div class="requests">
                                              <span class="recipientName"><%# Eval("DonorName") %></span>
                                              <span class="recipientFood"><%# Eval("AppointmentTime") %></span>
                                          </div>
                                      </ItemTemplate>
                                  </asp:Repeater>
                              </div>
                          </div>
                </asp:Panel>
            </div>

     
           
            <div class ="dashboard_table">
                            <asp:Panel ID="pnlInventoryDashboard" runat="server" Width="100%">
                        <h2 style="text-align: center;">Inventory Dashboard</h2>

                      <div id="inventoryContainer">
                          <div class="inventoryGroup">
                              <h3 class="available">Available</h3>
                              <asp:Repeater ID="rptInventory" runat="server">
                                  <ItemTemplate>
                                      <div class="inventory">
                                          <span class="inventoryName"><%# Eval("DonorName") %></span>
                                          <span class="inventoryFood"><%# Eval("AppointmentTime") %></span>
                                      </div>
                                  </ItemTemplate>
                              </asp:Repeater>
                          </div>
                      </div>
            </asp:Panel>
          
            </div>


      
            
            <div class ="dashboard_table">
                 <asp:Panel ID="donationDashboard" runat="server" Width="100%">
                        <h2 style="text-align: center;">Donation Status</h2>

                      <div id="donationContainer">
                          <div class="donationGroup">
                              <h3 class="deliver">Ready to Deliver</h3>
                              <asp:Repeater ID="rptdonation" runat="server">
                                  <ItemTemplate>
                                      <div class="donation">
                                          <span class="donationName"><%# Eval("DonorName") %></span>
                                          <span class="donationFood"><%# Eval("AppointmentTime") %></span>
                                      </div>
                                  </ItemTemplate>
                              </asp:Repeater>
                          </div>
                      </div>
                </asp:Panel>
            </div>
         
      </div>
</asp:Content>
