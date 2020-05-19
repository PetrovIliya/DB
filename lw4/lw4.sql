-- 1)
INSERT INTO
	computer
VALUES
	(1, 'ASUS Aaspire 5', 2, 1321254589, 50, 10, NULL);
  
INSERT INTO 
	manufacturer_company(name, adress, reputation)
VALUES
	('Asus', 'some addres', 69);

INSERT INTO
	equipment(name, type, manufacturer_company_id)
SELECT
	'super hight', 2, mc.manufacturer_company_id
FROM 
	manufacturer_company mc
WHERE 
	name = 'Asus';
 
 -- 2)
DELETE FROM computer;

DELETE FROM 
	computer
WHERE 
	computer_id = 1;
 
TRUNCATE TABLE computer;

-- 3)
UPDATE 
	component
SET 
	name = 'name',
    price = 123,
    type = 2,
    weight = 800;
    
UPDATE 
	component c
SET
	c.name = 'test2'
WHERE
	c.component_id = 1;
    
    
UPDATE 
	component c
SET
	c.name = 'test2',
    type = 2
WHERE
	c.component_id = 1;

-- 4)
SELECT 
	type, name
FROM
	component;
    
SELECT 
	*
FROM
	component;
    
SELECT 
	*
FROM
	component
WHERE 
	component_id = 1;
    
-- 5)
SELECT 
	*
FROM
	computer
ORDER BY 
	computer_id
LIMIT
	1;
    
SELECT 
	*
FROM
	computer
ORDER BY computer_id DESC;

SELECT 
	*
FROM
	computer
ORDER BY
	computer_id, name
LIMIT 
	1;

SELECT 
	*
FROM
	computer
ORDER BY
	1;
    
-- 6)

SELECT 
	*
FROM
	computer
WHERE 
	manufacture_date < '2020-01-01';

SELECT
	YEAR(manufacture_date)
FROM
	computer;
    
-- 7

-- максимальная дата
SELECT 
	MAX(manufacture_date)
FROM
	computer
GROUP BY 
	manufacture_date;
 
 
 -- минимальная дата
SELECT 
	MIN(manufacture_date)
FROM
	computer
GROUP BY 
	manufacture_date;
 
-- средняя цена компонентов в комплектации
SELECT
	ec.equipment_id, AVG(c.price)
FROM
	equipment e
    INNER JOIN equipment_component ec USING(equipment_id)
    INNER JOIN component c USING(component_id)
GROUP BY
	ec.equipment_id;

-- общая цена каждоой комплектации
SELECT
	ec.component_id, SUM(c.price)
FROM
	equipment e
    INNER JOIN equipment_component ec USING(equipment_id)
    INNER JOIN component c USING(component_id)
GROUP BY
	ec.equipment_id;
    
-- количество поставок в каждой дате
SELECT
	manufacture_date, COUNT(*)
FROM
	computer
GROUP BY
	manufacture_date;

-- 8
-- комплекации у которых цена выше 10

SELECT 
	price
FROM
	(
		SELECT 
			eq.equipment_id, c.price
		FROM
			equipment_component eq
			INNER JOIN component c USING(component_id)
		GROUP BY 
			c.price
		HAVING
			SUM(c.price) > 100
    ) AS price;
    
-- те даты в которые было больше 2ух поставок
SELECT 
	manufacture_date
FROM
	computer
GROUP BY 
	manufacture_date
HAVING
	COUNT(manufacture_date) > 2;
    
-- комплектации у которых среднияя цена больше 30
SELECT 
	c.*
FROM
	equipment_component eq
    INNER JOIN component c USING(component_id)
GROUP BY 
	c.price
HAVING
	AVG(c.price) > 20;
    
-- 9


SELECT 
	*
FROM 
	computer c
    LEFT JOIN equipment e ON e.equipment_Id = c.equpment_id
    LEFT JOIN equipment_component eq ON eq.equipment_Id = e.equipment_Id
WHERE
	eq.component_id = 1;
    
SELECT 
	*
FROM
	equipment e
    RIGHT JOIN computer c ON c.equpment_id = e.equipment_Id
ORDER BY 
	e.equipment_Id
LIMIT
	1;
    
SELECT 
	*
FROM 
	computer c
    LEFT JOIN equipment e ON e.equipment_Id = c.equpment_id
    LEFT JOIN equipment_component eq ON eq.equipment_Id = e.equipment_Id
    LEFT JOIN component ct ON ct.component_id = eq.component_id
WHERE
	eq.component_id = 1
    AND c.manufacture_date > '2019-01-01'
    AND ct.price < 100
    AND eq.equipment_Id > 10;
    

SELECT 
	*
FROM 
	computer c
    JOIN equipment_component;
    
-- 10

SELECT 
	*
FROM 
	computer c
    INNER JOIN equipment eq ON equipment_Id = c.equpment_id
    INNER JOIN equipment_component ec ON ec.equipment_id = eq.equipment_id
    INNER JOIN component ct ON ct.component_id = ec.component_id
WHERE
	c.component_id IN (
		SELECT 
			ct2.component_id
		FROM
			component ct2
		WHERE
			price < 100
    );
    
SELECT 
	c.name, c.serial_number
FROM
	(
		SELECT
			c2.name, c2.serial_number
		FROM
			computer c2
	) AS c;
