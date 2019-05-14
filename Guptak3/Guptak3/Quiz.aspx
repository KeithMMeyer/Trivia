<%@ Page Title="View" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Info.aspx.cs" Inherits="Guptak3.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <title>Triviapp</title>
    <link rel="import" href="includes/head.html">
    <script>
        var radioNames = [];
        var correct = [];
        $(document).ready(function () {
            $("#questionContainer").hide();
            $("#quizFinish").hide();
        });

        function getQuiz() {
            var quizname = $("#quizName").val();
            var d = "<table class='table table-striped table-bordered' style='max-width:700px;'>";
            service("getQuiz", "{quizName:" + JSON.stringify(quizname) + "}",
                function (response) {
                    if (response === undefined || response.length == 0) {
                        alert("Quiz not found, please enter a new quiz name");
                        $("#getQuizList").html("");
                    }
                    else {
                        $.each(response, function (index, value) {
                            var name = value.Name;
                            d += "<tr>" +
                                "<td>" + name + "</td>" +
                                "<td>" + value.Date + "</td>" +
                                "<td>" + value.NumberOfQuestions + "</td>" +
                                "<td><button type=\"button\" id=" + name + " class=\"btn btn-primary\" onclick=getQuestion(\"" + name + "\")>Take Quiz</button></td>" +
                                "</tr>";
                        });
                        $("#getQuizList").html(d + "</table><br>");
                    }
                }, function (response) {
                    alert("Error...");
                    console.log(response);
                });
        }

        function getQuestion(name) {
            $("#quizContainer").hide();
            $("#questionContainer").show();
            service("getQuestionByQuiz", "{quizName:" + JSON.stringify(name) + "}",
                function (response) {
                    radioNames = [];
                    var d = "";
                    $.each(response, function (index, value) {
                        d += "<div class='row'>"
                        var title = "<div class='row'><h3>" + value.Content + "?</h1></div>";
                        var answers = [value.CorrectAnswer, value.Incorrect1, value.Incorrect2, value.Incorrect3];
                        answers = shuffle(answers);
                        $.each(answers, function (index, ans) {
                            if (ans == value.CorrectAnswer) {
                                correct.push(index);
                            }
                        });

                        d += title +
                            "<div class='row'><input type='radio' id='questions' name=" + value.VisibleId + " value=0>" + answers[0] + "</div>" +
                            "<div class='row'><input type='radio' id='questions' name=" + value.VisibleId + " value=1>" + answers[1] + "</div>" +
                            "<div class='row'><input type='radio' id='questions' name=" + value.VisibleId + " value=2>" + answers[2] + "</div>" +
                            "<div class='row'><input type='radio' id='questions' name=" + value.VisibleId + " value=3>" + answers[3] + "</div>";
                        d += "</div>";
                        radioNames.push(value.VisibleId);
                    });
                    d += "<div class='row'><br><button type='button' class='btn btn-primary' onClick=checkQuiz()>Submit Quiz</button></div>"
                    $("#quiz").html(d);
                }, function (response) {
                    alert("Error...");
                    console.log(response);
                });
        }

        function shuffle(array) {
            var currentIndex = array.length, temporaryValue, randomIndex;

            // While there remain elements to shuffle...
            while (0 !== currentIndex) {

                // Pick a remaining element...
                randomIndex = Math.floor(Math.random() * currentIndex);
                currentIndex -= 1;

                // And swap it with the current element.
                temporaryValue = array[currentIndex];
                array[currentIndex] = array[randomIndex];
                array[randomIndex] = temporaryValue;
            }

            return array;
        }

        function checkQuiz() {
            var sum = 0;
            $.each(radioNames, function (index, value) {
                if ($('input[name=' + value + ']:checked').val() == correct[index]) {
                    sum += 1;
                }
            })
            submitScore(sum);
        }

        function submitScore(score) {
            $("#questionContainer").hide();
            $("#quizFinish").show();
            $("#finishMessage").html("Congratulations, you got " + score + " questions correct!");
        }


    </script>
</head>

<body>
    <!--Present a list of quizzes to the user, or allow them to search for a quiz-->
    <div style="margin-left:32px; margin-top:32px;" id="quizContainer">
        <h2>Quizzes</h2>
        <div class="container">
            <div class="row">
            <p>Want to make your own Quiz? <a href="AddQuiz.aspx" class="btn btn-info"> Create New Quiz</a></p>
                </div>
            <div class="row">
                <label for="quizName">Enter Quiz Name:</label>
                <input type="text" id="quizName">
                <button type="button" class="btn btn-primary" onclick=getQuiz()>Search For Quiz</button>
            </div>
            <div id="getQuizList" class="row" style="margin-top:16px;float:left;">

            </div>
        </div>
    </div>
    <!--Once quiz is chosen, go to new page or create separate area for quiz.-->
    <div style="margin-left:32px; margin-top:32px;" id="questionContainer">
        <h2>Questions</h2>
        <div class="container" id="quiz">

        </div>
    </div>

    <div style="margin-left:32px; margin-top:32px;" id="quizFinish">
        <p id="finishMessage">

        </p>
        <button type="button" class="btn btn-primary" onclick=location.reload()>Go Back To Quizzes</button>
    </div>
</body>

</html>
</asp:Content>
