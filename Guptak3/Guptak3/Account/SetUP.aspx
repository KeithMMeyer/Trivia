<%@ Page Title="SetUp" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SetUp.aspx.cs" Inherits="Guptak3.Account.SetUp" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

<script>
	function service(method, data, success, fail) {
		$.ajax({
			type: "POST",
			url: "../api.asmx/" + method,
			data: data,
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: success,
			error: fail
		});
	}
</script>

<h2><%: Title %>.</h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <div class="form-horizontal">
        <h4>Almost Done!</h4>
        <hr />
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="FirstName" CssClass="col-md-2 control-label">First Name</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="FirstName" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName"
                    CssClass="text-danger" ErrorMessage="The name field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="LastName" CssClass="col-md-2 control-label">Last Name</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="LastName" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="LastName"
                    CssClass="text-danger" ErrorMessage="The name field is required." />
            </div>
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="MiamiCheck" CssClass="col-md-2 control-label">Miami Student?</asp:Label>
            <div class="col-md-10">
                <asp:CheckBox id="MiamiCheck" runat="server"
                    AutoPostBack="True"
                    TextAlign="Left"
                    />
            </div>
        </div>

            <div class="col-md-offset-2 col-md-10">
                <button id="btnCret" type="button" class="btn btn-default" onclick="createUser()"> Create Account</button>
        </div>
    <script>

            function createUser() {
            service("createUser", "{userName:\"" + "<%: Context.User.Identity.GetUserName()%>" + "\", firstName:\"" + $("#MainContent_FirstName").val() + "\", lastName:\"" + $("#MainContent_LastName").val() + "\", student:" + false + "}",
                function (response) {
                    //showInvoices(selectedVendor);
                    alert("Account Created!");
                    window.location.replace("../info.aspx");
                }, function (response) {
                    alert("Error");
                    console.log(response);
                });
        }



    </script>
    <asp:Label ID="slaveFunc" runat="server"></asp:Label> 

</asp:Content>
