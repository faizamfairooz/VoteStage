package com.voting.dao;

import com.voting.model.Comment;
import com.voting.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    // Add comment - UPDATED to match EXACT database schema
    public static void addComment(Comment comment) throws SQLException {
        // Generate a simple comment ID
        String commentId = "CMT" + (System.currentTimeMillis() % 10000);

        String sql = "INSERT INTO Comments (comment_id, video_id, person_id, comment_text, comment_date, commented_by_type) VALUES (?, ?, ?, ?, ?, 'Person')";

        System.out.println("DEBUG: Inserting comment - ID: " + commentId + ", Video: " + comment.getVideoId() + ", Judge: " + comment.getJudgeId());

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, commentId);
            ps.setString(2, comment.getVideoId());
            ps.setString(3, comment.getJudgeId());
            ps.setString(4, comment.getCommentText());
            ps.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis()));

            int rows = ps.executeUpdate();
            System.out.println("DEBUG: Rows affected: " + rows);

        } catch (SQLException e) {
            System.err.println("SQL Error in addComment: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // Get all comments for a video - UPDATED
    public static List<Comment> getCommentsByVideo(String videoId) throws SQLException {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.comment_id, c.video_id, c.person_id, p.name as judge_name, c.comment_text, c.comment_date, COALESCE(c.likes_count, 0) as likes_count " +
                "FROM Comments c " +
                "LEFT JOIN Persons p ON c.person_id = p.person_id " +
                "WHERE c.video_id = ? AND c.commented_by_type = 'Person' " +
                "ORDER BY c.comment_date DESC";

        System.out.println("DEBUG: Loading comments for video: " + videoId);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, videoId);
            ResultSet rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
                Comment c = new Comment();
                c.setCommentId(rs.getString("comment_id"));
                c.setVideoId(rs.getString("video_id"));
                c.setJudgeId(rs.getString("person_id"));
                c.setJudgeName(rs.getString("judge_name"));
                c.setCommentText(rs.getString("comment_text"));
                c.setCommentDate(rs.getTimestamp("comment_date"));
                c.setLikes(rs.getInt("likes_count"));
                comments.add(c);
            }
            System.out.println("DEBUG: Loaded " + count + " comments");

        } catch (SQLException e) {
            System.err.println("SQL Error in getCommentsByVideo: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return comments;
    }

    // Update comment - UPDATED
    public static void updateComment(String commentId, String newText) throws SQLException {
        String sql = "UPDATE Comments SET comment_text = ? WHERE comment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newText);
            ps.setString(2, commentId);
            ps.executeUpdate();
        }
    }

    // Delete comment - UPDATED
    public static void deleteComment(String commentId) throws SQLException {
        String sql = "DELETE FROM Comments WHERE comment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, commentId);
            ps.executeUpdate();
        }
    }

    // Like comment - UPDATED
    public static void likeComment(String commentId) throws SQLException {
        String sql = "UPDATE Comments SET likes_count = COALESCE(likes_count, 0) + 1 WHERE comment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, commentId);
            ps.executeUpdate();
        }
    }
}