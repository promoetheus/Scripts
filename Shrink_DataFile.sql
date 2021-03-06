Declare @Sql Nvarchar(1500);
Declare @dbName Nvarchar(400);
Declare @FileName Nvarchar(400);
Declare @TargetSize Int;
Declare @InitialSize Int;
Set @dbName = 'STCrypt';
Set @FileName = 'STCrypt';
Set @InitialSize = 407552; -- in Megabytes
Set @TargetSize = 404480; -- in Megabytes

While @InitialSize > @TargetSize
	Begin 
		
		Set @Sql = 'USE ' + @dbName + Char(10) +
					'DBCC SHRINKFILE (N''' + @FileName + ''','+Convert(Nvarchar,@InitialSize) +')'
		Print @sql;
		Exec (@sql);

		Set @InitialSize = @InitialSize - 2048;
	End