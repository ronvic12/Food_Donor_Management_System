using Food_Donor_Management_System.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Donor_Management_System
{
    public partial class DonorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadDonatedFood();
        }



        protected void btnAddFood_Click(object sender, EventArgs e)
        {
            string name = txtFoodName.Text;
            string description = txtDescription.Text;
            string expiryDate = txtExpiryDate.Text;
            int donorID = GetLoggedInUserID(); // Implement a method to fetch the current user's ID

            string query = $"INSERT INTO FoodItems (Name, Description, ExpiryDate, DonorID) VALUES ('{name}', '{description}', '{expiryDate}', {donorID})";
            DatabaseHelper.ExecuteNonQuery(query);

            LoadDonatedFood();
        }

        private void LoadDonatedFood()
        {
            int donorID = GetLoggedInUserID();
            string query = $"SELECT Name, Description, ExpiryDate, Status FROM FoodItems WHERE DonorID = {donorID}";
            gvDonatedFood.DataSource = DatabaseHelper.ExecuteQuery(query);
            gvDonatedFood.DataBind();
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