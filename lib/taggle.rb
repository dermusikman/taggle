# Licensed under GPLv3
require 'mixlib/cli'
require 'time'

class Taggle
  include Mixlib::CLI
  # I figure it's really unlikely to accidentally encounter an emoji
  FS = "✋"

  option :report,
    :short => "-r",
    :long => "--report",
    :default => false,
    :boolean => true,
    :description => "Print a time report"

  option :log_file,
    :short => "-o FILE",
    :long => "--output FILE",
    :default => "#{ENV['HOME']}/.taggle",
    :description => "File to which time should be written (default: ~/.taggle"

  option :help,
    :short => "-h",
    :long => "--help",
    :default => false,
    :description => "Show this help message",
    :show_options => true,
    :exit => true

  def clock_in(msg, file)
    abort "ERROR: Message required" if msg.empty?
    now = Time.now
    File.open(file, File::CREAT|File::WRONLY|File::APPEND) do |f|
      f.write(now.to_s + FS + msg + "\n")
    end
  end

  def report(file)
    time_hash = {}
    times = File.read(file).split("\n")
    abort "#{file} is empty" if times.empty?
    times << Time.now.to_s + "✋ENDING"
    times.each_cons(2) do |t|
      # t = ["<timestamp0>FS<msg0>","<timestamp1>FS<msg1>"]
      msg = t[0].split(FS)[1]
      t_newer = Time.parse(t[1].split(FS)[0])
      t_older = Time.parse(t[0].split(FS)[0])
      t_delta = t_newer - t_older
      if time_hash[msg].is_a? Numeric
        time_hash[msg] += t_delta
      else
        time_hash[msg] = t_delta
      end
    end
    time_hash.each do |msg,dur|
      begin
        puts readable_time(dur) + " " + msg
      rescue
        abort "#{file} is malformed"
      end
    end
  end

  private
  def readable_time(sec)
    sec_i = sec.to_i
    time = ""
    # Get hours
    if sec_i >= 3600
      hh = sec_i / 3600
      time += hh.to_s.rjust(2,'0') + "h"
      sec_i = sec_i % 3600
    else
      time += "00h"
    end
    # Get minutes
    if sec_i >= 60
      mm = sec_i / 60
      time += mm.to_s.rjust(2,'0') + "m"
      sec_i = sec_i % 60
    else
      time += "00m"
    end
    # Get seconds
    time += sec_i.to_s.rjust(2,'0') + "s"
  end
end
