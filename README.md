piqi-bin
========

This is a dummy / wrapper rebar dependency which copies over the piqi binary
from your system (based on `PATH`) and stores it in its `priv/` dir for
convenient later access from within Erlang via `code:priv_dir(piqi_bin)`.

You can also override the `piqi` in `PATH` by setting the env variable `PIQI`
to point to the piqi binary.

`piqi-bin` also verifies the version set by the option `req_piqi_vsn` in
`rebar.config`. See `rebar.config` for details.

This can be used to ensure, that you will always use the same piqi version at
runtime as you did at build time.

WARNING: largely untested at this point, especially the version constraint
part.  Though seems to work.
