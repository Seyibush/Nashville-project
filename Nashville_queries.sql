-- Disable safe updates
set SQL_SAFE_UPDATES = 0;

-- Update SaleDate column with a formatted date
update nashville
set SaleDate = STR_TO_DATE('April 9, 2013', '%M %e, %Y');

-- Add new columns for property street and city
alter table nashville
add column property_street VARCHAR(255),
add column property_city VARCHAR(255);

-- Update property street and city columns by extracting values from PropertyAddress
update nashville
SET property_street = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    property_city = SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 2), ',', -1);
    
-- Add new columns for owner street, city, state, and postal code
alter table nashville
add column owner_street VARCHAR(255),
add column owner_city VARCHAR(255),
add column owner_state VARCHAR(255),
add column owner_postal_code VARCHAR(10);

-- Update owner street, city, state, and postal code columns by extracting values from OwnerAddressUPDATE nashville
set owner_street = SUBSTRING_INDEX(OwnerAddress, ',', 1),
    owner_city = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1),
    owner_state = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1);
    
-- Retrieve distinct values of SoldAsVacant
select distinct(SoldAsVacant)
from nashville;


-- Update SoldAsVacant column with 'Yes' for 'y', 'No' for 'N', and keep other values as is
update nashville
set SoldAsVacant = case when SoldAsVacant = 'y' then 'Yes' 
                        when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant END;

-- Delete duplicate rows based on OwnerName, keeping the one with the lowest UniqueID
delete n1
from nashville n1
JOIN nashville n2 ON n1.OwnerName = n2.OwnerName
WHERE n1.UniqueID > n2.UniqueID;

-- Modify columns to have decimal data type
alter table nashville
modify column SalePrice DECIMAL(10, 2),
modify column LandValue DECIMAL(10, 2),
modify column BuildingValue DECIMAL(10, 2),
modify column TotalValue DECIMAL(10, 2)
;

-- Remove columns OwnerAddress and OwnerName from the table
alter table nashville
drop column OwnerAddress,
drop column OwnerName;