# Base Project

This is François Beausoleil's base project template. I prefer to work within a virtualized environment, and I use [Vagrant](https://vagrantup.com/) to manage those environments.

My preferred tools are:

* Shell: zsh
* Editor: vim
* Language: usually [Ruby](https://ruby-lang.org/)
* Database: [PostgreSQL](https://www.postgresql.org/)
* Configuration management: [Puppet](https://puppet.com/)

# Usage

```sh
git clone https://github.com/francois/newproject ${PROJECT_NAME}
vagrant up
vagrant ssh
byobu-enable
exit
vagrant ssh -- -A
# you will now be in a byobu session
cd /vagrant
git remote rm origin
git remote add origin ${NEW_PROJECT_URL}
vim README.markdown LICENSE
git add --all
git config --global user.name "my full name"
git config --global user.email "me@domain.org"
git commit --message "Booting new project"
# start coding away!
```

# LICENSE

This Vagrantfile and associated files are released in the public domain.
Projects made using this starter template shall be licensed at their sole owner's discretion.
