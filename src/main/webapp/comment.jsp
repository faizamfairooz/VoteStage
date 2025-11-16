<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.service.CommentService" %>
<%@ page import="com.voting.service.ContestantService" %>
<%@ page import="com.voting.model.Comment" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%
    // Session check
    String userName = (String) session.getAttribute("user_name");
    String judgeId = (String) session.getAttribute("user_id");
    String contestantId = request.getParameter("contestantId");
    String videoId = request.getParameter("videoId");

    if (userName == null || judgeId == null || contestantId == null || videoId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get video details
    ResultSet videoDetails = null;
    String videoTitle = "";
    String videoPath = "";
    String contestantName = "";

    try {
        videoDetails = ContestantService.getVideoDetails(videoId);
        if (videoDetails != null && videoDetails.next()) {
            videoTitle = videoDetails.getString("title");
            videoPath = videoDetails.getString("file_path");
            contestantName = videoDetails.getString("contestant_name");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Get comments for this video
    List<Comment> comments = null;
    try {
        comments = CommentService.getCommentsByVideo(videoId);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comments - <%= contestantName %></title>
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

        .video-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .video-container {
            background: #000;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .video-container video {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

        .video-info {
            padding: 15px 0;
        }

        .comment-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .comment-form {
            margin-bottom: 30px;
        }

        .comment-form textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            resize: vertical;
            min-height: 100px;
            font-size: 1rem;
            margin-bottom: 15px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-back {
            background: #2c3e50;
            color: white;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background: #3498db;
        }

        .comment-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #3498db;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .comment-author {
            font-weight: 600;
            color: #2c3e50;
        }

        .comment-date {
            color: #7f8c8d;
            font-size: 0.9rem;
        }

        .comment-text {
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .comment-actions {
            display: flex;
            gap: 10px;
        }

        .btn-like {
            background: #27ae60;
            color: white;
            padding: 8px 16px;
            font-size: 0.9rem;
        }

        .btn-edit {
            background: #f39c12;
            color: white;
            padding: 8px 16px;
            font-size: 0.9rem;
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
            padding: 8px 16px;
            font-size: 0.9rem;
        }

        .likes-count {
            background: rgba(39, 174, 96, 0.1);
            color: #27ae60;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            margin-left: 5px;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <div class="logo">VotesStage</div>
        <div class="tagline">Comments & Feedback</div>
    </header>

    <a href="contestant-performance.jsp" class="btn btn-back">
        <i class="fas fa-arrow-left"></i> Back to Performances
    </a>

    <!-- Success/Error Messages -->
    <%
        String status = request.getParameter("status");
        String message = request.getParameter("message");
        if ("success".equals(status)) {
    %>
    <div class="success-message">
        <i class="fas fa-check-circle"></i> <%= message %>
    </div>
    <%
    } else if ("error".equals(status)) {
    %>
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i> <%= message %>
    </div>
    <%
        }
    %>

    <!-- Video Section -->
    <div class="video-section">
        <h2><%= contestantName %> - <%= videoTitle %></h2>
        <div class="video-container">
            <video controls>
                <source src="<%= videoPath %>" type="video/mp4">
                Your browser does not support the video tag.
            </video>
        </div>
        <div class="video-info">
            <p><strong>Contestant:</strong> <%= contestantName %></p>
            <p><strong>Performance:</strong> <%= videoTitle %></p>
        </div>
    </div>

    <!-- Comment Section -->
    <div class="comment-section">
        <h3>Add Your Comment</h3>
        <form action="CommentServlet" method="POST" class="comment-form">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="contestantId" value="<%= contestantId %>">
            <input type="hidden" name="videoId" value="<%= videoId %>">

            <textarea name="commentText" placeholder="Share your thoughts about this performance..." required></textarea>

            <button type="submit" class="btn btn-primary">
                <i class="fas fa-paper-plane"></i> Submit Comment
            </button>
        </form>

        <h3>Comments (<%= comments != null ? comments.size() : 0 %>)</h3>

        <%
            if (comments != null && !comments.isEmpty()) {
                for (Comment comment : comments) {
        %>
        <div class="comment-item">
            <div class="comment-header">
                <div class="comment-author">
                    <i class="fas fa-user"></i>
                    <%= comment.getJudgeName() != null ? comment.getJudgeName() : "Judge " + comment.getJudgeId() %>
                </div>
                <div class="comment-date">
                    <i class="far fa-clock"></i> <%= comment.getCommentDate() %>
                </div>
            </div>
            <div class="comment-text">
                <%= comment.getCommentText() %>
            </div>
            <div class="comment-actions">
                <form action="CommentServlet" method="POST" style="display: inline;">
                    <input type="hidden" name="action" value="like">
                    <input type="hidden" name="contestantId" value="<%= contestantId %>">
                    <input type="hidden" name="videoId" value="<%= videoId %>">
                    <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>">
                    <button type="submit" class="btn btn-like">
                        <i class="fas fa-thumbs-up"></i> Like
                        <span class="likes-count"><%= comment.getLikes() %></span>
                    </button>
                </form>

                <% if (comment.getJudgeId().equals(judgeId)) { %>
                <form action="CommentServlet" method="POST" style="display: inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="contestantId" value="<%= contestantId %>">
                    <input type="hidden" name="videoId" value="<%= videoId %>">
                    <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>">
                    <button type="submit" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this comment?')">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </form>
                <% } %>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div style="text-align: center; padding: 40px; color: #7f8c8d;">
            <i class="far fa-comments" style="font-size: 3rem; margin-bottom: 15px;"></i>
            <p>No comments yet. Be the first to comment!</p>
        </div>
        <%
            }
        %>
    </div>
</div>
</body>
</html>