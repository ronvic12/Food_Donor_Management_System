using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Donor_Management_System
{
    public partial class Admin : System.Web.UI.MasterPage
    {

  /*      protected void Page_Init(object sender, EventArgs e) 
        {
            if (Session["AdminUserName"] == null && Session["AdminRole"].ToString() != "Admin")
            {
                if (!Request.RawUrl.Contains("SignIn.aspx"))
                {
                    Response.Redirect("SignIn.aspx");
                }
            }
            else 
            {
                pnlAdminNav.Visible = true;
            }

        }*/
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
            {
                pnlAdminNav.Visible = true;  // Make the panel visible if the user is Admin
            }
            else
            {
                pnlAdminNav.Visible = false;  // Hide it for non-admin users
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            // Clear the session and redirect to the admin login page
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Admin_Server/SignIn.aspx");
        }
    }
}