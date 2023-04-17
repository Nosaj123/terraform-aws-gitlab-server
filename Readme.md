# The below commands are sepcifically for Ubuntu machines
sudo apt-get update /n
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
 sudo apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
 sudo EXTERNAL_URL="https://gitlab.example.com" apt-get install gitlab-ee

sudo cat /etc/gitlab/initial_root_password/etc/gitlab/initial_root_password

# The below steps are optional (restoring from old server to new)
# Old/Current Server
gitlab-rake gitlab:backup:create
scp /var/opt/gitlab/backups/1681578168_2023_04_15_15.10.2-ee_gitlab_backup.tar root@NEW_SERVER_IP:/root/
cd /etc/gitlab/
scp gitlab-secrets.json gitlab.rb root@NEW_SERVER_IP:/root/

# New Server; 
sudo mv 1681578168_2023_04_15_15.10.2-ee_gitlab_backup.tar /var/opt/gitlab/backups/
cd  /var/opt/gitlab/backups/
chown git:git 1681572484_2023_04_15_15.10.3-ee_gitlab_backup.tar
sudo mv gitlab-secrets.json gitlab.rb /etc/gitlab/
sudo gitlab-ctl stop unicorn
sudo gitlab-ctl stop sidekiq
sudo gitlab-ctl stop puma
sudo gitlab-ctl status
sudo gitlab-backup restore BACKUP=1681578168_2023_04_15_15.10.2-ee
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
sudo gitlab-rake gitlab:check SANITIZE=true

