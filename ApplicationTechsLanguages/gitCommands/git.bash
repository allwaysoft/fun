/*
Issue with utf-16 files and diffs in gitLab
https://gitlab.com/gitlab-org/gitlab-foss/issues/24916
*/
# Get the latest changes
git pull# Create a new branch
git checkout -b feature/JIRA-01# Stage and commit your changes
git commit -a -m "My commit message"#Pull master to your branch before pushing your branch to remote. This avoids merge conflicts with master later on, if there are any
git pull origin master# First push of your changes to GitLab
git push -u origin feature/JIRA-01# Subsequent pushes on the same branch
git push
​

#git reset local branch with remote master
git reset --hard origin/masterand hotfixing:
​-------------------------------------------------------------------------------------------------------------------------------------------------------------Multi branch deployments, if there are issues, follow the below repo and see how the repo with issues is different from below.
https://git.acadian-asset.com/performance/bisam/warehouse-loader/database-mssql/blob/master/deploy.ps1git checkout --detach Feature/BISAM_18.2_Upgrade
git merge-base master HEAD  --Current version"git show-branch --merge-base"        --Slava's version but we could look for improveementgit log --pretty=oneline master...HEAD          --Didn't work, this showed the other commits which other branches had and if those branches were merged to our branch
git merge-base master HEAD                      --This works but there are issues when a master was merged into branch
git diff --name-only master                     --This worked but gives a list of files but we need the commit point in master, to get all the files modified as part of a branch (Basically the files which show up in a merge request)https://git.acadian-asset.com/performance/bisam/warehouse-loader/database-mssql/blob/Feature/BISAM_18.2_Upgrade/deploy.ps1    --Below handled master merge into branch (As of 10/9/2019)
https://git.acadian-asset.com/performance/bisam/attribution-service/database-mssql/blob/Feature/BISAM_18.2_Upgrade/deploy.ps1 --Below has issues if master merge into branch (As of 10/9/2019)-------------------------------------------------------------------------------------------------------------------------------------------------------------SQLPS powershell module issues
https://sqlpadawan.com/2018/08/01/how-to-install-sql-server-sqlps-powershell-module/-----------------------------------------------------------------------------------------------------------------------------------------------------------
HOT FIX DEPLOYMENT (Cherry Pick/HotFix:)Checkout previous tag into new branch hotfix/jira-story
    git checkout tags/v1.3.8 -b hotfix/JIRA-123
Cherry-pick commits


# *for individual commits use*
    git cherry-pick b2a1b602

# for squashed merges
    git cherry-pick -m 1 b2a1b602
run a dry run deployment (verify expected changes)
    PS -file deploy.ps1 -environment PROD -print
create a new tag
    git tag -a v1.3.9 -m "production deployment for JIRA-123"      --Note that this tag is created on the branch
push branch to remote repository
    git push origin hotfix/JIRA-123
push new tag to remote repository
    git push origin v1.3.9       -- Do not squash commits on the hotfix branch when merging to master because that is where the tag information shows up. Not on master.
run the pipeline in production   --Note that this has to be run on the tag created on the hotfix branch. Check tag v1.3.0 on https://git.acadian-asset.com/operations/database-mssql/-/network/master repo to see how a hotfix branch is deployed in production.
delete hotfix branch


Generate a personal access token first.
Settings -> Developer Settings - > Personal access tokens - > Generate new token

Git clone link-of-GitHub

Status
Add . —Adds everything changed in current directory to local
Commit -m “message” —Commits at local
Pull —Pulls all the changes on the git to local (This shows if there are any conflicts between committed and pulled, conflicts, if arias, should be resolved manually. Once done repeat 1,2,3, it should be clean this time)
Push origin master (Just to make sure it’s all clean, push from local”master” to remote”origin”)
Pull origin master (Vice versa of 4)

git stash drop stash@{1}    —deletes a stash with given name.

#Merge master into branch
#(on branch development)$ git merge master (Some times merge doesn’t work so need to pull master into branch before issuing merge)
#(resolve any merge conflicts if there are any)
git checkout master
git merge development (there wont be any conflicts now)

#Add all local changes not added/committed to a different branch by creating the branch
#1st stash changes
git add .
git stash save “Some name and Jira ticket“
#Then add stash to branch
git checkout -b new_branch_name
git stash pop stash@{n}
git commit -m “commit message”   —> At this point all the changes are safe on the local branch, switch back to master and work on something else and add them those changes to a diff branch with out including the chnages of this branch.

#Git to get everything from origin/master OVERWRITING local changes
git fetch --all && git reset --hard origin/master

#Git to remove any untracked local files
git clean -n -d
git clean -f -d 

#Go to a different remote branch than master
git checkout <branch name>

#Delete branches
#Local
git branch -d <branchName>
#Remote
git push origin --delete <branchName>

#Pushing a local branch
git push -u origin feature_branch_name

#Go to previous commit
#———————————
git reset <commit id which needs to be rolled back, from git log>