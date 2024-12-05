1. Создать пользователя admin с правами администратора. Дальнейшие действия, требующие прав администратора, осуществлять под ним.

``` sql
SQL> create user admin identified by "6123"; -- создание пользователя admin и пароли

User created.

SQL> grant create session to admin ; --  права на подкючение к БД

Grant succeeded.

SQL> grant dba to admin -- назначение пользователя администратором
  2  ;

Grant succeeded.

SQL> conn admin/6123 -- подключение от имени админа
Connected.
SQL> show user; 
USER is "ADMIN"
```

2. Создать пользователя dummy. Создать под пользователем несколько таблиц, наполнить их любым количеством данных. Дать пользователю соответствующие привилегии - описать для чего нужна каждая выданная привилегия. Показать содержимое таблиц соответствующими запросами.

<mark style="background: #ABF7F7A6;">Описание привилегий:</mark>
- **`grant create table to dummy;`** — права на создание таблиц.
- **`grant insert any table to dummy;`** — права на вставку данных в любые таблицы.
- **`alter user dummy quota unlimited on users;`** — права на неограниченное использование дискового пространства в **tablespace** `USERS`.
- **`grant resource to dummy;`** — права на создание объектов базы данных (таблиц, представлений, индексов и т.д.) в своей схеме.

```sql
SQL> create users dummy identified "hello_world";
SQL> grant create session to dummy; -- для подключения к бд 
SQL> grant create table to dummy;
SQL> grant insert any table to dummy;
SQL> alter user dummy quota unlimited on users;
SQL> grant resource to dummy -- в моем случае для использования автоинкрементации
SQL> conn dummy/hello_world -- подключение от имени dummy
-- создание таблицы jobs, employees, customers
SQL> create table jobs(id number generated as identity, name varchar(100), min_salary integer, max_salary integer ); 

Table created.

SQL> create table employees( id number generated as identity , name varchar(100));                                                                                                                                                                                          Table created.                                                                                                                        

SQL> create table customers (id number generated as identity, name varchar(100), company varchar (100));

Table created.
-- заполнение таблиц 
SQL> insert into customers(name , company) values ('Jack Vorobey', 'Jet Brains');

1 row created.

SQL> insert into customers(name , company) values ('Doctor Stange', 'Google');

1 row created.

SQL> insert into customers(name , company) values ('Mike Gamilton', 'Oracle');

1 row created.

SQL> select * from customers; -- содержимое сustomers

        ID
----------
NAME
--------------------------------------------------------------------------------
COMPANY
--------------------------------------------------------------------------------
         1
Jack Vorobey
Jet Brains

         2
Doctor Stange
Google

        ID
----------
NAME
--------------------------------------------------------------------------------
COMPANY
--------------------------------------------------------------------------------

         3
Mike Gamilton
Oracle

SQL> insert into employees(name) values ('Harry Potter');

1 row created.

SQL> insert into employees(name) values ('Munira Gulova');

1 row created.

SQL> insert into employees (name) values ( 'Sergey Palin');

1 row created.

SQL> select * from employees; -- содержимое employees

        ID
----------
NAME
--------------------------------------------------------------------------------
         1
Harry Potter

         2
Munira Gulova

         3
Sergey Palin

SQL> insert into jobs (name, min_salary, max_salary) values ( 'designer', 5000, 10000);

1 row created.

SQL> insert into jobs (name, min_salary, max_salary) values ( 'ml ingener', 5000, 19999);

1 row created.

SQL> insert into jobs (name, min_salary, max_salary) values ( 'data analyst', 4999, 19000);

1 row created.

SQL> select * from jobs; -- содержимое jobs

		ID
----------
NAME
--------------------------------------------------------------------------------
MIN_SALARY MAX_SALARY
---------- ----------

         3
ml ingener
      5000      19999

         4
data analyst

        ID
----------
NAME
--------------------------------------------------------------------------------
MIN_SALARY MAX_SALARY
---------- ----------
      4999      19000



```
3. Создайте пользователя reader, дайте ему права только на чтение созданных ранее таблиц пользователя dummy. При этом reader не должен иметь права создавать свои таблицы. Продемонстрируйте в отчете, как это работает.
``` sql
SQL> conn as sysdba -- подключение от имени админа sysdba
Enter user-name: 2024
Enter password:
Connected.
SQL> create user reader; -- создание пользователя

User created.

SQL> grant create session to reader; -- права на подключение к БД

Grant succeeded.

-- права на чтения таблиц
SQL> grant select on dummy.employees to reader; 

Grant succeeded.

SQL> grant select on dummy.jobs to reader;

Grant succeeded.

SQL> grant select on dummy.customers to reader;

Grant succeeded.

SQL> conn reader;
Enter password:
ERROR:
ORA-01017: invalid username/password; logon denied

Warning: You are no longer connected to ORACLE.

SQL> conn as sysdba
Enter user-name: 2024
Enter password:
Connected.
SQL> alter user reader identified by "I_read";

User altered.

SQL> conn reader/I_read;
Connected.

-- просмотр таблиц
SQL> select * from dummy.jobs;

        ID
----------
NAME
--------------------------------------------------------------------------------
MIN_SALARY MAX_SALARY
---------- ----------
         1
Jon Smit
      5000      10000

         2
designer
      5000      10000

        ID
----------
NAME
--------------------------------------------------------------------------------
MIN_SALARY MAX_SALARY
---------- ----------

         3
ml ingener
      5000      19999

         4
data analyst

        ID
----------
NAME
--------------------------------------------------------------------------------
MIN_SALARY MAX_SALARY
---------- ----------
      4999      19000


SQL> select * from dummy.customers;

        ID
----------
NAME
--------------------------------------------------------------------------------
COMPANY
--------------------------------------------------------------------------------
         1
Jack Vorobey
Jet Brains

         2
Doctor Stange
Google

        ID
----------
NAME
--------------------------------------------------------------------------------
COMPANY
--------------------------------------------------------------------------------

         3
Mike Gamilton
Oracle

         4
Mike Gamilton

        ID
----------
NAME
--------------------------------------------------------------------------------
COMPANY
--------------------------------------------------------------------------------
Oracle


```

