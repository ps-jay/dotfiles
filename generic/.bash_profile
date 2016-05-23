# Hints: http://superuser.com/questions/789448/choosing-between-bashrc-profile-bash-profile-etc

# Source .profile
if [ -f ~/.profile ]; then
    source ~/.profile
fi

# Source .bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
