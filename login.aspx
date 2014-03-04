<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <h2>Please sign in</h2>
        <asp:Label ID="FlashMessage" runat="server" Visible="false" Text="Forkert brugernavn eller adganskode"></asp:Label><br />
        <asp:TextBox ID="UserNameTextB" runat="server" Text="" placeholder="username"></asp:TextBox>
        <asp:TextBox ID="PasswordTextB" runat="server" Text="" placeholder="Password" TextMode="Password"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" Text="Sign in" OnClick="Button1_Click" />
        <br />
        <asp:Button ID="Button2" runat="server" Text="fortsæt som gæst" OnClick="Button2_Click"/>

</asp:Content>

