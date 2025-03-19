# Food Donations Made Easy
Problem:
- Food Insecurity
- Lack of Centralized Management System

Solution:
- Food Donation Tracking System

## Home Page
![Home page](Images/Home_page.png) 


## Donor Dashboard
![Donor Dashboard](Images/Donor_Dashboard.png)


## Recipient Dashboard
![Recipient Dashboard](Images/Recipient_Dashboard.png)

## Admin Dashboard
- Food_to_Inventory
![Food_to_Inventory](Images/Admin_Dashboard(Food_to_Inventory).png)


- Recipient Request Donation Status
![Recipient Request Donation Status](Images/Recipient_Request_Donation_Status.png)



## Code Snippets:
## Food Donation Grid View
### Front-End Code 
- Food Donation Grid View
```xml
<asp:GridView ID="gvFoodItems" runat="server" AutoGenerateColumns="False" CssClass="gridview-style">
    <Columns>
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
        <asp:BoundField DataField="FoodCategory" HeaderText="Food Category" />
        <asp:BoundField DataField="FoodName" HeaderText="Food Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" />
        <asp:BoundField DataField="ExpirationDate" HeaderText="Expiration Date" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false"/>
    </Columns>
</asp:GridView>
```

Image Output

- Food Donation Grid View in Modal
```xml
    <asp:GridView ID="gvModalFoodItem" runat="server" AutoGenerateColumns="False"  CssClass="gridview-style">
    <Columns>
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
        <asp:BoundField DataField="FoodCategory" HeaderText="Food Category" />
        <asp:BoundField DataField="FoodName" HeaderText="Food Name" />
        <asp:BoundField DataField="Description" HeaderText="Description" />
        <asp:BoundField DataField="ExpirationDate" HeaderText="Expiration Date" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false" />
    </Columns>
</asp:GridView>
<hr />
    <div class="mb-3">
        <label for="txtAppointmentTime" class="form-label">Drop Off Time</label>
        <asp:TextBox ID="txtdropoffDateTime" runat="server" TextMode="DateTimeLocal" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
         <asp:Label ID=sucessMsg runat="server" CssClass="text-success"></asp:Label>
    </div>
```


### Backend Code

```csharp
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
```
```csharp
protected void btnAddFood_Click(object sender, EventArgs e)
{
    DataTable dt = GetFoodTable();

    DataRow dr = dt.NewRow();
    dr["Quantity"] = int.Parse(txtQuantity.Text);
    dr["FoodCategory"] = ddlCategories.SelectedValue;
    dr["FoodName"] = txtFoodName.Text;
    dr["Description"] = txtDescription.Text;
    dr["ExpirationDate"] = DateTime.Parse(txtExpiryDate.Text);
    if (dr["FoodCategory"] == null) // Validate category selection
    {
        lblMessage.CssClass = "text-danger";
        lblMessage.Text = "Please select a valid food category.";
        return;
    }
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
```
```csharp
protected void SaveAppointment_Click(object sender, EventArgs e) 
  {
      DataTable dt = GetFoodTable();
      string dropoff_DateTime = txtdropoffDateTime.Text;

      foreach (DataRow row in dt.Rows) 
      {
          string query = "INSERT INTO FoodItems (Name, Description, ExpiryDate, DonorID, Quantity, DropOffDateTime, CategoryID) " +
                "VALUES (@Name, @Description, @ExpiryDate, @DonorID, @Quantity, @DropOffDateTime, @CategoryID)";
          int donorID = GetLoggedInUserID();
          int categoryID = Convert.ToInt32(row["FoodCategory"]);
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

          gvModalFoodItem.DataSource = null; 
          gvModalFoodItem.DataBind();
      }
  }

```

