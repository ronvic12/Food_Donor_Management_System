using Food_Donor_Management_System.Helpers;
using MySqlX.XDevAPI.Common;
using Newtonsoft.Json;
using Org.BouncyCastle.Cms;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using static Mysqlx.Expect.Open.Types;

namespace Food_Donor_Management_System
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        public enum FoodStatus
        {
            Available,
            Requested,
            Reserved,
            Shipped,
            Claimed
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load appointments on the first load
                LoadDropOffAppointments();
                LoadAvailableFoodItems();
                LoadRecipientRequests();
                LoadDeliveryProcess();
            }
            else
            {
                // Handle postback arguments for actions like Approve/Reject
                string eventArgument = Request["__EVENTARGUMENT"];
                if (eventArgument == "SubmitDecision")
                {
                    // Retrieve values from hidden fields
                    string foodItemID = FoodItemID.Value; // Hidden field for FoodItemID
                    string decision = Decision.Value;     // Hidden field for Approve/Reject

                    // Process the decision
                    if (!string.IsNullOrEmpty(foodItemID) && !string.IsNullOrEmpty(decision))
                    {
                        if (decision == "Approve")
                        {
                            decision = "Available";
                            int num_foodItemID = Convert.ToInt32(foodItemID);
                            UpdateDecisionStatusFoodItem(decision, num_foodItemID);
                        }
                        else if (decision == "Reject")
                        {
                            decision = "Rejected";
                            int num_foodItemID = Convert.ToInt32(foodItemID);
                            UpdateDecisionStatusFoodItem(decision, num_foodItemID);
                        }

                        // Reload appointments to reflect the updated data
                        LoadDropOffAppointments();
                    }
                }

                    // different argument 

                    if (eventArgument == "ApproveOrDenyRequest") 
                    {
                        // Retrieve values from hidden fields
                        string requestfooditemID = RequestFoodItemID.Value; // Hidden field for FoodItemID
                        string requestrecipientID = RequestRecipientID.Value;
                        string requestdecision = RequestDecision.Value;     // Hidden field for Approve/Reject


                        if (!string.IsNullOrEmpty(requestfooditemID) && !string.IsNullOrEmpty(requestrecipientID) && !string.IsNullOrEmpty(requestdecision))
                        {
                            if (requestdecision == "Approve")
                            {
                                string fooditemDecision = "Reserved";
                                requestdecision = "Approved";
                                int num_foodItemID = Convert.ToInt32(requestfooditemID);
                                int num_requestrecipientID = Convert.ToInt32(requestrecipientID);
                                UpdateDecisionStatusFoodItem(fooditemDecision, num_foodItemID);
                                UpdateDecisionRequests(requestdecision, num_foodItemID, num_requestrecipientID);
                            }
                            else if (requestdecision == "Deny")
                            {
                                string fooditemDecision = "Available"; // bring it back to available
                                requestdecision = "Rejected";
                                int num_foodItemID = Convert.ToInt32(requestfooditemID);
                                int num_requestrecipientID = Convert.ToInt32(requestrecipientID);
                                UpdateDecisionStatusFoodItem(fooditemDecision, num_foodItemID);
                                UpdateDecisionRequests(requestdecision, num_foodItemID, num_requestrecipientID);
                            }

                            // Reload appointments to reflect the updated data
                            LoadRecipientRequests();
                        }

                    }
            }
        }

        private void UpdateDecisionStatusFoodItem(string decision, int foodItemID)
        {
            string updateQuery = @" UPDATE FoodItems
                                       SET Status = @Status
                                       WHERE ID = @FoodItemID";
            var updateparameters = new Dictionary<string, object>
                {
                    {"@Status", decision},
                    {"@FoodItemID",foodItemID }
                };
            DatabaseHelper.ExecuteNonQuery(updateQuery, updateparameters);
        }

        private void UpdateDecisionRequests(string decision, int foodItemID, int recipientID) 
        {
            string updateQuery = @" UPDATE Requests
                                       SET Status = @Status
                                       WHERE FoodItemID  = @FoodItemID AND RecipientID = @RecipientID";
            var updateparameters = new Dictionary<string, object>
                {
                    {"@Status", decision},
                    {"@FoodItemID",foodItemID },
                    {"@RecipientID",recipientID }
                };
            DatabaseHelper.ExecuteNonQuery(updateQuery, updateparameters);

        }

        private void LoadDropOffAppointments()
        {
            // CAST(GETDATE() AS DATE) to get today's date and future date of appointments
            string query = @"
            SELECT 
             u.Name AS DonorName,
            fi.ID as FoodItemID,
            fc.Name AS FoodCategory,
            fi.Name AS FoodName,
            fi.Description,
            fi.Quantity,
            fi.ExpiryDate AS ExpirationDate,
            fi.Status,
            fi.DropOffDateTime AS AppointmentTime
        FROM 
            FoodItems fi
        INNER JOIN 
            Users u ON fi.DonorID = u.ID
        INNER JOIN 
            FoodCategories fc ON fi.CategoryID = fc.ID
        WHERE
            fi.DropOffDateTime >= CURDATE()  
        ORDER BY
            fi.DropOffDateTime ";

            // Implementing LINQ Structure because the data needs to be shown in front end is group hierarchally. 
            var result = DatabaseHelper.ExecuteQuery(query);
            // Group data by DonorName and AppointmentTime
            var groupedData = result.AsEnumerable()
                              .GroupBy(row => new
                              {
                                  DonorName = row["DonorName"],
                                  AppointmentTime = row["AppointmentTime"]
                              }).Select(group => new
                              {
                                  DonorName = group.Key.DonorName,
                                  AppointmentTime = group.Key.AppointmentTime,
                                  FoodItems = group.Select(item => new
                                  {
                                      FoodCategory = item["FoodCategory"],
                                      FoodName = item["FoodName"],
                                      Description = item["Description"],
                                      Quantity = item["Quantity"],
                                      ExpirationDate = item["ExpirationDate"],
                                      FoodItemID = item["FoodItemID"],
                                      Status = item["Status"]
                                  }).ToList(),  // to ensure it serializes into JSON

                                  // Serialize the FoodItems as JSON and pass it to the UI
                                  SerializedFoodItems = JsonConvert.SerializeObject(group.Select(item => new
                                  {
                                      FoodCategory = item["FoodCategory"],
                                      FoodName = item["FoodName"],
                                      Description = item["Description"],
                                      Quantity = item["Quantity"],
                                      ExpirationDate = item["ExpirationDate"],
                                      FoodItemID = item["FoodItemID"],
                                      Status = item["Status"]
                                  }).ToList())
                              })
                              .ToList();// Ensure grouping is executed before serializing to JSON

            // Now, if you want to bind the data to the DataSource, you can continue to use DataBind
            rptTodayAppointments.DataSource = groupedData;
            rptTodayAppointments.DataBind();

        }
        public string TodayDate
        {
            get
            {
                return DateTime.Now.ToString("MMMM d");
            }
        }
    

        // This is for Inventory
        private void LoadAvailableFoodItems()
        {
            string loadquery = @" 
                        SELECT 
                        fi.ID as InventoryFoodItemID, 
                         fc.Name AS InventoryFoodCategory,
                         fi.Name AS InventoryFoodName,
                         fi.Description as InventoryDescription,
                         fi.Quantity as InventoryQuantity,
                         fi.ExpiryDate AS InventoryExpirationDate,
                         fi.Status as InventoryStatus 
                   FROM 
                        fooditems fi 
               INNER JOIN  
                         foodcategories fc ON fi.CategoryID = fc.ID
                WHERE fi.Status = @status";
 
            // using Parameter queries, to avoid injection
            var parameters = new Dictionary<string, object>
            {
                { "@status", FoodStatus.Available.ToString() }
            };
            // Implementing LINQ Structure because the data needs to be shown in front end is group hierarchally. 
            var availableresult = DatabaseHelper.ExecuteQuery(loadquery,parameters);

            var groupavailabledata = availableresult.AsEnumerable()
                              .GroupBy(row => new
                              { // need food name since because so that inventory has differentiation of names under same category
                                  InventoryFoodCategory = row["InventoryFoodCategory"],
                                  InventoryFoodName = row["InventoryFoodName"],
                                  InventoryQuantity = row["InventoryQuantity"],
                                  InventoryExpirationDate = row["InventoryExpirationDate"]
                              }).Select(group => new
                              {
                                  InventoryFoodCategory = group.Key.InventoryFoodCategory,
                                  InventoryFoodName = group.Key.InventoryFoodName,
                                  InventoryQuantity = group.Key.InventoryQuantity,
                                  InventoryExpirationDate = group.Key.InventoryExpirationDate,
                                  InventoryFoodItems = group.Select(item => new
                                  {
                                      InventoryFoodCategory = item["InventoryFoodCategory"],
                                      InventoryFoodName = item["InventoryFoodName"],
                                      InventoryDescription = item["InventoryDescription"],
                                      InventoryQuantity = item["InventoryQuantity"],
                                      InventoryExpirationDate = item["InventoryExpirationDate"],
                                      InventoryFoodItemID = item["InventoryFoodItemID"],
                                      InventoryStatus = item["InventoryStatus"]
                                  }).ToList(),  // to ensure it serializes into JSON
                                      
                                  // Serialize Inventory as JSON and pass it to the UI
                                  SerializedInventory = JsonConvert.SerializeObject(group.Select(item => new
                                  {
                                      InventoryFoodCategory = item["InventoryFoodCategory"],
                                      InventoryFoodName = item["InventoryFoodName"],
                                      InventoryDescription = item["InventoryDescription"],
                                      InventoryQuantity = item["InventoryQuantity"],
                                      InventoryExpirationDate = item["InventoryExpirationDate"],
                                      InventoryFoodItemID = item["InventoryFoodItemID"],
                                      InventoryStatus = item["InventoryStatus"]
                                  }).ToList())
                              })
                              .ToList();

            rptInventory.DataSource = groupavailabledata;
            rptInventory.DataBind();
        }

        private void LoadRecipientRequests()
        {

            string query = @"
                        SELECT 
                            u.Name AS RecipientName,
                            fi.ID as FoodItemID,
                            r.RecipientID,
                            fi.Name AS FoodItem,
                            fc.Name AS FoodCategory,
                            fi.Description,
                            fi.Quantity,
                            fi.ExpiryDate as ExpirationDate,
                            fi.Status AS FoodItemStatus,
                            r.Status AS RequestStatus
                        FROM 
                            Requests r
                        INNER JOIN 
                            FoodItems fi ON r.FoodItemID = fi.ID
                        INNER JOIN 
                            FoodCategories fc ON fi.CategoryID = fc.ID
                        INNER JOIN 
                            Users u ON r.RecipientID = u.ID
                        WHERE
                             fi.Status = @status";
            
            var parameters = new Dictionary<string, object>
            {
                { "@status", FoodStatus.Requested.ToString() }
            };
               // Implementing LINQ Structure because the data needs to be shown in front end is group hierarchally. 
            var recipientsresult = DatabaseHelper.ExecuteQuery(query, parameters);


            var grouprecipientdata = recipientsresult.AsEnumerable()
                              .GroupBy(row => new
                              { // need food name since because so that inventory has differentiation of names under same category
                                  RecipientName= row["RecipientName"],
                                  FoodCategory = row["FoodCategory"],
                                  FoodItem = row["FoodItem"],
                                  Quantity = row["Quantity"],
                                  ExpirationDate = row["ExpirationDate"]
                              }).Select(group => new
                              {
                                  RecipientName = group.Key.RecipientName,
                                  FoodCategory = group.Key.FoodCategory,
                                  FoodItem = group.Key.FoodItem,
                                  Quantity = group.Key.Quantity,
                                  ExpirationDate = group.Key.ExpirationDate,
                                  RecipientItems = group.Select(item => new
                                  {
                                      RecipientName = item["RecipientName"],
                                      FoodCategory = item["FoodCategory"],
                                      FoodItem = item["FoodItem"],
                                      Description = item["Description"],
                                      Quantity = item["Quantity"],
                                      ExpirationDate = item["ExpirationDate"],
                                      FoodItemStatus = item["FoodItemStatus"],
                                      FoodItemID = item["FoodItemID"],
                                      RecipientID = item["RecipientID"]
                                  }).ToList(),  // to ensure it serializes into JSON

                                  // Serialize Inventory as JSON and pass it to the UI
                                  SerializedRecipients = JsonConvert.SerializeObject(group.Select(item => new
                                  {
                                      RecipientName = item["RecipientName"],
                                      FoodCategory = item["FoodCategory"],
                                      FoodItem = item["FoodItem"],
                                      Description = item["Description"],
                                      Quantity = item["Quantity"],
                                      ExpirationDate = item["ExpirationDate"],
                                      FoodItemStatus = item["FoodItemStatus"],
                                      FoodItemID = item["FoodItemID"],
                                      RecipientID = item["RecipientID"]
                                  }).ToList())
                              })
                              .ToList();
            rptPendingRequests.DataSource = grouprecipientdata;
            rptPendingRequests.DataBind();
        }




        private void LoadDeliveryProcess() 
        {

            string query = @"
                        SELECT 
                            u.Name AS RecipientName,
                            fi.ID as FoodItemID,
                            r.RecipientID,
                            fi.Name AS FoodItem,
                            fc.Name AS FoodCategory,
                            fi.Description,
                            fi.Quantity,
                            fi.ExpiryDate as ExpirationDate,
                            fi.Status AS FoodItemStatus,
                            r.Status AS RequestStatus
                        FROM 
                            Requests r
                        INNER JOIN 
                            FoodItems fi ON r.FoodItemID = fi.ID
                        INNER JOIN 
                            FoodCategories fc ON fi.CategoryID = fc.ID
                        INNER JOIN 
                            Users u ON r.RecipientID = u.ID
                        WHERE
                             fi.Status = @status";

            var parameters = new Dictionary<string, object>
            {
                { "@status", FoodStatus.Reserved.ToString() }
            };
            // Implementing LINQ Structure because the data needs to be shown in front end is group hierarchally. 
            var deliveryresult = DatabaseHelper.ExecuteQuery(query, parameters);


            var groupdeliverydata = deliveryresult.AsEnumerable()
                              .GroupBy(row => new
                              { // need food name since because so that inventory has differentiation of names under same category
                                  RecipientName = row["RecipientName"],
                                  FoodCategory = row["FoodCategory"],
                                  FoodItem = row["FoodItem"],
                                  Quantity = row["Quantity"],
                                  ExpirationDate = row["ExpirationDate"]
                              }).Select(group => new
                              {
                                  RecipientName = group.Key.RecipientName,
                                  FoodCategory = group.Key.FoodCategory,
                                  FoodItem = group.Key.FoodItem,
                                  Quantity = group.Key.Quantity,
                                  ExpirationDate = group.Key.ExpirationDate,
                                  RecipientItems = group.Select(item => new
                                  {
                                      RecipientName = item["RecipientName"],
                                      FoodCategory = item["FoodCategory"],
                                      FoodItem = item["FoodItem"],
                                      Description = item["Description"],
                                      Quantity = item["Quantity"],
                                      ExpirationDate = item["ExpirationDate"],
                                      FoodItemStatus = item["FoodItemStatus"],
                                      FoodItemID = item["FoodItemID"],
                                      RecipientID = item["RecipientID"]
                                  }).ToList(),  // to ensure it serializes into JSON

                                  // Serialize Inventory as JSON and pass it to the UI
                                  SerializedDelivery = JsonConvert.SerializeObject(group.Select(item => new
                                  {
                                      RecipientName = item["RecipientName"],
                                      FoodCategory = item["FoodCategory"],
                                      FoodItem = item["FoodItem"],
                                      Description = item["Description"],
                                      Quantity = item["Quantity"],
                                      ExpirationDate = item["ExpirationDate"],
                                      FoodItemStatus = item["FoodItemStatus"],
                                      FoodItemID = item["FoodItemID"],
                                      RecipientID = item["RecipientID"]
                                  }).ToList())
                              })
                              .ToList();
            rptdonation.DataSource = groupdeliverydata;
            rptdonation.DataBind();




        }
    }
}

