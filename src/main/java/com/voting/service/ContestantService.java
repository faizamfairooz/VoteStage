package com.voting.service;

import com.voting.dao.ContestantDAO;
import com.voting.dao.VoterDAO;
import com.voting.model.Contestant;
import com.voting.model.Voter;
import com.voting.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.voting.dao.VoterDAO.getVoterById;

public class ContestantService {

    public static ResultSet getContestantsWithVideos() throws SQLException {
        String sql = "SELECT " +
                "c.contestant_id, " +
                "c.contestant_name, " +
                "c.age, " +
                "c.gender, " +
                "c.total_votes_received, " +
                "c.image_path, " +
                "v.video_id, " +
                "v.title, " +
                "v.description, " +
                "v.original_singer, " +
                "v.duration, " +
                "v.file_path " +
                "FROM Contestants c " +
                "LEFT JOIN Videos v ON c.contestant_id = v.contestant_id " +
                "WHERE v.video_id IS NOT NULL " +  // Only contestants with videos
                "ORDER BY c.contestant_name";

        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }

    public static String getVideoFilePath(String videoId) throws SQLException {
        String sql = "SELECT file_path FROM Videos WHERE video_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, videoId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("file_path");
            }
            return "videos/default.mp4"; // fallback
        }
    }

    public static ResultSet getAllContestants() throws SQLException {
        String sql = "SELECT contestant_id, contestant_name, email, age, gender, total_votes_received, image_path FROM Contestants ORDER BY contestant_name";
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }

    public static void registerContestant(Contestant contestant) throws SQLException {
        ContestantDAO.insertContestant(contestant);
    }

    public static Contestant getContestantById(String id) throws SQLException {
        return ContestantDAO.getContestantById(id);
    }

    public static void receiveVote(String contestantId) throws SQLException {
        Contestant contestant = getContestantById(contestantId);

        if (contestant == null) {
            throw new IllegalArgumentException("Contestant not found");
        }

        contestant.setTotalVotesReceived(contestant.getTotalVotesReceived() + 1);
        ContestantDAO.updateContestant(contestant);

        System.out.println(contestant.getName() + " received a vote! Total: " + contestant.getTotalVotesReceived());
    }

    // ❌ eliminateContestant() method REMOVED — no longer needed
    public static void castVote(String voterId, String contestantId) throws SQLException {
        Voter voter = getVoterById(voterId);
        if (voter == null) {
            throw new IllegalArgumentException("Voter not found");
        }

        Contestant contestant = ContestantDAO.getContestantById(contestantId);
        if (contestant == null) {
            throw new IllegalArgumentException("Contestant not found");
        }

        // ✅ NO ELIMINATION CHECK — contestants can always receive votes

        contestant.setTotalVotesReceived(contestant.getTotalVotesReceived() + 1);
        ContestantDAO.updateContestant(contestant);

        voter.setVoteCount(voter.getVoteCount() + 1);
        VoterDAO.updateVoter(voter);

        System.out.println("✅ Vote cast successfully by " + voter.getName() +
                " for contestant " + contestant.getName());
    }
}