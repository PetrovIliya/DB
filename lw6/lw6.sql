-- 1. Добавить внешние ключи.

ALTER TABLE `lw6`.`dealer` 
ADD CONSTRAINT `company_fk`
  FOREIGN KEY (`company_id`)
  REFERENCES `lw6`.`company` (`company_id`);

ALTER TABLE `lw6`.`order` 
ADD CONSTRAINT `production_fk`
  FOREIGN KEY (`production_id`)
  REFERENCES `lw6`.`production` (`production_id`),
ADD CONSTRAINT `dealer_fk`
  FOREIGN KEY (`dealer_id`)
  REFERENCES `lw6`.`dealer` (`dealer_id`),
ADD CONSTRAINT `pharmacy_fk`
  FOREIGN KEY (`pharmacy_id`)
  REFERENCES `lw6`.`pharmacy` (`pharmacy_id`);

ALTER TABLE `lw6`.`production` 
ADD CONSTRAINT `production_company_fk`
  FOREIGN KEY (`company_id`)
  REFERENCES `lw6`.`company` (`company_id`),
ADD CONSTRAINT `medicine_fk`
  FOREIGN KEY (`medicine_id`)
  REFERENCES `lw6`.`medicine` (`medicine_id`);
  
-- Выдать информацию по всем заказам лекарства “Кордеон” компании “Аргус” с
-- указанием названий аптек, дат, объема заказов.

SELECT
  ph.name pharmacy,
  o.date,
  o.quantity,
  p.price,
  o.quantity * p.price AS total
FROM
  `order` o
  INNER JOIN production p ON o.production_id = p.production_id
  INNER JOIN company c ON p.company_id = c.company_id
  INNER JOIN medicine m ON p.medicine_id = m.medicine_id
  INNER JOIN pharmacy ph ON o.pharmacy_id = ph.pharmacy_id
WHERE
  c.name = 'Аргус'
  AND m.name = 'Кордерон';
  
-- Дать список лекарств компании “Фарма”, на которые не были сделаны заказы
-- до 25 января.
 
SELECT
  m.name medicine,
  p.price
FROM
  company c
  INNER JOIN production p ON c.company_id = p.company_id
  INNER JOIN medicine m ON p.medicine_id = m.medicine_id
WHERE
   c.name = 'Фарма'
   AND p.production_id NOT IN (
    SELECT
      o.production_id
    FROM
      `order` o
    WHERE
      o.date < '2019-01-25'
  );

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
-- оформила не менее 120 заказов

SELECT
  c.name company,
  MIN(p.rating) min_prod_rating,
  MAX(p.rating) max_prod_rating
FROM
  `order` o
  INNER JOIN production p ON o.production_id = p.production_id
  INNER JOIN company c ON p.company_id = c.company_id
GROUP BY
   c.company_id, c.name
HAVING
  COUNT(DISTINCT o.order_id) >= 120;


-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
-- Если у дилера нет заказов, в названии аптеки проставить NULL

SELECT
  d.name dealer_name,
  d.phone dealer_phone,
  r.pharmacy_name
FROM
  dealer d
  INNER JOIN company c ON d.company_id = c.company_id
  LEFT JOIN (
    SELECT
      o.dealer_id,
      ph.name pharmacy_name
    FROM
      `order` o
      INNER JOIN pharmacy ph ON o.pharmacy_id = ph.pharmacy_id
  ) r ON d.dealer_id = r.dealer_id
WHERE
  c.name = 'AstraZeneca';
  
-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
-- длительность лечения не более 7 дней

SET SQL_SAFE_UPDATES=0;

UPDATE
  production p
  INNER JOIN medicine m ON p.medicine_id = m.medicine_id
SET 
  price = price * 0.8
 WHERE
  p.price > 3000
  AND m.cure_duration <= 7;
  
-- 7. Добавить необходимые индексы.

CREATE INDEX production_idx ON `order`(production_id);
CREATE INDEX dealer_idx ON `order`(dealer_id);
CREATE INDEX pharmacy_idx ON `order`(pharmacy_id);
CREATE INDEX date_idx ON `order`(date);
CREATE INDEX date_idx ON `order`(date);
CREATE INDEX company_idx ON dealer(company_id);
CREATE INDEX company_prod_idx ON production(company_id);
CREATE INDEX medicine_idx ON production(medicine_id);
CREATE INDEX price_idx ON production(price);
CREATE INDEX cure_duration_idx ON medicine(cure_duration);
