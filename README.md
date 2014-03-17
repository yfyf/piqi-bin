piqi-bin
========

This is a dummy / wrapper rebar dependency which copies over the piqi binary
from your system (based on PATH) and stores in its `priv/` dir for later
access.

It also verifies the version. See `rebar.config` for details.

This can be used to ensure, that you will always use the same piqi version at
runtime as you did at buildtime.

WARNING: largely untested at this point, especially the version contraint part.
