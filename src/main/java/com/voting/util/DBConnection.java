package com.voting.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Adjust to your setup
    private static final String URL =
            "jdbc:sqlserver://localhost:1433;databaseName=VotingDB;encrypt=false;trustServerCertificate=true;integratedSecurity=false";
    private static final String USER = ConnectionData.USERNAME;
    private static final String PASS = ConnectionData.PASSWORD;

    // Simple DriverManager-based connection (fine for tests)
    public static Connection getConnection() throws SQLException {
        SQLException lastException = null;
        
        // Try SQL Server Authentication first
        try {
            System.out.println("🔗 Attempting SQL Server Authentication...");
            System.out.println("📍 URL: " + URL);
            System.out.println("👤 User: " + USER);
            
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ SQL Server Authentication successful!");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ SQL Server Authentication failed!");
            System.err.println("Error: " + e.getMessage());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            lastException = e;
        }
        
        // Try Windows Authentication as fallback
        try {
            System.out.println("🔗 Attempting Windows Authentication as fallback...");
            String windowsAuthURL = "jdbc:sqlserver://localhost:1433;databaseName=VoteStage2;integratedSecurity=true;encrypt=false;trustServerCertificate=true";
            Connection conn = DriverManager.getConnection(windowsAuthURL);
            System.out.println("✅ Windows Authentication successful!");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Windows Authentication also failed!");
            System.err.println("Error: " + e.getMessage());
            lastException = e;
        }
        
        // Try localhost with different port
        try {
            System.out.println("🔗 Attempting connection on port 1434...");
            String altURL = "jdbc:sqlserver://localhost:1434;databaseName=VoteStage2;encrypt=false;trustServerCertificate=true;integratedSecurity=false";
            Connection conn = DriverManager.getConnection(altURL, USER, PASS);
            System.out.println("✅ Connection on port 1434 successful!");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Port 1434 connection failed!");
            System.err.println("Error: " + e.getMessage());
            lastException = e;
        }
        
        // If all attempts fail, throw the original exception
        System.err.println("❌ All connection attempts failed!");
        throw new SQLException("Unable to connect to database. Please check SQL Server configuration.", lastException);
    }

    // Alternative connection method for testing
    public static Connection getAlternativeConnection() throws SQLException {
        try {
            // Try with Windows Authentication
            String windowsAuthURL = "jdbc:sqlserver://localhost:1433;databaseName=VoteStage2;integratedSecurity=true;encrypt=false;trustServerCertificate=true";
            System.out.println("🔗 Trying Windows Authentication...");
            Connection conn = DriverManager.getConnection(windowsAuthURL);
            System.out.println("✅ Windows Authentication successful!");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Windows Authentication failed: " + e.getMessage());
            throw e;
        }
    }

    // Test connection method
    public static boolean testConnection() {
        try {
            Connection conn = getConnection();
            conn.close();
            return true;
        } catch (SQLException e) {
            System.err.println("Connection test failed: " + e.getMessage());
            return false;
        }
    }

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("✅ SQL Server Driver LOADED!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Driver MISSING!");
            e.printStackTrace();
        }
    }
}