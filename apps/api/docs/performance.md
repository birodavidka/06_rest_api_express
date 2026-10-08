## Performance

Local load testing was performed with Autocannon against the compiled
production build.

| Metric | Result |
|---|---:|
| Average throughput | 31,252 requests/sec |
| Total requests | 625,037 |
| Average latency | 0.02 ms |
| p99 latency | <1 ms |
| p99.9 latency | 3 ms |
| Maximum latency | 27 ms |

> This benchmark measured the unauthorized authentication-rejection path.
> All requests returned HTTP 401, so the results do not represent successful
> authenticated requests or production network conditions.

![Autocannon benchmark summary](docs/assets/autocannon-summary.png)

[View the detailed benchmark report](docs/performance.md)