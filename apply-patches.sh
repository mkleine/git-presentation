if [ -e ./current_ref.txt ]; then
  HEAD_REF=`cat ./current_ref.txt`
  git reset --hard $HEAD_REF
else 
  HEAD_REF=`git rev-parse HEAD`
fi
echo "head revision is ${HEAD_REF}"
SOURCE_REF=$1
if [ -z ${SOURCE_REF+x} ] ; then
  SOURCE_REF=presentation
fi

for i in `git log ${SOURCE_REF} --cherry-pick --oneline --pretty=format:'%h' ${HEAD_REF}...${SOURCE_REF}`; do 
  NEXT_REF=$i
  echo "upcoming revision is ${NEXT_REF}" 
done
if [ -z ${NEXT_REF+x} ]; then
  echo "no more revisions to pick"
else 
  git cherry-pick ${NEXT_REF} && echo "cherry-pick successful"
  git reset --soft HEAD^
  echo $NEXT_REF > current_ref.txt
fi
