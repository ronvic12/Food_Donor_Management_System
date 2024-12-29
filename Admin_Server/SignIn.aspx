<%@ Page Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="SignIn.aspx.cs" Inherits="Food_Donor_Management_System.Admin_Server.SignIn" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="AdminContent" runat="server">
         <asp:MultiView runat="server" ID="mvMain" ActiveViewIndex="0">
          <asp:View runat="server" ID="vwLogin">
              <div class ="logincontainer">
                 <h2>Admin Sign In</h2>

                 <!-- Custom Email as Username -->
                 <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="txtEmail">Email:</asp:Label>
                 <asp:TextBox ID="txtEmail" runat="server" Placeholder="Email"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email required" ForeColor="Red" />
                 <br />
 
                 <!-- Custom Password -->
                 <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="txtPassword">Password:</asp:Label>
                 <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password required" ForeColor="Red" />
                 <!-- Sign In Button -->
                 <asp:Button ID="btnLogin" runat="server" Text="Sign In" CommandName="Login" OnClick="SignInAuthenticate" CssClass="btn btn-login"/>
                 <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
            </div>
              </asp:View>
         </asp:MultiView>
    </asp:Content>