3. Написать один или несколько sql-запросов, которые позволяют вытащить наиболее интересную и важную (на ваш взгляд) информацию о БД из динамических таблиц `v$database и v$instance`.
``` sql 
-- NAME - имя БД, DBID - уникальный идентификатор БД , CREATED - дата и время создания БД, OPEN_MODE - текущий режим , LOG_MODE - режим журнала , PROTECTION_MODE - режим защиты данных
SQL> SELECT name, dbid, created FROM v$database;

NAME            DBID CREATED
--------- ---------- ---------
MOON      2940491080 28-NOV-24

SQL> select name, dbid , created, open_mode, log_mode, protection_mode from v$database;

NAME            DBID CREATED   OPEN_MODE            LOG_MODE
--------- ---------- --------- -------------------- ------------
PROTECTION_MODE
--------------------
MOON      2940491080 28-NOV-24 READ WRITE           NOARCHIVELOG
MAXIMUM PERFORMANCE

-- INSTANCE_NAME - имя инстанции (экземпляра) , STATUS - текущее состояние инстанции , DATABASE_STATUS - состояние БД, HOST_NAME - имя хоста , VERSION - версия СУБД Oracle, STARTUP_TIME - время последнего запуска инстанции, ARCHIVER - режим архивирования журналов 
SQL> select instance_name , status, database_status, host_name, version, startup_time, archiver from v$instance;

INSTANCE_NAME    STATUS       DATABASE_STATUS
---------------- ------------ -----------------
HOST_NAME
----------------------------------------------------------------
VERSION           STARTUP_T ARCHIVE
----------------- --------- -------
moon             OPEN         ACTIVE
Linux.myguest.virtualbox.org
19.0.0.0.0        05-DEC-24 STOPPED

```


5. Почитать про alert-лог БД, найти его. Прописать переменную окружения, указывающую на этот файл.

коротко :
**alert-лог** — это специальный файл в базе данных, в котором записываются важные сообщения и ошибки, связанные с работой базы данных. Этот файл помогает администраторам базы данных отслеживать, что происходит в базе, выявлять и устранять проблемы.

Примеры сообщений в **alert-логе**:

- Старт и остановка базы данных.
- Ошибки при запуске или работе базы данных.
- Важные события, такие как изменения конфигурации, ошибки, сбои в работе процессов.

``` sql

[root@Linux ~]# su - oracle

[oracle@Linux rdbms]$ cd orcl
[oracle@Linux orcl]$ ls -a
.  ..  ORCL
[oracle@Linux orcl]$ ls -l
total 4
drwxr-xr-x. 16 oracle oinstall 4096 Nov 28 14:16 ORCL
[oracle@Linux orcl]$ cd ORCL
[oracle@Linux ORCL]$ ls -l
total 56
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 alert
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 cdump
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 hm
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 incident
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 incpkg
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 ir
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 lck
drwxr-xr-x. 8 oracle oinstall 4096 Nov 28 14:16 log
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 metadata
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 metadata_dgif
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 metadata_pv
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 stage
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:16 sweep
drwxr-xr-x. 2 oracle oinstall 4096 Nov 28 14:19 trace
[oracle@Linux ORCL]$ cd trace
[oracle@Linux trace]$ ls -l
total 48
-rw-r-----. 1 oracle oinstall  4278 Nov 28 14:19 alert_ORCL.log
-rw-r-----. 1 oracle oinstall 15181 Nov 28 14:16 ORCL_ora_17407.trc
-rw-r-----. 1 oracle oinstall  1822 Nov 28 14:16 ORCL_ora_17407.trm
-rw-r-----. 1 oracle oinstall 15181 Nov 28 14:19 ORCL_ora_19286.trc
-rw-r-----. 1 oracle oinstall  1827 Nov 28 14:19 ORCL_ora_19286.trm
[oracle@Linux trace]$ cat alert_ORCL.log
[oracle@Linux trace]$ pwd
/u01/app/oracle/diag/rdbms/orcl/ORCL/trace
[oracle@Linux trace]$ cd
[oracle@Linux ~]$ touch environment_variable.sh
[oracle@Linux ~]$ nano environment_variable.sh
[oracle@Linux ~]$ chmod +x environment_variable.sh
[oracle@Linux ~]$ source environment_variable.sh
[oracle@Linux ~]$ nano environment_variable.sh
[oracle@Linux ~]$ source environment_variable.sh
[oracle@Linux ~]$ echo $path_alertlog
/u01/app/oracle/diag/rdbms/orcl/ORCL/trace
```