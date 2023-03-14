# 采用java官方镜像做为构建镜像
FROM maven:3.6.0-jdk-8-slim AS build

# 设置应用工作目录
WORKDIR /app

# 将所有文件拷贝到容器中
COPY . .

# 编译项目
RUN mvn -B -e -U -s settings.xml clean package

# 采用java或者alpine/debian官方镜像做为运行时镜像
FROM openjdk:8-bullseye

# RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
#  apt update && apt install -y curl

# 设置应用工作目录
WORKDIR /app

# 将构建产物拷贝到运行时的工作目录中
COPY --from=build /app/**/*.jar ./

# 暴露端口
# 此处端口必须与构建小程序服务端时填写的服务端口和探活端口一致，不然会部署失败
EXPOSE 80

# 设置时区
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai > /etc/timezone

CMD ["java", "-jar", "antcloud-0.0.1-SNAPSHOT.jar"]
