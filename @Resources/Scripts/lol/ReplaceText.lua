function replacetext()
  text = SKIN:GetMeasure('MeasureHour'):GetStringValue()
  font = SELF:GetOption('Font')
  size = SELF:GetOption('Size')
  file = io.open(SKIN:MakePathAbsolute(SELF:GetOption("SVGfile")), "w")
  template={"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>","<svg","xmlns:dc=\"http://purl.org/dc/elements/1.1/\"","xmlns:cc=\"http://creativecommons.org/ns#\"","xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"","xmlns:svg=\"http://www.w3.org/2000/svg\"","xmlns=\"http://www.w3.org/2000/svg\"","version=\"1.1\"","width=\"440.29297\"","height=\"39.824219\"","id=\"svg2\">","<defs","id=\"defs4\" />","<metadata","id=\"metadata7\">","<rdf:RDF>","<cc:Work","rdf:about=\"\">","<dc:format>image/svg+xml</dc:format>","<dc:type","rdf:resource=\"http://purl.org/dc/dcmitype/StillImage\" />","<dc:title></dc:title>","</cc:Work>","</rdf:RDF>","</metadata>","<text","x=\"0\"","y=\"0\"","id=\"maintext\"","xml:space=\"preserve\"","style=\"font-size:"..size.."px;font-style:normal;font-weight:normal;line-height:125%;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;font-family:"..font.."\"><tspan","x=\"0\"","y=\"0\"","id=\"tspan3006\"","style=\"fill:#000000\">"..text.."</tspan></text>","</svg>"}
  file:write(table.concat(template, "\n"))
  file:close()
  
  SKIN:Bang('[!Commandmeasure ScriptVectorConverter "ClearAllShapePath()"][!CommandMeasure Inkscape "Run"]')

end