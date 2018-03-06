# README #

Portage is a package management system originally created for and used by Gentoo Linux and also by Chrome OS, Sabayon, and Funtoo Linux among others. Portage is based on the concept of ports collections. Gentoo is sometimes referred to as a meta-distribution due to the extreme flexibility of Portage, which makes it operating-system-independent. The Gentoo/Alt project is concerned with using Portage to manage other operating systems, such as BSDs, Mac OS X and Solaris. The most notable of these implementations is the Gentoo/FreeBSD project.

For more background on the concepts used in Portage see the obligatory [wikipedia Link](https://en.wikipedia.org/wiki/Portage_(software)).

This repository hosts the SolidFire portage tree for our own internal 3rd Party Library build system. In this repo we've got a rather sophisticated and elegant eclass infrastructure that makes it trivial to add new 3rd Party Libraries into our core product in a manner that guarantees the strict versioning used at SolidFire.


# So you want to modify an ebuild #

There are a few steps that can be difficult for people to figure out the first time they are going about modifying an ebuild that makes it difficult and potentially frustrating to attempt. This will hopefully alleviate those issues and streamline the process.

## Make your changes ##

As you may expect, this should be the easy part. Basically, you do whatever you would be doing. This may be as simple as copying an existing ebuild file and renaming it for the new version, or as complex as creating an entirely new ebuild. Either way, make your changes... just don't check them in yet!

## Updating the Manifest ##

This is where the meat of the process comes in. Updating the Manifest file, and getting everything checked is easiest done in Gentoo, but most dev workstations aren't running Gentoo. So we are going to drop in to a docker image that is running everything we need!

This should be as easy to accomplish as `dmake shell`.

## Updating the `/etc/wgetrc` file ##

Once you are in the docker container, you will want to update the wgetrc configuration so wget has access to bitbucket (using your credentials) to download the .bz2 source tree of the package you are updating. To do this, simply add the following lines to the docker image's `/etc/wgetrc` file, and save it off. It is important to note that since this is all within a docker container, it is transient and you will have to do this each time.

> user=example.user@example.com  
> password=mySuperAwesomePassw0rdYo!!!  
> auth-no-challenge=on  

## Finally letting the build magic happen ##

Great! Now all of the setup is done and we are ready to get cracking! This is the easy part (assuming that things are working). Simply use `make digest` and it should auto-magically find all the new/ updated ebuilds and update their manifest (as well as adding the tar.bz2 manifest lines) accordingly.

Once that is all done, `exit` out of the docker image, commit your work (and the manifest updates), push them to bitbucket, and you are ready to open a pull request!

# A little troubleshooting #

### HELP! dmake is giving me an auth failure and bailing ###

If you run into an error message along the lines of the following, it likely means that your ssh-agent isn't set up properly for some reason or another.

> Could not open a connection to your authentication agent.  
> a bytes-like object is required, not 'str'  

In that case, what you will want to do is `$(ssh-agent)` to make sure that SSH agent is running, and then add your private keys to it via `ssh-add /path/to/private/ssh/key`. You may want to add multiple ssh keys.

Sometimes, the `$(ssh-agent)` will fail, at which point you can manually run the same commands it would by doing the following:

`ssh-agent` (notice that we aren't swapping it in the subshell)

> SSH\_AUTH\_SOCK=/tmp/ssh-2OlWWp9TG8CK/agent.6820; export SSH\_AUTH\_SOCK;  
> SSH\_AGENT\_PID=6821; export SSH\_AGENT\_PID;  
> echo Agent pid 6821;  

`export SSH_AUTH_SOCK=/tmp/ssh-2OlWWp9TG8CK/agent.6820`  
`export SSH_AGENT_PID=6821`  

At that point, everything _should_ work. At least in theory.
