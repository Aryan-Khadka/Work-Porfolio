/*
Cleaning Data in SQL Queries
*/


Select *
From WorkPortfolio.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SalesDate, CONVERT(Date,SaleDate)
From WorkPortfolio.dbo.NashvilleHousing

Update WorkPortfolio.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE WorkPortfolio.dbo.NashvilleHousing
Add SalesDate Date;

Update WorkPortfolio.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From WorkPortfolio.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM WorkPortfolio.dbo.NashvilleHousing a
JOIN WorkPortfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM WorkPortfolio.dbo.NashvilleHousing a
JOIN WorkPortfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From WorkPortfolio.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

From WorkPortfolio.dbo.NashvilleHousing			

ALTER TABLE WorkPortfolio.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update WorkPortfolio.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE WorkPortfolio.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update WorkPortfolio.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From WorkPortfolio.dbo.NashvilleHousing




Select OwnerAddress
From WorkPortfolio.dbo.NashvilleHousing	



Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),																	
PARSENAME(Replace(OwnerAddress,',','.'),1)																		
From WorkPortfolio.dbo.NashvilleHousing

ALTER TABLE WorkPortfolio.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update WorkPortfolio.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE WorkPortfolio.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update WorkPortfolio.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE WorkPortfolio.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update WorkPortfolio.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)		



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct (SoldAsVacant),
Count (SoldAsVacant)
From WorkPortfolio.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2



select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From WorkPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END







-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *, 
ROW_NUMBER() Over( 
Partition By ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID) row_num

FROM WorkPortfolio.dbo.NashvilleHousing

--ORDER BY ParcelID
)

Select * 

FROM RowNumCTE

WHERE row_num > 1
Order by PropertyAddress






---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *

From WorkPortfolio.dbo.NashvilleHousing

Alter Table WorkPortfolio.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table WorkPortfolio.dbo.NashvilleHousing
Drop Column SaleDate




