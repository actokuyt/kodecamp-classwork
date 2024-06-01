# Vagrant

Vagrant isolates dependencies and their configuration within a single disposable, consistent environment, without sacrificing any of your existing tools. 
In lay-man terms vagrant helps you package a light weight bootable environment (OS) called boxes, which can be run on a hypervisor or a containerization platform.

### To get going with vagrant you'll need the following:
* An installation of the vagrant binaries in your system PATH. (this makes vagrant available in your terminal).
* A hypervisor like virtualbox or a containerization platform like docker.
* A vagrantfile which is a configuraton file written in ruby that tells vagrant how to cook your environment.
* A vagrant box which is the lightweight base image from which vagrant builds your custom environment.

### Follow these steps to get going with a vagrant environment:
1. Install the vagrant binaries.
2. Install the virtualization software or hypervisor.
3. Initialize your project with the shell command `vagrant init ubuntu/focal64`, in your project directory. This creates a vagrantfile in your current working directory. Here's a breakdown of the vagrantfile created:

```ruby
# initaite a vagrant configuration block using the configure method
Vagrant.configure("2") do |config| 

# set "ubuntu/focal64" as the base image to use
  config.vm.box = "ubuntu/focal64" #

# end the configuration block
end
```
4. Spin up your virtual environment with the shell command `vagrant up`, in your project directory. This goes ahead to cook a new environment, from the provided base image using the configuration in your vagrantfile. 
5. After the previous command is successfully completed, you can now access your new virtual environment with the shell command `vagrant ssh`, in your project directory. This will directly place you in a new shell environment on your guest environment/virtual environment.
6. When you're done with the project, you can simply exit the virtual environment by running the command `logout`. This takes you out of ssh and back into your project directory.
7. To remove all traces of the guest machine or virtual environment from your host PC, you can run the shell command `vagrant destroy`, in your project directory.


## Here's How You Can Complete The Class Work From The Lecture
### Create a Web Server Using Apache2
#### Remember to use sudo if you encounter permission issues.

1. Create a new directory in your project directory using the shell command `mkdir html`. Move into the new directory by running the shell command `cd html`.
2. Create a new file in the html directory by runnnig the shell command `touch index.html`. Edit the file with `nano index.html`, and add the following lines to it,
```html
<!DOCTYPE html>
<html>
  <body>
    <h1>Hello World!</h1>
  </body>
</html>
```
save the file with __CTRL+O__ then __ENTER__ and exit with __CTRL+X__. This is the html file we'll be serving.

3. Follow the steps above to spin up a virtual environment and ssh into it.
4. From the ssh environment run the shell command `apt update`. This essentially updates the package lists for apt on your virtual environment.
5. After the above command completes successfully, run the shell command `apt install apache2`. This downloads and adds binaries for apache2 to PATH on your VM.
6. Run the shell command `rm -rf /var/www` after the installation. This removes and resets the directory __/var/www__ which apache uses to serve files.
6. Run the shell command `ln -fs /vagrant /var/www`. This basically redirects to your __/vagrant__ from __/var/www__, by creating a link between them, essentially allowing us to serve the files in our __/vagrant__ (shared folder).
7. Everything is now setup, and to verify that, you can run the shell command `wget -qO- 127.0.0.1`. This should return the contents of the html file we created above.

### There's a shortcut to all this using scripting or automation

We can create one more file in our project directory, say __bootstrap.sh__, and add the following as it's contents,
```bash
#!/usr/bin/env bash

# update package lists
apt-get update

# install apache2 from apt(advance package tool)
apt-get install -y apache2

# sets up a redirect for apache2 from "/var/www" to "/vagrant"
# (essentially this tells apache2 to serve the files from /vagrant, which is the shared folder set up by vagrant between our host pc and the guest VM.)
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
```

notice that the contents of the new file are actually the commands with which we installed and set up __apache2__. Now we need vagrant to be aware that we want to run this script while setting up our environment. To do that, our vagrantfile needs to be edited as such,

```ruby
# initaite a vagrant configuration block using the configure method
Vagrant.configure("2") do |config|

# set "ubuntu/focal64" as the base image to use
  config.vm.box = "ubuntu/focal64"

# tell vagrant to run our bash script during setup
  config.vm.provision :shell, path: "bootstrap.sh"

# end the configuration block
end
```

With these changes made, we can go ahead to run `vagrant up` to spin up our environment, and once it's done we can run `wget -qO- 127.0.0.1`, to test our server.


## Port Forwarding With Vagrant
To forawrd a port is simply giving access to your guest system from the host system. Essentially, this provides a way to communicate with your guest system, by giving it a location, more casually a door to it's apartment where you can knock on to make requests or talk to it. To achieve this, one can add another line to the vagrant config block on the vagrnat file, so that we now have this:

```ruby
# initaite a vagrant configuration block using the configure method
Vagrant.configure("2") do |config|

# set "ubuntu/focal64" as the base image to use
  config.vm.box = "ubuntu/focal64"

# tell vagrant to run our bash script during setup
  config.vm.provision :shell, path: "bootstrap.sh"

# tell vagrant to forward the port 80 on the guest to port 4567 on the host.
  config.vm.network :forwarded_port, guest: 80, host: 4567

# end the configuration block
end
```

With this new instruction we successfully open a portal to reach our guest system through the host. So any requests or messages that goes to the port 4567 on the host is forwarded to the port 80 on the guest system. We can now open our browser and visit `localhost:4567` and we should get our html page as response.