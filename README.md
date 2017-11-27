### Implementing roaming user profile on Linux.

The basic concept is that there is a local copy of the profile of a user authenticated via AD, say at `/usr/local/DOMAIN/user`,
and a copy of the user profile stored on a central server and mounted on the local system, say at `/usr/roaming/DOMAIN/user`.

The task is to keep the profiles in sync.

[Related post](https://abchk.in/blog/roaming-profile-on-linux-in-2017/).

*P.S.*
Tested on Ubuntu 16.04.
