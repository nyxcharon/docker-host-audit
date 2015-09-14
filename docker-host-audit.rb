#! /usr/bin/env ruby

require 'ostruct'
require 'optparse'

def check_test(results,args)
  if args.checks.empty?
    args.checks = "1.1,1.2,1.3,1.5,1.6,1.7,1.8,1.9,1.10,1.11,1.13,1.14,1.15,1.16,1.17,1.18
                   ,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,2.10
                   ,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,3.10,3.11,3.12,3.13,3.14,3.15,3.16
                   ,3.17,3.18,3.19,3.20,3.21,3.22,3.23,3.24,3.25,3.26
                   ,4.1
                   ,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.10,5.11,5.12,5.13,5.14,5.15,5.16,5.17,5.18,5.19
                   ,6.5,6.6,6.7"
  end

  if  args.checks.include?(',')
      docker_test = args.checks.split(',')
  elsif not args.checks.empty?
      docker_test = [ args.checks ]
  end

  failed_test = ""
  results.each_line do |line|
    docker_test.each do |t|
      if /WARN.+#{t}\s+/ =~ line
          failed_test += t+" "
      end
    end
  end
  return failed_test
end

def run(args)
  command = "docker run -it --net host --pid host --cap-add audit_control \
      -v /var/lib:/var/lib \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /usr/lib/systemd:/usr/lib/systemd \
      -v /etc:/etc --label docker_bench_security \
      docker/docker-bench-security"

  report=%x[#{command}]

  if (args.verbose)
    puts report
  end
  results = check_test(report,args)
  if results.empty?
    puts 'Docker host audit passed'
    exit 0
  else
    puts 'Docker host audit failed: '+results
    exit 1
  end
end


def parse_args(args)
  options = OpenStruct.new
  options.verbose = false
  options.checks = ""

  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: docker-host-audit.rb [options]"
    opts.on("-c", "--checks LIST",
          "Comma seperated list of checks") do |checks|
          options.checks << checks
    end
    opts.on("-v", "--verbose", "Run verbosely") do |v| options.verbose = v end
  end
  opt_parser.parse!(args)
  options
end


options = parse_args(ARGV)
run(options)
