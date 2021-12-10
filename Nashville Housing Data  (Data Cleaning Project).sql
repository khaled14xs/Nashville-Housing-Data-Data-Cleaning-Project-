
Select *
From [dbo].[Nashville ]





Update [dbo].[Nashville ]
SET SaleDate = CONVERT(Date,SaleDate)




 

-- Populate Property Address data

Select *
From [dbo].[Nashville ]
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[Nashville ] a
JOIN [dbo].[Nashville ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[Nashville ] a
JOIN [dbo].[Nashville ] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null





-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [dbo].[Nashville ]


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [dbo].[Nashville ]


ALTER TABLE [dbo].[Nashville ]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[Nashville ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [dbo].[Nashville ]
Add PropertySplitCity Nvarchar(255)

Update [dbo].[Nashville ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [dbo].[Nashville ]





Select OwnerAddress
From [dbo].[Nashville ]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [dbo].[Nashville ]



ALTER TABLE [dbo].[Nashville ]
Add OwnerSplitAddress Nvarchar(255)

Update [dbo].[Nashville ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [dbo].[Nashville ]
Add OwnerSplitCity Nvarchar(255)

Update [dbo].[Nashville ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [dbo].[Nashville ]
Add OwnerSplitState Nvarchar(255)

Update [dbo].[Nashville ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [dbo].[Nashville ]


--------------------------------------------------------------------------------------------------------------------------


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [dbo].[Nashville ]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [dbo].[Nashville ]


Update [dbo].[Nashville ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END








-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [dbo].[Nashville ]
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [dbo].[Nashville ]




-- Delete Unused Columns





ALTER TABLE [dbo].[Nashville ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


