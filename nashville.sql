/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [portfolio project].[dbo].[NashvilleHousing]

  --Cleaning data in SQL Queries

  SELECT *
  FROM [portfolio project].dbo.NashvilleHousing

  --Standarize Date Format

    SELECT SaleDateConverted, CONVERT(Date,SaleDate)
  FROM [portfolio project].dbo.NashvilleHousing

  Update NashvilleHousing
  SET SaleDate = CONVERT(Date,SaleDate)

  ALTER TABLE NashvilleHousing
  Add SaleDateConverted Date;

  Update NashvilleHousing
  SET SaleDateConverted = CONVERT(Date,SaleDate)

  --Populate Property Address data

      SELECT *
  FROM [portfolio project].dbo.NashvilleHousing
  --WHERE PropertyAddress is null
  order by ParcelID


  SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM [portfolio project].dbo.NashvilleHousing a
  Join [portfolio project].dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

   UPDATE a
   SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
   FROM [portfolio project].dbo.NashvilleHousing a
  Join [portfolio project].dbo.NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null


   --Breaking Out Address Into Individual Columns (Address, City, State)



         SELECT PropertyAddress
  FROM [portfolio project].dbo.NashvilleHousing
  --WHERE PropertyAddress is null
  --order by ParcelID

  SELECT 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
  ,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) as Address
  FROM [portfolio project].dbo.NashvilleHousing



  ALTER TABLE NashVilleHousing
  Add PropertySplitAddress nvarchar(255);

  Update NashvilleHousing
  SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

    ALTER TABLE NashvilleHousing
  Add PropertySplitCity nvarchar(255);

  Update NashvilleHousing
  SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))


  SELECT *
  FROM [portfolio project].dbo.NashvilleHousing
  .
  .

    SELECT OwnerAddress
  FROM [portfolio project].dbo.NashvilleHousing

  SELECT
  PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
   ,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
    ,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
  FROM [portfolio project].dbo.NashvilleHousing



    ALTER TABLE NashVilleHousing
  Add OwnerSplitAddress nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

    ALTER TABLE NashvilleHousing
  Add OwnerSplitCity nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

      ALTER TABLE NashvilleHousing
  Add OwnerSplitState nvarchar(255);

  Update NashvilleHousing
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

    SELECT *
  FROM [portfolio project].dbo.NashvilleHousing


  -- Change Y and N to Yes and No in "sold as vacant" field

  SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
  FROM [portfolio project].dbo.NashvilleHousing
  Group by SoldAsVacant
  Order by 2

  SELECT SoldAsVacant
  , CASE when SoldAsVacant = 'Y' THEN 'Yes'
  When SoldAsVacant = 'N' THEN 'No'
  Else SoldAsVacant
  End
  FROM [portfolio project].dbo.NashvilleHousing

  Update NashvilleHousing
  SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
  When SoldAsVacant = 'N' THEN 'No'
  Else SoldAsVacant
  End



  --Remove Duplicates

 WITH RowNumCTE AS(
 SELECT*,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
                  PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order by
				  UniqueID
				  ) row_num

FROM [portfolio project].dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress


--DELETE unused columns

SELECT *
FROM [portfolio project].dbo.NashvilleHousing

ALTER TABLE [portfolio project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [portfolio project].dbo.NashvilleHousing
DROP COLUMN SaleDate