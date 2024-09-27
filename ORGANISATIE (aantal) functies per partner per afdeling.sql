--SELECT p.organisation_function_parent_ids, * FROM res_partner p WHERE p.id = 78008
--SELECT * FROM res_organisation_function WHERE partner_id = 248536

------------------------
--detail functies per ID
SELECT of.partner_id afd_id, a1.name afdeling, of.person_id partner_id, p.first_name || ' ' || p.last_name partner, of.name 
FROM res_organisation_function of 
	JOIN res_partner p ON p.id = of.person_id
	JOIN res_partner a1 ON a1.id = of.partner_id
WHERE /*of.partner_id = 248646 AND*/ of.person_id = 20065
ORDER BY p.id, a1.id


------------------------
--aantal functies per ID
SELECT p.id, COUNT(of.id) aantal, p.first_name || ' ' || p.last_name partner
FROM res_organisation_function of 
	JOIN res_partner p ON p.id = of.person_id
	JOIN res_partner a1 ON a1.id = of.partner_id
WHERE of.person_id IN (20065)
GROUP BY p.id, p.last_name, p.first_name
ORDER BY p.id