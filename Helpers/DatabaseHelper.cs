using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Diagnostics;

namespace Food_Donor_Management_System.Helpers
{

    // This is the connection queries for databases and executing query
    public class DatabaseHelper
    {
        private static string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlConnection"].ConnectionString;

        // Used for retrieving data from database, mostly using SELECT queries
        public static DataTable ExecuteQuery(string query, Dictionary<string, object> parameters = null)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    MySqlCommand cmd = new MySqlCommand(query, conn);

                    // Add parameters to the command if they exist
                    if (parameters != null)
                    {
                        foreach (var param in parameters)
                        {
                            cmd.Parameters.AddWithValue(param.Key, param.Value);
                        }
                    }

                    MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    return dt;
                }
            }
            catch (Exception ex)
            {
                // Log the error (or handle it as needed)
                Debug.WriteLine("Error executing query: " + ex.Message);
                return null;  // Return null or an empty DataTable based on your needs
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

        public static void ExecuteTransactionalQuery(string query, Dictionary<string, object> parameters)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                // Start a new transaction
                using (MySqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        // Create and configure the MySqlCommand with the query and parameters
                        using (MySqlCommand cmd = new MySqlCommand(query, conn, transaction))
                        {
                            // Add parameters to the command
                            foreach (var param in parameters)
                            {
                                cmd.Parameters.AddWithValue(param.Key, param.Value);
                            }

                            // Execute the query
                            cmd.ExecuteNonQuery();
                        }

                        // Commit the transaction if the query was successful
                        transaction.Commit();
                    }
                    catch (Exception)
                    {
                        // Rollback the transaction if any error occurs
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }
    }
}