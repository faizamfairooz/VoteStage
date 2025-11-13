<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.service.JudgeService" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Objects" %>
<%
    // Get parameters from the URL
    String contestantId = request.getParameter("contestantId");
    String contestantName = request.getParameter("contestantName");
    String videoId = request.getParameter("videoId");

    // Get judge info from session
    String judgeName = (String) session.getAttribute("user_name");
    String judgeId = (String) session.getAttribute("user_id");

    if (judgeName == null || judgeId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Validate video ID
    if (videoId == null || videoId.equals("null") || videoId.trim().isEmpty()) {
        response.sendRedirect("contestant-performance.jsp?error=Invalid video selection");
        return;
    }

    // Get messages from session
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    // Clear messages from session after displaying
    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");

    // Check golden vote status
    boolean hasUsedGoldenVote = false;
    String currentGoldenVoteContestantId = null;
    String currentGoldenVoteContestant = "another contestant";
    boolean hasGivenToThisContestant = false;

    try {
        hasUsedGoldenVote = JudgeService.hasGivenAnyGoldenVote(judgeId);

        if (hasUsedGoldenVote) {
            ResultSet goldenVote = JudgeService.getJudgeGoldenVote(judgeId);
            if (goldenVote.next()) {
                currentGoldenVoteContestantId = goldenVote.getString("contestant_id");
                currentGoldenVoteContestant = goldenVote.getString("contestant_name");

                if (currentGoldenVoteContestant == null || currentGoldenVoteContestant.trim().isEmpty()) {
                    currentGoldenVoteContestant = "Contestant " + currentGoldenVoteContestantId;
                }

                hasGivenToThisContestant = Objects.equals(currentGoldenVoteContestantId, contestantId);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Set video URL
    String videoUrl = "videos/emma_performance.mp4";
    if ("VID002".equals(videoId)) {
        videoUrl = "videos/tom_performance.mp4";
    } else if ("VID003".equals(videoId)) {
        videoUrl = "videos/sophia_performance.mp4";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote for <%= contestantName %> - VotesStage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%);
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px 0;
            background: linear-gradient(135deg, #2c3e50, #3498db);
            color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .logo {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .tagline {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .page-title {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-title h1 {
            font-size: 2.2rem;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .page-title p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }

        .video-container-large {
            background: #000;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .video-container-large video {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

        .vote-form {
            margin-bottom: 30px;
        }

        .vote-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .btn {
            padding: 20px;
            border: none;
            border-radius: 10px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
        }

        .btn-vote-large {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .btn-vote-large:hover {
            background: linear-gradient(135deg, #2980b9, #2573a7);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.4);
        }

        .btn-golden-large {
            background: linear-gradient(135deg, #ffd700, #ffb700);
            color: #2c3e50;
        }

        .btn-golden-large:hover {
            background: linear-gradient(135deg, #ffb700, #ffa500);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(255, 215, 0, 0.4);
        }

        .golden-vote-info {
            background: #e8f4fd;
            color: #2c3e50;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .golden-vote-warning {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ffc107;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-transfer {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            color: white;
        }

        .btn-transfer:hover {
            background: linear-gradient(135deg, #8e44ad, #7d3c98);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(155, 89, 182, 0.4);
        }

        .btn-revoke-large {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }

        .btn-revoke-large:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(231, 76, 60, 0.4);
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: #2c3e50;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: background 0.3s ease;
        }

        .back-link:hover {
            background: #3498db;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .judge-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        @media (max-width: 768px) {
            .vote-options {
                grid-template-columns: 1fr;
            }

            .video-container-large video {
                height: 300px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <div class="logo">VotesStage</div>
        <div class="tagline">Voting Panel</div>
    </header>

    <div class="page-title">
        <h1>Vote for <%= contestantName %></h1>
    </div>
    <div class="judge-info">
        <strong>Judge:</strong> <%= judgeName %> | <strong>Contestant:</strong> <%= contestantName %>
        <% if (hasUsedGoldenVote) { %>
        | <strong style="color: #e74c3c;">Golden Vote Used</strong>
        <% } else { %>
        | <strong style="color: #27ae60;">Golden Vote Available</strong>
        <% } %>
    </div>

    <% if (hasUsedGoldenVote && hasGivenToThisContestant) { %>
    <div class="golden-vote-info">
        <i class="fas fa-crown" style="color: #ffd700;"></i>
        <strong>You have given your golden vote to this contestant!</strong> Click "Revoke Golden Vote" to take it back.
    </div>
    <% } else if (hasUsedGoldenVote) { %>
    <div class="golden-vote-warning">
        <i class="fas fa-exclamation-triangle"></i>
        <strong>You have already used your golden vote on <%= currentGoldenVoteContestant %>.</strong>
        You must revoke it first before giving it to another contestant.
    </div>
    <% } else { %>
    <div class="golden-vote-info">
        <i class="fas fa-info-circle"></i>
        <strong>Golden Vote Available:</strong> Each judge can give only ONE golden vote total. Choose wisely!
    </div>
    <% } %>

    <% if (successMessage != null) { %>
    <div class="success-message">
        <i class="fas fa-check-circle"></i> <%= successMessage %>
    </div>
    <% } %>

    <% if (errorMessage != null) { %>
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
    </div>
    <% } %>

    <div class="video-container-large">
        <h3 style="text-align: center; margin-bottom: 15px; color: #2c3e50;">
            <i class="fas fa-play-circle"></i> <%= contestantName %> - Performance
        </h3>
        <video controls width="100%" height="400" style="border-radius: 8px;">
            <source src="<%= videoUrl %>" type="video/mp4">
            Your browser does not support the video tag.
        </video>
    </div>


    <!-- VOTE FORM - This will submit to the servlet -->
    <form method="post" action="vote" class="vote-form">
        <input type="hidden" name="contestantId" value="<%= contestantId %>">
        <input type="hidden" name="contestantName" value="<%= contestantName %>">
        <input type="hidden" name="videoId" value="<%= videoId %>">

        <div class="vote-options">
            <!-- REGULAR VOTE BUTTON -->
            <button type="submit" name="voteType" value="regular" class="btn btn-vote-large">
                <i class="fas fa-vote-yea"></i> Regular Vote (10 Points)
            </button>

            <!-- GOLDEN VOTE BUTTONS -->
            <% if (hasUsedGoldenVote && hasGivenToThisContestant) { %>
            <button type="submit" name="voteType" value="revoke" class="btn btn-revoke-large">
                <i class="fas fa-times"></i> Revoke Golden Vote
            </button>
            <% } else if (hasUsedGoldenVote) { %>
            <button type="button" class="btn btn-transfer" onclick="location.href='contestant-performance.jsp'">
                <i class="fas fa-lock"></i>Vote Locked
            </button>

            <% } else { %>
            <button type="submit" name="voteType" value="golden" class="btn btn-golden-large">
                <i class="fas fa-crown"></i> Give Golden Vote
            </button>
            <% } %>
        </div>
    </form>

    <a href="contestant-performance.jsp" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Contestants
    </a>
</div>

<script>
    // Auto-scroll to messages if they exist
    window.addEventListener('load', function() {
        <% if (successMessage != null || errorMessage != null) { %>
        window.scrollTo(0, 0);
        <% } %>
    });

        // Confirmation for revoking golden vote
        const revokeButton = document.querySelector('.btn-revoke-large');
        if (revokeButton) {
            console.log('Revoke button found');
            revokeButton.addEventListener('click', function(e) {
                console.log('Revoke button clicked');
                if (!confirm('Are you sure you want to revoke your golden vote from <%= contestantName %>? This will free up your golden vote for another contestant.')) {
                    e.preventDefault();
                    console.log('Revoke cancelled by user');
                }
            });
        }

        // Confirmation for giving golden vote
        const giveGoldenButton = document.querySelector('.btn-golden-large');
        if (giveGoldenButton) {
            console.log('Give golden button found');
            giveGoldenButton.addEventListener('click', function(e) {
                console.log('Give golden button clicked');
                if (!confirm('Are you sure you want to give your golden vote to <%= contestantName %>? Each judge gets only ONE golden vote total.')) {
                    e.preventDefault();
                    console.log('Give golden cancelled by user');
                }
            });
        }
    });
</script>
</body>
</html>


