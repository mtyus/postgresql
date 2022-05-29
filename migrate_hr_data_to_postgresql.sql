-- I used the package extract_hr_data_pkg, in my PL/SQL repository, to extract HR data from my Oracle Live SQL account. In addition, I'm
-- treating this as a data migration project and I'm migrating the HR extract data to PostgreSQL. Listed below are (1) the constraints
-- for the HR source tables in Oracle, (2) the PostgreSQL table DDL I created using pgAdmin and (3) the data extract records that I loaded into PostgreSQL.

*** REGIONS
-- Oracle constraints for region table.
TABLE_NAME  CONSTRAINT_NAME CONSTRAINT_TYPE SEARCH_CONDITION        DELETE_RULE
REGIONS     REGION_ID_NN    CHECK           "REGION_ID" IS NOT NULL - 
REGIONS     REG_ID_PK       PRIMARY KEY     -                       - 

-- PostgreSQL regions table DDL with constraints above applied.
-- DROP TABLE IF EXISTS human_resources.regions;
CREATE TABLE IF NOT EXISTS human_resources.regions
(
    region_id numeric(22,0) NOT NULL,
    region_name character varying(25) COLLATE pg_catalog."default",
    CONSTRAINT reg_id_pk PRIMARY KEY (region_id)
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS human_resources.regions
    OWNER to postgres;

-- PostgreSQL regions table contents.
region_id   region_name
1           Europe
2           Americas
3           Asia
4           Middle East and Africa

*** COUNTRIES
-- Oracle constraints for countries table.
TABLE_NAME  CONSTRAINT_NAME CONSTRAINT_TYPE         SEARCH_CONDITION            DELETE_RULE
COUNTRIES   COUNTR_REG_FK   REFERENTIAL INTEGRITY   -                           NO ACTION
COUNTRIES   COUNTRY_ID_NN   CHECK                   "COUNTRY_ID" IS NOT NULL    - 
COUNTRIES   COUNTRY_C_ID_PK PRIMARY KEY             -                           - 

-- PostgreSQL countries table DDL with constraints above applied.
-- DROP TABLE IF EXISTS human_resources.countries;
CREATE TABLE IF NOT EXISTS human_resources.countries
(
    country_id character(2) COLLATE pg_catalog."default" NOT NULL,
    country_name character varying(40) COLLATE pg_catalog."default",
    region_id numeric(22,0),
    CONSTRAINT country_c_id_pk PRIMARY KEY (country_id),
    CONSTRAINT countr_reg_fk FOREIGN KEY (region_id)
        REFERENCES human_resources.regions (region_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS human_resources.countries
    OWNER to postgres;

-- PostgreSQL countries table contents.
country_id  country_name                region_id
AR          Argentina                   2
AU          Australia                   3
BE          Belgium                     1
BR          Brazil                      2
CA          Canada                      2
CH          Switzerland                 1
CN          China                       3
DE          Germany                     1
DK          Denmark                     1
EG          Egypt                       4
FR          France                      1
IL          Israel                      4
IN          India                       3
IT          Italy                       1
JP          Japan                       3
KW          Kuwait                      4
ML          Malaysia                    3
MX          Mexico                      2
NG          Nigeria                     4
NL          Netherlands                 1
SG          Singapore                   3
UK          United Kingdom              1
US          United States of America    2
ZM          Zambia                      4
ZW          Zimbabwe                    4

*** LOCATIONS
-- Oracle constraints for locations table.
TABLE_NAME  CONSTRAINT_NAME CONSTRAINT_TYPE         SEARCH_CONDITION    DELETE_RULE
LOCATIONS   LOC_ID_PK       PRIMARY KEY             -                   - 
LOCATIONS   LOC_C_ID_FK     REFERENTIAL INTEGRITY   -                   NO ACTION
LOCATIONS   LOC_CITY_NN     CHECK                   "CITY" IS NOT NULL  -

-- PostgreSQL locations table DDL with constraints above applied.
-- DROP TABLE IF EXISTS human_resources.locations;
CREATE TABLE IF NOT EXISTS human_resources.locations
(
    location_id numeric(22,0) NOT NULL,
    street_address character varying(40) COLLATE pg_catalog."default",
    postal_code character varying(12) COLLATE pg_catalog."default",
    city character varying(30) COLLATE pg_catalog."default" NOT NULL,
    state_province character varying(25) COLLATE pg_catalog."default",
    country_id character(2) COLLATE pg_catalog."default",
    CONSTRAINT loc_id_pk PRIMARY KEY (location_id),
    CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id)
        REFERENCES human_resources.countries (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS human_resources.locations
    OWNER to postgres;

-- PostgreSQL locations table contents.
location_id street_address                              postal_code city                state_province      country_id
1000        1297 Via Cola di Rie                        989         Roma                -                   IT
1100        93091 Calle della Testa                     10934       Venice              -                   IT
1200        2017 Shinjuku-ku                            1689        Tokyo               Tokyo Prefecture    JP
1300        9450 Kamiya-cho                             6823        Hiroshima           -                   JP
1400        2014 Jabberwocky Rd                         26192       Southlake           Texas               US
1500        2011 Interiors Blvd                         99236       South San Francisco California          US
1600        2007 Zagora St                              50090       South Brunswick     New Jersey          US
1700        2004 Charade Rd                             98199       Seattle             Washington          US
1800        147 Spadina Ave                             M5V 2L7     Toronto             Ontario             CA
1900        6092 Boxwood St                             YSW 9T2     Whitehorse          Yukon               CA
2000        40-5-12 Laogianggen                         190518      Beijing             -                   CN
2100        1298 Vileparle (E)                          490231      Bombay              Maharashtra         IN
2200        12-98 Victoria Street                       2901        Sydney              New South Wales     AU
2300        198 Clementi North                          540198      Singapore           -                   SG
2400        8204 Arthur St                              -           London              -                   UK
2500        Magdalen Centre, The Oxford Science Park    OX9 9ZB     Oxford              Oxford              UK
2600        9702 Chester Road                           9629850293  Stretford           Manchester          UK
2700        Schwanthalerstr. 7031                       80925       Munich              Bavaria             DE
2800        Rua Frei Caneca 1360                        01307-002   Sao Paulo           Sao Paulo           BR
2900        20 Rue des Corps-Saints                     1730        Geneva              Geneve              CH
3000        Murtenstrasse 921                           3095        Bern                BE                  CH
3100        Pieter Breughelstraat 837                   3029SK      Utrecht             Utrecht             NL
3200        Mariano Escobedo 9991                       11932       Mexico City         Distrito Federal,   MX  

*** DEPARTMENTS
-- Oracle constraints for departments table.
TABLE_NAME  CONSTRAINT_NAME CONSTRAINT_TYPE         SEARCH_CONDITION                DELETE_RULE
DEPARTMENTS DEPT_ID_PK      PRIMARY KEY             -                               - 
DEPARTMENTS DEPT_LOC_FK     REFERENTIAL INTEGRITY   -                               NO ACTION
DEPARTMENTS DEPT_MGR_FK     REFERENTIAL INTEGRITY   -                               NO ACTION
DEPARTMENTS DEPT_NAME_NN    CHECK                   "DEPARTMENT_NAME" IS NOT NULL   - 

-- PostgreSQL departments table DDL with constraints above applied.
-- DROP TABLE IF EXISTS human_resources.departments;
CREATE TABLE IF NOT EXISTS human_resources.departments
(
    department_id numeric(22,0) NOT NULL,
    department_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    manager_id numeric(22,0),
    location_id numeric(22,0),
    CONSTRAINT dept_id_pk PRIMARY KEY (department_id),
    CONSTRAINT dept_loc_fk FOREIGN KEY (location_id)
        REFERENCES human_resources.locations (location_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id)
        REFERENCES human_resources.employees (employee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS human_resources.departments
    OWNER to postgres;

-- PostgreSQL departments table contents.
department_id   department_name         manager_id  location_id
10              Administration          200         1700
20              Marketing               201         1800
30              Purchasing              114         1700
40              Human Resources         203         2400
50              Shipping                121         1500
60              IT                      103         1400
70              Public Relations        204         2700
80              Sales                   145         2500
90              Executive               100         1700
100             Finance                 108         1700
110             Accounting              205         1700
120             Treasury                            1700
130             Corporate Tax                       1700
140             Control And Credit                  1700
150             Shareholder Services                1700
160             Benefits                            1700
170             Manufacturing                       1700
180             Construction                        1700
190             Contracting                         1700
200             Operations                          1700
210             IT Support                          1700
220             NOC                                 1700
230             IT Helpdesk                         1700
240             Government Sales                    1700
250             Retail Sales                        1700
260             Recruiting                          1700
270             Payroll                             1700

*** JOBS
-- Oracle constraints for jobs table.
TABLE_NAME  CONSTRAINT_NAME CONSTRAINT_TYPE SEARCH_CONDITION        DELETE_RULE
JOBS        JOB_ID_PK       PRIMARY KEY     -                       - 
JOBS        JOB_TITLE_NN    CHECK           "JOB_TITLE" IS NOT NULL - 

-- PostgreSQL jobs table DDL with constraints above applied.
-- DROP TABLE IF EXISTS human_resources.jobs;
CREATE TABLE IF NOT EXISTS human_resources.jobs
(
    job_id character varying(10) COLLATE pg_catalog."default" NOT NULL,
    job_title character varying(35) COLLATE pg_catalog."default" NOT NULL,
    min_salary numeric(22,0),
    max_salary numeric(22,0),
    CONSTRAINT job_id_pk PRIMARY KEY (job_id)
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS human_resources.jobs
    OWNER to postgres;

-- PostgreSQL jobs table contents.
job_id          job_title                       min_salary  max_salary
AD_PRES         President                       20080       40000
AD_VP           Administration Vice President   15000       30000
AD_ASST         Administration Assistant        3000        6000
FI_MGR          Finance Manager                 8200        16000
FI_ACCOUNT      Accountant                      4200        9000
AC_MGR          Accounting Manager              8200        16000
AC_ACCOUNT      Public Accountant               4200        9000
SA_MAN          Sales Manager                   10000       20080
SA_REP          Sales Representative            6000        12008
PU_MAN          Purchasing Manager              8000        15000
PU_CLERK        Purchasing Clerk                2500        5500
ST_MAN          Stock Manager                   5500        8500
ST_CLERK        Stock Clerk                     2008        5000
SH_CLERK        Shipping Clerk                  2500        5500
IT_PROG         Programmer                      4000        10000
MK_MAN          Marketing Manager               9000        15000
MK_REP          Marketing Representative        4000        9000
HR_REP          Human Resources Representative  4000        9000
PR_REP          Public Relations Representative 4500        10500

*** JOB_HISTORY
-- Oracle constraints for job_history table.
TABLE_NAME  CONSTRAINT_NAME         CONSTRAINT_TYPE         SEARCH_CONDITION            DELETE_RULE
JOB_HISTORY JHIST_EMP_ID_ST_DATE_PK PRIMARY KEY             -                           - 
JOB_HISTORY JHIST_DATE_INTERVAL     CHECK                   end_date > start_date       - 
JOB_HISTORY JHIST_JOB_FK            REFERENTIAL INTEGRITY   -                           NO ACTION
JOB_HISTORY JHIST_DEPT_FK           REFERENTIAL INTEGRITY   -                           NO ACTION
JOB_HISTORY JHIST_EMP_FK            REFERENTIAL INTEGRITY   -                           NO ACTION
JOB_HISTORY JHIST_EMPLOYEE_NN       CHECK                   "EMPLOYEE_ID" IS NOT NULL   - 
JOB_HISTORY JHIST_START_DATE_NN     CHECK                   "START_DATE" IS NOT NULL    - 
JOB_HISTORY JHIST_END_DATE_NN       CHECK                   "END_DATE" IS NOT NULL      - 
JOB_HISTORY JHIST_JOB_NN            CHECK                   "JOB_ID" IS NOT NULL        - 

-- PostgreSQL job history table DDL with constraints above applied.
-- DROP TABLE IF EXISTS human_resources.job_history;
CREATE TABLE IF NOT EXISTS human_resources.job_history
(
    employee_id numeric(22,0) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    job_id character varying(10) COLLATE pg_catalog."default" NOT NULL,
    department_id numeric(22,0),
    CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date),
    CONSTRAINT jhist_dept_fk FOREIGN KEY (department_id)
        REFERENCES human_resources.departments (department_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id)
        REFERENCES human_resources.employees (employee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT jhist_job_fk FOREIGN KEY (job_id)
        REFERENCES human_resources.jobs (job_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT jhist_date_interval CHECK (end_date > start_date)
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS human_resources.job_history
    OWNER to postgres;

-- PostgreSQL job history table contents.
employee_id start_date  end_date    job_id      department_id
102         1/13/01     7/24/06     IT_PROG     60
101         9/21/97     10/27/01    AC_ACCOUNT  110
101         10/28/01    3/15/05     AC_MGR      110
201         2/17/04     12/19/07    MK_REP      20
114         3/24/06     12/31/07    ST_CLERK    50
122         1/1/07      12/31/07    ST_CLERK    50
200         9/17/95     6/17/01     AD_ASST     90
176         3/24/06     12/31/06    SA_REP      80
176         1/1/07      12/31/07    SA_MAN      80
200         7/1/02      12/31/06    AC_ACCOUNT  90
120         7/18/04     3/16/19     ST_MAN      50

*** EMPLOYEES
-- Oracle constraints for employees table.
TABLE_NAME  CONSTRAINT_NAME     CONSTRAINT_TYPE         SEARCH_CONDITION            DELETE_RULE
EMPLOYEES   EMP_EMP_ID_PK       PRIMARY KEY             -                           - 
EMPLOYEES   EMP_SALARY_MIN      CHECK                   salary > 0                  - 
EMPLOYEES   EMP_EMAIL_UK        UNIQUE KEY              -                           - 
EMPLOYEES   EMP_MANAGER_FK      REFERENTIAL INTEGRITY   -                           NO ACTION
EMPLOYEES   EMP_DEPT_FK         REFERENTIAL INTEGRITY   -                           NO ACTION
EMPLOYEES   EMP_JOB_FK          REFERENTIAL INTEGRITY   -                           NO ACTION
EMPLOYEES   EMP_LAST_NAME_NN    CHECK                   "LAST_NAME" IS NOT NULL     - 
EMPLOYEES   EMP_EMAIL_NN        CHECK                   "EMAIL" IS NOT NULL         - 
EMPLOYEES   EMP_HIRE_DATE_NN    CHECK                   "HIRE_DATE" IS NOT NULL     - 
EMPLOYEES   EMP_JOB_NN          CHECK                   "JOB_ID" IS NOT NULL        - 

-- PostgreSQL employees table DDL with constraints above applied.
-- DROP TABLE IF EXISTS human_resources.employees;
CREATE TABLE IF NOT EXISTS human_resources.employees
(
    employee_id numeric(22,0) NOT NULL,
    first_name character varying(20) COLLATE pg_catalog."default",
    last_name character varying(25) COLLATE pg_catalog."default" NOT NULL,
    email character varying(25) COLLATE pg_catalog."default" NOT NULL,
    phone_number character varying(20) COLLATE pg_catalog."default",
    hire_date date NOT NULL,
    job_id character varying(10) COLLATE pg_catalog."default" NOT NULL,
    salary numeric(22,2),
    commission_pct numeric(22,2),
    manager_id numeric(22,0),
    department_id numeric(22,0),
    CONSTRAINT emp_id_pk PRIMARY KEY (employee_id),
    CONSTRAINT emp_email_uk UNIQUE (email),
    CONSTRAINT emp_dept_fk FOREIGN KEY (department_id)
        REFERENCES human_resources.departments (department_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT emp_job_fk FOREIGN KEY (job_id)
        REFERENCES human_resources.jobs (job_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id)
        REFERENCES human_resources.employees (employee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT emp_salary_min CHECK (salary > 0::numeric)
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS human_resources.employees
    OWNER to postgres;

-- PostgreSQL employees table contents.
employee_id first_name      last_name   email       phone_number        hire_date   job_id      salary  commission_pct  manager_id  department_id
100         Steven          King        SKING       515.123.4567        6/17/03     AD_PRES     24000                               90
101         Neena           Kochhar     NKOCHHAR    515.123.4568        9/21/05     AD_VP       17000                   100         90
102         Lex             De Haan     LDEHAAN     515.123.4569        1/13/01     AD_VP       17000                   100         90
103         Alexander       Hunold      AHUNOLD     590.423.4567        1/3/06      IT_PROG     9000                    102         60
104         Bruce           Ernst       BERNST      590.423.4568        5/21/07     IT_PROG     6000                    103         60
105         David           Austin      DAUSTIN     590.423.4569        6/25/05     IT_PROG     4800                    103         60
106         Valli           Pataballa   VPATABAL    590.423.4560        2/5/06      IT_PROG     4800                    103         60
107         Diana           Lorentz     DLORENTZ    590.423.5567        2/7/07      IT_PROG     4200                    103         60
108         Nancy           Greenberg   NGREENBE    515.124.4569        8/17/02     FI_MGR      12008                   101         100
109         Daniel          Faviet      DFAVIET     515.124.4169        8/16/02     FI_ACCOUNT  9000                    108         100
110         John            Chen        JCHEN       515.124.4269        9/28/05     FI_ACCOUNT  8200                    108         100
111         Ismael          Sciarra     ISCIARRA    515.124.4369        9/30/05     FI_ACCOUNT  7700                    108         100
112         Jose Manuel     Urman       JMURMAN     515.124.4469        3/7/06      FI_ACCOUNT  7800                    108         100
113         Luis            Popp        LPOPP       515.124.4567        12/7/07     FI_ACCOUNT  6900                    108         100
114         Den             Raphaely    DRAPHEAL    515.127.4561        12/7/02     PU_MAN      11000                   100         30
115         Alexander       Khoo        AKHOO       515.127.4562        5/18/03     PU_CLERK    3100                    114         30
116         Shelli          Baida       SBAIDA      515.127.4563        12/24/05    PU_CLERK    2900                    114         30
117         Sigal           Tobias      STOBIAS     515.127.4564        7/24/05     PU_CLERK    2800                    114         30
118         Guy             Himuro      GHIMURO     515.127.4565        11/15/06    PU_CLERK    2600                    114         30
119         Karen           Colmenares  KCOLMENA    515.127.4566        8/10/07     PU_CLERK    2500                    114         30
120         Matthew         Weiss       MWEISS      650.123.1234        7/18/04     ST_MAN      8000                    100         50
121         Adam            Fripp       AFRIPP      650.123.2234        4/10/05     ST_MAN      8200                    100         50
122         Payam           Kaufling    PKAUFLIN    650.123.3234        5/1/03      ST_MAN      7900                    100         50
123         Shanta          Vollman     SVOLLMAN    650.123.4234        10/10/05    ST_MAN      6500                    100         50
124         Kevin           Mourgos     KMOURGOS    650.123.5234        11/16/07    ST_MAN      5800                    100         50
125         Julia           Nayer       JNAYER      650.124.1214        7/16/05     ST_CLERK    3200                    120         50
126         Irene           Mikkilineni IMIKKILI    650.124.1224        9/28/06     ST_CLERK    2700                    120         50
127         James           Landry      JLANDRY     650.124.1334        1/14/07     ST_CLERK    2400                    120         50
128         Steven          Markle      SMARKLE     650.124.1434        3/8/08      ST_CLERK    2200                    120         50
129         Laura           Bissot      LBISSOT     650.124.5234        8/20/05     ST_CLERK    3300                    121         50
130         Mozhe           Atkinson    MATKINSO    650.124.6234        10/30/05    ST_CLERK    2800                    121         50
131         James           Marlow      JAMRLOW     650.124.7234        2/16/05     ST_CLERK    2500                    121         50
132         TJ              Olson       TJOLSON     650.124.8234        4/10/07     ST_CLERK    2100                    121         50
133         Jason           Mallin      JMALLIN     650.127.1934        6/14/04     ST_CLERK    3300                    122         50
134         Michael         Rogers      MROGERS     650.127.1834        8/26/06     ST_CLERK    2900                    122         50
135         Ki              Gee         KGEE        650.127.1734        12/12/07    ST_CLERK    2400                    122         50
136         Hazel           Philtanker  HPHILTAN    650.127.1634        2/6/08      ST_CLERK    2200                    122         50
137         Renske          Ladwig      RLADWIG     650.121.1234        7/14/03     ST_CLERK    3600                    123         50
138         Stephen         Stiles      SSTILES     650.121.2034        10/26/05    ST_CLERK    3200                    123         50
139         John            Seo         JSEO        650.121.2019        2/12/06     ST_CLERK    2700                    123         50
140         Joshua          Patel       JPATEL      650.121.1834        4/6/06      ST_CLERK    2500                    123         50
141         Trenna          Rajs        TRAJS       650.121.8009        10/17/03    ST_CLERK    3500                    124         50
142         Curtis          Davies      CDAVIES     650.121.2994        1/29/05     ST_CLERK    3100                    124         50
143         Randall         Matos       RMATOS      650.121.2874        3/15/06     ST_CLERK    2600                    124         50
144         Peter           Vargas      PVARGAS     650.121.2004        7/9/06      ST_CLERK    2500                    124         50
145         John            Russell     JRUSSEL     011.44.1344.429268  10/1/04     SA_MAN      14000   0.4             100         80
146         Karen           Partners    KPARTNER    011.44.1344.467268  1/5/05      SA_MAN      13500   0.3             100         80
147         Alberto         Errazuriz   AERRAZUR    011.44.1344.429278  3/10/05     SA_MAN      12000   0.3             100         80
148         Gerald          Cambrault   GCAMBRAU    011.44.1344.619268  10/15/07    SA_MAN      11000   0.3             100         80
149         Eleni           Zlotkey     EZLOTKEY    011.44.1344.429018  1/29/08     SA_MAN      10500   0.2             100         80                  
