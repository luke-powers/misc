import math
from prometheus_client import start_http_server, Gauge
import time


METRIC = Gauge(
    'test_metric',
    'Test Metrics for Testing',
    labelnames=['foo', 'bar']
)


def emit_metric(num):
    value_1 = int((math.sin(0.025*num) * 500) + 500)
    METRIC.labels(foo='ok', bar='strange').set(value_1)
    value_2 = int((math.cos(0.025*num) * 250) + 250)
    METRIC.labels(foo='meh', bar='bah').set(value_2)


if __name__ == '__main__':
    start_http_server(8888)
    ctr = 0
    while True:
        emit_metric(ctr)
        ctr += 1
        time.sleep(10)
