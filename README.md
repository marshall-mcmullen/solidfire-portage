# README #

Portage is a package management system originally created for and used by Gentoo Linux and also by Chrome OS, Sabayon, and Funtoo Linux among others. Portage is based on the concept of ports collections. Gentoo is sometimes referred to as a meta-distribution due to the extreme flexibility of Portage, which makes it operating-system-independent. The Gentoo/Alt project is concerned with using Portage to manage other operating systems, such as BSDs, Mac OS X and Solaris. The most notable of these implementations is the Gentoo/FreeBSD project.

For more background on the concepts used in Portage see the obligatory wikipedia link: [https://en.wikipedia.org/wiki/Portage_(software)]

This repository hosts the SolidFire portage tree for our own internal 3rd Party Library build system. In this repo we've got a rather sophisticated and elegant eclass infrastructure that makes it trivial to add new 3rd Party Libraries into our core product in a manner that guarantees the strict versioning used at SolidFire.