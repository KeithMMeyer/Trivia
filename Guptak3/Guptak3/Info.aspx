<%@ Page Title="View" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Info.aspx.cs" Inherits="Guptak3.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<html>
<head>
    <title>GameSource</title>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="import" href="includes/head.html">
</head>
<body>
            <div class="container">
                <h1>TriviApp</h1>
                <h3>Search</h3>
                <form id="gameSearch">
                    <div class="form-group">
                        <label for="gameSearch">Name</label>
                        <input type="text" class="form-control" id="gameSearch" placeholder="Search for a game ...">
                    </div>
                    <button type="button" class="btn btn-primary">Search</button>
                </form>
            </div>

            <div class="container" id="games">
            </div>
            <p class="text-center"><button  id="leftbtn" type="button" class="btn btn-link"><</button> Page <span id="pageCount">1</span> <button type="button"  id="rightbtn" class="btn btn-link">></button> </p>

            <script>
                var pageCount = 1;
                $(document).ready(function () {
                    getFacts(1);

                    function getFacts(page) {
                        var d = "<h1>Facts</h1>";
                        service("getFullFacts", "{amount:" + 10 + ", page:" + page + "}",
                            function (response) {
                                $.each(response, function (index, value) {
                                    d += "<a href=Game?id='" + value.VisibleID + "' class='list-group-item'>" +
                                        "<h4 class='list-group-item-heading'>" + value.Type + "</h4>" +
                                        "<p class='list-group-item-text'><b>Info:</b><br />" +
                                        value.Content + "</p></a>";
                                });
                                $("#games").html(d);
                            }, function (response) {
                                alert("Error...");
                                console.log(response);
                            });
                    }

                    $("#rightbtn").click(function () {
                        pageCount += 1;
                        getFacts(pageCount);
                        $("#pageCount").html(pageCount)
                    }
                    );


                    $("#leftbtn").click(function () {
                        if (pageCount > 1) {
                            pageCount -= 1;
                            getFacts(pageCount);
                            $("#pageCount").html(pageCount)
                        }
                    }
                    );





                }
                );

            </script>
            <div class="footer">
                <p><br /><br /><br />&copy2019 TriviApp</p>
                <p align="center">Need Help? Submit a request <a href="SubmitForm.html">here</a></p>
            </div>
</body>
</html>
</asp:Content>
