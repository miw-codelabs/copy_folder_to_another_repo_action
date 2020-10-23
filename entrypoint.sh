#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE_REPO" ]
then
  echo "Source repo must be defined"
  return -1
fi

if [ -z "$INPUT_SOURCE_FOLDER" ]
then
  echo "Source folder must be defined"
  return -1
fi

if [ -z "$INPUT_DESTINATION_REPO" ]
then
  echo "Destination repo folder must be defined"
  return -1
fi

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_DESTINATION_BRANCH=main
fi

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_SOURCE_BRANCH=main
fi

if [ -z "$INPUT_COMMIT_MSG" ]
then
  INPUT_COMMIT_MSG="Update $INPUT_DESTINATION_FOLDER."
fi

CLONE_DIR_SRC=$(mktemp -d)
CLONE_DIR_DST=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
git clone --single-branch --branch $INPUT_SOURCE_BRANCH "https://$INPUT_AUTH_TOKEN:x-oauth-basic@github.com/$INPUT_SOURCE_REPO.git" "$CLONE_DIR_SRC"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://$INPUT_AUTH_TOKEN:x-oauth-basic@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR_DST"

echo "Removing old folder: ${CLONE_DIR_DST}/${INPUT_DESTINATION_FOLDER}/"
rm -rf $CLONE_DIR_DST/$INPUT_DESTINATION_FOLDER/
echo "Copying: ${CLONE_DIR_SRC}/${INPUT_SOURCE_FOLDER}/ -> ${CLONE_DIR_DST}/${INPUT_DESTINATION_FOLDER}/"
cp -a $CLONE_DIR_SRC/$INPUT_SOURCE_FOLDER/. $CLONE_DIR_DST/$INPUT_DESTINATION_FOLDER/
echo "switching to destination repo directory: ${CLONE_DIR_DST}"
cd "$CLONE_DIR_DST"
ls -a

echo "Adding git commit"
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MSG"
  echo "Pushing git commit"
  git push origin $INPUT_DESTINATION_BRANCH
else
  echo "No changes detected"
fi
