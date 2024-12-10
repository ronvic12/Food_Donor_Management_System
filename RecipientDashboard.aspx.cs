using Food_Donor_Management_System.Helpers;
using Org.BouncyCastle.Cms;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Donor_Management_System
{
    public partial class RecipientDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAvailableFood();
            }

        }
        public enum FoodStatus
        {
            Available
        }
        private void LoadAvailableFood()
        {
            string query = @" 
                        SELECT 
                        fi.ID as FoodItemID, 
                         fc.Name AS FoodCategory,
                         fi.Name AS FoodName,
                         fi.Description as Description,
                         fi.Quantity as Quantity,
                         fi.ExpiryDate AS ExpirationDate,
                         fi.Status as Status 
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
            gvAvailableFood.DataSource = DatabaseHelper.ExecuteQuery(query, parameters);
            gvAvailableFood.DataBind();
        }
        public enum Status
        {
         
            Requested,
            Delivered
        }
        protected void gvAvailableFood_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Request")
            {

                int? recipientID = GetLoggedInUserID();
                if (recipientID == null || recipientID <= 0)
                {
                    lblError.Text = "You must be logged in to make a request.";
                    lblError.Visible = true; // Show the error message
                    return; // Exit the method to prevent further execution
                }
                // Get the row index
                int rowIndex = Convert.ToInt32(e.CommandArgument);

                int foodItemID = Convert.ToInt32(gvAvailableFood.DataKeys[rowIndex]["FoodItemID"]);


                // Use parameterized query to prevent SQL injection
                string query = $"INSERT INTO Requests (FoodItemID, RecipientID, Status) VALUES (@FoodItemID, @RecipientID, 'Pending') ON DUPLICATE KEY UPDATE Status = 'Pending'";

                var insertParams = new Dictionary<string, object>
                 {
                     {"@FoodItemID",foodItemID },
                     { "@RecipientID",recipientID}
                 };


                DatabaseHelper.ExecuteNonQuery(query, insertParams);

                string updateQuery = $"UPDATE FoodItems SET Status = @status WHERE ID = @FoodItemID";


                var updateParams = new Dictionary<string, object>
                 {
                     {"@status",Status.Requested.ToString()},
                     { "@FoodItemID",foodItemID}
                 };
                DatabaseHelper.ExecuteNonQuery(updateQuery, updateParams);

                LoadAvailableFood();
            }
        }

        // int? means can be nullable integer or 0
        protected int? GetLoggedInUserID()
        {
            if (Session["UserID"] != null)
            {
                return Convert.ToInt32(Session["UserID"]);
            }
            return null;
        }
    }
}