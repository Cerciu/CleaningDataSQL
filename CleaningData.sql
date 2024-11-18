--Cleaning Data in SQL 

select*
From PortofolioProject..NaschvilleHousing

--Standardize Data Format

select SALEDATECConverted,Convert(Date,Saledate)
From PortofolioProject..NaschvilleHousing

Update NaschvilleHousing
SET SaleDate=Convert(date,SaleDate)

Alter Table NaschvilleHousing
Add SALEDATECConverted DATE
Update NaschvilleHousing
SET SALEDATECConverted = Convert(Date,Saledate)

--Populate Property Address data
select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject..NaschvilleHousing a
--where PropertyAddress is null

join PortofolioProject..NaschvilleHousing b 
on a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress IS NULL

Update a
Set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject..NaschvilleHousing a
--where PropertyAddress is null

join PortofolioProject..NaschvilleHousing b 
on a.ParcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress IS NULL

--Breaking out Adress into Individual Columns(Adress,City,State)

select PropertyAddress
From PortofolioProject..NaschvilleHousing

Select
Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Adress,
Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as City
From PortofolioProject..NaschvilleHousing

--select 
--Substring(OwnerAddress,1,Charindex(',',OwnerAddress)-1) as Adress,
--substring(OwnerAddress,CHARINDEX(',',OwnerAddress)+1,Charindex(',',OwnerAddress)-1) as City
--From PortofolioProject..NaschvilleHousing

Alter Table NaschvilleHousing
Add PropertySlpitAdress nvarchar(255)
Update NaschvilleHousing
SET PropertySlpitAdress =Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NaschvilleHousing
Add PropertySlpitCity nvarchar(255)
Update NaschvilleHousing
SET PropertySlpitCity= Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

Select *
From PortofolioProject..NaschvilleHousing


Select OwnerAddress
From PortofolioProject..NaschvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortofolioProject..NaschvilleHousing

Alter Table NaschvilleHousing
Add OwnerSlpitAdress nvarchar(255)
Update NaschvilleHousing 
Set OwnerSlpitAdress=PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table NaschvilleHousing
Add OwnerSlpitCity1 nvarchar(255)
Update NaschvilleHousing 
Set OwnerSlpitCity1=PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table NaschvilleHousing
Add OwnerSlpitState nvarchar(255)
Update NaschvilleHousing 
Set OwnerSlpitState=PARSENAME(Replace(OwnerAddress,',','.'),1)
select*
From PortofolioProject..NaschvilleHousing


--Change Y an N to Yes and NO in ''Sold as Vacant''

select Distinct(SoldasVacant),Count(SoldasVacant)
From PortofolioProject..NaschvilleHousing
group by SoldasVacant
order by 2


select SoldAsVacant
,case when SoldAsVacant ='Y' then 'YES'
      when SoldAsVacant='N' then 'NO'
	  Else SoldAsVacant
	  end
From PortofolioProject..NaschvilleHousing

update NaschvilleHousing
set SoldAsVacant= case when SoldAsVacant ='Y' then 'YES'
      when SoldAsVacant='N' then 'NO'
	  Else SoldAsVacant
	  end


--Remove Duplicates
With RowNumCTE as (
select *,
row_number()over (
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by 
			   UniqueID
			   )row_num

From PortofolioProject..NaschvilleHousing
)
Delete
From RowNumCTE
where row_num>1

--Delete Unused Columns

Select*
From PortofolioProject..NaschvilleHousing

Alter Table PortofolioProject..NaschvilleHousing
Drop Column  TaxDistrict
Alter Table PortofolioProject..NaschvilleHousing
Drop Column  SaleDate