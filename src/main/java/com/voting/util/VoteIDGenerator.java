package com.voting.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VoteIDGenerator {

    public static synchronized String generateVoteId(String voteType) throws SQLException {
        String prefix = "RVID"; // Default prefix for regular votes

        if ("golden".equalsIgnoreCase(voteType)) {
            prefix = "GVID"; // Golden vote prefix
        }

        String tableName = "RegularVotes"; // Updated table name
        if ("golden".equalsIgnoreCase(voteType)) {
            tableName = "GoldenVotes"; // Updated table name
        }

        // Get the current maximum vote_id from the database
        String getMaxIdSql = "SELECT MAX(vote_id) FROM " + tableName;
        String newVoteId = "";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(getMaxIdSql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String maxId = rs.getString(1);

                if (maxId == null) {
                    // First vote in the table
                    newVoteId = prefix + "001";
                } else {
                    // Extract number and increment
                    String numberPart;

                    // Handle different prefix formats
                    if (maxId.startsWith("RVID")) {
                        numberPart = maxId.substring(4); // Remove "RVID" prefix
                    } else if (maxId.startsWith("GVID")) {
                        numberPart = maxId.substring(4); // Remove "GVID" prefix
                    } else if (maxId.startsWith("VID")) {
                        numberPart = maxId.substring(3); // Remove "VID" prefix (backward compatibility)
                    } else {
                        // If no known prefix, assume it's just a number
                        numberPart = maxId;
                    }

                    try {
                        int currentNumber = Integer.parseInt(numberPart);
                        int nextNumber = currentNumber + 1;
                        newVoteId = prefix + String.format("%03d", nextNumber);
                    } catch (NumberFormatException e) {
                        // If parsing fails, start from 1
                        newVoteId = prefix + "001";
                    }
                }
            } else {
                // No rows found, start from 1
                newVoteId = prefix + "001";
            }
        }

        return newVoteId;
    }
}