
IF SERVERPROPERTY ('IsHadrEnabled') = 1 --AG

SELECT
   AGC.name -- Availability Group
, RCS.replica_server_name -- SQL cluster node name
, ARS.role_desc  -- Replica Role
, AGL.dns_name  -- Listener Name
FROM
sys.availability_groups_cluster AS AGC
  INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS RCS
   ON
    RCS.group_id = AGC.group_id
  INNER JOIN sys.dm_hadr_availability_replica_states AS ARS
   ON
    ARS.replica_id = RCS.replica_id
  INNER JOIN sys.availability_group_listeners AS AGL
   ON
    AGL.group_id = ARS.group_id
WHERE
ARS.role_desc = 'PRIMARY';

ELSE --NON AG
select  @@servername as [name],SERVERPROPERTY('ComputerNamePhysicalNetBIOS') as [replica_server_name],'PRIMARY' as [role_desc],@@servername as [dns_name];
