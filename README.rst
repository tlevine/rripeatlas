R RIPE Atlas
==========================
Query `RIPE Atlas <https://atlas.ripe.net>`_ data.

Install
-----------
It is an R package. ::

    wget https://github.com/tlevine/rripe-atlas/archive/master.tar.gz
    R CMD INSTALL master.tar.gz

Use
---------
Import it. ::

    library(rripeatlas)

Get a bunch of measurements from
https://atlas.ripe.net/api/v1/measurement/. ::

    get.measurement()

Get one measurement, like from
https://atlas.ripe.net/api/v1/measurement/1001/. ::

    get.measurement(1001)

Get a result, like from
``https://atlas.ripe.net/api/v1/measurement/1001/result/``. ::

    get.result(1001)

The interface is quite basic at the moment; tell me if there's a particular
option/feature you need.
