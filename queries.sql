-- Query 1: JOIN
SELECT
    bookings.booking_id,
    users.name AS customer_name,
    vehicles.name AS vehicle_name,
    bookings.start_date,
    bookings.end_date,
    bookings.status
FROM
    bookings
    INNER JOIN users ON bookings.user_id = users.user_id
    INNER JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id;



-- Query 2: EXISTS
SELECT
    vehicles.vehicle_id,
    vehicles.name,
    vehicles.type,
    vehicles.model,
    vehicles.registration_number,
    vehicles.rental_price,
    vehicles.status
FROM
    vehicles
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            bookings
        WHERE
            bookings.vehicle_id = vehicles.vehicle_id
    );


-- Query 3: WHERE
SELECT
    *
FROM
    vehicles
WHERE
    status = 'available'
    AND type = 'car';



-- Query 4: GROUP BY and HAVING
SELECT
    vehicles.name AS vehicle_name,
    COUNT(bookings.booking_id) AS total_bookings
FROM
    vehicles
    INNER JOIN bookings ON vehicles.vehicle_id = bookings.vehicle_id
GROUP BY
    vehicles.name
HAVING
    COUNT(bookings.booking_id) > 2;