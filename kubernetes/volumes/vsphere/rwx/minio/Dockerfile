FROM alpine:latest

#ENV MNT_POINT /var/s3
#ENV IAM_ROLE=none
#ENV S3_REGION ''

#VOLUME /var/s3


#ARG S3FS_VERSION=v1.84

RUN apk --update add bash fuse libcurl libxml2 libstdc++ libgcc alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git; \
    curl https://github.com/kahing/goofys/releases/download/v0.24.0/goofys --output ./goofys; \
    chmod 755 ./goofys;

#RUN sed -i s/"#user_allow_other"/"user_allow_other"/g /etc/fuse.conf

#COPY docker-entrypoint.sh /
#CMD /docker-entrypoint.sh
