load("ranger", "source")
load("ranger", "metric")
load("ranger", "device")
load("ranger", "log")

metrics = [
    'frame-error-out',
    'frame-error-in',
    'frame-discard',
    'tlv-discard',
    'tlv-unknown',
    'frame-in',
    'frame-out',
]

config = [
    'name',
    'admin-state',
    'oper-state',
]

def execute(report):
    #log("###### STRALARK INTERFACE LLDP STARTING #######")
        
    interfaces = source.select("/system/lldp/interface")
  
    if interfaces:
        for intf in interfaces:
            record = report.append()
            # Get dimensions
            for key in config:
              record.append(key, intf.get(key), metric=False )  
            # Get metrics
            for key in metrics:
              record.append(key, intf['statistics'].get(key), metric=True )  
            
            # Reflect admin/oper states into metrics           
            record.append('admin-status', 1, metric=True ) if intf.get('admin-state') in ['enable'] else record.append('admin-status', 0, metric=True )
            record.append('oper-status', 1, metric=True ) if intf.get('oper-state') in ['up'] else record.append('oper-status', 0, metric=True )
            
            record.append("device_name", device().config.name)
            record.append("device_ip", device().config.host)
            record.append("device_id", device().config.id)
            
    else:
        log("###### STRALARK INTF-LLDP EMPTY #######")
        return
    
    #log("###### STRALARK INTF LLDP FINISHED #######")