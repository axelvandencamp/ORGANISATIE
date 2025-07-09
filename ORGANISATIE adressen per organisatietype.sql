-----------------------------------------
--
-- Te gebruiken voor maandelijkse statistieken
-- - leden per provincie
-- - leden per afdeling
-- - nieuwwe leden per wervende afdeling
--
-- OPMERKING
-- - voor ledencijfers "OGM" in comment laten; geeft verdubbelingen
-- - ook alle "ml." velden weglaten om zelfde reden
-----------------------------------------

--=================================================================
--
-- REGEL voor ivm uitsluiting opgezegden herzien (of procedure van opzegging)
--
--=================================================================
--SET VARIABLES
DROP TABLE IF EXISTS _AV_myvar;
CREATE TEMP TABLE _AV_myvar 
	(startdatum DATE, einddatum DATE
	 ,afdeling NUMERIC, postcode TEXT, herkomst_lidmaatschap NUMERIC, wervende_organisatie NUMERIC, test_id NUMERIC
	 );

INSERT INTO _AV_myvar VALUES('2025-01-01',	--startdatum
				'2026-12-31',	--einddatum
				248494, --afdeling 	
				'2260', --postcode
				494,  	--numeric 
				248585,	--wervende_organisatie
				'16382'	--numeric
				);
SELECT * FROM _AV_myvar;
--====================================================================
--====================================================================
SELECT	DISTINCT--COUNT(p.id) _aantal, now()::date vandaag
	p.id database_id, 
	p.membership_nbr lidnummer, 
	ot.name organisatie_type,
	COALESCE(p.first_name,'') as voornaam,
	COALESCE(p.last_name,'') as achternaam,
	COALESCE(p.street2,'') huisnaam,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN COALESCE(ccs.name,'')
		ELSE COALESCE(p.street,'')
	END straat,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN COALESCE(p.street_nbr,'') ELSE ''
	END huisnummer, 
	COALESCE(p.street_bus,'') bus,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN COALESCE(cc.zip,'')
		ELSE COALESCE(p.zip,'')
	END postcode,
	CASE 
		WHEN c.id = 21 THEN COALESCE(cc.name,'') ELSE COALESCE(p.city,'') 
	END woonplaats,
	COALESCE(p.postbus_nbr,'') postbus,
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
	_crm_land(c.id) land,
	p.email,
	COALESCE(p.phone_work,p.phone) telefoonnr,
	p.mobile gsm,
	p.membership_state huidige_lidmaatschap_status,
	COALESCE(p.membership_start,p.create_date::date) aanmaak_datum,
	p.membership_start Lidmaatschap_startdatum, 
	p.membership_stop Lidmaatschap_einddatum,  
	p.membership_pay_date betaaldatum,
	p.membership_renewal_date hernieuwingsdatum,
	p.membership_end recentste_einddatum_lidmaatschap,
	p.active,
	CASE
		WHEN p.address_state_id = 2 THEN 1 ELSE 0
	END adres_verkeerd
FROM 	_av_myvar v, res_partner p
	--Voor de ontdubbeling veroorzaakt door meedere lidmaatschapslijnen
	--land, straat, gemeente info
	JOIN res_country c ON p.country_id = c.id
	LEFT OUTER JOIN res_country_city_street ccs ON p.street_id = ccs.id
	LEFT OUTER JOIN res_country_city cc ON p.zip_id = cc.id
	--organisatietype
	LEFT OUTER JOIN res_organisation_type ot ON ot.id = p.organisation_type_id
-- SELECT * FROM res_organisation_type ot	
--=============================================================================
WHERE 	p.organisation_type_id IN (15,16,23) -- 15-Gebouw; 16-Werking bezoekerscentrum; 23-Werking natuur.huis