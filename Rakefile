
task :default => :sandbox

task :sandbox => :vendor do
  system "qmlscene ./sandbox.qml"
end

task :vendor do
  vendor_dir = File.join(File.dirname(__FILE__), 'qml/vendor')
  vendor_source = "https://raw.github.com/zefhemel/persistencejs/master/lib/"
  vendor_gets = [
    "persistence.js",
    "persistence.store.sql.js",
    "persistence.store.websql.js",
  ]
  
  Dir.mkdir vendor_dir unless Dir.exists? vendor_dir
  vendor_gets.each { |f|
    system "cd #{vendor_dir} && wget #{vendor_source + f}" \
      unless File.exists? File.join(vendor_dir, f)
  }
end
