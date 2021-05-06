# CrystalBall

CrystalBall is a web application to the predict academic performance of freshmen at university. The main goal 
of predicting academic performance is to help mentors identify freshmen students that need mentoring the most.
This project was developed in 2014 as part of my BSc thesis at the University of Navarra, Spain.

The backend was developed in Java using Java servlets hosted in Apache Tomcat. The database used was Microsoft Access 2007 (lame, I know). The statistical analyses (developed by Álvaro Fuertes Vallés) in R are passed to the TCP/IP server Rserve installed through a package in R.

The front-end was developed using the popular Bootstrap framework. The requests to the backend are handled using the Javascript library JQuery and Ajax for dynamic refresh of contents. The Javascript framework AlertifyJS was used to send notifications to the user.

## Prerequisites

Required R packages:
- Rserve
- Nozzle.R1
- gdata
- impute (BioConductor)
- glmnet
- reshape2
- Run gdata::installXLSXsupport() in R terminal

The web server uses Java Servlets running on Apache Tomcat v9.0. The OpenJDK 11.0.11 Java Development Kit has been used for Java code development.

Required JAR files are handled by the Maven file pom.xml.

## License

TBD
