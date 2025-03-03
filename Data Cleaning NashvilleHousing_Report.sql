/*

Cleaning Data in SQL Queries

*/


select *
From PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDateConverted, Convert(date,saledate)	
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set Saledate = Convert(date,Saledate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing SET SaleDateConverted = Convert(Date,SaleDate)

-------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is Null
Order by 2



select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL


----------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is Null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add ProperySplitAddress VARCHAR(255) 

Update NashvilleHousing 
SET ProperySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add ProperySplitCity VARCHAR(255);

Update NashvilleHousing 
SET ProperySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress))


Select *
FROM PortfolioProject.dbo.NashvilleHousing



Select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
FROM PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress VARCHAR(255) 

Update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity VARCHAR(255);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState VARCHAR(255) 

Update NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)




Select *
FROM PortfolioProject.dbo.NashvilleHousing



-------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant"

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order By 2



Select SoldAsVacant
,CASE 
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE 
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
End






-------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--Order BY ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by 4

Select *
From PortfolioProject.dbo.NashvilleHousing



-------------------------------------------------------------------------------------------------------------------
-- Remove Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate





























