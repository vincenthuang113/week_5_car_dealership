
-- CREATE TABLE--
CREATE TABLE "mechanic" (
  "mechanic_staff_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  PRIMARY KEY ("mechanic_staff_id")
);

CREATE TABLE "customer" (
  "customer_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  "billing_info" VARCHAR(100),
  PRIMARY KEY ("customer_id")
);

CREATE TABLE "car" (
  "serial_number" SERIAL,
  "make" VARCHAR(100),
  "model" VARCHAR(10),
  "car_price" NUMERIC(10,2),
  PRIMARY KEY ("serial_number")
);

CREATE TABLE "salesperson" (
  "sales_staff_id" SERIAL,
  "first_ name" VARCHAR(100),
  "last_name" VARCHAR(100),
  PRIMARY KEY ("sales_staff_id")
);

CREATE TABLE "part" (
  "part_number" SERIAL,
  "type_of_part" VARCHAR,
  "part_price" NUMERIC(6,2),
  PRIMARY KEY ("part_number")
);

CREATE TABLE "invoice" ( ---
  "invoice_id" SERIAL,
  "invoice_date" DATE DEFAULT CURRENT_DATE,
  "sales_staff_id" INTEGER,
  "customer_id" INTEGER,
  "serial_number" INTEGER,
  PRIMARY KEY ("invoice_id"),
  CONSTRAINT "FK_invoice.customer_id"
    FOREIGN KEY ("customer_id")
      REFERENCES "customer"("customer_id"),
  CONSTRAINT "FK_invoice.sales_staff_id"
    FOREIGN KEY ("sales_staff_id")
      REFERENCES "salesperson"("sales_staff_id"),
   CONSTRAINT "FK_invoice.serial_number"
    FOREIGN KEY ("serial_number")
      REFERENCES "car"("serial_number")
);

CREATE TABLE "service_ticket" (
  "service_ticket" SERIAL,
  "maintenance" VARCHAR(100),
  "total_price" NUMERIC(8,2),
  "service_ticket_date" DATE DEFAULT CURRENT_DATE,
  "serial_number" INTEGER,
  "customer_id" INTEGER,
  "part_number" INTEGER,
  "mechanic_staff_id" INTEGER,
  PRIMARY KEY ("service_ticket"),
  CONSTRAINT "FK_service_ticket.part_number"
    FOREIGN KEY ("part_number")
      REFERENCES "part"("part_number"),
  CONSTRAINT "FK_service_ticket.mechanic_staff_id"
    FOREIGN KEY ("mechanic_staff_id")
      REFERENCES "mechanic"("mechanic_staff_id"),
  CONSTRAINT "FK_service_ticket.customer_id"
    FOREIGN KEY ("customer_id")
      REFERENCES "customer"("customer_id"),
  CONSTRAINT "FK_service_ticket.serial_number"
    FOREIGN KEY ("serial_number")
      REFERENCES "car"("serial_number")
);


-- INSERT RECRD --
INSERT INTO salesperson
VALUES
	(
		1,
		'Vincent',
		'Huang'
	),
	(
		2,
		'Ryan',
		'Rhoades'
	);
	
INSERT INTO customer
VALUES
	(
		1,
		'Vinnie',
		'Huang',
		'1111-2222-3333-4445 124 01/23'
	),
	(
		2,
		'Vincento',
		'Huang',
		'1111-2222-3333-4444 123 01/23'
	),
	(
		3,
		'Terrell',
		'McKinney',
		'1111-2222-3333-4445 125 01/23'
	);
	
INSERT INTO car
VALUES
	(
		10001,
		'Toyota',
		'Camry',
		25500
	),
	(
		10002,
		'Volkswagen',
		'Atlas',
		33900
	),
	(
		10003,
		'Audi',
		'A4',
		39900
	);

INSERT INTO invoice
VALUES
	(
		1,
		'2021-11-03',
		1,
		1,
		10001
	),
	(
		2,
		'2021-12-25',
		2,
		2,
		10002
	);
	
INSERT INTO part
VALUES
	(
		1,
		'door',
		2999.99
	),
	(
		2,
		'wheels',
		664.56
	);
	
INSERT INTO mechanic
VALUES
	(
		1,
		'Vince',
		'Huang'
	),
	(
		2,
		'Vin',
		'Huang'
	);
	
INSERT INTO service_ticket (
	service_ticket,
	maintenance,
	total_price,
	service_ticket_date,
	serial_number,
	customer_id,
	mechanic_staff_id
)
VALUES
	(
		1,
		'Oil Change',
		70.99,
		'2022-01-09',
		10003,
		3,
		1
	);
	
-- Function/Procedure to add record to column --
CREATE OR REPLACE FUNCTION price_calc(part_no INTEGER)
RETURNS DECIMAL
AS $$
DECLARE 
	price DECIMAL;
BEGIN
	SELECT part_price INTO price
	FROM part
	where part_number = part_no;
	RETURN price;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE service_ticket_parts_change(
	ticket_no INTEGER,
	customer INTEGER,
	part_no INTEGER,
	car_serial INTEGER,
	mechanic_id INTEGER
)

LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO service_ticket (
	service_ticket,
	maintenance,
	total_price,
	serial_number,
	customer_id,
	part_number,
	mechanic_staff_id
)
VALUES
	(
		ticket_no,
		'Parts Change',
		price_calc(part_no),
		car_serial,
		customer,
		part_no,
		mechanic_id);
	COMMIT;

END;
$$
		
CALL service_ticket_parts_change(2,1,1,10001,2);

SELECT * 
FROM service_ticket;