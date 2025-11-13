package com.voting.servlet;

import com.voting.service.JudgeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/vote")
public class JudgeVoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String judgeId = (String) session.getAttribute("user_id");
        String judgeName = (String) session.getAttribute("user_name");
        String voteType = request.getParameter("voteType");
        String contestantId = request.getParameter("contestantId");
        String contestantName = request.getParameter("contestantName");
        String videoId = request.getParameter("videoId");

        System.out.println("=== VOTE PROCESSING ===");
        System.out.println("Vote Type: " + voteType);
        System.out.println("Judge: " + judgeId);
        System.out.println("Contestant: " + contestantId);

        try {
            if ("regular".equals(voteType)) {
                handleRegularVote(session, judgeId, contestantId, contestantName, judgeName, videoId);
            } else if ("golden".equals(voteType)) {
                handleGiveGoldenVote(session, judgeId, contestantId, contestantName, judgeName, videoId);
            } else if ("revoke".equals(voteType)) {
                handleRevokeGoldenVote(session, judgeId, contestantId, contestantName);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "System error: " + e.getMessage());
        }

        // Always redirect back to refresh the page with updated button state
        String redirectUrl = String.format("judge-vote.jsp?contestantId=%s&contestantName=%s&videoId=%s",
                contestantId, java.net.URLEncoder.encode(contestantName, "UTF-8"), videoId);
        response.sendRedirect(redirectUrl);
    }

    private void handleRegularVote(HttpSession session, String judgeId, String contestantId,
                                   String contestantName, String judgeName, String videoId) throws SQLException {
        boolean success = JudgeService.recordRegularVote(
                judgeId, contestantId, contestantName, "Performance", judgeName, videoId);

        if (success) {
            session.setAttribute("successMessage", "Regular vote (10 points) submitted successfully for " + contestantName + "!");
        } else {
            session.setAttribute("errorMessage", "You have already voted for " + contestantName + " today!");
        }
    }

    private void handleGiveGoldenVote(HttpSession session, String judgeId, String contestantId,
                                      String contestantName, String judgeName, String videoId) throws SQLException {
        // REMOVED THE CHECK - JUST GIVE THE VOTE
        boolean success = JudgeService.recordGoldenVote(
                judgeId, contestantId, contestantName, "Performance", judgeName, videoId);

        if (success) {
            session.setAttribute("successMessage", "Golden vote successfully given to " + contestantName + "!");
        } else {
            session.setAttribute("errorMessage", "Error giving golden vote to " + contestantName + "!");
        }
    }

    private void handleRevokeGoldenVote(HttpSession session, String judgeId, String contestantId,
                                        String contestantName) throws SQLException {
        System.out.println("Attempting to revoke golden vote for judge: " + judgeId);

        // Get current golden vote info first
        String currentGoldenContestantId = null;
        String currentGoldenContestantName = null;

        try {
            ResultSet goldenVote = JudgeService.getJudgeGoldenVote(judgeId);
            if (goldenVote.next()) {
                currentGoldenContestantId = goldenVote.getString("contestant_id");
                currentGoldenContestantName = goldenVote.getString("contestant_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        boolean revoked = JudgeService.revokeGoldenVote(judgeId, currentGoldenContestantId);
        System.out.println("Revocation result: " + revoked);

        if (revoked) {
            String message = "Golden vote successfully revoked";
            if (currentGoldenContestantName != null && !currentGoldenContestantName.equals(contestantName)) {
                message += " from " + currentGoldenContestantName;
            }
            message += "!";

            session.setAttribute("successMessage", message);
        } else {
            session.setAttribute("errorMessage", "Failed to revoke golden vote!");
        }
    }
}