/*package com.voting.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class IDGenerator {

    public static synchronized String generateUserId(String role) throws SQLException {
        String prefix = getPrefixForRole(role);

        // Get the current maximum ID from the database
        String getMaxIdSql = "SELECT MAX(person_id) FROM Persons WHERE person_id LIKE ?";
        String newUserId = "";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(getMaxIdSql)) {

            ps.setString(1, prefix + "%");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String maxId = rs.getString(1);

                    if (maxId == null) {
                        // First user of this type
                        newUserId = prefix + "001";
                    } else {
                        // Extract number and increment
                        String numberPart = maxId.replace(prefix, "");
                        int currentNumber = Integer.parseInt(numberPart);
                        int nextNumber = currentNumber + 1;
                        newUserId = prefix + String.format("%03d", nextNumber);
                    }
                }
            }
        }

        return newUserId;
    }

    private static String getPrefixForRole(String role) {
        return switch (role) {
            case "Admin" -> "ADM";
            case "Voter" -> "VOT";
            case "Contestant" -> "CON";
            case "Judge" -> "JUD";
            case "ITSupporter" -> "ITS";
            default -> "USR";
        };
    }
}*/