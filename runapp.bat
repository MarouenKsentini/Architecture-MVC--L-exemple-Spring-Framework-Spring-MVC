@echo off
set "JAVA_HOME=C:\Program Files\Java\jdk-17.0.18"
cd /D "C:\Users\marou\Downloads\productapp"
"C:\apache-maven\apache-maven-3.9.14\bin\mvn.cmd" spring-boot:run -f "C:\Users\marou\Downloads\productapp\pom.xml" >> "C:\Users\marou\Downloads\productapp\mvn-run.log" 2>&1
echo MAVEN_PID=%PID% >> "C:\Users\marou\Downloads\productapp\mvn-run.log"
