@echo off

:: Starting
echo "Starting migration" > D:\tfs2git.log

:: Print current working directory
echo %~dp0 >> D:\tfs2git.log

:: Switch into Migration directory
cd D:\Migration

:: Print current working directory
echo "In the " %~dp0 " directory" >> D:\tfs2git.log

:: Starting clone
git tfs clone https://nztfs.service.waynecorp.com/tfs/Development "$/batwing" D:\Migration\batwing >> D:\tfs2git.log

cd D:\Migration\batwing
echo %~dp0 >> D:\tfs2git.log

:: Adding Git remote
git remote add GitHub https://lfox:$token@github.service.waynecorp.com/scm/cla/batwing.git

git remote -v >> D:\tfs2git.log

git push -u GitHub master >> D:\tfs2git.log
