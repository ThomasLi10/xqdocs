ini
=======

What is Ini?
--------------

The xquant platform uses the Ini-style files for configurations.

Ini files are simple plain text files with a basic structure that composed of sections, variables and includes.


Getting Started
----------------

Good projects separate codes and configurations apart so that users get full control of which parameters they are using and what options they have.

The simplist form of Ini-style configuration is a field or a key equalling some value (scala or vector) under an empty section. For example, assume we have a file named ``foo.ini``:

.. code-block:: ini
    
    # file : foo.ini
    []
    x = 10
    v = [ a b c ]

If you intend to read the scala value of ``x`` and the vector value of ``v``, all you need to do is initializing an 
:py:class:`Ini <ini.Ini>` object with the file path and use ``.find``-series and ``get``-series functions to fetch the contents.



.. code-block:: python

    from ini import Ini
    ini = Ini('foo.ini')
    x = ini.find('x')           # return a string
    i = ini.findInt('x')        # return an int
    v = ini.findStringVec('v')  # return a list


However, sometimes one may find it useful to name each section in order to categorize information, like

.. code-block:: ini

    [Book]
    Color   = red
    ISBN    = 110110
    
    [Pen]
    Color   = black
    Length  = 10

It's quite easy to withdraw these contents too. Bridge the section name and the field name with ``~``, then you will get it.

.. code-block:: python

    book_color = ini.find('Book~Color')
    book_isbn = ini.findInt('BOOK~isbn')
    pen_color = ini.find('Pen~Color')
    pen_len = ini.findNum('PEN~LENGTH')

I bet you have found out that methods of :py:class:`Ini <ini.Ini>` are actually **case-insensitive**.

Easy enough? Well, excuse me that I ask for more of your patience, since there are some more wonderful feature about this ini-style configuration tool. I bet you will love it once you get to know them.

Comments
------------------

Let's start with a simple but aslo essential feature, comments.

In :py:class:`Ini <ini.Ini>`, anything behind ``#`` in each line is a comment which contributes nothing to the content.
Use it wisely and it will help users understand the configuration better.

Example:

.. code-block:: ini
    
    # This is a comment
    []          # Also a comment
    x = 10      # Still a comment

Return Types
----------------

:py:class:`Ini <ini.Ini>` supports to return different types of values, including 

- string ( :py:meth:`find <ini.Ini.find>`, :py:meth:`findString <ini.Ini.findString>`, :py:meth:`get <ini.Ini.get>`, :py:meth:`getString <ini.Ini.getString>` )
- integer ( :py:meth:`findInt <ini.Ini.findInt>`, :py:meth:`getInt <ini.Ini.getInt>`)
- float ( :py:meth:`findNum <ini.Ini.findNum>`, :py:meth:`findFloat <ini.Ini.findFloat>`, :py:meth:`getNum <ini.Ini.getNum>`, :py:meth:`getFloat <ini.Ini.getFloat>`)
- boolean ( :py:meth:`findBool <ini.Ini.findBool>`, :py:meth:`getBool <ini.Ini.getBool>`)
- list of strings ( :py:meth:`findStringVec <ini.Ini.findStringVec>`, :py:meth:`getStringVec <ini.Ini.getStringVec>`)
- numpy array of integers ( :py:meth:`findIntVec <ini.Ini.findIntVec>`, :py:meth:`getIntVec <ini.Ini.getIntVec>`)
- numpy array of floats ( :py:meth:`findNumVec <ini.Ini.findNumVec>`, :py:meth:`findFloatVec <ini.Ini.findFloatVec>`, :py:meth:`getNumVec <ini.Ini.getNumVec>`, :py:meth:`getFloatVec <ini.Ini.getFloatVec>`)
- list of booleans ( :py:meth:`findBoolVec <ini.Ini.findBoolVec>`, :py:meth:`getBoolVec <ini.Ini.getBoolVec>`) 


``find`` v.s. ``get``
-----------------------

The ``find``-series methods would raise error if the section or the field can not be found in the file, while ``get``-series methods should be feed with a second argument, which would be returned if the section/field does not exist.

The type of second argument of ``get``-series methods, whose default value is ``None``, is surprisingly not confined to which type the method returns. In another word, you may literally return any type if the field cannot be "got" from the ini file. For instance, it is legal to put it this way:

.. code-block:: python

    v = ini.getInt('NotFoundField',['a','b'])

Whitespace Characters and Blank Lines
------------------------------------------

