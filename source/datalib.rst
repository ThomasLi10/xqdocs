Data Framework
====================

Quick Start
---------------

We have designed an elegent data framework for xq module.

The data environment needs to be initialized with an configuration file (Ini format) that has information such as data dictionary, research instruments and date range etc. An example of configuration file for Chinese A share stocks is **/q/share/lixiang/xq-examples/datablib/ini/ashare.base.ini**, which we will talk about in :ref:`Configuration Reference <config>` later.

Initialization
^^^^^^^^^^^^^^^^^

First step is to initialize the data environment:

.. code-block:: python

    from xq import *
    env = DataEnv('/q/share/lixiang/xq-examples/datablib/ini/ashare.base.ini')

Now that the data environment has started, we need to set the date and time of the platform so all data access will be as of this date/time. In this example, say we want to access data as if we were on 20200606 at 10:00am: 

.. code-block:: python

    env.set_now(20200606,1000)


Daily Data
^^^^^^^^^^^^^^^

In this study, let's assume that we are interested in the unadjusted open prices. We can achieve this by creating an XQData object with "unadjusted_open" as the argument. 
    
.. code-block:: python

    uopen = XQData('unadjusted_open',env)

We can use uopen object to access the open prices in a number of ways.

Vector
""""""""""""""

To get the open prices on "today", i.e. 20200606: 

.. code-block:: python
    
    x = uopen()
    # Or 
    x = uopen.vector()

    x :
    array([ 13.6 ,  26.65,  29.78, ...,  23.02, 154.64, 129.9 ])

Or to get a pandas Series with labels: 

.. code-block:: python
    
    sr = uopen.vector_pd()

    Out :
    000001     13.60
    000002     26.65
    000004     29.78
    000005      2.68
    000006      5.10
               ...
    603998      6.50
    603999      6.00
    605001     23.02
    605168    154.64
    605288    129.90
    Name: 20200605, Length: 3653, dtype: float64


One can also get data from a different day, such as "Yesterday": 

.. code-block:: python

    x = uopen(Constants.Yesterday)
    sr = uopen.vector_pd(Constants.Yesterday)

    x : array([ 13.53,  27.02,  29.  , ...,  22.22, 140.58, 133.63])
    sr :
    000001     13.53
    000002     27.02
    000004     29.00
    000005      2.65
    000006      5.10
               ...
    603998      6.55
    603999      5.82
    605001     22.22
    605168    140.58
    605288    133.63
    Name: 20200604, Length: 3653, dtype: float64



