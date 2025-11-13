<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.voting.model.Video" %>
<%
    List<Video> videos = (List<Video>) request.getAttribute("videos");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - Video Management</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f8f8f8; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; background: #fff; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background: #333; color: #fff; }
        video { width: 250px; height: 150px; border-radius: 6px; }
        form { margin: 0; }
        .actions button { margin: 3px; padding: 6px 10px; }
        .upload-form { background: #fff; padding: 20px; border: 1px solid #ccc; border-radius: 6px; margin-bottom: 20px; }
    </style>
</head>
<body>
<h1>Admin - Manage Videos</h1>

<!-- 🔹 Upload New Video -->
<div class="upload-form">
    <h2>Upload New Video</h2>
    <form action="video" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="upload">
        <label>Title:</label> <input type="text" name="title" required><br><br>
        <label>Description:</label> <input type="text" name="description"><br><br>
        <label>Original Singer:</label> <input type="text" name="singer"><br><br>
        <label>Duration:</label> <input type="text" name="duration"><br><br>
        <label>Contestant ID:</label> <input type="number" name="contestantId" required><br><br>
        <label>Video File:</label> <input type="file" name="videoFile" accept="video/*" required><br><br>
        <button type="submit">Upload Video</button>
    </form>
</div>

<!-- 🔹 List Videos -->
<h2>Uploaded Videos</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Preview</th>
        <th>Title</th>
        <th>Description</th>
        <th>Singer</th>
        <th>Duration</th>
        <th>Contestant</th>
        <th>Admin</th>
        <th>Uploaded At</th>
        <th>Actions</th>
    </tr>
    <%
        if (videos != null && !videos.isEmpty()) {
            for (Video v : videos) {
    %>
    <tr>
        <td><%= v.getVideoId() %></td>
        <td>
            <video controls>
                <source src="<%= request.getContextPath() + "/videos/" + new java.io.File(v.getFilePath()).getName() %>" type="video/mp4">
                Your browser does not support the video tag.
            </video>
        </td>
        <td><%= v.getTitle() %></td>
        <td><%= v.getDescription() %></td>
        <td><%= v.getSinger() %></td>
        <td><%= v.getDuration() %></td>
        <td><%= v.getContestantId() %></td>
        <td><%= v.getAdminId() %></td>
        <td><%= v.getUploadedAt() %></td>
        <td class="actions">
            <!-- Edit Form -->
            <form action="video" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="videoId" value="<%= v.getVideoId() %>">
                <input type="text" name="title" value="<%= v.getTitle() %>">
                <input type="text" name="description" value="<%= v.getDescription() %>">
                <button type="submit">Update</button>
            </form>
            <!-- Delete Form -->
            <form action="video" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="videoId" value="<%= v.getVideoId() %>">
                <button type="submit" style="background:red;color:white;">Delete</button>
            </form>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="10">No videos uploaded yet.</td></tr>
    <% } %>
</table>
</body>
</html>