Any consecutive whitespace characters would be regarded as one for users' convenience.

Whitespace characters includes:

- A space character
- A tab character
- A carriage return character
- A new line character

Also, all blank lines are ignored.

As a result, it is a legal way to write an entry of vector configuration like this:

.. code-block:: ini

    []
    vec = [ a1 b2 
            c3 d4 e5
            # Even inserted comments are OK
            f6

            g7 h8
    ]

You will find this feature quite useful.

``None`` Recognition
---------------------------

Values will be recognize as ``None`` if their lower-case equal 'none'.


Reference
-----------------

Values in **%variable%** form are expanded based on its most recent value.

For example,

.. code-block:: ini

    []
    x = 10
    y = %x%     # y = 10
    x = 20
    z = %x%     # z = 20, x = 20, y = 10

Thanks to this feature, nested lists or vectors are feasible, like:

.. code-block:: ini

    []
    v1 = [1 2]
    v2 = [3 4]
    v3 = [ %v1% %v2% ] # v3 = [1 2 3 4]


References Prefer Siblings
---------------------------------

References always prefer sibling items under the same section if there are two identical fields under two different sections.

Example

.. code-block:: ini

    []
    x = 1
    [foo]
    x = 2
    y = %x%      # y = 2
    z = %~x%     # z = 1
    w = %foo~x%  # w = 2


Substitution
------------------

The ``find``/``get``-series methods receive user-defined keyword-type arguments, which are used for substitution of sub-strings in **$variable$** format.

For example, an entry of ini file looks like:

.. code-block:: ini
    
    []
    File = /home/$user$/$name$.csv

Then, you can replace 'user' and 'name' by:

.. code-block:: python

    f = ini.find('File',user='lixiang',name='mydata')  
    print(f)    # /home/lixiang/mydata.csv


File Inclusion
-------------------
A powerful feature of :py:class:`Ini <ini.Ini>` is that it can include other Ini files. This would allow the common Ini files to be included by other Ini files.

The format is include, followed by the relative path (or absolute path) to the file to be included, which is enclosed in double quotes or angle brackets ( <> )

Example: 

.. code-block:: ini
    
    include <another.ini>

It is important to keep in mind that path of any included ini file is a **relative** path to the current ini file, which makes it much easier to build a multi-layer ini-file structure.


Environment Variables
----------------------------

All environment variables are set into :py:class:`Ini <ini.Ini>` object in advance. Thus they can be referenced in %variable% form.

Example: 

.. code-block:: ini
    
    []
    Dir = %HOME%/foo
    


Terminal Command Line
----------------------

Another powerfutl feature is that users can set a variable in terminal command line (TCL). 

If the format is to add ``|`` before ``=``, then the field is over-written by the TCL variable. 

Example:

- Ini file

.. code-block:: ini

    []
    x |= 10

- Python script

.. code-block:: python

    # file : tcl.py
    print(ini.find('x'))

- Terminal

.. code-block:: console

    $ x=5 ipython tcl.py  # Got 5

Furthermore, format to assign value of a field under non-void section in TCL is ``section__field``, since ``~`` is not a legal character for a shell variable.

Example:

- Ini file

.. code-block:: ini

    [foo]
    x |= 10


- Terminal

.. code-block:: console

    $ foo__x=7 ipython tcl.py  # Got 7



Apart from that, new TCL variables are treated as environment variables so that they can also be referenced in %variable% form even if never defined in the ini file before.

Example:

- Ini file

.. code-block:: ini

    []
    x = %new%

- Python script

.. code-block:: python

    # file : tcl2.py
    print(ini.find('x'))

- Terminal

.. code-block:: console

    $ new=6 ipython tcl2.py  # Got 6



Built-in Variables
---------------------------

Some variables are automatically set, such as the date when the Ini (or the program) starts.

- ``PATH_FINI`` : the absolute path the ini file.
- ``CUR_DIR`` : the directory of ``PATH_FINI``
- ``TODAY``/``DATE`` : current date


A Demo
------------------

Now, maybe your are still feeling dizzy about all these topics. Don't worry, here is an executable demo under path ``/q/share/lixiang/ini-examples`` on firebolt for further learning. Copy it to your home directory and run the program right now!

.. code-block:: console

   $ cp /q/share/lixiang/ini-examples ~/ -r ; cd ~/ini-examples
   $ ./run.sh


Trust me, it will be a much better world once you become the ini-master!
