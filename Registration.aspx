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
            <asp:TextBox ID="txtName" runat="server" Placeholder="Name"></asp:TextBox>
            <asp:TextBox ID="txtEmail" runat="server" Placeholder="Email"></asp:TextBox>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>

            </div>
          <br />
        <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>

    </div>
     <!-- JavaScript code at the end of the body -->
    <script type="text/javascript">
        function toggleCredentials() {
            var role = document.getElementById('<%= ddlRole.ClientID %>').value;
            document.getElementById('userCredentials').style.display = 'none';

            if(role === 'Donor') {
                document.getElementById('userCredentials').style.display = 'block';
            } else if (role === 'Recipient') {
                document.getElementById('userCredentials').style.display = 'block';
            }
        }
    </script>
    </asp:Content>
