load('system.star', 'system_process')
load("ranger", "source")
load("ranger", "device")
load("ranger", "metric")
load("ranger", "log")

def process(n, indexes):
    #n.append('index', 0, metric=False)
    n.append('os-version', source.select("system/information/version"), metric=False)
    
    log(n['os-version'].value)
    
# def execute(report):
#     record = report.append()
#     version = source.select("system/information/version")
#     log(version)
    
#     record.append("os-version", version, metric=False)
#     record.append("os-name", "Nokia SR Linux", metric=False)
#     record.append("device_name", device().config.name)
#     record.append("device_ip", device().config.host)
#     record.append("device_id", device().config.id)