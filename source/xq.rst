xq
=======

Finally, it comes to the core module of xquant platform ``xq``.

The Xquant Platform (or xq) is designed for a wide range of quantitative trading strategists and researchers. This documentation aims to give an introduction to get a new user to quickly start to use the platform. For further in-depth understanding of the platform, one should consult additional online references such as :doc:`API <../api>`.

In a nutshell, xq provides the following key features:

- a data environment with easy, efficient and consistent access
- a set of rapid trading strategy development tools
- a realistic historical simulation framework with a rich set of performance attribution capabilities
- a general purpose risk management environment
- seamless integration with real-time trading, allowing immediate deployment of research models to real-time production trading.

Structurally, xq has two main parts: a **data framework** and a **simulation system**. Here is a high level breakdown of key components:

- Data Framework

    - Data Dictionary
    - Access data of various files, formats, and locations
    - Presenting data to users with a consistent mechanism
    - Flexible research universe handling

- Simulation System

    - Depends on the data framework
    - Design many trading strategies
    - Portfolio management
    - Alpha combination
    - Optimization
    - Risk management
    - Execution
    - Performance attribution, sophisticated analytics and flexible reporting


.. toctree::
    datalib
    simulator
