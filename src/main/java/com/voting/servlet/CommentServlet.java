package com.voting.servlet;

import com.voting.model.Comment;
import com.voting.service.CommentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String judgeId = (String) session.getAttribute("user_id");
        String videoId = request.getParameter("videoId");
        String contestantId = request.getParameter("contestantId");
        String action = request.getParameter("action");

        if (judgeId == null || videoId == null || action == null) {
            response.sendRedirect("error.jsp?message=InvalidSessionOrParameters");
            return;
        }

        boolean success = false;
        String message = "";

        // Handle Actions
        if ("add".equals(action)) {
            String commentText = request.getParameter("commentText");

            if (commentText != null && !commentText.trim().isEmpty()) {
                Comment comment = new Comment();
                comment.setJudgeId(judgeId);
                comment.setVideoId(videoId);
                comment.setContestantId(contestantId);
                comment.setCommentText(commentText);
                comment.setCommentDate(new Timestamp(System.currentTimeMillis()));

                success = CommentService.addComment(comment);
                message = success ? "Comment added successfully!" : "Failed to add comment";
            }

        } else if ("edit".equals(action)) {
            String commentId = request.getParameter("commentId");
            String newText = request.getParameter("newCommentText");

            if (commentId != null && newText != null) {
                success = CommentService.updateComment(commentId, newText);
                message = success ? "Comment updated successfully!" : "Failed to update comment";
            }

        } else if ("delete".equals(action)) {
            String commentId = request.getParameter("commentId");

            if (commentId != null) {
                success = CommentService.deleteComment(commentId);
                message = success ? "Comment deleted successfully!" : "Failed to delete comment";
            }

        } else if ("like".equals(action)) {
            String commentId = request.getParameter("commentId");

            if (commentId != null) {
                success = CommentService.likeComment(commentId);
                message = success ? "Comment liked!" : "Failed to like comment";
            }

        } else {
            message = "Unknown action";
        }

        // Redirect back to comment page
        String status = success ? "success" : "error";
        response.sendRedirect("comment.jsp?contestantId=" + contestantId + "&videoId=" + videoId + "&status=" + status + "&message=" + message);
    }
}