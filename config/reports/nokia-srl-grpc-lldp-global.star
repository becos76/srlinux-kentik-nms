load("ranger", "source")
load("ranger", "metric")
load("ranger", "device")
load("ranger", "log")

metrics = [
    'frame-out',
    'frame-error-in',
    'frame-discard',
    'tlv-discard',
    'tlv-unknown',
    'tlv-accepted',
    'entries-aged-out',
    'frame-in',
]

config = [
    'admin-state',
    'chassis-id',
    'chassis-id-type',
    'hello-timer',
    'hold-multiplier',
    'system-name',
    'system-description',
]

def execute(report):
    #log("###### STRALARK GLOBAL LLDP STARTING #######")
        
    lldp = source.select("/system/lldp")
    
    if lldp:
        record = report.append()

        for key in metrics:
            record.append(key, lldp['statistics'].get(key), metric=True )

        for key in config:   
            record.append(key, lldp.get(key), metric=False)
        
        if lldp.get('admin-state') in [ 'enable' ]:
            record.append('online', 1 , metric=True)
        else:
            record.append('online', 0 , metric=True)
                
        record.append("device_name", device().config.name)
        record.append("device_ip", device().config.host)
        record.append("device_id", device().config.id)
    else:
        log("###### STRALARK GLOBAL-LLDP EMPTY #######")
        return
    
    #log("###### STRALARK GLOBAL LLDP FINISHED #######")