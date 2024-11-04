-------------------------------------------
-- regionale definitie: postcode per afdeling
-------------------------------------------
SELECT p.id, cc.zip, p.name afdeling 
FROM res_partner p

	--afdeling vs afdeling eigen keuze
	/*LEFT OUTER JOIN res_partner a ON p.department_id = a.id
	LEFT OUTER JOIN res_partner a2 ON p.department_choice_id = a2.id*/
	--regionale definitie linken aan afdeling (eigen keuze of woonplaats) en postcodes ophalen
	LEFT OUTER JOIN res_organisation_city_rel ocr ON ocr.partner_id = p.id
	LEFT OUTER JOIN res_country_city cc ON ocr.zip_id = cc.id

--WHERE SUBSTRING(cc.zip from '[0-9]+')::numeric IN ('9990','9900')
WHERE p.organisation_type_id = 1
ORDER cc.zip

--SELECT name FROM res_partner WHERE id = 248587