/* private void LoadUsers()
  {
      string query = "SELECT Name, Email, Role FROM Users";
      gvUsers.DataSource = DatabaseHelper.ExecuteQuery(query);
      gvUsers.DataBind();
  }


  protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
  {
      if (e.CommandName == "Delete")
      {
          int userID = Convert.ToInt32(gvUsers.DataKeys[Convert.ToInt32(e.CommandArgument)].Value);
          string query = $"DELETE FROM Users WHERE ID = {userID}";
          DatabaseHelper.ExecuteNonQuery(query);

          LoadUsers();
      }
  }*/


/* private void LoadStats()
 {
     string query = @"
 SELECT 
     (SELECT COUNT(*) FROM FoodItems) AS TotalDonations,
     (SELECT COUNT(*) FROM Requests WHERE Status = 'Pending') AS PendingRequests,
     (SELECT COUNT(*) FROM Requests WHERE Status = 'Approved') AS ApprovedRequests,
     (SELECT COUNT(*) FROM Requests WHERE Status = 'Rejected') AS RejectedRequests";
     DataTable dt = DatabaseHelper.ExecuteQuery(query);

     if (dt.Rows.Count > 0)
     {
         lblStats.Text = $"Total Donations: {dt.Rows[0]["TotalDonations"]}<br />" +
                         $"Pending Requests: {dt.Rows[0]["PendingRequests"]}<br />" +
                         $"Approved Requests: {dt.Rows[0]["ApprovedRequests"]}<br />" +
                         $"Rejected Requests: {dt.Rows[0]["RejectedRequests"]}";
     }
 }*/


/*string jsonData;
                using (var reader = new System.IO.StreamReader(Request.InputStream))
                {
                    jsonData = reader.ReadToEnd();
                }

                // Log the raw JSON to help debug the issue
               Console.WriteLine("This is JSON DATA "+ jsonData);

                // Deserialize the JSON data into an object
                var requestData = JsonConvert.DeserializeObject<RequestData>(jsonData);*/

/*  int foodItemID = Convert.ToInt32(requestData.foodItemID);
  string status = requestData.status;
  string newStatus = (status == "Approve") ? "Available" : "Rejected";
  // Update the status of the food item in the database


  // Respond with success
  Response.StatusCode = 200; // OK
  Response.Write("Success");
  Response.End(); // End the response here to avoid page load continuation*/