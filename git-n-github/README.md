# Working With Git and Github

Our objectives for this article would be to:
- Download and Install Git.
- Create a Github Account.
- Create a New Repo on Github.
- Setup SSH Keypairs on our Local Machine to Securely Authenticate and Access our Github Repo.
- Successfully Clone the Repo.
- Add Files to the Repo Locally.
- Successfully Push the new File to the Remote(github).

### Download and Install Git
To download and install git for any platform click [here](https://www.git-scm.com/downloads) and follow the instructions for your specific platform or Operating System.

### Create a Github Account
To create a github account click [here](https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home) and follow the instructions, or use an exiting one.

### Create a New Repo on Github
To create a new repo, click your profile avatar at the top-right of the page and goto `Your Repositories`. Click the new button (in green with a journal icon) at the top-right corner of the page. Fill the form and click create repository button at the bottom of the form. (for the purpose of this article, we can use the suggested name by clicking the word in green under the input field for repo name. Also we can leave everyother thing as default. Basically, just click the suggested name and then the create repo button.)

### Setup SSH Keypairs on our Local Machine to Securely Authenticate and Access our Github Repo.
1. On your terminal run `ssh-keygen -t ed25519`. You're prompted for a file name, you can choose to go with the default by hitting the 'Enter' key on your keyboard or provide a path with a name with which to identify the keypair. Next you're asked to set a passphrase, you can leave this empty and just hit your 'Enter' key 2x. 

2. Next run `cat ~/.ssh/keypair_name.pub` to print out the public key which you'll copy to your clipboard and head over to github.

3. On github, click your profile avatar at the top right corner of the page and head to `settings`. On the left side bar click `SSH and GPG keys`. At the top right you'll find a green button that says `New SSH key` click it and fill out the form, providing a title for identification and pasting the public key you copied earlier to the key textarea. Finally click `Add SSH key`.

4. Now we need to tell the SSH Agent on our local machine to authenticate with the private key for the github.com host. To do that, go to your terminal and run `nano ~/.ssh/config`, and add the following lines to it;

```
Host github.com
    User git
    HostName github.com
    IdentityFile /path/to/keypair/keypair_name
    IdentitiesOnly yes
```
after which you save with `CTRL + O` and exit with `CTRL + X`.

5. With this done you can test your connection to github by running the command `ssh -T git@github.com` and if successful you'll get the following reply;
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```
### Successfully Clone the Repo.
We can now attempt to clone the repository we created above. Let's get the unique url for the repo by going to github, and navigating to repositories, open the the repo you wish to clone and click the green button labelled code with a code block icon. Select the ssh tab and copy the provided link. Now on your terminal, navigate to the directory you'll like to create the repo and run `git clone paste the provided link here`, and hit enter. You should now have the repo on your local machine, if this completes successfully.

### Add Files to the Repo Locally.
Navigate into the repo and Create a new file. It can be any type of file and can contain anything. After adding some content, save it.

### Successfully Push the new File to the Remote(github).
Now to push the new state of the repo to the remote, you'll need to stage and commit your recent changes, then push to the remote(github). Follow these steps to achieve that;
1. In the repo directory run `git add .`, to stage all recent changes.
2. Then run `git commit -m "descriptive comment"`, to commit those changes.
3. Finally run `git push` to upload all changes to the remote repo.

You can verify this by logging into github and opening that repo. You should see that the new file is in the repo.

## Bonus
For authenticating with shh you can add the -i flag to provide the private key instead of meddling with the config file. Here's an example `ssh -i /path/to/private/key/keypair_name git@github.com`. However this is not standard practice and will often be used just to test a connection to the remote server(github in this context).

## Further Studies
Here're other ways to connect to github and perform basic VCM operations;
- HTTPS: Easy setup, suitable for most users. Use with a credential helper for convenience.
- GitHub CLI: Provides extra GitHub-specific functionalities and easy setup.
- Personal Access Tokens: More secure than passwords for HTTPS, useful in CI/CD.
- OAuth Tokens: Advanced setup, useful for custom applications integrating with GitHub.