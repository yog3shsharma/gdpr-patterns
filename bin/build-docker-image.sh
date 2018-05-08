echo "*****************************"
echo "*** Building docker image ***"
echo "*****************************"

cd bin/Docker
ls

#docker build -t owasp/gdpr-patterns . || exit 1
docker build -t owasp/gdpr-patterns .

docker run --rm -it owasp/gdpr-patterns bash