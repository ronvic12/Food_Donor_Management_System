using Food_Donor_Management_System.Helpers;
using Mysqlx.Crud;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace Food_Donor_Management_System
{
    public partial class DonorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //LoadDonatedFood();

            if (!IsPostBack)
            {
                PopulateFoodCategories();
            }
        }
        private DataTable GetFoodTable()
        {
            if (Session["FoodTable"] == null)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Quantity", typeof(int));
                dt.Columns.Add("FoodCategory", typeof(string));
                dt.Columns.Add("FoodName", typeof(string));
                dt.Columns.Add("Description", typeof(string));
                dt.Columns.Add("ExpirationDate", typeof(DateTime));
                Session["FoodTable"] = dt;
            }
            return (DataTable)Session["FoodTable"];
        }

        protected void btnAddFood_Click(object sender, EventArgs e)
        {
            DataTable dt = GetFoodTable();

            DataRow dr = dt.NewRow();
            dr["Quantity"] = int.Parse(txtQuantity.Text);
            dr["FoodCategory"] = ddlCategories.SelectedValue;
            dr["FoodName"] = txtFoodName.Text;
            dr["Description"] = txtDescription.Text;
            dr["ExpirationDate"] = DateTime.Parse(txtExpiryDate.Text);

            dt.Rows.Add(dr);

            gvFoodItems.DataSource = dt; // for the main grid. 
            gvFoodItems.DataBind();


            gvModalFoodItem.DataSource = dt; // for modal grid
            gvModalFoodItem.DataBind();

            // Clear input fields
            txtQuantity.Text = "";
            ddlCategories.ClearSelection();
            txtFoodName.Text = "";
            txtDescription.Text = "";
            txtExpiryDate.Text = "";
        }


        protected void SaveAppointment_Click(object sender, EventArgs e) 
        {
            DataTable dt = GetFoodTable();
            string dropoff_DateTime = txtdropoffDateTime.Text;

            foreach (DataRow row in dt.Rows) 
            {
                string query = "INSERT INTO FoodItems (Name, Description, ExpiryDate, DonorID, Quantity, DropOffDateTime, CategoryID) " +
                      "VALUES (@Name, @Description, @ExpiryDate, @DonorID, @Quantity, @DropOffDateTime, @CategoryID)";
                int donorID = GetLoggedInUserID();
                // Get selected category
                int categoryID = Convert.ToInt32(row["FoodCategory"]);
                if (categoryID == 0) // Validate category selection
                {
                    /*lblMessage.CssClass = "text-danger"; // Set a new CSS class
                    lblMessage.Text = "Please select a valid food category.";*/
                    return;
                }
                var parameters = new Dictionary<string, object>
                {
                    { "@Name", row["FoodName"] },
                    { "@Description", row["Description"] },
                    { "@ExpiryDate", row["ExpirationDate"]  },
                    { "@DonorID", donorID },
                    { "@Quantity", row["Quantity"] },
                    { "@DropOffDateTime", dropoff_DateTime},
                    { "@CategoryID", categoryID }
                };

                DatabaseHelper.ExecuteTransactionalQuery(query, parameters);
                sucessMsg.Text = "Food Donation and Drop Off Time Saved!";


                // Clear session and GridView
                Session["FoodTable"] = null;
                gvFoodItems.DataSource = null;
                gvFoodItems.DataBind();

                gvModalFoodItem.DataSource = null; // for modal grid
                gvModalFoodItem.DataBind();
            }
        }


        /*protected void btnAddFood_Click(object sender, EventArgs e)
        {
            string name = txtFoodName.Text;
            string description = txtDescription.Text;
            string expiryDate = txtExpiryDate.Text;
            int donorID = GetLoggedInUserID(); // Implement a method to fetch the current user's ID
            int quantity = Convert.ToInt32(txtQuantity.Text);
            string dropoff_DateTime = txtdropoffDateTime.Text;



            // Get selected category
            int categoryID = Convert.ToInt32(ddlCategories.SelectedValue);
            if (categoryID == 0) // Validate category selection
            {
                lblMessage.CssClass = "text-danger"; // Set a new CSS class
                lblMessage.Text = "Please select a valid food category.";
                return;
            }

            // Insert query with CategoryID
            string query = "INSERT INTO FoodItems (Name, Description, ExpiryDate, DonorID, Quantity, DropOffDateTime, CategoryID) " +
                   "VALUES (@Name, @Description, @ExpiryDate, @DonorID, @Quantity, @DropOffDateTime, @CategoryID)";

            // Use parameterized query to prevent SQL injection
            var parameters = new Dictionary<string, object>
            {
                { "@Name", name },
                { "@Description", description },
                { "@ExpiryDate", expiryDate },
                { "@DonorID", donorID },
                { "@Quantity", quantity },
                { "@DropOffDateTime", dropoff_DateTime},
                { "@CategoryID", categoryID }
            };

            DatabaseHelper.ExecuteNonQuery(query,parameters);
            lblMessage.Text = "Food item added successfully!";
            //LoadDonatedFood();
        }*/

        private void PopulateFoodCategories()
        {
            string query = "SELECT ID, Name FROM FoodCategories";
            DataTable dt = DatabaseHelper.ExecuteQuery(query);

            ddlCategories.DataSource = dt;
            ddlCategories.DataTextField = "Name"; // Display Name in dropdown
            ddlCategories.DataValueField = "ID"; // Use ID as value
            ddlCategories.DataBind();

            ddlCategories.Items.Insert(0, new ListItem("Select Food Category", "0")); // Default option
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


/*     private void LoadDonatedFood()
     {
         int donorID = GetLoggedInUserID();
         string query = $"SELECT Name, Description, ExpiryDate, Status FROM FoodItems WHERE DonorID = {donorID}";
         gvDonatedFood.DataSource = DatabaseHelper.ExecuteQuery(query);
         gvDonatedFood.DataBind();
     }*/