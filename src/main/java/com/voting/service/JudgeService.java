package com.voting.service;

import com.voting.dao.JudgeDAO;
import com.voting.model.Judge;
import com.voting.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class JudgeService {

    public static void registerJudge(Judge judge) throws SQLException {
        if (judge == null) {
            throw new IllegalArgumentException("Judge object cannot be null");
        }
        JudgeDAO.insertJudge(judge);
    }

    public static Judge getJudgeById(String id) throws SQLException {
        return JudgeDAO.getJudgeById(id);
    }

    // Add this method to JudgeService.java
    public static ResultSet getJudgeGoldenVote(String judgeId) {
        Connection conn = null;
        try {
            String sql = "SELECT g.contestant_id, c.contestant_name, g.vote_date " +
                    "FROM GoldenVotes g " +
                    "LEFT JOIN contestants c ON g.contestant_id = c.contestant_id " +
                    "WHERE g.person_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, judgeId);
            return pstmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }


    // New method to handle golden vote
    public static boolean recordGoldenVote(String judgeId, String contestantId, String contestantName,
                                           String performance, String judgeName, String videoId) throws SQLException {
        // Check if judge has already given golden vote to this contestant
        if (JudgeDAO.hasGivenGoldenVote(judgeId, contestantId)) {
            return false; // Already voted
        }

        JudgeDAO.recordGoldenVote(judgeId, contestantId, contestantName, performance, judgeName, videoId);
        return true;
    }

    public static boolean validateJudge(String judgeId) throws SQLException {
        Judge judge = getJudgeById(judgeId);
        return judge != null && "Judge".equals(judge.getRole());
    }

    // Get golden votes for display
    public static ResultSet getGoldenVotes() throws SQLException {
        return JudgeDAO.getGoldenVotes();
    }

    // Add this method to your JudgeService.java

    // New method to handle regular vote
    public static boolean recordRegularVote(String judgeId, String contestantId, String contestantName,
                                            String performance, String judgeName, String videoId) throws SQLException {
        // Check if judge has already given regular vote to this contestant today
        if (JudgeDAO.hasGivenRegularVoteToday(judgeId, contestantId)) {
            return false; // Already voted today
        }

        JudgeDAO.recordRegularVote(judgeId, contestantId, contestantName, performance, judgeName, videoId);
        return true;
    }

    // Add this method to your existing JudgeService.java
    public static boolean hasGivenGoldenVote(String judgeId, String contestantId) throws SQLException {
        return JudgeDAO.hasGivenGoldenVote(judgeId, contestantId);
    }

    // Add this method to your existing JudgeService.java
    public static boolean revokeGoldenVote(String judgeId, String contestantId) throws SQLException {
        return JudgeDAO.revokeGoldenVote(judgeId, contestantId);
    }

    // Check if judge has already given any golden vote
    // In JudgeService.java - FIX the hasGivenAnyGoldenVote method
    public static boolean hasGivenAnyGoldenVote(String judgeId) throws SQLException {
        // Use JudgeDAO instead of creating new connection
        return JudgeDAO.hasGivenAnyGoldenVote(judgeId);
    }
}