-- Добавить внешние ключи

ALTER TABLE `lw5`.`booking` 
ADD CONSTRAINT `client_fk`
  FOREIGN KEY (`client_id`)
  REFERENCES `lw5`.`client` (`client_id`);
;
  
ALTER TABLE `lw5`.`room` 
ADD CONSTRAINT `hotel_id_fk`
  FOREIGN KEY (`hotel_id`)
  REFERENCES `lw5`.`hotel` (`hotel_id`),
ADD CONSTRAINT `room_category_id_fk`
  FOREIGN KEY (`room_category_id`)
  REFERENCES `lw5`.`room_category` (`room_category_id`);


ALTER TABLE `lw5`.`room_in_booking` 
ADD CONSTRAINT `booking_id_fk`
  FOREIGN KEY (`booking_id`)
  REFERENCES `lw5`.`booking` (`booking_id`),
ADD CONSTRAINT `room_id_fk`
  FOREIGN KEY (`room_id`)
  REFERENCES `lw5`.`room` (`room_id`)
;

-- Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.

SELECT
  c.*
FROM
  client c
  INNER JOIN booking b ON b.client_id = c.client_id
  INNER JOIN room_in_booking rb ON b.booking_id = rb.booking_id
  INNER JOIN room r ON r.room_id = rb.room_id
  INNER JOIN hotel h ON h.hotel_id = r.hotel_id
  INNER JOIN room_category rc ON rc.room_category_id = r.room_category_id
WHERE
  h.name = 'Космос'
  AND rc.name = 'Люкс'
  AND '2019-04-21' BETWEEN checkin_date AND checkout_date;
  
-- Дать список свободных номеров всех гостиниц на 22 апреля
SELECT 
  r.*
FROM
  room_in_booking rb
  INNER JOIN room r ON r.room_id = rb.room_id
WHERE
  '2019-04-22' NOT BETWEEN rb.checkin_date AND rb.checkout_date;
  
-- Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров
  
SELECT
  rc.name AS category, COUNT(rc.name) AS quantity
FROM
  room_in_booking rb
  INNER JOIN room r ON r.room_id = rb.room_id
  INNER JOIN hotel h ON h.hotel_id = r.hotel_id
  INNER JOIN room_category rc ON rc.room_category_id = r.room_category_id
WHERE
  h.name = 'Космос'
  AND '2019-03-23' BETWEEN checkin_date AND checkout_date
GROUP BY
  rc.name;

-- Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда.   
  
SELECT
  c.*, rb.checkout_date
FROM
  hotel h
  INNER JOIN room r ON h.hotel_id = r.hotel_id
  INNER JOIN room_category rc ON r.room_category_id = rc.room_category_id
  INNER JOIN room_in_booking rb ON (
    SELECT
      rb2.room_in_booking_id
    FROM 
      room_in_booking rb2
    WHERE
      rb.room_id = r.room_id
      AND rb2.checkout_date BETWEEN '2019-04-01' AND '2019-04-31'
    ORDER BY
      rb2.checkout_date DESC
    LIMIT 1
  )
  INNER JOIN booking b ON rb.booking_id = b.booking_id
  INNER JOIN client c ON b.client_id = c.client_id
WHERE
  h.name = 'Космос';
  
  -- Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.

SET SQL_SAFE_UPDATES=0;

UPDATE
  room_in_booking rb
  INNER JOIN room r ON r.room_id = rb.room_id
  INNER JOIN hotel h ON h.hotel_id = r.hotel_id
  INNER JOIN room_category rc ON rc.room_category_id = r.room_category_id
SET
  rb.checkout_date = DATE_ADD(rb.checkout_date, INTERVAL 2 DAY)
WHERE
  h.name = 'Космос'
  AND rc.name = 'Бизнес'
  AND rb.checkin_date = '2019-05-10';
  
/* Найти все "пересекающиеся" варианты проживания. Правильное состояние: не
может быть забронирован один номер на одну дату несколько раз, т.к. нельзя
заселиться нескольким клиентам в один номер. Записи в таблице
room_in_booking с id_room_in_booking = 5 и 2154 являются примером
неправильного состояния, которые необходимо найти. Результирующий кортеж
выборки должен содержать информацию о двух конфликтующих номерах. */
  
SELECT
  *
FROM
  room_in_booking rb
  INNER JOIN room_in_booking rb2 ON (
    rb.room_id = rb2.room_id
    AND rb2.checkin_date BETWEEN rb.checkin_date AND rb.checkout_date + INTERVAL '-1' DAY
    AND rb.room_in_booking_id <> rb2.room_in_booking_i
  );
  
-- Создать бронирование в транзакции.

BEGIN;

INSERT INTO client (name, phone)
VALUES ('Элефтеров Владилен Куприянович', '7(169)143-76-81');

INSERT INTO booking (id_client, booking_date)
VALUES ((SELECT id_client FROM client ORDER BY 1 DESC LIMIT 1), NOW());

INSERT INTO room_in_booking (id_booking, id_room, checkin_date, checkout_date)
VALUES ((SELECT booking.id_booking FROM booking ORDER BY 1 DESC LIMIT 1), 10, '2020-04-15', '2020-04-22');

COMMIT;
  
-- 9. Добавить необходимые индексы для всех таблиц.
CREATE INDEX booking_idx ON room_in_booking(booking_id);
CREATE INDEX client_inx ON booking(client_id);
CREATE INDEX hotel_idx ON room(hotel_id);
CREATE INDEX room_category_idx ON room(room_category_id);
CREATE INDEX room_idx ON room_in_booking(room_id);
CREATE INDEX phone_idx ON client(phone);
CREATE INDEX checkin_checkout_idx ON room_in_booking(checkin_date, checkout_date);