History Matrix
"""""""""""""""""

We can also get a recent history of stocks in the universe. The query below get the open prices for the recent 10 days ending on today (i.e. 20200606)

.. code-block:: python

    m = uopen.history_matrix(10)

    m : 
    array([[ 12.97,  13.02,  13.05, ...,  13.64,  13.53,  13.6 ],
           [ 25.23,  25.58,  25.83, ...,  27.4 ,  27.02,  26.65],
           [ 28.09,  27.73,  28.58, ...,  29.29,  29.  ,  29.78],
           ...,
           [ 25.56,  28.11,  25.21, ...,  23.1 ,  22.22,  23.02],
           [   nan,    nan,    nan, ..., 127.8 , 140.58, 154.64],
           [   nan,    nan,    nan, ..., 160.87, 133.63, 129.9 ]])


We can also get a DataFrame version of the same query, which might be easier to read: 
    
.. code-block:: python

    df = uopen.history_matrix_pd(10)

    df : 
            20200525  20200526  20200527  20200528  20200529  20200601  20200602  20200603  20200604  20200605
    000001     12.97     13.02     13.05     12.87     13.01     13.10     13.29     13.64     13.53     13.60
    000002     25.23     25.58     25.83     25.88     26.12     25.98     26.37     27.40     27.02     26.65
    000004     28.09     27.73     28.58     29.38     28.28     29.01     29.40     29.29     29.00     29.78
    000005      2.51      2.52      2.60      2.56      2.57      2.56      2.61      2.66      2.65      2.68
    000006      4.68      4.73      4.80      4.81      4.79      4.85      4.90      5.00      5.10      5.10
    ...          ...       ...       ...       ...       ...       ...       ...       ...       ...       ...
    603998      6.28      6.31      6.40      6.39      6.33      6.38      6.48      6.56      6.55      6.50
    603999      5.52      5.47      5.57      5.60      5.59      5.69      5.79      5.84      5.82      6.00
    605001     25.56     28.11     25.21     27.00     24.15     22.60     22.84     23.10     22.22     23.02
    605168       NaN       NaN       NaN     72.74     96.02    105.62    116.18    127.80    140.58    154.64
    605288       NaN       NaN       NaN       NaN       NaN    111.11    146.66    160.87    133.63    129.90

    [3653 rows x 10 columns]


Minute Bar Data
^^^^^^^^^^^^^^^^^^

Now let's look at minute bar data. In this case, we will examine the intraday 5 minute bars for mid prices.

Since we use XQData to access all data listed in the data dictionary, we will create a XQData object that references 5 minute bars for mid prices as follows: 


.. code-block:: python

    mb = XQData('mid.b5',env)

From now on, mb object can be used to access minute bars in different ways.

To get the current prices, at 10 am of 20200606: 

Vector
""""""""""""""

.. code-block:: python
    
    y = mb()

    y : array([ 13.485,  26.355,  29.285, ...,  22.915,     nan, 126.13 ])

To get the prices 15 minutes ago: 

.. code-block:: python
    
    y = mb.vector_pd(Constants.FifteenMinsAgo)

    y : 
    000001     13.485
    000002     26.405
    000004     29.355
    000005      2.665
    000006      5.095
               ...
    603998      6.485
    603999      5.985
    605001     23.105
    605168    154.645
    605288    126.665
    Name: 945, Length: 3653, dtype: float64

To get prices from Open to 5 minutes ago in a DataFrame, i.e. from 9:35 to 9:55

Daily Matrix
""""""""""""""

.. code-block:: python
    
    y = mb.daily_matrix_pd(Constants.FiveMinsAgo)

    y:
                930      935      940      945      950      955
    000001   13.605   13.515   13.485   13.485   13.475   13.465
    000002   26.655   26.425   26.395   26.405   26.405   26.395
    000004   29.795   29.605   29.435   29.355   29.295   29.395
    000005    2.685    2.665    2.665    2.665    2.665    2.655
    000006    5.105    5.125    5.085    5.095    5.065    5.065
    ...         ...      ...      ...      ...      ...      ...
    603998    6.505    6.495    6.465    6.485    6.470    6.465
    603999    5.995    5.965    6.005    5.985    5.995    6.045
    605001   23.030   23.195   23.215   23.105   23.070   23.040
    605168  154.645  154.645  154.645  154.645  154.645  154.645
    605288  129.905  127.865  126.480  126.665  126.250  126.575

    [3653 rows x 6 columns]

History Matrix
""""""""""""""""""

To get a recent history at the same minute bar time of stocks in the universe. In this case, mid price at 9:55 of last 10 days.

.. code-block:: python

    y = mb.history_matrix_pd(10,Constants.FiveMinsAgo)

    y:
            20200525  20200526  20200527  20200528  20200529  20200601  20200602  20200603  20200604  20200605
    000001    12.955    13.015    13.125    13.105    12.995    13.225    13.375    13.815    13.445    13.465
    000002    25.465    25.605    25.995    26.475    26.025    26.165    26.425    27.625    26.615    26.395
    000004    28.205    27.915    30.155    29.490    28.505    28.850    29.220    29.485    29.300    29.395
    000005     2.515     2.625     2.585     2.575     2.555     2.575     2.625     2.645     2.665     2.655
    000006     4.695     4.785     4.795     4.845     4.785     4.835     5.115     5.015     5.215     5.065
    ...          ...       ...       ...       ...       ...       ...       ...       ...       ...       ...
    603998     6.305     6.325     6.445     6.420     6.345     6.390     6.505     6.665     6.515     6.465
    603999     5.555       NaN     5.585     5.645     5.695     5.755     5.845     5.825     5.845     6.045
    605001       NaN    26.125    26.065    26.420    23.885    23.100    23.335    22.725    22.525    23.040
    605168       NaN       NaN       NaN       NaN       NaN   105.625       NaN       NaN       NaN   154.645
    605288       NaN       NaN       NaN       NaN       NaN       NaN       NaN   143.995   130.240   126.575

    [3653 rows x 10 columns]

Time-series Matrix
""""""""""""""""""""""""

To get recent consecutive minute bar prices

.. code-block:: python

     y = mb.time_series_matrix_pd(20,Constants.FiveMinsAgo)

     y:
             20200604:1355  20200604:1400  20200604:1405  20200604:1410  20200604:1415  ...  20200605:935  20200605:940  20200605:945  20200605:950  20200605:955
     000001         13.565         13.555         13.575         13.575         13.565  ...        13.515        13.485        13.485        13.475        13.465
     000002         26.625         26.645         26.655         26.695         26.675  ...        26.425        26.395        26.405        26.405        26.395
     000004         29.285         29.295         29.335         29.675         29.645  ...        29.605        29.435        29.355        29.295        29.395
     000005          2.665          2.665          2.665          2.665          2.665  ...         2.665         2.665         2.665         2.665         2.655
     000006          5.135          5.125          5.135          5.135          5.135  ...         5.125         5.085         5.095         5.065         5.065
     ...               ...            ...            ...            ...            ...  ...           ...           ...           ...           ...           ...
     603998          6.500          6.495            NaN          6.515          6.505  ...         6.495         6.465         6.485         6.470         6.465
     603999          6.045          6.045          6.045          6.045          6.045  ...         5.965         6.005         5.985         5.995         6.045
     605001         22.545         22.555         22.555         22.555         22.535  ...        23.195        23.215        23.105        23.070        23.040
     605168            NaN            NaN            NaN            NaN            NaN  ...       154.645       154.645       154.645       154.645       154.645
     605288        132.415        132.515        132.945        133.940        133.155  ...       127.865       126.480       126.665       126.250       126.575
     
     [3653 rows x 20 columns]                                                                                                                      

Data Framework Components
------------------------------

Here are the key concepts/components in the data framework:

    - Configuration
    - Data Dictionary
    - Future Data Invalidation
    - DateTimeSpec
    - Universe
    - XQData


.. _config:

Configuration Reference
------------------------------

Data environment construction requires several necessary configurations:

- ``ResearchDatesFile``, ``ResearchDataStartDate`` and ``ResearchDataEndDate`` provide list of trading dates of the data environment, which :py:class:`DateTimeSpec <xq.DateTimeSpec>` heavily relies on.
- ``ResearchInstrumentsFile`` clarifies research instrument universe of the data environment, which is exactly :attr:`UnivType.All <xq.UnivType>` refers to.
- ``MarketTradingTimes`` lists trading times of the market.
- ``Universe`` is the tradable universe, which must related to an entry under ``[DataDictionary]`` we will discuss later in :ref:`Data Dictionary<datadict>`.

Example (/q/share/lixiang/xq-examples/datablib/ini/ashare.base.ini):

.. code-block:: ini

    []
    ENV_DATA_DIR    = /q/share/lixiang/data/ashare/windpy
    
    []
    Universe                        = estu.r
    
    []
    AllowFutureData                 = False
    # Research environment
    ResearchDatesFile               = %ENV_DATA_DIR%/trade.date.txt
    ResearchInstrumentsFile         = %ENV_DATA_DIR%/ids.txt
    ResearchDataStartDate           = 20170101
    ResearchDataEndDate             = 20221231
    MarketTradingTimes              = [ 930To1130 1300To1500 ]

First and second columns of ``ResearchDatesFile`` should be dates in YYYYMMDD format and 1/0 flags for trading days. And the file should contain no header.

Example  (/q/share/lixiang/data/ashare/windpy/trade.date.txt):

.. code-block:: text

    20100104,1
    20100105,1
    20100106,1
    20100107,1
    20100108,1
    20100109,0
    20100110,0
    20100111,1
    20100112,1
    20100113,1
    20100114,1
    ...

First three columns of ``ResearchInstrumentsFile`` should be tickers, exchange markets and classifications. Also, no header in this file.

Example  (/q/share/lixiang/data/ashare/windpy/ids.txt):

.. code-block:: text

    000001,SZ,AShareStock
    000002,SZ,AShareStock
    000003,SZ,AShareStock
    ...
    csi500,-,AShareIndex
    csi800,-,AShareIndex
    sse50,-,AShareIndex

You may notice there is an entry ``AllowFutureData`` which was not mentioned. It is dispensable for the data environment configuration with default value of False. It helps users to control future data invalidation. See more detail in :ref:`Future Data Invalidation<futuredata>`

Initialize with such an ini file, then you get an :py:class:`DataEnv <xq.DataEnv>` object.

.. code-block:: python
    
    env = DataEnv('/q/share/lixiang/xq-examples/datablib/ini/ashare.base.ini')

If your programe only need a single environment, there is no need to always assign the env object to other functions or classes one by one. You may set it as the global one which others use as default env.

.. code-block:: python
    
    set_data_env(env)


.. _datadict:

Data Dictionary
-------------------------

Data dictionary contains definitions of data sources.

A data source represents a specific data concept, such as open prices, volumes, index memberships etc.

A data source might use many files with different formats to store its data. Take daily close prices for example, some years they might be stored in binary file, other years might be CSV text file, and in real-time (actual day today) prices might be from a network socket.

So a data source is a user facing term. i.e. a user only needs to know the nature or concept of a data source, not the actual storage or format of its data files.

A user would need to access data using the name of its data source in the data dictionary. For example, given the following data dictionary definition of open prices: 

.. code-block:: ini

    []
    DAILY_DATA_DIR  = %ENV_DATA_DIR%
    
    [DataDictionary]
    unadjusted_open = [ UniverseBinary:%DAILY_DATA_DIR%/uopen.bin:Date|Asset ]

A user would only need to use 'unadjusted_open' as the name to create a :py:class:`XQData <xq.XQData>` object with a data environment object, from which the user can access data on different dates, without worrying about the underlying formats of the data files.

.. code-block:: python
    
    myopen = XQData('unadjusted_open',env)

See also for more information about different file formats that can be loaded by the platform. (TODO)

A user can get a full list of data source names in the dictionary of the current system by using the data_dictionary function:

    
.. code-block:: python
    
    print(env.data_dictionary)

    Output:
    ['ESTU',
     'ESTU.R',
     'UNADJUSTED_CLOSE',
     ...

.. code-block:: python

    print(env.data_dictionary_cfgs)

    Output:
    {'ESTU': {'type': 'UniverseBinary',
     'file': ['/q/share/lixiang/data/ashare/windpy/estu.bin'],
     'cfg': [_DataConfig(['Date|Asset'])]},
     'ESTU.R': {'type': 'UniverseBinary',
     'file': ['/q/share/lixiang/data/ashare/windpy/estu.r.bin'],
     'cfg': [_DataConfig(['Date|Asset'])]},
     'UNADJUSTED_CLOSE': {'type': 'UniverseBinary',
     'file': ['/q/share/lixiang/data/ashare/windpy/uclose.bin'],
     'cfg': [_DataConfig(['Date|Asset', 'valid=1500'])]},

Miscellaneous Data Tasks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Although xq makes data sources as user facing terms, sometimes one, such as a miscellaneous data task developer or a data-pipeline maker, needs to read source data file regardless of the xq data framework.

For 2D and 3D binary files, xq provides planty interface functions to read and to save as.

For financial statement data, xq also provides interface functions to read and to make.

See more detail in :doc:`API<../api>`.



.. _futuredata:

Future Data Invalidation
-------------------------

TODO


Date and Time Specifications
------------------------------

The :py:meth:`set_now <xq.DataEnv.set_now>` method plugs a baseline date and time for the data environment. Thus, it is more convenient and less error-prone for users to retrieve data relative to this date and time. 

Xq has unified the rules to express dates and times by class :py:class:`DateTimeSpec <xq.DateTimeSpec>`. :py:class:`DateTimeSpec <xq.DateTimeSpec>` has two attributes, :py:class:`DateSpec <xq.DateSpec>` and :py:class:`TimeSpec <xq.TimeSpec>`.

One may new a :py:class:`DateSpec <xq.DateSpec>` object with either a YYYYMMDD-format integer or an :py:class:`DateOffset <xq.DateOffset>` object. Similarly, one may new a :py:class:`TimeSpec <xq.TimeSpec>` object with either a HHMM-format integer or an :py:class:`TimeOffset <xq.TimeOffset>` object.

Several commonly used instances of DateTimeSpec have been pre-defined and encapsulated into :py:class:`Constants <xq.Constants>`, such as:

- Now             
- Today           
- Yesterday       
- TwoDaysAgo      
- ThreeDaysAgo    
- FourDaysAgo     
- FiveDaysAgo     
- Tomorrow        

- AShareCloseToday        
- AShareCloseYesterday    
- AShareOpenToday         
- AShareOpenYesterday     

- OneMinAgo       
- TwoMinsAgo      
- ThreeMinsAgo    
- FourMinsAgo     
- FiveMinsAgo     
- TenMinsAgo      
- FifteenMinsAgo  
- TwentyMinsAgo   
- ThirtyMinsAgo   
- SixtyMinsAgo    
- OneHourAgo      
- TwoHoursAgo     
- ThreeHoursAgo   
- FourHoursAgo    

Universe
----------------

There are two types of universes:

- **research universe**, also known as the **"all"** universe, or the full universe, which contains all tickers that the data frame work might have data for. No data can be found unless a stock is in the research universe.

    - research universe is a static and ordered list of tickers
    - for Chinese A Shares in the recent 10 years, about 4000 to 5000 stocks in the research universe, close to all stocks that are ever listed
    - most users share the same research universe
    - research universe is defined in the Ini file by the ``ResearchInstrumentsFile`` field


- **tradable universe**, which is the set of stocks that a particular researcher might be interested in. For example, if one is interested in stocks in CSI300 index, then there are 300 stocks in the tradable universe each day.

    - tradable universe should be a subset of the research universe
    - tradable universe might change daily
    - different users could have different tradable universes
    - tradable universe is defined in the Ini file by the ``Universe`` field


XQData
-------------

:py:class:`XQData <xq.XQData>` object is a handle that allows one to access platform data by name in various formats.

Each XQData object is linked to a data source (such as unadjusted close price) by name. All available data source names are defined in data dictionary

Three principle attributes are needed for a data query:

- *when*, i.e. the date and time for the data is needed. Example date and time specifications are: Now, Constants.Yesterday, Constants.ThreeDaysAgo etc. See also :py:class:`Constants <xq.Constants>`, and :py:class:`DateTimeSpec <xq.DateTimeSpec>`
- *how*, i.e. the format of the data to be returned. 
- *what*, i.e. what universe of stocks to be returned. Two possible choices:

    - :py:meth:`UnivType.Tradable <xq.UnivType>`, tradable universe, which are the universe being studied, such as CSI300. This is specified by the "Unvierse" field in the Ini file.
    - :py:meth:`UnivType.All <xq.UnivType>`, all, which are all tickers in the research universe. This is generally larger than the tradable universe.


Data Format Reference 
------------------------------


TODO


A Demo
------------------

Here is an executable demo under path **/q/share/lixiang/xq-examples/datalib** on firebolt for further learning. Copy it to your home directory and run the program right now!

