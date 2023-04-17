# The below commands are sepcifically for Ubuntu machines
sudo apt-get update <br>
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl <br>
 sudo apt-get install -y postfix <br>
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash <br>
 sudo EXTERNAL_URL="https://gitlab.example.com" apt-get install gitlab-ee <br>

sudo cat /etc/gitlab/initial_root_password/etc/gitlab/initial_root_password <br>

# The below steps are optional (restoring from old server to new)
# Old/Current Server
gitlab-rake gitlab:backup:create <br>
scp /var/opt/gitlab/backups/1681578168_2023_04_15_15.10.2-ee_gitlab_backup.tar root@NEW_SERVER_IP:/root/ <br>
cd /etc/gitlab/ <br>
scp gitlab-secrets.json gitlab.rb root@NEW_SERVER_IP:/root/ <br>

# New Server; 
sudo mv 1681578168_2023_04_15_15.10.2-ee_gitlab_backup.tar /var/opt/gitlab/backups/ <br>
cd  /var/opt/gitlab/backups/ <br> 
chown git:git 1681572484_2023_04_15_15.10.3-ee_gitlab_backup.tar <br>
sudo mv gitlab-secrets.json gitlab.rb /etc/gitlab/ <br>
sudo gitlab-ctl stop unicorn <br>
sudo gitlab-ctl stop sidekiq <br>
sudo gitlab-ctl stop puma <br>
sudo gitlab-ctl status <br>
sudo gitlab-backup restore BACKUP=1681578168_2023_04_15_15.10.2-ee <br>
sudo gitlab-ctl reconfigure <br>
sudo gitlab-ctl restart <br>
sudo gitlab-rake gitlab:check SANITIZE=true <br>

