using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;

namespace Food_Donor_Management_System.Helpers
{

    // This is the connection queries for databases and executing query
    public class DatabaseHelper
    {
        private static string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlConnection"].ConnectionString;

        // Used for retrieving data from database, mostly using SELECT queries
        public static DataTable ExecuteQuery(string query)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                MySqlCommand cmd = new MySqlCommand(query, conn);
                MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                return dt;
            }
        }


        // Use for non-retrieval operations in databases:Insert,Update,Delete
        // add another parameter to accept dictionary so that it can use parameterized queries.
        public static void ExecuteNonQuery(string query, Dictionary<string, object> parameters)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {

                    foreach (var param in parameters) 
                    {
                        cmd.Parameters.AddWithValue(param.Key, param.Value);
                    }
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
              
            }
        }
    }
}