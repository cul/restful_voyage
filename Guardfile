# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  watch(%r{^test/(.*)test_(.*).rb})
  watch(%r{^lib/((?:(?:[^/]+)/)*)([^/]+)\.rb}) { "test" }
  watch(%r{^test/helper(.*).rb})  { "test" }
end

