﻿<%@ Page Language="C#"  MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="Food_Donor_Management_System.AdminDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminContent" runat="server">
        <!-- Hidden Fields for Submitting Food Item Decision -->
        <asp:HiddenField ID="FoodItemID" runat="server" />
        <asp:HiddenField ID="Decision" runat="server" />

        <!-- Hidden Fields for Submitting Approve or Deny Request -->
        <asp:HiddenField ID="RequestFoodItemID" runat="server" />
        <asp:HiddenField ID="RequestRecipientID" runat="server" />
        <asp:HiddenField ID="RequestDecision" runat="server" />


            <!-- Include Bootstrap CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

        <!-- Include jQuery (needed for Bootstrap 4 modals) -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>

        <!-- Include Bootstrap JS -->
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // consider creating a new js script for cleanliness of the code.
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
            console.log(foodItems);
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
                  actionTd.style.border = "1px solid #ddd";
                  actionTd.style.padding = "8px";

                  const approveButton = document.createElement("button");
                  approveButton.textContent = "Approve";
                  approveButton.style.marginRight = "5px";
                  approveButton.style.backgroundColor = "#90EE90";
                  approveButton.style.border = "none";
                  approveButton.style.padding = "5px 10px";
                  approveButton.style.cursor = "pointer";
                  approveButton.onclick = () => submitDecision(item.FoodItemID, "Approve");

                    // Hover effect for approve button
                    approveButton.onmouseover = () => {
                        approveButton.style.backgroundColor = "#76C776"; // Lighter green when hovered
                    };
                    approveButton.onmouseout = () => {
                        approveButton.style.backgroundColor = "#90EE90"; // Return to original green
                };


                  const rejectButton = document.createElement("button");
                  rejectButton.textContent = "Reject";
                  rejectButton.style.backgroundColor = "#FF7F7F";
                  rejectButton.style.border = "none";
                  rejectButton.style.padding = "5px 10px";
                  rejectButton.style.cursor = "pointer";
                  rejectButton.onclick = () => submitDecision(item.FoodItemID, "Reject");

                    // Hover effect for reject button
                    rejectButton.onmouseover = () => {
                        rejectButton.style.backgroundColor = "#FF4C4C"; // Darker red when hovered
                    };
                    rejectButton.onmouseout = () => {
                        rejectButton.style.backgroundColor = "#FF7F7F"; // Return to original red
                    };
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
                { label: "Expiration Date", value: formatDate(inventory[0].InventoryExpirationDate)}
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
            // difference is that it should have approve and reject button. 

        function showRecipients(recipientJSON) {
            const recipients = JSON.parse(recipientJSON);
            const container = document.getElementById("recipientDetailsContainer");
            // Clear previous content
            while (container.firstChild) {
                container.removeChild(container.firstChild);
            }

            // Create and append details dynamically, inventory uses first child only, since that only matters
            const fields = [
                { label: "Recipient Name", value: recipients[0].RecipientName },
                { label: "Food Category", value: recipients[0].FoodCategory },
                { label: "Food Item", value: recipients[0].FoodItem },
                { label: "Description", value: recipients[0].Description },
                { label: "Quantity", value: recipients[0].Quantity },
                { label: "Expiration Date", value: formatDate(recipients[0].ExpirationDate) },
                { label: "Status", value: recipients[0].FoodItemStatus == "Requested" ? "Pending Request":""}
            ];

            fields.forEach(field => {
                const paragraph = document.createElement("p");
                const boldLabel = document.createElement("strong");
                boldLabel.textContent = `${field.label}: `;
                paragraph.appendChild(boldLabel);
                paragraph.appendChild(document.createTextNode(field.value));
                container.appendChild(paragraph);
            });


            // Create and append "Approve" and "Reject" buttons
            const buttonContainer = document.createElement("div");
            buttonContainer.style.marginTop = "10px"; // Optional: Adds space between details and buttons

            const approveButton = document.createElement("button");
            approveButton.textContent = "Approve Request";
            approveButton.style.marginRight = "5px";
            approveButton.style.backgroundColor = "#90EE90";
            approveButton.style.border = "none";
            approveButton.style.padding = "5px 10px";
            approveButton.style.cursor = "pointer";
            approveButton.classList.add("approve-btn"); // Optional: Add a CSS class for styling
            approveButton.onclick = () => approveOrDenyRequest(recipients[0].FoodItemID, recipients[0].RecipientID, "Approve");
            // Hover effect for approve button
            approveButton.onmouseover = () => {
                approveButton.style.backgroundColor = "#76C776"; // Lighter green when hovered
            };
            approveButton.onmouseout = () => {
                approveButton.style.backgroundColor = "#90EE90"; // Return to original green
            };


            const rejectButton = document.createElement("button");
            rejectButton.textContent = "Deny Request";
            rejectButton.style.backgroundColor = "#FF7F7F";
            rejectButton.style.border = "none";
            rejectButton.style.padding = "5px 10px";
            rejectButton.style.cursor = "pointer";
            rejectButton.classList.add("reject-btn"); // Optional: Add a CSS class for styling
            rejectButton.onclick = () => approveOrDenyRequest(recipients[0].FoodItemID, recipients[0].RecipientID, "Deny");

            // Hover effect for reject button
            rejectButton.onmouseover = () => {
                rejectButton.style.backgroundColor = "#FF4C4C"; // Darker red when hovered
            };
            rejectButton.onmouseout = () => {
                rejectButton.style.backgroundColor = "#FF7F7F"; // Return to original red
            };
            // Append buttons to the button container
            buttonContainer.appendChild(approveButton);
            buttonContainer.appendChild(rejectButton);

            // Append the button container to the main container
            container.appendChild(buttonContainer);
        }

        function showDelivery(deliveryJSON) {

            const delivery = JSON.parse(deliveryJSON);
            const container = document.getElementById("deliveryDetailsContainer");
            // Clear previous content
            while (container.firstChild) {
                container.removeChild(container.firstChild);
            }



            // Create and append details dynamically, inventory uses first child only, since that only matters
            const fields = [
                { label: "To: ", value: delivery[0].RecipientName },
                { label: "Food Category", value: delivery[0].FoodCategory },
                { label: "Food Item", value: delivery[0].FoodItem },
                { label: "Description", value: delivery[0].Description },
                { label: "Quantity", value: delivery[0].Quantity },
                { label: "Expiration Date", value: formatDate(delivery[0].ExpirationDate) },
                { label: "Status", value: delivery[0].FoodItemStatus}
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

        // helper 
        function approveOrDenyRequest(requestfooditemID, requestrecipientID, requestdecision) {

            // Get hidden fields by their ASP.NET generated Client IDs
            document.getElementById('<%= RequestFoodItemID.ClientID %>').value = requestfooditemID;
            document.getElementById('<%= RequestRecipientID.ClientID %>').value = requestrecipientID;
            document.getElementById('<%= RequestDecision.ClientID %>').value = requestdecision;


            // Submit the form
            __doPostBack('', 'ApproveOrDenyRequest');
        }
    </script>

    <div class="dashboard_container">
            <div class ="dashboard_table">
      
            <asp:Panel ID="pnlDonorDashboard" runat="server" Width="100%">
            <h3 style="text-align: center;">Donor Dashboard: Drop Off</h3>
                <hr>
            <div id="appointmentsContainer">
                <div class="appointmentGroup">
                    <asp:Label ID="lblNoAppointments" runat="server" Text="" Visible="false" />
                    <asp:Repeater ID="rptTodayAppointments" runat="server">
                        <ItemTemplate>
                             <h4 class="appointmentDate"><%# Eval("AppointmentTime", "{0:MMMM dd, yyyy}") %></h4>
                            <div class="appointment">
                            <h5><%# Eval("DonorName") %> - <%# Eval("AppointmentTime", "{0:hh:mm tt}") %></h5>
                                   <button type="button" 
                                       class="btn btn-info" 
                                       data-toggle="modal" 
                                       data-target="#foodDetailsModal"
                                       onclick="showFoodDetails('<%# Server.HtmlEncode(Eval("SerializedFoodItems").ToString().Replace("'", "\\'")) %>')">  <!-- To ensure protection in html coding and json read it as string -->
                                       View Food Details
                                   </button>

                            </div>
                             </ItemTemplate>
                        </asp:Repeater>  
                    
                            <!-- Modal Structure -->
                    <div class="modal fade" id="foodDetailsModal" tabindex="-1" aria-labelledby="foodDetailsLabel" aria-hidden="true">
                         <div class="modal-dialog">
                             <div class="modal-content" id="foodDetailContent">
                                 <div class="modal-header">
                                    <h5 class="modal-title" id="foodDetailsLabel">Food Details</h5>
                                </div>
                                  <div class="modal-body">
                                    <!-- This is where the food details will be populated dynamically -->
                                    <div id="foodDetailsContainer"></div>
                                 </div>
                                 <div class="modal-footer">                                   
                                </div>
                              </div>
                           </div>
                      </div>
                    </div>
                </div>
                </asp:Panel>
            </div>


         <!-- Use Update Panel to have smooth transition of the flow -->
       
            <div class ="dashboard_table">
                    <asp:Panel ID="pnlRecipientDashboard" runat="server" Width="100%">
                    <h3 style="text-align: center;">Recipient  Dashboard: Food Requests</h3>
                         <hr>
                          <div id="recipientContainer">
                              <div class="recipientGroup">
                                  <h4 class="recipientRequests">Pending Requests</h4>
                                  <asp:Label ID="lblNoRecipients" runat="server" Text="" Visible="false" />
                                  <asp:Repeater ID="rptPendingRequests" runat="server">
                                      <ItemTemplate>
                                          <div class="requests">
                                              <h5><%# Eval("RecipientName") %>  </h5>

                                              <p><strong>Requested Food:</strong> <span><%# Eval("Quantity") %> <%# Eval("FoodCategory") %></span></p>
                                               <button type="button" 
                                                         class="btn btn-info" 
                                                         data-toggle="modal" 
                                                         data-target="#recipientDetailModal"
                                                         onclick="showRecipients('<%# Server.HtmlEncode(Eval("SerializedRecipients").ToString().Replace("'","\\'")) %>')">  <!-- To ensure protection in html coding and json read it as string -->
                                                         View Recipient
                                                     </button>
                                          </div>
                                      </ItemTemplate>
                                  </asp:Repeater>

                                    <div class="modal fade" id="recipientDetailModal" tabindex="-1" aria-labelledby="recipientDetailLabel" aria-hidden="true">
                                       <div class="modal-dialog">
                                           <div class="modal-content">
                                               <div class="modal-header">
                                                  <h5 class="modal-title" id="recipientDetailLabel">Recipient Details</h5>               
                                              </div>
                                                <div class="modal-body">
                                                  <!-- This is where the food details will be populated dynamically -->
                                                  <div id="recipientDetailsContainer"></div>
                                               </div>
                                               <div class="modal-footer">
                                              </div>
                                            </div>
                                         </div>
                                    </div>
                              </div>
                          </div>
                </asp:Panel>
            </div>

     
           
            <div class ="dashboard_table">
                            <asp:Panel ID="pnlInventoryDashboard" runat="server" Width="100%">
                        <h3 style="text-align: center;">Inventory Dashboard</h3>
                                 <hr>
                      <div id="inventoryContainer">
                          <div class="inventoryGroup">
                              <h4 class="available">Available</h4>
                               <asp:Label ID="lblNoInventory" runat="server" Text="" Visible="false" />
                              <asp:Repeater ID="rptInventory" runat="server">
                                  <ItemTemplate>
                                <div class="inventory">
                                     <h5><%# Eval("InventoryQuantity") %>  <%# Eval("InventoryFoodCategory") %></h5>

                                       <button type="button" 
                                           class="btn btn-info" 
                                           data-toggle="modal" 
                                           data-target="#inventoryDetailsModal"
                                           onclick="showInventory('<%# Server.HtmlEncode(Eval("SerializedInventory").ToString().Replace("'","\\'")) %>')">  <!-- To ensure protection in html coding and json read it as string -->
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
                                             <h5 class="modal-title" id="inventoryDetailsLabel">Inventory Detail</h5>                    
                                         </div>
                                           <div class="modal-body">
                                             <!-- This is where the food details will be populated dynamically -->
                                             <div id="inventoryDetailsContainer"></div>
                                          </div>
                                          <div class="modal-footer">
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
                        <h3 style="text-align: center;">Donation Status</h3>
                      <hr>
                      <div id="donationContainer">
                          <div class="donationGroup">
                              <h4 class="deliver">Ready to Deliver</h4>
                              <asp:Label ID="lblNoDelivery" runat="server" Text="" Visible="false" />
                              <asp:Repeater ID="rptdonation" runat="server">
                                  <ItemTemplate>
                                      <div class="donation">
                                           <h5><%# Eval("Quantity") %>  <%# Eval("FoodCategory") %> </h5>
                                          <p><strong>To:</strong> <span><%# Eval("RecipientName") %></span></p>
                                            <button type="button" 
                                            class="btn btn-info" 
                                            data-toggle="modal" 
                                            data-target="#deliveryDetailsModal"
                                            onclick="showDelivery('<%# Server.HtmlEncode(Eval("SerializedDelivery").ToString().Replace("'","\\'")) %>')">  <!-- To ensure protection in html coding and json read it as string -->
                                            View Delivery Details
                                        </button>
                                      </div>
                                       
                                  </ItemTemplate>
                              </asp:Repeater>
                                 <div class="modal fade" id="deliveryDetailsModal" tabindex="-1" aria-labelledby="deliveryDetailsLabel" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                               <h5 class="modal-title" id="deliveryDetailsLabel">Delivery Details</h5>                                               
                                           </div>
                                             <div class="modal-body">
                                               <!-- This is where the food details will be populated dynamically -->
                                               <div id="deliveryDetailsContainer"></div>
                                            </div>
                                            <div class="modal-footer">                                               
                                           </div>
                                         </div>
                                      </div>
                                 </div>
                          </div>
                      </div>
                </asp:Panel>
            </div>
         
      </div>

    <style>

   .donation{
        display:flex;
        flex-direction:column;
    }
        .requests {
            display: flex;
            flex-direction: column;
        }
         h4 {
            display: inline-block;   /* Makes the width adjust to the content */
            padding: 10px;
            border: 1px solid black; /* Border will adjust based on content length */
            border-radius: 10px;
            background-color: lightblue;
            font-size:20px;
        }

      hr {
            border: none;               /* Remove default border */
            border-top: 2px solid #007BFF; /* Add custom border on top */
            width: 100%;                 /* Adjust width of the line */
            margin-left: auto;          /* Center the line horizontally */
            margin-right: auto;         /* Center the line horizontally */
        }


      .recipientRequests{background-color:#ff7474}
      .available{border: 2px solid #3a8f33;background-color:#ffffff}

      .deliver{background-color:#62d268}

    </style>
</asp:Content>
