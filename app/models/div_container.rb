require 'couchrest_model'

# TODO: Move this model to REDIS if appropriate.
class DivContainer < CouchRest::Model::Base
	property :offset_left, String
	property :offset_top,  String
	property :created_at,  String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')

	design do
		view :divs,
			map:
				"function(doc) {
					if(doc['type'] == 'DivContainer' && doc.offset_left && doc.offset_top) {
						emit(doc.offset_left, doc.offset_top);
					}
				}"
	end

	class << self
		def get_and_transform_set id
			pieces = Piece.send :get_all_child_pieces, id
			get_random_wrappers(pieces, get_all_divs).shuffle!
		end

		private

		def get_all_divs
			divs.rows.map do |row|
				row.delete_if {|key, value| key == "id" }
			end
		end	

		def get_random_wrappers pieces, divs
			result_set = []

			pieces.each do
				random_index = rand(divs.size)
				result_set << divs[random_index]
				divs.pop[random_index]
			end

			result_set
		end
	end

	# EXPLAIN: The method creates DivContainer objects  
	#  with predefined pixels' values for offset_left and offset_top fields
	# def self.create_divs
	# 	{
	# 		'1' =>['10', '10'], '2'=>['10','55'],'3'=>['10','115'], '4' =>['10', '175'], '5'=>['10','225'],'6'=>['10','265'],
	# 		 '7'=>['10','325'], '8'=>['10','385'], '9'=>['10','435'],'10'=>['10','495'], '11'=>['10','545'], '12'=>['10','605'],
	# 		'13'=>['70','5'],'14'=>['70','55'], '15'=>['70','115'], '16'=>['70','165'], '17'=>['70','215'], '18'=>['70','265'],
	# 		'19'=>['70','315'], '20'=>['70','375'], '21'=>['70','425'], '22'=>['70','485'], '23'=>['70','535'], '24'=>['70','595'],
	# 		 '25'=>['120','5'], '26'=>['120','55'], '27'=>['130','115'], '28'=>['140','165'], '29'=>['120','215'], '30'=>['120','265'],
	# 		'31'=>['130','315'], '32'=>['140','375'], '33'=>['120','425'], '34'=>['130','485'], '35'=>['120','535'],'36'=>['120','595'],
	# 		'37'=>['190','10'], '38'=>['190','70'],'39'=>['195','130'],'40'=>['190','200'],'41'=>['195','270'],'42'=>['190','340'],
	# 		'43'=>['195','400'],'44'=>['190','450'],'45'=>['190','500'],'46'=>['190','590'],
	# 		'47'=>['240','30'], '48'=>['240','90'],'49'=>['240','140'], '50'=>['240','190'],'51'=>['240','240'],'52'=>['240','290'],
	# 		'53'=>['245','340'],'54'=>['240','390'],'55'=>['240','440'],'56'=>['240','490'],'57'=>['240','590'],
	# 		'58'=>['305','10'],'59'=>['305','55'],'60'=>['305','115'],'61'=>['305','175'],'62'=>['305','225'],'63'=>['305','265'],
	# 		'64'=>['305','325'],'65'=>['305','385'],'66'=>['305','435'],'67'=>['305','495'], '68'=>['305','545'],'69'=>['305','605'],
	# 		'70'=>['365','20'],'71'=>['365','75'],'72'=>['365','135'],'73'=>['365','525'],'74'=>['365','580'],
	# 		'75'=>['440','20'],'76'=>['440','65'],'77'=>['420','115'],'78'=>['440','525'], '79'=>['440','585'],'80'=>['490','20'],'81'=>['495','65'],
	# 		'82'=>['500','115'], '83'=>['540','20'],'84'=>['590','65'],'85'=>['640','115'],'86'=>['580','115'],'87'=>['640','65'],'88'=>['640','20'],
	# 		'89'=>['700','20'], '90'=>['700','65'], '91'=>['700','115'],'92'=>['745','10'],'93'=>['745','55'], '94'=>['745','100'],'95'=>['745','150'],
	# 		'96'=>['800','10'],'97'=>['805','55'],'98'=>['815','100'],'99'=>['820','150'],'100'=>['880','10'],'101'=>['875','55'],'102'=>['870','100'],'103'=>['865','150'],
	# 		'104'=>['940','10'],'105'=>['940','55'],'106'=>['940','115'],'107'=>['940','175'],'108'=>['940','225'],'109'=>['940','265'],'110'=>['940','325'],
	# 		'111'=>['940','385'],'112'=>['940','435'],'113'=>['940','495'],'114'=>['940','545'],'115'=>['940','605'],
	# 		'116'=>['995','10'],'117'=>['995','65'],'118'=>['995','125'],'119'=>['995','185'],'120'=>['995','235'],'121'=>['995','275'],
	# 		'122'=>['995','335'],'123'=>['995','395'],'124'=>['995','445'],'125'=>['995','505'],'126'=>['995','555'],'127'=>['995','615'],
	# 		'128'=>['1045','65'],'129'=>['1045','125'],'130'=>['1045','235'],'131'=>['1045','275'],'132'=>['1045','335'],'133'=>['1045','395'],
	# 		'134'=>['1045','445'],'135'=>['1045','505'],'136'=>['1045','615'],
	# 		'137'=>['1090','65'],'138'=>['1090','125'],'139'=>['1090','235'],'140'=>['1090','275'],'141'=>['1090','335'],
	# 		'142'=>['1090','395'],'143'=>['1090','445'],'144'=>['1090','505'],'145'=>['1090','615'],
	# 		'146'=>['1135','15'],'147'=>['1135','65'],'148'=>['1135','125'],'149'=>['1135','175'],'150'=>['1135','235'],
	# 		'151'=>['1135','290'],'152'=>['1135','335'],'153'=>['1135','395'],'154'=>['1135','445'],'155'=>['1135','505'],
	# 		'156'=>['1135','545'],'157'=>['1135','615'],
	# 		'158'=>['1185','15'],'159'=>['1185','65'],'160'=>['1185','125'],'161'=>['1185','175'],'162'=>['1185','235'],
	# 		'163'=>['1185','290'],'164'=>['1185','335'],'165'=>['1185','395'],'166'=>['1185','445'],'167'=>['1185','505'],
	# 		'168'=>['1185','545'],'169'=>['1185','615'],
	# 		'170'=>['1230','10'],'171'=>['1230','55'],'172'=>['1230','115'],'173'=>['1230','175'],'174'=>['1230','225'],
	# 		'175'=>['1230','265'],'176'=>['1230','325'],'177'=>['1230','385'],'178'=>['1230','435'],'179'=>['1230','495'],
	# 		'180'=>['1230','545'],'181'=>['1230','605']
	# 	}
	# 	 .map do |_,value|
	# 		create!(offset_left: value[0],offset_top: value[1])		
	# 	end
	# end
end
