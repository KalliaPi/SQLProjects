-- Converting Date Time format to Date format

select NewSaleDate, convert(date,saledate)
from PortfolioProject..NashvilleRE

update NashvilleRE
set saledate = convert(date,saledate)

alter table NashvilleRE
add NewSaleDate Date;


update NashvilleRE
set NewSaleDate = convert(date,saledate)



-- Filling the NULLS with information

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleRE a
join PortfolioProject..NashvilleRE b
on a.ParcelID= b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleRE a
join PortfolioProject..NashvilleRE b
on a.ParcelID= b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-- Splitting PropertyAddress into Address and City columns using SUBSTRING Function

select 
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as city
from PortfolioProject..NashvilleRE

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
from PortfolioProject..NashvilleRE



Alter table NashvilleRE
add Address nvarchar(255);

update NashvilleRE
set Address=substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


Alter table NashvilleRE
add City nvarchar(255);

update NashvilleRE
set City=substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



-- Splitting OwnerAddress into separate columns using PARSENAME Function

select
Parsename(replace( OwnerAddress,',','.') ,3)
,Parsename(replace( OwnerAddress,',','.') ,2)
,Parsename(replace( OwnerAddress,',','.') ,1)
from PortfolioProject..NashvilleRE

alter table Portfolioproject..Nashvillere
add OwnerAddress2 nvarchar(255);

update Portfolioproject..Nashvillere
set OwnerAddress2=Parsename(replace( OwnerAddress,',','.') ,3)

alter table  Portfolioproject..Nashvillere
add OwnerCity nvarchar(255);

update  Portfolioproject..Nashvillere
set OwnerCity=Parsename(replace( OwnerAddress,',','.') ,2)

alter table  Portfolioproject..Nashvillere
add OwnerState nvarchar(255);

update  Portfolioproject..Nashvillere
set OwnerState=Parsename(replace( OwnerAddress,',','.') ,1)

--alter table  Portfolioproject..Nashvillere 
--DROP COLUMN OwnerAddres2;



-- Updating Y and N into Yes and No from SoldAsVacant column

Select SoldAsVacant,
CASE 
    When SoldAsVacant='Y' THEN 'Yes'
    When SoldAsVacant='N' THEN 'No'
    ELSE SoldAsVacant
    END
From PortfolioProject..NashvilleRE

Update PortfolioProject..NashvilleRE
Set SoldAsVacant=CASE 
    When SoldAsVacant='Y' THEN 'Yes'
    When SoldAsVacant='N' THEN 'No'
    ELSE SoldAsVacant
    END

	Select Distinct(SoldAsVacant), Count(SoldAsVacant)
	from PortfolioProject..NashvilleRE
	Group by SoldAsVacant
	Order by SoldAsVacant desc



-- Removing Duplicates (Using CTE)

	With RownumCTE as (
	select *,
	row_number() over (Partition by ParcelId, PropertyAddress, SalePrice, SaleDate, LegalReference
	Order by UniqueID) as row_num
	from PortfolioProject..NashvilleRE)
    SELECT *
	--Delete
	from RownumCTE
	Where row_num>1
	--order by PropertyAddress



-- Deleting Columns that we don't need

Alter table PortfolioProject..NashvilleRE
drop column PropertyAddress, OwnerAddress, TaxDistrict


Alter table PortfolioProject..NashvilleRE
drop column SaleDate
