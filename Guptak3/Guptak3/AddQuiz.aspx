<%@ Page Title="View" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Info.aspx.cs" Inherits="Guptak3.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <title>Triviapp</title>
    <link rel="import" href="includes/head.html">
    <script>
        var name = "";
        $(document).ready(function () {
            $("#addQuestionContainer").hide();
        });

        function getQuizVar() {
            var quizname = $("#quizname").val();
            name = quizname;
            var date = new Date();
            var number = parseInt($("#numOfQuestions").val());
            createQuiz(quizname, date, number);
        }

        function getQuestionVar(number) {
            var i
            for (i = 0; i < number; i++) {
                var quizname = name;
                var foundEmptyId = 0;
                var questionId = $("#qid" + (i+1)).val();
                var content = $("#content" + (i + 1)).val();
                var correct = $("#correct" + (i + 1)).val();
                var incOne = $("#incOne" + (i + 1)).val();
                var incTwo = $("#incTwo" + (i + 1)).val();
                var incThree = $("#incThree" + (i + 1)).val();
                createQuestion(quizname, content, questionId, correct, incOne, incTwo, incThree);
            }
            location.reload();
        }


        function createQuiz(quizname, date, number) {
            service("createQuiz", "{NumberOfQuestions:" + number + ", Date:" + JSON.stringify(date) + ", QuizName:" + JSON.stringify(quizname) + "}",
                function (response) {
                    alert("Success");
                    console.log(response);
                    addQuestions(number);
                },
                function (response) {
                    alert("Error...");
                    console.log(response);
                });
        }

        function addQuestions(number) {
            $("#addQuizContainer").hide();
            $("#addQuestionContainer").show();
            var d = "";
            var i;
            for (i = 1; i <= number; i++) {
                d += "      <div class=\"row\">" +
                    "<h2>Question " + i + "</h2>" +
                    "</div>" +
                    "<div class=\"row\">" +
                    "Enter your content: <br>" +
                    "<textarea rows=\"5\" cols=\"30\" id=\"content" + i + "\"></textarea>" +
                    "</div>" +
                    "<br>" +
                    "<div class=\"row\">" +
                    "Enter the question ID:" +
                    "<input type=\"text\" id=\"qid" + i + "\">" +
                    "</div>" +
                    "<br>" +
                    "<div class=\"row\">" +
                    "Enter the correct answer:" +
                    "<input type=\"text\" id=\"correct" + i + "\">" +
                    "</div>" +
                    "<br>" +
                    "<div class=\"row\">" +
                    "Enter incorrect answer number one:" +
                    "<input type=\"text\" id=\"incOne" + i + "\">" +
                    "</div>" +
                    "<br>" +
                    "<div class=\"row\">" +
                    "Enter incorrect answer number two:" +
                    "<input type=\"text\" id=\"incTwo" + i + "\">" +
                    "</div>" +
                    "<br>" +
                    "<div class=\"row\">" +
                    "Enter incorrect answer number three:" +
                    "<input type=\"text\" id=\"incThree" + i + "\">" +
                    "</div><br>";
            }
            d += "<div class=\"row\"><button type=\"button\" class=\"btn btn-primary\" onclick=getQuestionVar(" + number + ")>Submit</button></div>";
            $("#addQuestionContainer").html(d);

        }

        function createQuestion(quizname, content, id, correct, incOne, incTwo, incThree) {
            service("createQuestion", "{questionId:" + id + ", content:" + JSON.stringify(content) + ", quizName:" + JSON.stringify(quizname) +
                ", correct:" + JSON.stringify(correct) + ", incorrectOne:" + JSON.stringify(incOne) + ", incorrectTwo:" + JSON.stringify(incTwo) +
                ", incorrectThree:" + JSON.stringify(incThree) + "}",
                function (response) {
                    alert("Success");
                    console.log(response);
                },
                function (response) {
                    alert("Error...");
                    console.log(response);
                });
        }


    </script>
</head>

<body>
    <div style="margin-left:32px; margin-top:32px;" class="container" id="addQuizContainer">
        <div class="row">
            <h2>Create a quiz</h2>
        </div>
        <div class="row">
            Enter your quiz name:
            <input type="text" id="quizname">
        </div>
        <br>
        <div class="row">
            Enter the number of questions for the quiz:
            <input type="text" id="numOfQuestions">
        </div>
        <br>
        <div class="row">
            <button type="button" onclick=getQuizVar() class="btn btn-primary">Create Quiz</button>
        </div>
    </div>

    <div style="margin-left:32px; margin-top:32px;" class="container" id="addQuestionContainer">

    </div>
</body>

</html>
    </asp:Content>