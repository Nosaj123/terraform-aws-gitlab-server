# Installation Process
# The below commands are sepcifically for Ubuntu machines

# The below script requires manual input after installation, so the .tpl might fail.
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
 sudo apt-get install -y postfix
 
 # You can download other packages here - https://packages.gitlab.com/gitlab/
 curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
 sudo EXTERNAL_URL="https://gitlab.example.com" apt-get install gitlab-ee

# To review the root p/w, run the below command
sudo cat /etc/gitlab/initial_root_password/etc/gitlab/initial_root_password

# ..
# Optional

# Restore from another gitlab account:
# Old/Current Server; create a backup: 
gitlab-rake gitlab:backup:create

# Ensure that you setup a connection between the old and new server (using .pem or create a key)
scp /var/opt/gitlab/backups/1681578168_2023_04_15_15.10.2-ee_gitlab_backup.tar root@NEW_SERVER_IP:/root/
cd /etc/gitlab/
scp gitlab-secrets.json gitlab.rb root@NEW_SERVER_IP:/root/

# ...
# New Server; 
sudo mv 1681578168_2023_04_15_15.10.2-ee_gitlab_backup.tar /var/opt/gitlab/backups/
cd  /var/opt/gitlab/backups/

# modify ownership & permissions if needed
chown git:git 1681572484_2023_04_15_15.10.3-ee_gitlab_backup.tar

# move config file and secrets.json
sudo mv gitlab-secrets.json gitlab.rb /etc/gitlab/

# ensure you review and modify the gitlab.rb file to change external IP and other vairables as needed

# Stop GitLab Running Services
sudo gitlab-ctl stop unicorn
sudo gitlab-ctl stop sidekiq
sudo gitlab-ctl stop puma

# Verify Processes are stopped
sudo gitlab-ctl status

# Restore the backup
# Remove the '_gitlab_backup.tar' of the backup filename
sudo gitlab-backup restore BACKUP=1681578168_2023_04_15_15.10.2-ee

# Reconfigure & Restart Gitlab
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
sudo gitlab-rake gitlab:check SANITIZE=true

