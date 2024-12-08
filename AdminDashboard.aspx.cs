using Food_Donor_Management_System.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Donor_Management_System
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
            /*    // Example data source
                var appointments = new List<Appointment>
                    {
                        new Appointment { AppointmentName = "Meeting", AppointmentTime = DateTime.Now.AddHours(1) },
                        new Appointment { AppointmentName = "Checkup", AppointmentTime = DateTime.Now.AddHours(2) }
                    };

                gvAppt.DataSource = appointments;
                gvAppt.DataBind();
            }*/
        }
        protected void btnDate_Click(object sender, EventArgs e)
        {
            // Handle button click (if needed)
            // For example, you can show a message or log the date
            Response.Write("Button clicked for today's date!");
        }

        public class Appointment
        {
            public string AppointmentName { get; set; }
            public DateTime AppointmentTime { get; set; }
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