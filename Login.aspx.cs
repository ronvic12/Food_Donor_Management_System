using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;

using Food_Donor_Management_System.Helpers;
namespace Food_Donor_Management_System
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void Login_Authenticate(object sender, EventArgs e)
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
                Session["Username"] = name;
                Session["UserRole"] = role;
                Session["UserEmail"] = email;
                Session["UserID"] = id;
                // Consider add cookieform to make it recognizable on the server.
                 if (role == "Donor") Response.Redirect("DonorDashboard.aspx");
                else if (role == "Recipient") Response.Redirect("RecipientDashboard.aspx");
            }
            else
            {
                lblMessage.Text = "Invalid Email or Password credentials! If you forgot your password, go to forgot password";
            }
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