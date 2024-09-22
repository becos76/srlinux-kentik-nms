load("time.star", "time")
load("ranger", "source")
load("ranger", "metric")
load("ranger", "device")
load("ranger", "log")

remote = [
  'system-name',
  'system-description',
  'port-id',
  'port-id-type',
  'port-description',
  'chassis-id',
  'chassis-id-type',
  'id',
]
metrics = [
    'first-message',
    'last-update', 
]

def execute(report):
    interfaces = source.select("/system/lldp/interface")
  
    if interfaces:
        for intf in interfaces:
            if intf.get('neighbor'):
                record = report.append()
                record.append('local-port-name', intf.get('name'), metric=False )  
                record.append('neighbors', len(intf['neighbor']), metric=True )  
                
                for nei in intf['neighbor']:
                    for key in remote:
                        record.append(key, nei.get(key), metric=False )  
                    for key in metrics:
                        now = time.now()
                        end = time.parse_time(nei.get(key))
                        duration = time.parse_duration(now - end)
                        record.append(key, int(duration.seconds), metric=True )  
                
                record.append("device_name", device().config.name)
                record.append("device_ip", device().config.host)
                record.append("device_id", device().config.id)
            else:
                pass
    else:
        log("###### STRALARK INTF-LLDP-NEI EMPTY #######")
        return