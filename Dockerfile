# Sử dụng Java JDK và Maven làm builder
FROM maven:3-jdk-11 AS builder
WORKDIR /app
COPY pom.xml .
COPY src src
RUN mvn clean install -DskipTests

# Giai đoạn Runtime (chỉ chứa ứng dụng và máy chủ)
FROM tomcat:9.0-jre11-temurin
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]