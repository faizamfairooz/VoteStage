# VoteStage - Reality Show Voting System

## 🎯 Project Overview
A web-based voting system for reality show competitions built with Java Servlets, MySQL, and MVC architecture.

## 🚧 Project Status
**Under Active Development**

## 🏗️ Architecture
- **Frontend**: JSP, HTML, CSS
- **Backend**: Java Servlets
- **Database**: MySQL
- **Patterns**: MVC, DAO, Observer
- **Build Tool**: Maven
- **IDE**: IntelliJ IDEA

## 📁 Project Structure

VoteStage/
├── src/main/java/com/voting/
│ ├── dao/ # Data Access Objects
│ ├── model/ # Entity classes
│ ├── observer/ # Observer pattern
│ ├── service/ # Business logic
│ ├── servlet/ # Web controllers
│ └── util/ # Utilities
├── src/main/resources/
├── src/main/webapp/ # JSP, CSS, JS files
├── VotingDB.sql # Database schema
└── pom.xml # Maven configuration


## 🛠️ Setup Instructions

### Prerequisites
- Java 8+
- Apache Tomcat 9+
- MySQL 5.7+

### Database Setup
1. Create MySQL database: `VotingDB`
2. Run schema: `mysql -u root -p VotingDB < VotingDB.sql`

### Configuration
1. Update database credentials in configuration files
2. Deploy to Tomcat server
3. Access: `http://localhost:8080/VoteStage`

## 📋 Features
- [ ] User authentication
- [ ] Contestant management
- [ ] Real-time voting
- [ ] Results calculation
- [ ] Admin dashboard
- [ ] Vote history

## 🎓 Academic Project
This is a Software Engineering academic project.
