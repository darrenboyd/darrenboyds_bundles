#!/usr/bin/env ruby


# adding some cool magic I learned from merb :D
class String
  def /(other)
    File.join(self, other)
  end
end

bundles = {
  'ruby-on-rails' => {:type => :git, :url => 'git://github.com/drnic/ruby-on-rails-tmbundle.git'},
  'ack'           => {:type => :git, :url => 'git://github.com/protocool/ack-tmbundle.git'},
  'git'           => {:type => :git, :url => 'git://github.com/timcharper/git-tmbundle.git'},
  'rspec'         => {:type => :git, :url => 'git://github.com/dchelimsky/rspec-tmbundle.git'},
  'ruby-shoulda'  => {:type => :git, :url => 'git://github.com/drnic/ruby-shoulda-tmbundle.git'},
  # 'merb'          => {:type => :git, :url => 'git://github.com/drnic/merb-tmbundle.git'},
  'Ruby'          => {:type => :git, :url => 'git://github.com/drnic/ruby-tmbundle.git'},
  # 'Ruby'          => {:type => :svn, :url => 'http://svn.textmate.org/trunk/Bundles/Ruby.tmbundle'},
  'Ruby Haml'     => {:type => :git, :url => 'git://github.com/douglasjarquin/ruby-haml-tmbundle.git'},
  # 'GraphViz'      => {:type => :svn, :url => 'http://svn.textmate.org/trunk/Bundles/Graphviz.tmbundle'},
}


base_dir = ENV['HOME'] / "Library/Application Support/TextMate"

unless File.exist?(base_dir)
  puts "There is no TextMate directory: #{base_dir}"
  exit(1)
end

def update_svn(dir, url)
  if File.exist?(dir) && File.exist?(dir / '.svn')
    puts `cd "#{dir}" && svn up`
    true
  elsif !File.exist?(dir)
    puts `svn co "#{url}" "#{dir}"`
    true
  else
    nil
  end
end

def update_git(dir, url)
  if File.exist?(dir) && File.exist?(dir / '.git')
    puts `cd "#{dir}" && git pull`
    true
  elsif !File.exist?(dir)
    puts `git clone "#{url}" "#{dir}"`
    true
  else
    nil
  end
end

puts "Updating the Support folder."
unless update_svn(base_dir / 'Support', 'http://svn.textmate.org/trunk/Support')
  puts "You seem to have a Support directory not under Subversion source control."
  puts "Sorry, I can't deal with that."
end

require 'fileutils'
FileUtils.mkdir_p(base_dir/'Bundles')

bundles.each do |name, bundle|
  puts ""
  puts "Updating Bundle: #{name}"
  case bundle[:type]
  when :git, :svn
    unless send("update_#{bundle[:type]}", base_dir/'Bundles'/"#{name}.tmbundle", bundle[:url])
      puts "You seem to have a Bundle called #{name} already, but not under source control (#{bundle[:type]}).  Skipping."
    end
  else
    "Error with bundle #{name}, unkown type."
  end
end