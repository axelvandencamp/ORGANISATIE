
-- bedragen afdracht op halen per afdeling en regionale
SELECT ot.id, ot.name, p.id, p.name, p.remittance_new_member afdracht_nieuw_lid, p.remittance_exist_member afdracht_bestaand_lid
FROM res_partner p 
	JOIN res_organisation_type ot ON ot.id = p.organisation_type_id
--WHERE ot.name = 'Afdeling'	
WHERE p.organisation_type_id IN (1,7)
ORDER BY p.organisation_type_id, p.name
---------------
-- afdeling en hun regionale ophalen
SELECT p.id, p.name, p.partner_up_id, p2.id, p2.name
FROM res_partner p
	LEFT OUTER JOIN res_partner p2 ON p2.id = p.partner_up_id 
WHERE p.organisation_type_id = 1 --AND p.id = 248492--p.partner_up_id = 248530
	--AND p2.id = 15192
ORDER BY p2.name, p.name