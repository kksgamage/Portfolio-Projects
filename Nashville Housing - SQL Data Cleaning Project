select*
from dbo.nashvillehousing



-------------------------------------------------------------------------------------------------------------------------
--Staderdize date format

select SalesDateConverted, convert(date,saledate)
from dbo.nashvillehousing

update nashvillehousing
set SaleDate = convert(date,saledate)

Alter table nashvillehousing
Add SalesDateConverted date ;

update nashvillehousing
set SalesDateConverted = convert(date,saledate)



--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Property Address Data

select*
from dbo.nashvillehousing
order by ParcelID

select a.ParcelID,a.PropertyAddress, b.ParcelID , b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.nashvillehousing a
join dbo.nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.nashvillehousing a
join dbo.nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



-------------------------------------------------------------------------------------------------------------------------------------
--Breaking Out Address Into Indivigual Coloums(Address,City,State)

select PropertyAddress
from dbo.nashvillehousing

Select
	substring(propertyaddress , 1, CHARINDEX(',', PropertyAddress) -1) as Address
	,substring(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress)) as City
	

Alter table nashvillehousing
Add PropertySplitAddress nvarchar(255) ;

update nashvillehousing
set PropertySplitAddress = substring(propertyaddress , 1, CHARINDEX(',', PropertyAddress) -1) 

Alter table nashvillehousing
Add PropertySplitCity nvarchar(255) ;

update nashvillehousing
set PropertySplitCity = substring(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))


select 
	PARSENAME(replace(owneraddress,',','.'),3) as Address
	,PARSENAME(replace(owneraddress,',','.'),2) as City
	,PARSENAME(replace(owneraddress,',','.'),1) as State
from dbo.nashvillehousing


Alter table nashvillehousing
Add OwnerSplitAddress nvarchar(255) ;

update nashvillehousing
set OwnerSplitAddress = PARSENAME(replace(owneraddress,',','.'),3) 

Alter table nashvillehousing
Add OwnerSplitCity nvarchar(255) ;

update nashvillehousing
set OwnerSplitCity = PARSENAME(replace(owneraddress,',','.'),2) 

Alter table nashvillehousing
Add OwnerSplitState nvarchar(255) ;

update nashvillehousing
set OwnerSplitState = PARSENAME(replace(owneraddress,',','.'),1) 

select*
from dbo.nashvillehousing



-------------------------------------------------------------------------------------------------------------------------
--Change Y,N,Yes and No in Same Category

select Distinct(SoldAsVacant), count(SoldAsVacant)
from dbo.nashvillehousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
	,CASE WHEN SoldAsVacant ='Y' THEN 'YES'
		  WHEN SoldAsVacant ='N' THEN 'No'
		  Else SoldAsVacant
		  end
from dbo.nashvillehousing

update nashvillehousing
set SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'YES'
		  WHEN SoldAsVacant ='N' THEN 'No'
		  Else SoldAsVacant
		  end


-----------------------------------------------------------------------------------------------------------------------------
--Remove Dublicates

with rownumcte as(
select *,
	ROW_NUMBER() over (
	partition by parcelid,
				 propertyAddress,
				 saleprice,
				 saledate,
				 legalreference
		Order by
					uniqueid
					)row_num

from dbo.nashvillehousing
--order by ParcelID
)
Select*
from rownumcte
where row_num >1
order by PropertyAddress



-----------------------------------------------------------------------------------------------------------------------------
--Delete Unused Coloums

select*
from dbo.nashvillehousing

Alter table dbo.nashvillehousing
drop column owneraddress,taxdistrict,propertyaddress, saledate
