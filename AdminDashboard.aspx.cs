using Food_Donor_Management_System.Helpers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Mysqlx.Expect.Open.Types;

namespace Food_Donor_Management_System
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropOffAppointments();
            }
        }
        protected void btnDate_Click(object sender, EventArgs e)
        {
            // Handle button click (if needed)
            // For example, you can show a message or log the date
            Response.Write("Button clicked for today's date!");
        }


        private void LoadDropOffAppointments()
        {
            // CAST(GETDATE() AS DATE) to get today's date and future date of appointments
            string query = @"
            SELECT 
             u.Name AS DonorName,
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
                                      ExpirationDate = item["ExpirationDate"]
                                  }).ToList(),  // to ensure it serializes into JSON

                                  // Serialize the FoodItems as JSON and pass it to the UI
                                  SerializedFoodItems = JsonConvert.SerializeObject(group.Select(item => new
                                   {
                                       FoodCategory = item["FoodCategory"],
                                       FoodName = item["FoodName"],
                                       Description = item["Description"],
                                       Quantity = item["Quantity"],
                                       ExpirationDate = item["ExpirationDate"]
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