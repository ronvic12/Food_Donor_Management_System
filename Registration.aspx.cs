using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Food_Donor_Management_System.Helpers;
using System.Security.Cryptography;
using System.Text;

namespace Food_Donor_Management_System
{
    public partial class Registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }


        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string name = txtName.Text;
            string email = txtEmail.Text;
            string passwordHash = HashPassword(txtPassword.Text);
            string role = ddlRole.SelectedValue;

            string query = $"INSERT INTO Users (Name, Email, PasswordHash, Role) VALUES ('{name}', '{email}', '{passwordHash}', '{role}')";
            DatabaseHelper.ExecuteNonQuery(query);

            lblMessage.Text = "Registration successful!";
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