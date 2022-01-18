local mt = {}

function mt:age()
end
function mt:birthday()
end
-- CPF; ID to identify taxpayers in Brazil
function mt:cpf()
end
function mt:first()
end
function mt:profession()
end
function mt:company()
end
function mt:gender()
end
function mt:last()
end
function mt:israelId()
end
function mt:mrz()
end
function mt:name()
end
-- Return the list of available name prefixes based on supplied gender.
-- @todo introduce internationalization
function mt:name_prefixes()
end
-- Alias for name_prefix
function mt:prefix()
end
function mt:name_prefix()
end
-- Hungarian ID number
function mt:HIDN()
end
function mt:ssn()
end
-- Aadhar is similar to ssn, used in India to uniquely identify a person
function mt:aadhar()
end
-- Return the list of available name suffixes
-- @todo introduce internationalization
function mt:name_suffixes()
end
-- Alias for name_suffix
function mt:suffix()
end
function mt:name_suffix()
end
function mt:nationalities()
end
-- Generate random nationality based on json list
function mt:nationality()
end

return mt
