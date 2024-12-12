<%@ Page Title="Food Community Donations" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Food_Donor_Management_System._Default" %>




<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main style="background-image: url('/Images/fooddonation.jpeg'); background-size: cover; background-position: center center; height: 100vh; display: flex; justify-content: center; align-items: center;">
        <section id="main_section" class="row" aria-labelledby="aspnetTitle">
            <h1 id="aspnetTitle" style="background-color:white;font-weight:bold">Food Community Donations</h1>
            <p class="lead" style="background-color:white;font-weight:bold">Always help people in need</p>
            <p><a runat="server" href="~/Login" class="btn btn-primary btn-md" style="background-color:white;color:black;border: 2px solid #333;box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);">Donate Today</a></p>
        </section>
    </main>

</asp:Content>
