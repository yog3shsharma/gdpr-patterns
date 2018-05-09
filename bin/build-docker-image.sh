echo "*****************************"
echo "*** Building docker image ***"
echo "*****************************"

cd bin/Docker
ls

docker build -t diniscruz/gdpr-patterns . || exit 1
#docker build -t diniscruz/gdpr-patterns .

#docker run --rm -it -p 3001:3000 diniscruz/gdpr-patterns bash
#docker run --rm -it -p 3000:3000 diniscruz/gdpr-patterns

docker push diniscruz/gdpr-patterns
