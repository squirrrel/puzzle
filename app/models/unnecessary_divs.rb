require 'json'

module UnnecessaryDivs
  ['large_group', 'small_group'].each do |method|
    define_method "get_#{method}_list" do
      json = File.read('db/unnecessary_divs.json')
      JSON.parse(json).with_indifferent_access[:"#{method}"]
    end
  end
end