set -e

echo "Committing changes to Git..."
git add .
read -p "Enter commit message: " COMMIT_MESSAGE
git commit -m "$COMMIT_MESSAGE"
read -p "Do you want to push the changes to the remote repository? (y/n) " PUSH_CHANGES
if [[ "$PUSH_CHANGES" == "y" ]]; then
    git push
    echo "Changes pushed to remote repository."
else
    echo "Changes not pushed to remote repository."
fi