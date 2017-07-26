#!/bin/bash
rm -rf .git versions/
git init .
git add .
git commit -am 'Initial commit'
git remote add origin git@github.com:erichelgeson/grails-versions.git
git push origin master -f

export SDKMAN_DIR="$HOME/.sdkman" && source "$HOME/.sdkman/bin/sdkman-init.sh"

function diffVersion() {
    sdk use grails $1
    grails create-app versions
    cd versions
    ./gradlew dependencyManagement > dependencyManagement.txt
    cd ..
    git add versions
    git commit -a -m $1
    git tag $1
    rm -rf versions
}

# Initial version to diff from
diffVersion 3.0.0

# 3.0.x
for i in $(seq 1 17); do
    diffVersion 3.0.$i
done

# 3.1.x
for i in $(seq 0 15); do
   diffVersion 3.1.$i
done

# 3.2.x
for i in $(seq 0 11); do
   diffVersion 3.2.$i
done

# 3.3.0.Milestone Releases
diffVersion 3.3.0.M1
diffVersion 3.3.0.M2
diffVersion 3.3.0.RC1

# 3.3.x
for i in $(seq 0 0); do
  diffVersion 3.3.$i
done

git push origin master -f
git push origin --tags -f
