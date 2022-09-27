.. ini documentation master file, created by
   sphinx-quickstart on Tue Sep  6 17:10:28 2022.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to XQuant's documentation!
=========================================

What is Xquant?
---------------------

Xquant is an intergrated platform for development and deployment of quantitative trading strategies, of all kinds of tradable instruments, such as stocks, bonds, futures, options, or even cryptos. 

It is well-designed (at least we hoped) for users to manipulate data and to simulate historical trading with mild learning-curve.
And we do hope to establish standards or benchmarks for strategy evaluation by providing an universal R&D tool.
Furthermore, **look-ahead bias** (using unavailable future data in research of past data) always cause great damage to a strategy, and xquant shall prevent users from these fatal mistakes, or at least help detect them more easily.

On the other hand, discrepancy between simulation and real-life trading hurt PnL since day one. The platform intends to assure consistency and inheritability from research environment to production environment.
To achieve this goal, the platform shall process three key features:

- High-level compatibility of real-time data (min-bar, level1 or level2) and historical data.
- Robust reusability of the codes of the trading rules on both simulation and real-time upcoming tradings.
- Accurate estimation of transaction costs in simulation.

How Xquant Works?
------------------------

XQuant platform consists of three major Python packages, which play crucial roles in quantitative trading strategies.

- ``ini``. Configuration tool for the platform.
- ``xutil``. Commonly used utility functions or constants in research.
- ``xq``

Each package relies on the former one progressively, but each package can be imported and used standalone.

Now, why not give it a try by running this in ``IPython`` console?

.. code-block:: python

    from xq import *
    hello_quant()



.. toctree::
    start
    ini
    util
    xq
    api
    :maxdepth: 1
    :caption: Contents:



Indices and Tables
==================
* :ref:`genindex`
* :ref:`modindex`
