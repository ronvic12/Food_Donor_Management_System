<%@ Page Language="C#"  MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="Food_Donor_Management_System.AdminDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminContent" runat="server">
        <!-- Hidden Fields for Submitting Food Item Decision -->
        <asp:HiddenField ID="FoodItemID" runat="server" />
        <asp:HiddenField ID="Decision" runat="server" />

            <!-- Include Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

        <!-- Include jQuery (needed for Bootstrap 4 modals) -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>

        <!-- Include Bootstrap JS -->
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Helper function to format the date
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString(); // Formats the date to a local format, e.g., "12/8/2024"
        }
        // Function to update the food item's status
          function submitDecision(foodItemID, decision) {
            // Get hidden fields by their ASP.NET generated Client IDs
            document.getElementById('<%= FoodItemID.ClientID %>').value = foodItemID;
            document.getElementById('<%= Decision.ClientID %>').value = decision;

           var statusElement = document.getElementById("status_" + foodItemID);
            if (statusElement) {
                if (decision === "Approve") {
                    statusElement.textContent = "Available";  // Update status to Available
                } else if (decision === "Reject") {
                    statusElement.textContent = "Rejected";  // Update status to Rejected
                }
            }

            // Submit the form
            __doPostBack('', 'SubmitDecision');
        }

        // consider refactor code later, to be more efficient and readable
        function showFoodDetails(foodItemsJSON) {

            const foodItems = JSON.parse(foodItemsJSON);
            // Get the container for food details
            const container = document.getElementById("foodDetailsContainer");
            // Clear previous content
            container.innerHTML = "";

            // Create a table element
            const table = document.createElement("table");
            table.style.borderCollapse = "collapse";
            table.style.width = "100%";


            // Create the table header
            const headerRow = document.createElement("tr");
            const headers = ["Category", "Name", "Description", "Quantity", "Expiration Date", "Status","Approved/Reject FoodItem?"];
            headers.forEach(headerText => {
                const th = document.createElement("th");
                th.textContent = headerText;
                th.style.border = "1px solid #ddd";
                th.style.padding = "8px";
                th.style.textAlign = "left";
                th.style.backgroundColor = "#f2f2f2";
                headerRow.appendChild(th);
            });
            table.appendChild(headerRow);


            // Populate the table with food details
            foodItems.forEach(item => {
                const row = document.createElement("tr");

                const values = [
                    item.FoodCategory,
                    item.FoodName,
                    item.Description,
                    item.Quantity,
                    formatDate(item.ExpirationDate),
                    item.Status
                ];

                values.forEach(value => {
                    const td = document.createElement("td");
                    td.textContent = value;
                    td.style.border = "1px solid #ddd";
                    td.style.padding = "8px";
                    row.appendChild(td);
                });
                
                // Approve/Reject Buttons
                  const actionTd = document.createElement("td");
                  const approveButton = document.createElement("button");
                  approveButton.textContent = "Approve";
                  approveButton.style.marginRight = "5px";
                  approveButton.onclick = () => submitDecision(item.FoodItemID, "Approve");

                  const rejectButton = document.createElement("button");
                  rejectButton.textContent = "Reject";
                  rejectButton.onclick = () => submitDecision(item.FoodItemID, "Reject");

                  actionTd.appendChild(approveButton);
                  actionTd.appendChild(rejectButton);

                row.appendChild(actionTd);
                table.appendChild(row);
            });
                   
          
            // Append the table to the container
            container.appendChild(table);
        }
        function showInventory(inventoryJSON) {
            const inventory = JSON.parse(inventoryJSON);
            console.log(inventory);
            // Get the container for food details
            const container = document.getElementById("inventoryDetailsContainer");
            // Clear previous content
            while (container.firstChild) {
                container.removeChild(container.firstChild);
            }

            // using DOM elements to create a inventory detail

            // Create and append details dynamically, inventory uses first child only, since that only matters
            const fields = [
                { label: "Food Category", value: inventory[0].InventoryFoodCategory },
                { label: "Food Name", value: inventory[0].InventoryFoodName },
                { label: "Description", value: inventory[0].InventoryDescription },
                { label: "Quantity", value: inventory[0].InventoryQuantity },
                { label: "Expiration Date", value: new Date(inventory[0].InventoryExpirationDate).toLocaleDateString() }
            ];

            fields.forEach(field => {
                const paragraph = document.createElement("p");
                const boldLabel = document.createElement("strong");
                boldLabel.textContent = `${field.label}: `;
                paragraph.appendChild(boldLabel);
                paragraph.appendChild(document.createTextNode(field.value));
                container.appendChild(paragraph);
            });

        }
    </script>

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
                            <h3><%# Eval("DonorName") %> - <%# Eval("AppointmentTime", "{0:yyyy-MM-dd HH:mm}") %></h3>
                                   <button type="button" 
                                       class="btn btn-info" 
                                       data-toggle="modal" 
                                       data-target="#foodDetailsModal"
                                       onclick="showFoodDetails('<%# Server.HtmlEncode(Eval("SerializedFoodItems").ToString()) %>')">  <!-- To ensure protection in html coding and json read it as string -->
                                       View Food Details
                                   </button>

                            </div>
                             </ItemTemplate>
                        </asp:Repeater>  
                    
                            <!-- Modal Structure -->
                    <div class="modal fade" id="foodDetailsModal" tabindex="-1" aria-labelledby="foodDetailsLabel" aria-hidden="true">
                         <div class="modal-dialog">
                             <div class="modal-content">
                                 <div class="modal-header">
                                    <h5 class="modal-title" id="foodDetailsLabel">Food Details</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                  <div class="modal-body">
                                    <!-- This is where the food details will be populated dynamically -->
                                    <div id="foodDetailsContainer"></div>
                                 </div>
                                 <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                              </div>
                           </div>
                      </div>
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
                                     <h3><%# Eval("InventoryQuantity") %>  <%# Eval("InventoryFoodCategory") %></h3>

                                       <button type="button" 
                                           class="btn btn-info" 
                                           data-toggle="modal" 
                                           data-target="#inventoryDetailsModal"
                                           onclick="showInventory('<%# Server.HtmlEncode(Eval("SerializedInventory").ToString()) %>')">  <!-- To ensure protection in html coding and json read it as string -->
                                           View Inventory
                                       </button>
                                </div>
                                      </ItemTemplate>
                              </asp:Repeater>

                                       <!-- Modal Structure -->
                             <div class="modal fade" id="inventoryDetailsModal" tabindex="-1" aria-labelledby="inventoryDetailsLabel" aria-hidden="true">
                                  <div class="modal-dialog">
                                      <div class="modal-content">
                                          <div class="modal-header">
                                             <h5 class="modal-title" id="inventoryDetailsLabel"></h5>
                                             <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                         </div>
                                           <div class="modal-body">
                                             <!-- This is where the food details will be populated dynamically -->
                                             <div id="inventoryDetailsContainer"></div>
                                          </div>
                                          <div class="modal-footer">
                                             <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                         </div>
                                       </div>
                                    </div>
                               </div>
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
