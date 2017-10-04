<%@ Page Title="Azure Admin" Language="C#" MasterPageFile="~/AzureAdmin.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="azureadmin.net.Default" %>
<%@ MasterType VirtualPath ="~/AzureAdmin.Master" %>

<asp:Content ID="DefaultTitle" ContentPlaceHolderID="PageTitle" runat="server">Azure Admin</asp:Content>

<asp:Content ID="DefaultSynopsis" ContentPlaceHolderID="PageSynopsis" runat="server">
  <p>Personal experiences with Microsoft Azure.</p>
</asp:Content>

<asp:Content ID="DefaultContent" ContentPlaceHolderID="PageContent" runat="server">
</asp:Content>

<asp:Content ID="DefaultNavigation" ContentPlaceHolderID="PageNavigation" runat="server">
  <a href="https://azure.microsoft.com/en-us/" title="Microsoft Azure">Azure</a>
</asp:Content>
