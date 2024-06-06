# Setup Nginx and Mysql with Vagrant

The task we hope to achieve with this article has the following goals.
- Setup a web server with nginx.
- Setup a database server with mysql.
- Give the servers above access to a network to communicate with each other.

### Step One: Create a Vagrantfile and Provisioning Scripts.

- Get into your project directory and create a new Vagrantfile, with the following content.

``` ruby

# Initiate a Vagrant configuration block using the configure method
# "2" indicates the configuration version being used.
Vagrant.configure("2") do |config|

  # Define the configuration for the web server VM
  config.vm.define "web" do |web|
    # Specify the base box to use for the web server VM, here using Ubuntu 20.04 (Focal Fossa)
    web.vm.box = "ubuntu/focal64"

    # Set the hostname for the web server VM
    web.vm.hostname = "web-server"

    # Provision the web server VM using a shell script. The script is located at "web_script.sh"
    web.vm.provision :shell, path: "web_script.sh"

    # Set up a forwarded port. Map port 80 on the guest (web server VM) to port 4567 on the host machine
    # This allows access to the web server running on the VM from the host machine via port 4567
    web.vm.network :forwarded_port, guest: 80, host: 4567

    # Configure a private network with a static IP address for the web server VM
    # This allows communication between VMs on this private network without exposing them to the external network
    web.vm.network "private_network", ip: "192.168.50.4"

    # Customize the resources allocated to the web server VM using the VirtualBox provider
    web.vm.provider "virtualbox" do |vb|
      # Allocate 1024 MB (1 GB) of memory to the web server VM
      vb.memory = "1024"
    end
  end

  # Define the configuration for the database server VM
  config.vm.define "db" do |db|
    # Specify the base box to use for the database server VM, here using Ubuntu 20.04 (Focal Fossa)
    db.vm.box = "ubuntu/focal64"

    # Set the hostname for the database server VM
    db.vm.hostname = "db-server"

    # Provision the database server VM using a shell script. The script is located at "db_script.sh"
    db.vm.provision :shell, path: "db_script.sh"

    # Configure a private network with a static IP address for the database server VM
    # This allows communication between VMs on this private network without exposing them to the external network
    db.vm.network "private_network", ip: "192.168.50.5"

    # Customize the resources allocated to the database server VM using the VirtualBox provider
    db.vm.provider "virtualbox" do |vb|
      # Allocate 2048 MB (2 GB) of memory to the database server VM
      vb.memory = "2048"
    end
  end
end


```

- Also create a file web_script.sh (the provisioning script for the web server) in the project folder with the following content.

``` bash

#!/usr/bin/env bash

# Update the package list to ensure we have the latest information on available packages and their dependencies.
apt-get update

# Install Nginx web server and MySQL client.
# The '-y' option automatically answers 'yes' to any prompts during the installation process.
apt-get install -y nginx mysql-client

# Check if /var/www is not a symbolic link. The -L flag checks if the file is a symbolic link.
########### Add this block if you wish to serve a custom web page from your shared folder ############
if ! [ -L /var/www ]; then
  # If /var/www is not a symbolic link, remove the existing /var/www directory.
  # The '-rf' options ensure recursive removal of the directory and its contents without prompting for confirmation.
  rm -rf /var/www

  # Create a symbolic link from /var/www to /vagrant.
  # This links the /var/www directory, used by the web server to serve files, to the /vagrant directory.
  # /vagrant is shared between the host machine and the VM, allowing easy access and synchronization of files.
  ln -fs /vagrant /var/www
fi


```

- Create another file in the project directory named db_script.sh (the provisioning script for the DB server), with the following content.

``` bash

#!/usr/bin/env bash

# Update the package list to ensure we have the latest information on available packages and their dependencies.
apt-get update

# Install the MySQL server package.
# The '-y' option automatically answers 'yes' to any prompts during the installation process.
apt-get install -y mysql-server

# Use a heredoc to run a series of SQL commands on the MySQL server.
# These commands will be executed as the root user by default.
mysql <<EOF
# Create a new database named 'my_database'.
CREATE DATABASE my_database;

# Create a new MySQL user 'my_user' that can connect from any host ('%').
# This user is identified by the password 'my_password'.
CREATE USER 'my_user'@'%' IDENTIFIED BY 'my_password';

# Grant all privileges on the 'my_database' database to the 'my_user' user.
GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'%';

# Refresh the privileges, ensuring that the changes take effect immediately.
FLUSH PRIVILEGES;
EOF

# Use 'sed' (stream editor) to modify the MySQL configuration file to allow external connections.
# The '-i' option edits the file in place.
# The 's/bind-address\s*=.*$/bind-address = 0.0.0.0/' part of the command uses a regular expression to:
#   - Match the line that begins with 'bind-address', followed by any whitespace (\s*), an equals sign (=), and any characters (.*) until the end of the line ($).
#   - Replace the entire matched line with 'bind-address = 0.0.0.0'.
# This change allows MySQL to listen on all network interfaces (0.0.0.0), enabling connections from any IP address.
sed -i "s/bind-address\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart the MySQL service to apply the configuration changes.
# 'systemctl' is the command to interact with the systemd service manager.
# 'restart' stops and then starts the MySQL service, applying any changes made to the configuration.
systemctl restart mysql


```

- Optionally, if you chose to serve a custom webpage from your shared folder, you can create a new directory named "html" in the project directory and add an index.html file in the html directory.


### Step Two: Provision Your Machines.

- In your project directory, run `~$ vagrant up` and relax, everything will get setup for you in a few.
- When it's done setting up run `~$ vagrant ssh web` to access the web server via ssh.
- Also to access the DB server run `~$ vagrant ssh db`.


### Step Three: Test the VMs.
- Now we can run the following commands to test if all packages where successfully installed.
    * On the web server VM - `~$ nginx -V` and `~$ mysql -V`.
    * On the DB server VM - `~$ mysql -V`.

- Also we can open `localhost:4567` on the browser and we should see the page being served by nginx on the web server.

- To confirm the VMs can talk to each other we'll try to access the database we created on the DB server from the web server using the following commands.
    * On the web server VM, run `~$ mysql -h192.168.50.5 -umy_user -pmy_password`. If it's successful, you'll be ushered into mysql, where you'll run the next command.
    * Run `~$ show databases; `. You should see the entry for the "my_database" database we created during provisioning.
