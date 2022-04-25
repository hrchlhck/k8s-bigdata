FROM vpemfh7/spark-base:latest

# Spark
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_WEBUI_PORT=8080
ENV SPARK_MASTER_LOG=/spark/logs
ENV SPARK_HOME=/spark

EXPOSE 8080 7077

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]