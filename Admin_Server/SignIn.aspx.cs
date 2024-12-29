using Food_Donor_Management_System.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Donor_Management_System.Admin_Server
{
    public partial class SignIn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            // Check if a user is already logged in and redirect if they are not an Admin
            if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
            {
                // Allow access to the admin login page if the user is already logged in as Admin
            }
            else if (Session["Role"] != null && Session["Role"].ToString() == "Customer")
            {
                // Redirect if the user is already logged in as Customer
                Response.Redirect("~/Login.aspx");
            }
            else
            {
                // No user logged in, continue with the regular admin login process
            }

        }
        protected void SignInAuthenticate(object sender, EventArgs e)
        {

            string email = txtEmail.Text;
            string passwordHash = HashPassword(txtPassword.Text);

            string query = $"SELECT ID,Name,Role FROM Users WHERE Email = '{email}' AND PasswordHash = '{passwordHash}'";
            DataTable dt = DatabaseHelper.ExecuteQuery(query);

            if (dt.Rows.Count > 0)
            {
                // work on this tom
                string role = dt.Rows[0]["Role"].ToString();
                string id = dt.Rows[0]["ID"].ToString();
                string name = dt.Rows[0]["Name"].ToString();

                if(dt.Rows[0]["Role"] != null &&  role == "Admin") 
                {
                    Session["Username"] = name;
                    Session["Role"] = role;
                    Session["UserEmail"] = email;
                    Session["UserID"] = id;

                    // Make the panel visible in the master page
                    if (this.Master != null)
                    {
                        Panel adminPanel = (Panel)this.Master.FindControl("pnlAdminNav");
                        if (adminPanel != null)
                        {
                            adminPanel.Visible = true;  // Show the panel after login
                        }
                    }
                    Response.Redirect("AdminDashboard.aspx");
                }   
            }
            else
            {
                lblMessage.Text = "Invalid Email or Password credentials! Please Contact Admin Director";
            }
            //mvMain.SetActiveView(vwLogin);

        }


        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}