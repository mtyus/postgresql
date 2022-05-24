-- The list_employees_proc procedure uses a cursor to retrieve and display the data in the
-- employees table.

CREATE PROCEDURE human_resources.list_employees_proc()
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE
     
    emp_cur CURSOR FOR SELECT * FROM human_resources.employees ORDER BY employee_id;
    
    v_emp_rec human_resources.employees%ROWTYPE;
    
BEGIN

   OPEN emp_cur;
   
   LOOP

    FETCH emp_cur INTO v_emp_rec;
    
       EXIT WHEN NOT FOUND;
       
       RAISE NOTICE '%', rpad(to_char(v_emp_rec.employee_id,'999'),6,' ') ||
                         rpad(v_emp_rec.first_name,15,' ') ||
                         rpad(v_emp_rec.last_name,15,' ') ||
                         rpad(to_char(v_emp_rec.hire_date,'MM/DD/YYYY'),12,' ') ||
                         rpad(to_char(v_emp_rec.department_id,'999'),6,' ');
   
   END LOOP;
   
   CLOSE emp_cur;

END
$BODY$;

ALTER PROCEDURE human_resources.list_employees_proc()
    OWNER TO postgres;

-- EXECUTION RESULTS --

CALL human_resources.list_employees_proc();

NOTICE:     4  Suzanne        Farmer         09/18/2014   300  
NOTICE:     5  Leonard        Grant          12/05/2009   300  
NOTICE:    20  Elaine         Jefferson      03/02/2020   500  
NOTICE:    27  Raquel         Booth          10/24/2010   600  
NOTICE:    28  Eric           Jackson        06/30/2020   800  
NOTICE:    36  Chris          Preston        03/27/2020   400  
NOTICE:    44  Diane          Andrews        06/07/2017   500  
NOTICE:    58  Jessica        Chapman        04/10/2020   800  
NOTICE:    59  Michael        Bowman         09/03/2018   300  
NOTICE:    61  Mark           Moses          10/13/2017   700  
NOTICE:    67  Leslie         Doyle          12/24/2014   400  
NOTICE:    77  Allan          Carter         12/18/2010   700  
NOTICE:    84  Michael        Kirby          11/19/2018   400  
NOTICE:    96  Christopher    Soto           09/24/2019   500  
NOTICE:   103  Deborah        Lindsey        05/25/2013   200  
NOTICE:   111  Teason         Anderson       01/30/2018   800  
NOTICE:   112  Douglas        Howell         08/06/2009   100  
NOTICE:   114  Bryant         Vargas         08/21/2019   100  
NOTICE:   139  Edward         Hayes          03/11/2020   100  
NOTICE:   157  Al             Serrano        11/01/2019   100  
NOTICE:   168  John           Cameron        08/28/2017   600  
NOTICE:   190  Jessica        Wilson         01/21/2019   600  
NOTICE:   198  Hunyen         Curry          10/30/2009   200  
NOTICE:   205  Michael        Vasquez        06/06/2018   100  
NOTICE:   213  Brian          Morton         06/18/2019   700  
NOTICE:   214  Gary           Jennings       04/07/2020   500  
NOTICE:   222  Danielle       Atkinson       07/27/2018   200  
NOTICE:   234  Gary           Long           01/12/2019   500  
NOTICE:   251  Michael        Schmidt        07/28/2010   500  
NOTICE:   259  George         Horn           02/06/2020   400  
NOTICE:   275  Shannon        Gilbert        07/03/2011   800  
NOTICE:   287  Dennis         Freeman        08/20/2019   800  
NOTICE:   290  Robert         French         02/06/2013   100  
NOTICE:   303  Cynthia        Harper         09/20/2019   400  
NOTICE:   313  Ellen          Fox            01/20/2010   400  
NOTICE:   314  Keith          Brown          02/02/2021   800  
CALL

Query returned successfully in 24 msec.
