use [mdlp]

exec sp_msforeachtable N'UPDATE STATISTICS ? WITH FULLSCAN'
