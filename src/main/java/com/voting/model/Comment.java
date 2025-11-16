package com.voting.model;

import java.sql.Timestamp;

public class Comment {
    private String commentId;
    private String judgeId;
    private String judgeName;
    private String videoId;
    private String contestantId;
    private String commentText;
    private Timestamp commentDate;
    private int likes;

    public Comment() {}

    // Getters and setters
    public String getCommentId() { return commentId; }
    public void setCommentId(String commentId) { this.commentId = commentId; }

    public String getJudgeId() { return judgeId; }
    public void setJudgeId(String judgeId) { this.judgeId = judgeId; }

    public String getJudgeName() { return judgeName; }
    public void setJudgeName(String judgeName) { this.judgeName = judgeName; }

    public String getVideoId() { return videoId; }
    public void setVideoId(String videoId) { this.videoId = videoId; }

    public String getContestantId() { return contestantId; }
    public void setContestantId(String contestantId) { this.contestantId = contestantId; }

    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }

    public Timestamp getCommentDate() { return commentDate; }
    public void setCommentDate(Timestamp commentDate) { this.commentDate = commentDate; }

    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }
}