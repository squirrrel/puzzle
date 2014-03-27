# TODO: refactor at a later time
require 'json'

module CouchSeeds
  def self.extended(klass)
    klass.extend(eval("#{klass}slave"))
  end

  CouchSeeds.class_exec do
    ['DivContainerslave', 'Imagenslave', 'Pieceslave'].each do |module_name|
      module_body = Module.new do
        define_method "#{module_name.downcase}_list" do
          json = File.read("db/#{module_name.downcase}_seeds.json")
          JSON.parse(json).with_indifferent_access["#{module_name.downcase}"]
        end
      end

      CouchSeeds.const_set(:"#{module_name}", module_body)
    end
  end
end
