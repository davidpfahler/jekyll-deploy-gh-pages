#!/bin/sh

remote_repo="git@github.com:${GITHUB_REPOSITORY}.git"
remote_branch=${BRANCH:-gh-pages}

# check if deploy key is set
if [ -z ${var+x} ]; then echo "❌ GIT_DEPLOY_KEY not set" && exit 1; else echo "✅deploy key is set"; fi

mkdir /root/.ssh
echo 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' > /root/.ssh/known_hosts
echo "${GIT_DEPLOY_KEY}" > /root/.ssh/id_rsa
chmod 400 /root/.ssh/id_rsa

bundle install > /dev/null 2>&1
bundle list | grep "jekyll ("
echo '👍 BUNDLE INSTALLED—BUILDING THE SITE'
bundle exec jekyll build
echo '👍 THE SITE IS BUILT — PUSHING IT BACK TO GITHUB-PAGES'
cd build

git init
git remote add origin "${remote_repo}"
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
echo -n 'Files to Commit:' && ls -l | wc -l
git commit -m "Automated deployment to GitHub Pages"
git push -f origin "master:${remote_branch}"
rm -fr .git
cd ../

echo '👍 GREAT SUCCESS!'
