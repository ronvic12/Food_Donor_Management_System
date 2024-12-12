<%@ Page Title="Account Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Food_Donor_Management_System.Login" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
            <div class ="logincontainer">
                <h2>Sign In</h2>

                <!-- Custom Email as Username -->
                <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="txtEmail">Email:</asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" Placeholder="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email required" ForeColor="Red" />
                <br />
                
                <!-- Custom Password -->
                <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="txtPassword">Password:</asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password required" ForeColor="Red" />
                 <!-- Create An Account Navigation Link -->
                <asp:HyperLink ID="CreateAccountHyperLink" runat="server" ForeColor="Blue" NavigateUrl="~/Registration.aspx">New here? Register</asp:HyperLink>
                <!-- Hyperlink for Forgot Password -->
                <!-- <asp:HyperLink ID="HyperLink1" runat="server" ForeColor="Blue" NavigateUrl="~/ForgotPassword.aspx">Forgot Password</asp:HyperLink> -->
                <br />

               
                <!-- Sign In Button -->
                <asp:Button ID="btnLogin" runat="server" Text="Sign In" CommandName="Login" OnClick="Login_Authenticate" CssClass="btn btn-login"/>
                <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
            </div>

</asp:Content>





