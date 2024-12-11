<%@ Page Title="Account Sign Up" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="Food_Donor_Management_System.Registration" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

      <div class ="registercontainer">
        <h2>Register</h2>
            <span>I am a</span>

           <!-- Role Dropdown -->
        <asp:DropDownList ID="ddlRole" runat="server" onchange="toggleCredentials()" OnSelectedIndexChanged="ddlRole_SelectedIndexChanged" >
            <asp:ListItem Text="Select Role" Value="" />
            <asp:ListItem Text="Donor" Value="Donor" />
            <asp:ListItem Text="Recipient" Value="Recipient" />
        </asp:DropDownList>

          <div id="userCredentials" class="personalCredentials" style="display: none;">
            <asp:TextBox ID="txtName" runat="server" Placeholder=""></asp:TextBox>
            <asp:TextBox ID="txtEmail" runat="server" Placeholder="Email"></asp:TextBox>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>
            </div>
          <br />
          <asp:HyperLink ID="CreateAccountHyperLink" runat="server" ForeColor="Blue" NavigateUrl="~/Login.aspx">Already a user? Sign In</asp:HyperLink>
        <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>

    </div>
     <!-- JavaScript code at the end of the body -->
    <script type="text/javascript">
        function toggleCredentials() {
            var role = document.getElementById('<%= ddlRole.ClientID %>').value;
            var txtName = document.getElementById('<%= txtName.ClientID %>');
            var userCredentials = document.getElementById('userCredentials');
            userCredentials.style.display = 'none';

            if (role === 'Donor') {
                // Change the placeholder text to "Name" when 'Donor' is selected
                txtName.placeholder = "Name";
                userCredentials.style.display = 'flex';
                userCredentials.style.flexDirection = 'column';  // Align items vertically
                userCredentials.style.gap = '15px';  // Space between elements

                // Add the required attribute to the input field
                txtName.required = true;
                txtEmail.required = true;
                txtPassword.required = true;
                // Apply styles to each input inside the userCredentials div
                var inputs = userCredentials.getElementsByTagName('input');
                for (var i = 0; i < inputs.length; i++) {
                    inputs[i].style.width = '100%';  // Make input fields span the full width
                    inputs[i].style.padding = '10px';
                    inputs[i].style.margin = '5px 0';
                    inputs[i].style.border = '1px solid #ccc';
                    inputs[i].style.borderRadius = '4px';
                }
            } else if (role === 'Recipient') {
                txtName.placeholder = "Organization Name";
                userCredentials.style.display = 'flex';
                userCredentials.style.flexDirection = 'column';  // Align items vertically
                userCredentials.style.gap = '15px';  // Space between elements

                // Add the required attribute to the input field
                txtName.required = true;
                txtEmail.required = true;
                txtPassword.required = true;
                // Apply styles to each input inside the userCredentials div
                var inputs = userCredentials.getElementsByTagName('input');
                for (var i = 0; i < inputs.length; i++) {
                    inputs[i].style.width = '100%';  // Make input fields span the full width
                    inputs[i].style.padding = '10px';
                    inputs[i].style.margin = '5px 0';
                    inputs[i].style.border = '1px solid #ccc';
                    inputs[i].style.borderRadius = '4px';
                }
            } else {
                userCredentials.style.display = 'none';
                // Add the required attribute to the input field
                txtName.required = false;
                txtEmail.required = false;
                txtPassword.required = false;
            }
        }
    </script>
    </asp:Content>
