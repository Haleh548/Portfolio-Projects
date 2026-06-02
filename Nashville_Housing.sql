SELECT * 
FROM `nashville housing data for data cleaning` ;

-- Standardized date format
ALTER TABLE `nashville housing data for data cleaning`
ADD SaleDateConverted DATE;

UPDATE `nashville housing data for data cleaning`
SET SaleDateConverted= STR_To_DATE(SaleDate, '%Y-%m-%d');

SELECT `SaleDate`, `SaleDateConverted`
FROM `nashville housing data for data cleaning`;

-- Populate property address data

SELECT UniqueID,ParcelID,PropertyAddress
FROM `nashville housing data for data cleaning` 
ORDER BY ParcelID ;

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM `nashville housing data for data cleaning` AS a
JOIN `nashville housing data for data cleaning` AS b
   ON a.ParcelID=b.ParcelID
   AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE `nashville housing data for data cleaning` AS a
JOIN `nashville housing data for data cleaning` AS b
   ON a.ParcelID=b.ParcelID
   AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress= IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;
   
-- Breaking out PropertyAddress into Individual Columns(Adress,City,State)
ALTER TABLE `nashville housing data for data cleaning`
ADD PropertySplitAddress VARCHAR(255),
ADD PropertySplitCity VARCHAR(255);

UPDATE `nashville housing data for data cleaning`
SET
PropertySplitAddress= SUBSTRING_INDEX(PropertyAddress,',',1),
PropertySplitCity= SUBSTRING_INDEX(PropertyAddress,',',-1);

-- Breaking out OwnerAddress into Individual Columns(Adress,City,State)

ALTER TABLE `nashville housing data for data cleaning`
ADD OwnerSplitAddress VARCHAR(255),
ADD OwnerSplitCity VARCHAR(255),
ADD OwnerSplitState VARCHAR(255);

UPDATE `nashville housing data for data cleaning`
SET 
OwnerSplitAddress= TRIM(SUBSTRING_INDEX(OwnerAddress, ',',1)),
OwnerSplitCity= TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',',2), ',',-1)),
OwnerSplitState=TRIM(SUBSTRING_INDEX(OwnerAddress, ',',-1));
  
-- Change Y and N to Yes and No in "SoldAsVacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(*)
FROM `nashville housing data for data cleaning`
GROUP BY SoldAsVacant
ORDER BY 2;


UPDATE `nashville housing data for data cleaning`
SET  SoldAsVacant=
       CASE WHEN SoldAsVacant='N' THEN 'NO'
            WHEN SoldAsVacant='Y' THEN 'YES'
            ELSE SoldAsVacant
	   END;


SELECT DISTINCT
    (SoldAsVacant), COUNT(*)
FROM
    `nashville housing data for data cleaning`
GROUP BY SoldAsVacant
ORDER BY 2; 

-- Remove Duplicates
WITH RowNumCTE AS (
SELECT *, ROW_NUMBER() OVER(
          PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     ORDER BY UniqueID) AS row_num
FROM `nashville housing data for data cleaning`
)  
SELECT *
FROM  RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress; 

CREATE TABLE nashville_housing_Backup AS
SELECT *
FROM `nashville housing data for data cleaning`; 

DELETE t1
FROM `nashville housing data for data cleaning` t1
JOIN(
     SELECT UniqueID, ROW_NUMBER() OVER(
          PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     ORDER BY UniqueID) AS row_num
    FROM `nashville housing data for data cleaning`
) t2
ON t1.UniqueID=t2.UniqueID
WHERE row_num > 1;


 SELECT
    ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference,
    COUNT(*) AS cnt
FROM `nashville housing data for data cleaning`
GROUP BY
    ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
HAVING COUNT(*) > 1; 

-- Delete Unused Columns
Alter Table `nashville housing data for data cleaning`
DROP COLUMN TaxDistrict;

SELECT * FROM `nashville housing data for data cleaning`;                   