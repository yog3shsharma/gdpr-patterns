echo ""
echo "**********************************"
echo "***    Git Push (mini util)    ***"
echo "**********************************"
echo "*** only use for small changes ***"
echo ""

git add .
git commit -m 'commit for github push'
git pull origin master
git push origin master