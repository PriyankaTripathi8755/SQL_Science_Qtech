-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- SQL PROJECT : Science Qtech -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


/* TASK 1 =======================
Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources. */

create database employee;  # employee database created 
Use employee; # use database

-- all 3 csv file imported using import wizard
select * from employee.emp_record_table;  # checking Employee record table 
select * from employee.data_science_team;  # checking Data science team
select * from employee.proj_table;  # checking Proj table

/* TASK 2 ======================= 
Create an ER diagram for the given employee database. */

# ER Diagram :: refer to attached screenshot
          
/* TASK 3 ======================= 
Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department. */

select emp_id, first_name, last_name, gender, dept from emp_record_table;

/* TASK 4 ======================= 
Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four 
●	between two and four */

select emp_id, first_name, last_name, gender, dept, emp_rating
from emp_record_table where emp_rating<2; 

select emp_id, first_name, last_name, gender, dept, emp_rating
from emp_record_table where emp_rating>4;  

select emp_id, first_name, last_name, gender, dept, emp_rating 
from emp_record_table where emp_rating between 2 and 4;

/* TASK 5 ======================= 
Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME. */

select concat (first_name,' ',last_name) as 'name', dept from emp_record_table 
where dept = 'finance';   

/* TASK 6 ======================= 
Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President). */
 	
select manager_id as Employee_ID, count(manager_id) as Total_people_reporting
from employee.emp_record_table
group by MANAGER_ID having count(Manager_id)>0;
 
/* TASK 7 ======================= 
Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table. */

select emp_id, concat(first_name,' ',last_name) as emp_name, dept
from employee.emp_record_table where dept='Healthcare' 
union 
select emp_id, concat(first_name,' ',last_name) as emp_name, dept 
from employee.emp_record_table where dept='finance';

/* TASK 8 ======================= 
Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
Also include the respective employee rating along with the max emp rating for the department. */

select emp_id, first_name, last_name, role, dept, emp_rating, 
max(emp_rating) over (partition by dept) as Max_dept_rating 
from emp_record_table order by dept;

/* TASK 9 ======================= 
Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table. */

select emp_id, concat(first_name,' ',last_name) as emp_name, role, salary,
max(salary) over (partition by role) as Max_salary, 
min(salary) over (partition by role) as Min_salary 
from emp_record_table;

/* TASK 10 =======================
Write a query to assign ranks to each employee based on their experience. Take data from the employee record table. */

select emp_id, concat(first_name,' ',last_name) as emp_name, exp, 
rank() over (order by exp desc) as 'rank', 
dense_rank() over (order by exp desc) as 'dense_rank' 
from emp_record_table;     

/* TASK 11 ======================= 
Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table. */

create view EmpSalCountryView as select * from emp_record_table where salary>6000 ;
select * from EmpSalCountryView ;  # checking view
			
/* TASK 12 ======================= 
Write a nested query to find employees with experience of more than ten years. Take data from the employee record table. */

select emp_id, first_name, last_name, exp as exp_greater_tha_10 from emp_record_table 
where emp_id in (select emp_id from emp_record_table WHERE exp > 10) 
ORDER BY exp;

/* TASK 13 =======================
Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table. */

DELIMITER //   
create procedure Employee_3plus_exp()	     
begin
select * from emp_record_table where exp>3 order by exp desc;
end // 
DELIMITER ;

call Employee_3plus_exp();  # calling procedure

/* TASK 14 ======================= 
Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
The standard being:
	* For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
	* For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
	* For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
	* For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
	* For an employee with the experience of 12 to 16 years assign 'MANAGER'. */

delimiter //
CREATE FUNCTION check_role(exp int)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
	DECLARE chck VARCHAR(40);
    IF EXP <= 2 THEN
		SET chck = "JUNIOR DATA SCIENTIST";
	elseif exp > 2 AND exp <= 5 THEN
		SET chck = "ASSOCIATE DATA SCIENTIST";
	elseif exp > 5 AND exp <= 10 THEN
		SET chck = "SENIOR DATA SCIENTIST";
	elseif exp > 10 AND exp <= 12 THEN
		SET chck = "LEAD DATA SCIENTIST";
	elseif exp > 12 AND exp <= 16 THEN
		SET chck = "MANAGER";		
	end if;
    RETURN(chck);
END //
delimiter ;

select EMP_ID, FIRST_NAME, LAST_NAME, ROLE as assigned_role, check_role(exp) as Organisation_standard_role from data_science_team;
        
/* TASK 15 ======================= 
Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan. */ 

select * from emp_record_table where first_name = 'eric' ;  # before index --> click on "icon with a magnifying glass" next to execute icon on top, to check execution plan

create index name_index on emp_record_table(first_name(10));
select * from emp_record_table where first_name = 'eric';  # check again after index, cost and performance of query will be improved now

/* TASK 16 =======================
Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating). */

select emp_id, concat(first_name,' ',last_name) as emp_name, emp_rating as rating, salary, (salary*0.05)*emp_rating as Bonus from emp_record_table;

/* TASK 17 ======================= 
Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table. */

select emp_id, concat(first_name,' ',last_name) as emp_name, country, continent, salary as emp_salary, 
avg(salary) over(partition by country) country_avg_sal,
avg(salary) over(partition by continent) continent_avg_sal
from emp_record_table order by continent;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- END OF PROJECT -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
