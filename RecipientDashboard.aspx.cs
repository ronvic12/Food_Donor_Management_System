using Food_Donor_Management_System.Helpers;
using Org.BouncyCastle.Cms;
using System;
using System.Collections.Generic;
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

        private void LoadAvailableFood()
        {
            string query = "SELECT ID, Name, Description, ExpiryDate FROM FoodItems WHERE Status = 'Available'";
            gvAvailableFood.DataSource = DatabaseHelper.ExecuteQuery(query);
            gvAvailableFood.DataBind();
        }

        protected void gvAvailableFood_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Request")
            {
                int foodItemID = Convert.ToInt32(gvAvailableFood.DataKeys[Convert.ToInt32(e.CommandArgument)].Value);
                int recipientID = GetLoggedInUserID();


                // Use parameterized query to prevent SQL injection
               string query = $"INSERT INTO Requests (FoodItemID, RecipientID) VALUES (@FoodItemID, @RecipientID)";

                var insertParams = new Dictionary<string, object>
                {
                    {"@FoodItemID",foodItemID },
                    { "@RecipientID",recipientID}
                };


                
                DatabaseHelper.ExecuteNonQuery(query,insertParams);

                string updateQuery = $"UPDATE FoodItems SET Status = '@Status' WHERE ID = @FoodItemID";


                var updateParams = new Dictionary<string, object>
                {
                    {"@Status","Reserved" },
                    { "@FoodItemID",foodItemID}
                };
                DatabaseHelper.ExecuteNonQuery(updateQuery,updateParams);

                LoadAvailableFood();
            }
        }


        protected int GetLoggedInUserID()
        {
            if (Session["UserID"] != null)
            {
                return Convert.ToInt32(Session["UserID"]);
            }
            return 0;
        }
    }
}