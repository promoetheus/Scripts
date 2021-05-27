SELECT @@SERVERNAME AS Server_name,  queues.Name AS Queue_name, parti.Rows, cast((is_receive_enabled | is_enqueue_enabled) as int) is_queue_enabled
      FROM post16.sys.objects AS SysObj
        INNER JOIN post16.sys.partitions AS parti ON parti.object_id = SysObj.object_id
        INNER JOIN post16.sys.objects AS queues ON SysObj.parent_object_id = queues.object_id
        left join post16.sys.service_queues sq on sq.is_ms_shipped =0 and sq.name=queues.name
      WHERE
        parti.index_id = 1 and queues.is_ms_shipped = 0 