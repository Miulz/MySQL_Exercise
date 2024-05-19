create database driving_schools;
use driving_schools;


create table cities (
id int primary key auto_increment,
name varchar(40) not null unique
);

create table cars (
id int primary key auto_increment,
brand varchar(20) not null,
model varchar(20) not null unique
);

create table instructors(
id int primary key auto_increment,
first_name varchar(40) not null,
last_name varchar(40) not null unique,
has_a_license_from date not null
);

create table driving_schools(
id int primary key auto_increment,
name varchar(40) not null unique,
night_time_driving boolean not null,
average_lesson_price decimal(10, 2),
car_id int not null,
city_id int not null,
foreign key(car_id) references cars(id),
foreign key(city_id) references cities(id)
);


create table students(
id int primary key auto_increment,
first_name varchar(40) not null,
last_name varchar(40) not null unique,
age int,
phone_number varchar(20) unique
);

create table instructors_driving_schools(
instructor_id int,
driving_school_id int not null,
foreign key(instructor_id) references instructors(id),
foreign key(driving_school_id) references driving_schools(id)
);

create table instructors_students(
instructor_id int not null,
student_id int not null,
foreign key(instructor_id) references instructors(id),
foreign key(student_id) references students(id)
);


--- Task 02 


insert into students (first_name, last_name, age, phone_number)
select lower(reverse(first_name)), lower(reverse(last_name)), age + substring(phone_number, 1, 1), concat('1+',phone_number)
from students
where age < 20
;

--- Task 03 

select * from cities;

update driving_schools ds
set average_lesson_price = average_lesson_price + 30
where city_id = 5 and night_time_driving = 1;


---  Task 04 

delete from driving_schools where night_time_driving = 0;


--- Task 05

select concat(first_name, " ", last_name) as full_name, age
from students
where locate('a', first_name) and age <=19
order by id asc;


--- Task 06

select * from driving_schools;
select * from cars;
select * from instructors_driving_schools;
select * from instructors;
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

select ds.id, ds.name, brand from (driving_schools ds, cars c)
join instructors_driving_schools i
on ds.id = i.driving_school_id
left join instructors ins
on i.instructor_id is null
group by ds.id
order by brand asc, ds.id
;   


--- Task 07

select * from instructors;
select * from instructors_students;
select * from instructors_driving_schools;
select  * from driving_schools;

select ins.first_name, ins.last_name, count(*) as students_count, c.name as city  from (instructors ins, cities c)
join instructors_students ist
on ins.id = ist.instructor_id
join instructors_driving_schools ids
on ist.instructor_id = ids.instructor_id
group by city
having count(*) > 1
order by students_count desc, ins.first_name asc
;






--- Task 08 


select * from driving_schools;
select * from cities;
select  * from instructors_driving_schools;

select cs.name, count(*) as instructor_count  from cities cs 
join driving_schools ds
on cs.id = ds.city_id
join instructors_driving_schools ids
on ds.id = ids.driving_school_id
group by cs.name
order by instructor_count desc
;


--- Task 09

select * from instructors;

select concat(first_name, " ", last_name) as full_name,
case
when has_a_license_from >= '1980-01-01' and has_a_license_from < '1990-01-01'  then 'Specialist'
when has_a_license_from >= '1990-01-01' and has_a_license_from < '2000-01-01' then 'Advanced'
when has_a_license_from >= '2000-01-01' and has_a_license_from < '2008-01-01' then 'Experienced'
when has_a_license_from >= '2008-01-01' and has_a_license_from < '2015-01-01' then 'Qualified'
when has_a_license_from >= '2015-01-01' and has_a_license_from < '2020-01-01' then 'Provisional'
when has_a_license_from >= '2020-01-01' then 'Trainee'
end as level
from instructors
order by has_a_license_from asc, first_name asc;





--- Task 10


delimiter $

create function udf_average_lesson_price_by_city (name VARCHAR(40))  returns decimal(10, 2)
deterministic
begin
declare result decimal(10, 2);
set result := (select avg(average_lesson_price) from driving_schools ds
join cities c
on ds.city_id = c.id 
where c.name = name
group by ds.city_id
 );
return result;
end$

delimiter ;

--- Task 11




delimiter $

create procedure udp_find_school_by_car (name varchar(20))
begin
update driving_schools ds
join cars cs
on ds.car_id = cs.id
set average_lesson_price = avg(average_lesson_price)
where cs.brand = name;
end //


delimiter ; 

select * from cars;
select * from driving_schools;
































