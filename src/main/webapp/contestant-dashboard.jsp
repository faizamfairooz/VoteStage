<%@ page import="java.sql.*" %>
<%@ page import="com.voting.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("user_name");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Contestant Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #8A2BE2;
            --primary-light: #9d45e5;
            --secondary: #FF6B9D;
            --accent: #00D4AA;
            --dark: #1A1A2E;
            --light: #F8F9FF;
            --gray: #6C757D;
            --success: #28a745;
            --warning: #FFC107;
            --danger: #E63946;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #1A1A2E 0%, #16213E 50%, #0F3460 100%);
            color: var(--light);
            min-height: 100vh;
            line-height: 1.6;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 2.8rem;
            font-weight: 700;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .header h2 {
            font-weight: 400;
            font-size: 1.4rem;
            color: var(--light);
            opacity: 0.9;
        }

        .welcome-badge {
            display: inline-block;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            padding: 8px 20px;
            border-radius: 50px;
            margin-top: 15px;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(138, 43, 226, 0.4);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        .panel {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 25px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .panel:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
        }

        .panel h3 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: var(--accent);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .panel h3 i {
            font-size: 1.3rem;
        }

        .contestants-panel {
            grid-column: 1 / -1;
            text-align: center;
            border: 2px solid var(--success);
        }

        .contestants-wrapper {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 30px;
            margin-top: 20px;
        }

        .contestant-card {
            text-align: center;
            width: 120px;
            transition: transform 0.4s ease, filter 0.4s ease;
        }

        .contestant-card a {
            text-decoration: none;
            color: inherit;
        }

        .contestant-card img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid transparent;
            transition: all 0.4s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .contestant-card:hover {
            transform: translateY(-10px);
        }

        .contestant-card:hover img {
            transform: scale(1.15) rotate(5deg);
            border-color: var(--accent);
            box-shadow: 0 10px 25px rgba(0, 212, 170, 0.4);
        }

        .contestant-card:hover p {
            color: var(--accent);
            font-weight: 600;
        }

        .contestant-card p {
            margin-top: 10px;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .chart-container {
            grid-column: 1 / -1;
        }

        .schedule {
            background: linear-gradient(135deg, rgba(0, 212, 170, 0.1) 0%, rgba(138, 43, 226, 0.1) 100%);
            border: 1px solid rgba(0, 212, 170, 0.3);
        }

        .schedule p {
            margin-bottom: 20px;
            font-size: 1.1rem;
        }

        .schedule strong {
            color: var(--accent);
        }

        .btn-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 1rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn.logout {
            background: linear-gradient(90deg, var(--danger), #FF4D6D);
            color: white;
        }

        .btn.logout:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(230, 57, 70, 0.4);
        }

        .btn.judge {
            background: linear-gradient(90deg, var(--warning), #FFD166);
            color: var(--dark);
        }

        .btn.judge:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 193, 7, 0.4);
        }

        .btn.schedule {
            background: linear-gradient(90deg, var(--accent), #2AFCB2);
            color: var(--dark);
        }

        .btn.schedule:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 212, 170, 0.4);
        }

        /* Back Link Box */
        .back-box {
            margin-top: 30px;
            text-align: center;
        }

        .back-box a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: linear-gradient(90deg, var(--primary), var(--primary-light));
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(138, 43, 226, 0.4);
        }

        .back-box a:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(138, 43, 226, 0.5);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .header h1 {
                font-size: 2.2rem;
            }

            .btn-container {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="fas fa-microphone-alt"></i> Vote Stage</h1>
        <h2>Your Performance Hub</h2>
        <div class="welcome-badge">
            Welcome!
        </div>
    </div>

    <div class="dashboard-grid">
        <!-- Contestants Gallery -->
        <div class="panel contestants-panel">
            <h3><i class="fas fa-users"></i> Meet the Contestants</h3>
            <div class="contestants-wrapper">
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=DJ Nova">
                        <img src="img/bg-img/dj_nova.jpg" alt="DJ Nova">
                        <p>DJ Nova</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=MC Blaze">
                        <img src="img/bg-img/mc_blaze.jpg" alt="MC Blaze">
                        <p>MC Blaze</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=Luna Star">
                        <img src="img/bg-img/luna_star.jpg" alt="Luna Star">
                        <p>Luna Star</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=Beat King">
                        <img src="img/bg-img/beat_king.jpg" alt="Beat King">
                        <p>Beat King</p>
                    </a>
                </div>
                <div class="contestant-card">
                    <a href="contestantProfile.jsp?name=Rhythm Queen">
                        <img src="img/bg-img/rhythm_queen.jpg" alt="Rhythm Queen">
                        <p>Rhythm Queen</p>
                    </a>
                </div>
            </div>
        </div>

        <!-- Votes Chart -->
        <div class="panel chart-container">
            <h3><i class="fas fa-chart-bar"></i> Votes Comparison</h3>
            <canvas id="votesChart"></canvas>
        </div>

        <!-- Performance Schedule -->
        <div class="panel schedule">
            <h3><i class="fas fa-clock"></i> Performance Schedule</h3>
            <a href="schedule.jsp" class="btn schedule"><i class="fas fa-calendar-alt"></i> View Full Schedule</a>
        </div>
    </div>

    <!-- Buttons -->
    <div class="btn-container">
        <a href="judge-vote.jsp" class="btn judge"><i class="fas fa-eye"></i> View Judge Votes</a>
        <a href="logout-success.jsp" class="btn logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <!-- Back Link Box -->
    <div class="back-box">
        <a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
    </div>
</div>

<script>
    const ctx = document.getElementById('votesChart').getContext('2d');
    const data = {
        labels: ['DJ Nova', 'MC Blaze', 'Luna Star', 'Beat King', 'Rhythm Queen'],
        datasets: [{
            label: 'Votes Received',
            data: [1247, 980, 870, 650, 430],
            backgroundColor: [
                'rgba(138, 43, 226, 0.8)',
                'rgba(255, 107, 157, 0.8)',
                'rgba(0, 212, 170, 0.8)',
                'rgba(255, 193, 7, 0.8)',
                'rgba(230, 57, 70, 0.8)'
            ],
            borderColor: [
                'rgba(138, 43, 226, 1)',
                'rgba(255, 107, 157, 1)',
                'rgba(0, 212, 170, 1)',
                'rgba(255, 193, 7, 1)',
                'rgba(230, 57, 70, 1)'
            ],
            borderWidth: 2,
            borderRadius: 8,
            borderSkipped: false,
        }]
    };
    const config = {
        type: 'bar',
        data: data,
        options: {
            indexAxis: 'y',
            scales: {
                x: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: 'rgba(255, 255, 255, 0.7)'
                    }
                },
                y: {
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: 'rgba(255, 255, 255, 0.7)'
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    };
    const votesChart = new Chart(ctx, config);
</script>
</body>
</html>
