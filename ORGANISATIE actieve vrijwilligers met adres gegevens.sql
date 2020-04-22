------------------------
-- actieve afdelingen --
------------------------
SELECT DISTINCT p.id p_id, 
	COALESCE(p.first_name,'') voornaam,
	COALESCE(p.last_name,'') familienaam,
	afd.name afdeling,
	CASE 
		WHEN COALESCE(of.valid_to_date,'2999-01-01') > now()::date THEN 1 ELSE 0
	END afdeling_actief,
	fc.name functiecategorie,
	ft.name functietype,
	--!!! voor buitenlanders moet "res_partner.street" genomen worden met de straat naam en nr in 1 veld !!!
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN ccs.name
		ELSE p.street
	END straat,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN p.street_nbr ELSE ''
	END huisnummer, 
	p.street_bus bus,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN cc.zip
		ELSE p.zip
	END postcode,
	CASE 
		WHEN c.id = 21 AND p.crab_used = 'true' THEN cc.name ELSE p.city 
	END gemeente,
	p.postbus_nbr postbus,
	CASE
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 1000 AND 1299 THEN 'Brussel' 
		WHEN p.country_id = 21 AND (substring(p.zip from '[0-9]+')::numeric BETWEEN 1500 AND 1999 OR substring(p.zip from '[0-9]+')::numeric BETWEEN 3000 AND 3499) THEN 'Vlaams Brabant'
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 2000 AND 2999  THEN 'Antwerpen' 
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 3500 AND 3999  THEN 'Limburg' 
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 8000 AND 8999  THEN 'West-Vlaanderen' 
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 9000 AND 9999  THEN 'Oost-Vlaanderen' 
		WHEN p.country_id = 21 THEN 'Wallonië'
		WHEN p.country_id = 166 THEN 'Nederland'
		WHEN NOT(p.country_id IN (21,166)) THEN 'Buitenland niet NL'
		ELSE 'andere'
	END AS provincie,
	c.name land,
	p.email, p.email_work email_werk
FROM (SELECT p.id, p.name
	FROM res_partner p
		JOIN res_organisation_type o ON p.organisation_type_id = o.id
		--LEFT OUTER JOIN res_partner_bank pb ON p.id = pb.partner_id
	WHERE /*p.organisation_type_id IN (1) AND*/ p.active
	ORDER BY p.organisation_type_id, p.name)afd
	JOIN res_organisation_function of ON of.partner_id = afd.id
	JOIN res_partner p ON p.id = of.person_id
	JOIN res_function_type ft ON ft.id = of.function_type_id 
	JOIN res_function_categ fc ON fc.id = ft.categ_id

	--land, straat, gemeente info
	JOIN res_country c ON p.country_id = c.id
	LEFT OUTER JOIN res_country_city_street ccs ON p.street_id = ccs.id
	LEFT OUTER JOIN res_country_city cc ON p.zip_id = cc.id
WHERE COALESCE(of.valid_to_date,'2999-01-01') > now()::date



-------------------------------------
--SELECT * FROM res_organisation_type
-------------------------------------
-- Afdeling = 1
-- Werkgroep = 5
-- Regionale = 7
-- Bezoekerscentrum = 10





