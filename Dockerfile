# --- Giai đoạn 1: Build bằng Maven ---
FROM maven:3-jdk-11 AS builder
WORKDIR /app

# 1. Copy file pom.xml vào trước
COPY pom.xml .

# 2. ĐÂY LÀ BƯỚC QUAN TRỌNG NHẤT:
# Thay vì COPY src src (như cũ), ta copy thẳng vào cấu trúc Maven
# Lưu ý: Kiểm tra thư mục chứa code Java của bạn tên là 'src'
COPY src ./src/main/java

# 3. Copy thư mục giao diện web vào đúng chỗ Maven cần
# Lưu ý: Trong NetBeans cũ, thư mục này thường tên là 'web' hoặc 'WebContent'
# Hãy mở thư mục máy tính xem nó tên là gì, rồi sửa dòng dưới cho đúng (ví dụ COPY web...)
COPY web ./src/main/webapp

# 4. Chạy lệnh build tạo file WAR
RUN mvn clean package -DskipTests

# --- Giai đoạn 2: Chạy bằng Tomcat ---
FROM tomcat:9.0-jre11-temurin
# Xóa ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy file WAR vừa build được vào thư mục ROOT
COPY --from=builder /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]