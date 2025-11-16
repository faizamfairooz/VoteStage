package com.voting.service;

import com.voting.dao.CommentDAO;
import com.voting.model.Comment;
import java.util.List;

public class CommentService {

    // Get all comments for a video
    public static List<Comment> getCommentsByVideo(String videoId) {
        try {
            return CommentDAO.getCommentsByVideo(videoId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Add new comment with debug logging
    public static boolean addComment(Comment comment) {
        try {
            System.out.println("=== COMMENT SERVICE DEBUG ===");
            System.out.println("Judge ID: " + comment.getJudgeId());
            System.out.println("Video ID: " + comment.getVideoId());
            System.out.println("Comment Text: " + comment.getCommentText());

            CommentDAO.addComment(comment);
            System.out.println("Comment added successfully!");
            return true;
        } catch (Exception e) {
            System.err.println("ERROR in addComment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Update existing comment
    public static boolean updateComment(String commentId, String newText) {
        try {
            CommentDAO.updateComment(commentId, newText);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete comment
    public static boolean deleteComment(String commentId) {
        try {
            CommentDAO.deleteComment(commentId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Like comment method
    public static boolean likeComment(String commentId) {
        try {
            CommentDAO.likeComment(commentId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}