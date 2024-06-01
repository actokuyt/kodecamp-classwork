# User Management and Permissions

User management and permissions is an important concept for devops engineers. Understanding how to manage users and permissions is fundamental to maintaining a secure and efficient Linux environment. Whether you are administering a small personal server or a large corporate network, mastering these concepts is crucial for system security and proper resource allocation.

### User Accounts

The following commands can be used to create or modify user accounts on a Linux environment.
- `$ useradd <user name>` is used to create a new user. You can use the `-m` flag to create a home directory for the user, or a -g flag to add the user simultaneously to a group.
- `$ usermod -l <new user name> <old user name>` is used to change a users login name.
- `$ usermod -d <new home dir> <user name>` is used to change the home directory.
- `$ usermod -G <group name> <user name>` is used to add the user to a secondary group.
- `$ usermod -s <shell path> <user name>` is used to change a users shell.
- `$ userdel <user name>` is used to delete a user. You can use the -r flag to delete the home directory simultaneously.
- `$ passwd <user name>` is used to chage a users password.
- `$ id <user name>` is used to display a users identity information.
- `$ groups <username>` is used to display all groups a user belongs to.
- `$ getent passwd <user name>` is used to get a users account details.
- `$ cat /etc/passwd` or `$ getent passwd` will list all user entities on a system.


### Groups

The following commands can be used to create or modify groups on a Linux environment.
- `$ groupadd <group name>` is used to create a new group on a system.
- `$ groupmod -n <new group name> <old group name>` is used to change a groups name.
- `$ groupmod -g <new GID> <group name>` is used to change a groups ID.
- `$ groupdel <group name>` is used to delete a group.
- `$ gpasswd -a <user name> <group name>` is used to add user to a group.
- `$ gpasswd -d <user name> <group name>` is used to remove a user from a group.
- `$ getent group <group name>` is used to get details about a specific group.
- `$ getent group` will list all groups on a system.

## Permissions

The following commands are used to manage permissions on a linux system.

- `$ chown <new user>:<new group> <file name>` is used to change the ownership of a file or directory. You can use the -R flag to recursively change the ownership of a directory and all of it's contents.
- `$ chgrp <new group> <file name>` is used to change the group ownership of a file or directory. The -R flag is used to recursively change the ownership of a directory and all of its contents.
- `$ chmod [options] <file name>` is used to grant or remove permissions on a file or folder. There're two ways in which this can be done and it's illustrated below.


### Using Symbolic mode

Symbolic mode uses symbols (r, w, x, +, -, =) to change permissions. Where : 
- "u" = User (owner)
- "g" = Group
- "o" = Others
- "a" = All (user, group, and others)
- "+" = Adds a permission
- "-" = Removes a permission
- "=" = Sets the exact permission

e.g: 
- `chmod u+x <filename>` adds execution permissions to the user.
- `chmod g-w <filename>` removes write permissions from the group.
- `chmod a=rw <filename>` sets read and write permissions for all entities.


### Using Numeric mode

Numeric mode uses octal numbers to change permissions. Where:

| octal number | r | w | x |
|--------------|---|---|---|
|0             | 0 | 0 | 0 |
|1             | 0 | 0 | 1 |
|2             | 0 | 1 | 0 |
|3             | 0 | 1 | 1 |
|4             | 1 | 0 | 0 |
|5             | 1 | 0 | 1 |
|6             | 1 | 1 | 0 |
|7             | 1 | 1 | 1 |

e.g:
- `chmod 755 <filename>` adds rwx access for the user, r_x access for the group, r_x access for others. The first digit represents the permission for the user, the second represents the permissions for the group, and the last digit represents permissions for others.


### There's a pattern to getting the table above

- The column for x alternates between 0s and 1s.
- The column for w alternates between two 0s and two 1s.
- The column for r alternates between four 0s and four 1s.