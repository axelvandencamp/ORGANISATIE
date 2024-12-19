
-- bedragen afdracht op halen per afdeling en regionale
SELECT ot.id, 
	CASE WHEN active AND regional_partnership AND organisation_type_id = 1 THEN 'Afdeling & Regionaal samenwerkingsverband' ELSE ot.name END organisatie_type, 
	p.id, p.name, 
	p.remittance_new_member afdracht_nieuw_lid, p.remittance_exist_member afdracht_bestaand_lid
FROM res_partner p 
	JOIN res_organisation_type ot ON ot.id = p.organisation_type_id
--WHERE ot.name = 'Afdeling'	
WHERE p.organisation_type_id IN (1,7)
ORDER BY p.organisation_type_id, p.name
---------------
-- afdelingen met ledenaantal en hun regionale
SELECT p.id, p.name,
	sq1.aantal aantal_leden,
	CASE WHEN p.active AND p.regional_partnership AND p.organisation_type_id = 1 THEN p.id ELSE p2.id END regionale_id,
	CASE WHEN p.active AND p.regional_partnership AND p.organisation_type_id = 1 THEN p.name ELSE COALESCE(p2.name,'') END regionaal_samenwerkingsverband
FROM res_partner p
	LEFT OUTER JOIN res_partner p2 ON p2.id = p.partner_up_id 
	JOIN
		(SELECT a.id, a.name, COUNT(p.id) aantal
			FROM res_partner p
				--afdeling vs afdeling eigen keuze
				LEFT OUTER JOIN res_partner a ON a.id = COALESCE(p.department_choice_id,p.department_id)
			WHERE a.organisation_type_id = 1 AND p.active AND p.membership_state IN ('paid','invoiced','free')
			GROUP BY a.id, a.name
		) SQ1 ON sq1.id = p.id
WHERE p.organisation_type_id = 1 
ORDER BY p2.name, p.name