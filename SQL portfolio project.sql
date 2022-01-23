--CLEANING DATA IN SQL
use [portfolio project ]

SELECT * FROM dbo.nasvillehousing
 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

----CHANGING DATE FORMAT 
SELECT SaleDate, CONVERT(DATE,saledate)
FROM dbo.nasvillehousing

-- how to update the data format  in table 
alter table dbo.nasvillehousing
add saledatenew date 
-- we are using update because we are taking data from saledate column 
UPDATE Dbo.nasvillehousing
SET SaleDatenew = CONVERT(Date,SaleDate)

--populate property address data 

--------------------------------------------------------------------------------------------------------------------------
SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(b.PropertyAddress, a.propertyaddress)
FROM dbo.nasvillehousing a  join 
dbo.nasvillehousing b 
on a.ParcelID = b.ParcelID
and a.uniqueid <> b.UniqueID 
where b.PropertyAddress is null 
--for update new column with b column we will run this query 

update b 
set PropertyAddress = ISNULL(b.PropertyAddress, a.propertyaddress)
FROM dbo.nasvillehousing a  join 
dbo.nasvillehousing b 
on a.ParcelID = b.ParcelID
and a.uniqueid <> b.UniqueID 
where b.PropertyAddress is null 
--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
-- Populate Property Address data
SELECT PropertyAddress
FROM dbo.nasvillehousing
query for seperating address and state separtely 
-- Populate Property Address data
SELECT substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as address , 
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))as state 
FROM dbo.nasvillehousing


--for creating the new column  property_break_address 

alter table dbo.nasvillehousing
add property_break_address nvarchar(255)

--update data into it 
update  dbo.nasvillehousing
set property_break_address = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

--for creating the new column property_break_state
alter table dbo.nasvillehousing
add property_break_state nvarchar(255)

update  dbo.nasvillehousing
set property_break_state = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))
--------------------------------------------------------------------------------------------------------------------------
select  * from dbo.nasvillehousing
-- query for changing the owneraddress in address,city,and state 
select PARSENAME(replace(owneraddress,',','.'),1)
,PARSENAME(replace(owneraddress,',','.'),2) 
,PARSENAME(replace(owneraddress,',','.'),3)
from dbo.nasvillehousing 
--query for adding new column owner_state
alter table dbo.nasvillehousing
add owner_state nvarchar(255)
--adding split data into the column 
update dbo.nasvillehousing
set owner_state = PARSENAME(replace(owneraddress,',','.'),1)
--query for adding new column owner_state
alter table dbo.nasvillehousing
add owner_city nvarchar(255)
--adding split data into the column 
update dbo.nasvillehousing
set owner_city  = PARSENAME(replace(owneraddress,',','.'),2)
--query for adding new column owner_address 
alter table dbo.nasvillehousing
add owner_address nvarchar(255)
--adding split data into the column 
update dbo.nasvillehousing
set owner_address  = PARSENAME(replace(owneraddress,',','.'),3)
--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
select  SoldAsVacant from dbo.nasvillehousing

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from dbo.nasvillehousing
GROUP BY SoldAsVacant
ORDER BY 2
-- SO WE WILL CHANGE THE Y AND N  INO YES AND NO 
select
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE 
SoldAsVacant
END 
from dbo.nasvillehousing
--now transforming the data into the table 
update dbo.nasvillehousing
set SoldAsVacant = 
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE 
SoldAsVacant
END 
--Testing 
select soldasvacant from dbo.nasvillehousing
--perfectly fine go a head 
--------------------------------------------------------------------------------------------------------------------------
--Remove duplicate 
select * from dbo.nasvillehousing
with rownocte as (select *,ROW_NUMBER() over (partition by 
PropertyAddress,
parcelid,
saleprice,
saledate,
legalreference
order by uniqueid) as row_num

from dbo.nasvillehousing)
select * from rownocte

where row_num > 1

--------------------------------------------------------------------------------------------------------------------------
--delete unused column 

select  * from dbo.nasvillehousing
alter table dbo.nasvillehousing
drop column propertyaddress,owneraddress,saledate









