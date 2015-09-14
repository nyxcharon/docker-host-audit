docker-host-audit
=============================

Overview
---------------------
This is a ruby script to run the official docker host security audit container on
a machine and report what test fail. It can run all test, or just a set of them
that can be specified. It will only alert on test in a WARN state. Returns 0 on success
and 1 on failure.  
Offical docker host audit image - [https://github.com/docker/docker-bench-security]  
Center for Internet Security report the above image was based on - [PDF Here](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.6_Benchmark_v1.0.0.pdf)

Flags
---------------------
-c LIST - The list of test to verify as passing. If not specified it will run all test.  
-v      - Verbosity. This flag will also output the contents of the test instead of just pass or fail.  

Usage
---------------------

Run all test  
```
ruby docker-host-audit.rb
```
Run a set of test  
```
ruby docker-host-audit.rb -c "1.2,1.5,1.6,2.1,2.4,2.5,3.15,3.16,5.5,5.6,5.18"
```
Run a set of test and output the test results  
```
ruby docker-host-audit.rb -c "1.2,1.5" -v
```
