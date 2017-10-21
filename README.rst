Network Server Performance Benchmarking Toolbench
=================================================

This is a simple collection of scripts intended to benchmark the basic
network performance of a variety of server frameworks.

The servers are run inside a Docker container for environment stability,
so to use this toolbench you need a reasonably recent Docker.

Installation
------------

Install the following:

- `Docker<https://docs.docker.com/engine/installation/>` (tested with *17.09.0-ce*)
- Python 3.5+ (tested with *3.5.2*)
- `numpy<https://pypi.python.org/pypi/numpy>` (tested with *1.13.3*)
- `wrk<https://github.com/wg/wrk>` (tested with *4.0.0*)

Build the docker image containing the servers being tested by running
``./build.sh``.

The benchmarks can then be ran with ``./run_benchmarks``.  Use
``./run_benchmarks --help`` for various options, including selective
benchmark running.

To run the http benchmarks and save results to ``./results.html``:

.. code::

  ./run_benchmarks --duration=60 --save-html=results.html http
