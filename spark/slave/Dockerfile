FROM vpemfh7/spark-base:latest

ENV SPARK_WORKER_WEBUI_PORT=8081
ENV SPARK_WORKER_LOG=/spark/logs

EXPOSE 8081 4040

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]