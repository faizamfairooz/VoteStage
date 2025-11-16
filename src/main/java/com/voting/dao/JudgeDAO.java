package com.voting.dao;
import com.voting.model.Judge;
import com.voting.observer.VotingSubject;
import com.voting.util.DBConnection;
import com.voting.util.VoteIDGenerator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class JudgeDAO {
    
    // Static instance of VotingSubject for Observer pattern
    private static final VotingSubject votingSubject = new VotingSubject();
    
    /**
     * Get the VotingSubject instance
     * @return VotingSubject instance
     */
    public static VotingSubject getVotingSubject() {
        return votingSubject;
    }

    public static void insertJudge(Judge judge) throws SQLException {
        String personId = PersonDAO.insertPerson(judge);

        String sql = "INSERT INTO Judges (person_id, judge_vote_count) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, personId);
            ps.setInt(2, judge.getJudgeVoteCount());

            ps.executeUpdate();
        }
    }

    public static Judge getJudgeById(String id) throws SQLException {
        Judge judge = new Judge();
        String sql = "SELECT p.*, j.judge_vote_count FROM Persons p JOIN Judges j ON p.person_id = j.person_id WHERE p.person_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                judge.setId(rs.getString("person_id"));
                judge.setName(rs.getString("name"));
                judge.setEmail(rs.getString("email"));
                judge.setPassword(rs.getString("password"));
                judge.setRole(rs.getString("role"));
                judge.setJudgeVoteCount(rs.getInt("judge_vote_count"));
                return judge; // Don't forget to return the judge
            }
        }
        return null; // Return null if not found
    }

    // New method to record golden vote
    // In JudgeDAO.java - Fix the recordGoldenVote method
    public static void recordGoldenVote(String personId, String contestantId, String contestantName,
                                        String performance, String judgeName, String videoId) throws SQLException {

        // First, verify that the contestant exists in Persons table
        String checkSql = "SELECT COUNT(*) FROM Contestants WHERE contestant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            checkPs.setString(1, contestantId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt(1) == 0) {
                throw new SQLException("Contestant with ID '" + contestantId + "' does not exist in Contestants table.");
            }
        }

        // Generate vote ID
        String voteId = VoteIDGenerator.generateVoteId("golden");

        // Fixed SQL to match your database schema
        String sql = "INSERT INTO GoldenVotes (vote_id, contestant_id, person_id, video_id, vote_date, vote_type, status) VALUES (?, ?, ?, ?, GETDATE(), 'Golden', 'Active')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, voteId);
            ps.setString(2, contestantId);
            ps.setString(3, personId); // judge ID
            ps.setString(4, videoId); // You need to pass actual video_id - this should come from frontend

            ps.executeUpdate();

            // Notify observers about the golden vote using Observer pattern
            System.out.println("🏆 JudgeDAO: Golden vote recorded, notifying observers...");
            votingSubject.notifyGoldenVote(contestantId, personId, judgeName); // Fixed parameter name
        }
    }


    // Get golden votes for dashboard
    // In JudgeDAO.java - FIX the getGoldenVotes method
    public static ResultSet getGoldenVotes() throws SQLException {
        // Updated SQL to include contestant name and performance title
        String sql = "SELECT g.vote_id, g.contestant_id, c.contestant_name, " +
                "v.title as performance, g.vote_date, p.name as judge_name " +
                "FROM GoldenVotes g " +
                "LEFT JOIN Contestants c ON g.contestant_id = c.contestant_id " +
                "LEFT JOIN Videos v ON g.video_id = v.video_id " +
                "LEFT JOIN Persons p ON g.person_id = p.person_id " +
                "WHERE g.status = 'Active' " +
                "ORDER BY g.vote_date DESC";

        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }

    // Get golden votes received by a specific contestant
    public static ResultSet getGoldenVotesByContestant(String contestantId) throws SQLException {
        String sql = "SELECT * FROM GoldenVotes WHERE contestant_id = ? ORDER BY vote_date DESC";
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, contestantId);
        return ps.executeQuery();
    }

    // Check if judge has already given golden vote to contestant
    // Fix hasGivenGoldenVote method
    public static boolean hasGivenGoldenVote(String judgeId, String contestantId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM GoldenVotes WHERE person_id = ? AND contestant_id = ? AND status = 'Active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ps.setString(2, contestantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }


    // Check if judge has already given any golden vote (to any contestant)
    public static boolean hasGivenAnyGoldenVote(String judgeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM GoldenVotes WHERE person_id = ? AND status = 'Active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }



    // Get current golden vote details for judge
    public static ResultSet getJudgeGoldenVote(String judgeId) throws SQLException {
        String sql = "SELECT * FROM GoldenVotes WHERE person_id = ? AND status = 'Active'";
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, judgeId);
        return ps.executeQuery();
    }

    // In JudgeDAO.java - ENHANCE the revokeGoldenVote method
    public static boolean revokeGoldenVote(String judgeId, String contestantId) throws SQLException {
        String sql = "UPDATE GoldenVotes SET status = 'Revoked' WHERE person_id = ? AND contestant_id = ? AND status = 'Active'";

        System.out.println("DEBUG: Revoking golden vote - judgeId: " + judgeId + ", contestantId: " + contestantId);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ps.setString(2, contestantId);

            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: Rows affected by revocation: " + rowsAffected);

            return rowsAffected > 0;
        }
    }


    // Method to record regular vote
    public static void recordRegularVote(String judgeId, String contestantId, String contestantName,
                                         String performance, String judgeName, String videoId) throws SQLException {

        // Add contestant validation for regular votes
        String checkSql = "SELECT COUNT(*) FROM Contestants WHERE contestant_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            checkPs.setString(1, contestantId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt(1) == 0) {
                throw new SQLException("Contestant with ID '" + contestantId + "' does not exist in Contestants table.");
            }
        }

        // Generate vote ID
        String voteId = VoteIDGenerator.generateVoteId("regular");

        // Fixed SQL to match your database schema
        String sql = "INSERT INTO RegularVotes (vote_id, contestant_id, person_id, video_id, score, vote_type) VALUES (?, ?, ?, ?, 10, 'Regular')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, voteId);
            ps.setString(2, contestantId);
            ps.setString(3, judgeId); // person_id (judge ID)
            ps.setString(4, videoId); // You need to pass actual video_id - this should come from frontend

            ps.executeUpdate();

            System.out.println("DEBUG: Regular vote recorded - Contestant: " + contestantId + ", Video: " + videoId);
        }
    }

    // Check if judge has already given regular vote to contestant today
    public static boolean hasGivenRegularVoteToday(String judgeId, String contestantId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM RegularVotes WHERE person_id = ? AND contestant_id = ? AND CONVERT(DATE, vote_date) = CONVERT(DATE, GETDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, judgeId);
            ps.setString(2, contestantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }

    // In JudgeDAO.java - Add method to get regular votes for dashboard
    public static ResultSet getRegularVotes() throws SQLException {
        // Updated SQL to include contestant name and performance title
        String sql = "SELECT r.vote_id, r.contestant_id, c.contestant_name, " +
                "v.title as performance, r.vote_date, p.name as judge_name, r.score " +
                "FROM RegularVotes r " +
                "LEFT JOIN Contestants c ON r.contestant_id = c.contestant_id " +
                "LEFT JOIN Videos v ON r.video_id = v.video_id " +
                "LEFT JOIN Persons p ON r.person_id = p.person_id " +
                "ORDER BY r.vote_date DESC";

        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }
}